import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      save();
    });
  }

  void remove(int index) {
    setState(() {
      widget.items.removeAt(index);
    });
    save();
  }

  Future loadData() async {
    var preferences = await SharedPreferences.getInstance();
    var list = preferences.getString('todoList@items');

    if (list != null) {
      Iterable listDecoded = jsonDecode(list);
      List<Item> result = listDecoded.map((item) => Item.fromJson(item)).toList();
      
      setState(() {
        widget.items = result;
      });
    }
  }

  save() async {
    var preferences = await SharedPreferences.getInstance();
    await preferences.setString('todoList@items', jsonEncode(widget.items));
  }

  _HomePageState() {
    loadData();
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

          return Dismissible(
            key: Key(item.title),
            child: CheckboxListTile(
              title: Text(item.title),
              value: item.done,
              onChanged: (value) {
                setState(() {
                  item.done = value;
                  save();
                });
              },
            ),
            background: Container(
              color: Colors.red.withOpacity(0.4),
              child: Icon(Icons.delete),
            ),
            onDismissed: (direction) {
              if (direction == DismissDirection.endToStart) {
                remove(index);
              }
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
