import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ssc/screens/posts.dart';
import 'package:ssc/screens/signin_screen.dart';
import 'package:ssc/utils/color_utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final currentuser = FirebaseAuth.instance.currentUser!;

  final textController = TextEditingController();

  void postMessage() {
    if (textController.text.isNotEmpty) {
      FirebaseFirestore.instance.collection("User Posts").add({
        'UserEmail': currentuser.email,
        'Message': textController.text,
        'Likes': [],
        'TimeStamp': Timestamp.now(),
      });
    }

    setState(() {
      textController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SkillShareConnect',
          style: TextStyle(
            fontFamily: 'amazon',
            fontSize: 27.0,
          ),
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Handle notifications
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // Handle user profile
            },
          ),
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  child: const Text('Settings'),
                  onTap: () {
                    // Handle settings
                  },
                ),
              ];
            },
          ),
        ],
      ),
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
                  onPressed: (b) {
                    for (var category in categoryList) {
                      category.isSelected = false;
                    }
                    setState(() {
                      categoryList[index].isSelected = true;
                    });
                  },
                );
              },
            ),
          ),
          ElevatedButton(
            child: const Text("Logout"),
            onPressed: () {
              FirebaseAuth.instance.signOut().then((value) {
                print("Signed Out");
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SignInScreen()));
              });
            },
          ),
          Text("logged in as: ${currentuser.email!}"),
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
                              icon: const Icon(Icons.open_in_new),
                              onPressed: () {
                                // Handle the button press
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
                    color: Colors
                        .white, // Set the icon color to contrast with the background
                    onPressed: postMessage,
                  ),
                ),
              ],
            ),
          )
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
  final Function(bool) onPressed;

  const CategoryCard(
      {required this.category, required this.onPressed, Key? key})
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
          color:
              widget.category.isSelected ? Colors.white : Colors.transparent),
      child: TextButton(
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.all(Colors.transparent),
        ),
        onPressed: () {
          widget.onPressed(true);
        },
        child: Text(
          widget.category.title,
          style: TextStyle(
            color: widget.category.isSelected ? Colors.black : Colors.grey,
          ),
        ),
      ),
    );
  }
}


//*****************************************   End of category view   **********************************************