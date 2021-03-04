import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class HomeContent extends StatefulWidget {
  final String label;
  final String value;

  HomeContent({@required this.label, this.value});
  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularPercentIndicator(
          radius: 100.0,
          lineWidth: 13.0,
          animation: true,
          percent: 0.7,
          center: Text(
            widget.value != null ? widget.value : '70.0%',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
          footer: Padding(
            padding: EdgeInsets.only(top: 15.0),
            child: Text(
              widget.label.toUpperCase(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15.0,
              ),
            ),
          ),
          circularStrokeCap: CircularStrokeCap.round,
          progressColor: Colors.amber[800],
        ),
      ],
    );
  }
}
