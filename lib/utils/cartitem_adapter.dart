// ignore_for_file: avoid_renaming_method_parameters, depend_on_referenced_packages

import 'package:hive/hive.dart';
import 'package:milkman/utils/cart_item.dart';

class CartItemAdapter extends TypeAdapter<CartItem> {
  @override
  final int typeId = 1;

  @override
  CartItem read(BinaryReader reader) {
    var item = CartItem();
    item.id = reader.readString(); //attribute ID
    item.price = reader.readDouble(); // normal Price
    item.quantity = reader.readInt(); // product Qty
    item.productPrice = reader.readDouble(); // product Normal Price
    item.strTitle = reader.readString(); // Store Title
    item.per = reader.readString(); // Product Descount
    item.isRequride = reader.readString(); // SubScripTion Requride
    item.storeID = reader.readString(); // Store ID
    item.sPrice = reader.readDouble(); // SubScription Price
    item.img = reader.readString(); // Product Image
    item.productTitle = reader.readString(); // Product Title
    item.selectDelivery = reader.readString(); // Select Delivery
    item.startDate = reader.readString(); // Start Date
    item.startTime = reader.readString(); // Start Time
    item.daysList = reader.readStringList(); // daysList
    item.cartCheck = reader.readString(); // CartCheck
    item.productID = reader.readString(); // Product Id
    return item;
  }

  @override
  void write(BinaryWriter writer, CartItem item) {
    writer.writeString(item.id.toString()); //attribute ID
    writer.writeDouble(item.price ?? 0); // normal Price
    writer.writeInt(item.quantity!); // product Qty
    writer.writeDouble(item.productPrice ?? 0); // product Normal Price
    writer.writeString(item.strTitle ?? ""); // Store Title
    writer.writeString(item.per ?? ""); // Product Descount
    writer.writeString(item.isRequride ?? ""); // SubScripTion Requride
    writer.writeString(item.storeID ?? ""); // Store ID
    writer.writeDouble(item.sPrice ?? 0); // SubScription Price
    writer.writeString(item.img ?? ""); // Product Image
    writer.writeString(item.productTitle ?? ""); // Product Title
    writer.writeString(item.selectDelivery ?? ""); // Select Delivery
    writer.writeString(item.startDate ?? ""); // Start Date
    writer.writeString(item.startTime ?? ""); // Start Time
    writer.writeStringList(item.daysList ?? []); // daysList
    writer.writeString(item.cartCheck ?? "0"); // CartCheck
    writer.writeString(item.productID ?? ""); // Product Id
  }
}
