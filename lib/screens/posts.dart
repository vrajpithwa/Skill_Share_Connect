import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ssc/components/likeButton.dart';
import 'package:ssc/utils/color_utils.dart';

class Posts extends StatefulWidget {
  final String user;
  final String message;
  final String postId;
  final List<String> likes;
  const Posts({
    Key? key,
    required this.message,
    required this.user,
    required this.postId,
    required this.likes,
  }) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: hexStringToColor("a8dadc"),
        border: Border.all(color: Colors.black),
        borderRadius: const BorderRadius.all(
          Radius.circular(5.0),
        ), // Adjust the border radius as needed
      ),
      margin: const EdgeInsets.only(top: 5, left: 5, right: 5),
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          // Profile Pic
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[400],
            ),
            padding: EdgeInsets.all(10),
            child: const Icon(
              Icons.person,
              color: Colors.white,
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
              ],
            ),
          ),
          // Like button
          Column(
            children: [
              LikeButton(isLiked: isLiked, onTap: toggleLike),
              Text(widget.likes.length.toString()),
            ],
          ),
        ],
      ),
    );
  }
}
