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
  bool _isAddView = true;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _adminController = TextEditingController();
  final _descriptionController = TextEditingController();
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref('clubs');
  List<Map<String, dynamic>> _clubs = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchClubs();
  }

  Future<void> _fetchClubs() async {
    _dbRef.onValue.listen((event) {
      final data = Map<String, dynamic>.from(event.snapshot.value as Map<dynamic, dynamic>? ?? {});
      setState(() {
        _clubs = data.entries.map<Map<String, dynamic>>((e) =>
        {"key": e.key, ...Map<String, dynamic>.from(e.value)}
        ).toList();

      });
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<String> _uploadImage(File image) async {
    const String apiKey = '5732129137e8541dd24d87d509239fff';
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('https://api.imgbb.com/1/upload?key=$apiKey'),
    )..files.add(await http.MultipartFile.fromPath('image', image.path));

    final response = await request.send();
    final respStr = await response.stream.bytesToString();
    if (response.statusCode == 200) {
      final result = jsonDecode(respStr);
      return result['data']['url'];
    } else {
      throw Exception('Failed to upload image');
    }
  }

  Future<void> _submitClub() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      String imageUrl = '';
      if (_selectedImage != null) {
        imageUrl = await _uploadImage(_selectedImage!);
      }

      final clubInfo = {
        'name': _nameController.text,
        'admin': _adminController.text,
        'description': _descriptionController.text,
        'imageUrl': imageUrl,
      };

      await _dbRef.push().set(clubInfo);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Club added successfully!')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error adding club: $e')));
    } finally {
      _resetForm();
      setState(() => _isLoading = false);
    }
  }

  void _resetForm() {
    _nameController.clear();
    _adminController.clear();
    _descriptionController.clear();
    _selectedImage = null;
  }

  void _deleteClub(String key) async {
    await _dbRef.child(key).remove();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Club deleted successfully')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isAddView ? 'Add Club' : 'View Clubs'),
        actions: [
          IconButton(
            icon: Icon(_isAddView ? Icons.add :  Icons.view_list),
            onPressed: () => setState(() => _isAddView = !_isAddView), // Toggle view
          ),
        ],
      ),
      body: _isAddView ? _buildViewClubs() :  _buildAddView(), // Toggle between adding and viewing clubs
    );
  }

// _buildAddView, _buildViewClubs, and other methods...


  Widget _buildAddView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: _selectedImage != null
                  ? Image.file(_selectedImage!, fit: BoxFit.fill, height: 200)
                  : Container(
                height: 200,
                decoration: BoxDecoration(color: Colors.grey[200]),
                child: Icon(Icons.camera_alt, color: Colors.grey[800], size: 50),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Club Name', border: OutlineInputBorder()),
              validator: (value) => value == null || value.isEmpty ? 'Please enter the club name' : null,
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _adminController,
              decoration: InputDecoration(labelText: 'Admin', border: OutlineInputBorder()),
              validator: (value) => value == null || value.isEmpty ? 'Please enter the admin name' : null,
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
              validator: (value) => value == null || value.isEmpty ? 'Please enter a description' : null,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _submitClub,
              child: Text('Submit Club'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildViewClubs() {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemCount: _clubs.length,
      itemBuilder: (context, index) {
        final club = _clubs[index];
        return ClubCard(
          club: club,
          onEdit: (key) {
            final clubInfo = _clubs.firstWhere((club) => club['key'] == key);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EditClubPage(clubKey: key, clubInfo: clubInfo)),
            );
          },

          onDelete: (key) {
            _showDeleteConfirmation(context, () => _deleteClub(key));
          },
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context, VoidCallback onConfirmDelete) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this club?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                onConfirmDelete();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

}
class ClubCard extends StatefulWidget {
  final Map<String, dynamic> club;
  final Function(String) onEdit;
  final Function(String) onDelete;

  const ClubCard({
    Key? key,
    required this.club,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  _ClubCardState createState() => _ClubCardState();
}

class _ClubCardState extends State<ClubCard> {
  bool _showActions = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        setState(() {
          _showActions = !_showActions;
        });
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 5,
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: widget.club['imageUrl'] != null && widget.club['imageUrl'].isNotEmpty
                      ? Image.network(widget.club['imageUrl'], fit: BoxFit.cover)
                      : Image.asset('assets/placeholder.png', fit: BoxFit.cover),
                ),
                ListTile(
                  title: Text(widget.club['name']),
                  subtitle: Text('Admin: ${widget.club['admin']}'),
                ),
              ],
            ),
            if (_showActions) Positioned(
              right: 0,
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => widget.onEdit(widget.club['key']),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => widget.onDelete(widget.club['key']),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class EditClubPage extends StatefulWidget {
  final String clubKey;
  final Map<String, dynamic> clubInfo;

  const EditClubPage({Key? key, required this.clubKey, required this.clubInfo}) : super(key: key);

  @override
  _EditClubPageState createState() => _EditClubPageState();
}

class EditclubPage extends StatefulWidget {

  final String clubKey;
  final Map<String, dynamic> clubInfo;

  const EditclubPage({Key? key, required this.clubKey, required this.clubInfo}) : super(key: key);

  @override
  _EditClubPageState createState() => _EditClubPageState();
}

class _EditClubPageState extends State<EditClubPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _adminController;
  late TextEditingController _descriptionController;
  String? _imageUrl; // Existing image URL
  File? _newImage; // New image selected by the user
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.clubInfo['name']);
    _adminController = TextEditingController(text: widget.clubInfo['admin']);
    _descriptionController = TextEditingController(text: widget.clubInfo['description']);
    _imageUrl = widget.clubInfo['imageUrl'];
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _newImage = File(pickedFile.path));
    }
  }

  Future<String> _uploadImage(File image) async {
    const String apiKey = '5732129137e8541dd24d87d509239fff'; // Replace with your actual API key
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('https://api.imgbb.com/1/upload?key=$apiKey'),
    )..files.add(await http.MultipartFile.fromPath('image', image.path));

    final response = await request.send();
    final respStr = await response.stream.bytesToString();
    if (response.statusCode == 200) {
      final result = jsonDecode(respStr);
      return result['data']['url'];
    } else {
      throw Exception('Failed to upload image');
    }
  }
  Future<void> _updateClub() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      String imageUrl = _imageUrl ?? '';
      if (_newImage != null) {
        imageUrl = await _uploadImage(_newImage!); // Ensure _uploadImage method is defined
      }

      final clubInfo = {
        'name': _nameController.text.trim(),
        'admin': _adminController.text.trim(),
        'description': _descriptionController.text.trim(),
        'imageUrl': imageUrl,
      };

      // Update club information in Firebase
      await FirebaseDatabase.instance.ref('clubs').child(widget.clubKey).update(clubInfo);

      Navigator.pop(context); // Optionally pop the context to return to the previous screen
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Club updated successfully!')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error updating club: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Club'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _isLoading ? null : _updateClub,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: _newImage != null
                    ? Image.file(_newImage!, height: 200, width: double.infinity, fit: BoxFit.cover)
                    : (_imageUrl != null && _imageUrl!.isNotEmpty
                    ? Image.network(_imageUrl!, height: 200, width: double.infinity, fit: BoxFit.cover)
                    : Container(
                  height: 200,
                  color: Colors.grey[200],
                  child: Icon(Icons.camera_alt, color: Colors.grey[800], size: 50),
                )),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Club Name', border: OutlineInputBorder()),
                validator: (value) => value?.isEmpty ?? true ? 'Please enter the club name' : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _adminController,
                decoration: InputDecoration(labelText: 'Admin', border: OutlineInputBorder()),
                validator: (value) => value?.isEmpty ?? true ? 'Please enter the admin name' : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
                validator: (value) => value?.isEmpty ?? true ? 'Please enter a description' : null,
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

// Include your _updateClub method here as provided
}