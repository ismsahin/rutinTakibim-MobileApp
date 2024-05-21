import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:yapilacaklar_listem_proje/DatabaseHelper.dart'; // DatabaseHelper dosyasını içe aktarın.
import 'package:yapilacaklar_listem_proje/DatabaseHarcamalar.dart'; // DatabaseHelperHarcamalar dosyasını içe aktarın.
import 'package:yapilacaklar_listem_proje/DatabaseTakvim.dart'; // DatabaseTakvim dosyasını içe aktarın.

class AnaEkran extends StatefulWidget {
  @override
  _AnaEkranState createState() => _AnaEkranState();
}

class _AnaEkranState extends State<AnaEkran> {
  List<Map<String, dynamic>> todos = [];
  List<Harcama> harcamalar = [];
  List<Task> upcomingTasks = [];
  double toplamHarcama = 0.0;

  @override
  void initState() {
    super.initState();
    _refreshTodos();
    _refreshHarcamalar();
    _refreshUpcomingTasks();
  }

  Future<void> _refreshTodos() async {
    final data = await DatabaseHelper.instance.readAllTodos();
    setState(() {
      todos = data.where((todo) => todo['isCompleted'] == 0).toList();
    });
  }

  Future<void> _refreshHarcamalar() async {
    final data = await DatabaseHarcamalar.instance.readAllHarcamalar();
    double toplam = 0.0;
    data.forEach((harcama) {
      toplam += harcama.miktar;
    });

    setState(() {
      harcamalar = data.reversed.take(7).toList(); // Son 7 harcamayı alın.
      toplamHarcama = toplam;
    });
  }

  Future<void> _refreshUpcomingTasks() async {
    final data = await DatabaseTakvim.instance.fetchUpcomingTasks();
    setState(() {
      upcomingTasks = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.purple, width: 2.0),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Text(
                'GÜNE BAKIŞ',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.purple),
              ),
            ),
            Container(
              margin: EdgeInsets.all(8),
              padding: EdgeInsets.all(8),
              color: Colors.grey[200],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Yapılacaklar',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  ...todos.asMap().entries.map((entry) {
                    int index = entry.key + 1;
                    Map<String, dynamic> todo = entry.value;
                    return Text('$index. ${todo['task']}');
                  }).toList(),
                  SizedBox(height: 8),
                  Text(
                    'Tamamlanacaklar: ${todos.where((todo) => todo['isCompleted'] == 0).length} adet',
                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(8),
              padding: EdgeInsets.all(8),
              color: Colors.grey[200],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bu Ayki Harcamalar (Son 7)',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  ...harcamalar.map((harcama) {
                    return Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 8),
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          '${harcama.aciklama}: ${harcama.miktar.toStringAsFixed(2)} TL',
                          style: TextStyle(),
                        ),
                      ],
                    );
                  }).toList(),
                  SizedBox(height: 8),
                  Text(
                    'Toplam Harcama: ${toplamHarcama.toStringAsFixed(2)} TL',
                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(8),
              padding: EdgeInsets.all(8),
              color: Colors.grey[200],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Takvimde Yaklaşanlar',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  ...upcomingTasks.map((task) {
                    return Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 8),
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          '${task.date.toLocal().toIso8601String().split('T')[0]}: ${task.title} - ${task.description}',
                          style: TextStyle(),
                        ),
                      ],
                    );
                  }).toList(),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(8),
              padding: EdgeInsets.all(8),
              color: Colors.grey[200],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hedefler',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('1 ay boyunca telefona %10 daha az bak.'),
                  Text('Harcamalarını %20 düşür.'),
                  Text('20 tane görev tamamla.'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
