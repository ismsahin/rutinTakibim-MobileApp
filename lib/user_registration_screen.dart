import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'user_database_helper.dart';

class UserRegistrationScreen extends StatefulWidget {
  @override
  _UserRegistrationScreenState createState() => _UserRegistrationScreenState();
}

class _UserRegistrationScreenState extends State<UserRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  File? _image;
  UserDatabaseHelper dbHelper = UserDatabaseHelper();

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveUserInfo() async {
    if (_formKey.currentState!.validate()) {
      await dbHelper.saveUserInfo(_nameController.text, _surnameController.text, _image);
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    Map<String, dynamic> userInfo = await dbHelper.getUserInfo();
    if (userInfo.isNotEmpty) {
      _nameController.text = userInfo['name'];
      _surnameController.text = userInfo['surname'];
      if (userInfo.containsKey('imageFile')) {
        setState(() {
          _image = userInfo['imageFile'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kullanıcı Kaydı'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Ad'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen adınızı girin';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _surnameController,
                decoration: InputDecoration(labelText: 'Soyad'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen soyadınızı girin';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              _image == null
                  ? Text('Fotoğraf seçilmedi')
                  : Image.file(_image!, height: 100),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Fotoğraf Seç'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveUserInfo,
                child: Text('Kaydet'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
