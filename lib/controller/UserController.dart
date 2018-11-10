import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chat_app/controller/Controller.dart';

class UserController extends Controller {
  
  Future getUser() async {
    final token = await getLocalToken();

    try {
      final response = await http.get("$baseUrl/users/me",
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'JWT $token'
        }
      );

      print(response.statusCode);

      if(response.statusCode == 200) {
        final parsedJson = json.decode(response.body);
        return parsedJson['local']['name'];
      } else {
        return "";
      }
    } catch(err) {
      print(err);
    }
  }

  Future removeSession() async {
    sharedPref = await SharedPreferences.getInstance();

    sharedPref.remove('token');
  }

  Future getLocalToken() async {
    sharedPref = await SharedPreferences.getInstance();

    return sharedPref.getString('token');
  }
}