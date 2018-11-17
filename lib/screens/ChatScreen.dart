import 'package:flutter/material.dart';
import 'dart:async';
import 'package:chat_app/controller/UserController.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  UserController _userController;
  var chats = [];
  var otherUsers;
  bool isLoading;

  @override
  void initState() {
    super.initState();
    _userController = new UserController();
    isLoading = true;
    setup();
  }

  Future setup() async {
    final allUsers = await _userController.getAllUsers();
    this.setState(() {
      otherUsers = allUsers;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(isLoading) {
      return new Center(
        child: new CircularProgressIndicator(),
      );
    } else {

    }
    return new Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        new Flexible(
          child: new Text('ChatScreen'),
        )
      ],
    );
  }
}