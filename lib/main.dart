import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import 'package:to_do/layout/tabs.dart';
import 'package:to_do/shared/bloc_observer.dart';

void main() {
  //===================== Observing My Bloc =====================
  Bloc.observer = MyBlocObserver();

  //===================== Running App =====================
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      //============ Main Screen ============
      home: const Tabs(),

      //============ App Theme ============
      theme: ThemeData(
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          bodyLarge: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          bodySmall: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
