import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:smart_indoor_garden_monitoring/shared/constants.dart';
import 'package:smart_indoor_garden_monitoring/view/components/appbar_content.dart';
import 'package:smart_indoor_garden_monitoring/view/components/bottom_navbar.dart';
import 'package:smart_indoor_garden_monitoring/view/components/exit_dialog.dart';

enum ReportType { sensor, device }
Query dataTemp, dataHumid;

class Report extends StatefulWidget {
  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<Report> {
  ReportType reports;
  // bool isLoading = false;
  // num _stackToView = 1;
  // List<charts.Series<ChartData, dynamic>> _seriesList;
  // List<ChartData> chartData;

  // _generateData(chartData) {
  //   _seriesList = List<charts.Series<ChartData, String>>();
  //   _seriesList.add(charts.Series(
  //     domainFn: (ChartData data, _) => data.xValue,
  //     measureFn: (ChartData data, _) => data.yValue,
  //     id: "Temp Redings",
  //     data: chartData,
  //   ));
  // }

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
                      maxHeight: MediaQuery.of(context).size.height * 1.2),
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
              List<TempData> tempData = <TempData>[];
              Map data = snap.data.snapshot.value;
              Map sorted = Map.fromEntries(
                data.entries.toList()
                  ..sort(
                    (e1, e2) =>
                        e1.value["timestamp"].compareTo(e2.value["timestamp"]),
                  ),
              );

              for (Map childData in sorted.values) {
                tempData.add(
                  TempData.fromMap(
                    childData.cast<String, dynamic>(),
                  ),
                );
              }

              // List<ChartData> data = snap.data.snapshot.value
              //     .map((snapshot) => ChartData.fromMap(snapshot.data))
              //     .toList();
              // print(chartData);
              // chartData = data;
              // _generateData(chartData);

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
                              primaryXAxis: DateTimeAxis(
                                dateFormat: DateFormat.Hm(),
                                intervalType: DateTimeIntervalType.minutes,
                                interval: 10,
                              ),
                              series: <ChartSeries<TempData, dynamic>>[
                                LineSeries<TempData, dynamic>(
                                  //markerSettings: MarkerSettings(isVisible: true),
                                  dataSource: tempData,
                                  xValueMapper: (TempData data, _) =>
                                      data.xValue,
                                  yValueMapper: (TempData data, _) =>
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
              //     charts.LineChart(
              //   _seriesList,
              //   animate: true,
              //   animationDuration: Duration(seconds: 5),
              // );

              // Container();
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

class TempData {
  TempData({this.xValue, this.yValue});
  TempData.fromMap(Map<String, dynamic> dataMap)
      : xValue =
            DateTime.fromMillisecondsSinceEpoch(dataMap['timestamp'] * -1000),
        yValue = ((dataMap['value'] as num) * 100).truncateToDouble() / 100;
  final xValue;
  final yValue;
}

class HumidData {
  HumidData({this.xValue, this.yValue});
  HumidData.fromMap(Map<String, dynamic> dataMap)
      : xValue =
            DateTime.fromMillisecondsSinceEpoch(dataMap['timestamp'] * -1000),
        yValue = ((dataMap['value'] as num) * 100).truncateToDouble() / 100;
  final xValue;
  final yValue;
}
