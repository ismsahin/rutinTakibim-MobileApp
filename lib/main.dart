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
//https://www.youtube.com/watch?v=V1ofEl17_BQ
//https://github.com/asjqkkkk/flutter-todos
class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rutin Takibi',
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
        title: Text('Rutin Takibim'),
        backgroundColor: Colors.red,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BildirimEkran()),
              );
            },
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        animationDuration: const Duration(seconds: 1),
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: _navBarItems,
      ),
    );
  }
}

const _navBarItems = [
  NavigationDestination(
    icon: Icon(Icons.home_outlined),
    selectedIcon: Icon(Icons.home_rounded),
    label: 'Home',
  ),
  NavigationDestination(
    icon: Icon(Icons.check_circle_outline),
    selectedIcon: Icon(Icons.check_circle_rounded),
    label: 'Yapılacaklar',
  ),
  NavigationDestination(
    icon: Icon(Icons.money_outlined),
    selectedIcon: Icon(Icons.money_rounded),
    label: 'Harcamalar',
  ),
  NavigationDestination(
    icon: Icon(Icons.calendar_today),
    selectedIcon: Icon(Icons.calendar_today_rounded),
    label: 'Takvim',
  ),
  NavigationDestination(
    icon: Icon(Icons.person_outlined),
    selectedIcon: Icon(Icons.person_rounded),
    label: 'Hesabım',
  ),
];




