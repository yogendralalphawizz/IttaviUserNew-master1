// To parse this JSON data, do
//
//     final storeDataInfo = storeDataInfoFromJson(jsonString);

import 'dart:convert';

StoreDataInfo storeDataInfoFromJson(String str) =>
    StoreDataInfo.fromJson(json.decode(str));

String storeDataInfoToJson(StoreDataInfo data) => json.encode(data.toJson());

class StoreDataInfo {
  String responseCode;
  String result;
  String responseMsg;
  StoreInfo storeInfo;
  List<Catwiseproduct> catwiseproduct;
  List<Photo> photos;
  List<FaQdatum> faQdata;
  List<Reviewdatum> reviewdata;

  StoreDataInfo({
    required this.responseCode,
    required this.result,
    required this.responseMsg,
    required this.storeInfo,
    required this.catwiseproduct,
    required this.photos,
    required this.faQdata,
    required this.reviewdata,
  });

  factory StoreDataInfo.fromJson(Map<String, dynamic> json) => StoreDataInfo(
        responseCode: json["ResponseCode"],
        result: json["Result"],
        responseMsg: json["ResponseMsg"],
        storeInfo: StoreInfo.fromJson(json["StoreInfo"]),
        catwiseproduct: List<Catwiseproduct>.from(
            json["catwiseproduct"].map((x) => Catwiseproduct.fromJson(x))),
        photos: List<Photo>.from(json["photos"].map((x) => Photo.fromJson(x))),
        faQdata: List<FaQdatum>.from(
            json["FAQdata"].map((x) => FaQdatum.fromJson(x))),
        reviewdata: List<Reviewdatum>.from(
            json["reviewdata"].map((x) => Reviewdatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ResponseCode": responseCode,
        "Result": result,
        "ResponseMsg": responseMsg,
        "StoreInfo": storeInfo.toJson(),
        "catwiseproduct":
            List<dynamic>.from(catwiseproduct.map((x) => x.toJson())),
        "photos": List<dynamic>.from(photos.map((x) => x.toJson())),
        "FAQdata": List<dynamic>.from(faQdata.map((x) => x.toJson())),
        "reviewdata": List<dynamic>.from(reviewdata.map((x) => x.toJson())),
      };
}

class Catwiseproduct {
  String catId;
  String catTitle;
  String img;
  List<Productdatum> productdata;

  Catwiseproduct({
    required this.catId,
    required this.catTitle,
    required this.img,
    required this.productdata,
  });

  factory Catwiseproduct.fromJson(Map<String, dynamic> json) => Catwiseproduct(
        catId: json["cat_id"],
        catTitle: json["cat_title"],
        img: json["img"],
        productdata: List<Productdatum>.from(
            json["productdata"].map((x) => Productdatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "cat_id": catId,
        "cat_title": catTitle,
        "img": img,
        "productdata": List<dynamic>.from(productdata.map((x) => x.toJson())),
      };
}

class Productdatum {
  String productId;
  String productTitle;
  String productImg;
  List<ProductInfo> productInfo;

  Productdatum({
    required this.productId,
    required this.productTitle,
    required this.productImg,
    required this.productInfo,
  });

  factory Productdatum.fromJson(Map<String, dynamic> json) => Productdatum(
        productId: json["product_id"],
        productTitle: json["product_title"],
        productImg: json["product_img"],
        productInfo: List<ProductInfo>.from(
            json["product_info"].map((x) => ProductInfo.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "product_id": productId,
        "product_title": productTitle,
        "product_img": productImg,
        "product_info": List<dynamic>.from(productInfo.map((x) => x.toJson())),
      };
}

class ProductInfo {
  String attributeId;
  String productId;
  String normalPrice;
  String subscribePrice;
  String title;
  String productDiscount;
  String productOutStock;
  String subscriptionRequired;
  String? productSubscripitionDiscount;

  ProductInfo({
    required this.attributeId,
    required this.productId,
    required this.normalPrice,
    required this.subscribePrice,
    required this.title,
    required this.productDiscount,
    required this.productOutStock,
    required this.subscriptionRequired,
    this.productSubscripitionDiscount
  });

  factory ProductInfo.fromJson(Map<String, dynamic> json) => ProductInfo(
        attributeId: json["attribute_id"],
        productId: json["product_id"],
        normalPrice: json["normal_price"],
        subscribePrice: json["subscribe_price"],
        title: json["title"],
        productDiscount: json["product_discount"],
        productOutStock: json["Product_Out_Stock"],
        subscriptionRequired: json["subscription_required"],
       productSubscripitionDiscount: json["product_subscripition_discount"]
      );

  Map<String, dynamic> toJson() => {
        "attribute_id": attributeId,
        "product_id": productId,
        "normal_price": normalPrice,
        "subscribe_price": subscribePrice,
        "title": title,
        "product_discount": productDiscount,
        "Product_Out_Stock": productOutStock,
        "subscription_required": subscriptionRequired,
        "product_subscripition_discount": productSubscripitionDiscount
      };
}

class FaQdatum {
  String id;
  String storeId;
  String question;
  String answer;
  String status;

  FaQdatum({
    required this.id,
    required this.storeId,
    required this.question,
    required this.answer,
    required this.status,
  });

  factory FaQdatum.fromJson(Map<String, dynamic> json) => FaQdatum(
        id: json["id"],
        storeId: json["store_id"],
        question: json["question"],
        answer: json["answer"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "store_id": storeId,
        "question": question,
        "answer": answer,
        "status": status,
      };
}

class Photo {
  String id;
  String img;

  Photo({
    required this.id,
    required this.img,
  });

  factory Photo.fromJson(Map<String, dynamic> json) => Photo(
        id: json["id"],
        img: json["img"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "img": img,
      };
}

class Reviewdatum {
  String userImg;
  String userTitle;
  String userRate;
  DateTime reviewDate;
  String userDesc;

  Reviewdatum({
    required this.userImg,
    required this.userTitle,
    required this.userRate,
    required this.reviewDate,
    required this.userDesc,
  });

  factory Reviewdatum.fromJson(Map<String, dynamic> json) => Reviewdatum(
        userImg: json["user_img"].toString(),
        userTitle: json["user_title"],
        userRate: json["user_rate"],
        reviewDate: DateTime.parse(json["review_date"]),
        userDesc: json["user_desc"],
      );

  Map<String, dynamic> toJson() => {
        "user_img": userImg,
        "user_title": userTitle,
        "user_rate": userRate,
        "review_date":
            "${reviewDate.year.toString().padLeft(4, '0')}-${reviewDate.month.toString().padLeft(2, '0')}-${reviewDate.day.toString().padLeft(2, '0')}",
        "user_desc": userDesc,
      };
}

class StoreInfo {
  String storeId;
  String storeLogo;
  String storeTitle;
  String storeCover;
  String storeSlogan;
  String storeSloganTitle;
  String storeShortDesc;
  String storeRate;
  String storeLat;
  String storeLongs;
  String storeAddress;
  String storeMobile;
  String storeEmail;
  String storeOpentime;
  String storeClosetime;
  String storeCanclePolicy;
  String storeIsPickup;
  List<String> storeTags;
  String storeLandmark;
  int totalFav;
  int isFavourite;
  String restDistance;

  StoreInfo({
    required this.storeId,
    required this.storeLogo,
    required this.storeTitle,
    required this.storeCover,
    required this.storeSlogan,
    required this.storeSloganTitle,
    required this.storeShortDesc,
    required this.storeRate,
    required this.storeLat,
    required this.storeLongs,
    required this.storeAddress,
    required this.storeMobile,
    required this.storeEmail,
    required this.storeOpentime,
    required this.storeClosetime,
    required this.storeCanclePolicy,
    required this.storeIsPickup,
    required this.storeTags,
    required this.storeLandmark,
    required this.totalFav,
    required this.isFavourite,
    required this.restDistance,
  });

  factory StoreInfo.fromJson(Map<String, dynamic> json) => StoreInfo(
        storeId: json["store_id"],
        storeLogo: json["store_logo"],
        storeTitle: json["store_title"],
        storeCover: json["store_cover"],
        storeSlogan: json["store_slogan"],
        storeSloganTitle: json["store_slogan_title"],
        storeShortDesc: json["store_short_desc"],
        storeRate: json["store_rate"],
        storeLat: json["store_lat"],
        storeLongs: json["store_longs"],
        storeAddress: json["store_address"],
        storeMobile: json["store_mobile"],
        storeEmail: json["store_email"],
        storeOpentime: json["store_opentime"],
        storeClosetime: json["store_closetime"],
        storeCanclePolicy: json["store_cancle_policy"],
        storeIsPickup: json["store_is_pickup"],
        storeTags: List<String>.from(json["store_tags"].map((x) => x)),
        storeLandmark: json["store_landmark"],
        totalFav: json["total_fav"],
        isFavourite: json["IS_FAVOURITE"],
        restDistance: json["rest_distance"],
      );

  Map<String, dynamic> toJson() => {
        "store_id": storeId,
        "store_logo": storeLogo,
        "store_title": storeTitle,
        "store_cover": storeCover,
        "store_slogan": storeSlogan,
        "store_slogan_title": storeSloganTitle,
        "store_short_desc": storeShortDesc,
        "store_rate": storeRate,
        "store_lat": storeLat,
        "store_longs": storeLongs,
        "store_address": storeAddress,
        "store_mobile": storeMobile,
        "store_email": storeEmail,
        "store_opentime": storeOpentime,
        "store_closetime": storeClosetime,
        "store_cancle_policy": storeCanclePolicy,
        "store_is_pickup": storeIsPickup,
        "store_tags": List<dynamic>.from(storeTags.map((x) => x)),
        "store_landmark": storeLandmark,
        "total_fav": totalFav,
        "IS_FAVOURITE": isFavourite,
        "rest_distance": restDistance,
      };
}
