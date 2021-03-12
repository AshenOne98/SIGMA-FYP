import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smart_indoor_garden_monitoring/shared/constants.dart';
import 'package:smart_indoor_garden_monitoring/view/components/appbar_content.dart';
import 'package:smart_indoor_garden_monitoring/view/components/bottom_navbar.dart';
import 'package:smart_indoor_garden_monitoring/view/components/control_alert.dart';
import 'package:smart_indoor_garden_monitoring/view/components/control_content.dart';
import 'package:smart_indoor_garden_monitoring/view/components/exit_dialog.dart';
import 'package:smart_indoor_garden_monitoring/view/components/reusable_card.dart';

enum Device { fan, light, pump }

class Control extends StatefulWidget {
  @override
  _ControlState createState() => _ControlState();
}

class _ControlState extends State<Control> {
  final dbRef = FirebaseDatabase.instance.reference();

  void initState() {
    super.initState();

    getDeviceStatus();
  }

  bool _fanStatus = true;
  bool _lightStatus = false;
  bool _pumpStatus;

  bool _deviceStatus;

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
        body: StreamBuilder<Object>(
            stream: dbRef.child('device').onValue,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 15.0),
                      child: Text(
                        'CONTROL DEVICES',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFFA800),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: ReusableCard(
                              color: kActiveCardColor,
                              onPress: () {
                                _showAlert(
                                    'Exhaust Fan', _fanStatus, Device.fan);
                              },
                              cardChild: ControlContent(
                                label: 'exhaust fan',
                                icon: FontAwesomeIcons.fan,
                                status: _fanStatus == true ? 'ON' : 'OFF',
                              ),
                            ),
                          ),
                          Expanded(
                            child: ReusableCard(
                              color: kActiveCardColor,
                              onPress: () {
                                _showAlert(
                                    'Grow Light', _lightStatus, Device.light);
                              },
                              cardChild: ControlContent(
                                icon: FontAwesomeIcons.solidLightbulb,
                                label: 'grow light',
                                status: _lightStatus == true ? 'ON' : 'OFF',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: MediaQuery.of(context).size.width / 1.9,
                        height: MediaQuery.of(context).size.height,
                        child: ReusableCard(
                          color: kActiveCardColor,
                          onPress: () {
                            _showAlert('Water Pump', _pumpStatus, Device.pump);
                          },
                          cardChild: ControlContent(
                            icon: FontAwesomeIcons.handHoldingWater,
                            label: 'water pump',
                            status: _pumpStatus == true ? 'ON' : 'OFF',
                          ),
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
                      selectedIndex: 2,
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
            }),
      ),
    );
  }

  void _showAlert(String label, bool status, Device selectedDevice) async {
    _deviceStatus = status;
    final setDeviceStatus = await showDialog<bool>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return ControlAlert(initialDeviceStatus: _deviceStatus, label: label);
        });
    if (setDeviceStatus != null) {
      setState(() {
        _deviceStatus = setDeviceStatus;
        if (selectedDevice == Device.fan) {
          _fanStatus = _deviceStatus;
          updateDeviceStatus('fan', _fanStatus);
          addActionLog('Exhaust fan', _fanStatus);
        } else if (selectedDevice == Device.light) {
          _lightStatus = _deviceStatus;
          updateDeviceStatus('growlight', _lightStatus);
          addActionLog('Growth light', _lightStatus);
        } else {
          _pumpStatus = _deviceStatus;
          updateDeviceStatus('waterpump', _pumpStatus);
          addActionLog('Water pump', _pumpStatus);
        }
      });
    }
  }

  void getDeviceStatus() {
    dbRef.child('device').onValue.listen((event) async {
      var snapshot = event.snapshot;

      _pumpStatus = await snapshot.value['waterpump']['status'];
      _lightStatus = await snapshot.value['growlight']['status'];
      _fanStatus = await snapshot.value['fan']['status'];
      //print(_pumpStatus);
    });
  }

  void updateDeviceStatus(deviceName, newStatus) async {
    await dbRef.child('device').child(deviceName).update({'status': newStatus});
  }

  void addActionLog(deviceName, newStatus) async {
    await dbRef.child('log').child('actionlog').push().set({
      'action': newStatus,
      'device': deviceName,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }
}
