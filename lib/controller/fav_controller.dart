// ignore_for_file: prefer_interpolation_to_compose_strings, avoid_print, unrelated_type_equality_checks

import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:milkman/Api/config.dart';
import 'package:milkman/Api/data_store.dart';
import 'package:milkman/controller/home_controller.dart';
import 'package:milkman/controller/stordata_controller.dart';

class FavController extends GetxController implements GetxService {
  StoreDataContoller storeDataContoller = Get.find();
  HomePageController homePageController = Get.find();

  addFavAndRemoveApi({String? storeId}) async {
    try {
      Map map = {
        "uid": getData.read("UserLogin")["id"],
        "store_id": storeId,
      };
      Uri uri = Uri.parse(Config.path + Config.favAndRemoveApi);
      var response = await http.post(
        uri,
        body: jsonEncode(map),
      );
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        print(result.toString());
        storeDataContoller.getStoreData(storeId: storeId);
        homePageController.getHomeDataApi();
      }
      update();
    } catch (e) {
      print(e.toString());
    }
  }
}
