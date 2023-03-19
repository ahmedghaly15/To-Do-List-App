import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/shared/components.dart';
import '/shared/cubit/cubit.dart';
import '/shared/cubit/states.dart';

class DoneTaskScreen extends StatelessWidget {
  const DoneTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var tasks = AppCubit.getCubitObject(context).doneTasks;

          return tasksBuilder(
            context: context,
            tasks: tasks,
            icon: Icons.check_circle,
            text: "No tasks yet, go finish some",
          );
        });
  }
}
