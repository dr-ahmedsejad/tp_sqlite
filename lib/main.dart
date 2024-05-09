// -*- coding: utf-8 -*-

import 'package:flutter/material.dart';
import 'EditTask.dart';
import 'BD.dart';

void main()  {

  runApp(MaterialApp(
    home: TaskList(),
  ));
}

class TaskList extends StatefulWidget {
  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  final BD bd = BD();
  List<Map> tasks = [];
  bool isLoading = true; // Ajout de l'état isLoading

  TextEditingController _taskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }


  void _loadTasks() async {
    setState(() {
      isLoading = true; // Début du chargement
    });

    List<Map> data = await bd.Afficher("SELECT * FROM tasks order by id desc");

    setState(() {
      tasks = data;
      isLoading = false; // Fin du chargement
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste de tâches'),
        backgroundColor: Colors.blue,
      ),
      body:isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text('Tâche ${tasks[index]['id']}'),
              subtitle: Text(tasks[index]['task']),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Aller_vers_EditScreen(tasks[index]);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      Alert_suppression(tasks[index]);
                    },
                  ),
                  Checkbox(
                    value: tasks[index]['completed'] == 1,
                    onChanged: (bool? value) {
                      // Mettez à jour la tâche comme terminée ou non
                      Modifier_task_status(tasks[index], value);
                    },
                  )
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Dialog_ajouter_task();
        },
        child: Icon(Icons.add,color: Colors.white),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void Aller_vers_EditScreen(Map task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditTask(task: task),
      ),
    ).then((value) {
      _loadTasks();
    });
  }

  void Alert_suppression(Map task) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Supprimer la tâche'),
          content: Text('Êtes-vous sûr(e) de vouloir supprimer cette tâche ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                Supprimer_task(task);
                Navigator.pop(context);
              },
              child: Text('Supprimer'),
            ),
          ],
        );
      },
    );
  }

  void Supprimer_task(Map task) async {
    String sql = "DELETE FROM tasks WHERE id = ${task['id']}";
    await bd.Supprimer(sql);
    _loadTasks();
  }

  void Dialog_ajouter_task() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ajouter une tâche'),
          content: TextField(
            controller: _taskController,
            decoration: InputDecoration(labelText: 'Tâche'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                Ajouter_task();
                Navigator.pop(context);
              },
              child: Text('Ajouter'),
            ),
          ],
        );
      },
    );
  }

  void Ajouter_task() async {
    String taskText = _taskController.text;
    String sql = "INSERT INTO tasks (task) VALUES ('$taskText')";
    await bd.Ajouter(sql);
    _taskController.clear();
    _loadTasks();
  }

  void Modifier_task_status(Map task, bool? completed) async {
    int completedValue = completed! ? 1 : 0;
    String sql = "UPDATE tasks SET completed = $completedValue WHERE id = ${task['id']}";
    await bd.Modifier(sql);
    _loadTasks();
  }

}
