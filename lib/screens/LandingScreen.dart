import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:chat_app/controller/UserController.dart';

class LandingScreen extends StatefulWidget {
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> with TickerProviderStateMixin {
  UserController _userController = new UserController();
  SharedPreferences sharedPref;
  String username = "";

  @override
  void initState() {
    super.initState();
    getUserName();
  }

  Future<void> getUserName() async {
    sharedPref = await SharedPreferences.getInstance();
    var userName = '';

    if(sharedPref.getString('username') == null) {
       userName = await _userController.getUser();
       await sharedPref.setString('username', userName);
    } else {
      userName = sharedPref.getString('username');
    }

    this.setState(() {
      this.username = userName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Center(
          child: new Text('Welcome $username', style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold)),
        ),
      ]
    );
  }
}