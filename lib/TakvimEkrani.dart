import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Task {
  final String title;
  final String description;

  Task(this.title, this.description);
}

class TakvimEkrani extends StatefulWidget {
  @override
  _TakvimEkraniState createState() => _TakvimEkraniState();
}

class _TakvimEkraniState extends State<TakvimEkrani> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  Map<DateTime, List<Task>> _tasks = {
    DateTime(2024, 3, 4): [Task('Bulaşıkları yıka', 'Bulaşıklar yıkanacak')],
    DateTime(2024, 4, 5): [Task('Kıyafetleri ütüle', 'Kıyafetler ütülenecek')],

  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Takvim Ekranı'),
      ),
      body: Center(
        child: TableCalendar(
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
            return _tasks.containsKey(day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _focusedDay = focusedDay;
            });
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TasksScreen(tasks: _tasks[selectedDay] ?? []),
              ),
            );
          },
        ),
      ),
    );
  }
}

class TasksScreen extends StatelessWidget {
  final List<Task> tasks;

  TasksScreen({required this.tasks});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Görevler'),
        backgroundColor: Colors.red,
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return ListTile(
            title: Text(task.title),
            subtitle: Text(task.description),
          );
        },
      ),
    );
  }
}
