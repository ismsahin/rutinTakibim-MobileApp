import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'HarcamalarEkrani.dart';
import 'YapilacaklarEkrani.dart';
import 'TakvimEkrani.dart';
import 'DatabaseHelper.dart';

class HesabimEkrani extends StatefulWidget {
  @override
  _HesabimEkraniState createState() => _HesabimEkraniState();
}

class _HesabimEkraniState extends State<HesabimEkrani> {
  int yapilmamisGorevlerCount = 0;
  int tamamlananlarCount = 0;
  int takvimlerimCount = 24;  // Sabit olarak 24 sayısı
  String name = "";
  String surname = "";
  String? imagePath;

    @override
    void initState() {
      super.initState();
      _loadUserInfo();
      _loadCounts();
    }

  Future<void> _loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name') ?? "";
      surname = prefs.getString('surname') ?? "";
      imagePath = prefs.getString('imagePath');
    });
  }

  Future<void> _loadCounts() async {
    final dbHelper = DatabaseHelper.instance;
    int yapilmamisGorevler = await dbHelper.getCountOfIncompleteTodos();
    int tamamlananlar = await dbHelper.getCountOfCompletedTodos();

    setState(() {
      yapilmamisGorevlerCount = yapilmamisGorevler;
      tamamlananlarCount = tamamlananlar;
    });
  }

  Future<void> _updateUserInfo(String newName, String newSurname, File? newImage) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (newImage != null) {
      // Resmi kalıcı depolama alanına kopyala
      final directory = await getApplicationDocumentsDirectory();
      String newPath = '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.png';
      File permanentImage = await newImage.copy(newPath);

      setState(() {
        imagePath = permanentImage.path;
        prefs.setString('imagePath', permanentImage.path);
      });
    }

    setState(() {
      name = newName;
      surname = newSurname;
      prefs.setString('name', newName);
      prefs.setString('surname', newSurname);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hesabım'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => UserEditScreen(
                    currentName: name,
                    currentSurname: surname,
                    currentImagePath: imagePath,
                    onSave: _updateUserInfo,
                  ),
                ),
              );
            },
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(flex: 2, child: _TopPortion(imagePath: imagePath)),
          Expanded(
            flex: 3,
            child: Column(
              children: [
                const SizedBox(height: 16),
                Text(
                  "$name $surname",
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FloatingActionButton.extended(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => YapilacaklarEkrani()),
                        );
                      },
                      heroTag: 'follow',
                      elevation: 0,
                      label: const Text("Yapılacaklar"),
                      icon: const Icon(Icons.check_circle_outline),
                    ),
                    const SizedBox(width: 16.0),
                    FloatingActionButton.extended(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HarcamalarEkrani()),
                        );
                      },
                      heroTag: 'mesage',
                      elevation: 0,
                      backgroundColor: Colors.red,
                      label: const Text("Harcamalar"),
                      icon: const Icon(Icons.money_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                FloatingActionButton.extended(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TakvimEkrani()),
                    );
                  },
                  heroTag: 'events',
                  elevation: 0,
                  backgroundColor: Colors.blue,
                  label: const Text("Yaklaşan Etkinlikler"),
                  icon: const Icon(Icons.calendar_today),
                ),
                const SizedBox(height: 16),
                _ProfileInfoRow(
                  yapilmamisGorevlerCount: yapilmamisGorevlerCount,
                  tamamlananlarCount: tamamlananlarCount,
                  takvimlerimCount: takvimlerimCount,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TopPortion extends StatelessWidget {
  final String? imagePath;

  const _TopPortion({Key? key, this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 50),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Color(0xff0043ba), Color(0xff006df1)],
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: 150,
            height: 150,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.black,
                  child: imagePath == null
                      ? Icon(Icons.person, size: 80, color: Colors.white)
                      : CircleAvatar(
                    radius: 72,
                    backgroundImage: FileImage(File(imagePath!)),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    child: Container(
                      margin: const EdgeInsets.all(8.0),
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ProfileInfoRow extends StatelessWidget {
  final int yapilmamisGorevlerCount;
  final int tamamlananlarCount;
  final int takvimlerimCount;

  const _ProfileInfoRow({
    Key? key,
    required this.yapilmamisGorevlerCount,
    required this.tamamlananlarCount,
    required this.takvimlerimCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildProfileInfo(context, "Yapılmamış Görevler", yapilmamisGorevlerCount),
        _buildVerticalDivider(),
        _buildProfileInfo(context, "Tamamlananlar", tamamlananlarCount),
        _buildVerticalDivider(),
        _buildProfileInfo(context, "Takvimlerim", takvimlerimCount),
      ],
    );
  }

  Widget _buildProfileInfo(BuildContext context, String title, int count) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: Theme.of(context).textTheme.headline6?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(title),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 40,
      width: 2,
      color: Colors.grey,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
    );
  }
}

class UserEditScreen extends StatefulWidget {
  final String currentName;
  final String currentSurname;
  final String? currentImagePath;
  final Function(String, String, File?) onSave;

  UserEditScreen({
    required this.currentName,
    required this.currentSurname,
    this.currentImagePath,
    required this.onSave,
  });

  @override
  _UserEditScreenState createState() => _UserEditScreenState();
}

class _UserEditScreenState extends State<UserEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  File? _image;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.currentName;
    _surnameController.text = widget.currentSurname;
    if (widget.currentImagePath != null) {
      _image = File(widget.currentImagePath!);
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      widget.onSave(_nameController.text, _surnameController.text, _image);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil Düzenle'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveChanges,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
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
              const SizedBox(height: 16),
              _image == null
                  ? Text('Fotoğraf seçilmedi')
                  : Image.file(_image!, height: 100),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Fotoğraf Seç'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
