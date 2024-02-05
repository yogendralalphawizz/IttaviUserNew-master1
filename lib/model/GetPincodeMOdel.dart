/// Deliverylist : [{"id":"2","pincode":"8787878"},{"id":"3","pincode":"452015"}]
/// ResponseCode : "200"
/// Result : "true"
/// ResponseMsg : "Deliveries List Founded!"

class GetPincodeMOdel {
  GetPincodeMOdel({
      List<Deliverylist>? deliverylist, 
      String? responseCode, 
      String? result, 
      String? responseMsg,}){
    _deliverylist = deliverylist;
    _responseCode = responseCode;
    _result = result;
    _responseMsg = responseMsg;
}

  GetPincodeMOdel.fromJson(dynamic json) {
    if (json['Deliverylist'] != null) {
      _deliverylist = [];
      json['Deliverylist'].forEach((v) {
        _deliverylist?.add(Deliverylist.fromJson(v));
      });
    }
    _responseCode = json['ResponseCode'];
    _result = json['Result'];
    _responseMsg = json['ResponseMsg'];
  }
  List<Deliverylist>? _deliverylist;
  String? _responseCode;
  String? _result;
  String? _responseMsg;
GetPincodeMOdel copyWith({  List<Deliverylist>? deliverylist,
  String? responseCode,
  String? result,
  String? responseMsg,
}) => GetPincodeMOdel(  deliverylist: deliverylist ?? _deliverylist,
  responseCode: responseCode ?? _responseCode,
  result: result ?? _result,
  responseMsg: responseMsg ?? _responseMsg,
);
  List<Deliverylist>? get deliverylist => _deliverylist;
  String? get responseCode => _responseCode;
  String? get result => _result;
  String? get responseMsg => _responseMsg;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_deliverylist != null) {
      map['Deliverylist'] = _deliverylist?.map((v) => v.toJson()).toList();
    }
    map['ResponseCode'] = _responseCode;
    map['Result'] = _result;
    map['ResponseMsg'] = _responseMsg;
    return map;
  }

}

/// id : "2"
/// pincode : "8787878"

class Deliverylist {
  Deliverylist({
      String? id, 
      String? pincode,}){
    _id = id;
    _pincode = pincode;
}

  Deliverylist.fromJson(dynamic json) {
    _id = json['id'];
    _pincode = json['pincode'];
  }
  String? _id;
  String? _pincode;
Deliverylist copyWith({  String? id,
  String? pincode,
}) => Deliverylist(  id: id ?? _id,
  pincode: pincode ?? _pincode,
);
  String? get id => _id;
  String? get pincode => _pincode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['pincode'] = _pincode;
    return map;
  }

}