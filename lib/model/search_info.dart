// To parse this JSON data, do
//
//     final searchInfo = searchInfoFromJson(jsonString);

import 'dart:convert';

SearchInfo searchInfoFromJson(String str) =>
    SearchInfo.fromJson(json.decode(str));

String searchInfoToJson(SearchInfo data) => json.encode(data.toJson());

class SearchInfo {
  SearchInfo({
    required this.storeId,
    required this.storeLogo,
    required this.storeTitle,
    required this.storeCover,
    required this.storeSlogan,
    required this.storeSloganTitle,
    required this.storeSdesc,
    required this.storeRate,
    required this.storeTags,
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
  String storeRate;
  List<String> storeTags;
  int totalFav;
  String couponTitle;
  String couponSubtitle;

  factory SearchInfo.fromJson(Map<String, dynamic> json) => SearchInfo(
        storeId: json["store_id"],
        storeLogo: json["store_logo"],
        storeTitle: json["store_title"],
        storeCover: json["store_cover"],
        storeSlogan: json["store_slogan"],
        storeSloganTitle: json["store_slogan_title"],
        storeSdesc: json["store_sdesc"],
        storeRate: json["store_rate"],
        storeTags: List<String>.from(json["store_tags"].map((x) => x)),
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
        "store_rate": storeRate,
        "store_tags": List<dynamic>.from(storeTags.map((x) => x)),
        "total_fav": totalFav,
        "coupon_title": couponTitle,
        "coupon_subtitle": couponSubtitle,
      };
}
