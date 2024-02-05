// To parse this JSON data, do
//
//     final cartDataInfo = cartDataInfoFromJson(jsonString);

import 'dart:convert';

CartDataInfo cartDataInfoFromJson(String str) =>
    CartDataInfo.fromJson(json.decode(str));

String cartDataInfoToJson(CartDataInfo data) => json.encode(data.toJson());

class CartDataInfo {
  CartDataInfo({
    required this.responseCode,
    required this.result,
    required this.responseMsg,
    required this.storeData,
    required this.couponList,
    required this.paymentData,
    required this.timeslotlist,
  });

  String responseCode;
  String result;
  String responseMsg;
  StoreData storeData;
  List<CouponList> couponList;
  List<PaymentDatum> paymentData;
  List<Timeslotlist> timeslotlist;

  factory CartDataInfo.fromJson(Map<String, dynamic> json) => CartDataInfo(
        responseCode: json["ResponseCode"],
        result: json["Result"],
        responseMsg: json["ResponseMsg"],
        storeData: StoreData.fromJson(json["StoreData"]),
        couponList: List<CouponList>.from(
            json["CouponList"].map((x) => CouponList.fromJson(x))),
        paymentData: List<PaymentDatum>.from(
            json["PaymentData"].map((x) => PaymentDatum.fromJson(x))),
        timeslotlist: List<Timeslotlist>.from(
            json["Timeslotlist"].map((x) => Timeslotlist.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ResponseCode": responseCode,
        "Result": result,
        "ResponseMsg": responseMsg,
        "StoreData": storeData.toJson(),
        "CouponList": List<dynamic>.from(couponList.map((x) => x.toJson())),
        "PaymentData": List<dynamic>.from(paymentData.map((x) => x.toJson())),
        "Timeslotlist": List<dynamic>.from(timeslotlist.map((x) => x.toJson())),
      };
}

class CouponList {
  CouponList({
    required this.id,
    required this.couponImg,
    required this.expireDate,
    required this.cDesc,
    required this.couponVal,
    required this.couponCode,
    required this.couponTitle,
    required this.couponSubtitle,
    required this.minAmt,
  });

  String id;
  String couponImg;
  DateTime expireDate;
  String cDesc;
  String couponVal;
  String couponCode;
  String couponTitle;
  String couponSubtitle;
  String minAmt;

  factory CouponList.fromJson(Map<String, dynamic> json) => CouponList(
        id: json["id"],
        couponImg: json["coupon_img"],
        expireDate: DateTime.parse(json["expire_date"]),
        cDesc: json["c_desc"].toString(),
        couponVal: json["coupon_val"],
        couponCode: json["coupon_code"],
        couponTitle: json["coupon_title"],
        couponSubtitle: json["coupon_subtitle"],
        minAmt: json["min_amt"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "coupon_img": couponImg,
        "expire_date":
            "${expireDate.year.toString().padLeft(4, '0')}-${expireDate.month.toString().padLeft(2, '0')}-${expireDate.day.toString().padLeft(2, '0')}",
        "c_desc": cDesc,
        "coupon_val": couponVal,
        "coupon_code": couponCode,
        "coupon_title": couponTitle,
        "coupon_subtitle": couponSubtitle,
        "min_amt": minAmt,
      };
}

class PaymentDatum {
  PaymentDatum({
    required this.id,
    required this.title,
    required this.img,
    required this.attributes,
    required this.status,
    required this.subtitle,
    required this.pShow,
  });

  String id;
  String title;
  String img;
  String attributes;
  String status;
  String subtitle;
  String pShow;

  factory PaymentDatum.fromJson(Map<String, dynamic> json) => PaymentDatum(
        id: json["id"],
        title: json["title"],
        img: json["img"],
        attributes: json["attributes"],
        status: json["status"],
        subtitle: json["subtitle"],
        pShow: json["p_show"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "img": img,
        "attributes": attributes,
        "status": status,
        "subtitle": subtitle,
        "p_show": pShow,
      };
}

class StoreData {
  StoreData({
    required this.storeId,
    required this.storeLogo,
    required this.storeTitle,
    required this.storeTags,
    required this.storeIsPickup,
    required this.storeFullAddress,
    required this.storeCharge,
    required this.storeMorder,
    required this.storeIsOpen,
    required this.restDcharge,
    required this.storeIsDeliver,
  });

  String storeId;
  String storeLogo;
  String storeTitle;
  List<String> storeTags;
  String storeIsPickup;
  String storeFullAddress;
  String storeCharge;
  String storeMorder;
  String storeIsOpen;
  String restDcharge;
  String storeIsDeliver;

  factory StoreData.fromJson(Map<String, dynamic> json) => StoreData(
        storeId: json["store_id"],
        storeLogo: json["store_logo"],
        storeTitle: json["store_title"],
        storeTags: List<String>.from(json["store_tags"].map((x) => x)),
        storeIsPickup: json["store_is_pickup"],
        storeFullAddress: json["store_full_address"],
        storeCharge: json["store_charge"],
        storeMorder: json["store_morder"],
        storeIsOpen: json["store_is_open"],
        restDcharge: json["rest_dcharge"].toString(),
        storeIsDeliver: json["store_is_deliver"],
      );

  Map<String, dynamic> toJson() => {
        "store_id": storeId,
        "store_logo": storeLogo,
        "store_title": storeTitle,
        "store_tags": List<dynamic>.from(storeTags.map((x) => x)),
        "store_is_pickup": storeIsPickup,
        "store_full_address": storeFullAddress,
        "store_charge": storeCharge,
        "store_morder": storeMorder,
        "store_is_open": storeIsOpen,
        "rest_dcharge": restDcharge,
        "store_is_deliver": storeIsDeliver,
      };
}

class Timeslotlist {
  Timeslotlist({
    required this.id,
    required this.storeId,
    required this.mintime,
    required this.maxtime,
    required this.status,
  });

  String id;
  String storeId;
  String mintime;
  String maxtime;
  String status;

  factory Timeslotlist.fromJson(Map<String, dynamic> json) => Timeslotlist(
        id: json["id"],
        storeId: json["store_id"],
        mintime: json["mintime"],
        maxtime: json["maxtime"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "store_id": storeId,
        "mintime": mintime,
        "maxtime": maxtime,
        "status": status,
      };
}
