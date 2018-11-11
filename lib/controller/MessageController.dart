import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chat_app/controller/Controller.dart';
import 'package:chat_app/controller/LoginController.dart';

class MessageController extends Controller {
  LoginController _loginController = new LoginController();

  MessageController() {
    this.setup();
  }

  @override
  void setup() async {
    sharedPref = await SharedPreferences.getInstance();
  }

  Future getAllMessages() async {
    final sessionId = await _loginController.getLocalToken();
    final response = await http.get("$baseUrl/messages",
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'JWT $sessionId'
      }
    );

    if(response.statusCode == 200) {
      final parsedJson = json.decode(response.body);

      return parsedJson;
    }

    if(response.statusCode == 401) {
      return 'not-authorized';
    }
  }

  Future postMessage(String message) async {
    final sessionId = await _loginController.getLocalToken();
    final userName = sharedPref.getString('username');

    print(userName);

    try {
      final response = await http.post("$baseUrl/messages", 
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'JWT $sessionId'
        },
        body: json.encode({
          'user': userName,
          'message': message
        })
      );

      if(response.statusCode == 200) {
        final parsedJson = json.decode(response.body);
        return parsedJson;
      }

      if(response.statusCode == 401) {
        return 401;
      }

    } catch(err) {
      print(err);
    }
  }

}