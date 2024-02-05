// To parse this JSON data, do
//
//     final addressInfo = addressInfoFromJson(jsonString);

import 'dart:convert';

AddressInfo addressInfoFromJson(String str) =>
    AddressInfo.fromJson(json.decode(str));

String addressInfoToJson(AddressInfo data) => json.encode(data.toJson());

class AddressInfo {
  AddressInfo({
    required this.responseCode,
    required this.result,
    required this.responseMsg,
    required this.addressList,
  });

  String responseCode;
  String result;
  String responseMsg;
  List<AddressList> addressList;

  factory AddressInfo.fromJson(Map<String, dynamic> json) => AddressInfo(
        responseCode: json["ResponseCode"],
        result: json["Result"],
        responseMsg: json["ResponseMsg"],
        addressList: List<AddressList>.from(
            json["AddressList"].map((x) => AddressList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ResponseCode": responseCode,
        "Result": result,
        "ResponseMsg": responseMsg,
        "AddressList": List<dynamic>.from(addressList.map((x) => x.toJson())),
      };
}

class AddressList {
  AddressList({
    required this.id,
    required this.uid,
    required this.address,
    required this.landmark,
    required this.rInstruction,
    required this.aType,
    required this.aLat,
    required this.aLong,
  });

  String id;
  String uid;
  String address;
  String landmark;
  String rInstruction;
  String aType;
  String aLat;
  String aLong;

  factory AddressList.fromJson(Map<String, dynamic> json) => AddressList(
        id: json["id"],
        uid: json["uid"],
        address: json["address"],
        landmark: json["landmark"],
        rInstruction: json["r_instruction"],
        aType: json["a_type"],
        aLat: json["a_lat"],
        aLong: json["a_long"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "uid": uid,
        "address": address,
        "landmark": landmark,
        "r_instruction": rInstruction,
        "a_type": aType,
        "a_lat": aLat,
        "a_long": aLong,
      };
}
