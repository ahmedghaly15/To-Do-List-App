import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:to_do/shared/cubit/cubit.dart';
import 'package:to_do/shared/cubit/states.dart';

import '../shared/components.dart';

class Tabs extends StatelessWidget {
  const Tabs({super.key});

  @override
  Widget build(BuildContext context) {
    //================ For Making App Responsive ================
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return BlocProvider(
      //================ Creating My Cubit ================
      create: (BuildContext context) => AppCubit()..createDB(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state) {
          // to close the bottom sheet after insertToDB() is finished
          if (state is AppInsertDatabaseState) Navigator.pop(context);
        },

        //================ Building The UI ================
        builder: (BuildContext context, AppStates state) {
          AppCubit cubit = AppCubit.getCubitObject(context);
          return Scaffold(
            backgroundColor: Colors.white,
            key: cubit.scaffoldKey,
            appBar: AppBar(
              title: Text(
                cubit.screensTitles[cubit.currentIndex],
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              elevation: 0,
              centerTitle: true,
              backgroundColor: Colors.white,
            ),
            body: ConditionalBuilder(
              condition: state is! AppGetDatabaseLoadingState,
              builder: (BuildContext context) =>
                  cubit.screens[cubit.currentIndex],
              fallback: (context) => const Center(
                child: CircularProgressIndicator(),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isBottomSheetShown) {
                  // Closing the bottom sheet & isBottomSheet = false
                  Navigator.pop(context);
                  cubit.changeBottomSheetStatus(false);
                } else {
                  cubit.scaffoldKey.currentState!
                      .showBottomSheet(
                        (context) => Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.02,
                            vertical: screenHeight * 0.04,
                          ),
                          width: screenWidth,
                          height: screenHeight * 0.3,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(screenHeight * 0.025),
                              topRight: Radius.circular(screenHeight * 0.025),
                            ),
                            color: Colors.white,
                          ),
                          //================ Creating A New Task Form ================
                          child: Form(
                            key: cubit.formKey,
                            child: Column(
                              children: <Widget>[
                                //========== Task Title ==========
                                buildTextFormField(
                                  context: context,
                                  hint: "Type a task...",
                                  controller: cubit.taskTitleController,
                                  keyboardType: TextInputType.text,
                                  capitalization: TextCapitalization.sentences,
                                  enableSuggestions: true,
                                  icon: const Icon(
                                    Icons.title,
                                    color: Colors.blue,
                                    size: 28,
                                  ),
                                  validating: (val) {
                                    if (val!.isEmpty) {
                                      return "Task is required";
                                    }
                                    return null;
                                  },
                                ),

                                // For Adding Some Space
                                SizedBox(height: screenHeight * 0.02),

                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: buildTextFormField(
                                        context: context,
                                        controller: cubit.timeController,
                                        //========== Task Time ==========
                                        hint: "Task time",
                                        keyboardType: TextInputType.none,
                                        capitalization: TextCapitalization.none,
                                        enableSuggestions: false,
                                        icon: const Icon(
                                          Icons.watch_later_outlined,
                                          color: Colors.blue,
                                          size: 28,
                                        ),
                                        validating: (val) {
                                          if (val!.isEmpty) {
                                            return "Time is required";
                                          }
                                          return null;
                                        },
                                        onTap: () {
                                          showTimePicker(
                                                  context: context,
                                                  initialTime: TimeOfDay.now())
                                              .then((value) {
                                            cubit.timeController.text =
                                                value!.format(context);
                                          });
                                        },
                                      ),
                                    ),

                                    // For Adding Some Space
                                    SizedBox(width: screenWidth * 0.03),

                                    Expanded(
                                      //========== Task Date ==========
                                      child: buildTextFormField(
                                        context: context,
                                        controller: cubit.dateController,
                                        hint: "Task date",
                                        keyboardType: TextInputType.none,
                                        capitalization: TextCapitalization.none,
                                        enableSuggestions: false,
                                        icon: const Icon(
                                          Icons.calendar_today_outlined,
                                          color: Colors.blue,
                                          size: 28,
                                        ),
                                        validating: (val) {
                                          if (val!.isEmpty) {
                                            return "Date is required";
                                          }
                                          return null;
                                        },
                                        onTap: () {
                                          showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now(),
                                            lastDate:
                                                DateTime.parse('2030-12-03'),
                                          ).then((value) {
                                            cubit.dateController.text =
                                                DateFormat.yMMMd()
                                                    .format(value!);
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),

                                // For Adding Some Space
                                SizedBox(height: screenHeight * 0.02),

                                //================ Add A New Task Button ================
                                ElevatedButton(
                                  onPressed: () {
                                    if (cubit.formKey.currentState!
                                        .validate()) {
                                      cubit.insertIntoDB(
                                        title: cubit.taskTitleController.text,
                                        time: cubit.timeController.text,
                                        date: cubit.dateController.text,
                                      );
                                    }
                                  },
                                  style: ButtonStyle(
                                    padding: MaterialStateProperty.all(
                                      EdgeInsets.symmetric(
                                        horizontal: screenWidth * 0.25,
                                        vertical: screenHeight * 0.02,
                                      ),
                                    ),
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                      Radius.circular(screenWidth * 0.03),
                                    ))),
                                    textStyle: MaterialStateProperty.all(
                                      const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  child: const Text("ADD TASK"),
                                )
                              ],
                            ),
                          ),
                        ),
                        elevation: 25,
                      )
                      .closed
                      .then((value) {
                    cubit.changeBottomSheetStatus(false);
                  });

                  cubit.changeBottomSheetStatus(true);
                }
              },
              child: cubit.isBottomSheetShown
                  ? const Icon(
                      Icons.close,
                      size: 25,
                    )
                  : const Icon(
                      Icons.edit_outlined,
                      size: 25,
                    ),
            ),

            //================ Creating A Bottom Nav Bar ================
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.currentIndex,
              type: BottomNavigationBarType.fixed,
              iconSize: 28.0,
              showSelectedLabels: true,
              showUnselectedLabels: false,
              selectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
              onTap: (currentIndx) {
                cubit.changeIndex(currentIndx);
              },
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu),
                  label: "Tasks",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.check_circle),
                  label: "Done",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.archive),
                  label: "Archived",
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
