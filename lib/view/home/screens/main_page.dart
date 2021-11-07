import 'package:flutter/material.dart';
import 'home_page.dart';
import 'profile_page.dart';
import '../widgets/opinion_widget.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    OpinionWidget(),
    Text(
      'Previous Votes',
      style: TextStyle(
        fontSize: 35,
        fontWeight: FontWeight.bold,
      ),
    ),
    ProfileScreen(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Home Page'),
      // ),
      body: SafeArea(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: Colors.black,
              ),
              label: 'asd',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.add,
                color: Colors.black,
              ),
              label: 'Create Post',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.category,
                color: Colors.black,
              ),
              label: 'Votes',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                color: Colors.black,
              ),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          elevation: 0),
    );
  }
}
