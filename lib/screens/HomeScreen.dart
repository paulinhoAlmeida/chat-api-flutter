import 'package:flutter/material.dart';
import 'dart:async';

import '../controller/UserController.dart';

import './LoginScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserController _userController = new UserController();
  String username = "";


  @override
  void initState() {
    super.initState();
    getUserName();
  }

  Future<void> getUserName() async {
    var userName = await _userController.getUser();

    this.setState(() {
      this.username = userName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Home'),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Center(
            child: new Text('Welcome $username', style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold)),
          ),
          new RaisedButton(
            child: new Text('Log out', style: new TextStyle(color: Colors.white)),
            color: Theme.of(context).primaryColor,
            onPressed: () {
              _userController.removeSession();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => new LoginScreen()));
            },
          )
        ],
      ),
    );
  }
}