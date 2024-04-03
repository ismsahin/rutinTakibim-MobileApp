import 'package:flutter/material.dart';

class YapilacaklarEkrani extends StatefulWidget {
  @override
  _YapilacaklarEkraniState createState() => _YapilacaklarEkraniState();
}

class _YapilacaklarEkraniState extends State<YapilacaklarEkrani> {
  List<String> todos = [];
  TextEditingController _textEditingController = TextEditingController();

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
                  title: Text(todos[index]),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        todos.removeAt(index);
                      });
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
                  onPressed: () {
                    setState(() {
                      todos.add(_textEditingController.text);
                      _textEditingController.clear();
                    });
                  },
                  child: Text('Ekle'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
