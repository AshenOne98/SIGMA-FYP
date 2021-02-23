import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:smart_indoor_garden_monitoring/shared/constants.dart';
import 'package:smart_indoor_garden_monitoring/view/components/appbar_content.dart';
import 'package:smart_indoor_garden_monitoring/view/components/bottom_navbar.dart';
import 'package:smart_indoor_garden_monitoring/view/components/plant_care_content.dart';
import 'package:smart_indoor_garden_monitoring/view/components/reusable_card.dart';

class PlantCare extends StatefulWidget {
  @override
  _PlantCareState createState() => _PlantCareState();
}

class _PlantCareState extends State<PlantCare> {
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
                    onPress: onPress,
                    cardChild: PlantCareContent(
                      label: 'light intensity',
                      icon: FontAwesomeIcons.lightbulb,
                    ),
                  ),
                ),
                Expanded(
                  child: ReusableCard(
                    color: kActiveCardColor,
                    onPress: onPress,
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
                    onPress: onPress,
                    cardChild: PlantCareContent(
                      label: 'air temperature',
                      icon: FontAwesomeIcons.temperatureLow,
                    ),
                  ),
                ),
                Expanded(
                  child: ReusableCard(
                    color: kActiveCardColor,
                    onPress: onPress,
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

  void onPress() {
    setState(() {
      Alert(
        context: context,
        title: "RFLUTTER ALERT",
        desc: "Flutter is more awesome with RFlutter Alert.",
        style: AlertStyle(backgroundColor: Color(0xFFFFFFFFF)),
        buttons: [
          DialogButton(
            child: Text(
              "COOL",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
            width: 120,
          )
        ],
      ).show();
    });
  }
}
