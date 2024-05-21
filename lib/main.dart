import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'user_registration_screen.dart';
import 'AnaEkran.dart';
import 'YapilacaklarEkrani.dart';
import 'HarcamalarEkrani.dart';
import 'TakvimEkrani.dart';
import 'HesabimEkrani.dart';
import 'bildirim_ekrani.dart';

void main() {
  runApp(TodoApp());
}

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rutin Takibi',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => UserCheckScreen(),
        '/registration': (context) => UserRegistrationScreen(),
        '/home': (context) => AnaSayfa(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class UserCheckScreen extends StatelessWidget {
  Future<bool> _isUserRegistered() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('name') && prefs.containsKey('surname');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _isUserRegistered(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasData && snapshot.data == true) {
          return AnaSayfa();
        } else {
          return UserRegistrationScreen();
        }
      },
    );
  }
}

class AnaSayfa extends StatefulWidget {
  @override
  _AnaSayfaState createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  int _selectedIndex = 0;
  List<Map<String, dynamic>> todos = [];

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
