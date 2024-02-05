// ignore_for_file: avoid_print, prefer_interpolation_to_compose_strings

import 'dart:convert';

import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:milkman/Api/config.dart';
import 'package:milkman/Api/data_store.dart';
import 'package:milkman/model/catwise_info.dart';
import 'package:milkman/screen/bottombarpro_screen.dart';
import 'package:milkman/screen/onbording_screen.dart';
import 'package:milkman/utils/cart_item.dart';

class CatDetailsController extends GetxController implements GetxService {
  CatWiseInfo? catWiseInfo;

  bool isLoading = false;

  String strId = "";
  Box<CartItem> cart = Hive.box<CartItem>('cart');
  List count = [];

  String id = "";
  double price = 0.0;

  double productPrice = 0.0;
  String strTitle = "";
  String per = "";
  String isRequride = "";
  String qLimit = "";
  String storeID = "";

  changeIndex(int index) {
    currentIndex = index;
    update();
  }

  getCartLangth() {
    count = [];
    for (var element in cart.values) {
      if (element.storeID == strId) {
        count.add(element.id);
      }
      update();
    }
    update();
  }

  getDetails({
    String? id1,
    price1,
    quantity1,
    productPrice1,
    strTitle1,
    per1,
    isRequride1,
    qLimit1,
    storeID1,
  }) {
    id = id1 ?? "";
    price = double.parse(price1);
    productPrice = double.parse(productPrice1);
    strTitle = strTitle1;
    per = per1;
    isRequride = isRequride1;
    qLimit = qLimit1;
    storeID = storeID1;
    update();
  }

  getCatWiseData({String? catId}) async {
    try {
      Map map = {
        "uid": getData.read("UserLogin")["id"],
        "lats": lat.toString(),
        "longs": long.toString(),
        "cat_id": catId,
      };
      Uri uri = Uri.parse(Config.path + Config.catWiseData);
      var response = await http.post(
        uri,
        body: jsonEncode(map),
      );
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        catWiseInfo = CatWiseInfo.fromJson(result);
      }
      isLoading = true;
      update();
    } catch (e) {
      print(e.toString());
    }
  }
}
