import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smart_indoor_garden_monitoring/shared/constants.dart';
import 'package:smart_indoor_garden_monitoring/view/components/appbar_content.dart';
import 'package:smart_indoor_garden_monitoring/view/components/bottom_navbar.dart';
import 'package:smart_indoor_garden_monitoring/view/components/plant_alert.dart';
import 'package:smart_indoor_garden_monitoring/view/components/plant_care_content.dart';
import 'package:smart_indoor_garden_monitoring/view/components/reusable_card.dart';

class PlantCare extends StatefulWidget {
  @override
  _PlantCareState createState() => _PlantCareState();
}

class _PlantCareState extends State<PlantCare> {
  double _lightMinVal = 65.75;
  double _soilMinVal = 50.25;
  double _tempMinVal = 35.15;
  double _humidMinVal = 45.55;

  double _sensorValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(75.0),
        child: AppBarContent(),
      ),
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: ReusableCard(
                    color: kActiveCardColor,
                    onPress: () {
                      _showAlert('Light Intensity', _lightMinVal);
                    },
                    cardChild: PlantCareContent(
                      label: 'light intensity',
                      icon: FontAwesomeIcons.lightbulb,
                    ),
                  ),
                ),
                Expanded(
                  child: ReusableCard(
                    color: kActiveCardColor,
                    onPress: () {
                      _showAlert('Soil Moisture', _soilMinVal);
                    },
                    cardChild: PlantCareContent(
                      icon: FontAwesomeIcons.leaf,
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
                    onPress: () {
                      _showAlert('Air Temperature', _tempMinVal);
                    },
                    cardChild: PlantCareContent(
                      label: 'air temperature',
                      icon: FontAwesomeIcons.temperatureLow,
                    ),
                  ),
                ),
                Expanded(
                  child: ReusableCard(
                    color: kActiveCardColor,
                    onPress: () {
                      _showAlert('Air Humidity', _humidMinVal);
                    },
                    cardChild: PlantCareContent(
                      label: 'air humidity',
                      icon: FontAwesomeIcons.wind,
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
            selectedIndex: 1,
          ),
        ],
      ),
    );
  }

  void _showAlert(String label, double value) async {
    _sensorValue = value;
    final setSensorValue = await showDialog<double>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return PlantAlert(initialSensorValue: _sensorValue, label: label);
        });
    if (setSensorValue != null) {
      setState(() {
        _sensorValue = setSensorValue;
      });
    }
  }
}

// finalValue == null
//         ? finalValue = sensorValue.toString()
//         : finalValue = finalValue;
//     Alert(
//       context: context,
//       title: "Set Minimum $label",
//       desc: "Current Minimum: $finalValue",
//       style: AlertStyle(
//         backgroundColor: Color(0xFFFFFFFFF),
//         titleStyle: TextStyle(fontSize: 15, color: Colors.black),
//         descStyle: TextStyle(fontSize: 15, color: Colors.black),
//       ),
//       content: Center(
//         child: SliderTheme(
//           data: SliderTheme.of(context).copyWith(
//               inactiveTrackColor: Color(0xFF8D8E98),
//               activeTrackColor: Colors.blue,
//               thumbColor: Colors.blue,
//               overlayColor: Colors.blue[100],
//               thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10.0),
//               overlayShape: RoundSliderOverlayShape(overlayRadius: 20.0)),
//           child: Slider(
//             value: sensorValue,
//             min: 0,
//             max: 100,
//             //activeColor: Colors.white, //Color(0xFFEB1555),
//             //inactiveColor: Color(0xFF8D8E98),
//             onChanged: (double newValue) {
//               setState(() {
//                 sensorValue = newValue;
//                 finalValue = sensorValue.toStringAsFixed(2);
//                 print(finalValue);
//               });
//             },
//           ),
//         ),
//       ),
//       buttons: [
//         DialogButton(
//           color: Colors.blue,
//           child: Text(
//             "SET",
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 15,
//             ),
//           ),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           width: 100,
//         )
//       ],
//     ).show();
