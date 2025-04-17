import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'DatabaseTakvim.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Takvim Uygulaması',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TakvimEkrani(),
    );
  }
}

class TakvimEkrani extends StatefulWidget {
  const TakvimEkrani({super.key});

  @override
  _TakvimEkraniState createState() => _TakvimEkraniState();
}

class _TakvimEkraniState extends State<TakvimEkrani> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  final Map<DateTime, List<Task>> _tasks = {};
  List<Task> _upcomingTasks = [];
  List<Task> _allTasks = [];
  int _taskCount = 0;

  @override
  void initState() {
    super.initState();
    _loadTasks();
    _loadUpcomingTasks();
    _loadAllTasks();
    _loadTaskCount();
  }

  void _loadTasks() async {
    final dbTasks = await DatabaseTakvim.instance.fetchTasks(_focusedDay);
    setState(() {
      _tasks[_focusedDay] = dbTasks;
    });
  }

  void _refreshTasks(DateTime date) async {
    final dbTasks = await DatabaseTakvim.instance.fetchTasks(date);
    setState(() {
      _tasks[date] = dbTasks;
    });
  }

  void _loadUpcomingTasks() async {
    final dbTasks = await DatabaseTakvim.instance.fetchUpcomingTasks();
    setState(() {
      _upcomingTasks = dbTasks;
    });
  }

  void _loadAllTasks() async {
    final dbTasks = await DatabaseTakvim.instance.fetchAllTasks();
    setState(() {
      _allTasks = dbTasks..sort((a, b) => a.date.compareTo(b.date));
    });
  }

  void _loadTaskCount() async {
    final count = await DatabaseTakvim.instance.fetchTaskCount();
    setState(() {
      _taskCount = count;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Takvim Ekranı'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
                _refreshTasks(selectedDay);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TasksScreen(tasks: _tasks[selectedDay] ?? []),
                  ),
                );
              },
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddTaskScreen(selectedDate: _selectedDay),
                  ),
                ).then((_) {
                  _refreshTasks(_selectedDay);
                  _loadUpcomingTasks();
                  _loadAllTasks();
                  _loadTaskCount();
                });
              },
              child: const Text('Görev Ekle'),
            ),
            const SizedBox(height: 20),
            ExpansionTile(
              title: const Text(
                'Yaklaşan Etkinlikler (30 gün)',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              initiallyExpanded: true,
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _upcomingTasks.length,
                  itemBuilder: (context, index) {
                    final task = _upcomingTasks[index];
                    return ListTile(
                      title: Text(task.title),
                      subtitle: Text(
                          '${task.description} - ${task.date.toLocal().toIso8601String().split('T')[0]}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditTaskScreen(task: task),
                                ),
                              ).then((_) {
                                _refreshTasks(_selectedDay);
                                _loadUpcomingTasks();
                                _loadAllTasks();
                                _loadTaskCount();
                              });
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              setState(() {
                                _upcomingTasks.removeAt(index);
                                DatabaseTakvim.instance.deleteTask(task);
                                _loadAllTasks();
                                _loadTaskCount();
                              });
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
            ExpansionTile(
              title: Text(
                'Tüm Etkinlikler ($_taskCount)',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _allTasks.length,
                  itemBuilder: (context, index) {
                    final task = _allTasks[index];
                    return ListTile(
                      title: Text(task.title),
                      subtitle: Text(
                          '${task.description} - ${task.date.toLocal().toIso8601String().split('T')[0]}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditTaskScreen(task: task),
                                ),
                              ).then((_) {
                                _refreshTasks(_selectedDay);
                                _loadUpcomingTasks();
                                _loadAllTasks();
                                _loadTaskCount();
                              });
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              setState(() {
                                _allTasks.removeAt(index);
                                DatabaseTakvim.instance.deleteTask(task);
                                _loadAllTasks();
                                _loadTaskCount();
                              });
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AddTaskScreen extends StatefulWidget {
  final DateTime selectedDate;

  const AddTaskScreen({super.key, required this.selectedDate});

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yeni Görev Ekle'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Başlık'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen bir başlık girin';
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Açıklama'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen bir açıklama girin';
                  }
                  return null;
                },
                onSaved: (value) {
                  _description = value!;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                  );
                  if (selectedDate != null) {
                    setState(() {
                      _selectedDate = selectedDate;
                    });
                  }
                },
                child:
                    Text('Tarih Seç (${_selectedDate.toLocal().toIso8601String().split('T')[0]})'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    Task newTask = Task(
                      title: _title,
                      description: _description,
                      date: _selectedDate,
                    );

                    await DatabaseTakvim.instance.insertTask(newTask);

                    Navigator.pop(context);
                  }
                },
                child: const Text('Görev Ekle'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EditTaskScreen extends StatefulWidget {
  final Task task;

  const EditTaskScreen({super.key, required this.task});

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _title = widget.task.title;
    _description = widget.task.description;
    _selectedDate = widget.task.date;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Görev Düzenle'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _title,
                decoration: const InputDecoration(labelText: 'Başlık'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen bir başlık girin';
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value!;
                },
              ),
              TextFormField(
                initialValue: _description,
                decoration: const InputDecoration(labelText: 'Açıklama'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen bir açıklama girin';
                  }
                  return null;
                },
                onSaved: (value) {
                  _description = value!;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                  );
                  if (selectedDate != null) {
                    setState(() {
                      _selectedDate = selectedDate;
                    });
                  }
                },
                child:
                    Text('Tarih Seç (${_selectedDate.toLocal().toIso8601String().split('T')[0]})'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    Task updatedTask = Task(
                      id: widget.task.id,
                      title: _title,
                      description: _description,
                      date: _selectedDate,
                    );

                    await DatabaseTakvim.instance.updateTask(updatedTask);

                    Navigator.pop(context);
                  }
                },
                child: const Text('Görev Güncelle'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TasksScreen extends StatelessWidget {
  final List<Task> tasks;

  const TasksScreen({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Görevler'),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return ListTile(
            title: Text(task.title),
            subtitle: Text(
                '${task.description} - ${task.date.toLocal().toIso8601String().split('T')[0]}'),
          );
        },
      ),
    );
  }
}
