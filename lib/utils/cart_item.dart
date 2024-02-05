// ignore_for_file: file_names, depend_on_referenced_packages

import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class CartItem extends HiveObject {
  @HiveField(0)
  String? id; //attribute ID

  @HiveField(1)
  double? price; // normal Price

  @HiveField(2)
  int? quantity; // product Qty

  @HiveField(3)
  double? productPrice; // product Normal Price

  @HiveField(4)
  String? strTitle; // Store Title

  @HiveField(5)
  String? per; // Product Descount

  @HiveField(6)
  String? isRequride; // SubScripTion Requride

  @HiveField(7)
  String? storeID; // Store ID

  @HiveField(8)
  double? sPrice; // SubScription Price

  @HiveField(9)
  String? img; // Product Image

  @HiveField(10)
  String? productTitle; // Product Title

  @HiveField(11)
  String? selectDelivery; // Select Delivery

  @HiveField(12)
  String? startDate; // Start Date

  @HiveField(13)
  String? startTime; // Start Time

  @HiveField(14)
  List<String>? daysList; // daysList

  @HiveField(15)
  String? cartCheck;
  // CartCheck

  @HiveField(16)
  String? productID;
  // ProductId

  @HiveField(17)
  String? selectnewmonth;


}
