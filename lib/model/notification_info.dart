// To parse this JSON data, do
//
//     final notificationInfo = notificationInfoFromJson(jsonString);

import 'dart:convert';

NotificationInfo notificationInfoFromJson(String str) =>
    NotificationInfo.fromJson(json.decode(str));

String notificationInfoToJson(NotificationInfo data) =>
    json.encode(data.toJson());

class NotificationInfo {
  NotificationInfo({
    required this.notificationData,
    required this.responseCode,
    required this.result,
    required this.responseMsg,
  });

  List<NotificationDatum> notificationData;
  String responseCode;
  String result;
  String responseMsg;

  factory NotificationInfo.fromJson(Map<String, dynamic> json) =>
      NotificationInfo(
        notificationData: List<NotificationDatum>.from(
            json["NotificationData"].map((x) => NotificationDatum.fromJson(x))),
        responseCode: json["ResponseCode"],
        result: json["Result"],
        responseMsg: json["ResponseMsg"],
      );

  Map<String, dynamic> toJson() => {
        "NotificationData":
            List<dynamic>.from(notificationData.map((x) => x.toJson())),
        "ResponseCode": responseCode,
        "Result": result,
        "ResponseMsg": responseMsg,
      };
}

class NotificationDatum {
  NotificationDatum({
    required this.id,
    required this.uid,
    required this.datetime,
    required this.title,
    required this.description,
  });

  String id;
  String uid;
  DateTime datetime;
  String title;
  String description;

  factory NotificationDatum.fromJson(Map<String, dynamic> json) =>
      NotificationDatum(
        id: json["id"],
        uid: json["uid"],
        datetime: DateTime.parse(json["datetime"]),
        title: json["title"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "uid": uid,
        "datetime": datetime.toIso8601String(),
        "title": title,
        "description": description,
      };
}
