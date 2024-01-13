import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  final String userName;
  final String userImage;
  final Function(String, String) onUpdate;

  const ProfilePage({Key? key, required this.userName, required this.userImage, required this.onUpdate}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late String currentName;
  late String currentImage;
  final TextEditingController _nameController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    currentName = widget.userName;
    currentImage = widget.userImage;
    _nameController.text = currentName;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void showImageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: currentImage.isNotEmpty ? Image.file(
            File(currentImage),
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.width * 0.8,
            fit: BoxFit.contain,
          ) : const Text("No image selected."),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickImage() async {
    try {
      final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        setState(() {
          currentImage = pickedImage.path;
        });
      }
    } catch (e) {
      // ignore: avoid_print
      print("Image picker error: $e");
      // Handle error or notify user
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: showImageDialog,
              child: CircleAvatar(
                backgroundImage: currentImage.isNotEmpty ? FileImage(File(currentImage)) : null,
                radius: 60,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Change Image'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
                hintText: 'Enter your name',
              ),
              onChanged: (value) {
                currentName = value;
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                widget.onUpdate(currentName, currentImage);
                Navigator.pop(context);
              },
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
