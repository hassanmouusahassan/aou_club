import 'package:flutter/material.dart';
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

  void _submitClub() {
    if (_formKey.currentState!.validate()) {
      // Sanitize the club name to create a valid Firebase key
      final String clubKey = _nameController.text.trim().replaceAll(' ', '_').toLowerCase();

      final DatabaseReference dbRef = FirebaseDatabase.instance.ref('clubs/$clubKey');
      final newClub = {
        'name': _nameController.text.trim(),
        'admin': _adminController.text.trim(),
        'description': _descriptionController.text.trim(),
        'imageUrl': _imageUrlController.text.trim(),
      };

      dbRef.set(newClub).then((_) {
        // Display a success message
        final snackBar = SnackBar(content: Text('Club added successfully!'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.of(context).pop(); // Go back to the previous screen
      }).catchError((error) {
        // Handle errors here
        final snackBar = SnackBar(content: Text('Error submitting club: $error'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Page'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Club Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the club name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _adminController,
                decoration: const InputDecoration(labelText: 'Admin'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the admin name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(labelText: 'Image URL'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the image URL';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: _submitClub,
                child: const Text('Submit Club'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
