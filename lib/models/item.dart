class Item {
  String title;
  bool done;

  Item({this.title, this.done});

  Item.fromJson(Map<String, dynamic> obj) {
    title = obj['title'];
    done = obj['done'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> obj = new Map<String, dynamic>();

    obj['title'] = this.title;
    obj['done'] = this.done;

    return obj;
  }
}
