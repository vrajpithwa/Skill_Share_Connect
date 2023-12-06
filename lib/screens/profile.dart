import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ssc/components/text_box.dart';
import 'package:ssc/screens/posts.dart';
import 'package:ssc/utils/color_utils.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final currentuser = FirebaseAuth.instance.currentUser!;
  final userCollection = FirebaseFirestore.instance.collection("Users");
  final postCollection = FirebaseFirestore.instance.collection("User Posts");
  final textController = TextEditingController();

  Future<void> editfield(String field) async {
    String newValue = "";
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Edit $field",
          style: const TextStyle(color: Colors.grey),
        ),
        content: TextField(
          autofocus: true,
          decoration: InputDecoration(
            hintText: "Enter new $field",
            hintStyle: TextStyle(color: Colors.grey),
          ),
          onChanged: (value) {
            newValue = value;
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop(newValue);
              if (newValue.trim().length > 0) {
                await userCollection
                    .doc(currentuser.email)
                    .update({field: newValue});
              }
            },
            child: Text('Save'),
          )
        ],
      ),
    );
  }

  void postMessage() {
    if (textController.text.isNotEmpty) {
      postCollection.add({
        'UserEmail': currentuser.email ?? '',
        'Message': textController.text ?? '',
        'Likes': [] ?? '',
        'image': '', // Assuming imageUrl is not used here
        'TimeStamp': Timestamp.now(),
      });
      setState(() {
        textController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile Page"),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: userCollection.doc(currentuser.email).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userData = snapshot.data!.data() as Map<String, dynamic>;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 50,
                ),
                Icon(
                  Icons.person,
                  size: 50,
                ),
                Text(
                  currentuser.email!,
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text("Details"),
                ),
                MyTextBox(
                  text: userData['username'],
                  sectionName: "Username",
                  onPressed: () => editfield("username"),
                ),
                MyTextBox(
                  text: userData['bio'],
                  sectionName: "Bio",
                  onPressed: () => editfield("bio"),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Your Posts"),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: postCollection
                          .where('UserEmail', isEqualTo: currentuser.email)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<DocumentSnapshot> posts = snapshot.data!.docs;
                          if (posts.isEmpty) {
                            return Center(
                              child: Text('You have no posts yet.'),
                            );
                          } else {
                            return Column(
                              children: posts
                                  .map((post) => Posts(
                                        message: post['Message'],
                                        user: post['UserEmail'],
                                        postId: post.id,
                                        imageUrl: post['image'],
                                        postTime: post['TimeStamp'],
                                        likes: List<String>.from(
                                            post['Likes'] ?? []),
                                      ))
                                  .toList(),
                            );
                          }
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        }
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: postMessage,
                  child: Text('Post Message'),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
