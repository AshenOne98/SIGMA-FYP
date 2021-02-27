import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smart_indoor_garden_monitoring/shared/constants.dart';
import 'package:smart_indoor_garden_monitoring/view/components/appbar_content.dart';
import 'package:smart_indoor_garden_monitoring/view/components/bottom_navbar.dart';
import 'package:smart_indoor_garden_monitoring/view/components/control_content.dart';
import 'package:smart_indoor_garden_monitoring/view/components/reusable_card.dart';

class Control extends StatefulWidget {
  @override
  _ControlState createState() => _ControlState();
}

class _ControlState extends State<Control> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    onPress: () {},
                    cardChild: ControlContent(
                      label: 'exhaust fan',
                      icon: FontAwesomeIcons.fan,
                    ),
                  ),
                ),
                Expanded(
                  child: ReusableCard(
                    color: kActiveCardColor,
                    onPress: () {},
                    cardChild: ControlContent(
                      icon: FontAwesomeIcons.solidLightbulb,
                      label: 'grow light',
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
                onPress: () {},
                cardChild: ControlContent(
                  icon: FontAwesomeIcons.handHoldingWater,
                  label: 'water pump',
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
    );
  }
}
