// ignore_for_file: avoid_print, unused_local_variable

import 'dart:convert';

import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:milkman/Api/config.dart';
import 'package:milkman/Api/data_store.dart';
import 'package:milkman/model/search_info.dart';
import 'package:milkman/model/searchproduct_info.dart';
import 'package:milkman/screen/onbording_screen.dart';
import 'package:http/http.dart' as http;

class SearchController1 extends GetxController implements GetxService {
  List<SearchInfo> searchInfo = [];
  List<SearchProductInfo> searchProductInfo = [];
  bool isLoading = false;

  getSearchStoreData({String? keyWord}) async {
    try {
      isLoading = false;
      Map map = {
        "uid": getData.read("UserLogin")["id"],
        "lats": lat,
        "longs": long,
        "keyword": keyWord,
      };
      print("serach parra ${map}");
      Uri uri = Uri.parse(Config.path + Config.storeSearchApi);
      var response = await http.post(
        uri,
        body: jsonEncode(map),
      );
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        searchInfo = [];
        for (var element in result["SearchStoreData"]) {
          searchInfo.add(SearchInfo.fromJson(element));
        }
        print(result.toString());
      }
      isLoading = true;
      update();
    } catch (e) {
      print(e.toString());
    }
  }

  getSearchProductData({String? keyWord, storeID}) async {
    print("workingggggg");
    try {
      isLoading = false;
      Map map = {
        "uid": getData.read("UserLogin")["id"],
        "store_id": "13",
        "keyword": keyWord,
      };
      Uri uri = Uri.parse(Config.path + Config.productSearch);
      print(uri);
      print("map productt isss ${map}");
      var response = await http.post(
        uri,
        body: jsonEncode(map),
      );
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        searchProductInfo = [];
        for (var element in result["SearchData"]) {
          searchProductInfo.add(SearchProductInfo.fromJson(element));
        }
        print(searchProductInfo.length.toString() +'jhjkhjhkjhjkhkhk');
        print(result.toString());
      }
      isLoading = true;
      update();
    } catch (e) {
      print(e.toString());
    }
  }
}
