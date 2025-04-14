 import 'package:flutter/material.dart';
import 'package:to_do_app/core/features/todo/archive/archive_screen.dart';
import 'package:to_do_app/core/features/todo/done/done_screen.dart';
import 'package:to_do_app/core/features/todo/new/new_screen.dart';

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

class _TodoAppState extends State<TodoApp> {
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
      floatingActionButton: FloatingActionButton(onPressed: () /*async*/
      {
       /*try{
         var name = await printName();
         print(name);
         print('shahd');
         throw('error');
       } catch(error){
         print(error);
       }*/
        printName().then((value){
          print(value);
        }).catchError((error){
          print(error.toString());
        });
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
Future<String> printName() async {
  return('shgot7');
}

