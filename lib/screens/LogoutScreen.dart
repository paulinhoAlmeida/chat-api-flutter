import 'package:flutter/material.dart';

import 'package:chat_app/controller/LoginController.dart';

import 'package:chat_app/screens/LoginScreen.dart';

class LogoutScreen extends StatefulWidget {
  @override
  _LogoutScreenState createState() => _LogoutScreenState();
}

class _LogoutScreenState extends State<LogoutScreen> {
  LoginController _loginController;

  @override
  void initState() {
    super.initState();
    _loginController = new LoginController();
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text('Log out'),
          content: new Text('Are you sure?'),
          actions: [
            new FlatButton(
              child: new Text('NO', style: new TextStyle(color: Colors.teal)),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            new FlatButton(
              child: new Text('YES', style: new TextStyle(color: Colors.teal)),
              onPressed: () async {
                _loginController.removeLocalToken();
                Navigator.pushAndRemoveUntil(context, 
                  MaterialPageRoute(
                    builder: (context) => LoginScreen()
                  ), 
                  ModalRoute.withName('/login')
                );
              },
            )
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: new Center(
        child: new MaterialButton(
          color: Colors.red.shade700,
          child: new Text("Click here to log out", style: new TextStyle(color: Colors.white)),
          onPressed: () {
            _showDialog();
          },
        ),
      ),
    );
  }
}