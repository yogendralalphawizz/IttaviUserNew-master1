// To parse this JSON data, do
//
//     final walletInfo = walletInfoFromJson(jsonString);

import 'dart:convert';

WalletInfo walletInfoFromJson(String str) =>
    WalletInfo.fromJson(json.decode(str));

String walletInfoToJson(WalletInfo data) => json.encode(data.toJson());

class WalletInfo {
  WalletInfo({
    required this.walletitem,
    required this.wallet,
    required this.responseCode,
    required this.result,
    required this.responseMsg,
  });

  List<Walletitem> walletitem;
  String wallet;
  String responseCode;
  String result;
  String responseMsg;

  factory WalletInfo.fromJson(Map<String, dynamic> json) => WalletInfo(
        walletitem: List<Walletitem>.from(
            json["Walletitem"].map((x) => Walletitem.fromJson(x))),
        wallet: json["wallet"],
        responseCode: json["ResponseCode"],
        result: json["Result"],
        responseMsg: json["ResponseMsg"],
      );

  Map<String, dynamic> toJson() => {
        "Walletitem": List<dynamic>.from(walletitem.map((x) => x.toJson())),
        "wallet": wallet,
        "ResponseCode": responseCode,
        "Result": result,
        "ResponseMsg": responseMsg,
      };
}

class Walletitem {
  Walletitem({
    required this.message,
    required this.status,
    required this.amt,
    required this.tdate,
  });

  String message;
  String status;
  String amt;
  String tdate;

  factory Walletitem.fromJson(Map<String, dynamic> json) => Walletitem(
        message: json["message"],
        status: json["status"],
        amt: json["amt"],
        tdate: json["tdate"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "status": status,
        "amt": amt,
        "tdate": tdate,
      };
}
