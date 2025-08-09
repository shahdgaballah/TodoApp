import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:to_do_app/core/layout/todo/controller/state.dart';

import '../../../features/todo/archive/archive_screen.dart';
import '../../../features/todo/done/done_screen.dart';
import '../../../features/todo/new/new_screen.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  Database? database;
  List<BottomNavigationBarItem> items = [
    BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'New'),
    BottomNavigationBarItem(icon: Icon(Icons.check_box), label: 'Done'),
    BottomNavigationBarItem(icon: Icon(Icons.archive), label: 'Archived'),
  ];
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archiveTasks = [];
  int currentIndex = 0;
  List<Widget> screens = [NewScreen(), DoneScreen(), ArchiveScreen()];
  List<String> titles = ['New', 'Done', 'Archive'];
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  bool isBottomShow = false;
  IconData fabIcon = Icons.edit;
  var titleController = TextEditingController();
  var dateController = TextEditingController();
  var timeController = TextEditingController();

  void changeFabIcon({required bool isShow, required IconData icon}) {
    isBottomShow = isShow;
    fabIcon = icon;
    emit(AppChangeFabIconState());
  }

  void changeBottomNav(index) {
    currentIndex = index;
    emit(AppChangeBottomNavState());
  }

  void createDataFromDatabase() async {
    var databasesPath = await getDatabasesPath();
    String path = p.join(databasesPath, 'tasks.db');
    openDataFromDatabase(path: path);
    emit(AppCreateDataFromDatabaseState());
  }

  void openDataFromDatabase({required String path}) async {
    await openDatabase(
      path,
      version: 1,
      onCreate: (Database database, int version) async {
        debugPrint('Database created');
        await database
            .execute(
          'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)',
        )
            .then((value) {
          debugPrint('Table created');
        })
            .catchError((error) {
          debugPrint('Error When Table Opened ${error.toString()}');
        });
      },
      onOpen: (database) {
        getDataFromDatabase(database);
        debugPrint('Database opened');
        emit(AppOpenDataFromDatabaseState());
      },
    ).then((value) {
      database = value;
    });
  }

  void insertDataFromDatabase({
    required String title,
    required String date,
    required String time,
  }) async {
    await database!.transaction((txn) async {
      txn
          .rawInsert(
        'INSERT INTO tasks(title, date, time, status) VALUES("$title", "$date", "$time", "new")',
      )
          .then((value) {
        getDataFromDatabase(database);
        debugPrint('$value inserted Successfully');
        titleController.clear();
        timeController.clear();
        dateController.clear();
        emit(AppInsertDataFromDatabaseState());
      })
          .catchError((error) {
        debugPrint('Error when insert new record ${error.toString()}');
      });
    });
  }

  void getDataFromDatabase(database) async {
    newTasks = [];
    doneTasks = [];
    archiveTasks = [];
    await database.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new') {
          newTasks.add(element);
        } else if (element['status'] == 'done') {
          doneTasks.add(element);
        } else {
          archiveTasks.add(element);
        }
      });
      emit(AppGetDataFromDatabaseState());
    });
  }

  void updateDateFromDatabase({required String status, required int id}) async {
    await database!
        .rawUpdate('UPDATE tasks SET status = ? WHERE id = ?', [status, id])
        .then((value) {
      getDataFromDatabase(database);
      emit(AppUpdateDataFromDatabaseState());
    });
  }

  void deleteDataFromDatabase({required int id}) async {
    await database!
        .rawDelete('DELETE FROM tasks WHERE id = ?', [id])
        .then((value) {
      getDataFromDatabase(database);
      emit(AppDeleteDataFromDatabaseState());
    });
  }
}