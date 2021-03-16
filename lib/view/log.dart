import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smart_indoor_garden_monitoring/shared/constants.dart';
import 'package:smart_indoor_garden_monitoring/view/components/appbar_content.dart';
import 'package:smart_indoor_garden_monitoring/view/components/bottom_navbar.dart';
import 'package:smart_indoor_garden_monitoring/view/components/exit_dialog.dart';

enum LogType { warning, action }
final dbRef = FirebaseDatabase.instance.reference();

var status;
var device;
var timestamp;

Query _ref;

class Log extends StatefulWidget {
  @override
  _LogState createState() => _LogState();
}

class _LogState extends State<Log> {
  LogType logs;

  @override
  void initState() {
    super.initState();
    logs = LogType.warning;
    _ref = FirebaseDatabase.instance
        .reference()
        .child('log')
        .child("actionlog")
        .orderByChild('timestamp');
    //readData();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return onBackPressed(context);
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(75.0),
          child: AppBarContent(),
        ),
        body: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    child: Container(
                      color: logs == LogType.warning
                          ? Colors.red
                          : kActiveCardColor,
                      height: 50.0,
                      child: Center(
                        child: Text(
                          'Warning Log',
                          style: TextStyle(),
                        ),
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        logs = LogType.warning;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    child: Container(
                      color: logs == LogType.action
                          ? Colors.blue[900]
                          : kActiveCardColor,
                      height: 50.0,
                      child: Center(
                        child: Text(
                          'Action Log',
                        ),
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        logs = LogType.action;
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FirebaseAnimatedList(
                  query: _ref,
                  itemBuilder: (BuildContext context, DataSnapshot snapshot,
                      Animation<double> animation, int index) {
                    Map logContent = snapshot.value;
                    if (logContent == null) {
                      return Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.lightBlueAccent,
                        ),
                      );
                    }

                    return ActionLog(log: logContent);
                  },
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
              width: MediaQuery.of(context).size.width / 1.1,
              child: Divider(
                color: Colors.white,
              ),
            ),
            BottomNavBar(
              selectedIndex: 3,
            ),
          ],
        ),
      ),
    );
  }

  // readData() {
  //   dbRef.child('log').child("actionlog").onValue.listen((event) async {
  //     var snapshot = event.snapshot;

  //     status = await snapshot.value['-MVWjhVyQDV0R8l_tDl6']['action'];
  //     device = await snapshot.value['-MVWjhVyQDV0R8l_tDl6']['device'];
  //     timestamp = await snapshot.value['-MVWjhVyQDV0R8l_tDl6']['timestamp'];

  //     print(status);

  //     //int count = snapshot.value.length;
  //     //print(snapshot.value);

  //     // var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
  //     // var formattedDate = DateFormat.yMd().add_jm().format(date);
  //     // datetime = formattedDate;
  //     // print(formattedDate);
  //   });
  // }
}

class ActionLog extends StatelessWidget {
  final Map log;

  const ActionLog({this.log});

  @override
  Widget build(BuildContext context) {
    var status;
    IconData icon;

    log['action'] == true ? status = 'On' : status = 'Off';

    log['device'] == 'Exhaust fan'
        ? icon = FontAwesomeIcons.fan
        : log['device'] == 'Growth light'
            ? icon = FontAwesomeIcons.solidLightbulb
            : icon = FontAwesomeIcons.handHoldingWater;

    var date = DateTime.fromMillisecondsSinceEpoch(log['timestamp'] * -1);
    var formattedDate = DateFormat('dd/MM/yyyy KK:mm a')
        .format(date); //DateFormat.yMMMEd().add_jm().format(date);

    return Card(
      child: ListTileTheme(
        child: ListTile(
          leading: Icon(
            icon,
            size: 40.0,
            color: Colors.white,
          ),
          title: Text(
            '${log['device']} turns $status',
            style: TextStyle(
              color: log['action'] == true ? Colors.green : Colors.red,
            ),
          ),
          subtitle: Text('${log['device']} has been turned $status'),
          trailing: Container(
            width: 80.0,
            child: Text(
              '$formattedDate',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          isThreeLine: true,
        ),
      ),
    );
  }
}
