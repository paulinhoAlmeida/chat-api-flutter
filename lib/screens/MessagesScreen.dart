import 'package:flutter/material.dart';
import 'dart:async';

import 'package:chat_app/controller/LoginController.dart';
import 'package:chat_app/controller/MessageController.dart';
import 'package:chat_app/screens/LoginScreen.dart';

class MessagesScreen extends StatefulWidget {
  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  final TextEditingController _textController = new TextEditingController();
  MessageController _messageController;
  LoginController _loginController;
  var messages;
  bool isLoading;

  @override
  void initState() {
    super.initState();
    _messageController = new MessageController();
    _loginController = new LoginController();
    isLoading = true;
    setup();
  }

  void _showDialog() {
    showDialog(
      context: (context),
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text('Sessie verlopen'),
          actions: <Widget>[
            new FlatButton(
              child: new Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        );
      }
    );
  }

  setup() async {
    messages = await _messageController.getAllMessages();
    if(messages == 'not-authorized') {
      _showDialog();
      _loginController.removeLocalToken();
      Navigator.pushAndRemoveUntil(context, 
        MaterialPageRoute(
          builder: (context) => LoginScreen()
        ), 
        ModalRoute.withName('/login')
      );
    }
    this.setState(() {
      messages = messages;
      isLoading = false;
    });
  }

  renderMessages() {
    List<Widget> list = new List<Widget>();
    for(var item in this.messages) {
      list.add(new Card(
              child: new ListTile(
          leading: new CircleAvatar(
            child: new Text(item['user']),
          ),
          title: new Text(item['message']),
          subtitle: new Text(item['time']),
          onTap: () {
            print(item['message']);
          },
        ),
      ));
    }

    return list;
  }

  Future _refresh() {
    _refreshIndicatorKey.currentState.show();
    return setup();
  }

  Future _handleSubmitted(String message) async {
    _textController.clear();
    final response = await _messageController.postMessage(message);

    print(response);

    if(response['message'] != null) {
      this.setState(() {
        this._refreshIndicatorKey.currentState.show();
      });
    }
  }

  Widget _textComposerWidget() {
    return new IconTheme(
      data: new IconThemeData(color: Colors.blue),
      child: new Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(
          children: <Widget>[
            new Flexible(
              child: new TextField(
                decoration: new InputDecoration.collapsed(hintText: "Send a message"),
                controller: _textController,
                onSubmitted: _handleSubmitted,
              ),
            ),
            new Container(
              decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(30.0))
              ),
              margin: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
              child: new IconButton(
                icon: new Icon(Icons.send),
                onPressed: () => _handleSubmitted(_textController.text),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height / 2;
    if(isLoading) {
      return new Center(
        child: new CircularProgressIndicator()
      ); 
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new Flexible(
            child: RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: _refresh,
              child: (isLoading) ? _refreshIndicatorKey.currentState.show() : 
              new ListView(
                children: renderMessages(),
              ),
            ),
          ),
          new Divider(
            height: 1.0,
          ),
          new Container(
            child: _textComposerWidget(),
          )
        ]
      );
    }
  }
}