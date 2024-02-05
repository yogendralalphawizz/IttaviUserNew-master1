// ignore_for_file: avoid_print, prefer_interpolation_to_compose_strings

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:milkman/Api/config.dart';
import 'package:milkman/Api/data_store.dart';
import 'package:milkman/model/ndetails_info.dart';
import 'package:milkman/model/norder_info.dart';
import 'package:milkman/utils/Custom_widget.dart';

class MyOrderController extends GetxController implements GetxService {
  NOrderInfo? nOrderInfo;
  NDetailsInfo? nDetailsInfo;

  bool isLoading = false;
  TextEditingController ratingText = TextEditingController();

  double tRate = 1.0;

  int currentIndex = 0;

  totalRateUpdate(double rating) {
    tRate = rating;
    update();
  }

  changeIndexProductWise({int? index}) {
    currentIndex = index ?? 0;
    update();
  }

  // myOrderHistory({String? statusWise}) async {
  //   try {
  //     isLoading = false;
  //     update();
  //     Map map = {
  //       "uid": getData.read("UserLogin")["id"],
  //       "status": statusWise,
  //     };
  //     Uri uri = Uri.parse(Config.path + Config.myOrderHistory);
  //     var response = await http.post(
  //       uri,
  //       body: jsonEncode(map),
  //     );
  //     if (response.statusCode == 200) {
  //       var result = jsonDecode(response.body);
  //       orderInfo = OrderInfo.fromJson(result);
  //     }
  //     isLoading = true;
  //     update();
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

  cancleOrder({String? orderId1, reason}) async {
    try {
      isLoading = false;
      update();
      Map map = {
        "uid": getData.read("UserLogin")["id"],
        "order_id": orderId1,
        "comment_reject": reason,
      };
      print(".............." + map.toString());
      Uri uri = Uri.parse(Config.path + Config.orderCancle);
      var response = await http.post(
        uri,
        body: jsonEncode(map),
      );
      print(".............." + response.body.toString());
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        if (result["Result"] == "true") {
          normalOrderHistory(statusWise: 'Current');
          Get.back();
        }
        showToastMessage(result["ResponseMsg"]);
      }
      isLoading = true;
      update();
    } catch (e) {
      print(e.toString());
    }
  }

  orderReviewApi({String? orderID}) async {
    try {
      Map map = {
        "uid": getData.read("UserLogin")["id"],
        "order_id": orderID,
        "total_rate": tRate.toString(),
        "rate_text": ratingText.text != "" ? ratingText.text : "",
      };

      print("!!!!!!!!!!!!!!!!" + map.toString());
      Uri uri = Uri.parse(Config.path + Config.orderReview);
      var response = await http.post(
        uri,
        body: jsonEncode(map),
      );
      print(response.body);
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        tRate = 1.0;
        ratingText.text = "";
        Get.back();
        normalOrderDetails(orderID: orderID);
        showToastMessage(result["ResponseMsg"]);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  normalOrderHistory({String? statusWise}) async {
    try {
      isLoading = false;
      Map map = {
        "uid": getData.read("UserLogin")["id"],
        "status": "${statusWise}",
      };
      print("========normal order history =======${map}===========");
      Uri uri = Uri.parse(Config.path + Config.normalOrderHistory);
      var response = await http.post(
        uri,
        body: jsonEncode(map),
      );
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        print(result.toString());
        nOrderInfo = NOrderInfo.fromJson(result);
      }
      isLoading = true;
      update();
    } catch (e) {
      print(e.toString());
    }
  }

  normalOrderDetails({String? orderID}) async {
    try {
      isLoading = false;
      Map map = {
        "uid": getData.read("UserLogin")["id"],
        "order_id": orderID,
      };
      print("ordere details ${map}");
      Uri uri = Uri.parse(Config.path + Config.normalOrderInfo);
      var response = await http.post(
        uri,
        body: jsonEncode(map),
      );
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        nDetailsInfo = NDetailsInfo.fromJson(result);
      }
      isLoading = true;
      update();
    } catch (e) {
      print(e.toString());
    }
  }
}
