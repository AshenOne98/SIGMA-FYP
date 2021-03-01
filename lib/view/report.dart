import 'package:flutter/material.dart';
import 'package:smart_indoor_garden_monitoring/shared/constants.dart';
import 'package:smart_indoor_garden_monitoring/view/components/appbar_content.dart';
import 'package:smart_indoor_garden_monitoring/view/components/bottom_navbar.dart';

enum ReportType { sensor, device }

class Report extends StatefulWidget {
  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<Report> {
  ReportType reports;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    reports = ReportType.sensor;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(75.0),
        child: AppBarContent(),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  child: Container(
                    color: reports == ReportType.sensor
                        ? Color(0xFFFFA800)
                        : kActiveCardColor,
                    height: 50.0,
                    child: Center(
                      child: Text(
                        'Sensor Reports',
                        style: TextStyle(),
                      ),
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      reports = ReportType.sensor;
                    });
                  },
                ),
              ),
              Expanded(
                child: GestureDetector(
                  child: Container(
                    color: reports == ReportType.device
                        ? Color(0xFFFFA800)
                        : kActiveCardColor,
                    height: 50.0,
                    child: Center(
                      child: Text(
                        'Device Reports',
                      ),
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      reports = ReportType.device;
                    });
                  },
                ),
              ),
            ],
          ),
          Expanded(
            child: Container(),
          ),
          SizedBox(
            height: 20.0,
            width: MediaQuery.of(context).size.width / 1.1,
            child: Divider(
              color: Colors.white,
            ),
          ),
          BottomNavBar(
            selectedIndex: 4,
          ),
        ],
      ),
    );
  }
}
