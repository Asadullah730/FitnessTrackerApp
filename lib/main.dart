import 'package:firebase_core/firebase_core.dart';
import 'package:fitness_tracker_app/firebase_options.dart';
import 'package:fitness_tracker_app/view/add_activity_screen.dart';
import 'package:fitness_tracker_app/view/homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Fitness Tracker App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      // home: Homescreen(),
      home: AddActivityScreen(),
    );
  }
}
