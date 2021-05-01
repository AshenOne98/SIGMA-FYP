import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smart_indoor_garden_monitoring/shared/constants.dart';
import 'package:smart_indoor_garden_monitoring/view/components/appbar_content.dart';
import 'package:smart_indoor_garden_monitoring/view/components/bottom_navbar.dart';
import 'package:smart_indoor_garden_monitoring/view/components/exit_dialog.dart';

enum LogType { warning, action }
enum WarningType { humid, temp, light, moisture }
enum ActionType { growthLight, exhaustFan, waterPump }
final dbRef = FirebaseDatabase.instance.reference();
var _selection;
String selectedWarning, selectedAction;
// Key _key;

// var status;
// var device;
// var timestamp;

Query _actionRef, _warningRef;

class Log extends StatefulWidget {
  @override
  _LogState createState() => _LogState();
}

class _LogState extends State<Log> {
  LogType logs;
  WarningType warnings;

  @override
  void initState() {
    super.initState();
    logs = LogType.warning;
    selectedWarning = '';
    selectedAction = '';

    _actionRef = FirebaseDatabase.instance
        .reference()
        .child('log')
        .child("actionlog")
        .orderByChild('timestamp')
        .limitToFirst(100);

    _warningRef = FirebaseDatabase.instance
        .reference()
        .child('log')
        .child("warninglog")
        .orderByChild('timestamp')
        .limitToFirst(100);

    listenChange();
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
                          'Device Log',
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
                child: logs == LogType.warning ? WarningLog() : ActionLog(),
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
        floatingActionButton: Padding(
          padding: EdgeInsets.only(bottom: 70.0),
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xFFFFA800),
              borderRadius: BorderRadius.all(
                Radius.circular(50),
              ),
            ),
            height: 50.0,
            width: 50.0,
            child: logs == LogType.warning ? popMenuWarning() : popMenuAction(),
          ),
        ),
      ),
    );
  }

  PopupMenuButton<WarningType> popMenuWarning() {
    return PopupMenuButton<WarningType>(
      onSelected: (WarningType result) {
        setState(() {
          _selection = result;
          print(_selection);

          if (_selection == WarningType.humid) selectedWarning = "humidity";
          if (_selection == WarningType.moisture)
            selectedWarning = "soil moisture";
          if (_selection == WarningType.temp) selectedWarning = "temperature";
          if (_selection == WarningType.light)
            selectedWarning = "light intensity";

          // _key = Key(selectedWarning.toString());
        });
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<WarningType>>[
        const PopupMenuItem<WarningType>(
          value: WarningType.temp,
          child: Text('Temperature'),
        ),
        const PopupMenuItem<WarningType>(
          value: WarningType.humid,
          child: Text('Humidity'),
        ),
        const PopupMenuItem<WarningType>(
          value: WarningType.moisture,
          child: Text('Moisture'),
        ),
        const PopupMenuItem<WarningType>(
          value: WarningType.light,
          child: Text('Light'),
        ),
      ],
      child: Icon(
        Icons.menu,
        color: Colors.black,
      ),
    );
  }

  PopupMenuButton<ActionType> popMenuAction() {
    return PopupMenuButton<ActionType>(
      onSelected: (ActionType result) {
        setState(() {
          _selection = result;
          print(_selection);

          if (_selection == ActionType.exhaustFan)
            selectedAction = 'Exhaust fan';
          if (_selection == ActionType.growthLight)
            selectedAction = 'Growth light';
          if (_selection == ActionType.waterPump) selectedAction = 'Water pump';

          // _key = Key(selectedAction.toString());
        });
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<ActionType>>[
        const PopupMenuItem<ActionType>(
          value: ActionType.exhaustFan,
          child: Text('Exhaust Fan'),
        ),
        const PopupMenuItem<ActionType>(
          value: ActionType.waterPump,
          child: Text('Water Pump'),
        ),
        const PopupMenuItem<ActionType>(
          value: ActionType.growthLight,
          child: Text('Light'),
        ),
      ],
      child: Icon(
        Icons.menu,
        color: Colors.black,
      ),
    );
  }
}

class ActionLog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var status;
    IconData icon;
    return FirebaseAnimatedList(
      query: _actionRef,
      defaultChild: Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.lightBlueAccent,
        ),
      ),
      itemBuilder: (BuildContext context, DataSnapshot snapshot,
          Animation<double> animation, int index) {
        Map log = snapshot.value;

        if (log == null) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        } else if (log.isEmpty) {
          return Center(
            child: Text('There is no action log'),
          );
        }

        log['action'] == true ? status = 'On' : status = 'Off';

        log['device'] == 'Exhaust fan'
            ? icon = FontAwesomeIcons.fan
            : log['device'] == 'Growth light'
                ? icon = FontAwesomeIcons.solidLightbulb
                : icon = FontAwesomeIcons.handHoldingWater;

        var date = DateTime.fromMillisecondsSinceEpoch(log['timestamp'] * -1);
        var formattedDate = DateFormat('dd/MM/yyyy KK:mm a')
            .format(date); //DateFormat.yMMMEd().add_jm().format(date);

        if (selectedAction == null || selectedAction == '') {
          return ActionCard(
            icon: icon,
            log: log,
            status: status,
            formattedDate: formattedDate,
          );
        } else if (log['device'] == '$selectedAction') {
          return ActionCard(
            icon: icon,
            log: log,
            status: status,
            formattedDate: formattedDate,
          );
        } else if (log['device'] != '$selectedAction' &&
            selectedAction != null) {
          print("bottom");
          return SizedBox(height: 0);
        } else {
          return SizedBox(height: 0);
        }
      },
    );
  }
}

class ActionCard extends StatelessWidget {
  const ActionCard({
    Key key,
    @required this.icon,
    @required this.log,
    @required this.status,
    @required this.formattedDate,
  }) : super(key: key);

  final IconData icon;
  final Map log;
  final status;
  final String formattedDate;

  @override
  Widget build(BuildContext context) {
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

class WarningLog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FirebaseAnimatedList(
      // key: _key,
      query: _warningRef,
      defaultChild: Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.lightBlueAccent,
        ),
      ),
      itemBuilder: (BuildContext context, DataSnapshot snapshot,
          Animation<double> animation, int index) {
        Map log = snapshot.value;

        if (log == null) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        } else if (_warningRef == null) {
          return Center(
            child: Text('There is no warning log'),
          );
        }

        IconData icon;
        log['type'] == 'temperature'
            ? icon = FontAwesomeIcons.temperatureHigh
            : log['type'] == 'humidity'
                ? icon = FontAwesomeIcons.wind
                : log['type'] == 'light intensity'
                    ? icon = FontAwesomeIcons.lightbulb
                    : icon = FontAwesomeIcons.leaf;

        String level = log['type'] == 'temperature' ? 'High' : 'Low';

        String device = log['type'] == 'temperature'
            ? 'exhaust fan'
            : log['type'] == 'humidity'
                ? 'exhaust fan'
                : log['type'] == 'light intensity'
                    ? 'growth light'
                    : 'water pump';

        var date =
            DateTime.fromMillisecondsSinceEpoch(log['timestamp'] * -1000);
        var formattedDate = DateFormat('dd/MM/yyyy KK:mm a')
            .format(date); //DateFormat.yMMMEd().add_jm().format(date);

        if (selectedWarning == null || selectedWarning == '') {
          print("top");
          return WarningCard(
              icon: icon,
              level: level,
              log: log,
              device: device,
              formattedDate: formattedDate);
        } else if (log['type'] == '$selectedWarning') {
          print("middle");
          return WarningCard(
              icon: icon,
              level: level,
              log: log,
              device: device,
              formattedDate: formattedDate);
        } else if (log['type'] != '$selectedWarning' &&
            selectedWarning != null) {
          print("bottom");
          return SizedBox(height: 0);
        } else {
          return SizedBox(height: 0);
        }
      },
    );
  }
}

class WarningCard extends StatelessWidget {
  const WarningCard({
    @required this.icon,
    @required this.level,
    @required this.log,
    @required this.device,
    @required this.formattedDate,
  });

  final IconData icon;
  final String level;
  final Map log;
  final String device;
  final String formattedDate;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTileTheme(
        child: ListTile(
          leading: Icon(
            icon,
            size: 40.0,
            color: Colors.white,
          ),
          title: Text(
            '$level ${log['type']}',
            style: TextStyle(
              color: Colors.red,
            ),
          ),
          subtitle: Text(
              'Your plant ${log['type']} is ${level.toLowerCase()}. Activating $device'),
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

listenChange() {
  var db = dbRef.child("log");
  db.child("warningLog").onChildAdded.listen((data) {
    print(data);
  });
}
