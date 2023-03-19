import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:to_do/shared/cubit/cubit.dart';

// ======================== Build Text Form Field Function =============================
TextFormField buildTextFormField({
  required BuildContext context,
  String? hint,
  TextCapitalization? capitalization,
  bool? enableSuggestions,
  Widget? icon,
  TextEditingController? controller,
  required String? Function(String?)? validating,
  TextInputType? keyboardType,
  Function()? onTap,
}) {
  // For Making App Responsive
  double screenWidth = MediaQuery.of(context).size.width;
  return TextFormField(
    textCapitalization: capitalization!,
    enableSuggestions: enableSuggestions!,
    controller: controller,
    decoration: InputDecoration(
      icon: icon,
      hintText: hint,
      hintStyle: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        letterSpacing: 1,
        color: Colors.grey,
      ),
      contentPadding: EdgeInsets.only(left: screenWidth * 0.03),
      border: const OutlineInputBorder(),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(screenWidth * 0.04),
          borderSide: const BorderSide(color: Colors.blue)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(screenWidth * 0.04),
          borderSide: const BorderSide(
            color: Colors.blue,
            width: 2,
          )),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(screenWidth * 0.04),
        borderSide: const BorderSide(color: Colors.blue),
      ),
    ),
    style: const TextStyle(
      color: Colors.black,
      fontSize: 20,
      letterSpacing: 1,
      fontWeight: FontWeight.w400,
    ),
    keyboardType: keyboardType,
    validator: validating,
    onTap: onTap,
  );
}

// ======================== Build Text Item Function =============================
Widget buildTaskItem(
  Map model, {
  required BuildContext context,
}) {
  // For Making App Responsive
  double screenWidth = MediaQuery.of(context).size.width;
  double screenHeight = MediaQuery.of(context).size.height;

  return Dismissible(
    key: Key(model['id'].toString()),
    onDismissed: (direction) {
      AppCubit.getCubitObject(context).deleteData(id: model['id']);
    },
    child: Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: screenHeight * 0.01,
      ),
      child: Card(
        elevation: 5,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04,
            vertical: screenHeight * 0.02,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                radius: MediaQuery.of(context).size.width * 0.12,
                child: Text(
                  model['time'],
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              SizedBox(width: screenWidth * 0.03),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      model['title'],
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    SizedBox(height: screenHeight * 0.005),
                    Text(
                      model['date'],
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Colors.grey,
                            fontSize: 15,
                          ),
                    )
                  ],
                ),
              ),
              SizedBox(width: screenWidth * 0.03),
              IconButton(
                onPressed: () {
                  AppCubit.getCubitObject(context).updateData(
                    status: 'done',
                    id: model['id'],
                  );
                },
                icon: const Icon(
                  Icons.check_box_rounded,
                  color: Colors.green,
                  size: 30,
                ),
              ),
              IconButton(
                onPressed: () {
                  AppCubit.getCubitObject(context).updateData(
                    status: 'archived',
                    id: model['id'],
                  );
                },
                icon: const Icon(
                  Icons.archive_rounded,
                  color: Colors.black54,
                  size: 30,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

// ======================== Build UI Of A Screen Function =============================
Widget tasksBuilder({
  required List<Map> tasks,
  required IconData icon,
  required String text,
  required BuildContext context,
}) {
  // For Making App Responsive
  double screenHeight = MediaQuery.of(context).size.height;

  return ConditionalBuilder(
    condition: tasks.isNotEmpty,
    builder: (context) => ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        return buildTaskItem(tasks[index], context: context);
      },
    ),
    fallback: (context) => Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            icon,
            size: screenHeight * 0.15,
            color: Colors.grey,
          ),
          Text(
            text,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    ),
  );
}
