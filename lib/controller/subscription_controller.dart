// ignore_for_file: avoid_print, unnecessary_string_interpolations, prefer_interpolation_to_compose_strings, unused_local_variable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:milkman/Api/config.dart';
import 'package:milkman/Api/data_store.dart';
import 'package:milkman/controller/home_controller.dart';
import 'package:milkman/model/sdetails_info.dart';
import 'package:milkman/model/sorder_info.dart';
import 'package:milkman/utils/Custom_widget.dart';

class PreScriptionControllre extends GetxController implements GetxService {
  HomePageController homePageController = Get.find();

  List<String> path = [];
  bool isLoading = false;

  SOrderInfo? sOrderInfo;
  SDetailsInfo? sDetailsInfo;

  TextEditingController ratingText = TextEditingController();

  double tRate = 1.0;

  bool isOrderLoading = false;
  int currentIndex = 0;
  int? index;

  var selectDate = [];

  totalRateUpdate(double rating) {
    tRate = rating;
    update();
  }

  setOrderLoading() {
    isOrderLoading = true;
    update();
  }

  changeDateIndex({int? index, String? date}) {
    print("<<<<<<<<>>>>>>>" + date.toString());
    if (selectDate.contains(date)) {
      selectDate.remove(date);
      update();
    } else {
      selectDate.add(date);
      update();
    }
  }

  makeDicision({String? oID, status, reson}) async {
    try {
      Map map = {
        "oid": oID,
        "status": status,
        "comment_reject": reson,
      };
      Uri uri = Uri.parse(Config.path + Config.makeDecision);
      var response = await http.post(
        uri,
        body: jsonEncode(map),
      );
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);

        showToastMessage(result["ResponseMsg"]);
      }
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
      Uri uri = Uri.parse(Config.path + Config.priOrderReview);
      var response = await http.post(
        uri,
        body: jsonEncode(map),
      );
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        tRate = 1.0;
        ratingText.text = "";
        Get.back();
        subScriptionOrderInfo(orderID: orderID);
        showToastMessage(result["ResponseMsg"]);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  subScriptionOrderHistory({String? statusWise}) async {
    try {
      isLoading = false;
      Map map = {
        "uid": getData.read("UserLogin")["id"],
        "status": statusWise,
      };
      Uri uri = Uri.parse(Config.path + Config.subScriptionHistory);
      var response = await http.post(
        uri,
        body: jsonEncode(map),
      );
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        sOrderInfo = SOrderInfo.fromJson(result);
        print(result.toString());
      }
      isLoading = true;
      update();
    } catch (e) {
      print(e.toString());
    }
  }

  changeIndexProductWise({int? index}) {
    currentIndex = index ?? 0;
    update();
  }

  subScriptionOrderInfo({String? orderID}) async {
    try {
      isLoading = false;
      Map map = {
        "uid": getData.read("UserLogin")["id"],
        "order_id": orderID,
      };
      print("new parameter ${map}");
      Uri uri = Uri.parse(Config.path + Config.subScriptionInfo);
      var response = await http.post(
        uri,
        body: jsonEncode(map),
      );
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        sDetailsInfo = SDetailsInfo.fromJson(result);
      }
      isLoading = true;
      update();
    } catch (e) {
      print(e.toString());
    }
  }

  skipOrExtendDay({String? itemId, orderId, total, status}) async {
    var list = [];
    for (var i = 0; i < selectDate.length; i++) {
      list.add(jsonEncode(selectDate[i]));
    }
    print("|||||||||----------->>" + list.toString());
    try {
      isLoading = false;
      Map map = {
        "uid": getData.read("UserLogin")["id"],
        "order_id": orderId.toString(),
        "item_id": itemId.toString(),
        "total": total,
        "status": status,
        "sday": list.toString(),
      };
// {
//     "uid": "2",
//     "order_id": "1",
//     "item_id": "1",
//     "total": 22.5,
//     "status": "skip",
//     "sday": "[\"2023-06-01\",\"2023-06-09\"]"
// }
      print("**********(Skip:Map:Extend)*********" + map.toString());
      Uri uri = Uri.parse(Config.path + Config.skipAndExtend);
      var response = await http.post(
        uri,
        body: jsonEncode(map),
      );
      print("**********(Skip:Response:Extend)*********" + response.body);
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        selectDate = [];
        list = [];
        subScriptionOrderInfo(orderID: orderId);
        showToastMessage(result["ResponseMsg"]);
        homePageController.getHomeDataApi();
      }
      isLoading = true;
      update();
    } catch (e) {
      print(e.toString());
    }
  }
}
