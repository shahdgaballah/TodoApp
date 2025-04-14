 import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_app/core/features/todo/archive/archive_screen.dart';
import 'package:to_do_app/core/features/todo/done/done_screen.dart';
import 'package:to_do_app/core/features/todo/new/new_screen.dart';
import 'package:path/path.dart' as p;

class TodoApp extends StatefulWidget {
  const TodoApp({super.key});

  @override
  State<TodoApp> createState() => _TodoAppState();
}

List<BottomNavigationBarItem> items = [
  BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'New'),
  BottomNavigationBarItem(icon: Icon(Icons.check_box), label: 'Done'),
  BottomNavigationBarItem(icon: Icon(Icons.archive), label: 'Archived'),
];

int currentIndex = 0;

List<Widget>screens =[
  NewScreen(),
  DoneScreen(),
  ArchiveScreen(),
];

List<String>titles=[
  'New Tasks',
  'Done Tasks ',
  'Archived Tasks'
];

Database? database; //declaring the database

class _TodoAppState extends State<TodoApp> {
  @override
  void initState() {
    createDataFromDatabase();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        backgroundColor: Colors.teal,
        title: Text(titles[currentIndex],
          style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold, color: Colors.amber
        ),),
      ),
      bottomNavigationBar: BottomNavigationBar(items: items,
        //backgroundColor: Colors.white,
        currentIndex: currentIndex,
        onTap: (index){
        setState(() {
          currentIndex = index;
        });
        },
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,

      ),
      floatingActionButton: FloatingActionButton(onPressed: ()
      {
       insertDataFromDatabase();
      },
        backgroundColor: Colors.teal,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0)
        ),

      child: Icon(Icons.add, color: Colors.amber,),
      ),
      body: screens[currentIndex],
    );
  }
}

void createDataFromDatabase() async{
  // Get a location using getDatabasesPath
  var databasesPath = await getDatabasesPath();
  String path = p.join(databasesPath, 'tasks.db');
  openDataFromDatabase(path: path); // to make the path work/used
 }

 void openDataFromDatabase( {
   required String path,
 } ) async{
   // open the database

    await openDatabase(
       path,
       version: 1, //object of database
       onCreate: (Database database, int version) async {
         debugPrint('Database created');
         await database.execute(
             'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)',
          ).then((value){
           debugPrint('Table created');
         })
             .catchError((error){
           debugPrint('Error when table created');
         });

       },
     onOpen: (database){
       debugPrint('Database opened');
     },
       ).then((value){
         database = value;
    });

 }

 void insertDataFromDatabase()async{
   await database!.transaction((txn) async {
     txn.rawInsert(
         'INSERT INTO tasks(title, date, time, status) VALUES("some name", "1234", "456.789", "new")');
   }).then((value){
     debugPrint('${value} inserted successfully');
   })
       .catchError((error){
         debugPrint('Error when inserting new record ${error.toString()}');
   });


 }
