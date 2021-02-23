import 'package:flutter/material.dart';
import 'package:smart_indoor_garden_monitoring/view/home.dart';
import 'package:smart_indoor_garden_monitoring/view/plant_care.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => Home(),
        '/plantCare': (context) => PlantCare(),
      },
      theme: ThemeData.dark().copyWith(
        primaryColor: Color(0xFF1F2025),
        scaffoldBackgroundColor: Color(0xFF1F2025),
      ),
    );
  }
}
