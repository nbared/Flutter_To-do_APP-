import 'package:flutter/material.dart';
import 'new_item_view.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<ToDo> list = List<ToDo>();

  @override
  void initState() {
    list.add(ToDo(title: 'Learn dart fundamentals'));
    list.add(ToDo(title: 'set up mobile development environment'));
    list.add(ToDo(title: 'build flutter To-do list app'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My To-Do List'),
        centerTitle: true,
      ),
      body: list.isNotEmpty ? buildBody() : buildEmptyBody(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => goToNewItemView(),
      ),
    );
  }


  Widget buildBody() {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        return buildItem(list[index]);
      },
    );
  }

  Widget buildEmptyBody(){
    return Center (
      child: Text('No items'),
    );
  }

  Widget buildItem(ToDo item) {
    return Dismissible(
      key: Key(item.hashCode.toString()),
      onDismissed: (direction) => removeItem(item),
      direction: DismissDirection.startToEnd,
      background: Container(
        color: Colors.red[600],
        child: Icon(Icons.delete, color: Colors.white),
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 14.0),
      ),
      child: buildListTile(item),
    );
  }

  Widget buildListTile(ToDo item){
    return ListTile(
      title: Text(item.title),
      trailing: Checkbox(value: item.complete, onChanged: null),
      onTap: () => setCompleteness(item),
      onLongPress: ()=> goToEditItemView(item),
    );
  }

  void goToNewItemView(){
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context){
          return NewItemView();
        }
    )).then((title) {
      if(title != null)
        addToDo(ToDo(title: title));
    });
  }

  void goToEditItemView(ToDo item){
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context){
          return NewItemView(title: item.title);
        }
    )).then((title){
      if (title != null) editToDo(item, title);
    });
  }


  void setCompleteness(ToDo item) {
    setState(() {
      item.complete = !item.complete;
    });
  }

  void removeItem(ToDo item){

    list.remove(item);
    if (list.isEmpty) setState(() {

    });
  }
  void addToDo(ToDo item){
    list.add(item);
  }
  void editToDo(ToDo item, String title){
    item.title = title;
  }
}

class ToDo {
  String title;
  bool complete;

  ToDo({
    this.title,
    this.complete = false,
  });
}
