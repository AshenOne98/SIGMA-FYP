import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:smart_indoor_garden_monitoring/view/components/rounded_button.dart';
import 'package:get/get.dart';
// import 'package:overlay_support/overlay_support.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:smart_indoor_garden_monitoring/view/log.dart';

class Welcome extends StatefulWidget {
  static const String id = 'welcome_screen';

  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;

  // FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
  // FlutterLocalNotificationsPlugin localNotifications;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );

    animation = ColorTween(
      begin: Colors.white,
      end: Color(0xFF1F2025),
    ).animate(controller);

    controller.forward();

    controller.addListener(() {
      setState(() {});
    });

    // var androidInitialize = new AndroidInitializationSettings('ic_launcher');
    // var iOSInitialize = new IOSInitializationSettings();
    // var initializationSettings = new InitializationSettings(
    //     android: androidInitialize, iOS: iOSInitialize);

    // localNotifications = new FlutterLocalNotificationsPlugin();
    // localNotifications.initialize(initializationSettings);

    // firebaseMessaging.configure(
    //   onLaunch: (Map<String, dynamic> msg) async {
    //     print("onLaunch called");
    //   },
    //   onResume: (Map<String, dynamic> msg) async {
    //     print("onResume called");
    //   },
    //   onMessage: (Map<String, dynamic> msg) async {
    //     print("onMessage called");
    //     print(msg);
    //     // showDialog(
    //     //   context: context,
    //     //   builder: (context) => AlertDialog(
    //     //     content: ListTile(
    //     //       title: Text(msg['notification']['title']),
    //     //       subtitle: Text(msg['notification']['body']),
    //     //     ),
    //     //     actions: [
    //     //       FlatButton(
    //     //         child: Text('ok'),
    //     //         onPressed: () => Navigator.of(context).pop(),
    //     //       )
    //     //     ],
    //     //   ),
    //     // );

    //     // Get.snackbar(
    //     //   msg['notification']['title'],
    //     //   msg['notification']['body'],
    //     //   onTap: (_) => (context) => Log(),
    //     //   duration: Duration(seconds: 4),
    //     //   animationDuration: Duration(milliseconds: 800),
    //     //   snackPosition: SnackPosition.TOP,
    //     // );

    //     // final snackbar = SnackBar(
    //     //   content: Text(msg['notification']['title']),
    //     //   action: SnackBarAction(
    //     //     label: 'Go',
    //     //     onPressed: () => null,
    //     //   ),
    //     // );

    //     // Scaffold.of(context).showSnackBar(snackbar);

    //     var androidDetails = new AndroidNotificationDetails(
    //       "channelID",
    //       "Local Notification",
    //       "descriptiion notification",
    //       importance: Importance.high,
    //     );

    //     var iosDetails = new IOSNotificationDetails();
    //     var generalNotificationDetails = new NotificationDetails(
    //       android: androidDetails,
    //       iOS: iosDetails,
    //     );
    //     localNotifications.show(0, "Notify title", "body of notification",
    //         generalNotificationDetails);
    //   },
    // );

    // firebaseMessaging.requestNotificationPermissions(
    //   const IosNotificationSettings(
    //     sound: true,
    //     alert: true,
    //     badge: true,
    //   ),
    // );

    // firebaseMessaging.onIosSettingsRegistered
    //     .listen((IosNotificationSettings setting) {
    //   print('IOS Setting Registered');
    // });

    // firebaseMessaging.getToken().then((token) {
    //   update(token);
    // });
  }

  // update(String token) {
  //   print(token);
  //   setState(() {});
  // }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 70.0,
                  ),
                ),
                SizedBox(width: 10.0),
                TypewriterAnimatedTextKit(
                  repeatForever: true,
                  speed: Duration(milliseconds: 600),
                  text: ['SIGMA'],
                  textStyle: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Center(
              child: Text(
                'Smart Indoor Garden Monitoring System',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(
              color: Colors.lightBlueAccent,
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              title: 'Log In',
            ),
            RoundedButton(
              color: Colors.blueAccent,
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              title: 'Register',
            ),
          ],
        ),
      ),
    );
  }
}
