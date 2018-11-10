import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:chat_app/controller/Controller.dart';
import 'package:chat_app/controller/LoginController.dart';

class MessageController extends Controller {
  LoginController _loginController = new LoginController();

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

}