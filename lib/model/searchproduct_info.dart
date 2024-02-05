// To parse this JSON data, do
//
//     final searchProductInfo = searchProductInfoFromJson(jsonString);

import 'dart:convert';

SearchProductInfo searchProductInfoFromJson(String str) =>
    SearchProductInfo.fromJson(json.decode(str));

String searchProductInfoToJson(SearchProductInfo data) =>
    json.encode(data.toJson());

class SearchProductInfo {
  String productId;
  String catid;
  String productTitle;
  String productImg;
  List<ProductInfo> productInfo;

  SearchProductInfo({
    required this.productId,
    required this.catid,
    required this.productTitle,
    required this.productImg,
    required this.productInfo,
  });

  factory SearchProductInfo.fromJson(Map<String, dynamic> json) =>
      SearchProductInfo(
        productId: json["product_id"],
        catid: json["catid"],
        productTitle: json["product_title"],
        productImg: json["product_img"],
        productInfo: List<ProductInfo>.from(
            json["product_info"].map((x) => ProductInfo.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "product_id": productId,
        "catid": catid,
        "product_title": productTitle,
        "product_img": productImg,
        "product_info": List<dynamic>.from(productInfo.map((x) => x.toJson())),
      };
}

class ProductInfo {
  String attributeId;
  String normalPrice;
  String subscribePrice;
  String title;
  String productDiscount;
  String productOutStock;
  String subscriptionRequired;

  ProductInfo({
    required this.attributeId,
    required this.normalPrice,
    required this.subscribePrice,
    required this.title,
    required this.productDiscount,
    required this.productOutStock,
    required this.subscriptionRequired,
  });

  factory ProductInfo.fromJson(Map<String, dynamic> json) => ProductInfo(
        attributeId: json["attribute_id"],
        normalPrice: json["normal_price"],
        subscribePrice: json["subscribe_price"],
        title: json["title"],
        productDiscount: json["product_discount"],
        productOutStock: json["Product_Out_Stock"],
        subscriptionRequired: json["subscription_required"],
      );

  Map<String, dynamic> toJson() => {
        "attribute_id": attributeId,
        "normal_price": normalPrice,
        "subscribe_price": subscribePrice,
        "title": title,
        "product_discount": productDiscount,
        "Product_Out_Stock": productOutStock,
        "subscription_required": subscriptionRequired,
      };
}
