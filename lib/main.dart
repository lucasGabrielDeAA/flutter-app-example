import 'package:flutter/material.dart';

import 'models/item.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  var items = new List<Item>();

  HomePage() {
    items = [];

    items.add(Item(title: "Item 1", done: false));
    items.add(Item(title: "Item 2", done: false));
    items.add(Item(title: "Item 3", done: true));
    items.add(Item(title: "Item 4", done: true));
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var newTaskTitleController = TextEditingController();

  void add() {
    if (newTaskTitleController.text.isEmpty) return;
    
    setState(() {
      widget.items.add(Item(title: newTaskTitleController.text, done: false));
      newTaskTitleController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          controller: newTaskTitleController,
          keyboardType: TextInputType.text,
          style: TextStyle(
            color: Colors.white,
          ),
          decoration: InputDecoration(
            labelText: "New task's title",
            labelStyle: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: widget.items.length,
        itemBuilder: (context, index) {
          final item = widget.items[index];

          return CheckboxListTile(
            title: Text(item.title),
            key: Key(item.title),
            value: item.done,
            onChanged: (value) {
              setState(() {
                item.done = value;
              });
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: add,
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}
