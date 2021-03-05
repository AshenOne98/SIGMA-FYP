import 'package:flutter/material.dart';

class ControlAlert extends StatefulWidget {
  final bool initialDeviceStatus;
  final String label;

  ControlAlert({this.initialDeviceStatus, this.label});

  @override
  _ControlAlertState createState() => _ControlAlertState();
}

class _ControlAlertState extends State<ControlAlert> {
  bool _isSwitched;

  void initState() {
    super.initState();
    _isSwitched = widget.initialDeviceStatus;
  }

  @override
  Widget build(BuildContext context) {
    String label = _isSwitched == true ? 'On' : 'Off';

    return AlertDialog(
      title: Text(
        'Turn On/Off ${widget.label}',
        textAlign: TextAlign.center,
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Transform.scale(
              scale: 1.3,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 80.0),
                child: Switch(
                  value: _isSwitched,
                  onChanged: (value) {
                    setState(() {
                      _isSwitched = value;
                      print(_isSwitched);
                    });
                  },
                  activeTrackColor: Colors.lightBlue[100],
                  activeColor: Colors.blue,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Center(
                child: Text(
              label.toUpperCase(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17.0,
              ),
            )),
            Container(
              margin: EdgeInsets.all(20),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                elevation: 3.0,
                child: Text('Set'),
                color: Colors.blueAccent,
                textColor: Colors.white,
                onPressed: () {
                  Navigator.pop(context, _isSwitched);
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
      //       Navigator.pop(context, _deviceStatus);
      //     },
      //   ),
      // ],
    );
  }
}
