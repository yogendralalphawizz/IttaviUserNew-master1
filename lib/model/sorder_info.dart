// To parse this JSON data, do
//
//     final sOrderInfo = sOrderInfoFromJson(jsonString);

import 'dart:convert';

SOrderInfo sOrderInfoFromJson(String str) =>
    SOrderInfo.fromJson(json.decode(str));

String sOrderInfoToJson(SOrderInfo data) => json.encode(data.toJson());

class SOrderInfo {
  List<OrderHistory> orderHistory;
  String responseCode;
  String result;
  String responseMsg;

  SOrderInfo({
    required this.orderHistory,
    required this.responseCode,
    required this.result,
    required this.responseMsg,
  });

  factory SOrderInfo.fromJson(Map<String, dynamic> json) => SOrderInfo(
        orderHistory: List<OrderHistory>.from(
            json["OrderHistory"].map((x) => OrderHistory.fromJson(x))),
        responseCode: json["ResponseCode"],
        result: json["Result"],
        responseMsg: json["ResponseMsg"],
      );

  Map<String, dynamic> toJson() => {
        "OrderHistory": List<dynamic>.from(orderHistory.map((x) => x.toJson())),
        "ResponseCode": responseCode,
        "Result": result,
        "ResponseMsg": responseMsg,
      };
}

class OrderHistory {
  String id;
  int totalProduct;
  String deliveryName;
  String storeTitle;
  String storeImg;
  String storeAddress;
  String storeRate;
  String status;
  DateTime date;
  String total;

  OrderHistory({
    required this.id,
    required this.totalProduct,
    required this.deliveryName,
    required this.storeTitle,
    required this.storeImg,
    required this.storeAddress,
    required this.storeRate,
    required this.status,
    required this.date,
    required this.total,
  });

  factory OrderHistory.fromJson(Map<String, dynamic> json) => OrderHistory(
        id: json["id"],
        totalProduct: json["total_product"],
        deliveryName: json["Delivery_name"],
        storeTitle: json["store_title"],
        storeImg: json["store_img"],
        storeAddress: json["store_address"],
        storeRate: json["store_rate"],
        status: json["status"],
        date: DateTime.parse(json["date"]),
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "total_product": totalProduct,
        "Delivery_name": deliveryName,
        "store_title": storeTitle,
        "store_img": storeImg,
        "store_address": storeAddress,
        "store_rate": storeRate,
        "status": status,
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "total": total,
      };
}
