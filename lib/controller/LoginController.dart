import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chat_app/controller/Controller.dart';

class LoginController extends Controller {

  Future login(username, password) async {

    sharedPref = await SharedPreferences.getInstance();

    try {
      final response = await http.post("$baseUrl/auth", 
        headers: {
          'Content-Type': 'application/json'
        },
        body: json.encode({
          "user": username,
          "password": password
        })
      ); 

      print(response.statusCode);

      if(response.statusCode == 200) {
        final parsedJson = json.decode(response.body);
        sharedPref.setString('token', parsedJson['token']);

        return parsedJson['token'];
      } 
      
      if(response.statusCode == 401) {
        return 'wrong-credentials';
      } else {
        return "";
      }

    } catch(err) {
      print(err);
    }
  }

  Future getLocalToken() async {
    sharedPref = await SharedPreferences.getInstance();

    return sharedPref.getString('token');
  }

  Future removeLocalToken() async {
    sharedPref = await SharedPreferences.getInstance();

    sharedPref.remove('username');
    sharedPref.remove('token');
  }
}