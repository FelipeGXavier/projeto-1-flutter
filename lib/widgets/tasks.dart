import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:projeto_1/services/databaseService.dart';
import 'package:projeto_1/widgets/bottomBar.dart';

class Task {
  int? id;
  late String title;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
    };
  }

  static Task fromMap(Map<String, dynamic> map) {
    var task = Task();
    task.id = map['id']?.toInt() ?? 0;
    task.title = map['title'] ?? '';
    return task;
  }
}

class Tasks extends StatefulWidget {
  const Tasks({super.key});

  @override
  State<StatefulWidget> createState() {
    return _TasksState();
  }
}

class _TasksState extends State {
  late String _title;
  List<Task> _tasks = [];

  @override
  void initState() {
    super.initState();
    _initTasks();
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return Scaffold(
        appBar: AppBar(title: const Text("Tarefas")),
        body: Column(children: [
          ListView(
            padding: const EdgeInsets.only(top: 16.0),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: [
              ElevatedButton(
                child: const Text("Criar Nova Tarefa"),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          scrollable: true,
                          title: const Text('Login'),
                          content: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Form(
                              key: formKey,
                              child: Column(
                                children: <Widget>[
                                  TextFormField(
                                    onSaved: (newValue) {
                                      setState(() {
                                        _title = newValue!;
                                      });
                                    },
                                    decoration: const InputDecoration(
                                      labelText: 'Tarefa',
                                      icon: Icon(Icons.confirmation_num),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          actions: [
                            ElevatedButton(
                                child: const Text("Salvar"),
                                onPressed: () {
                                  formKey.currentState!.save();
                                  _insertTask();
                                })
                          ],
                        );
                      });
                },
              ),
              ListView.separated(
                padding: const EdgeInsets.only(top: 16.0),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: _tasks.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    padding: const EdgeInsets.all(8.0),
                    color: Colors.amber,
                    child: Center(
                      child: ListTile(
                        title: Text(
                          _tasks[index].title,
                          style: const TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 20.0),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(
                                Icons.delete_outline,
                                size: 20.0,
                                color: Colors.brown[900],
                              ),
                              onPressed: () {
                                _deleteTask(index);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
              ),
            ],
          ),
          Expanded(
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: BottomNav(
                selectedTab: 2,
              ),
            ),
          ),
        ]));
  }

  void _deleteTask(index) async {
    setState(() {
      _tasks.removeAt(index);
    });
    var db = DatabaseService();
    await db.deleteTask(index + 1);
  }

  void _insertTask() async {
    var db = DatabaseService();
    var task = Task();
    task.title = _title;
    await db.insertTask(task);
    setState(() {
      _tasks.add(task);
      Navigator.pop(context);
    });
  }

  void _initTasks() async {
    var db = DatabaseService();
    var tasks = await db.tasks();
    setState(() {
      _tasks = tasks;
    });
  }
}
