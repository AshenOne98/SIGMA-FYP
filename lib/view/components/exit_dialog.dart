import 'package:flutter/material.dart';

Future<bool> onBackPressed(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) => new AlertDialog(
      title: new Text('Are you sure?'),
      content: new Text('Do you want to return to login screen?'),
      actions: <Widget>[
        new GestureDetector(
          onTap: () => Navigator.of(context).pop(false),
          child: Text(
            "NO",
            style: TextStyle(fontSize: 17.0),
          ),
        ),
        SizedBox(width: 8),
        new GestureDetector(
          //onTap: () => Navigator.popUntil(context, ModalRoute.withName('/')),
          onTap: () =>
              Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false),
          child: Text(
            "YES",
            style: TextStyle(fontSize: 17.0),
          ),
        ),
        SizedBox(height: 40),
      ],
    ),
  );
}
