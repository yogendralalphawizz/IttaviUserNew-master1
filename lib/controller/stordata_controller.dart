// ignore_for_file: avoid_print, unrelated_type_equality_checks, prefer_interpolation_to_compose_strings

import 'dart:convert';

import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:http/http.dart' as http;
import 'package:milkman/Api/config.dart';
import 'package:milkman/Api/data_store.dart';
import 'package:milkman/model/storedata_info.dart';
import 'package:milkman/screen/onbording_screen.dart';

class StoreDataContoller extends GetxController implements GetxService {
  bool isLoading = false;
  StoreDataInfo? storeDataInfo;

  String storeid = "";

  getStoreData({String? storeId, pincode}) async {
    try {
      Map map = {
        "uid": getData.read("UserLogin")["id"],
        "store_id": '13',
        "lats": lat.toString(),
        "longs": long.toString(),
        "pincode": pincode.toString()
        // "pincode":"4",
      };
      print(map.toString());
      Uri uri = Uri.parse(Config.path + Config.storeData);
      var response = await http.post(
        uri, body: jsonEncode(map),
      );
      print("2@@@@@@@@@ " + uri.path);
      print("<<<<<<<<Response>>>>>>>>>>" + response.body);
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        print(result.toString());
        storeid = result["StoreInfo"]["store_id"];
        print("SSSSSSSSSS" + storeId.toString());
        storeDataInfo = StoreDataInfo.fromJson(result);
      }
      isLoading = true;
      update();
    } catch (e) {
      print(e.toString());
    }
  }
}
