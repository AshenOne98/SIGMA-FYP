import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smart_indoor_garden_monitoring/shared/constants.dart';
import 'package:smart_indoor_garden_monitoring/view/components/appbar_content.dart';
import 'package:smart_indoor_garden_monitoring/view/components/bottom_navbar.dart';
import 'package:smart_indoor_garden_monitoring/view/components/exit_dialog.dart';
import 'package:smart_indoor_garden_monitoring/view/components/home_content.dart';
import 'package:smart_indoor_garden_monitoring/view/components/reusable_card.dart';

final dbRef = FirebaseDatabase.instance.reference();
var tempValue;
var humidValue;
var lightValue;
var moistureValue;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readData();
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
        body: StreamBuilder(
          stream: dbRef.child("sensors").onValue,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: Row(
                      children: [
                        Expanded(
                          child: ReusableCard(
                            color: kActiveCardColor,
                            cardChild: HomeContent(
                              label: 'light intensity',
                              value: lightValue.toString(),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ReusableCard(
                            color: kActiveCardColor,
                            cardChild: HomeContent(
                              label: 'soil moisture',
                              value: moistureValue.toString(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Row(
                      children: [
                        Expanded(
                          child: ReusableCard(
                            color: kActiveCardColor,
                            cardChild: HomeContent(
                              label: 'air temperature',
                              value: tempValue.toString(),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ReusableCard(
                            color: kActiveCardColor,
                            cardChild: HomeContent(
                              label: 'air humidity',
                              value: humidValue.toString(),
                            ),
                          ),
                        ),
                      ],
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
                    selectedIndex: 0,
                  ),
                ],
              );
            } else {
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.lightBlueAccent,
                ),
              );
            }
          },
        ),
      ),
    );
  }

  // readData() {
  //   dbRef.child("SIGMA").once().then((DataSnapshot snapshot) async {
  //     print(snapshot.value['temperature']);
  //     tempValue = await snapshot.value['temperature:'];
  //     // setState(() {
  //     //   value = snapshot.value['temperature'];
  //     // });
  //   });
  // }

}

readData() {
  dbRef.child('sensors').onValue.listen((event) async {
    var snapshot = event.snapshot;

    tempValue = await snapshot.value['tempSensor']['value'];
    humidValue = await snapshot.value['humidSensor']['value'];
    lightValue = await snapshot.value['lightSensor']['value'];
    moistureValue = await snapshot.value['soilSensor']['value'];
    //print('Value is $tempValue');

    //if (tempValue >= 40.0) addWarningLog('temperature', tempValue);
    // if (humidValue <= 40.0) addWarningLog('humidity', tempValue);
    //  if (lightValue >= 70.0) addWarningLog('light', tempValue);
    //   if (moistureValue <= 20.0) addWarningLog('moisture', tempValue);
  });
}

void addWarningLog(type, value) async {
  await dbRef.child('log').child('warninglog').push().set({
    'value': value,
    'type': type,
    'timestamp': DateTime.now().millisecondsSinceEpoch * -1,
  });
}
