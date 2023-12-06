import 'package:flutter/material.dart';

class MyTextBox extends StatelessWidget {
  final String text;
  final String sectionName;
  final void Function()? onPressed;

  const MyTextBox({
    super.key,
    required this.text,
    required this.sectionName,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(8)),
      margin: const EdgeInsets.only(left: 15.0, right: 15, top: 15),
      padding: const EdgeInsets.only(left: 15, bottom: 15),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              sectionName,
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
            IconButton(
              onPressed: onPressed,
              icon: Icon(
                Icons.edit,
                color: Colors.grey[800],
              ),
            )
          ],
        ),
        Text(text),
      ]),
    );
  }
}
