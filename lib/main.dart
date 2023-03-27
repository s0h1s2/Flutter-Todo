import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class TodoItem {
  String text;
  bool isCompleted;
  int id;
  TodoItem(this.text, this.isCompleted, this.id);
}

class Todos {
  List<TodoItem> todos = [];
  void addTodo(String text) {
    this.todos.add(new TodoItem(text, false, this.todos.length));
  }

  List<TodoItem> getCompletedTodos() {
    return this.todos.where((todo) => todo.isCompleted == true).toList();
  }

  List<TodoItem> getTodos() {
    return this.todos.where((todo) => todo.isCompleted == false).toList();
  }

  void finishTodo(int id) {
    if (id < this.todos.length) {
      this.todos[id].isCompleted = true;
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Todo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: DefaultTabController(
          length: 2, child: MyHomePage(title: 'Flutter Demo Home Page')),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.title});

  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Todos todos = new Todos();
  String todoTextValue = "";
  @override
  void initState() {
    super.initState();
    this.todos = new Todos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () => showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                          title: Text("What Todo?"),
                          content: TextField(
                              onChanged: (newText) {
                                this.todoTextValue = newText;
                              },
                              decoration: InputDecoration(hintText: "todo?")),
                          actions: <Widget>[
                            TextButton(
                                child: Text("Cancel"),
                                onPressed: () {
                                  print("Cancel");
                                  Navigator.pop(context, "Pop");
                                }),
                            TextButton(
                                child: Text("Add"),
                                onPressed: () {
                                  if (!this.todoTextValue.isEmpty) {
                                    this.todos.addTodo(this.todoTextValue);
                                  }
                                  setState(() {});
                                  Navigator.pop(context, "OK");
                                })
                          ])).then((val) {
                this.todoTextValue = "";
              }),
          child: Icon(Icons.add)),
      appBar: AppBar(
          bottom: TabBar(
        tabs: [
          Tab(text: "Todo"),
          Tab(
            text: "Completed",
          ),
        ],
      )),
      body: TabBarView(
        children: [
          ListView(padding: const EdgeInsets.all(8), children: <Widget>[
            for (TodoItem todo in this.todos.getTodos())
              CheckboxListTile(
                  title: Text(todo.text),
                  value: false,
                  onChanged: (bool? value) {
                    this.todos.finishTodo(todo.id);
                    setState(() {});
                  })
          ]),
	  ListView(
		  padding:const EdgeInsets.all(8),children:<Widget>[
	  for(TodoItem todo in this.todos.getCompletedTodos())
	    	Text(todo.text,style:TextStyle(fontSize:16)),
		  ])
        ],
      ),
    );
  }
}
