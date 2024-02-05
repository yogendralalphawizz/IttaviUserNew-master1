// To parse this JSON data, do
//
//     final catWiseInfo = catWiseInfoFromJson(jsonString);

import 'dart:convert';

CatWiseInfo catWiseInfoFromJson(String str) =>
    CatWiseInfo.fromJson(json.decode(str));

String catWiseInfoToJson(CatWiseInfo data) => json.encode(data.toJson());

class CatWiseInfo {
  CatWiseInfo({
    required this.responseCode,
    required this.result,
    required this.responseMsg,
    required this.catWiseStoreData,
  });

  String responseCode;
  String result;
  String responseMsg;
  List<CatWiseStoreDatum> catWiseStoreData;

  factory CatWiseInfo.fromJson(Map<String, dynamic> json) => CatWiseInfo(
        responseCode: json["ResponseCode"],
        result: json["Result"],
        responseMsg: json["ResponseMsg"],
        catWiseStoreData: List<CatWiseStoreDatum>.from(
            json["CatWiseStoreData"].map((x) => CatWiseStoreDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ResponseCode": responseCode,
        "Result": result,
        "ResponseMsg": responseMsg,
        "CatWiseStoreData":
            List<dynamic>.from(catWiseStoreData.map((x) => x.toJson())),
      };
}

class CatWiseStoreDatum {
  CatWiseStoreDatum({
    required this.storeId,
    required this.storeLogo,
    required this.storeTitle,
    required this.storeCover,
    required this.storeSlogan,
    required this.storeSloganTitle,
    required this.storeSdesc,
    required this.storeTags,
    required this.storeRate,
    required this.totalFav,
    required this.couponTitle,
    required this.couponSubtitle,
  });

  String storeId;
  String storeLogo;
  String storeTitle;
  String storeCover;
  String storeSlogan;
  String storeSloganTitle;
  String storeSdesc;
  List<String> storeTags;
  String storeRate;
  int totalFav;
  String couponTitle;
  String couponSubtitle;

  factory CatWiseStoreDatum.fromJson(Map<String, dynamic> json) =>
      CatWiseStoreDatum(
        storeId: json["store_id"],
        storeLogo: json["store_logo"],
        storeTitle: json["store_title"],
        storeCover: json["store_cover"],
        storeSlogan: json["store_slogan"],
        storeSloganTitle: json["store_slogan_title"],
        storeSdesc: json["store_sdesc"],
        storeTags: List<String>.from(json["store_tags"].map((x) => x)),
        storeRate: json["store_rate"],
        totalFav: json["total_fav"],
        couponTitle: json["coupon_title"],
        couponSubtitle: json["coupon_subtitle"],
      );

  Map<String, dynamic> toJson() => {
        "store_id": storeId,
        "store_logo": storeLogo,
        "store_title": storeTitle,
        "store_cover": storeCover,
        "store_slogan": storeSlogan,
        "store_slogan_title": storeSloganTitle,
        "store_sdesc": storeSdesc,
        "store_tags": List<dynamic>.from(storeTags.map((x) => x)),
        "store_rate": storeRate,
        "total_fav": totalFav,
        "coupon_title": couponTitle,
        "coupon_subtitle": couponSubtitle,
      };
}
