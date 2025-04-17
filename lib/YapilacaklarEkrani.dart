import 'package:flutter/material.dart';
import 'DatabaseHelper.dart'; // DatabaseHelper dosyasını içe aktarın.

class YapilacaklarEkrani extends StatefulWidget {
  const YapilacaklarEkrani({super.key});

  @override
  _YapilacaklarEkraniState createState() => _YapilacaklarEkraniState();
}

class _YapilacaklarEkraniState extends State<YapilacaklarEkrani> {
  List<Map<String, dynamic>> todos = [];
  List<Map<String, dynamic>> completedTodos = [];
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _refreshTodos();
  }

  Future<void> _refreshTodos() async {
    final data = await DatabaseHelper.instance.readAllTodos();
    setState(() {
      todos = data.where((todo) => todo['isCompleted'] == 0).toList();
      completedTodos = data.where((todo) => todo['isCompleted'] == 1).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yapılacaklar Listesi'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                ExpansionTile(
                  initiallyExpanded: true,
                  title: const Text(
                    'Yapılacaklar',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  children: todos
                      .map((todo) => ListTile(
                            leading: Checkbox(
                              value: todo['isCompleted'] == 1,
                              onChanged: (bool? value) async {
                                await DatabaseHelper.instance
                                    .updateCompletion(todo['id'], value! ? 1 : 0);
                                _refreshTodos();
                              },
                            ),
                            title: Text(
                              todo['task'],
                              style: TextStyle(
                                decoration: todo['isCompleted'] == 1
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                                await DatabaseHelper.instance.delete(todo['id']);
                                _refreshTodos();
                              },
                            ),
                          ))
                      .toList(),
                ),
                ExpansionTile(
                  title: const Text(
                    'Tamamlananlar',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  children: completedTodos
                      .map((todo) => ListTile(
                            leading: Checkbox(
                              value: todo['isCompleted'] == 1,
                              onChanged: (bool? value) async {
                                await DatabaseHelper.instance
                                    .updateCompletion(todo['id'], value! ? 1 : 0);
                                _refreshTodos();
                              },
                            ),
                            title: Text(
                              todo['task'],
                              style: TextStyle(
                                decoration: todo['isCompleted'] == 1
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                                await DatabaseHelper.instance.delete(todo['id']);
                                _refreshTodos();
                              },
                            ),
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textEditingController,
                    decoration: const InputDecoration(hintText: 'Bir görev ekle'),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () async {
                    if (_textEditingController.text.isNotEmpty) {
                      await DatabaseHelper.instance.create(_textEditingController.text);
                      _textEditingController.clear();
                      _refreshTodos();
                    }
                  },
                  child: const Text('Ekle'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Toplam yapılacaklar:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(width: 5),
                Text(
                  '${todos.length}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
