import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:ssc/components/likeButton.dart';
import 'package:ssc/screens/editpost.dart';
import 'package:ssc/utils/color_utils.dart';
import 'package:intl/intl.dart';

class Posts extends StatefulWidget {
  final String user;
  final String message;
  final String postId;
  final List<String> likes;
  final String imageUrl;
  final Timestamp postTime;
  final String category;

  const Posts({
    super.key,
    required this.message,
    required this.imageUrl,
    required this.user,
    required this.postId,
    required this.postTime,
    required this.likes,
    required this.category,
  });

  @override
  State<Posts> createState() => _PostsState();
}

class _PostsState extends State<Posts> {
// getting user info from the firebase
  final currentuser = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentuser.email);
  }

//toggeling like unlike button

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });

    //getting this doc in firebase
    DocumentReference postRef =
        FirebaseFirestore.instance.collection('User Posts').doc(widget.postId);
    //if the post is liked then add user email else remove if liked

    if (isLiked) {
      postRef.update({
        'Likes': FieldValue.arrayUnion([currentuser.email])
      });
    } else {
      postRef.update({
        'Likes': FieldValue.arrayRemove([currentuser.email])
      });
    }
  }

  void showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Delete"),
          content: Text("Are you sure you want to delete this post?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text(
                "Cancel",
                style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
              ),
            ),
            TextButton(
              onPressed: () {
                deletePost();
                Navigator.pop(context); // Close the dialog
              },
              child: Text("Delete",
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.tertiary)),
            ),
          ],
        );
      },
    );
  }

  void deletePost() async {
    try {
      // Delete the post document from Firestore
      await FirebaseFirestore.instance
          .collection('User Posts')
          .doc(widget.postId)
          .delete();

      // Check if the post has an associated image
      if (widget.imageUrl.isNotEmpty) {
        // Extract the image filename from the URL
        String imageName = widget.imageUrl.split('/').last;

        // Create a reference to the image in Firebase Storage
        Reference referenceRoot = FirebaseStorage.instance.ref();
        Reference referenceDirImages = referenceRoot.child('images');
        Reference referenceImageToDelete = referenceDirImages.child(imageName);

        // Delete the image from Firebase Storage
        await referenceImageToDelete.delete();
      }

      // Optionally, you may want to add additional cleanup or error handling
    } catch (error) {
      print("Error deleting post: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context)
                      .colorScheme
                      .secondary
                      .withOpacity(0.5), // Change the shadow color as needed
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset:
                      const Offset(0, 2), // Adjust the position of the shadow
                ),
              ],
              color: Theme.of(context).colorScheme.primary,
              border: Border.all(color: const Color.fromARGB(28, 0, 0, 0)),
              borderRadius: const BorderRadius.all(
                Radius.circular(5.0),
              ), // Adjust the border radius as needed
            ),
            margin: const EdgeInsets.only(top: 5, left: 5, right: 5),
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  children: [
                    // Profile Pic
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      padding: const EdgeInsets.all(10),
                      child: const Icon(
                        Icons.person,
                        color: Color.fromARGB(255, 122, 122, 122),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    // Post Content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.user,
                            style: TextStyle(color: Colors.grey[500]),
                          ),
                          Text(widget.message),
                          Text(
                            "#" + widget.category,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary),
                          ),
                          // Text(widget.postTime.toString()),
                        ],
                      ),
                    ),
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'edit') {
                          Map<String, dynamic> postData = {
                            'postId': widget.postId,
                            'initialMessage': widget.message,
                            'initialImageUrl': widget.imageUrl,
                          };

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EditPostScreen(postData: postData),
                            ),
                          );
                        } else if (value == 'delete') {
                          showDeleteConfirmationDialog();
                        }
                      },

                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<String>>[
                        const PopupMenuItem<String>(
                          value: 'edit',
                          child: Text('Edit'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'delete',
                          child: Text('Delete'),
                        ),
                        // Add more menu items as needed
                      ],
                      icon: const Icon(Icons.more_vert),
                      // Three dots icon
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  child: widget.imageUrl.isNotEmpty
                      ? Image.network(
                          widget.imageUrl,
                          fit: BoxFit.cover,
                          height: 500, // Adjust the height as needed
                        )
                      : Container(
                          height: 0,
                          width: 0,
                        ), // You can replace Placeholder() with any widget you want to show when imageUrl is empty
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    LikeButton(isLiked: isLiked, onTap: toggleLike),
                    Text(widget.likes.length.toString() + " Likes"),
                    // showing time
                    Spacer(),
                    Text(
                      DateFormat('dd-MMM hh:mm a')
                          .format(widget.postTime.toDate()),
                      style: TextStyle(color: Colors.grey[500]),
                    ),
                  ],
                ),
              ],
            )));
  }
}
