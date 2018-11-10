import 'package:flutter/material.dart';
import 'dart:async';

import 'package:chat_app/controller/LoginController.dart';

import 'package:chat_app/screens/HomeScreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginController _controller = new LoginController();
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    setup();
  }

  setup() async {
    var localToken = await _controller.getLocalToken();
    await new Future.delayed(new Duration(seconds: 1));
    if(localToken == null) {
      this.setState(() {
        _isLoading = false;
      });
    } else {
      Navigator.pushAndRemoveUntil(context, 
          MaterialPageRoute(
            builder: (context) => new HomeScreen()
          ),
          ModalRoute.withName('/home')
        );
    }
  }

  Future login(String username, String password) async {
    this.setState(() {
      this._isLoading = true;
    });

    try {
      final String token = await _controller.login(username, password);
      print(token);
      if(token.isNotEmpty && token != 'wrong-credentials') {
        Navigator.pushAndRemoveUntil(context, 
          MaterialPageRoute(
            builder: (context) => new HomeScreen()
          ),
          ModalRoute.withName('/home')
        );
      } 

      if(token == 'wrong-credentials') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return new AlertDialog(
              title: new Text('Verkeerde gegevens'),
              content: new Text('Probeer het opnieuw.'),
              actions: <Widget>[
                new FlatButton(
                  child: new Text('OK'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            );
          }
        );
        this.setState(() {
          this._isLoading = false;
        });
      } else {
        this.setState(() {
          this._isLoading = false;
        });
      }
    } catch(err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: new AppBar(
        title: new Text('Chat app'),
      ),
      body: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Padding(
            padding: const EdgeInsets.all(16.0),
            child: (_isLoading) ? new Center(
                child: new Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: new CircularProgressIndicator()
                ),
              ) : new Card(
              child: new Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: new Form(
                    key: _formKey,
                    child: new Column(
                      children: <Widget>[
                        new Text('Log in', style: new TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold)),
                        new TextFormField(
                          controller: this._usernameController,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter your email';
                            }
                          },
                          decoration: new InputDecoration(
                            icon: new Icon(Icons.person),
                            labelText: 'Username',
                          ),
                        ),
                        new TextFormField(
                          controller: this._passwordController,
                          obscureText: true,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter your password';
                            }
                          },
                          decoration: new InputDecoration(
                            icon: new Icon(Icons.lock),
                            labelText: 'Password',
                          ),
                        ),
                        new Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: new FlatButton(
                            color: Theme.of(context).primaryColor,
                            child: new Text('Log in', style: new TextStyle(color: Colors.white)),
                            onPressed: () {
                              print('Pressed');
                              if(_formKey.currentState.validate()) {
                                final String usernameText = this._usernameController.text;
                                final String passwordText = this._passwordController.text;
                                this.login(usernameText, passwordText);
                              }
                            },
                          ),
                        ),
                      ],
                ),
                  ),
              ),
            ),
          )
        ],
      ),
    );
  }
}