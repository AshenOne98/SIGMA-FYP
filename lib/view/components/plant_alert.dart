import 'package:flutter/material.dart';

class PlantAlert extends StatefulWidget {
  final initialSensorValue;
  final String label;

  PlantAlert({this.initialSensorValue, this.label});

  @override
  _PlantAlertState createState() => _PlantAlertState();
}

class _PlantAlertState extends State<PlantAlert> {
  double _sensorValue;
  String level;

  void initState() {
    super.initState();
    _sensorValue = widget.initialSensorValue;
  }

  @override
  Widget build(BuildContext context) {
    level = widget.label == 'Air Temperature' ? 'maximum' : 'minimum';

    return AlertDialog(
      title: Text('Set $level ${widget.label}'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text('Current $level value: ' +
                widget.initialSensorValue.toStringAsFixed(2)),
            Text('Set $level value: ${_sensorValue.toStringAsFixed(2)}'),
            SizedBox(
              height: 10.0,
            ),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                  inactiveTrackColor: Color(0xFF8D8E98),
                  activeTrackColor: Colors.blue,
                  thumbColor: Colors.blue,
                  overlayColor: Colors.blue[100],
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10.0),
                  overlayShape: RoundSliderOverlayShape(overlayRadius: 20.0)),
              child: Slider(
                value: _sensorValue,
                min: 0,
                max: 100,
                //activeColor: Colors.white, //Color(0xFFEB1555),
                //inactiveColor: Color(0xFF8D8E98),
                onChanged: (double newValue) {
                  setState(() {
                    _sensorValue = newValue;
                  });
                },
              ),
            ),
            Container(
              margin: EdgeInsets.all(20),
              child: RaisedButton(
                elevation: 3.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Text('Set'),
                color: Colors.blueAccent,
                textColor: Colors.white,
                onPressed: () {
                  Navigator.pop(context, _sensorValue);
                },
              ),
            ),
          ],
        ),
      ),
      // actions: <Widget>[
      //   TextButton(
      //     child: Text('Set'),
      //     onPressed: () {
      //       Navigator.pop(context, _sensorValue);
      //     },
      //   ),
      // ],
    );
  }
}
