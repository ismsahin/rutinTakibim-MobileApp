import 'package:flutter/material.dart';
import 'DatabaseHelper.dart'; // DatabaseHelper dosyasını içe aktarın.

class YapilacaklarEkrani extends StatefulWidget {
  @override
  _YapilacaklarEkraniState createState() => _YapilacaklarEkraniState();
}

class _YapilacaklarEkraniState extends State<YapilacaklarEkrani> {
  List<Map<String, dynamic>> todos = [];
  TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _refreshTodos();
  }

  Future<void> _refreshTodos() async {
    final data = await DatabaseHelper.instance.readAllTodos();
    setState(() {
      todos = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Yapılacaklar Listesi'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: todos.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(todos[index]['task']),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      await DatabaseHelper.instance.delete(todos[index]['id']);
                      _refreshTodos();
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textEditingController,
                    decoration: InputDecoration(hintText: 'Bir görev ekle'),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () async {
                    if (_textEditingController.text.isNotEmpty) {
                      await DatabaseHelper.instance.create(_textEditingController.text);
                      _textEditingController.clear();
                      _refreshTodos();
                    }
                  },
                  child: Text('Ekle'),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Toplam yapılacaklar:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18), // fontSize'u 18 olarak güncellendi
                ),
                SizedBox(width: 5),
                Text(
                  '${todos.length}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18), // fontSize'u 18 olarak güncellendi
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
