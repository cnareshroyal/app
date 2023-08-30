import 'package:flutter/material.dart';

void main() {
  runApp(TodoApp());
}

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do List App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: TodoListScreen(),
    );
  }
}

class Todo {
  String task;
  String time;
  bool isCompleted;
  DateTime? completionDate;

  Todo({
    required this.task,
    required this.time,
    this.isCompleted = false,
    this.completionDate,
  });
}

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  List<Todo> todos = [];

  void _addTodo() async {
    final todo = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddTodoScreen()),
    );
    if (todo != null) {
      setState(() {
        todos.add(todo);
      });
    }
  }

  void _updateTodo(int index) async {
    final updatedTodo = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => EditTodoScreen(todo: todos[index])),
    );
    if (updatedTodo != null) {
      setState(() {
        todos[index] = updatedTodo;
      });
    }
  }

  void _deleteTodo(int index) {
    setState(() {
      todos.removeAt(index);
    });
  }

  void _completeTodo(int index) {
    setState(() {
      todos[index].isCompleted = true;
      todos[index].completionDate = DateTime.now();
    });
  }

  List<Todo> get completedTodos =>
      todos.where((todo) => todo.isCompleted).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do List'),
        actions: [
          IconButton(
            onPressed: () {
              showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );
            },
            icon: Icon(Icons.calendar_today),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(todos[index].task),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(todos[index].time),
                if (todos[index].isCompleted &&
                    todos[index].completionDate != null)
                  Text(
                      'Completed on: ${todos[index].completionDate!.toString()}'),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () => _updateTodo(index),
                  icon: Icon(Icons.edit),
                ),
                IconButton(
                  onPressed: () => _deleteTodo(index),
                  icon: Icon(Icons.delete),
                ),
                if (!todos[index].isCompleted)
                  IconButton(
                    onPressed: () => _completeTodo(index),
                    icon: Icon(Icons.check_circle),
                  ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTodo,
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'All',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check),
            label: 'Completed',
          ),
        ],
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      CompletedTodosScreen(completedTodos: completedTodos)),
            );
          }
        },
      ),
    );
  }
}

class AddTodoScreen extends StatefulWidget {
  @override
  _AddTodoScreenState createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  late String task;
  late String time;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Task'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onChanged: (value) {
                task = value;
              },
              decoration: InputDecoration(
                hintText: 'Task',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              onChanged: (value) {
                time = value;
              },
              decoration: InputDecoration(
                hintText: 'Time',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                if (task.isNotEmpty && time.isNotEmpty) {
                  Navigator.pop(
                    context,
                    Todo(
                      task: task,
                      time: time,
                    ),
                  );
                }
              },
              child: Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}

class EditTodoScreen extends StatefulWidget {
  final Todo todo;

  EditTodoScreen({required this.todo});

  @override
  _EditTodoScreenState createState() => _EditTodoScreenState();
}

class _EditTodoScreenState extends State<EditTodoScreen> {
  late String task;
  late String time;

  @override
  void initState() {
    super.initState();
    task = widget.todo.task;
    time = widget.todo.time;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Task'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: TextEditingController(text: task),
              onChanged: (value) {
                task = value;
              },
              decoration: InputDecoration(
                hintText: 'Task',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: TextEditingController(text: time),
              onChanged: (value) {
                time = value;
              },
              decoration: InputDecoration(
                hintText: 'Time',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                if (task.isNotEmpty && time.isNotEmpty) {
                  Navigator.pop(
                    context,
                    Todo(
                      task: task,
                      time: time,
                      isCompleted: widget.todo.isCompleted,
                      completionDate: widget.todo.completionDate,
                    ),
                  );
                }
              },
              child: Text('Update'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}

class CompletedTodosScreen extends StatelessWidget {
  final List<Todo> completedTodos;

  CompletedTodosScreen({required this.completedTodos});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Completed Tasks'),
      ),
      body: ListView.builder(
        itemCount: completedTodos.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(completedTodos[index].task),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(completedTodos[index].time),
                Text(
                    'Completed on: ${completedTodos[index].completionDate!.toString()}'),
              ],
            ),
          );
        },
      ),
    );
  }
}
