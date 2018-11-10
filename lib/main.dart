import 'package:flutter/material.dart';

import './screens/LoginScreen.dart';
import './screens/HomeScreen.dart';

void main() => runApp(new ChatApp());

class ChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        primaryColor: Colors.blue.shade900,
        backgroundColor: Colors.blue.shade200
      ),
      home: new LoginScreen(),
      routes: <String, WidgetBuilder> { 
        '/login': (BuildContext context) => new LoginScreen(), 
        '/home' : (BuildContext context) => new HomeScreen() 
      },
    );
  }
}