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
  bool _fanStatus = true;
  bool _lightStatus = false;
  bool _pumpStatus = false;

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
        body: Column(
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
                        _showAlert('Exhaust Fan', _fanStatus, Device.fan);
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
                        _showAlert('Grow Light', _lightStatus, Device.light);
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
        ),
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
        } else if (selectedDevice == Device.light) {
          _lightStatus = _deviceStatus;
        } else {
          _pumpStatus = _deviceStatus;
        }
      });
    }
  }
}
