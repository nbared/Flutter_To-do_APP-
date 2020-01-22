import 'package:flutter/material.dart';
import 'new_item_view.dart';
import 'package:provider/provider.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<List>(
      create: (_) => List(),
//      dispose: (_, list) => list.dispose(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
        ),
        home: HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<ToDo> list = List<ToDo>();
  List<ToDo> completed = List<ToDo>();
  @override
  void initState() {
    list.add(ToDo(title: 'Learn Dart'));
    list.add(ToDo(title: 'build flutter To-do list app'));
    list.add(ToDo(title: 'die'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My To-Do List'),
        centerTitle: true,
      ),
      body: list.isNotEmpty ? Column(
          children: <Widget>[
            buildToDo(),
            completed.isNotEmpty ?
            buildDone() : buildEmpty(),
          ])
          : Column(
            children: <Widget>[
              buildEmptyBody(),
              buildDone()
            ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => goToNewItemView(),
      ),
      backgroundColor: Colors.grey[700],
    );
  }
  Widget buildToDo(){
    return Flexible(
      fit: FlexFit.loose,
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
              color: Colors.grey[300],
              width: 10000,
              child: Column (
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 8.0, 280, 8.0),
                      child: Text('Active:',
                      style: TextStyle(
                      color: Colors.black,
                      fontSize: 24.0,
                      letterSpacing: 2.0,
                        fontWeight: FontWeight.bold
                  ),
                  ),
                    ),
               buildList(),
          ],
        )
    ),
      ));
  }

  Widget buildList() {
    return Expanded(
      child: SizedBox(
        height: 200.0,
        child: ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
            return buildToDoItem(list[index]);
          },
        ),
      ),
    );

  }

  Widget buildDone() {
    return Flexible(
        fit: FlexFit.loose,
        flex: 1,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15.0, 15.0,15.0, 40.0),
          child: Container(
              color: Colors.grey[300],
              width: 10000,
              child: Column (
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 8.0, 220, 8.0),
                    child: Text('Completed:',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 24.0,
                          letterSpacing: 2.0,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  buildCompletedList(),
                ],
              )
          ),
        ));
  }

  Widget buildEmpty(){
    return SizedBox(
        height: 300.0,
        child: Text('No Completed Tasks:'),
        );
  }

  Widget buildCompletedList() {
    return Expanded(
      child: SizedBox(
        height: 200.0,
        child: ListView.builder(
          itemCount: completed.length,
          itemBuilder: (context, index) {
            return buildCompletedItem(completed[index]);
          },
        ),
      ),
    );
  }

  Widget buildEmptyBody(){
    return SizedBox(
        height: 200.0,
        child: Text('No active items')
    );
  }

  Widget buildToDoItem(ToDo item) {
    return Dismissible(
      key: Key(item.hashCode.toString()),
      onDismissed: (direction) => removeItem(item),
      direction: DismissDirection.startToEnd,
      background: Container(
        color: Colors.lightGreenAccent,
        child: Icon(Icons.check, color: Colors.white),
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 14.0),
      ),
      child: buildListTile(item),
    );
  }


  Widget buildCompletedItem(ToDo item) {
    return Dismissible(
      key: Key(item.hashCode.toString()),
      onDismissed: (direction) => reAddItem(item),
      direction: DismissDirection.startToEnd,
      background: Container(
        color: Colors.red,
        child: Icon(Icons.undo, color: Colors.white),
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 14.0),
      ),
      child: buildListTile(item),
    );
  }

  Widget buildListTile(ToDo item){
    return ListTile(
      title: Text(
        item.title,
        style: TextStyle(
          color: Colors.deepOrange
        ),
      ),
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
      setState(() {
      list.remove(item);
      item.complete = true;
      completed.add(item);
    });
  }

  void reAddItem(ToDo item){
      setState(() {
        completed.remove(item);
        item.complete = false;
        list.add(item);
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
