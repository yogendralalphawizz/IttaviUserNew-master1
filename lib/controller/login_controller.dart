// ignore_for_file: avoid_print, prefer_interpolation_to_compose_strings

import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:milkman/Api/config.dart';
import 'package:milkman/Api/data_store.dart';
import 'package:milkman/helpar/routes_helper.dart';
import 'package:milkman/utils/Custom_widget.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class LoginController extends GetxController implements GetxService {
  TextEditingController number = TextEditingController();
  TextEditingController password = TextEditingController();

  TextEditingController newPassword = TextEditingController();
  TextEditingController newConformPassword = TextEditingController();

  bool showPassword = true;
  bool newShowPassword = true;
  bool conformPassword = true;
  bool isChecked = false;

  String userMessage = "";
  String resultCheck = "";

  String forgetPasswprdResult = "";
  String forgetMsg = "";

  changeRememberMe(bool? value) {
    isChecked = value ?? false;
    update();
  }

  showOfPassword() {
    showPassword = !showPassword;
    update();
  }

  newShowOfPassword() {
    newShowPassword = !newShowPassword;
    update();
  }

  newConformShowOfPassword() {
    conformPassword = !conformPassword;
    update();
  }

  getLoginApiData(String cuntryCode) async {
    try {
      Map map = {
        "mobile": number.text,
        "ccode": '+91',
        "password": password.text,
      };
      Uri uri = Uri.parse(Config.path + Config.loginApi);
      var response = await http.post(
        uri,
        body: jsonEncode(map),
      );
      print("***********" + uri.toString());
      print("*********** $map" );
      if (response.statusCode == 200) {
        save('Firstuser', true);
        var result = jsonDecode(response.body);
        userMessage = result["ResponseMsg"];
        resultCheck = result["Result"];
        showToastMessage(userMessage);
        if (resultCheck == "true") {
          Get.offAllNamed(Routes.bottombarProScreen);
          number.text = "";
          password.text = "";
          isChecked = false;
          update();
        }
        save("UserLogin", result["UserLogin"]);
        initPlatformState();
        OneSignal.User.addTagWithKey("user_id", getData.read("UserLogin")["id"]);
        update();
      }
      print(Config.path);
    } catch (e) {
      print(Config.path);
      print(e.toString());
    }
  }

  setForgetPasswordApi({
    String? mobile,
    String? ccode,
  }) async {
    try {
      Map map = {
        "mobile": mobile,
        "ccode": ccode,
        "password": newPassword.text,
      };
      Uri uri = Uri.parse(Config.path + Config.forgetPassword);
      var response = await http.post(
        uri,
        body: jsonEncode(map),
      );
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        forgetPasswprdResult = result["Result"];
        forgetMsg = result["ResponseMsg"];
        if (forgetPasswprdResult == "true") {
          Get.toNamed(Routes.loginScreen);
          showToastMessage(forgetMsg);
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
