import 'package:shared_preferences/shared_preferences.dart';

abstract class Controller {
  final String baseUrl = "https://chat-api-stijn.herokuapp.com/api";
  SharedPreferences sharedPref;
}