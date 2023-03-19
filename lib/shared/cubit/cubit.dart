import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

import 'package:to_do/shared/cubit/states.dart';

import '../../modules/archived_tasks/archived_task_screen.dart';
import '../../modules/done_tasks/done_task_screen.dart';
import '../../modules/new_tasks/new_task_screen.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  // To Get An Object Of My Cubit For Easy Use AnyWhere
  static AppCubit getCubitObject(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<String> screensTitles = [
    'New Task',
    'Done Tasks',
    'Archived Tasks',
  ];
  List<Widget> screens = [
    const NewTaskScreen(),
    const DoneTaskScreen(),
    const ArchivedTaskScreen(),
  ];

  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  Database? database;

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isBottomSheetShown = false;

  TextEditingController taskTitleController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  //============== For Toggling Among Bottom Nav Bar Items ==============
  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavState());
  }

  //============== To Close Or Open The Bottom Sheet ==============
  void changeBottomSheetStatus(bool isBottomSheetDisplayed) {
    isBottomSheetShown = isBottomSheetDisplayed;
    emit(AppChangeBottomSheetState());
  }

  //============== For Creating A Local Database ==============
  void createDB() {
    openDatabase(
      // Database Name
      'todo.db',
      // Database Version
      version: 1,
      onCreate: (database, version) async {
        print("Database created");
        await database.execute(
            "CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)");
      },
      onOpen: (database) {
        // Get Data After Opening The Database
        getDataFromDatabase(database);
        print("Database opened");
      },
    ).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

  //============== For Updating Data In Database ==============
  void updateData({
    required String status,
    required int id,
  }) {
    database!.rawUpdate(
      'UPDATE tasks SET status = ? WHERE id = ?',
      [status, id],
    ).then((value) {
      // Getting Data After Updating The Database
      getDataFromDatabase(database!);
      emit(AppUpdateDatabaseState());
    });
  }

  //============== For Deleting Data From Database ==============
  void deleteData({
    required int id,
  }) {
    database!.rawDelete(
      'DELETE FROM tasks WHERE id = ?',
      [id],
    ).then((value) {
      // Getting Data After Deleting Something From The Database
      getDataFromDatabase(database!);
      emit(AppDeleteDatabaseState());
    });
  }

  //============== For Inserting Data Into Database ==============
  insertIntoDB({
    required String title,
    required String time,
    required String date,
  }) async {
    await database!.transaction((txn) {
      return txn
          .rawInsert(
        'INSERT INTO tasks(title, date, time, status) VALUES("$title", "$date", "$time", "new")',
      )
          .then(
        (value) {
          print("$value INSERTED SUCCESSFULLY");
          emit(AppInsertDatabaseState());

          // Getting Data After Inserting A New Record In Database
          getDataFromDatabase(database!);
        },
      ).catchError(
        (error) {
          print("Error when inserting new record: $error");
        },
      );
    });
  }

  //============== For Getting Data From Database ==============
  void getDataFromDatabase(Database database) {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];

    emit(AppGetDatabaseLoadingState());
    database.rawQuery('SELECT * FROM tasks').then((value) {
      // A Loop For Filtering Tasks According To Its Status
      for (var element in value) {
        if (element['status'] == 'new')
          newTasks.add(element);
        else if (element['status'] == 'done')
          doneTasks.add(element);
        else
          archivedTasks.add(element);
      }
      emit(AppGetDatabaseState());
    });
  }
}
