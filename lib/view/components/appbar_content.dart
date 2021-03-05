import 'package:flutter/material.dart';

class AppBarContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.01;

    return AppBar(
      automaticallyImplyLeading: false,
      title: Center(
        child: Padding(
          padding: EdgeInsets.only(top: 10.0),
          child: Container(
            child: Column(
              children: [
                Text(
                  'SIGMA',
                  style: TextStyle(
                    fontSize: width * 7,
                  ),
                ),
                //SizedBox(height: 2.0),
                Text(
                  'Smart Indoor Garden Monitoring System',
                  style: TextStyle(
                    fontSize: width * 4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
