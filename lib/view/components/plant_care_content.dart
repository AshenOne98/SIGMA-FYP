import 'package:flutter/material.dart';
import 'package:smart_indoor_garden_monitoring/shared/constants.dart';

class PlantCareContent extends StatelessWidget {
  final String label;
  final IconData icon;
  final String status;

  PlantCareContent({@required this.label, @required this.icon, this.status});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 60.0,
        ),
        SizedBox(
          height: 15.0,
        ),
        Text(
          label.toUpperCase(),
          style: kLabelTextStyle,
        ),
        SizedBox(
          height: 10.0,
        ),
        Text(
          status,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFFFFA800),
            fontSize: 17.0,
          ),
        )
      ],
    );
  }
}
