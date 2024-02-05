// To parse this JSON data, do
//
//     final sDetailsInfo = sDetailsInfoFromJson(jsonString);

import 'dart:convert';

SDetailsInfo sDetailsInfoFromJson(String str) =>
    SDetailsInfo.fromJson(json.decode(str));

String sDetailsInfoToJson(SDetailsInfo data) => json.encode(data.toJson());

class SDetailsInfo {
  OrderProductList orderProductList;
  String responseCode;
  String result;
  String responseMsg;

  SDetailsInfo({
    required this.orderProductList,
    required this.responseCode,
    required this.result,
    required this.responseMsg,
  });

  factory SDetailsInfo.fromJson(Map<String, dynamic> json) => SDetailsInfo(
        orderProductList: OrderProductList.fromJson(json["OrderProductList"]),
        responseCode: json["ResponseCode"],
        result: json["Result"],
        responseMsg: json["ResponseMsg"],
      );

  Map<String, dynamic> toJson() => {
        "OrderProductList": orderProductList.toJson(),
        "ResponseCode": responseCode,
        "Result": result,
        "ResponseMsg": responseMsg,
      };
}

class OrderProductList {
  String orderId;
  String riderTitle;
  String riderImage;
  String riderMobile;
  String pMethodName;
  String customerAddress;
  String customerName;
  String customerMobile;
  String deliveryCharge;
  String couponAmount;
  String walletAmount;
  String commentReject;
  String storeCharge;
  String orderTotal;
  String isRate;
  String orderSubTotal;
  String orderTransactionId;
  String additionalNote;
  String orderStatus;
  List<OrderProductDatum> orderProductData;

  OrderProductList({
    required this.orderId,
    required this.riderTitle,
    required this.riderImage,
    required this.riderMobile,
    required this.pMethodName,
    required this.customerAddress,
    required this.customerName,
    required this.customerMobile,
    required this.deliveryCharge,
    required this.couponAmount,
    required this.walletAmount,
    required this.commentReject,
    required this.storeCharge,
    required this.orderTotal,
    required this.isRate,
    required this.orderSubTotal,
    required this.orderTransactionId,
    required this.additionalNote,
    required this.orderStatus,
    required this.orderProductData,
  });

  factory OrderProductList.fromJson(Map<String, dynamic> json) =>
      OrderProductList(
        orderId: json["order_id"],
        riderTitle: json["rider_title"],
        riderImage: json["rider_image"],
        riderMobile: json["rider_mobile"],
        pMethodName: json["p_method_name"],
        customerAddress: json["customer_address"],
        customerName: json["customer_name"],
        customerMobile: json["customer_mobile"],
        deliveryCharge: json["Delivery_charge"],
        couponAmount: json["Coupon_Amount"],
        walletAmount: json["Wallet_Amount"],
        commentReject: json["comment_reject"].toString(),
        storeCharge: json["store_charge"],
        orderTotal: json["Order_Total"],
        isRate: json["is_rate"],
        orderSubTotal: json["Order_SubTotal"],
        orderTransactionId: json["Order_Transaction_id"],
        additionalNote: json["Additional_Note"],
        orderStatus: json["Order_Status"],
        orderProductData: List<OrderProductDatum>.from(
            json["Order_Product_Data"]
                .map((x) => OrderProductDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "order_id": orderId,
        "rider_title": riderTitle,
        "rider_image": riderImage,
        "rider_mobile": riderMobile,
        "p_method_name": pMethodName,
        "customer_address": customerAddress,
        "customer_name": customerName,
        "customer_mobile": customerMobile,
        "Delivery_charge": deliveryCharge,
        "Coupon_Amount": couponAmount,
        "Wallet_Amount": walletAmount,
        "comment_reject": commentReject,
        "store_charge": storeCharge,
        "Order_Total": orderTotal,
        "is_rate": isRate,
        "Order_SubTotal": orderSubTotal,
        "Order_Transaction_id": orderTransactionId,
        "Additional_Note": additionalNote,
        "Order_Status": orderStatus,
        "Order_Product_Data":
            List<dynamic>.from(orderProductData.map((x) => x.toJson())),
      };
}

class OrderProductDatum {
  String subscribeId;
  String productQuantity;
  String productName;
  String productDiscount;
  String productImage;
  String productPrice;
  String productVariation;
  String deliveryTimeslot;
  String productTotal;
  String totaldelivery;
  DateTime startdate;
  List<String?> selectmonth;
  List<Totaldate> totaldates;

  OrderProductDatum({
    required this.subscribeId,
    required this.productQuantity,
    required this.productName,
    required this.productDiscount,
    required this.productImage,
    required this.productPrice,
    required this.productVariation,
    required this.deliveryTimeslot,
    required this.productTotal,
    required this.totaldelivery,
    required this.startdate,
    required this.totaldates,
    required this.selectmonth
  });

  factory OrderProductDatum.fromJson(Map<String, dynamic> json) =>
      OrderProductDatum(
        subscribeId: json["Subscribe_Id"],
        productQuantity: json["Product_quantity"],
        productName: json["Product_name"],
        productDiscount: json["Product_discount"],
        productImage: json["Product_image"],
        productPrice: json["Product_price"],
        productVariation: json["Product_variation"],
        deliveryTimeslot: json["Delivery_Timeslot"],
        productTotal: json["Product_total"].toString(),
        totaldelivery: json["totaldelivery"],
        selectmonth: json['selectmonth'].cast<String>() ?? [],
        startdate: DateTime.parse(json["startdate"]),
        totaldates: List<Totaldate>.from(
            json["totaldates"].map((x) => Totaldate.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Subscribe_Id": subscribeId,
        "Product_quantity": productQuantity,
        "Product_name": productName,
        "Product_discount": productDiscount,
        "Product_image": productImage,
        "Product_price": productPrice,
        "Product_variation": productVariation,
        "Delivery_Timeslot": deliveryTimeslot,
        "Product_total": productTotal,
        "totaldelivery": totaldelivery,
        "selectmonth": selectmonth,
        "startdate":
            "${startdate.year.toString().padLeft(4, '0')}-${startdate.month.toString().padLeft(2, '0')}-${startdate.day.toString().padLeft(2, '0')}",
        "totaldates": List<dynamic>.from(totaldates.map((x) => x.toJson())),
      };
}

class Totaldate {
  DateTime date;
  int isComplete;
  String formatDate;

  Totaldate({
    required this.date,
    required this.isComplete,
    required this.formatDate,
  });

  factory Totaldate.fromJson(Map<String, dynamic> json) => Totaldate(
        date: DateTime.parse(json["date"]),
        isComplete: json["is_complete"],
        formatDate: json["format_date"],
      );

  Map<String, dynamic> toJson() => {
        "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "is_complete": isComplete,
        "format_date": formatDate,
      };
}
