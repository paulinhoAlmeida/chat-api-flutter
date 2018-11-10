import 'package:flutter/material.dart';

import 'package:chat_app/screens/LandingScreen.dart';
import 'package:chat_app/screens/MessagesScreen.dart';
import 'package:chat_app/screens/LogoutScreen.dart';
import 'package:chat_app/Widgets/BottomTabBar.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  String username = "";
  Widget _currentScreen;
  Widget _landingScreen;
  Widget _messagesScreen;
  Widget _logOutScreen;
  List<Widget> _children;

  @override
  void initState() {
    super.initState();
    _landingScreen = new LandingScreen();
    _messagesScreen = new MessagesScreen();
    _logOutScreen = new LogoutScreen();
    _children =  [
      _landingScreen,
      _messagesScreen,
      _logOutScreen
    ];
    _currentScreen = _children[0];
  }

  void _selectedTab(int index) {
    print(index);
    setState(() {
      _currentScreen = _children[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
        length: 2,
        child: new Scaffold(
        appBar: new AppBar(
          title: new Text('Chat app'),
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        body: _currentScreen,
        bottomNavigationBar: new BottomTabBar(
          backgroundColor: Theme.of(context).primaryColor,
          color: Colors.white,
          selectedColor: Colors.red,
          onTabSelected: _selectedTab,
          items: [
            BottomAppBarItem(iconData: Icons.home, text: 'Home'),
            BottomAppBarItem(iconData: Icons.message, text: 'Messages'),
            BottomAppBarItem(iconData: Icons.exit_to_app, text: 'Log out'),
          ],
        ),
      ),
    );
  }
}