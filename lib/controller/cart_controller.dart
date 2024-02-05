// ignore_for_file: avoid_print, unused_local_variable, depend_on_referenced_packages, prefer_interpolation_to_compose_strings, prefer_collection_literals, unnecessary_cast, unnecessary_brace_in_string_interps, body_might_complete_normally_nullable, await_only_futures, unnecessary_string_interpolations

import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:milkman/Api/config.dart';
import 'package:milkman/Api/data_store.dart';
import 'package:milkman/controller/subscription_controller.dart';
import 'package:milkman/model/address_info.dart';
import 'package:milkman/model/cartdata_info.dart';
import 'package:milkman/model/coupon_info.dart';
import 'package:milkman/model/payment_info.dart';
import 'package:milkman/screen/onbording_screen.dart';
import 'package:milkman/screen/yourcart_screen.dart';
import 'package:milkman/utils/Custom_widget.dart';
import 'package:milkman/utils/cart_item.dart';
import 'package:sqflite/sqflite.dart';

class CartController extends GetxController implements GetxService {
  PreScriptionControllre preScriptionControllre = Get.find();
  AddressInfo? addressInfo;
  CouponInfo? couponInfo;
  Database? database;
  PaymentInfo? paymentInfo;
  CartDataInfo? cartDataInfo;

  bool isOrderLoading = false;

  bool isLoading = false;

  String addressLat = "";
  String addressLong = "";
  String addresTitle = "";
  String aType = "";

  double subTotal = 0.0;
  double couponAmt = 0.0;

  String couponId = "";

  String copResult = "";
  String couponMsg = "";

  List isRq = [];

  Box<CartItem> cart = Hive.box<CartItem>('cart');

  File? image;

  CartController() {
    getPaymentListApi();
  }

  setOrderLoading() {
    isOrderLoading = true;
    update();
  }

  setOrderLoadingOff() {
    isOrderLoading = false;
    update();
  }

  getSubTotalClc({double? pPrice, String? subdiv, strCharge}) {
    if (subdiv == "pluse") {
      print("+++++Pluse+++++" + subTotal.toString());
      subTotal = (subTotal + pPrice!);
      print("+++++Pluse+++++" + subTotal.toString());

      update();
    } else if (subdiv == "div") {
      print("-----div-----" + subTotal.toString());
      subTotal = (subTotal - pPrice!);

      print("-----div-----" + subTotal.toString());
      update();
    }
  }

  getTotel({double? pPrice, double? discount,int ?qyt}) {
    print(pPrice);
    print(discount);
    print(qyt);
  double data= ( pPrice!*qyt!)-pPrice* discount! * (qyt!/100);

  // double data= (pPrice!+qyt!)-
  //      pPrice! *( (discount! * qyt!)/100);
  print(data);
  subTotal=data;
//  update();
  return data;

  }

  addressListApi() async {
    try {
      isLoading = false;
      update();
      Map map = {
        "uid": getData.read("UserLogin")["id"],
      };
      Uri uri = Uri.parse(Config.path + Config.addressList);
      var response = await http.post(
        uri,
        body: jsonEncode(map),
      );
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        addressInfo = AddressInfo.fromJson(result);
      }
      isLoading = true;
      update();
    } catch (e) {
      print(e.toString());
    }
  }

  getCouponList({String? sId}) async {
    try {
      isLoading = false;
      update();
      Map map = {
        "uid": getData.read("UserLogin")["id"],
        "store_id": sId,
      };
      Uri uri = Uri.parse(Config.path + Config.couponList);
      var response = await http.post(
        uri,
        body: jsonEncode(map),
      );
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        couponInfo = CouponInfo.fromJson(result);
      }
      isLoading = true;
      update();
    } catch (e) {
      print(e.toString());
    }
  }

  getPaymentListApi() async {
    try {
      isLoading = false;
      update();
      Map map = {
        "uid": getData.read("UserLogin")["id"],
      };
      Uri uri = Uri.parse(Config.path + Config.paymentList);
      var response = await http.post(
        uri,
        body: jsonEncode(map),
      );
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        paymentInfo = PaymentInfo.fromJson(result);
      }
      isLoading = true;
      update();
    } catch (e) {
      print(e.toString());
    }
  }

  getCartDataApi({String? storeID}) async {
    try {
      isLoading = false;
      Map map = {
        "uid": getData.read("UserLogin")["id"],
        "lats": addressLat != "" ? addressLat : lat,
        "longs": addressLong != "" ? addressLong : long,
        "store_id": storeID,
      };
      print("%%%%%%%%%%%%%%%%^^^^^^^^^^^" + map.toString());
      Uri uri = Uri.parse(Config.path + Config.cartDataApi);
      var response = await http.post(
        uri,
        body: jsonEncode(map),
      );
      print("<<<<<<<<<<>>>>>>>>>>>" + response.body.toString());
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        print('=======+++++++++========' +
            result["StoreData"]["rest_dcharge"].toString());
        if (getData.read("clc") == true) {
          if (groupValue == 0) {
            if (result["StoreData"]["store_is_pickup"] == "0") {
              total = subTotal +
                  ((int.parse(result["StoreData"]["store_charge"].toString()) *
                          getMaxDelivery) +
                      int.parse(
                          result["StoreData"]["rest_dcharge"].toString()));
              getTotal = total;
              save("clc", false);
            } else {
              total = (subTotal +
                  (int.parse(result["StoreData"]["store_charge"].toString()) *
                      getMaxDelivery));
              getTotal = total;
              save("clc", false);
            }
          } else {
            print("..........(groupValue 1).........");
            total = subTotal +
                ((int.parse(result["StoreData"]["store_charge"].toString()) *
                        getMaxDelivery) +
                    (int.parse(result["StoreData"]["rest_dcharge"].toString()) *
                        getMaxDelivery));
            getTotal = total;
            save("clc", false);
          }
        }
        cartDataInfo = CartDataInfo.fromJson(result);
      }
      isLoading = true;
      update();
    } catch (e) {
      print(e.toString());
    }
  }

  getAddress({String? aLat, aLong, aTitle, aType1}) {
    addressLat = aLat ?? "";
    addressLong = aLong ?? "";
    addresTitle = aTitle ?? "";
    aType = aType1 ?? "";
    update();
  }

  checkCouponDataApi({String? cid}) async {
    try {
      isLoading = false;
      update();
      Map map = {
        "uid": getData.read("UserLogin")["id"].toString(),
        "cid": cid,
      };
      Uri uri = Uri.parse(Config.path + Config.couponCheck);
      var response = await http.post(
        uri,
        body: jsonEncode(map),
      );
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        copResult = result["Result"];
        couponMsg = result["ResponseMsg"];
      }
      isLoading = true;
      update();
    } catch (e) {
      print(e.toString());
    }
  }

  emptyAllDetailsInStore({List<CartItem>? pList1}) {
    for (var i = 0; i < pList1!.length; i++) {
      cart.delete(pList1[i].id);
    }
    subTotal = 0;
    total = 0;
    addressLat = "";
    addressLong = "";
    addresTitle = "";
    subTotal = 0.0;
    couponAmt = 0.0;
    couponId = "";
    copResult = "";
    couponMsg = "";
    preScriptionControllre.path = [];
    isOrderLoading = false;
    update();
  }

  // orderNowApi({
  //   String? wallAmt,
  //   couId,
  //   couAmt,
  //   pMethodId,
  //   storeId,
  //   oType,
  //   oTimeSlot,
  //   fullAddress,
  //   dCharge,
  //   otid,
  //   productTotal,
  //   productSubTotal,
  //   aNote,
  //   lats,
  //   longs,
  //   sCharge,
  //   List<CartItem>? pList,
  //   List? isReq,
  //   List? imgPath,
  // }) async {
  //   try {
  //     List list = [];
  //     var map = Map<String, dynamic>();
  //     map["uid"] = getData.read("UserLogin")["id"];
  //     map["wall_amt"] = wallAmt;
  //     map["cou_id"] = couId;
  //     map["cou_amt"] = couAmt;
  //     map["p_method_id"] = pMethodId;
  //     map["store_id"] = storeId;
  //     map["o_type"] = oType;
  //     map["o_timeslot"] = oTimeSlot;
  //     map["full_address"] = fullAddress;
  //     map["d_charge"] = dCharge;
  //     map["transaction_id"] = otid;
  //     map["product_total"] = productTotal;
  //     map["product_subtotal"] = productSubTotal;
  //     map["a_note"] = aNote;
  //     map["lats"] = lats;
  //     map["longs"] = longs;
  //     map["s_charge"] = sCharge;
  //     map["size"] = imgPath!.length.toString();
  //     for (var i = 0; i < pList!.length; i++) {
  //       CartItem item = CartItem();
  //       Map map = {
  //         "pid": pList[i].id,
  //         "title": pList[i].strTitle,
  //         "cost": pList[i].sPrice,
  //         "qty": pList[i].quantity,
  //         "discount": pList[i].price,
  //         "is_required": pList[i].isRequride,
  //       };
  //       list.add(jsonEncode(map));
  //     }
  //     map["ProductData"] = list.toString();
  //     print("::::::::.....<map>.....::::::::::" + map.toString());
  //     print("£££@@@@@!!!" + imgPath.toString());
  //     if (isReq != []) {
  //       for (var i = 0; i < imgPath.length; i++) {
  //         // String fileName =
  //         //     await http.MultipartFile.fromPath('image$i', '${imgPath[i]}')
  //         //         .toString();
  //         await http.MultipartFile.fromPath(map["image${i}"], '${imgPath[i]}')
  //             .toString();
  //       }
  //     }
  //     print("::::::::.....<Map>.....::::::::::" + map.toString());
  //     Uri uri = Uri.parse(Config.path + Config.orderNow);
  //     var response = await http.post(
  //       uri,
  //       body: map,
  //     );
  //     if (response.statusCode == 200) {
  //       var result = jsonDecode(response.body);
  //       showToastMessage(result["ResponseMsg"]);
  //       emptyAllDetailsInStore(pList1: pList);
  //     }
  //     update();
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

  Future<Map<String, dynamic>?> doImageUpload(
    Map<String, String> params,
    List<String> imgs,
    List<CartItem> cartViewList1,
  ) async {
    List list = [];
    var headers = {
      'content-type': 'application/json',
    };
    // selectedimage
    try {
      var request = http.MultipartRequest(
          'POST', Uri.parse(Config.path + Config.orderNow));
      request.fields.addAll(params);
      print("???????????" + params.toString());
      for (var i = 0; i < cartViewList1.length; i++) {
        var map = {
          "pid": cartViewList1[i].id,
          "title": cartViewList1[i].strTitle,
          "cost": cartViewList1[i].sPrice,
          "qty": cartViewList1[i].quantity,
          "discount": cartViewList1[i].price,
          "is_required": cartViewList1[i].isRequride,
        };
        print("££££££££!!!!!!!!!" + map.toString());
        list.add(jsonEncode(map));
      }
      request.fields.addAll({"ProductData": list.toString()});
      for (int i = 0; i < imgs.length; i++) {
        request.files
            .add(await http.MultipartFile.fromPath('image$i', '${imgs[i]}'));
      }
      request.headers.addAll(headers);
      var response = await request.send();
      var responsed = await http.Response.fromStream(response);
      var responseData = json.decode(responsed.body);
      showToastMessage(responseData["ResponseMsg"]);
      OrderPlacedSuccessfully();
      print("|||||||||" + responseData["ResponseMsg"].toString());
      emptyAllDetailsInStore(pList1: cartViewList1);
    } catch (e) {
      print('Error ::: ${e.hashCode}');
      print('Error ::: ${e.toString()}');
    }
  }

  emptyPriscriptionDetails() {
    for (var i = 0; i < cartViewList.length; i++) {
      cart.delete(cartViewList[i].id);
    }
    subTotal = 0;
    total = 0;
    addressLat = "";
    addressLong = "";
    addresTitle = "";
    subTotal = 0.0;
    couponAmt = 0.0;
    couponId = "";
    copResult = "";
    couponMsg = "";
    preScriptionControllre.path = [];
    isOrderLoading = false;
    update();
  }

  normalOrderApi(
    List<CartItem> cartViewList1, {
    String? storeId,
    orderType,
    mobile,
    name,
    anote,
    storeCharge,
    subTotal,
    total,
    otid,
    ndate,
    wallAmt,
    couId,
    couAmt,
    dCharge,
    fullAddress,
    landMark,
    pMethod,
    type,
    tSlot,
  }) async {
    List list = [];
    for (var i = 0; i < cartViewList1.length; i++) {
      var data = {
        "title": cartViewList1[i].strTitle,
        "variation": cartViewList1[i].productTitle,
        "price": cartViewList1[i].productPrice.toString(),
        "sprice": cartViewList1[i].sPrice.toString(),
        "qty": cartViewList1[i].quantity.toString(),
        "discount": cartViewList1[i].per.toString(),
        "image": cartViewList1[i].img.toString(),
      };
      list.add(data);
    }
    print(list.toString());
    try {
      Map map = {
        "uid": getData.read("UserLogin")["id"],
        "store_id": storeId,
        "o_type": orderType,
        "mobile": mobile,
        "name": name,
        "a_note": anote,
        "store_charge": storeCharge,
        "product_subtotal": subTotal,
        "product_total": total,
        "transaction_id": otid,
        "ndate": ndate,
        "wall_amt": wallAmt,
        "cou_id": couId,
        "cou_amt": couAmt,
        "d_charge": dCharge,
        "full_address": fullAddress,
        "landmark": landMark,
        "p_method_id": pMethod,
        "type": type,
        "tslot": tSlot,
        "ProductData": list
      };
      print("*************::::::(normalllMap):::::*************" +
          jsonEncode(map).toString());
      Uri uri = Uri.parse(Config.path + Config.normalOrderApi);
      var response = await http.post(
        uri,
        body: jsonEncode(map),
      );
      print("*************::::::(Response):::::*************" +
          response.body.toString());
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        emptyAllDetailsInStore(pList1: cartViewList1);
        showToastMessage(result["ResponseMsg"]);
        OrderPlacedSuccessfully();
      }
    } catch (e) {
      print(e.toString());
    }
  }

  String ?selectedWeek;
  updateSelectweek(String month){
    selectedWeek=month;
    print(month);
    update();
  }

  updateSelectweekClear(){
    selectedWeek=null;

    update();
  }


  subscriptionOrderApi(
    List<CartItem> cartViewList1, {
    String? storeId,
    mobile,
    name,
    anote,
    storeCharge,
    subTotal,
    total,
    otid,
    walAmt,
    couId,
    couAmt,
    dCharge,
    fullAddress,
    landMark,
    pMethodId,
    type,
  }) async {
    List list = [];
    List dayList1 = [];
    for (var i = 0; i < cartViewList1.length; i++) {
      dayList1 = [];
      for (var j = 0; j < cartViewList1[i].daysList!.length; j++) {
        if (cartViewList1[i].daysList![j] == "Monday") {
          dayList1.add("0");
        } else if (cartViewList1[i].daysList![j] == "Tuesday") {
          dayList1.add("1");
        } else if (cartViewList1[i].daysList![j] == "Wednesday") {
          dayList1.add("2");
        } else if (cartViewList1[i].daysList![j] == "Thursday") {
          dayList1.add("3");
        } else if (cartViewList1[i].daysList![j] == "Friday") {
          dayList1.add("4");
        } else if (cartViewList1[i].daysList![j] == "Saturday") {
          dayList1.add("5");
        } else if (cartViewList1[i].daysList![j] == "Sunday") {
          dayList1.add("6");
        }
      }
      String selectDay = dayList1.join(",");
      print(selectDay.toString());
      var data = {
        "title": cartViewList1[i].strTitle,
        "variation": cartViewList1[i].productTitle,
        "price": cartViewList1[i].productPrice.toString(),
        "sprice": cartViewList1[i].sPrice.toString(),
        "qty": cartViewList1[i].quantity.toString(),
        "discount": cartViewList1[i].per.toString(),
        "image": cartViewList1[i].img.toString(),
        "select_days": selectDay,
        "select_months":selectedWeek,
        "total_deliveries": cartViewList1[i].selectDelivery!.split(" ").first,
        "startdate": cartViewList1[i].startDate,
        "tslot": cartViewList1[i].startTime
      };
      list.add(data);
    }
    print(list.toString());
    try {
      Map map = {
        "uid": getData.read("UserLogin")["id"],
        "store_id": storeId,
        "mobile": mobile,
        "name": name,
        "a_note": anote,
        "store_charge": storeCharge,
        "product_subtotal": subTotal,
        "product_total": total,
        "transaction_id": otid,
        "wall_amt": walAmt,
        "cou_id": couId,
        "cou_amt": couAmt,
        "d_charge": dCharge,
        "full_address": fullAddress,
        "landmark": landMark,
        "p_method_id": pMethodId,
        "type": type,
        "ProductData": list
      };

      print("*************::::::(Map1):::::*************" +
          jsonEncode(map).toString());
      print("*************::::::(Map1):::::************* ${map}"  );

      Uri uri = Uri.parse(Config.path + Config.subScriptionOrderApi);
      var response = await http.post(
        uri,
        body: jsonEncode(map),
      );
      print("*************::::::(Response1):::::*************" +
          response.body.toString());
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        emptyAllDetailsInStore(pList1: cartViewList1);
        showToastMessage(result["ResponseMsg"]);
        OrderPlacedSuccessfully();
      }
      updateSelectweekClear();
      update();
    } catch (e) {
      print(e.toString());
    }
  }
}

// {"uid":"2","store_id":"1","o_type":"Delivery","mobile":"9574019029","name":"Jayraj","a_note":"","store_charge":"10","product_subtotal":"210.0","product_total":"240.0","transaction_id":"pay_Lua7jchmXJu0QX","ndate":"26-05-2023","wall_amt":"0.0","cou_id":"","cou_amt":0.0,"d_charge":"20","full_address":"Lajamani Chowk , Surat , Gujarat","landmark":"","p_method_id":"4","type":"Normal","tslot":"0","ProductData":[{"title":"Amul Taaza Toned Fresh Milk","variation":"500 ML","price":"90.0","sprice":"25.0","qty":"1","discount":"10","image":"images/product/1684919412.png"},{"title":"Amul Gold Full Cream Fresh Milk","variation":"500 ML","price":"120.0","sprice":"100.0","qty":"1","discount":"0","image":"images/product/1684919773.png"}]}
