import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_database/firebase_database.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _adminController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _selectedImage = File(pickedFile.path);
    }
  }

  Future<void> _uploadImage() async {
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No image selected')));
      return;
    }
    setState(() => _isLoading = true);
    String url = "https://api.imgbb.com/1/upload?key=5732129137e8541dd24d87d509239fff"; // Replace YOUR_API_KEY with your actual ImgBB API key
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath('image', _selectedImage!.path));
    var response = await request.send();

    if (response.statusCode == 200) {
      String res = await response.stream.bytesToString();
      var jsonResponse = jsonDecode(res);
      _imageUrlController.text = jsonResponse['data']['display_url'];
      _submitClub();
    } else {
      print('Failed to upload image.');
      setState(() => _isLoading = false);
    }
  }

  void _submitClub() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill all fields')));
      setState(() => _isLoading = false);
      return;
    }

    final String clubName = _nameController.text.trim();
    final String adminName = _adminController.text.trim();
    final String description = _descriptionController.text.trim();
    final String imageUrl = _imageUrlController.text.trim();

    try {
      final String clubKey = clubName.replaceAll(' ', '_').toLowerCase();
      DatabaseReference dbRef = FirebaseDatabase.instance.ref('clubs/$clubKey');
      await dbRef.set({
        'name': clubName,
        'admin': adminName,
        'description': description,
        'imageUrl': imageUrl,
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Club added successfully!')));
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error submitting club: $error')));
    } finally {
      _nameController.clear();
      _adminController.clear();
      _descriptionController.clear();
      _imageUrlController.clear();
      _selectedImage = null;
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Page'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              if (_isLoading) CircularProgressIndicator(),
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Pick Image'),
              ),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Club Name'),
                validator: (value) => value == null || value.isEmpty ? 'Please enter the club name' : null,
              ),
              TextFormField(
                controller: _adminController,
                decoration: const InputDecoration(labelText: 'Admin'),
                validator: (value) => value == null || value.isEmpty ? 'Please enter the admin name' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) => value == null || value.isEmpty ? 'Please enter a description' : null,
              ),
              ElevatedButton(
                onPressed: _uploadImage, // Initiates the image upload and club submission process
                child: const Text('Submit '),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
