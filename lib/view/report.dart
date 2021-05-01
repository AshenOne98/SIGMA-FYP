import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'package:smart_indoor_garden_monitoring/shared/constants.dart';
import 'package:smart_indoor_garden_monitoring/view/components/appbar_content.dart';
import 'package:smart_indoor_garden_monitoring/view/components/bottom_navbar.dart';
import 'package:smart_indoor_garden_monitoring/view/components/exit_dialog.dart';

enum ReportType { sensor, device }
Query dataTemp, dataHumid, dataLight, dataMoisture;

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
    dataTemp = FirebaseDatabase.instance
        .reference()
        .child("readings")
        .child("tempReadings");

    dataHumid = FirebaseDatabase.instance
        .reference()
        .child("readings")
        .child("humidReadings");

    dataLight = FirebaseDatabase.instance
        .reference()
        .child("readings")
        .child("lightReadings");

    dataMoisture = FirebaseDatabase.instance
        .reference()
        .child("readings")
        .child("soilReadings");

    reports = ReportType.sensor;
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
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 2.3,
                      maxWidth: MediaQuery.of(context).size.width),
                  child: Column(
                    children: [
                      GraphReading(
                        query: dataTemp,
                        label: "Temperature",
                      ),
                      GraphReading(
                        query: dataHumid,
                        label: "Humidity",
                      ),
                      GraphReading(
                        query: dataLight,
                        label: "Light",
                      ),
                      GraphReading(
                        query: dataMoisture,
                        label: "Moisture",
                      ),
                    ],
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
              selectedIndex: 4,
            ),
          ],
        ),
      ),
    );
  }
}

class GraphReading extends StatelessWidget {
  final query;
  final label;
  GraphReading({this.query, this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        child: StreamBuilder<Event>(
          stream: query.onValue,
          builder: (BuildContext context, AsyncSnapshot<Event> snap) {
            if (snap.hasData) {
              List<ChartData> chartData = <ChartData>[];
              Map data = snap.data.snapshot.value;
              Map sorted = Map.fromEntries(
                data.entries.toList()
                  ..sort(
                    (e1, e2) =>
                        e1.value["timestamp"].compareTo(e2.value["timestamp"]),
                  ),
              );

              for (Map childData in sorted.values) {
                chartData.add(
                  ChartData.fromMap(
                    childData.cast<String, dynamic>(),
                  ),
                );
              }

              return Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            "$label Readings",
                            style: TextStyle(),
                          ),
                          Container(
                            child: SfCartesianChart(
                              enableAxisAnimation: true,
                              primaryXAxis: DateTimeAxis(
                                dateFormat: DateFormat.Hm(),
                                intervalType: DateTimeIntervalType.minutes,
                                interval: 5,
                              ),
                              series: <ChartSeries<ChartData, dynamic>>[
                                LineSeries<ChartData, dynamic>(
                                  // markerSettings:
                                  //     MarkerSettings(isVisible: true),
                                  dataSource: chartData,
                                  xValueMapper: (ChartData data, _) =>
                                      data.xValue,
                                  yValueMapper: (ChartData data, _) =>
                                      data.yValue,
                                  dataLabelSettings: DataLabelSettings(
                                      // Renders the data label
                                      //isVisible: true,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else if (snap.hasData == null) {
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.lightBlueAccent,
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.lightBlueAccent,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

class ChartData {
  ChartData({this.xValue, this.yValue});
  ChartData.fromMap(Map<String, dynamic> dataMap)
      : xValue =
            DateTime.fromMillisecondsSinceEpoch(dataMap['timestamp'] * -1000),
        yValue = ((dataMap['value'] as num) * 100).truncateToDouble() / 100;
  final xValue;
  final yValue;
}
