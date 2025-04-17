import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:yapilacaklar_listem_proje/AnaEkran.dart';
import 'package:yapilacaklar_listem_proje/component/todo_badge.dart';
import 'package:yapilacaklar_listem_proje/gradient_background.dart';
import 'package:yapilacaklar_listem_proje/main.dart';
import 'package:yapilacaklar_listem_proje/model/data/choice_card.dart';
import 'package:yapilacaklar_listem_proje/model/hero_id_model.dart';
import 'package:yapilacaklar_listem_proje/model/task_model.dart';
import 'package:yapilacaklar_listem_proje/page/add_task_screen.dart';
import 'package:yapilacaklar_listem_proje/page/detail_screen.dart';
import 'package:yapilacaklar_listem_proje/page/privacy_policy.dart' show PrivacyPolicyScreen;
import 'package:yapilacaklar_listem_proje/route/scale_route.dart';
import 'package:yapilacaklar_listem_proje/scopedmodel/todo_list_model.dart';
import 'package:yapilacaklar_listem_proje/task_progress_indicator.dart';
import 'package:yapilacaklar_listem_proje/utils/color_utils.dart';
import 'package:yapilacaklar_listem_proje/utils/datetime_utils.dart';

class Listtodos extends StatelessWidget {
  const Listtodos({super.key});

  @override
  Widget build(BuildContext context) {
    var app = MaterialApp(
      title: 'Todo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          textTheme: const TextTheme(
            displayLarge: TextStyle(fontSize: 32.0, fontWeight: FontWeight.w400),
            titleMedium: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w500),
            bodyLarge: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
          )),
      home: const MyHomePage(title: ''),
    );

    return ScopedModel<TodoListModel>(
      model: TodoListModel(),
      child: app,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  HeroId _generateHeroIds(Task task) {
    return HeroId(
      codePointId: 'code_point_id_${task.id}',
      progressId: 'progress_id_${task.id}',
      titleId: 'title_id_${task.id}',
      remainingTaskId: 'remaining_task_id_${task.id}',
    );
  }

  String currentDay(BuildContext context) {
    return DateTimeUtils.currentDay;
  }

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final GlobalKey _backdropKey = GlobalKey(debugLabel: 'Backdrop');
  late PageController _pageController;
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _pageController = PageController(initialPage: 0, viewportFraction: 0.8);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<TodoListModel>(
        builder: (BuildContext context, Widget? child, TodoListModel model) {
      var isLoading = model.isLoading;
      var tasks = model.tasks;
      var todos = model.todos;
      var backgroundColor = tasks.isEmpty || tasks.length == _currentPageIndex
          ? Colors.blueGrey
          : ColorUtils.getColorFrom(id: tasks[_currentPageIndex].color);
      if (!isLoading) {
        // move the animation value towards upperbound only when loading is complete
        _controller.forward();
      }
      return GradientBackground(
        color: backgroundColor,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text(widget.title),
            centerTitle: true,
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            actions: [
              IconButton(
                icon: const Icon(Icons.home),
                tooltip: 'Ana Ekran',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const AnaSayfa()),
                  );
                },
              ),
            ],
          ),
          body: isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 1.0,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : FadeTransition(
                  opacity: _animation,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(top: 0.0, left: 56.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            // ShadowImage(),
                            Container(
                              // margin: EdgeInsets.only(top: 22.0),
                              child: Text(
                                widget.currentDay(context),
                                style: Theme.of(context)
                                    .textTheme
                                    .displayLarge
                                    ?.copyWith(color: Colors.white),
                              ),
                            ),
                            Text(
                              '${DateTimeUtils.currentDate} ${DateTimeUtils.currentMonth}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(color: Colors.white.withOpacity(0.7)),
                            ),
                            Container(height: 16.0),
                            Text(
                              'You have ${todos.where((todo) => todo.isCompleted == 0).length} tasks to complete',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(color: Colors.white.withOpacity(0.7)),
                            ),
                            Container(
                              height: 16.0,
                            )
                            // Container(
                            //   margin: EdgeInsets.only(top: 42.0),
                            //   child: Text(
                            //     'TODAY : FEBURARY 13, 2019',
                            //     style: Theme.of(context)
                            //         .textTheme
                            //         .subtitle
                            //         .copyWith(color: Colors.white.withOpacity(0.8)),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                      Expanded(
                        key: _backdropKey,
                        flex: 1,
                        child: NotificationListener<ScrollNotification>(
                          onNotification: (notification) {
                            if (notification is ScrollEndNotification) {
                              print("ScrollNotification = ${_pageController.page}");
                              var currentPage = _pageController.page?.round().toInt() ?? 0;
                              if (_currentPageIndex != currentPage) {
                                setState(() => _currentPageIndex = currentPage);
                              }
                            }
                            return true;
                          },
                          child: PageView.builder(
                            controller: _pageController,
                            itemBuilder: (BuildContext context, int index) {
                              if (index == tasks.length) {
                                return const AddPageCard(
                                  color: Colors.blueGrey,
                                );
                              } else {
                                return TaskCard(
                                  backdropKey: _backdropKey,
                                  color: ColorUtils.getColorFrom(id: tasks[index].color),
                                  getHeroIds: widget._generateHeroIds,
                                  getTaskCompletionPercent: model.getTaskCompletionPercent,
                                  getTotalTodos: model.getTotalTodosFrom,
                                  task: tasks[index],
                                );
                              }
                            },
                            itemCount: tasks.length + 1,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 32.0),
                      ),
                    ],
                  ),
                ),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class AddPageCard extends StatelessWidget {
  final Color color;

  const AddPageCard({super.key, this.color = Colors.black});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      child: Material(
        borderRadius: BorderRadius.circular(16.0),
        color: Colors.white,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddTaskScreen(),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add,
                  size: 52.0,
                  color: color,
                ),
                Container(
                  height: 8.0,
                ),
                Text(
                  'Add Category',
                  style: TextStyle(color: color),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

typedef TaskGetter<T, V> = V Function(T value);

class TaskCard extends StatelessWidget {
  final GlobalKey backdropKey;
  final Task task;
  final Color color;

  final TaskGetter<Task, int> getTotalTodos;
  final TaskGetter<Task, HeroId> getHeroIds;
  final TaskGetter<Task, int> getTaskCompletionPercent;

  const TaskCard({
    super.key,
    required this.backdropKey,
    required this.color,
    required this.task,
    required this.getTotalTodos,
    required this.getHeroIds,
    required this.getTaskCompletionPercent,
  });

  @override
  Widget build(BuildContext context) {
    var heroIds = getHeroIds(task);
    return GestureDetector(
      onTap: () {
        final RenderBox renderBox = backdropKey.currentContext?.findRenderObject() as RenderBox;
        var backDropHeight = renderBox.size.height ?? 0;
        var bottomOffset = 60.0;
        var horizontalOffset = 52.0;
        var topOffset = MediaQuery.of(context).size.height - backDropHeight;

        var rect =
            RelativeRect.fromLTRB(horizontalOffset, topOffset, horizontalOffset, bottomOffset);
        Navigator.push(
          context,
          ScaleRoute(
            rect: rect,
            widget: DetailScreen(
              taskId: task.id,
              heroIds: heroIds,
            ),
          ),
          // MaterialPageRoute(
          //   builder: (context) => DetailScreen(
          //         taskId: task.id,
          //         heroIds: heroIds,
          //       ),
          // ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 4.0,
        margin: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TodoBadge(
                id: heroIds.codePointId,
                codePoint: task.codePoint,
                color: ColorUtils.getColorFrom(
                  id: task.color,
                ),
              ),
              const Spacer(
                flex: 8,
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 4.0),
                child: Hero(
                  tag: heroIds.remainingTaskId,
                  child: Text(
                    "${getTotalTodos(task)} Task",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey[500]),
                  ),
                ),
              ),
              Container(
                child: Hero(
                  tag: heroIds.titleId,
                  child: Text(task.name,
                      style:
                          Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black54)),
                ),
              ),
              const Spacer(),
              Hero(
                tag: heroIds.progressId,
                child: TaskProgressIndicator(
                  color: color,
                  progress: getTaskCompletionPercent(task),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
