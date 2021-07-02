import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mysql_app_php_flutter/model/User.dart';

class Services{
  static const root="http://mysqlphpmadfinals.000webhostapp.com/db_config.php";
  static const _GET_ALL_ACTION="GET_ALL";
  static const _ADD_USER_ACTION="ADD_USER";
  static const _UPDATE_USER_ACTION="UPDATE_USER";
  static const _DELETE_USER_ACTION="DELETE_USER";


  static Future<List<User>> getUsers() async {
    try {
      print("inside original getUsers()");
      var map = Map<String, dynamic>();
      map['action'] = _GET_ALL_ACTION;
      await http.post(Uri.
      parse(root), body: map).
      then((response) {
        print("the response of getUsers() is: ${response.body}");
        if (response.statusCode == 200) {
          List<User> list = parseResponse(response.body);
          print("response body is ${response.body}");
          print("returned list is $list");
          return list;
        } else {
          throw List<User>();
        }
      });

    } catch (e) {
      return List<User>();
    }
  }

  static List<User> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).
    cast<Map<String, dynamic>>();
    print(parsed.map<User>((json) => User.fromJson(json)).toList());
    return parsed.map<User>((json) => User.fromJson(json)).toList();
  }

  static Future<String> addUser(String name, String email,
      String phone, String skill, String blood_group, String address) async {
    try {
      var map = new Map<String, dynamic>();
      map["action"] = _ADD_USER_ACTION;
      map["name"] = name;
      map["email"] = email;
      map["phone"] = phone;
      map["skill"] = skill;
      map["blood_group"] = blood_group;
      map["address"] = address;
      final response = await http.post(Uri.parse(root), body: map);
      print("addEmployee >> Response:: ${response.body}");
      return response.body;
    } catch (e) {
      return 'error';
    }
  }


  static Future<String> updateUser(
      String name, String email,
      String phone, String skill, String blood_group,
      String address) async {
    try {
      var map = new Map<String, dynamic>();
      map["action"] = _UPDATE_USER_ACTION;
      map["name"] = name;
      map["email"] = email;
      map["phone"] = phone;
      map["skill"] = skill;
      map["blood_group"] = blood_group;
      map["address"] = address;
      final response = await http.post(Uri.parse(root), body: map);
      if (response.statusCode == 200) {
        print("updateEmployee >> Response:: ${response.body}");
        return response.body;
      }
      else{
        return "error";
      }

    } catch (e) {
      return 'error';
    }
  }

  static Future<String> deleteUser(String email) async {
    try {
      var map = new Map<String, dynamic>();
      map["action"] = _DELETE_USER_ACTION;
      map["email"] = email;
      final response = await http.post(Uri.parse(root), body: map);
      if (response.statusCode == 200) {
        print("response body is ${response.body}");
        print("deleteEmployee >> Response:: ${response.body}");
        return response.body;
      } else {
        return 'error';
      }
    } catch (e) {
      return 'error';
    }
  }

}
