import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
              Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
              break;
            case 1:
              Navigator.pushNamedAndRemoveUntil(
                  context, '/plantCare', (_) => false);
              break;
            case 2:
              Navigator.pushNamedAndRemoveUntil(
                  context, '/control', (_) => false);
              break;
            case 3:
              Navigator.pushNamedAndRemoveUntil(context, '/log', (_) => false);
              break;
            case 4:
              Navigator.pushNamedAndRemoveUntil(
                  context, '/report', (_) => false);
              break;
            default:
          }
        },
      ),
    );
  }
}
