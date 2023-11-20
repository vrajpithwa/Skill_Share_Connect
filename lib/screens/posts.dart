import 'package:flutter/material.dart';

class Posts extends StatelessWidget {
  final String user;
  // final String time;
  final String message;
  const Posts({
  super.key,
  required this.message,
  required this.user,
  // required this.time,
  });
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            Text(user),
            Text(message),  
          ],
        )
      ],
    );
  }
}
