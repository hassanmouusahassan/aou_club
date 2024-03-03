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
  File? _selectedImage;
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _selectedImage = File(pickedFile.path));
    }
  }

  Future<String> _uploadImage(File image) async {
    setState(() => _isLoading = true);
    var uri = Uri.parse("https://api.imgbb.com/1/upload");
    var request = http.MultipartRequest("POST", uri)
      ..fields['key'] = '5732129137e8541dd24d87d509239fff'  // Replace with your ImgBB API key
      ..files.add(await http.MultipartFile.fromPath('image', image.path));
    var response = await request.send();

    if (response.statusCode == 200) {
      String responseData = await response.stream.bytesToString();
      var decoded = json.decode(responseData);
      setState(() => _isLoading = false);
      return decoded['data']['url'];
    } else {
      setState(() => _isLoading = false);
      throw Exception('Failed to upload image');
    }
  }

  Future<void> _submitClub() async {
    if (!_formKey.currentState!.validate() || _selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please complete the form and select an image.')));
      return;
    }

    try {
      final imageUrl = await _uploadImage(_selectedImage!);
      final DatabaseReference dbRef = FirebaseDatabase.instance.ref('clubs').child(_nameController.text.trim());
      await dbRef.set({
        'name': _nameController.text.trim(),
        'admin': _adminController.text.trim(),
        'description': _descriptionController.text.trim(),
        'imageUrl': imageUrl,
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Club added successfully!')));
      _resetForm();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error submitting club: $error')));
      _resetForm();
    }
  }

  void _resetForm() {
    _nameController.clear();
    _adminController.clear();
    _descriptionController.clear();
    _selectedImage = null;
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Page'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              if (_isLoading) const LinearProgressIndicator(),
              GestureDetector(
                onTap: _pickImage,
                child: _selectedImage != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(_selectedImage!, fit: BoxFit.cover, height: 200),
                )
                    : Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.camera_alt, color: Colors.grey[800], size: 50),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Club Name', border: OutlineInputBorder()),
                validator: (value) => value == null || value.isEmpty ? 'Please enter the club name' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _adminController,
                decoration: const InputDecoration(labelText: 'Admin', border: OutlineInputBorder()),
                validator: (value) => value == null || value.isEmpty ? 'Please enter the admin name' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
                validator: (value) => value == null || value.isEmpty ? 'Please enter a description' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _submitClub,
                child: const Text('Submit Club'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.deepPurple,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
