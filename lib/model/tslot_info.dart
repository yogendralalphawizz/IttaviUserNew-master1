// To parse this JSON data, do
//
//     final tslotInfo = tslotInfoFromJson(jsonString);

import 'dart:convert';

TslotInfo tslotInfoFromJson(String str) => TslotInfo.fromJson(json.decode(str));

String tslotInfoToJson(TslotInfo data) => json.encode(data.toJson());

class TslotInfo {
  List<Datum> data;
  String responseCode;
  String result;
  String responseMsg;

  TslotInfo({
    required this.data,
    required this.responseCode,
    required this.result,
    required this.responseMsg,
  });

  factory TslotInfo.fromJson(Map<String, dynamic> json) => TslotInfo(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        responseCode: json["ResponseCode"],
        result: json["Result"],
        responseMsg: json["ResponseMsg"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "ResponseCode": responseCode,
        "Result": result,
        "ResponseMsg": responseMsg,
      };
}

class Datum {
  String id;
  String mintime;
  String maxtime;

  Datum({
    required this.id,
    required this.mintime,
    required this.maxtime,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        mintime: json["mintime"],
        maxtime: json["maxtime"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "mintime": mintime,
        "maxtime": maxtime,
      };
}
