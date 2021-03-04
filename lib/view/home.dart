import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smart_indoor_garden_monitoring/shared/constants.dart';
import 'package:smart_indoor_garden_monitoring/view/components/appbar_content.dart';
import 'package:smart_indoor_garden_monitoring/view/components/bottom_navbar.dart';
import 'package:smart_indoor_garden_monitoring/view/components/home_content.dart';
import 'package:smart_indoor_garden_monitoring/view/components/reusable_card.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final dbRef = FirebaseDatabase.instance.reference();

  var tempValue;
  var humidValue;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(75.0),
        child: AppBarContent(),
      ),
      body: StreamBuilder(
          stream: dbRef.child("SIGMA").onValue,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: ReusableCard(
                            color: kActiveCardColor,
                            cardChild: HomeContent(
                              label: 'light intensity',
                            ),
                          ),
                        ),
                        Expanded(
                          child: ReusableCard(
                            color: kActiveCardColor,
                            cardChild: HomeContent(
                              label: 'soil moisture',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: ReusableCard(
                            color: kActiveCardColor,
                            cardChild: HomeContent(
                              label: 'air temperature',
                              value: tempValue.toString() + "°C",
                            ),
                          ),
                        ),
                        Expanded(
                          child: ReusableCard(
                            color: kActiveCardColor,
                            cardChild: HomeContent(
                              label: 'air humidity',
                              value: humidValue.toString() + "%",
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
              return Container(
                child: Text('Loading'),
              );
            }
          }),
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

  readData() {
    dbRef.child('SIGMA').onValue.listen((event) async {
      var snapshot = event.snapshot;

      tempValue = await snapshot.value['temperature'];
      humidValue = await snapshot.value['humidity'];
      //print('Value is $tempValue');
    });
  }
}
