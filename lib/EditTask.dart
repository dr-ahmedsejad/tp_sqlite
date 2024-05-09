import 'package:flutter/material.dart';
import 'BD.dart';
class EditTask extends StatefulWidget {
  final Map task;

  EditTask({required this.task});

  @override
  _EditTaskState createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  TextEditingController _taskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _taskController.text = widget.task['task'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modifier une tâche'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _taskController,
              decoration: InputDecoration(labelText: 'Tâche'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Modifier_task();
              },
              child: Text('Modifier'),
            ),
          ],
        ),
      ),
    );
  }

  void Modifier_task() async {
    String sql = "UPDATE tasks SET task = '${_taskController.text}' WHERE id = ${widget.task['id']}";
    await BD().Modifier(sql);
    Navigator.pop(context);
  }
}