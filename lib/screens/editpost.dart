import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditPostScreen extends StatefulWidget {
  final Map<String, dynamic> postData;

  const EditPostScreen({Key? key, required this.postData}) : super(key: key);

  @override
  _EditPostScreenState createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  late String postId;
  late String initialMessage;
  late String initialImageUrl;

  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    postId = widget.postData['postId'];
    initialMessage = widget.postData['initialMessage'];
    initialImageUrl = widget.postData['initialImageUrl'];
    print("Initial Image URL: $initialImageUrl");
  }

  void pickImage() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);

    if (initialImageUrl.isNotEmpty) {
      String uniqFileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference referenceImageToUpload =
          FirebaseStorage.instance.refFromURL(initialImageUrl);

      try {
        // Storing the file
        await referenceImageToUpload.putFile(File(file!.path));
        // Success, get the download URL
        initialImageUrl = await referenceImageToUpload.getDownloadURL();
      } catch (error) {
        // Handle the error
        print("Error uploading image: $error");
      }

      if (file != null) {
        if (mounted) {
          setState(() {
            // Update initialImageUrl only if the upload was successful
            if (initialImageUrl.isNotEmpty) {
              // Update the state with the new initialImageUrl
              initialImageUrl = initialImageUrl;
            }
          });
        }
      }
    } else {
      // Handle the case where initialImageUrl is empty
      print("Initial URL is empty. Uploading without URL.");

      if (file != null) {
        try {
          String uniqFileName =
              DateTime.now().millisecondsSinceEpoch.toString();

          Reference referenceImageToUpload =
              FirebaseStorage.instance.ref().child(uniqFileName);
          await referenceImageToUpload.putFile(File(file.path));
          initialImageUrl = await referenceImageToUpload.getDownloadURL();

          if (mounted) {
            setState(() {
              // Update the state with the new initialImageUrl
              initialImageUrl = initialImageUrl;
            });
          }
        } catch (error) {
          print("Error uploading image: $error");
          // Handle the error as needed
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: textController,
              onChanged: (value) {
                setState(() {
                  initialMessage = value;
                });
              },
              decoration: InputDecoration(labelText: 'Edit Message'),
            ),
            SizedBox(height: 16.0),
            initialImageUrl.isNotEmpty
                ? initialImageUrl.startsWith('http')
                    ? Image.network(
                        initialImageUrl,
                        fit: BoxFit.cover,
                        height: 500,
                      )
                    : Image.file(
                        File(initialImageUrl), // Assume it's a local file path
                        fit: BoxFit.cover,
                        height: 500,
                      )
                : Container(),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: pickImage,
              child: Text(
                'Pick Image',
                style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                // Get the updated message
                String updatedMessage = textController.text;

                // Check if the image URL has changed

                // Update the Firestore document
                try {
                  if (mounted) {
                    setState(() {
                      FirebaseFirestore.instance
                          .collection('User Posts')
                          .doc(postId)
                          .update({
                        'Message': updatedMessage,
                        'image': initialImageUrl,
                      });
                    });
                  }

                  // Navigate back to the previous screen
                  Navigator.pop(context);
                } catch (error) {
                  // Handle the error
                  print("Error updating post: $error");
                }
              },
              child: Text('Save Changes',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.tertiary)),
            ),
          ],
        ),
      ),
    );
  }
}
