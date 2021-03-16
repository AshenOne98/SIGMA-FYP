import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smart_indoor_garden_monitoring/view/control.dart';
import 'package:smart_indoor_garden_monitoring/view/log.dart';
import 'package:smart_indoor_garden_monitoring/view/plant_care.dart';
import 'package:smart_indoor_garden_monitoring/view/report.dart';

class BottomNavBar extends StatefulWidget {
  final int selectedIndex;

  BottomNavBar({@required this.selectedIndex});
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Color(0xFF1F2025),
      ),
      child: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.home),
            label: 'HOME',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.leaf),
            label: 'PLANT CARE',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.cog),
            label: 'CONTROL',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.clipboardList),
            label: 'LOG',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.chartBar),
            label: 'REPORT',
          ),
        ],
        currentIndex: widget.selectedIndex,
        selectedItemColor: Color(0xFFFFA800),
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamedAndRemoveUntil(
                  context, '/home', (Route<dynamic> route) => false);
              break;
            case 1:
              // Navigator.pushNamedAndRemoveUntil(
              //     context, '/plantCare', (Route<dynamic> route) => false);
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => PlantCare()));
              break;
            case 2:
              // Navigator.pushNamedAndRemoveUntil(
              //     context, '/control', (Route<dynamic> route) => false);
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Control()));
              break;
            case 3:
              // Navigator.pushNamedAndRemoveUntil(context, '/log', (_) => false);
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Log()));
              break;
            case 4:
              // Navigator.pushNamedAndRemoveUntil(
              //     context, '/report', (Route<dynamic> route) => false);
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Report()));
              break;
            default:
          }
        },
      ),
    );
  }
}
