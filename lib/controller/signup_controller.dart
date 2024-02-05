// ignore_for_file: avoid_print, unused_local_variable, prefer_interpolation_to_compose_strings

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:milkman/Api/config.dart';
import 'package:milkman/Api/data_store.dart';
import 'package:milkman/helpar/routes_helper.dart';
import 'package:milkman/model/pagelist_info.dart';
import 'package:milkman/screen/loginAndsignup/resetpassword_screen.dart';
import 'package:milkman/utils/Custom_widget.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpController extends GetxController implements GetxService {
  PageListInfo? pageListInfo;
  bool isLoading = false;

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController number = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController referralCode = TextEditingController();

  bool showPassword = true;
  bool chack = false;
  int currentIndex = 0;
  int? otp;
  String userMessage = "";
  String resultCheck = "";

  String signUpMsg = "";

  SignUpController() {
    pageListApi();
  }

  showOfPassword() {
    showPassword = !showPassword;
    update();
  }

  checkTermsAndCondition(bool? newbool) {
    chack = newbool ?? false;
    update();
  }

  cleanFild() {
    name.text = "";
    email.text = "";
    number.text = "";
    password.text = "";
    referralCode.text = "";
    chack = false;
    update();
  }

  changeIndex(int index) {
    currentIndex = index;
    update();
  }

  checkMobileNumber(String cuntryCode) async {
    try {
      Map map = {
        "mobile": number.text,
        "ccode": "+91",
      };print("nenenennennen ${map}");
      Uri uri = Uri.parse(Config.path + Config.mobileChack);
      var response = await http.post(
        uri,
        body: jsonEncode(map),
      );

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        userMessage = result["ResponseMsg"];
        resultCheck = result["Result"];
        otp = result["otp"];
        print("MMMMMMMMMMMMMMMMMM" + userMessage  + otp.toString());
        if (resultCheck == "true") {
          sendOTP(number.text, cuntryCode,);
          Get.toNamed(Routes.otpScreen, arguments: {
            "number": number.text,
            "cuntryCode": cuntryCode,
            'otp': otp,
            "route": "signUpScreen",
          });
        }
        showToastMessage(userMessage,);
      }
      update();
    } catch (e) {
      print(e.toString());
    }
  }

  checkMobileInResetPassword({String? number, String? cuntryCode}) async {
    try {
      Map map = {
        "mobile": number,
        "ccode": cuntryCode,
      };
      print("hhjghj ${map}");
      Uri uri = Uri.parse(Config.path + Config.mobileChack);
      var response = await http.post(
        uri,
        body: jsonEncode(map),
      );

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        userMessage = result["ResponseMsg"];
        resultCheck = result["Result"];
        if (resultCheck == "false") {
          sendOTP(number ?? "", cuntryCode ?? "");
          Get.toNamed(Routes.otpScreen, arguments: {
            "number": number,
            "cuntryCode": cuntryCode,
            "route": "resetScreen",
          });
        } else {
          showToastMessage('Invalid Mobile Number');
        }
      }
      update();
    } catch (e) {
      print(e.toString());
    }
  }

  setUserApiData(String cuntryCode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      Map map = {
        "name": name.text,
        "email": email.text,
        "mobile": number.text,
        "ccode": cuntryCode,
        "password": password.text,
        "refercode": referralCode.text
      };
      print("check register para${map}");
      Uri uri = Uri.parse(Config.path + Config.registerUser);
      var response = await http.post(
        uri,
        body: jsonEncode(map),
      );
      print(map);
      print(uri);
      print(response.toString());
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        save("UserLogin", result["UserLogin"]);
        save('Firstuser', true);
        signUpMsg = result["ResponseMsg"];
        showToastMessage(signUpMsg);
        Get.offAndToNamed(Routes.homeScreen);
        initPlatformState();
        OneSignal.User.addTagWithKey("user_id", getData.read("UserLogin")["id"]);
        update();
      }
    } catch (e) {
      print(e.toString());
    }
  }

  editProfileApi({
    String? name,
    String? password,
  }) async {
    try {
      Map map = {
        "name": name,
        "password": password,
        "uid": getData.read("UserLogin")["id"].toString(),
      };
      Uri uri = Uri.parse(Config.path + Config.profileEdit);
      var response = await http.post(
        uri,
        body: jsonEncode(map),
      );
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        showToastMessage(result["ResponseMsg"]);
        save("UserLogin", result["UserLogin"]);
      }
      Get.back();
      update();
    } catch (e) {
      print(e.toString());
    }
  }

  pageListApi() async {
    try {
      Map map = {
        "uid": getData.read("UserLogin")["id"],
      };
      Uri uri = Uri.parse(Config.path + Config.pageList);
      var response = await http.post(
        uri,
        body: jsonEncode(map),
      );
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        pageListInfo = PageListInfo.fromJson(result);
      }
      isLoading = true;
      update();
    } catch (e) {
      print(e.toString());
    }
  }
}
