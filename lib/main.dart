import 'package:flutter/material.dart';

import 'package:yapilacaklar_listem_proje/bildirim_ekrani.dart';
import 'package:yapilacaklar_listem_proje/AnaEkran.dart';
import 'package:yapilacaklar_listem_proje/HarcamalarEkrani.dart';
import 'package:yapilacaklar_listem_proje/YapilacaklarEkrani.dart';
import 'package:yapilacaklar_listem_proje/TakvimEkrani.dart';
import 'package:yapilacaklar_listem_proje/HesabimEkrani.dart';

void main() {
  runApp(TodoApp());
}

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo Uygulaması',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AnaSayfa(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AnaSayfa extends StatefulWidget {
  @override
  _AnaSayfaState createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    AnaEkran(),
    YapilacaklarEkrani(),
    HarcamalarEkrani(),
    TakvimEkrani(),
    HesabimEkrani(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Yapılacaklar Listem'),
        backgroundColor: Colors.red,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Bildirim simgesine tıklandığında bildirim ekranına yönlendirme işlevselliği
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BildirimEkran()),
              );
            },
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,

        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Ana Ekran',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle_outline),
            selectedIcon: Icon(Icons.check_circle_rounded),
            label: 'Yapılacaklar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.money_outlined),
            selectedIcon: Icon(Icons.money_rounded),
            label: 'Harcamalar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Takvim',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box),
            label: 'Hesabım',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red,
        backgroundColor: Colors.grey,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },

      ),
    );
  }
}




