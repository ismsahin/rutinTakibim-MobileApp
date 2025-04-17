import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:yapilacaklar_listem_proje/DatabaseHelper.dart'; // DatabaseHelper dosyasını içe aktarın.
import 'package:yapilacaklar_listem_proje/DatabaseHarcamalar.dart'; // DatabaseHelperHarcamalar dosyasını içe aktarın.
import 'package:yapilacaklar_listem_proje/DatabaseTakvim.dart';
import 'package:yapilacaklar_listem_proje/ListTodos.dart'; // DatabaseTakvim dosyasını içe aktarın.

class AnaEkran extends StatefulWidget {
  const AnaEkran({super.key});

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
    for (var harcama in data) {
      toplam += harcama.miktar;
    }

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
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.purple, width: 2.0),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: const Text(
                'GÜNE BAKIŞ',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.purple),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(8),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Listtodos()),
                  );
                },
                icon: const Icon(Icons.list_alt_rounded),
                label: const Text(
                  'Listeleri Görüntüle',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(8),
              color: Colors.grey[200],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Yapılacaklar',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...todos.asMap().entries.map((entry) {
                    int index = entry.key + 1;
                    Map<String, dynamic> todo = entry.value;
                    return Text('$index. ${todo['task']}');
                  }),
                  const SizedBox(height: 8),
                  Text(
                    'Tamamlanacaklar: ${todos.where((todo) => todo['isCompleted'] == 0).length} adet',
                    style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(8),
              color: Colors.grey[200],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Bu Ayki Harcamalar (Son 7)',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...harcamalar.map((harcama) {
                    return Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 8),
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          '${harcama.aciklama}: ${harcama.miktar.toStringAsFixed(2)} TL',
                          style: const TextStyle(),
                        ),
                      ],
                    );
                  }),
                  const SizedBox(height: 8),
                  Text(
                    'Toplam Harcama: ${toplamHarcama.toStringAsFixed(2)} TL',
                    style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(8),
              color: Colors.grey[200],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Takvimde Yaklaşanlar',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...upcomingTasks.map((task) {
                    return Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 8),
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          '${task.date.toLocal().toIso8601String().split('T')[0]}: ${task.title} - ${task.description}',
                          style: const TextStyle(),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(8),
              color: Colors.grey[200],
              child: const Column(
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
