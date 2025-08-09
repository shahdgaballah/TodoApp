import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../shared/widgets/my_form_field.dart';
import 'controller/cubit.dart';
import 'controller/state.dart';

class TodoApp extends StatefulWidget {
  const TodoApp({super.key});

  @override
  State<TodoApp> createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  bool isDarkMode = false;

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: BlocProvider(
        create: (BuildContext context) => AppCubit()..createDataFromDatabase(),
        child: BlocConsumer<AppCubit, AppStates>(
          listener: (context, state) {
            if(state is AppInsertDataFromDatabaseState){
              Navigator.pop(context);
            }
          },
          builder: (context, state) {
            var cubit = AppCubit.get(context);
            return Scaffold(
              key: cubit.scaffoldKey,
              appBar: AppBar(
                titleSpacing: 20.0,
                automaticallyImplyLeading: false,
                backgroundColor: isDarkMode ? Theme.of(context).scaffoldBackgroundColor : Colors.teal,
                title: Text(
                  cubit.titles[cubit.currentIndex],
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.amber,
                  ),
                ),
                actions: [
                  Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.white.withValues(alpha: 0.1) : Colors.amber.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        isDarkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                        color: isDarkMode ? Colors.white : Colors.amber,
                        size: 20,
                      ),
                      onPressed: toggleTheme,
                    ),
                  ),
                ],
              ),
              bottomNavigationBar: BottomNavigationBar(
                items: cubit.items,
                currentIndex: cubit.currentIndex,
                onTap: (index) {
                  cubit.changeBottomNav(index);
                },
                selectedItemColor: isDarkMode ? Colors.white : Colors.amber,
                unselectedItemColor: isDarkMode ? Colors.grey : Colors.amber,
                type: BottomNavigationBarType.fixed,
                backgroundColor: isDarkMode ? Theme.of(context).scaffoldBackgroundColor : Colors.teal,
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  if (cubit.isBottomShow) {
                    if (cubit.formKey.currentState!.validate()) {
                      cubit.insertDataFromDatabase(
                        title: cubit.titleController.text,
                        date: cubit.dateController.text,
                        time: cubit.timeController.text,
                      );
                      cubit.changeFabIcon(isShow: false, icon: Icons.edit);
                    }
                  } else {
                    cubit.scaffoldKey.currentState!
                        .showBottomSheet(
                          (context) => Container(
                        padding: EdgeInsets.all(20.0),
                        color: isDarkMode ? Colors.grey[800] : Colors.grey[300],
                        child: SingleChildScrollView(
                          child: Form(
                            key: cubit.formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                MyFormField(
                                  controller: cubit.titleController,
                                  type: TextInputType.text,
                                  prefix: Icons.title,
                                  text: 'title',
                                  radius: 10.0,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Title must be not empty';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 20.0),
                                MyFormField(
                                  controller: cubit.dateController,
                                  type: TextInputType.datetime,
                                  prefix: Icons.calendar_today,
                                  text: 'date',
                                  radius: 10.0,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Date must be not empty';
                                    }
                                    return null;
                                  },
                                  onTap: () {
                                    FocusScope.of(
                                      context,
                                    ).requestFocus(FocusNode());
                                    showDatePicker(
                                      context: context,
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.parse('2025-12-31'),
                                    ).then((value) {
                                      if (value != null) {
                                        cubit.dateController.text =
                                            DateFormat.yMMMd().format(value);
                                        debugPrint(
                                          DateFormat.yMMMd().format(value),
                                        );
                                      }
                                    });
                                  },
                                ),
                                SizedBox(height: 20.0),
                                MyFormField(
                                  controller: cubit.timeController,
                                  type: TextInputType.datetime,
                                  prefix: Icons.watch_later_outlined,
                                  text: 'time',
                                  radius: 10.0,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Time must be not empty';
                                    }
                                    return null;
                                  },
                                  onTap: () {
                                    FocusScope.of(
                                      context,
                                    ).requestFocus(FocusNode());
                                    showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    ).then((value) {
                                      if (value != null) {
                                        if (context.mounted) {
                                          cubit.timeController.text = value
                                              .format(context);
                                        }
                                      }
                                    });
                                  },
                                ),
                                SizedBox(height: 20.0),
                                ElevatedButton(
                                  onPressed: () {
                                    if (cubit.formKey.currentState!.validate()) {
                                      cubit.insertDataFromDatabase(
                                        title: cubit.titleController.text,
                                        date: cubit.dateController.text,
                                        time: cubit.timeController.text,
                                      );
                                      Navigator.pop(context);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: isDarkMode ? Colors.grey[900] : Colors.teal,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                                  ),
                                  child: Text(
                                    'Add Task',
                                    style: TextStyle(
                                      color: isDarkMode ? Colors.white : Colors.amber,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                },
                backgroundColor: isDarkMode ? Colors.grey[900] : Colors.teal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Icon(cubit.isBottomShow ? Icons.add : Icons.edit, color: isDarkMode ? Colors.white : Colors.amber),
              ),
              body: cubit.screens[cubit.currentIndex],
            );
          },
        ),
      ),
    );
  }
}