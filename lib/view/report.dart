import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'package:smart_indoor_garden_monitoring/shared/constants.dart';
import 'package:smart_indoor_garden_monitoring/view/components/appbar_content.dart';
import 'package:smart_indoor_garden_monitoring/view/components/bottom_navbar.dart';
import 'package:smart_indoor_garden_monitoring/view/components/exit_dialog.dart';

enum ReportType { sensor, device }
Query dataTemp, dataHumid, dataLight, dataMoisture, dataSensor;

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
        .child("tempReadings")
        .limitToFirst(40);

    dataHumid = FirebaseDatabase.instance
        .reference()
        .child("readings")
        .child("humidReadings")
        .limitToFirst(40);

    dataLight = FirebaseDatabase.instance
        .reference()
        .child("readings")
        .child("lightReadings")
        .limitToFirst(40);

    dataMoisture = FirebaseDatabase.instance
        .reference()
        .child("readings")
        .child("soilReadings")
        .limitToFirst(40);

    dataSensor =
        FirebaseDatabase.instance.reference().child("log").child("sensorlog");

    reports = ReportType.sensor;

    print("time: " + DateTime.now().second.toString());
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
              child: reports == ReportType.sensor
                  ? GraphChart()
                  : Column(
                      children: [
                        BarChart(
                          query: dataSensor,
                        ),
                      ],
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

class GraphChart extends StatelessWidget {
  const GraphChart({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
    );
  }
}

class BarChart extends StatelessWidget {
  final query;
  BarChart({this.query});

  final String formattedDate =
      DateFormat.yMMMMd('en_US').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        child: StreamBuilder<Event>(
          stream: query.onValue,
          builder: (BuildContext context, AsyncSnapshot<Event> snap) {
            if (snap.hasData) {
              List<BarChartData> barChartData = <BarChartData>[];
              Map data = snap.data.snapshot.value;
              print(data['May 5 2021']['humidSensor']);

              for (Map childData in data.values) {
                barChartData.add(
                  BarChartData.fromMap(
                    childData.cast<String, dynamic>(),
                  ),
                );
              }
              return Padding(
                padding: EdgeInsets.all(5.0),
                child: Column(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            formattedDate,
                            style: TextStyle(),
                          ),
                          Container(
                            child: SfCartesianChart(
                              enableAxisAnimation: true,
                              primaryXAxis: CategoryAxis(
                                // labelPlacement: LabelPlacement.onTicks,
                                labelIntersectAction:
                                    AxisLabelIntersectAction.multipleRows,
                                rangePadding: ChartRangePadding.round,
                                plotOffset: 10,
                                interval: 1,
                              ),
                              series: <ChartSeries>[
                                // Renders column chart
                                ColumnSeries<BarChartData, String>(
                                  width: 1,
                                  spacing: 0.1,
                                  dataSource: barChartData,
                                  xValueMapper: (BarChartData data, _) =>
                                      data.dht11,
                                  yValueMapper: (BarChartData data, _) =>
                                      data.dht11Value,
                                ),
                                ColumnSeries<BarChartData, String>(
                                  width: 1,
                                  spacing: 0.1,
                                  dataSource: barChartData,
                                  xValueMapper: (BarChartData data, _) =>
                                      data.lightSensor,
                                  yValueMapper: (BarChartData data, _) =>
                                      data.lightValue,
                                ),
                                // ColumnSeries<BarChartData, String>(
                                //   width: 1,
                                //   spacing: 0.1,
                                //   dataSource: barChartData,
                                //   xValueMapper: (BarChartData data, _) =>
                                //       data.moistureSensor,
                                //   yValueMapper: (BarChartData data, _) =>
                                //       data.moistureSensorValue,
                                // ),
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
                                interval: 2,
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

class BarChartData {
  BarChartData(
      {this.dht11,
      this.dht11Value,
      this.lightSensor,
      this.lightValue,
      this.moistureSensor,
      this.moistureSensorValue});

  BarChartData.fromMap(Map<String, dynamic> dataMap)
      : dht11 = "DHT11",
        dht11Value = dataMap['humidSensor'],
        lightSensor = "Light Sensor",
        lightValue = dataMap['lightSensor'],
        moistureSensor = "Moisture Sensor",
        moistureSensorValue = dataMap['moistureSensor'];

  final dht11;
  final dht11Value;
  final lightSensor;
  final lightValue;
  final moistureSensor;
  final moistureSensorValue;
}
