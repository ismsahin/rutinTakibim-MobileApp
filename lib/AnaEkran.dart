import 'package:flutter/material.dart';

class AnaEkran extends StatelessWidget {
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
                  Text('1. Alışverişe git'),
                  Text('2. Spor yap'),
                  Text('3. Ders çalış'),
                  Text('4. Kitap oku'),
                  Text('5. Arkadaşlarla buluş'),
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
                    'Bu Ayki Harcamalar',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('4000 TL'),
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
                    'Bugünkü Yapılacaklar',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('Öğle yemeği hazırla'),
                  Text('E-postaları kontrol et'),
                  Text('Projeyi bitir'),
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
