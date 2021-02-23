import 'package:flutter/material.dart';
import 'package:smart_indoor_garden_monitoring/shared/constants.dart';

class PlantCareContent extends StatelessWidget {
  final String label;
  final IconData icon;

  PlantCareContent({@required this.label, @required this.icon});
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
      ],
    );
  }
}
