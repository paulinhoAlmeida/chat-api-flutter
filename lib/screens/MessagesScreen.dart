import 'package:flutter/material.dart';
import 'dart:async';

import 'package:chat_app/controller/MessageController.dart';

class MessagesScreen extends StatefulWidget {
  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  MessageController _messageController;
  var messages = [];
  bool isLoading;

  @override
  void initState() {
    super.initState();
    _messageController = new MessageController();
    isLoading = true;
    setup();
  }

  setup() async {
    messages = await _messageController.getAllMessages();
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
          new Padding(
            padding: const EdgeInsets.all(10.0),
            child: new Container(
              height: height,
              color: Theme.of(context).backgroundColor,
              child: RefreshIndicator(
                key: _refreshIndicatorKey,
                onRefresh: _refresh,
                child: (isLoading) ? _refreshIndicatorKey.currentState.show() : 
                new ListView(
                  children: renderMessages(),
                ),
              ),
            ),
          ),
        ]
      );
    }
  }
}