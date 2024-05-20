import 'package:flutter/material.dart';

class BildirimEkran extends StatefulWidget {
  const BildirimEkran({Key? key}) : super(key: key);

  @override
  State<BildirimEkran> createState() => _BildirimEkranState();
}

class _BildirimEkranState extends State<BildirimEkran> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bildirimler'),
        backgroundColor: Colors.red,
      ),
      body: ListView(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(8),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  NotificationItem(
                    title: 'Aylık Harcama Bildirimi',
                    description: 'Aylık harcama limitiniz 1000 TL\'yi aştı.',
                    date: '2 Nisan 2024',
                    onTap: () {
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                    },
                    child: Text(
                      'Detay',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.purple),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Card(
            margin: EdgeInsets.all(8),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  NotificationItem(
                    title: 'Takvim Bildirimi',
                    description: 'Bugün beklediğiniz bir etkinlik var.',
                    date: '3 Nisan 2024',
                    onTap: () {
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                    },
                    child: Text(
                      'Detay',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.purple),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Card(
            margin: EdgeInsets.all(8),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  NotificationItem(
                    title: 'Yapılacakları Unutma',
                    description: 'Bugün terziden kıyafetini almayı unutma.',
                    date: '5 Nisan 2024',
                    onTap: () {
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {

                    },
                    child: Text(
                      'Detay',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.purple),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NotificationItem extends StatelessWidget {
  final String title;
  final String description;
  final String date;
  final VoidCallback onTap;

  const NotificationItem({
    Key? key,
    required this.title,
    required this.description,
    required this.date,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(description),
          SizedBox(height: 4),
          Text(
            date,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
