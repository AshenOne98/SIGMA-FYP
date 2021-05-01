import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:smart_indoor_garden_monitoring/view/control.dart';
import 'package:smart_indoor_garden_monitoring/view/home.dart';
import 'package:smart_indoor_garden_monitoring/view/log.dart';
import 'package:smart_indoor_garden_monitoring/view/login.dart';
import 'package:smart_indoor_garden_monitoring/view/plant_care.dart';
import 'package:smart_indoor_garden_monitoring/view/register.dart';
import 'package:smart_indoor_garden_monitoring/view/report.dart';
import 'package:smart_indoor_garden_monitoring/view/welcome.dart';

FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
FlutterLocalNotificationsPlugin localNotifications;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var androidInitialize = new AndroidInitializationSettings('ic_launcher');
    var iOSInitialize = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        android: androidInitialize, iOS: iOSInitialize);

    localNotifications = new FlutterLocalNotificationsPlugin();
    localNotifications.initialize(initializationSettings);

    firebaseMessaging.configure(
      onLaunch: (Map<String, dynamic> msg) async {
        print("onLaunch called");
      },
      onResume: (Map<String, dynamic> msg) async {
        print("onResume called");
      },
      onMessage: (Map<String, dynamic> msg) async {
        print("onMessage called");
        print(msg);

        var androidDetails = new AndroidNotificationDetails(
          "channelID",
          "Local Notification",
          "descriptiion notification",
          importance: Importance.high,
        );

        var iosDetails = new IOSNotificationDetails();
        var generalNotificationDetails = new NotificationDetails(
          android: androidDetails,
          iOS: iosDetails,
        );
        localNotifications.show(0, "Notify title", "body of notification",
            generalNotificationDetails);
      },
    );

    firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(
        sound: true,
        alert: true,
        badge: true,
      ),
    );

    firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings setting) {
      print('IOS Setting Registered');
    });

    firebaseMessaging.getToken().then((token) {
      update(token);
    });

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

  update(String token) {
    print(token);

    DatabaseReference _dataRef = new FirebaseDatabase().reference();
    _dataRef.child('fcm-token/$token').set({"token": token});
  }
}
