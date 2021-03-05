import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:smart_indoor_garden_monitoring/view/control.dart';
import 'package:smart_indoor_garden_monitoring/view/home.dart';
import 'package:smart_indoor_garden_monitoring/view/log.dart';
import 'package:smart_indoor_garden_monitoring/view/login.dart';
import 'package:smart_indoor_garden_monitoring/view/plant_care.dart';
import 'package:smart_indoor_garden_monitoring/view/register.dart';
import 'package:smart_indoor_garden_monitoring/view/report.dart';
import 'package:smart_indoor_garden_monitoring/view/welcome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => Welcome(),
        '/register': (context) => Register(),
        '/login': (context) => Login(),
        '/home': (context) => Home(),
        '/plantCare': (context) => PlantCare(),
        '/control': (context) => Control(),
        '/log': (context) => Log(),
        '/report': (context) => Report(),
      },
      theme: ThemeData.dark().copyWith(
        primaryColor: Color(0xFF1F2025),
        scaffoldBackgroundColor: Color(0xFF1F2025),
      ),
    );
  }
}
