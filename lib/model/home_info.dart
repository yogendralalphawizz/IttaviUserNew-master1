// To parse this JSON data, do
//
//     final homeInfo = homeInfoFromJson(jsonString);

import 'dart:convert';

HomeInfo homeInfoFromJson(String str) => HomeInfo.fromJson(json.decode(str));

String homeInfoToJson(HomeInfo data) => json.encode(data.toJson());

class HomeInfo {
  String responseCode;
  String result;
  String responseMsg;
  HomeData homeData;

  HomeInfo({
    required this.responseCode,
    required this.result,
    required this.responseMsg,
    required this.homeData,
  });

  factory HomeInfo.fromJson(Map<String, dynamic> json) => HomeInfo(
        responseCode: json["ResponseCode"],
        result: json["Result"],
        responseMsg: json["ResponseMsg"],
        homeData: HomeData.fromJson(json["HomeData"]),
      );

  Map<String, dynamic> toJson() => {
        "ResponseCode": responseCode,
        "Result": result,
        "ResponseMsg": responseMsg,
        "HomeData": homeData.toJson(),
      };
}

class HomeData {
  List<Banlist> banlist;
  List<Catlist> catlist;
  List<Favlist> favlist;
  String currency;
  String wallet;
  List<Favlist> spotlightStore;
  List<TopStore> topStore;

  HomeData({
    required this.banlist,
    required this.catlist,
    required this.favlist,
    required this.currency,
    required this.wallet,
    required this.spotlightStore,
    required this.topStore,
  });

  factory HomeData.fromJson(Map<String, dynamic> json) => HomeData(
        banlist:
            List<Banlist>.from(json["Banlist"].map((x) => Banlist.fromJson(x))),
        catlist:
            List<Catlist>.from(json["Catlist"].map((x) => Catlist.fromJson(x))),
        favlist:
            List<Favlist>.from(json["Favlist"].map((x) => Favlist.fromJson(x))),
        currency: json["currency"],
        wallet: json["wallet"],
        spotlightStore: List<Favlist>.from(
            json["spotlight_store"].map((x) => Favlist.fromJson(x))),
        topStore: List<TopStore>.from(
            json["top_store"].map((x) => TopStore.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Banlist": List<dynamic>.from(banlist.map((x) => x.toJson())),
        "Catlist": List<dynamic>.from(catlist.map((x) => x.toJson())),
        "Favlist": List<dynamic>.from(favlist.map((x) => x.toJson())),
        "currency": currency,
        "wallet": wallet,
        "spotlight_store":
            List<dynamic>.from(spotlightStore.map((x) => x.toJson())),
        "top_store": List<dynamic>.from(topStore.map((x) => x.toJson())),
      };
}

class Banlist {
  String id;
  String img;

  Banlist({
    required this.id,
    required this.img,
  });

  factory Banlist.fromJson(Map<String, dynamic> json) => Banlist(
        id: json["id"],
        img: json["img"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "img": img,
      };
}

class Catlist {
  String id;
  String img;
  String title;
  String cover;

  Catlist({
    required this.id,
    required this.img,
    required this.title,
    required this.cover,
  });

  factory Catlist.fromJson(Map<String, dynamic> json) => Catlist(
        id: json["id"],
        img: json["img"],
        title: json["title"],
        cover: json["cover"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "img": img,
        "title": title,
        "cover": cover,
      };
}

class Favlist {
  String storeId;
  String storeTitle;
  String storeLogo;
  String storeCover;
  String storeSlogan;
  List<String> storeTags;
  String storeSloganTitle;
  String storeCategoryName;
  String? storeAddress;
  String? restDistance;

  Favlist({
    required this.storeId,
    required this.storeTitle,
    required this.storeLogo,
    required this.storeCover,
    required this.storeSlogan,
    required this.storeTags,
    required this.storeSloganTitle,
    required this.storeCategoryName,
    this.storeAddress,
    this.restDistance,
  });

  factory Favlist.fromJson(Map<String, dynamic> json) => Favlist(
        storeId: json["store_id"],
        storeTitle: json["store_title"],
        storeLogo: json["store_logo"],
        storeCover: json["store_cover"],
        storeSlogan: json["store_slogan"],
        storeTags: List<String>.from(json["store_tags"].map((x) => x)),
        storeSloganTitle: json["store_slogan_title"],
        storeCategoryName: json["store_category_name"],
        storeAddress: json["store_address"],
        restDistance: json["rest_distance"],
      );

  Map<String, dynamic> toJson() => {
        "store_id": storeId,
        "store_title": storeTitle,
        "store_logo": storeLogo,
        "store_cover": storeCover,
        "store_slogan": storeSlogan,
        "store_tags": List<dynamic>.from(storeTags.map((x) => x)),
        "store_slogan_title": storeSloganTitle,
        "store_category_name": storeCategoryName,
        "store_address": storeAddress,
        "rest_distance": restDistance,
      };
}

class TopStore {
  String storeId;
  String storeTitle;
  String storeLogo;
  String storeCover;
  String storeSlogan;
  String storeSloganTitle;
  String storeSdesc;
  String storeRate;
  List<String> storeTags;
  int totalFav;
  String couponTitle;
  String couponSubtitle;

  TopStore({
    required this.storeId,
    required this.storeTitle,
    required this.storeLogo,
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

  factory TopStore.fromJson(Map<String, dynamic> json) => TopStore(
        storeId: json["store_id"],
        storeTitle: json["store_title"],
        storeLogo: json["store_logo"],
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
        "store_title": storeTitle,
        "store_logo": storeLogo,
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
