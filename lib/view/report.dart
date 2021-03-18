import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
//import 'package:intl/intl.dart';
import 'package:webview_flutter/webview_flutter.dart';
//import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:smart_indoor_garden_monitoring/shared/constants.dart';
import 'package:smart_indoor_garden_monitoring/view/components/appbar_content.dart';
import 'package:smart_indoor_garden_monitoring/view/components/bottom_navbar.dart';
import 'package:smart_indoor_garden_monitoring/view/components/exit_dialog.dart';

enum ReportType { sensor, device }
final dbRef = FirebaseDatabase.instance.reference();

class Report extends StatefulWidget {
  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<Report> {
  ReportType reports;
  bool isLoading = false;
  num _stackToView = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    reports = ReportType.sensor;
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return onBackPressed(context);
      },
      child: Scaffold(
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
            SizedBox(height: 17.0),
            Expanded(
              child: IndexedStack(index: _stackToView, children: [
                Container(
                  child: WebView(
                    initialUrl: 'http://192.168.1.34',
                    javascriptMode: JavascriptMode.unrestricted,
                    onPageFinished: (finish) {
                      setState(() {
                        _stackToView = 0;
                      });
                    },
                  ),
                ),
                Container(
                  child: Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.lightBlueAccent,
                    ),
                  ),
                ),
              ]),
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
      ),
    );
  }
}

class ChartData {
  ChartData({this.xValue, this.yValue});
  ChartData.fromMap(Map<String, dynamic> dataMap)
      : xValue = dataMap['timestamp'],
        yValue = dataMap['value'];
  final xValue;
  final yValue;
}
