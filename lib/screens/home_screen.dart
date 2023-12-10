  import 'dart:async';
  import 'dart:convert';
  import 'dart:io';
  import 'package:http/http.dart' as http;
  import 'package:cloud_firestore/cloud_firestore.dart';
  import 'package:firebase_auth/firebase_auth.dart';
  import 'package:firebase_storage/firebase_storage.dart';
  import 'package:flutter/material.dart';
  import 'package:image_picker/image_picker.dart';
  import 'package:ssc/components/drawer.dart';
  import 'package:ssc/screens/Quote.dart';
  import 'package:ssc/screens/posts.dart';
  import 'package:ssc/screens/profile.dart';
  import 'package:ssc/screens/signin_screen.dart';
import 'package:ssc/screens/upi_payment.dart';
  import 'package:ssc/utils/color_utils.dart';

  class HomeScreen extends StatefulWidget {
    const HomeScreen({Key? key}) : super(key: key);

    @override
    _HomeScreenState createState() => _HomeScreenState();
  }

  class _HomeScreenState extends State<HomeScreen> {
    final currentuser = FirebaseAuth.instance.currentUser!;
    String imageUrl = '';
    final textController = TextEditingController();
    

    @override
    void initState() {
      super.initState();
      // Add this line to fetch and display a quote when the home screen is loaded
      Timer(Duration(milliseconds: 500), () => fetchAndShowQuote());
    }

    Future<void> selectCategoryAndPost() async {
    Category? selectedCategory = await showDialog<Category>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Category'),
          content: Column(
            children: categoryList.map((category) {
              return ListTile(
                title: Text(category.title),
                onTap: () {
                  Navigator.pop(context, category);
                },
              );
            }).toList(),
          ),
        );
      },
    );

    if (selectedCategory != null) {
      postMessage(selectedCategory);
    }
  }


    Future<void> fetchAndShowQuote() async {
      try {
        final response =
            await http.get(Uri.parse('https://zenquotes.io/api/random/'));
        if (response.statusCode == 200) {
          final quoteData = json.decode(response.body);
          final quote = Quote(
            text: quoteData[0]['q'],
            author: quoteData[0]['a'],
          );

          // Show the quote in the dialog
          showQuoteDialog(context, quote.text, quote.author);
        } else {
          throw Exception('Failed to load quote');
        }
      } catch (e) {
        print('Error fetching quote: $e');
      }
    }

    void showQuoteDialog(BuildContext context, String text, String author) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  AlertDialog(
                    title: Text(text),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "~ $author",
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 10),
                        Text(
                          '"Fuel your day with inspiration! 🌟 Read the Quote of the Day on Skill Share Connect and let motivation drive your success."',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Skip',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.tertiary),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

  void postMessage(Category selectedCategory) {
    if (textController.text.isNotEmpty) {
      FirebaseFirestore.instance.collection("User Posts").add({
        'UserEmail': currentuser.email ?? '',
        'Message': textController.text ?? '',
        'Likes': [] ?? '',
        'image': imageUrl ?? '',
        'TimeStamp': Timestamp.now(),
        'Category': selectedCategory.title, // Add category to the post
      });
    }

    print(imageUrl);
    setState(() {
      textController.clear();
    });
  }


    void goToprofile() {
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfilePage(),
        ),
      );
    }


  void goToPayment(){
     Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UpiPaymentScreen()),
                );
  }
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          title: const Text(
            'SkillShareConnect',
            style: TextStyle(
              fontFamily: 'amazon',
              fontSize: 27.0,
            ),
          ),
          // automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.messenger_rounded),
              onPressed: () {
                // Handle notifications
              },
            ),
          ],
        ),
        drawer: MyDrawer(
          onLogout: () {
            FirebaseAuth.instance.signOut().then((value) {
              print("Signed Out");
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const SignInScreen()));
            });
          },
          onProfile: goToprofile,
          onPayment: goToPayment,),
                
        body: Center(
            child: Column(
          children: [
            SizedBox(
              height: 45,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categoryList.length,
                itemBuilder: (context, index) {
                  return CategoryCard(
  category: categoryList[index],
  onPressed: (selectedCategory) {
    for (var category in categoryList) {
      category.isSelected = false;
    }
    setState(() {
      selectedCategory.isSelected = true;
    });
  },
);

                },
              ),
            ),
            Expanded(
                child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("User Posts")
                  .orderBy(
                    "TimeStamp",
                    descending: false,
                  )
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        // getting messages from firebase
                        final post = snapshot.data!.docs[index];
                        return Posts(
                            message: post['Message'],
                            user: post['UserEmail'],
                            postId: post.id,
                            category: post['Category'],
                            imageUrl: post['image'],
                            postTime: post['TimeStamp'],
                            likes: List<String>.from(post['Likes'] ?? []));
                      });
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error:${snapshot.error}'),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(
                          16.0), // Adjust the padding as needed
                      child: Expanded(
                        child: TextField(
                          controller: textController,
                          maxLines: null,
                          decoration: InputDecoration(
                            hintText: "Write text",
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(
                                  20.0)), // Adjust the border radius as needed
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 0, 0,
                                      0)), // Adjust the border color as needed
                            ),
                            suffixIcon: Padding(
                              padding: const EdgeInsets.only(
                                  right:
                                      5.0), // Adjust the left padding as needed
                              child: IconButton(
                                icon: const Icon(Icons.camera_alt),
                                onPressed: () async {
                                  ImagePicker imagePicker = ImagePicker();
                                  XFile? file = await imagePicker.pickImage(
                                      source: ImageSource.gallery);

                                  String uniqFileName = DateTime.now()
                                      .millisecondsSinceEpoch
                                      .toString();
                                  Reference referenceRoot =
                                      FirebaseStorage.instance.ref();
                                  Reference referenceDirImages =
                                      referenceRoot.child('images');

                                  Reference referenceImageToUpload =
                                      referenceDirImages.child(uniqFileName);

                                  try {
                                    //storing the file
                                    await referenceImageToUpload
                                        .putFile(File(file!.path));
                                    //success get the download url
                                    imageUrl = await referenceImageToUpload
                                        .getDownloadURL();
                                    print(imageUrl);
                                  } catch (error) {
                                    print(error);
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: hexStringToColor(
                          "22223b"), // Set your desired background color
                      borderRadius: BorderRadius.circular(
                          100.0), // Adjust the border radius as needed
                    ),
                    child: IconButton(
    icon: Icon(Icons.send_sharp),
    color: Colors.white,
    onPressed: selectCategoryAndPost,
  ),

                  ),
                ],
              ),
            ),
          ],
        )),
      );
    }
  }

  //*********************************************   Category view  *****************************************

  class Category {
    final String title;
    bool isSelected;
    Category(this.title, this.isSelected);
  }

  List<Category> categoryList = [
    Category("Trending", true),
    Category("Digital Arts", false),
    Category("3D Videos", false),
    Category("Game", false),
    Category("Console", false),
  ];

  class CategoryCard extends StatefulWidget {
  final Category category;
  final Function(Category) onPressed;

  const CategoryCard({required this.category, required this.onPressed, Key? key})
      : super(key: key);

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: widget.category.isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.transparent),
      child: TextButton(
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.all(Colors.transparent),
        ),
        onPressed: () {
          setState(() {
            widget.category.isSelected = !widget.category.isSelected;
          });
          widget.onPressed(widget.category);
        },
        child: Text(
          widget.category.title,
          style: TextStyle(
            color: widget.category.isSelected
                ? Theme.of(context).colorScheme.tertiary
                : Theme.of(context).colorScheme.secondary,
          ),
        ),
      ),
    );
  }
}


  //*****************************************   End of category view   **********************************************
