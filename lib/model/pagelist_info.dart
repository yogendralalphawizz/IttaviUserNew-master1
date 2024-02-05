// To parse this JSON data, do
//
//     final pageListInfo = pageListInfoFromJson(jsonString);

import 'dart:convert';

PageListInfo pageListInfoFromJson(String str) =>
    PageListInfo.fromJson(json.decode(str));

String pageListInfoToJson(PageListInfo data) => json.encode(data.toJson());

class PageListInfo {
  PageListInfo({
    required this.pagelist,
    required this.responseCode,
    required this.result,
    required this.responseMsg,
  });

  List<Pagelist> pagelist;
  String responseCode;
  String result;
  String responseMsg;

  factory PageListInfo.fromJson(Map<String, dynamic> json) => PageListInfo(
        pagelist: List<Pagelist>.from(
            json["pagelist"].map((x) => Pagelist.fromJson(x))),
        responseCode: json["ResponseCode"],
        result: json["Result"],
        responseMsg: json["ResponseMsg"],
      );

  Map<String, dynamic> toJson() => {
        "pagelist": List<dynamic>.from(pagelist.map((x) => x.toJson())),
        "ResponseCode": responseCode,
        "Result": result,
        "ResponseMsg": responseMsg,
      };
}

class Pagelist {
  Pagelist({
    required this.title,
    required this.description,
  });

  String title;
  String description;

  factory Pagelist.fromJson(Map<String, dynamic> json) => Pagelist(
        title: json["title"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
      };
}
