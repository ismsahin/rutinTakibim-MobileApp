import 'package:flutter/material.dart';

class BildirimEkran extends StatefulWidget {
  const BildirimEkran({super.key});

  @override
  State<BildirimEkran> createState() => _BildirimEkranState();
}

class _BildirimEkranState extends State<BildirimEkran> {
  final int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bildirimler'),
        backgroundColor: Colors.red,
      ),
      body: ListView(
        children: <Widget>[
          Card(
            margin: const EdgeInsets.all(8),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  NotificationItem(
                    title: 'Aylık Harcama Bildirimi',
                    description: 'Aylık harcama limitiniz 1000 TL\'yi aştı.',
                    date: '2 Nisan 2024',
                    onTap: () {},
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(Colors.purple),
                    ),
                    child: const Text(
                      'Detay',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.all(8),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  NotificationItem(
                    title: 'Takvim Bildirimi',
                    description: 'Bugün beklediğiniz bir etkinlik var.',
                    date: '3 Nisan 2024',
                    onTap: () {},
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(Colors.purple),
                    ),
                    child: const Text(
                      'Detay',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.all(8),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  NotificationItem(
                    title: 'Yapılacakları Unutma',
                    description: 'Bugün terziden kıyafetini almayı unutma.',
                    date: '5 Nisan 2024',
                    onTap: () {},
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(Colors.purple),
                    ),
                    child: const Text(
                      'Detay',
                      style: TextStyle(color: Colors.white),
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
    super.key,
    required this.title,
    required this.description,
    required this.date,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(description),
          const SizedBox(height: 4),
          Text(
            date,
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
