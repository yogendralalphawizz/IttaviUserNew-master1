// ignore_for_file: prefer_const_constructors, sort_child_properties_last, use_key_in_widget_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables, prefer_interpolation_to_compose_strings, avoid_print, sized_box_for_whitespace, unused_local_variable, unnecessary_brace_in_string_interps

import 'dart:convert';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:milkman/Api/config.dart';
import 'package:milkman/Api/data_store.dart';
import 'package:milkman/controller/catdetails_controller.dart';
import 'package:milkman/controller/home_controller.dart';
import 'package:milkman/controller/notification_controller.dart';
import 'package:milkman/controller/stordata_controller.dart';
import 'package:milkman/helpar/routes_helper.dart';
import 'package:milkman/model/fontfamily_model.dart';
import 'package:milkman/screen/onbording_screen.dart';
import 'package:milkman/utils/Colors.dart';
import 'package:readmore/readmore.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../controller/productdetails_controller.dart';
import '../model/GetPincodeMOdel.dart';
import '../utils/cart_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

var currency;
var wallat1;

class _HomeScreenState extends State<HomeScreen> {
  HomePageController homePageController = Get.find();
  CatDetailsController catDetailsController = Get.find();
  StoreDataContoller storeDataContoller = Get.find();
  ProductDetailsController productDetailsController = Get.find();
  NotificationController notificationController = Get.find();

  int selectIndex = 0;
  String name = "";

  @override
  void initState() {
    getCurrentLatAndLong();
    getPincode();
    if (getData.read("UserLogin") != null) {
      setState(() {
        name = getData.read("UserLogin")["name"];
      });
    }
    super.initState();
    cart = Hive.box<CartItem>('cart');
    _scrollController = ScrollController()..addListener(_scrollListener);
    setupHive();
  }

  bool lastStatus = true;
  double height = Get.height * 0.56;

  Future<void> setupHive() async {
    await Hive.initFlutter();
    cart = Hive.box<CartItem>('cart');
    AsyncSnapshot.waiting();
    List<CartItem> tempList = [];
    catDetailsController.getCartLangth();
  }

  Future<Position> locateUser() async {
    return Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  void _scrollListener() {
    if (_isShrink != lastStatus) {
      setState(() {
        lastStatus = _isShrink;
      });
    }
  }

  ScrollController scrollController = ScrollController();

  bool get _isShrink {
    return _scrollController != null &&
        _scrollController!.hasClients &&
        _scrollController!.offset > (height - kToolbarHeight);
  }

  getCurrentLatAndLong() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {}
    var currentLocation = await locateUser();
    List<Placemark> addresses = await placemarkFromCoordinates(
        currentLocation.latitude, currentLocation.longitude);
    await placemarkFromCoordinates(
            currentLocation.latitude, currentLocation.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      address =
          '${placemarks.first.name!.isNotEmpty ? placemarks.first.name! + ', ' : ''}${placemarks.first.thoroughfare!.isNotEmpty ? placemarks.first.thoroughfare! + ', ' : ''}${placemarks.first.subLocality!.isNotEmpty ? placemarks.first.subLocality! + ', ' : ''}${placemarks.first.locality!.isNotEmpty ? placemarks.first.locality! + ', ' : ''}${placemarks.first.subAdministrativeArea!.isNotEmpty ? placemarks.first.subAdministrativeArea! + ', ' : ''}${placemarks.first.postalCode!.isNotEmpty ? placemarks.first.postalCode! + ', ' : ''}${placemarks.first.administrativeArea!.isNotEmpty ? placemarks.first.administrativeArea : ''}';
    });
    print("AAAAAAAAAAAAAAAAAAAAAAA" + address.toString());
    // setState(() {});
  }

  List<String> img = [
    "assets/star2.png",
    "assets/location-pin2.png",
    "assets/door-open.png",
    "assets/like.png",
  ];

  ScrollController? _scrollController;

  List itemList = [];

  getSubScriptionProductTypeList() {
    print('.......+++++++++.........' +
        productDetailsController.productInfo!.productData.productInfo.length
            .toString());
    itemList = [];
    for (var element
        in productDetailsController.productInfo!.productData.productInfo) {
      if (element.subscriptionRequired != "0" &&
          element.productOutStock == "0") {
        itemList.add(element.title);
      }
    }
  }

  late Box<CartItem> cart;
  late final List<CartItem> items;
  double productPrice = 0;

  Future<void> onAddItem1(
    int index,
    String qtys, {
    String? id1,
    price1,
    strTitle1,
    per1,
    isRequride1,
    storeId1,
    sPrice1,
    img1,
    productTitle1,
    productId,
  }) async {
    String? id = productDetailsController
        .productInfo?.productData.productInfo[index].attributeId;

    String finalPrice = "${(double.parse(price1) * double.parse(per1)) / 100}";

    String? price = price1.toString();

    int? qty = int.parse(qtys);
    qty = qty + 1;
    cart = Hive.box<CartItem>('cart');
    final newItem = CartItem();
    newItem.id = id; //attribute ID
    newItem.price = double.parse(price1.toString()) -
        double.parse(finalPrice); // normal Price
    newItem.quantity = qty; // product Qty
    newItem.productPrice = double.parse(price1.toString()) -
        double.parse(finalPrice); // product Normal Price
    newItem.strTitle = strTitle1; // Store Title
    newItem.per = per1; // Product Descount
    newItem.isRequride = isRequride1; // SubScripTion Requride
    newItem.storeID = storeId1; // Store ID
    newItem.sPrice = double.parse(sPrice1); // SubScription Price
    newItem.img = img1; // Product Image
    newItem.productTitle = productTitle1; // Product Title
    newItem.selectDelivery = ""; // Select Delivery
    newItem.startDate = ""; // Start Date
    newItem.startTime = ""; // Start Time
    newItem.daysList = []; // daysList
    newItem.cartCheck = "0"; // CartCheck
    newItem.productID = productId; // Product ID
    if (qtys == "0") {
      cart.put(id, newItem);
      catDetailsController.getCartLangth();
      setState(() {});
    } else {
      var item = cart.get(id);
      item?.quantity = qty;
      cart.put(id, item!);
    }
  }

  void onRemoveItem1(
    int index,
    String qtys, {
    String? pr1,
  }) {
    String? id = productDetailsController
        .productInfo?.productData.productInfo[index].attributeId
        .toString();
    String? price = productDetailsController
        .productInfo?.productData.productInfo[index].normalPrice
        .toString();
    int? qty = int.parse(qtys);
    qty = qty - 1;
    cart = Hive.box<CartItem>('cart');
    if (qtys == "1") {
      cart.delete(id);

      catDetailsController.getCartLangth();
      setState(() {});
    } else {
      var item = cart.get(id);
      item?.quantity = qty;
      cart.put(id, item!);

      setState(() {});
    }
  }

  String isItem1(String? index) {
    for (final item in cart.values) {
      if (item.id == index) {
        return item.quantity.toString();
      }
    }
    return "0";
  }

  String isSubscibe1(String? index) {
    for (final item in cart.values) {
      if (item.id == index) {
        return item.cartCheck.toString();
      }
    }
    return "0";
  }

  Future<void> onAddItem(
    int index,
    String qtys, {
    String? id1,
    price1,
    strTitle1,
    per1,
    isRequride1,
    storeId1,
    sPrice1,
    img1,
    productTitle1,
    productId,
  }) async {
    String? id = id1;
    String? price = price1.toString();
    int? qty = int.parse(qtys);
    qty = qty + 1;
    cart = Hive.box<CartItem>('cart');
    final newItem = CartItem();

    String finalPrice =
        "${(double.parse(price1.toString()) * double.parse(per1)) / 100}";

    print("@@@@@@@@@<FinalPrice>@@@@@@@@@" + finalPrice);
    print("Price>@@@@@@@@@" + price1.toString());
    print("rrererererrereer" +  double.parse(per1).toString());


    newItem.id = id; //attribute ID
    newItem.price = double.parse(price1.toString()) -
        double.parse(finalPrice); // normal Price
    newItem.quantity = qty; // product Qty
    newItem.productPrice = double.parse(price1.toString()) -
        double.parse(finalPrice); // product Normal Price
    newItem.strTitle = strTitle1; // Store Title
    newItem.per = per1; // Product Descount
    newItem.isRequride = isRequride1; // SubScripTion Requride
    newItem.storeID = storeId1; // Store ID
    newItem.sPrice = double.parse(sPrice1); // SubScription Price
    newItem.img = img1; // Product Image
    newItem.productTitle = productTitle1; // Product Title
    newItem.selectDelivery = ""; // Select Delivery
    newItem.startDate = ""; // Start Date
    newItem.startTime = ""; // Start Time
    newItem.daysList = []; // daysList
    newItem.cartCheck = "0"; // CartCheck
    newItem.productID = productId;

    print("<<<<<<<<ID>>>>>>>>" + id1.toString());
    print("<<<<<<<<Price1>>>>>>>>" + price1.toString());
    print("<<<<<<<<Qty>>>>>>>>" + qty.toString());
    print("<<<<<<<<StrTitle1>>>>>>>>" + strTitle1.toString());
    print("<<<<<<<<Per1>>>>>>>>" + per1.toString());
    print("<<<<<<<<IsRequride1>>>>>>>>" + isRequride1.toString());
    print("<<<<<<<<StoreId1>>>>>>>>" + storeId1.toString());

    if (qtys == "0") {
      cart.put(id, newItem);
      catDetailsController.getCartLangth();
    } else {
      // if (int.parse(isItem(id)) < int.parse(qLimit1)) {
      var item = cart.get(id);
      item?.quantity = qty;
      cart.put(id, item!);
      // } else {
      //   showToastMessage("Exceeded the maximum quantity limit per order!".tr);
      // }
    }
  }

  void onRemoveItem(int index, String qtys, {String? id1, price1}) {
    String? id = id1;
    String? price = price1;
    int? qty = int.parse(qtys);
    qty = qty - 1;
    cart = Hive.box<CartItem>('cart');
    if (qtys == "1") {
      cart.delete(id);
      catDetailsController.getCartLangth();
    } else {
      var item = cart.get(id);
      item?.quantity = qty;
      cart.put(id, item!);
    }
  }

  String isItem(String? index) {
    for (final item in cart.values) {
      if (item.id == index) {
        return item.quantity.toString();
      }
    }
    return "0";
  }

  String isSubscibe(String? index) {
    for (final item in cart.values) {
      if (item.id == index) {
        return item.cartCheck.toString();
      }
    }
    return "0";
  }

  detailsSheet(String desc) {
    int selectIndex = 0;
    return showModalBottomSheet(
        backgroundColor: WhiteColor,
        isScrollControlled: true,
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15))),
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: Get.height * 0.8,
              // padding: const EdgeInsets.symmetric(vertical: 12),
              child: Scaffold(
                backgroundColor: WhiteColor,
                floatingActionButton: Container(
                  transform: Matrix4.translationValues(
                      0.0, -80, 0.0), // translate up by 30
                  child: FloatingActionButton(
                    backgroundColor: WhiteColor.withOpacity(0.5),
                    onPressed: () {
                      Get.back();
                    },
                    child: Icon(Icons.close),
                  ),
                ),
                bottomNavigationBar:
                    GetBuilder<ProductDetailsController>(builder: (context) {
                  if (productDetailsController.isLoading == true) {
                    getSubScriptionProductTypeList();
                  }
                  return productDetailsController.isLoading
                      ? Container(
                          height: 50,
                          width: Get.size.width,
                          color: WhiteColor,
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Text(
                                    //   "${catDetailsController.count.length.toString()} Piecessss",
                                    //   style: TextStyle(
                                    //     fontFamily: FontFamily.gilroyBold,
                                    //     fontSize: 14,
                                    //   ),
                                    // ),

                                    // SizedBox(
                                    //   height: 8,
                                    // ),
                                    // Text(
                                    //   // "${currency}${double.parse(productDetailsController.productInfo?.productData.productInfo[0].normalPrice.toString() ?? "") * int.parse(isItem1(productDetailsController.productInfo?.productData.id).toString())}",
                                    //   "${tempTotal}",
                                    //   style: TextStyle(
                                    //     fontFamily: FontFamily.gilroyBold,
                                    //     fontSize: 14,
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Get.back();
                                  catDetailsController.changeIndex(2);
                                },
                                child: Container(
                                  height: 40,
                                  width: 110,
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: Text(
                                    "View Cart".tr,
                                    style: TextStyle(
                                      fontFamily: FontFamily.gilroyMedium,
                                      fontSize: 14,
                                      color: WhiteColor,
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: gradient.btnGradient,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      : SizedBox();
                }),
                body: GetBuilder<ProductDetailsController>(builder: (context) {
                  return productDetailsController.isLoading
                      ? SizedBox(
                          height: Get.size.height,
                          width: Get.size.width,
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      color: WhiteColor,
                                      height: Get.size.height * 0.3,
                                      child: PageView.builder(
                                        itemCount: productDetailsController
                                            .productInfo
                                            ?.productData
                                            .img
                                            .length,
                                        physics: BouncingScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          return Stack(
                                            children: [
                                              Container(
                                                alignment: Alignment.center,
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 15,
                                                    vertical: 8),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  child:
                                                      FadeInImage.assetNetwork(
                                                    placeholder:
                                                        "assets/ezgif.com-crop.gif",
                                                    placeholderFit: BoxFit.fill,
                                                    image:
                                                        "${Config.imageUrl}${productDetailsController.productInfo?.productData.img[index] ?? ""}",
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                              ),
                                              // Positioned(
                                              //   bottom: 15,
                                              //   left: 15,
                                              //   right: 15,
                                              //   child: Container(
                                              //     height: 50,
                                              //     width: Get.size.width,
                                              //     decoration: BoxDecoration(
                                              //       image: DecorationImage(
                                              //         image: AssetImage(
                                              //             "assets/Rectangle.png"),
                                              //         fit: BoxFit.fill,
                                              //       ),
                                              //       borderRadius: BorderRadius.only(
                                              //         bottomLeft:
                                              //             Radius.circular(15),
                                              //         bottomRight:
                                              //             Radius.circular(15),
                                              //       ),
                                              //     ),
                                              //   ),
                                              // ),
                                            ],
                                          );
                                        },
                                        onPageChanged: (value) {
                                          setState(() {
                                            selectIndex = value;
                                          });
                                        },
                                      ),
                                    ),
                                    Positioned(
                                      bottom: -8,
                                      child: SizedBox(
                                        height: 25,
                                        width: Get.size.width,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            ...List.generate(
                                                productDetailsController
                                                    .productInfo!
                                                    .productData
                                                    .img
                                                    .length, (index) {
                                              return Indicator(
                                                isActive: selectIndex == index
                                                    ? true
                                                    : false,
                                              );
                                            }),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Divider(
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 15),
                                  child: Text(
                                    productDetailsController
                                            .productInfo?.productData.title ??
                                        "",
                                    maxLines: 2,
                                    style: TextStyle(
                                      fontFamily: FontFamily.gilroyBold,
                                      fontSize: 18,
                                      color: BlackColor,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Row(
                                    children: [
                                      Spacer(),
                                      itemList.isNotEmpty
                                          ? InkWell(
                                              onTap: () {
                                                for (var i = 0;
                                                    i <
                                                        productDetailsController
                                                            .productInfo!
                                                            .productData
                                                            .productInfo
                                                            .length;
                                                    i++) {
                                                  if (productDetailsController
                                                              .productInfo!
                                                              .productData
                                                              .productInfo[i]
                                                              .subscriptionRequired ==
                                                          "1" &&
                                                      productDetailsController
                                                              .productInfo!
                                                              .productData
                                                              .productInfo[i]
                                                              .productOutStock ==
                                                          "0") {
                                                    productDetailsController
                                                        .getProductDetailsApi(
                                                      pId:
                                                          productDetailsController
                                                                  .productInfo
                                                                  ?.productData
                                                                  .id ??
                                                              "",
                                                    );
                                                    Get.toNamed(
                                                        Routes.subScribeScreen,
                                                        arguments: {
                                                          "img":
                                                              productDetailsController
                                                                  .productInfo!
                                                                  .productData
                                                                  .img[0],
                                                          "name":
                                                              productDetailsController
                                                                  .productInfo!
                                                                  .productData
                                                                  .title,
                                                          "sprice":
                                                              productDetailsController
                                                                  .productInfo!
                                                                  .productData
                                                                  .productInfo[
                                                                      i]
                                                                  .subscribePrice,
                                                          "aprice": productDetailsController.productInfo!.productData.productInfo[i].normalPrice,
                                                          "per": productDetailsController
                                                              .productInfo!
                                                              .productData
                                                              .productInfo[i]
                                                              .productDiscount,
                                                          "attributeId":
                                                              productDetailsController
                                                                  .productInfo!
                                                                  .productData
                                                                  .productInfo[
                                                                      i]
                                                                  .attributeId,
                                                          "productTitle":
                                                              productDetailsController
                                                                  .productInfo!
                                                                  .productData
                                                                  .productInfo[i]
                                                                  .title,
                                                          "isEmpty": "0",
                                                          "productId":
                                                              productDetailsController
                                                                  .productInfo!
                                                                  .productData
                                                                  .id,
                                                          "product_subscripition_discount": productDetailsController.productInfo!.productData.productInfo[i].productDiscount,
                                                        });
                                                    break;
                                                  }
                                                }
                                              },
                                              child: Container(
                                                height: 25,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 8),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  "SUBSCRIBE".tr,
                                                  style: TextStyle(
                                                    color:
                                                        gradient.defoultColor,
                                                    fontFamily:
                                                        FontFamily.gilroyBold,
                                                    fontSize: 11,
                                                  ),
                                                ),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  border: Border.all(
                                                      color:
                                                          Colors.grey.shade300),
                                                ),
                                              ),
                                            )
                                          : SizedBox(),
                                      SizedBox(
                                        width: 10,
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Divider(
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Text(
                                    "Select unit".tr,
                                    style: TextStyle(
                                      fontFamily: FontFamily.gilroyBold,
                                      fontSize: 18,
                                      color: BlackColor,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 120,
                                  child: ListView.builder(
                                    itemCount: productDetailsController
                                            .productInfo
                                            ?.productData
                                            .productInfo
                                            .length ??
                                        0,
                                    scrollDirection: Axis.horizontal,
                                    padding: EdgeInsets.zero,
                                    itemBuilder: (context, index) {
                                      String currentPrice =
                                          "${(double.parse(productDetailsController.productInfo?.productData.productInfo[index].normalPrice ?? "") * double.parse(productDetailsController.productInfo?.productData.productInfo[index].productDiscount ?? "")) / 100}";
                                      return Stack(
                                        children: [
                                          Container(
                                            height: 120,
                                            width: 120,
                                            child: Column(
                                              children: [
                                                Container(
                                                  height: 70,
                                                  width: 120,
                                                  alignment: Alignment.center,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      SizedBox(
                                                        width: 120,
                                                        child: Text(
                                                          productDetailsController
                                                                  .productInfo
                                                                  ?.productData
                                                                  .productInfo[
                                                                      index]
                                                                  .title ??
                                                              "",
                                                          maxLines: 1,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            fontFamily:
                                                                FontFamily
                                                                    .gilroyBold,
                                                            fontSize: 15,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 7,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            "${currency}${double.parse(productDetailsController.productInfo?.productData.productInfo[index].normalPrice.toString() ?? "") - double.parse(productDetailsController.productInfo?.productData.productInfo[index].normalPrice.toString() ?? "")*double.parse(productDetailsController.productInfo?.productData.productInfo[index].productDiscount.toString() ?? "")/100}",
                                                            style: TextStyle(
                                                              color: BlackColor,
                                                              fontFamily:
                                                                  FontFamily
                                                                      .gilroyBold,
                                                              fontSize: 15,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 4,
                                                          ),
                                                          productDetailsController
                                                                      .productInfo
                                                                      ?.productData
                                                                      .productInfo[
                                                                          index]
                                                                      .productDiscount !=
                                                                  "0"
                                                              ? Text(
                                                                  "${currency}${productDetailsController.productInfo?.productData.productInfo[index].normalPrice}",
                                                                  style: TextStyle(
                                                                      color:
                                                                          greytext,
                                                                      fontFamily:
                                                                          FontFamily
                                                                              .gilroyBold,
                                                                      fontSize:
                                                                          13,
                                                                      decoration:
                                                                          TextDecoration
                                                                              .lineThrough),
                                                                )
                                                              : SizedBox(),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: WhiteColor,
                                                    border: Border.all(
                                                      color:
                                                          Colors.grey.shade300,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            margin: EdgeInsets.all(8),
                                          ),
                                          Positioned(
                                            bottom: 18,
                                            left: 20,
                                            right: 20,
                                            child: productDetailsController
                                                        .productInfo
                                                        ?.productData
                                                        .productInfo[index]
                                                        .productOutStock ==
                                                    "0"
                                                ? isItem1(productDetailsController
                                                            .productInfo
                                                            ?.productData
                                                            .productInfo[index]
                                                            .attributeId
                                                            .toString()) !=
                                                        "0"
                                                    ? isSubscibe(productDetailsController
                                                                .productInfo
                                                                ?.productData
                                                                .productInfo[
                                                                    index]
                                                                .attributeId
                                                                .toString()) !=
                                                            "1"
                                                        ? Container(
                                                            height: 28,
                                                            width: 70,
                                                            margin:
                                                                EdgeInsets.all(
                                                                    5),
                                                            alignment: Alignment
                                                                .center,
                                                            child: Row(
                                                              children: [
                                                                SizedBox(
                                                                  width: 7,
                                                                ),
                                                                InkWell(
                                                                  onTap: () {
                                                                    setState(
                                                                        () {
                                                                      onRemoveItem1(
                                                                        index,
                                                                        isItem1(productDetailsController
                                                                            .productInfo
                                                                            ?.productData
                                                                            .productInfo[index]
                                                                            .attributeId
                                                                            .toString()),
                                                                        pr1:
                                                                            "${(double.parse(productDetailsController.productInfo?.productData.productInfo[index].normalPrice ?? "") * double.parse(productDetailsController.productInfo?.productData.productInfo[index].productDiscount ?? "")) / 100}",
                                                                      );
                                                                    });
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    height: 30,
                                                                    width: 15,
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    child: Icon(
                                                                      Icons.remove,
                                                                      color: gradient
                                                                          .defoultColor,
                                                                      size: 15,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child:
                                                                      Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    child: Text(
                                                                      isItem1(productDetailsController
                                                                              .productInfo
                                                                              ?.productData
                                                                              .productInfo[index]
                                                                              .attributeId)
                                                                          .toString(),
                                                                      style:
                                                                          TextStyle(
                                                                        color: gradient
                                                                            .defoultColor,
                                                                        fontFamily:
                                                                            FontFamily.gilroyBold,
                                                                        fontSize:
                                                                            15,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                InkWell(
                                                                  onTap: () {
                                                                    setState(
                                                                        () {
                                                                      onAddItem1(
                                                                        index,
                                                                        isItem(productDetailsController.productInfo?.productData.productInfo[index].attributeId),
                                                                        id1: productDetailsController.productInfo?.productData.productInfo[index].attributeId,
                                                                        price1: productDetailsController.productInfo?.productData.productInfo[index].normalPrice,
                                                                        strTitle1: productDetailsController.productInfo?.productData.title,
                                                                        isRequride1: productDetailsController.productInfo?.productData.productInfo[index].subscriptionRequired,
                                                                        per1: productDetailsController.productInfo?.productData.productInfo[index].productDiscount,
                                                                        storeId1: storeDataContoller.storeDataInfo?.storeInfo.storeId,
                                                                        sPrice1: productDetailsController.productInfo?.productData.productInfo[index].subscribePrice,
                                                                        img1: productDetailsController.productInfo?.productData.img[0],
                                                                        productTitle1: productDetailsController.productInfo?.productData.productInfo[index].title,
                                                                        productId: productDetailsController.productInfo?.productData.id,
                                                                      );
                                                                    });
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    height: 30,
                                                                    width: 15,
                                                                    alignment: Alignment.center,
                                                                    child: Icon(
                                                                      Icons.add,
                                                                      color: gradient.defoultColor,
                                                                      size: 15,
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 7,
                                                                ),
                                                              ],
                                                            ),
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(10),
                                                              color: WhiteColor,
                                                              border: Border.all(color: Colors.grey.shade300)),
                                                          )
                                                        : InkWell(
                                                            onTap: () {
                                                              setState(() {
                                                                if (cart.values.isNotEmpty) {
                                                                  for (var element in cart.values) {
                                                                    if (element.storeID ==
                                                                        storeDataContoller.storeDataInfo?.storeInfo.storeId) {
                                                                      if (element.cartCheck == "1") {
                                                                        Get.bottomSheet(
                                                                          Container(
                                                                            height:
                                                                                200,
                                                                            width:
                                                                                Get.size.width,
                                                                            child:
                                                                                Column(
                                                                              children: [
                                                                                SizedBox(
                                                                                  height: 15,
                                                                                ),
                                                                                Padding(
                                                                                  padding: EdgeInsets.only(top: 5, left: 15, right: 15),
                                                                                  child: Text(
                                                                                    "Would you like to empty your cart and add new items, or do you want to keep the current items in your cart?".tr,
                                                                                    style: TextStyle(
                                                                                      fontFamily: FontFamily.gilroyMedium,
                                                                                      fontSize: 16,
                                                                                      height: 1.2,
                                                                                      letterSpacing: 1,
                                                                                      color: BlackColor,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                SizedBox(
                                                                                  height: 10,
                                                                                ),
                                                                                Padding(
                                                                                  padding: const EdgeInsets.symmetric(horizontal: 15),
                                                                                  child: Divider(
                                                                                    color: Colors.grey,
                                                                                  ),
                                                                                ),
                                                                                Spacer(),
                                                                                Row(
                                                                                  children: [
                                                                                    Expanded(
                                                                                      child: InkWell(
                                                                                        onTap: () {
                                                                                          Get.back();
                                                                                        },
                                                                                        child: Container(
                                                                                          height: 40,
                                                                                          width: Get.size.width,
                                                                                          alignment: Alignment.center,
                                                                                          margin: EdgeInsets.symmetric(horizontal: 10),
                                                                                          child: Text(
                                                                                            "No".tr,
                                                                                            style: TextStyle(
                                                                                              fontFamily: FontFamily.gilroyBold,
                                                                                              color: gradient.defoultColor,
                                                                                              fontSize: 16,
                                                                                            ),
                                                                                          ),
                                                                                          decoration: BoxDecoration(
                                                                                            color: gradient.defoultColor.withOpacity(0.1),
                                                                                            borderRadius: BorderRadius.circular(25),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    Expanded(
                                                                                      child: InkWell(
                                                                                        onTap: () {
                                                                                          for (var element in cart.values) {
                                                                                            if (element.storeID == storeDataContoller.storeDataInfo?.storeInfo.storeId) {
                                                                                              if (element.cartCheck == "1") {
                                                                                                cart.delete(element.id);
                                                                                                catDetailsController.getCartLangth();
                                                                                                setState(() {});
                                                                                              }
                                                                                            }
                                                                                          }
                                                                                          //!
                                                                                          onAddItem1(
                                                                                            index,
                                                                                            isItem(productDetailsController.productInfo?.productData.productInfo[index].attributeId),
                                                                                            id1: productDetailsController.productInfo?.productData.productInfo[index].attributeId,
                                                                                            price1: productDetailsController.productInfo?.productData.productInfo[index].normalPrice,
                                                                                            strTitle1: productDetailsController.productInfo?.productData.title,
                                                                                            isRequride1: productDetailsController.productInfo?.productData.productInfo[index].subscriptionRequired,
                                                                                            per1: productDetailsController.productInfo?.productData.productInfo[index].productDiscount,
                                                                                            storeId1: storeDataContoller.storeDataInfo?.storeInfo.storeId,
                                                                                            sPrice1: productDetailsController.productInfo?.productData.productInfo[index].subscribePrice,
                                                                                            img1: productDetailsController.productInfo?.productData.img[0],
                                                                                            productTitle1: productDetailsController.productInfo?.productData.productInfo[index].title,
                                                                                            productId: productDetailsController.productInfo?.productData.id,
                                                                                          );

                                                                                          Get.back();
                                                                                        },
                                                                                        child: Container(
                                                                                          height: 40,
                                                                                          width: Get.size.width,
                                                                                          alignment: Alignment.center,
                                                                                          margin: EdgeInsets.symmetric(horizontal: 10),
                                                                                          child: Text(
                                                                                            "Clear Cart".tr,
                                                                                            style: TextStyle(
                                                                                              fontFamily: FontFamily.gilroyBold,
                                                                                              color: WhiteColor,
                                                                                              fontSize: 16,
                                                                                            ),
                                                                                          ),
                                                                                          decoration: BoxDecoration(
                                                                                            gradient: gradient.btnGradient,
                                                                                            borderRadius: BorderRadius.circular(25),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                SizedBox(
                                                                                  height: 20,
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: WhiteColor,
                                                                              borderRadius: BorderRadius.only(
                                                                                topLeft: Radius.circular(30),
                                                                                topRight: Radius.circular(30),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        );
                                                                        break;
                                                                      } else {
                                                                        onAddItem1(
                                                                          index,
                                                                          isItem(productDetailsController
                                                                              .productInfo
                                                                              ?.productData
                                                                              .productInfo[index]
                                                                              .attributeId),
                                                                          id1: productDetailsController
                                                                              .productInfo
                                                                              ?.productData
                                                                              .productInfo[index]
                                                                              .attributeId,
                                                                          price1: productDetailsController
                                                                              .productInfo
                                                                              ?.productData
                                                                              .productInfo[index]
                                                                              .normalPrice,
                                                                          strTitle1: productDetailsController
                                                                              .productInfo
                                                                              ?.productData
                                                                              .title,
                                                                          isRequride1: productDetailsController
                                                                              .productInfo
                                                                              ?.productData
                                                                              .productInfo[index]
                                                                              .subscriptionRequired,
                                                                          per1: productDetailsController
                                                                              .productInfo
                                                                              ?.productData
                                                                              .productInfo[index]
                                                                              .productDiscount,
                                                                          storeId1: storeDataContoller
                                                                              .storeDataInfo
                                                                              ?.storeInfo
                                                                              .storeId,
                                                                          sPrice1: productDetailsController
                                                                              .productInfo
                                                                              ?.productData
                                                                              .productInfo[index]
                                                                              .subscribePrice,
                                                                          img1: productDetailsController
                                                                              .productInfo
                                                                              ?.productData
                                                                              .img[0],
                                                                          productTitle1: productDetailsController
                                                                              .productInfo
                                                                              ?.productData
                                                                              .productInfo[index]
                                                                              .title,
                                                                          productId: productDetailsController
                                                                              .productInfo
                                                                              ?.productData
                                                                              .id,
                                                                        );
                                                                        break;
                                                                      }
                                                                    }
                                                                  }
                                                                } else {
                                                                  onAddItem1(
                                                                    index,
                                                                    isItem(productDetailsController
                                                                        .productInfo
                                                                        ?.productData
                                                                        .productInfo[
                                                                            index]
                                                                        .attributeId),
                                                                    id1: productDetailsController
                                                                        .productInfo
                                                                        ?.productData
                                                                        .productInfo[
                                                                            index]
                                                                        .attributeId,
                                                                    price1: productDetailsController
                                                                        .productInfo
                                                                        ?.productData
                                                                        .productInfo[
                                                                            index]
                                                                        .normalPrice,
                                                                    strTitle1: productDetailsController
                                                                        .productInfo
                                                                        ?.productData
                                                                        .title,
                                                                    isRequride1: productDetailsController
                                                                        .productInfo
                                                                        ?.productData
                                                                        .productInfo[
                                                                            index]
                                                                        .subscriptionRequired,
                                                                    per1: productDetailsController
                                                                        .productInfo
                                                                        ?.productData
                                                                        .productInfo[
                                                                            index]
                                                                        .productDiscount,
                                                                    storeId1: storeDataContoller
                                                                        .storeDataInfo
                                                                        ?.storeInfo
                                                                        .storeId,
                                                                    sPrice1: productDetailsController
                                                                        .productInfo
                                                                        ?.productData
                                                                        .productInfo[
                                                                            index]
                                                                        .subscribePrice,
                                                                    img1: productDetailsController
                                                                        .productInfo
                                                                        ?.productData
                                                                        .img[0],
                                                                    productTitle1: productDetailsController
                                                                        .productInfo
                                                                        ?.productData
                                                                        .productInfo[
                                                                            index]
                                                                        .title,
                                                                    productId: productDetailsController
                                                                        .productInfo
                                                                        ?.productData
                                                                        .id,
                                                                  );
                                                                }
                                                              });
                                                            },
                                                            child: Container(
                                                              height: 30,
                                                              width: 70,
                                                              margin: EdgeInsets
                                                                  .all(5),
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Text(
                                                                "ADD".tr,
                                                                style:
                                                                    TextStyle(
                                                                  color: gradient
                                                                      .defoultColor,
                                                                  fontFamily:
                                                                      FontFamily
                                                                          .gilroyBold,
                                                                  fontSize: 13,
                                                                ),
                                                              ),
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                                color:
                                                                    WhiteColor,
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade300),
                                                              ),
                                                            ),
                                                          )
                                                    : InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            if (cart.values
                                                                .isNotEmpty) {
                                                              for (var element
                                                                  in cart
                                                                      .values) {
                                                                if (element
                                                                        .storeID ==
                                                                    storeDataContoller
                                                                        .storeDataInfo
                                                                        ?.storeInfo
                                                                        .storeId) {
                                                                  if (element
                                                                          .cartCheck ==
                                                                      "1") {
                                                                    Get.bottomSheet(
                                                                      Container(
                                                                        height:
                                                                            200,
                                                                        width: Get
                                                                            .size
                                                                            .width,
                                                                        child:
                                                                            Column(
                                                                          children: [
                                                                            SizedBox(
                                                                              height: 15,
                                                                            ),
                                                                            Padding(
                                                                              padding: EdgeInsets.only(top: 5, left: 15, right: 15),
                                                                              child: Text(
                                                                                "Would you like to empty your cart and add new items, or do you want to keep the current items in your cart?".tr,
                                                                                style: TextStyle(
                                                                                  fontFamily: FontFamily.gilroyMedium,
                                                                                  fontSize: 16,
                                                                                  height: 1.2,
                                                                                  letterSpacing: 1,
                                                                                  color: BlackColor,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              height: 10,
                                                                            ),
                                                                            Padding(
                                                                              padding: const EdgeInsets.symmetric(horizontal: 15),
                                                                              child: Divider(
                                                                                color: Colors.grey,
                                                                              ),
                                                                            ),
                                                                            Spacer(),
                                                                            Row(
                                                                              children: [
                                                                                Expanded(
                                                                                  child: InkWell(
                                                                                    onTap: () {
                                                                                      Get.back();
                                                                                    },
                                                                                    child: Container(
                                                                                      height: 40,
                                                                                      width: Get.size.width,
                                                                                      alignment: Alignment.center,
                                                                                      margin: EdgeInsets.symmetric(horizontal: 10),
                                                                                      child: Text(
                                                                                        "No".tr,
                                                                                        style: TextStyle(
                                                                                          fontFamily: FontFamily.gilroyBold,
                                                                                          color: gradient.defoultColor,
                                                                                          fontSize: 16,
                                                                                        ),
                                                                                      ),
                                                                                      decoration: BoxDecoration(
                                                                                        color: gradient.defoultColor.withOpacity(0.1),
                                                                                        borderRadius: BorderRadius.circular(25),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Expanded(
                                                                                  child: InkWell(
                                                                                    onTap: () {
                                                                                      for (var element in cart.values) {
                                                                                        if (element.storeID == storeDataContoller.storeDataInfo?.storeInfo.storeId) {
                                                                                          if (element.cartCheck == "1") {
                                                                                            cart.delete(element.id);
                                                                                            catDetailsController.getCartLangth();
                                                                                            setState(() {});
                                                                                          }
                                                                                        }
                                                                                      }
                                                                                      //!
                                                                                      onAddItem1(
                                                                                        index,
                                                                                        isItem(productDetailsController.productInfo?.productData.productInfo[index].attributeId),
                                                                                        id1: productDetailsController.productInfo?.productData.productInfo[index].attributeId,
                                                                                        price1: productDetailsController.productInfo?.productData.productInfo[index].normalPrice,
                                                                                        strTitle1: productDetailsController.productInfo?.productData.title,
                                                                                        isRequride1: productDetailsController.productInfo?.productData.productInfo[index].subscriptionRequired,
                                                                                        per1: productDetailsController.productInfo?.productData.productInfo[index].productDiscount,
                                                                                        storeId1: storeDataContoller.storeDataInfo?.storeInfo.storeId,
                                                                                        sPrice1: productDetailsController.productInfo?.productData.productInfo[index].subscribePrice,
                                                                                        img1: productDetailsController.productInfo?.productData.img[0],
                                                                                        productTitle1: productDetailsController.productInfo?.productData.productInfo[index].title,
                                                                                        productId: productDetailsController.productInfo?.productData.id,
                                                                                      );

                                                                                      Get.back();
                                                                                    },
                                                                                    child: Container(
                                                                                      height: 40,
                                                                                      width: Get.size.width,
                                                                                      alignment: Alignment.center,
                                                                                      margin: EdgeInsets.symmetric(horizontal: 10),
                                                                                      child: Text(
                                                                                        "Clear Cart".tr,
                                                                                        style: TextStyle(
                                                                                          fontFamily: FontFamily.gilroyBold,
                                                                                          color: WhiteColor,
                                                                                          fontSize: 16,
                                                                                        ),
                                                                                      ),
                                                                                      decoration: BoxDecoration(
                                                                                        gradient: gradient.btnGradient,
                                                                                        borderRadius: BorderRadius.circular(25),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            SizedBox(
                                                                              height: 20,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              WhiteColor,
                                                                          borderRadius:
                                                                              BorderRadius.only(
                                                                            topLeft:
                                                                                Radius.circular(30),
                                                                            topRight:
                                                                                Radius.circular(30),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    );
                                                                    break;
                                                                  } else {
                                                                    onAddItem1(
                                                                      index,
                                                                      isItem(productDetailsController
                                                                          .productInfo
                                                                          ?.productData
                                                                          .productInfo[index]
                                                                          .attributeId),
                                                                      id1: productDetailsController
                                                                          .productInfo
                                                                          ?.productData
                                                                          .productInfo[index]
                                                                          .attributeId,
                                                                      price1: productDetailsController
                                                                          .productInfo
                                                                          ?.productData
                                                                          .productInfo[
                                                                              index]
                                                                          .normalPrice,
                                                                      strTitle1: productDetailsController
                                                                          .productInfo
                                                                          ?.productData
                                                                          .title,
                                                                      isRequride1: productDetailsController
                                                                          .productInfo
                                                                          ?.productData
                                                                          .productInfo[
                                                                              index]
                                                                          .subscriptionRequired,
                                                                      per1: productDetailsController
                                                                          .productInfo
                                                                          ?.productData
                                                                          .productInfo[
                                                                              index]
                                                                          .productDiscount,
                                                                      storeId1: storeDataContoller
                                                                          .storeDataInfo
                                                                          ?.storeInfo
                                                                          .storeId,
                                                                      sPrice1: productDetailsController
                                                                          .productInfo
                                                                          ?.productData
                                                                          .productInfo[
                                                                              index]
                                                                          .subscribePrice,
                                                                      img1: productDetailsController
                                                                          .productInfo
                                                                          ?.productData
                                                                          .img[0],
                                                                      productTitle1: productDetailsController
                                                                          .productInfo
                                                                          ?.productData
                                                                          .productInfo[
                                                                              index]
                                                                          .title,
                                                                      productId: productDetailsController
                                                                          .productInfo
                                                                          ?.productData
                                                                          .id,
                                                                    );
                                                                    break;
                                                                  }
                                                                } else {
                                                                  onAddItem1(
                                                                    index,
                                                                    isItem(productDetailsController
                                                                        .productInfo
                                                                        ?.productData
                                                                        .productInfo[
                                                                            index]
                                                                        .attributeId),
                                                                    id1: productDetailsController
                                                                        .productInfo
                                                                        ?.productData
                                                                        .productInfo[
                                                                            index]
                                                                        .attributeId,
                                                                    price1: productDetailsController
                                                                        .productInfo
                                                                        ?.productData
                                                                        .productInfo[
                                                                            index]
                                                                        .normalPrice,
                                                                    strTitle1: productDetailsController
                                                                        .productInfo
                                                                        ?.productData
                                                                        .title,
                                                                    isRequride1: productDetailsController
                                                                        .productInfo
                                                                        ?.productData
                                                                        .productInfo[
                                                                            index]
                                                                        .subscriptionRequired,
                                                                    per1: productDetailsController
                                                                        .productInfo
                                                                        ?.productData
                                                                        .productInfo[
                                                                            index]
                                                                        .productDiscount,
                                                                    storeId1: storeDataContoller
                                                                        .storeDataInfo
                                                                        ?.storeInfo
                                                                        .storeId,
                                                                    sPrice1: productDetailsController
                                                                        .productInfo
                                                                        ?.productData
                                                                        .productInfo[
                                                                            index]
                                                                        .subscribePrice,
                                                                    img1: productDetailsController
                                                                        .productInfo
                                                                        ?.productData
                                                                        .img[0],
                                                                    productTitle1: productDetailsController
                                                                        .productInfo
                                                                        ?.productData
                                                                        .productInfo[
                                                                            index]
                                                                        .title,
                                                                    productId: productDetailsController
                                                                        .productInfo
                                                                        ?.productData
                                                                        .id,
                                                                  );
                                                                  break;
                                                                }
                                                              }
                                                            } else {
                                                              onAddItem1(
                                                                index,
                                                                isItem(productDetailsController
                                                                    .productInfo
                                                                    ?.productData
                                                                    .productInfo[
                                                                        index]
                                                                    .attributeId),
                                                                id1: productDetailsController
                                                                    .productInfo
                                                                    ?.productData
                                                                    .productInfo[
                                                                        index]
                                                                    .attributeId,
                                                                price1: productDetailsController
                                                                    .productInfo
                                                                    ?.productData
                                                                    .productInfo[
                                                                        index]
                                                                    .normalPrice,
                                                                strTitle1: productDetailsController
                                                                    .productInfo
                                                                    ?.productData
                                                                    .title,
                                                                isRequride1: productDetailsController
                                                                    .productInfo
                                                                    ?.productData
                                                                    .productInfo[
                                                                        index]
                                                                    .subscriptionRequired,
                                                                per1: productDetailsController
                                                                    .productInfo
                                                                    ?.productData
                                                                    .productInfo[
                                                                        index]
                                                                    .productDiscount,
                                                                storeId1: storeDataContoller
                                                                    .storeDataInfo
                                                                    ?.storeInfo
                                                                    .storeId,
                                                                sPrice1: productDetailsController
                                                                    .productInfo
                                                                    ?.productData
                                                                    .productInfo[
                                                                        index]
                                                                    .subscribePrice,
                                                                img1: productDetailsController
                                                                    .productInfo
                                                                    ?.productData
                                                                    .img[0],
                                                                productTitle1: productDetailsController
                                                                    .productInfo
                                                                    ?.productData
                                                                    .productInfo[
                                                                        index]
                                                                    .title,
                                                                productId: productDetailsController
                                                                    .productInfo
                                                                    ?.productData
                                                                    .id,
                                                              );
                                                            }
                                                          });
                                                        },
                                                        child: Container(
                                                          height: 30,
                                                          width: 70,
                                                          margin:
                                                              EdgeInsets.all(5),
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                            "ADD".tr,
                                                            style: TextStyle(
                                                              color: gradient
                                                                  .defoultColor,
                                                              fontFamily:
                                                                  FontFamily
                                                                      .gilroyBold,
                                                              fontSize: 13,
                                                            ),
                                                          ),
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            color: WhiteColor,
                                                            border: Border.all(
                                                                color: Colors
                                                                    .grey
                                                                    .shade300),
                                                          ),
                                                        ),
                                                      )
                                                : Container(
                                                    height: 27,
                                                    width: 80,
                                                    margin: EdgeInsets.all(5),
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      "Out of stock".tr,
                                                      style: TextStyle(
                                                        color: RedColor,
                                                        fontFamily: FontFamily
                                                            .gilroyMedium,
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      color: WhiteColor,
                                                      border: Border.all(
                                                          color: RedColor),
                                                    ),
                                                  ),
                                          ),
                                          productDetailsController
                                                      .productInfo
                                                      ?.productData
                                                      .productInfo[index]
                                                      .productDiscount !=
                                                  "0"
                                              ? Positioned(
                                                  top: 5,
                                                  left: 20,
                                                  right: 20,
                                                  child: Container(
                                                    height: 15,
                                                    width: 40,
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      "${productDetailsController.productInfo?.productData.productInfo[index].productDiscount}% OFF",
                                                      style: TextStyle(
                                                        fontFamily: FontFamily
                                                            .gilroyMedium,
                                                        color: WhiteColor,
                                                        fontSize: 11,
                                                      ),
                                                    ),
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        image: AssetImage(
                                                          "assets/selectUnitLable.png",
                                                        ),
                                                        fit: BoxFit.fill,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : SizedBox(),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Text(
                                    "Description".tr,
                                    style: TextStyle(
                                      fontFamily: FontFamily.gilroyBold,
                                      fontSize: 15,
                                      color: BlackColor,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: ReadMoreText(
                                    productDetailsController.productInfo
                                            ?.productData.productDescription ??
                                        "",
                                    trimLines: 2,
                                    trimMode: TrimMode.Line,
                                    trimCollapsedText: 'Show more',
                                    trimExpandedText: 'Show less',
                                    moreStyle: TextStyle(
                                      fontFamily: FontFamily.gilroyBold,
                                      fontSize: 14,
                                      color: gradient.defoultColor,
                                    ),
                                    lessStyle: TextStyle(
                                      fontFamily: FontFamily.gilroyBold,
                                      fontSize: 14,
                                      color: gradient.defoultColor,
                                    ),
                                    style: TextStyle(
                                      fontFamily: FontFamily.gilroyMedium,
                                      fontSize: 12,
                                      color: BlackColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Center(
                          child: CircularProgressIndicator(
                            color: gradient.defoultColor,
                          ),
                        );
                }),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerTop,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
            );
          });
        });
  }

  GetPincodeMOdel? pincodeModel;
  getPincode() async {
    var headers = {'Cookie': 'PHPSESSID=2e52c6c6ae034c09e153a350223dcab2'};
    var request = http.Request(
        'POST',
        Uri.parse(
            'https://ittavi.developmentalphawizz.com/user_api/d_pincode.php'));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var finalResponse = await response.stream.bytesToString();
      final jsonResponse = GetPincodeMOdel.fromJson(json.decode(finalResponse));
      print('____dsdsfds______${finalResponse}_________');
      for (int i = 0; i < jsonResponse.deliverylist!.length; i++) {
        print("${jsonResponse.deliverylist![i].id}");
        // category_id = jsonResponse.data?[i].id ?? "";
      }
      setState(() {
        pincodeModel = jsonResponse;
        selectedPinCode = pincodeModel?.deliverylist?.firstWhere((item) {
          if( item.id ==pincodeModel?.deliverylist?[0].id){
            print("+++++++++++++++++++"+"${item.id}");
            return true;
          }
          return false;
        });
        storeDataContoller.getStoreData(storeId: '13', pincode: 5);
        setState(() {
        });
      });
    } else {
      print(response.reasonPhrase);
    }
  }

  dynamic selectedPinCode;
  var pincodeId;
  List<String> pinCodes = ['1234', '5678', '9876', '4321'];

  final TextEditingController searchCitycn = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return exit(0);
      },
      child: Scaffold(
        backgroundColor: bgcolor,
        body: SafeArea(
          child: RefreshIndicator(
            color: gradient.defoultColor,
            onRefresh: () {
              return Future.delayed(
                Duration(seconds: 2),
                () {
                  homePageController.getHomeDataApi();
                },
              );
            },
            child: CustomScrollView(
              controller: scrollController,
              slivers: [
                SliverAppBar(
                  backgroundColor: WhiteColor,
                  elevation: 0,
                  expandedHeight: 180,
                  floating: true,
                  automaticallyImplyLeading: false,
                  flexibleSpace: FlexibleSpaceBar(
                    background: SizedBox(
                      height: 230,
                      width: Get.width,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${"Hello".tr},",
                                      style: TextStyle(
                                        fontFamily: FontFamily.gilroyBold,
                                        color: BlackColor,
                                        fontSize: 14,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      name,
                                      style: TextStyle(
                                        fontFamily: FontFamily.gilroyBold,
                                        color: BlackColor,
                                        fontSize: 20,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    // Text(
                                    //   address,
                                    //   maxLines: 1,
                                    //   style: TextStyle(
                                    //     fontFamily: FontFamily.gilroyMedium,
                                    //     color: BlackColor,
                                    //     fontSize: 12,
                                    //     overflow: TextOverflow.ellipsis,
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  notificationController.getNotificationData();
                                  Get.toNamed(Routes.notificationScreen);
                                },
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  child: Image.asset(
                                    "assets/Notification.png",
                                    height: 20,
                                    width: 20,
                                  ),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              InkWell(
                                onTap: () {
                                  Get.toNamed(Routes.profileScreen);
                                },
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  child: Image.asset(
                                    "assets/Profile.png",
                                    height: 20,
                                    width: 20,
                                  ),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // Container(
                          //   height: 50,
                          //   width: MediaQuery.of(context).size.width/1.1,
                          //   child: Card(
                          //     elevation: 2,
                          //     child: Padding(
                          //       padding: const EdgeInsets.all(10),
                          //       child: DropdownButton<dynamic>(
                          //         isExpanded: true,
                          //         hint: const Text(
                          //           'Select Pincode',
                          //           style: TextStyle(
                          //               color: Colors.black54,
                          //               fontWeight: FontWeight.w500,
                          //               fontSize: 15),
                          //         ),
                          //         // dropdownColor: colors.primary,
                          //         value: selectedPinCode,
                          //         icon: const Padding(
                          //           padding: EdgeInsets.only(left: 10.0, top: 0),
                          //           child: Icon(
                          //             Icons.keyboard_arrow_down_rounded,
                          //             color: Colors.grey,
                          //             size: 25,
                          //           ),
                          //         ),
                          //         // elevation: 16,
                          //         style: const TextStyle(
                          //             color: Colors.black54,
                          //             fontWeight: FontWeight.bold),
                          //         underline: Padding(
                          //           padding: const EdgeInsets.only(left: 0, right: 0),
                          //           child: Container(
                          //             // height: 2,
                          //             color: Colors.white,
                          //           ),
                          //         ),
                          //         onChanged: (dynamic value)  {
                          //           setState(() {
                          //             selectedPinCode = value!;
                          //             pincodeId = value.id.toString();
                          //             print("===============${pincodeId}===========");
                          //             // getCatModel!.data!.forEach((element) {
                          //             //   if (element.cName == value) {
                          //             //     selectedSateIndex = getCatModel!.data!.indexOf(element);
                          //             //     category_Id = element.id;
                          //             //     serviceId = element.serviceType;
                          //             //     print("select category id is $category_Id");
                          //             //     getSubCategory(category_Id!, serviceId);
                          //             //   }
                          //             // });
                          //           });
                          //           storeDataContoller.getStoreData(
                          //             storeId: '13', pincode: pincodeId
                          //           );
                          //         },
                          //         items: pincodeModel?.deliverylist?.map((items) {
                          //           return DropdownMenuItem(
                          //             value: items,
                          //             child: Column(
                          //               crossAxisAlignment: CrossAxisAlignment.start,
                          //               mainAxisAlignment: MainAxisAlignment.center,
                          //               children: [
                          //                 Padding(
                          //                   padding: const EdgeInsets.only(top: 0),
                          //                   child: Container(
                          //                     width: MediaQuery.of(context).size.width/1.42,
                          //                     child: Padding(
                          //                       padding: const EdgeInsets.only(top: 0),
                          //                       child: Text(
                          //                         items.pincode.toString(),
                          //                         overflow: TextOverflow.ellipsis,
                          //                         style: const TextStyle(color: Colors.black54),
                          //                       ),
                          //                     ),
                          //                   ),
                          //                 ),
                          //               ],
                          //             ),
                          //           );
                          //         }).toList(),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Card(
                              elevation: 2,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 0,
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 4,
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton2<dynamic>(
                                      isExpanded: true,
                                      hint: Text(
                                        'Select Pincode',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Theme.of(context).hintColor,
                                        ),
                                      ),
                                      items: pincodeModel?.deliverylist
                                          ?.map((item) => DropdownMenuItem<dynamic>(
                                                value: item,
                                                child: Text(
                                                  item.pincode ?? "",
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ))
                                          .toList(),
                                      iconStyleData: IconStyleData(
                                        icon: Icon(
                                          Icons.keyboard_arrow_down_outlined,
                                          color: Color(0xff5D8231),
                                        ),
                                      ),
                                      value: selectedPinCode,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedPinCode = value;
                                          pincodeId = value.id.toString();
                                        });
                                        storeDataContoller.getStoreData(
                                            storeId: '13', pincode: pincodeId);
                                      },
                                      dropdownSearchData: DropdownSearchData(
                                        searchController: searchCitycn,
                                        searchInnerWidgetHeight: 50,
                                        searchInnerWidget: Container(
                                          height: 50,
                                          padding: const EdgeInsets.only(
                                            top: 8,
                                            bottom: 4,
                                            right: 8,
                                            left: 8,
                                          ),
                                          child: TextFormField(
                                            expands: true,
                                            maxLines: null,
                                            controller: searchCitycn,
                                            decoration: InputDecoration(
                                              isDense: true,
                                              contentPadding: const EdgeInsets.symmetric(
                                                horizontal: 10,
                                                vertical: 8,
                                              ),
                                              hintText: 'Search Pincode Here',
                                              hintStyle: const TextStyle(fontSize: 12),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                            ),
                                          ),
                                        ),
                                        searchMatchFn: (item, searchValue) {
                                          return item.value.toString().toLowerCase().contains(searchValue.toLowerCase());
                                        },
                                      ),
                                      //This to clear the search value when you close the menu
                                      onMenuStateChange: (isOpen) {
                                        if (!isOpen) {
                                          searchCitycn.clear();
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 9,
                          ),
                          InkWell(
                            onTap: () async {
                              Get.toNamed(Routes.homeSearchScreen, arguments: {
                                "statusWiseSearch": true,
                              });
                            },
                            child: Container(
                              height: 45,
                              width: Get.size.width,
                              margin: EdgeInsets.symmetric(horizontal: 15),
                              alignment: Alignment.center,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Image.asset(
                                    "assets/Search.png",
                                    height: 18,
                                    width: 18,
                                    color: Color(0xFF636268),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "Search for Product".tr,
                                    style: TextStyle(
                                      color: greyColor,
                                      fontFamily: FontFamily.gilroyMedium,
                                    ),
                                  )
                                ],
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: GetBuilder<HomePageController>(builder: (context) {
                    return
                        // homePageController.isLoading
                        //     ?
                        Column(
                      children: [
                        Container(
                          color: WhiteColor,
                          // padding: EdgeInsets.symmetric(horizontal: 0),
                          child: Column(
                            children: [
                              SizedBox(
                                // height: 190,
                                // width: 500,
                                child: CarouselSlider(
                                  options: CarouselOptions(
                                    aspectRatio: 2.0,
                                    enlargeCenterPage: true,
                                    scrollDirection: Axis.horizontal,
                                    autoPlay: true,
                                    onPageChanged: (index, reason) {
                                      setState(() {
                                        selectIndex = index;
                                      });
                                    },
                                  ),
                                  items: homePageController.bannerList
                                      .map(
                                        (item) => Container(
                                          width: Get.size.width,
                                          margin: EdgeInsets.symmetric(
                                            vertical: 5,
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: FadeInImage.assetNetwork(
                                              fadeInCurve: Curves.easeInCirc,
                                              placeholder: "assets/ezgif.com-crop.gif",
                                              placeholderCacheHeight: 210,
                                              placeholderFit: BoxFit.fill,
                                              // placeholderScale: 1.0,
                                              image: item, fit: BoxFit.cover,
                                            ),
                                          ),
                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
                                        ),
                                      ).toList(),
                                ),
                              ),
                              SizedBox(
                                height: 25,
                                width: Get.size.width,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ...List.generate(homePageController.homeInfo?.homeData.banlist.length ?? 0, (index) {
                                      return Indicator(
                                        isActive: selectIndex == index ? true : false,
                                      );
                                    }),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              // Row(
                              //   children: [
                              //     Expanded(
                              //       child: Container(
                              //         height: 70,
                              //         child: Column(
                              //           mainAxisAlignment:
                              //               MainAxisAlignment.center,
                              //           children: [
                              //             Row(
                              //               mainAxisAlignment:
                              //                   MainAxisAlignment.center,
                              //               crossAxisAlignment:
                              //                   CrossAxisAlignment.center,
                              //               children: [
                              //                 Image.asset(
                              //                   img[0],
                              //                   height: 18,
                              //                   width: 18,
                              //                 ),
                              //                 SizedBox(
                              //                   width: 3,
                              //                 ),
                              //                 Text(
                              //                   storeDataContoller.storeDataInfo?.storeInfo.storeRate ??"",
                              //                   style: TextStyle(
                              //                     fontFamily:
                              //                         FontFamily.gilroyMedium,
                              //                     fontSize: 14,
                              //                   ),
                              //                 ),
                              //               ],
                              //             ),
                              //             SizedBox(
                              //               height: 3,
                              //             ),
                              //             Text(
                              //               "Rating".tr,
                              //               style: TextStyle(
                              //                 fontFamily:
                              //                     FontFamily.gilroyMedium,
                              //                 fontSize: 13,
                              //               ),
                              //             )
                              //           ],
                              //         ),
                              //       ),
                              //     ),
                              //     SizedBox(
                              //       height: 70,
                              //       child: VerticalDivider(
                              //         color: Colors.grey.shade200,
                              //         endIndent: 15,
                              //         width: 2,
                              //         indent: 15,
                              //         thickness: 1,
                              //       ),
                              //     ),
                              //     // Expanded(
                              //     //   child: Container(
                              //     //     height: 70,
                              //     //     width: Get.size.width,
                              //     //     child: Column(
                              //     //       mainAxisAlignment:
                              //     //       MainAxisAlignment.center,
                              //     //       children: [
                              //     //         // Row(
                              //     //         //   mainAxisAlignment:
                              //     //         //   MainAxisAlignment.center,
                              //     //         //   crossAxisAlignment:
                              //     //         //   CrossAxisAlignment.center,
                              //     //         //   children: [
                              //     //         //     Image.asset(
                              //     //         //       img[1],
                              //     //         //       height: 18,
                              //     //         //       width: 18,
                              //     //         //     ),
                              //     //         //     SizedBox(
                              //     //         //       width: 1,
                              //     //         //     ),
                              //     //         //     // SizedBox(
                              //     //         //     //   width: Get.size.width * 0.15,
                              //     //         //     //   child: Text(
                              //     //         //     //     "${storeDataContoller.storeDataInfo?.storeInfo.restDistance.split(" ").first ?? ""}Km",
                              //     //         //     //     maxLines: 1,
                              //     //         //     //     textAlign: TextAlign.center,
                              //     //         //     //     style: TextStyle(
                              //     //         //     //       fontFamily: FontFamily
                              //     //         //     //           .gilroyMedium,
                              //     //         //     //       fontSize: 13,
                              //     //         //     //       overflow:
                              //     //         //     //       TextOverflow.ellipsis,
                              //     //         //     //     ),
                              //     //         //     //   ),
                              //     //         //     // ),
                              //     //         //   ],
                              //     //         // ),
                              //     //         // SizedBox(
                              //     //         //   height: 3,
                              //     //         // ),
                              //     //         // Text(
                              //     //         //   "Distance".tr,
                              //     //         //   style: TextStyle(
                              //     //         //     fontFamily:
                              //     //         //     FontFamily.gilroyMedium,
                              //     //         //     fontSize: 13,
                              //     //         //   ),
                              //     //         // )
                              //     //       ],
                              //     //     ),
                              //     //   ),
                              //     // ),
                              //     // SizedBox(
                              //     //   height: 70,
                              //     //   child: VerticalDivider(
                              //     //     color: Colors.grey.shade200,
                              //     //     endIndent: 15,
                              //     //     width: 2,
                              //     //     indent: 15,
                              //     //     thickness: 1,
                              //     //   ),
                              //     // ),
                              //     Expanded(
                              //       child: Container(
                              //         height: 70,
                              //         child: Column(
                              //           mainAxisAlignment:
                              //               MainAxisAlignment.center,
                              //           children: [
                              //             Row(
                              //               mainAxisAlignment:
                              //                   MainAxisAlignment.center,
                              //               crossAxisAlignment:
                              //                   CrossAxisAlignment.center,
                              //               children: [
                              //                 Image.asset(
                              //                   img[2],
                              //                   height: 18,
                              //                   width: 18,
                              //                 ),
                              //                 SizedBox(
                              //                   width: 3,
                              //                 ),
                              //                 Text(
                              //                   "Time".tr,
                              //                   maxLines: 1,
                              //                   style: TextStyle(
                              //                     fontFamily:
                              //                         FontFamily.gilroyMedium,
                              //                     fontSize: 13,
                              //                     overflow:
                              //                         TextOverflow.ellipsis,
                              //                   ),
                              //                 ),
                              //               ],
                              //             ),
                              //             SizedBox(
                              //               height: 3,
                              //             ),
                              //             // Text(
                              //             //   "${DateFormat.jm().format(DateTime.parse("2023-03-20T${storeDataContoller.storeDataInfo?.storeInfo.storeOpentime}")).toString().split(":").first}AM - ${DateFormat.jm().format(DateTime.parse("2023-03-20T${storeDataContoller.storeDataInfo?.storeInfo.storeClosetime}")).toString().split(":").first}PM",
                              //             //   style: TextStyle(
                              //             //     fontFamily:
                              //             //     FontFamily.gilroyMedium,
                              //             //     fontSize: 13,
                              //             //   ),
                              //             // ),
                              //           ],
                              //         ),
                              //       ),
                              //     ),
                              //     SizedBox(
                              //       height: 70,
                              //       child: VerticalDivider(
                              //         color: Colors.grey.shade200,
                              //         endIndent: 15,
                              //         width: 2,
                              //         indent: 15,
                              //         thickness: 1,
                              //       ),
                              //     ),
                              //     Expanded(
                              //       child: Container(
                              //         height: 70,
                              //         child: Column(
                              //           mainAxisAlignment:
                              //               MainAxisAlignment.center,
                              //           children: [
                              //             Row(
                              //               mainAxisAlignment:
                              //                   MainAxisAlignment.center,
                              //               crossAxisAlignment:
                              //                   CrossAxisAlignment.center,
                              //               children: [
                              //                 Image.asset(
                              //                   img[3],
                              //                   height: 18,
                              //                   width: 18,
                              //                 ),
                              //                 SizedBox(
                              //                   width: 3,
                              //                 ),
                              //                 Text(
                              //                   storeDataContoller.storeDataInfo?.storeInfo.totalFav.toString() ?? "",
                              //                   maxLines: 1,
                              //                   style: TextStyle(
                              //                     fontFamily: FontFamily.gilroyMedium,
                              //                     fontSize: 13,
                              //                     overflow:
                              //                         TextOverflow.ellipsis,
                              //                   ),
                              //                 ),
                              //               ],
                              //             ),
                              //             SizedBox(
                              //               height: 3,
                              //             ),
                              //             Text(
                              //               "Likes".tr,
                              //               style: TextStyle(
                              //                 fontFamily:
                              //                     FontFamily.gilroyMedium,
                              //                 fontSize: 13,
                              //               ),
                              //             )
                              //           ],
                              //         ),
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              SizedBox(
                                height: 0,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  height: 50,
                                  width: Get.size.width,
                                  child: ListView.builder(
                                    itemCount: storeDataContoller.storeDataInfo?.catwiseproduct.length ?? 0,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      return storeDataContoller.storeDataInfo?.catwiseproduct[index].productdata.isNotEmpty ?? true
                                          ? InkWell(
                                              onTap: () {
                                                scrollController.animateTo(
                                                  index * 450,
                                                  curve: Curves.easeOut,
                                                  duration: const Duration(milliseconds: 300),
                                                );
                                              },
                                              child: Container(
                                                height: 50,
                                                margin: EdgeInsets.all(5),
                                                alignment: Alignment.center,
                                                padding: EdgeInsets.only(left: 10, right: 15),
                                                child: Row(
                                                  children: [
                                                    storeDataContoller.storeDataInfo?.catwiseproduct[index].img != ""
                                                        ? Container(
                                                            height: 30,
                                                            width: 30,
                                                            child: ClipRRect(
                                                              borderRadius: BorderRadius.circular(30),
                                                              child: FadeInImage.assetNetwork(
                                                                placeholder: "assets/ezgif.com-crop.gif",
                                                                placeholderCacheHeight: 30,
                                                                placeholderCacheWidth: 30,
                                                                placeholderFit: BoxFit.cover,
                                                                image: "${Config.imageUrl}${storeDataContoller.storeDataInfo?.catwiseproduct[index].img}",
                                                                height: 30,
                                                                width: 30,
                                                                fit: BoxFit.cover,
                                                              ),
                                                            ),
                                                            decoration: BoxDecoration(
                                                              shape: BoxShape.circle,
                                                            ),
                                                          )
                                                        : SizedBox(),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          storeDataContoller.storeDataInfo?.catwiseproduct[index].catTitle ?? "",
                                                          style: TextStyle(
                                                            fontFamily: FontFamily.gilroyBold,
                                                            fontSize: 13,
                                                          ),
                                                        ),
                                                        Text(
                                                          "${storeDataContoller.storeDataInfo?.catwiseproduct[index].productdata.length.toString()} items",
                                                          style: TextStyle(
                                                            fontFamily: FontFamily.gilroyMedium,
                                                            color: greytext,
                                                            fontSize: 10,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  color: WhiteColor,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey.shade300,
                                                      offset: const Offset(
                                                        0.3,
                                                        0.3,
                                                      ),
                                                      blurRadius: 0.3,
                                                      spreadRadius: 0.3,
                                                    ), //BoxShadow
                                                    BoxShadow(
                                                      color: Colors.white,
                                                      offset: const Offset(0.0, 0.0),
                                                      blurRadius: 0.0,
                                                      spreadRadius: 0.0,
                                                    ), //BoxShadow
                                                  ],
                                                ),
                                              ),
                                            )
                                          : SizedBox();
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  color: WhiteColor,
                                  child: ListView.builder(
                                    itemCount: storeDataContoller.storeDataInfo?.catwiseproduct.length ?? 0,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.zero,
                                    itemBuilder: (context, index1) {
                                      return storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata.isNotEmpty ?? true
                                          ? Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  storeDataContoller.storeDataInfo?.catwiseproduct[index1].catTitle ?? "",
                                                  style: TextStyle(
                                                    color: BlackColor,
                                                    fontFamily:
                                                        FontFamily.gilroyBold,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                GridView.builder(
                                                  itemCount: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata.length,
                                                  shrinkWrap: true,
                                                  padding: EdgeInsets.zero,
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  gridDelegate:
                                                      SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 2,
                                                    mainAxisSpacing: 8,
                                                    crossAxisSpacing: 8,
                                                    mainAxisExtent: 250,
                                                  ),
                                                  itemBuilder: (context, index) {
                                                    double price = 10.00;
                                                    // double price = (double.parse(storeDataContoller
                                                    //     .storeDataInfo
                                                    //     ?.catwiseproduct[
                                                    // index1]
                                                    //     .productdata[
                                                    // index]
                                                    //     .productInfo[
                                                    // 0]
                                                    //     .normalPrice ??
                                                    //     "") *
                                                    //     double.parse(storeDataContoller
                                                    //         .storeDataInfo
                                                    //         ?.catwiseproduct[
                                                    //     index1]
                                                    //         .productdata[
                                                    //     index]
                                                    //         .productInfo[
                                                    //     0]
                                                    //         .productDiscount ??
                                                    //         "")) /
                                                    //     100;
                                                    return Stack(
                                                      clipBehavior: Clip.none,
                                                      children: [
                                                        Container(
                                                          margin: EdgeInsets.all(1),
                                                          alignment: Alignment.center,
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              SizedBox(
                                                                height: 5,
                                                              ),
                                                              InkWell(
                                                                onTap: () {
                                                                  productDetailsController.getProductDetailsApi(
                                                                    pId: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productId,
                                                                  );
                                                                  detailsSheet(storeDataContoller.storeDataInfo?.storeInfo.storeShortDesc ?? "");
                                                                },
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment.start,
                                                                  children: [
                                                                    InkWell(
                                                                      onTap: () {
                                                                        productDetailsController.getProductDetailsApi(
                                                                          pId: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productId,
                                                                        );
                                                                        detailsSheet(storeDataContoller.storeDataInfo?.storeInfo.storeShortDesc ?? "");
                                                                      },
                                                                      child:
                                                                          Center(
                                                                        child: Container(
                                                                          height: 125,
                                                                          width: Get.size.width *0.35,
                                                                          child: ClipRRect(
                                                                            borderRadius: BorderRadius.circular(12),
                                                                            child: FadeInImage.assetNetwork(
                                                                              fadeInCurve: Curves.easeInCirc,
                                                                              placeholder: "assets/ezgif.com-crop.gif",
                                                                              placeholderCacheHeight: 125,
                                                                              placeholderCacheWidth: 125,
                                                                              height: 125,
                                                                              width: 125,
                                                                              placeholderFit: BoxFit.fill,
                                                                              image: "${Config.imageUrl}${storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productImg}",
                                                                              fit: BoxFit.cover,
                                                                            ),
                                                                          ),
                                                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height: 5,
                                                                    ),
                                                                    Padding(
                                                                      padding: EdgeInsets.symmetric(horizontal: 8),
                                                                      child: Text(
                                                                        storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productTitle ?? "",
                                                                        maxLines: 2,
                                                                        style: TextStyle(
                                                                          fontFamily: FontFamily.gilroyBold,
                                                                          fontSize: 12,
                                                                          overflow: TextOverflow.ellipsis,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height: 4,
                                                                    ),
                                                                    storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].productSubscripitionDiscount != "0" ?
                                                                    Padding(
                                                                      padding: EdgeInsets.symmetric(horizontal: 8),
                                                                      child: Row(
                                                                        children: [
                                                                          Text("Subscripition Discount:",  style: TextStyle(
                                                                            fontFamily: FontFamily.gilroyBold,
                                                                            fontSize: 12,
                                                                            overflow: TextOverflow.ellipsis,
                                                                          ),),
                                                                          SizedBox(width: 2,),
                                                                          Text(
                                                                            storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].productSubscripitionDiscount ?? "",
                                                                            maxLines: 2,
                                                                            style: TextStyle(
                                                                              fontFamily: FontFamily.gilroyBold,
                                                                              fontSize: 12,
                                                                              overflow: TextOverflow.ellipsis,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ): SizedBox(),
                                                                    Padding(
                                                                      padding: EdgeInsets
                                                                          .symmetric(
                                                                              horizontal:
                                                                                  8),
                                                                      child:
                                                                          InkWell(
                                                                        onTap:
                                                                            () {
                                                                          productDetailsController.getProductDetailsApi(pId: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productId,
                                                                          );

                                                                          detailsSheet(storeDataContoller.storeDataInfo?.storeInfo.storeShortDesc ?? "");
                                                                        },
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            Flexible(
                                                                              child:
                                                                                  Text(storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].title ?? "",
                                                                                maxLines: 1,
                                                                                overflow: TextOverflow.ellipsis,
                                                                                style: TextStyle(
                                                                                  fontFamily: FontFamily.gilroyMedium,
                                                                                  fontSize: 12,
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                  color: gradient.defoultColor,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              width:
                                                                                  4,
                                                                            ),
                                                                            // 1 < storeDataContoller.storeDataInfo!.catwiseproduct[index1].productdata[index].productInfo.length
                                                                            //     ?
                                                                            // Image.asset(
                                                                            //   "assets/angle-down.png",
                                                                            //   height:
                                                                            //       10,
                                                                            //   width:
                                                                            //       10,
                                                                            //   color:
                                                                            //       gradient.defoultColor,
                                                                            // )
                                                                            // : SizedBox()
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Container(
                                                                height: 70,
                                                                alignment: Alignment
                                                                    .bottomCenter,
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    storeDataContoller
                                                                                .storeDataInfo
                                                                                ?.catwiseproduct[index1]
                                                                                .productdata[index]
                                                                                .productInfo[0]
                                                                                .productOutStock ==
                                                                            "0"
                                                                        ? Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.end,
                                                                            children: [
                                                                              storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].subscriptionRequired != "0"
                                                                                  ? isSubscibe(storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].attributeId.toString()) != "0"
                                                                                      ? InkWell(
                                                                                          onTap: () {
                                                                                            print("!!!!!!!!!!!!!!!!!!!!");
                                                                                            productDetailsController.getProductDetailsApi(pId: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productId,
                                                                                            );
                                                                                            Get.toNamed(Routes.subScribeScreen, arguments: {
                                                                                              "img": storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productImg,
                                                                                              "name": storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productTitle,
                                                                                              "sprice": storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].subscribePrice,
                                                                                              "aprice": storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].normalPrice,
                                                                                              "per": storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].productDiscount,
                                                                                              "attributeId": storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].attributeId,
                                                                                              "productTitle": storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].title,
                                                                                              "isEmpty": "0",
                                                                                              "productId": storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productId,
                                                                                              "product_subscripition_discount": storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[index].productDiscount,
                                                                                            });
                                                                                            // }
                                                                                          },
                                                                                          child: Container(
                                                                                            height: 25,
                                                                                            padding: EdgeInsets.symmetric(horizontal: 8),
                                                                                            alignment: Alignment.center,
                                                                                            child: Text(
                                                                                              "SUBSCRIBED".tr,
                                                                                              style: TextStyle(
                                                                                                color: gradient.defoultColor,
                                                                                                fontFamily: FontFamily.gilroyBold,
                                                                                                fontSize: 11,
                                                                                              ),
                                                                                            ),
                                                                                            decoration: BoxDecoration(
                                                                                              borderRadius: BorderRadius.circular(5),
                                                                                              border: Border.all(color: Colors.grey.shade300),
                                                                                            ),
                                                                                          ),
                                                                                        )
                                                                                      : InkWell(
                                                                                          onTap: () {
                                                                                            print("!!!!!!!!!!!!!!!!!!!!");
                                                                                            productDetailsController.getProductDetailsApi(
                                                                                              pId: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productId,
                                                                                            );
                                                                                            Get.toNamed(Routes.subScribeScreen, arguments: {
                                                                                              "img": storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productImg,
                                                                                              "name": storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productTitle,
                                                                                              "sprice": storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].subscribePrice,
                                                                                              "aprice": storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].normalPrice,
                                                                                              "per": storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].productDiscount,
                                                                                              "attributeId": storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].attributeId,
                                                                                              "productTitle": storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].title,
                                                                                              "isEmpty": "0",
                                                                                              "productId": storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productId,
                                                                                              "product_subscripition_discount": storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[index].productSubscripitionDiscount,
                                                                                            });
                                                                                            // }
                                                                                          },
                                                                                          child: Container(
                                                                                            height: 25,
                                                                                            padding: EdgeInsets.symmetric(horizontal: 8),
                                                                                            alignment: Alignment.center,
                                                                                            child: Text(
                                                                                              "SUBSCRIBE".tr,
                                                                                              style: TextStyle(
                                                                                                color: gradient.defoultColor,
                                                                                                fontFamily: FontFamily.gilroyBold,
                                                                                                fontSize: 11,
                                                                                              ),
                                                                                            ),
                                                                                            decoration: BoxDecoration(
                                                                                              borderRadius: BorderRadius.circular(5),
                                                                                              border: Border.all(color: Colors.grey.shade300),
                                                                                            ),
                                                                                          ),
                                                                                        )
                                                                                  : SizedBox(),
                                                                              SizedBox(
                                                                                width: 5,
                                                                              ),
                                                                            ],
                                                                          )
                                                                        : SizedBox(),
                                                                    //! ------------ Add Product Widget -------------!//
                                                                    Row(
                                                                      children: [
                                                                        SizedBox(
                                                                          width:
                                                                              8,
                                                                        ),
                                                                        Column(
                                                                          children: [
                                                                            Text(
                                                                              "${currency}${double.parse(storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo.first.normalPrice ?? "")-(double.parse(storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo.first.normalPrice ?? "")*double.parse(storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo.first.productDiscount ?? "")/100)}",
                                                                              // "500/-",
                                                                              maxLines: 1,
                                                                              style: TextStyle(
                                                                                fontFamily: FontFamily.gilroyBold,
                                                                                fontSize: 13,
                                                                              ),
                                                                            ),
                                                                            storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].productDiscount != "0"
                                                                                ? Text(
                                                                                    "${currency}${storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].normalPrice ?? ""}",
                                                                                    maxLines: 1,
                                                                                    style: TextStyle(
                                                                                      color: greyColor,
                                                                                      fontFamily: FontFamily.gilroyMedium,
                                                                                      decoration: TextDecoration.lineThrough,
                                                                                      fontSize: 11,
                                                                                    ),
                                                                                  ) : SizedBox(),
                                                                          ],
                                                                        ),
                                                                        Spacer(),
                                                                        storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].productOutStock == "0"
                                                                            ? isItem(storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].attributeId.toString()) != "0"
                                                                                ? isSubscibe(storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].attributeId.toString()) != "1"
                                                                                    ? Container(
                                                                                        height: 25,
                                                                                        width: 80,
                                                                                        margin: EdgeInsets.all(5),
                                                                                        alignment: Alignment.center,
                                                                                        child: Row(
                                                                                          children: [
                                                                                            SizedBox(
                                                                                              width: 5,
                                                                                            ),
                                                                                            InkWell(
                                                                                              onTap: () {
                                                                                                setState(() {
                                                                                                  onRemoveItem(
                                                                                                    index,
                                                                                                    isItem(storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].attributeId.toString()),
                                                                                                    id1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].attributeId ?? "",
                                                                                                    price1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].normalPrice ?? "",
                                                                                                  );
                                                                                                });
                                                                                              },
                                                                                              child: Container(
                                                                                                height: 30,
                                                                                                width: 15,
                                                                                                alignment: Alignment.center,
                                                                                                child: Icon(
                                                                                                  Icons.remove,
                                                                                                  color: gradient.defoultColor,
                                                                                                  size: 15,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                            Expanded(
                                                                                              child: Container(
                                                                                                alignment: Alignment.center,
                                                                                                child: Text(
                                                                                                  isItem(storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].attributeId).toString(),
                                                                                                  style: TextStyle(
                                                                                                    color: gradient.defoultColor,
                                                                                                    fontFamily: FontFamily.gilroyBold,
                                                                                                    fontSize: 12,
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                            InkWell(
                                                                                              onTap: () {

                                                                                                for (var element in cart.values) {
                                                                                                  if (element.storeID == storeDataContoller.storeDataInfo?.storeInfo.storeId) {
                                                                                                    if (element.cartCheck == "1") {
                                                                                                      Get.bottomSheet(
                                                                                                        Container(
                                                                                                          height: 200,
                                                                                                          width: Get.size.width,
                                                                                                          child: Column(
                                                                                                            children: [
                                                                                                              SizedBox(
                                                                                                                height: 15,
                                                                                                              ),
                                                                                                              Padding(
                                                                                                                padding: EdgeInsets.only(top: 5, left: 15, right: 15),
                                                                                                                child: Text(
                                                                                                                  "Would you like to empty your cart and add new items, or do you want to keep the current items in your cart?".tr,
                                                                                                                  style: TextStyle(
                                                                                                                    fontFamily: FontFamily.gilroyMedium,
                                                                                                                    fontSize: 16,
                                                                                                                    height: 1.2,
                                                                                                                    letterSpacing: 1,
                                                                                                                    color: BlackColor,
                                                                                                                  ),
                                                                                                                ),
                                                                                                              ),
                                                                                                              SizedBox(
                                                                                                                height: 10,
                                                                                                              ),
                                                                                                              Padding(
                                                                                                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                                                                                                child: Divider(
                                                                                                                  color: Colors.grey,
                                                                                                                ),
                                                                                                              ),
                                                                                                              Spacer(),
                                                                                                              Row(
                                                                                                                children: [
                                                                                                                  Expanded(
                                                                                                                    child: InkWell(
                                                                                                                      onTap: () {
                                                                                                                        Get.back();
                                                                                                                      },
                                                                                                                      child: Container(
                                                                                                                        height: 40,
                                                                                                                        width: Get.size.width,
                                                                                                                        alignment: Alignment.center,
                                                                                                                        margin: EdgeInsets.symmetric(horizontal: 10),
                                                                                                                        child: Text(
                                                                                                                          "No".tr,
                                                                                                                          style: TextStyle(
                                                                                                                            fontFamily: FontFamily.gilroyBold,
                                                                                                                            color: gradient.defoultColor,
                                                                                                                            fontSize: 16,
                                                                                                                          ),
                                                                                                                        ),
                                                                                                                        decoration: BoxDecoration(
                                                                                                                          color: gradient.defoultColor.withOpacity(0.1),
                                                                                                                          borderRadius: BorderRadius.circular(25),
                                                                                                                        ),
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                  Expanded(
                                                                                                                    child: InkWell(
                                                                                                                      onTap: () {
                                                                                                                        for (var element in cart.values) {
                                                                                                                          if (element.storeID == storeDataContoller.storeDataInfo?.storeInfo.storeId) {
                                                                                                                            if (element.cartCheck == "1") {
                                                                                                                              cart.delete(element.id);
                                                                                                                              catDetailsController.getCartLangth();
                                                                                                                              setState(() {});
                                                                                                                            }
                                                                                                                          }
                                                                                                                        }
                                                                                                                        onAddItem(
                                                                                                                          index,
                                                                                                                          isItem(storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].attributeId),
                                                                                                                          id1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].attributeId ?? "",
                                                                                                                          price1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].normalPrice ?? "",
                                                                                                                          strTitle1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productTitle,
                                                                                                                          isRequride1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].subscriptionRequired ?? "",
                                                                                                                          per1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].productDiscount.toString() ?? "",
                                                                                                                          storeId1: storeDataContoller.storeDataInfo?.storeInfo.storeId,
                                                                                                                          sPrice1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].subscribePrice ?? "",
                                                                                                                          img1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productImg,
                                                                                                                          productTitle1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].title,
                                                                                                                          productId: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productId,
                                                                                                                        );
                                                                                                                        Get.back();
                                                                                                                      },
                                                                                                                      child: Container(
                                                                                                                        height: 40,
                                                                                                                        width: Get.size.width,
                                                                                                                        alignment: Alignment.center,
                                                                                                                        margin: EdgeInsets.symmetric(horizontal: 10),
                                                                                                                        child: Text(
                                                                                                                          "Clear Cart".tr,
                                                                                                                          style: TextStyle(
                                                                                                                            fontFamily: FontFamily.gilroyBold,
                                                                                                                            color: WhiteColor,
                                                                                                                            fontSize: 16,
                                                                                                                          ),
                                                                                                                        ),
                                                                                                                        decoration: BoxDecoration(
                                                                                                                          gradient: gradient.btnGradient,
                                                                                                                          borderRadius: BorderRadius.circular(25),
                                                                                                                        ),
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                ],
                                                                                                              ),
                                                                                                              SizedBox(
                                                                                                                height: 20,
                                                                                                              ),
                                                                                                            ],
                                                                                                          ),
                                                                                                          decoration: BoxDecoration(
                                                                                                            color: WhiteColor,
                                                                                                            borderRadius: BorderRadius.only(
                                                                                                              topLeft: Radius.circular(30),
                                                                                                              topRight: Radius.circular(30),
                                                                                                            ),
                                                                                                          ),
                                                                                                        ),
                                                                                                      );
                                                                                                      break;
                                                                                                    } else {
                                                                                                      setState(() {
                                                                                                        onAddItem(
                                                                                                          index,
                                                                                                          isItem(storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].attributeId),
                                                                                                          id1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].attributeId ?? "",
                                                                                                          price1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].normalPrice ?? "",
                                                                                                          strTitle1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productTitle,
                                                                                                          isRequride1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].subscriptionRequired ?? "",
                                                                                                          per1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].productDiscount.toString() ?? "",
                                                                                                          storeId1: storeDataContoller.storeDataInfo?.storeInfo.storeId,
                                                                                                          sPrice1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].subscribePrice ?? "",
                                                                                                          img1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productImg,
                                                                                                          productTitle1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].title,
                                                                                                          productId: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productId,
                                                                                                        );
                                                                                                      });
                                                                                                      break;
                                                                                                    }
                                                                                                  }
                                                                                                }
                                                                                              },
                                                                                              child: Container(
                                                                                                height: 30,
                                                                                                width: 15,
                                                                                                alignment: Alignment.center,
                                                                                                child: Icon(
                                                                                                  Icons.add,
                                                                                                  color: gradient.defoultColor,
                                                                                                  size: 15,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                            SizedBox(
                                                                                              width: 5,
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                        decoration: BoxDecoration(
                                                                                          borderRadius: BorderRadius.circular(5),
                                                                                          border: Border.all(color: Colors.grey.shade300),
                                                                                        ),
                                                                                      )
                                                                                    : InkWell(
                                                                                        onTap: () {
                                                                                          print(".-.-.-.-.-.-.-.-.-.-.-.-.-.--.--->>" + cart.values.length.toString());
                                                                                          setState(() {
                                                                                            if (cart.values.isNotEmpty) {
                                                                                              for (var element in cart.values) {
                                                                                                if (element.storeID == storeDataContoller.storeDataInfo?.storeInfo.storeId) {
                                                                                                  if (element.cartCheck == "1") {
                                                                                                    Get.bottomSheet(
                                                                                                      Container(
                                                                                                        height: 200,
                                                                                                        width: Get.size.width,
                                                                                                        child: Column(
                                                                                                          children: [
                                                                                                            SizedBox(
                                                                                                              height: 15,
                                                                                                            ),
                                                                                                            Padding(
                                                                                                              padding: EdgeInsets.only(top: 5, left: 15, right: 15),
                                                                                                              child: Text(
                                                                                                                "Would you like to empty your cart and add new items, or do you want to keep the current items in your cart?".tr,
                                                                                                                style: TextStyle(
                                                                                                                  fontFamily: FontFamily.gilroyMedium,
                                                                                                                  fontSize: 16,
                                                                                                                  height: 1.2,
                                                                                                                  letterSpacing: 1,
                                                                                                                  color: BlackColor,
                                                                                                                ),
                                                                                                              ),
                                                                                                            ),
                                                                                                            SizedBox(
                                                                                                              height: 10,
                                                                                                            ),
                                                                                                            Padding(
                                                                                                              padding: const EdgeInsets.symmetric(horizontal: 15),
                                                                                                              child: Divider(
                                                                                                                color: Colors.grey,
                                                                                                              ),
                                                                                                            ),
                                                                                                            Spacer(),
                                                                                                            Row(
                                                                                                              children: [
                                                                                                                Expanded(
                                                                                                                  child: InkWell(
                                                                                                                    onTap: () {
                                                                                                                      Get.back();
                                                                                                                    },
                                                                                                                    child: Container(
                                                                                                                      height: 40,
                                                                                                                      width: Get.size.width,
                                                                                                                      alignment: Alignment.center,
                                                                                                                      margin: EdgeInsets.symmetric(horizontal: 10),
                                                                                                                      child: Text(
                                                                                                                        "No".tr,
                                                                                                                        style: TextStyle(
                                                                                                                          fontFamily: FontFamily.gilroyBold,
                                                                                                                          color: gradient.defoultColor,
                                                                                                                          fontSize: 16,
                                                                                                                        ),
                                                                                                                      ),
                                                                                                                      decoration: BoxDecoration(
                                                                                                                        color: gradient.defoultColor.withOpacity(0.1),
                                                                                                                        borderRadius: BorderRadius.circular(25),
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                ),
                                                                                                                Expanded(
                                                                                                                  child: InkWell(
                                                                                                                    onTap: () {
                                                                                                                      for (var element in cart.values) {
                                                                                                                        if (element.storeID == storeDataContoller.storeDataInfo?.storeInfo.storeId) {
                                                                                                                          if (element.cartCheck == "1") {
                                                                                                                            cart.delete(element.id);
                                                                                                                            catDetailsController.getCartLangth();
                                                                                                                            setState(() {});
                                                                                                                          }
                                                                                                                        }
                                                                                                                      }
                                                                                                                      onAddItem(
                                                                                                                        index,
                                                                                                                        isItem(storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].attributeId),
                                                                                                                        id1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].attributeId ?? "",
                                                                                                                        price1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].normalPrice ?? "",
                                                                                                                        strTitle1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productTitle,
                                                                                                                        isRequride1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].subscriptionRequired ?? "",
                                                                                                                        per1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].productDiscount.toString() ?? "",
                                                                                                                        storeId1: storeDataContoller.storeDataInfo?.storeInfo.storeId,
                                                                                                                        sPrice1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].subscribePrice ?? "",
                                                                                                                        img1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productImg,
                                                                                                                        productTitle1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].title,
                                                                                                                        productId: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productId,
                                                                                                                      );
                                                                                                                      Get.back();
                                                                                                                    },
                                                                                                                    child: Container(
                                                                                                                      height: 40,
                                                                                                                      width: Get.size.width,
                                                                                                                      alignment: Alignment.center,
                                                                                                                      margin: EdgeInsets.symmetric(horizontal: 10),
                                                                                                                      child: Text(
                                                                                                                        "Clear Cart".tr,
                                                                                                                        style: TextStyle(
                                                                                                                          fontFamily: FontFamily.gilroyBold,
                                                                                                                          color: WhiteColor,
                                                                                                                          fontSize: 16,
                                                                                                                        ),
                                                                                                                      ),
                                                                                                                      decoration: BoxDecoration(
                                                                                                                        gradient: gradient.btnGradient,
                                                                                                                        borderRadius: BorderRadius.circular(25),
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                ),
                                                                                                              ],
                                                                                                            ),
                                                                                                            SizedBox(
                                                                                                              height: 20,
                                                                                                            ),
                                                                                                          ],
                                                                                                        ),
                                                                                                        decoration: BoxDecoration(
                                                                                                          color: WhiteColor,
                                                                                                          borderRadius: BorderRadius.only(
                                                                                                            topLeft: Radius.circular(30),
                                                                                                            topRight: Radius.circular(30),
                                                                                                          ),
                                                                                                        ),
                                                                                                      ),
                                                                                                    );
                                                                                                    break;
                                                                                                  } else {
                                                                                                    onAddItem(
                                                                                                      index,
                                                                                                      isItem(storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].attributeId),
                                                                                                      id1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].attributeId ?? "",
                                                                                                      price1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].normalPrice ?? "",
                                                                                                      strTitle1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productTitle,
                                                                                                      isRequride1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].subscriptionRequired ?? "",
                                                                                                      per1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].productDiscount.toString() ?? "",
                                                                                                      storeId1: storeDataContoller.storeDataInfo?.storeInfo.storeId,
                                                                                                      sPrice1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].subscribePrice ?? "",
                                                                                                      img1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productImg,
                                                                                                      productTitle1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].title,
                                                                                                      productId: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productId,
                                                                                                    );
                                                                                                    break;
                                                                                                  }
                                                                                                }
                                                                                              }
                                                                                            } else {
                                                                                              onAddItem(
                                                                                                index,
                                                                                                isItem(storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].attributeId),
                                                                                                id1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].attributeId ?? "",
                                                                                                price1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].normalPrice ?? "",
                                                                                                strTitle1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productTitle,
                                                                                                isRequride1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].subscriptionRequired ?? "",
                                                                                                per1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].productDiscount.toString() ?? "",
                                                                                                storeId1: storeDataContoller.storeDataInfo?.storeInfo.storeId,
                                                                                                sPrice1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].subscribePrice ?? "",
                                                                                                img1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productImg,
                                                                                                productTitle1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].title,
                                                                                                productId: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productId,
                                                                                              );
                                                                                            }
                                                                                          });
                                                                                        },
                                                                                        child: Container(
                                                                                          height: 25,
                                                                                          width: 80,
                                                                                          margin: EdgeInsets.all(5),
                                                                                          alignment: Alignment.center,
                                                                                          child: Text(
                                                                                            "ADD".tr,
                                                                                            style: TextStyle(
                                                                                              color: gradient.defoultColor,
                                                                                              fontFamily: FontFamily.gilroyBold,
                                                                                              fontSize: 12,
                                                                                            ),
                                                                                          ),
                                                                                          decoration: BoxDecoration(
                                                                                            borderRadius: BorderRadius.circular(5),
                                                                                            border: Border.all(color: Colors.grey.shade300),
                                                                                          ),
                                                                                        ),
                                                                                      )
                                                                                : InkWell(
                                                                                    onTap: () {
                                                                                      print(".-.-.-.-.-.-.-.-.-.-.-.-.-.--.--->>" + cart.values.length.toString());
                                                                                      setState(() {
                                                                                        if (cart.values.isNotEmpty) {
                                                                                          print("-=-=-=-=-=-=-=-=-=---1");
                                                                                          for (var element in cart.values) {
                                                                                            print("-=-=-=-=-=-=-=-=-=---2");
                                                                                            print("**************" + element.storeID.toString());
                                                                                            print("**************" + storeDataContoller.storeDataInfo!.storeInfo.storeId.toString());
                                                                                            if (element.storeID == storeDataContoller.storeDataInfo?.storeInfo.storeId) {
                                                                                              if (element.cartCheck == "1") {
                                                                                                Get.bottomSheet(
                                                                                                  Container(
                                                                                                    height: 200,
                                                                                                    width: Get.size.width,
                                                                                                    child: Column(
                                                                                                      children: [
                                                                                                        SizedBox(
                                                                                                          height: 15,
                                                                                                        ),
                                                                                                        Padding(
                                                                                                          padding: EdgeInsets.only(top: 5, left: 15, right: 15),
                                                                                                          child: Text(
                                                                                                            "Would you like to empty your cart and add new items, or do you want to keep the current items in your cart?".tr,
                                                                                                            style: TextStyle(
                                                                                                              fontFamily: FontFamily.gilroyMedium,
                                                                                                              fontSize: 16,
                                                                                                              height: 1.2,
                                                                                                              letterSpacing: 1,
                                                                                                              color: BlackColor,
                                                                                                            ),
                                                                                                          ),
                                                                                                        ),
                                                                                                        SizedBox(
                                                                                                          height: 10,
                                                                                                        ),
                                                                                                        Padding(
                                                                                                          padding: const EdgeInsets.symmetric(horizontal: 15),
                                                                                                          child: Divider(
                                                                                                            color: Colors.grey,
                                                                                                          ),
                                                                                                        ),
                                                                                                        Spacer(),
                                                                                                        Row(
                                                                                                          children: [
                                                                                                            Expanded(
                                                                                                              child: InkWell(
                                                                                                                onTap: () {
                                                                                                                  Get.back();
                                                                                                                },
                                                                                                                child: Container(
                                                                                                                  height: 40,
                                                                                                                  width: Get.size.width,
                                                                                                                  alignment: Alignment.center,
                                                                                                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                                                                                                  child: Text(
                                                                                                                    "No".tr,
                                                                                                                    style: TextStyle(
                                                                                                                      fontFamily: FontFamily.gilroyBold,
                                                                                                                      color: gradient.defoultColor,
                                                                                                                      fontSize: 16,
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                  decoration: BoxDecoration(
                                                                                                                    color: gradient.defoultColor.withOpacity(0.1),
                                                                                                                    borderRadius: BorderRadius.circular(25),
                                                                                                                  ),
                                                                                                                ),
                                                                                                              ),
                                                                                                            ),
                                                                                                            Expanded(
                                                                                                              child: InkWell(
                                                                                                                onTap: () {
                                                                                                                  for (var element in cart.values) {
                                                                                                                    if (element.storeID == storeDataContoller.storeDataInfo?.storeInfo.storeId) {
                                                                                                                      if (element.cartCheck == "1") {
                                                                                                                        cart.delete(element.id);
                                                                                                                        catDetailsController.getCartLangth();
                                                                                                                        setState(() {});
                                                                                                                      }
                                                                                                                    }
                                                                                                                  }
                                                                                                                  onAddItem(
                                                                                                                    index,
                                                                                                                    isItem(storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].attributeId),
                                                                                                                    id1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].attributeId ?? "",
                                                                                                                    price1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].normalPrice ?? "",
                                                                                                                    strTitle1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productTitle,
                                                                                                                    isRequride1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].subscriptionRequired ?? "",
                                                                                                                    per1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].productDiscount.toString() ?? "",
                                                                                                                    storeId1: storeDataContoller.storeDataInfo?.storeInfo.storeId,
                                                                                                                    sPrice1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].subscribePrice ?? "",
                                                                                                                    img1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productImg,
                                                                                                                    productTitle1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].title,
                                                                                                                    productId: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productId,
                                                                                                                  );
                                                                                                                  Get.back();
                                                                                                                },
                                                                                                                child: Container(
                                                                                                                  height: 40,
                                                                                                                  width: Get.size.width,
                                                                                                                  alignment: Alignment.center,
                                                                                                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                                                                                                  child: Text(
                                                                                                                    "Clear Cart".tr,
                                                                                                                    style: TextStyle(
                                                                                                                      fontFamily: FontFamily.gilroyBold,
                                                                                                                      color: WhiteColor,
                                                                                                                      fontSize: 16,
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                  decoration: BoxDecoration(
                                                                                                                    gradient: gradient.btnGradient,
                                                                                                                    borderRadius: BorderRadius.circular(25),
                                                                                                                  ),
                                                                                                                ),
                                                                                                              ),
                                                                                                            ),
                                                                                                          ],
                                                                                                        ),
                                                                                                        SizedBox(
                                                                                                          height: 20,
                                                                                                        ),
                                                                                                      ],
                                                                                                    ),
                                                                                                    decoration: BoxDecoration(
                                                                                                      color: WhiteColor,
                                                                                                      borderRadius: BorderRadius.only(
                                                                                                        topLeft: Radius.circular(30),
                                                                                                        topRight: Radius.circular(30),
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                );
                                                                                                break;
                                                                                              } else {
                                                                                                print("-=-=-=-=-=-=-=-=-=---3");
                                                                                                onAddItem(
                                                                                                  index,
                                                                                                  isItem(storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].attributeId),
                                                                                                  id1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].attributeId ?? "",
                                                                                                  price1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].normalPrice ?? "",
                                                                                                  strTitle1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productTitle,
                                                                                                  isRequride1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].subscriptionRequired ?? "",
                                                                                                  per1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].productDiscount.toString() ?? "",
                                                                                                  storeId1: storeDataContoller.storeDataInfo?.storeInfo.storeId,
                                                                                                  sPrice1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].subscribePrice ?? "",
                                                                                                  img1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productImg,
                                                                                                  productTitle1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].title,
                                                                                                  productId: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productId,
                                                                                                );
                                                                                                break;
                                                                                              }
                                                                                            } else {
                                                                                              onAddItem(
                                                                                                index,
                                                                                                isItem(storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].attributeId),
                                                                                                id1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].attributeId ?? "",
                                                                                                price1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].normalPrice ?? "",
                                                                                                strTitle1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productTitle,
                                                                                                isRequride1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].subscriptionRequired ?? "",
                                                                                                per1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].productDiscount.toString() ?? "",
                                                                                                storeId1: storeDataContoller.storeDataInfo?.storeInfo.storeId,
                                                                                                sPrice1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].subscribePrice ?? "",
                                                                                                img1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productImg,
                                                                                                productTitle1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].title,
                                                                                                productId: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productId,
                                                                                              );
                                                                                              break;
                                                                                            }
                                                                                          }
                                                                                        } else {
                                                                                          print("-=-=-=-=-=-=-=-=-=---4");
                                                                                          onAddItem(
                                                                                            index,
                                                                                            isItem(storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].attributeId),
                                                                                            id1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].attributeId ?? "",
                                                                                            price1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].normalPrice ?? "",
                                                                                            strTitle1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productTitle,
                                                                                            isRequride1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].subscriptionRequired ?? "",
                                                                                            per1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].productDiscount.toString() ?? "",
                                                                                            storeId1: storeDataContoller.storeDataInfo?.storeInfo.storeId,
                                                                                            sPrice1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].subscribePrice ?? "",
                                                                                            img1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productImg,
                                                                                            productTitle1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].title,
                                                                                            productId: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productId,
                                                                                          );
                                                                                        }
                                                                                      });
                                                                                    },
                                                                                    child: Container(
                                                                                      height: 25,
                                                                                      width: 80,
                                                                                      margin: EdgeInsets.all(5),
                                                                                      alignment: Alignment.center,
                                                                                      child: Text(
                                                                                        "ADD".tr,
                                                                                        style: TextStyle(
                                                                                          color: gradient.defoultColor,
                                                                                          fontFamily: FontFamily.gilroyBold,
                                                                                          fontSize: 12,
                                                                                        ),
                                                                                      ),
                                                                                      decoration: BoxDecoration(
                                                                                        borderRadius: BorderRadius.circular(5),
                                                                                        border: Border.all(color: Colors.grey.shade300),
                                                                                      ),
                                                                                    ),
                                                                                  )
                                                                            : Container(
                                                                                height: 22,
                                                                                width: 90,
                                                                                margin: EdgeInsets.all(5),
                                                                                alignment: Alignment.center,
                                                                                child: Text(
                                                                                  "Out of stock",
                                                                                  style: TextStyle(
                                                                                    fontFamily: FontFamily.gilroyMedium,
                                                                                    fontSize: 12,
                                                                                    color: RedColor,
                                                                                  ),
                                                                                ),
                                                                                decoration: BoxDecoration(
                                                                                  border: Border.all(color: RedColor),
                                                                                  borderRadius: BorderRadius.circular(5),
                                                                                ),
                                                                              ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: WhiteColor,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(8),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Colors.grey
                                                                    .shade300,
                                                                offset:
                                                                    const Offset(
                                                                  0.3,
                                                                  0.3,
                                                                ),
                                                                blurRadius: 0.3,
                                                                spreadRadius: 0.3,
                                                              ), //BoxShadow
                                                              BoxShadow(
                                                                color:
                                                                    Colors.white,
                                                                offset:
                                                                    const Offset(
                                                                        0.0, 0.0),
                                                                blurRadius: 0.0,
                                                                spreadRadius: 0.0,
                                                              ), //BoxShadow
                                                            ],
                                                          ),
                                                        ),
                                                        storeDataContoller
                                                                    .storeDataInfo
                                                                    ?.catwiseproduct[
                                                                        index1]
                                                                    .productdata[
                                                                        index]
                                                                    .productInfo[
                                                                        0]
                                                                    .productDiscount !=
                                                                "0"
                                                            ? Positioned(
                                                                top: -5,
                                                                left: 4,
                                                                child: Container(
                                                                  height: 40,
                                                                  width: 40,
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child: Text(
                                                                    "${storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].productDiscount}%\nOFF",
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          FontFamily
                                                                              .gilroyMedium,
                                                                      color:
                                                                          WhiteColor,
                                                                      fontSize:
                                                                          11,
                                                                      height: 1.1,
                                                                    ),
                                                                  ),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    image:
                                                                        DecorationImage(
                                                                      image:
                                                                          AssetImage(
                                                                        "assets/lable1.png",
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                            : SizedBox(),
                                                      ],
                                                    );
                                                  },
                                                )
                                              ],
                                            )
                                          : SizedBox();
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              // Container(
                              //   alignment: Alignment.topLeft,
                              //   padding: EdgeInsets.only(left: 15),
                              //   child: Text(
                              //     "Fastest Delivery".tr,
                              //     style: TextStyle(
                              //       color: BlackColor,
                              //       fontFamily: FontFamily.gilroyExtraBold,
                              //       fontSize: 20,
                              //     ),
                              //   ),
                              // ),
                              // SizedBox(
                              //   height: 5,
                              // ),
                              // Container(
                              //   alignment: Alignment.topLeft,
                              //   padding: EdgeInsets.only(left: 15),
                              //   child: Text(
                              //     "When you need it most".tr,
                              //     style: TextStyle(
                              //       color: BlackColor,
                              //       fontFamily: FontFamily.gilroyMedium,
                              //       fontSize: 17,
                              //     ),
                              //   ),
                              // ),
                              // SizedBox(
                              //   height: 260,
                              //   width: Get.size.width,
                              //   child: homePageController.homeInfo?.homeData
                              //               .spotlightStore.isNotEmpty ??
                              //           true
                              //       ? ListView.builder(
                              //           itemCount: homePageController
                              //                   .homeInfo
                              //                   ?.homeData
                              //                   .spotlightStore
                              //                   .length ??
                              //               0,
                              //           scrollDirection: Axis.horizontal,
                              //           physics: BouncingScrollPhysics(),
                              //           itemBuilder: (context, index) {
                              //             return InkWell(
                              //               onTap: () async {
                              //                 catDetailsController.strId =
                              //                     homePageController
                              //                             .homeInfo
                              //                             ?.homeData
                              //                             .spotlightStore[index]
                              //                             .storeId ??
                              //                         "";
                              //                 await storeDataContoller
                              //                     .getStoreData(
                              //                   storeId: homePageController
                              //                       .homeInfo
                              //                       ?.homeData
                              //                       .spotlightStore[index]
                              //                       .storeId,
                              //                 );
                              //                 save("changeIndex", true);
                              //                 homePageController.isback = "1";
                              //                 Get.toNamed(
                              //                     Routes.bottombarProScreen);
                              //               },
                              //               child: Container(
                              //                 height: 270,
                              //                 width: 290,
                              //                 margin: EdgeInsets.all(10),
                              //                 decoration: BoxDecoration(
                              //                   border: Border.all(
                              //                       color:
                              //                           Colors.grey.shade300),
                              //                   borderRadius:
                              //                       BorderRadius.circular(20),
                              //                 ),
                              //                 child: Column(
                              //                   crossAxisAlignment:
                              //                       CrossAxisAlignment.start,
                              //                   children: [
                              //                     Stack(
                              //                       clipBehavior: Clip.none,
                              //                       children: [
                              //                         Container(
                              //                           height: 150,
                              //                           width: 290,
                              //                           child: ClipRRect(
                              //                             borderRadius:
                              //                                 BorderRadius.only(
                              //                               topLeft:
                              //                                   Radius.circular(
                              //                                       20),
                              //                               topRight:
                              //                                   Radius.circular(
                              //                                       20),
                              //                             ),
                              //                             child: FadeInImage
                              //                                 .assetNetwork(
                              //                               fadeInCurve: Curves
                              //                                   .easeInCirc,
                              //                               placeholder:
                              //                                   "assets/ezgif.com-crop.gif",
                              //                               placeholderCacheHeight:
                              //                                   240,
                              //                               placeholderCacheWidth:
                              //                                   290,
                              //                               placeholderFit:
                              //                                   BoxFit.fill,
                              //                               image:
                              //                                   "${Config.imageUrl}${homePageController.homeInfo?.homeData.spotlightStore[index].storeCover ?? ""}",
                              //                               fit: BoxFit.cover,
                              //                             ),
                              //                           ),
                              //                           decoration:
                              //                               BoxDecoration(
                              //                             borderRadius:
                              //                                 BorderRadius.only(
                              //                               topLeft:
                              //                                   Radius.circular(
                              //                                       20),
                              //                               topRight:
                              //                                   Radius.circular(
                              //                                       20),
                              //                             ),
                              //                           ),
                              //                         ),
                              //                         Positioned(
                              //                           bottom: -30,
                              //                           right: 5,
                              //                           child: Container(
                              //                             height: 55,
                              //                             width: 55,
                              //                             child: ClipRRect(
                              //                               borderRadius:
                              //                                   BorderRadius
                              //                                       .circular(
                              //                                           12),
                              //                               child:
                              //                                   Image.network(
                              //                                 "${Config.imageUrl}${homePageController.homeInfo?.homeData.spotlightStore[index].storeLogo ?? ""}",
                              //                                 fit: BoxFit.cover,
                              //                               ),
                              //                             ),
                              //                             decoration:
                              //                                 BoxDecoration(
                              //                               color: WhiteColor,
                              //                               borderRadius:
                              //                                   BorderRadius
                              //                                       .circular(
                              //                                           12),
                              //                               border: Border.all(
                              //                                   color: Colors
                              //                                       .grey
                              //                                       .shade300),
                              //                             ),
                              //                           ),
                              //                         ),
                              //                       ],
                              //                     ),
                              //                     SizedBox(
                              //                       height: 8,
                              //                     ),
                              //                     Padding(
                              //                       padding: const EdgeInsets
                              //                               .symmetric(
                              //                           horizontal: 10),
                              //                       child: SizedBox(
                              //                         width: Get.width * 0.44,
                              //                         child: Text(
                              //                           homePageController
                              //                                   .homeInfo
                              //                                   ?.homeData
                              //                                   .spotlightStore[
                              //                                       index]
                              //                                   .storeTitle ??
                              //                               "",
                              //                           maxLines: 1,
                              //                           style: TextStyle(
                              //                             color: BlackColor,
                              //                             fontFamily: FontFamily
                              //                                 .gilroyExtraBold,
                              //                             fontSize: 17,
                              //                             overflow: TextOverflow
                              //                                 .ellipsis,
                              //                           ),
                              //                         ),
                              //                       ),
                              //                     ),
                              //                     SizedBox(
                              //                       height: 5,
                              //                     ),
                              //                     Padding(
                              //                       padding: const EdgeInsets
                              //                               .symmetric(
                              //                           horizontal: 10),
                              //                       child: Text(
                              //                         homePageController
                              //                                 .homeInfo
                              //                                 ?.homeData
                              //                                 .spotlightStore[
                              //                                     index]
                              //                                 .storeSlogan ??
                              //                             "",
                              //                         maxLines: 1,
                              //                         style: TextStyle(
                              //                           color: BlackColor,
                              //                           fontFamily: FontFamily
                              //                               .gilroyMedium,
                              //                           fontSize: 15,
                              //                           overflow: TextOverflow
                              //                               .ellipsis,
                              //                         ),
                              //                       ),
                              //                     ),
                              //                     SizedBox(
                              //                       height: 10,
                              //                     ),
                              //                     Padding(
                              //                       padding: const EdgeInsets
                              //                               .symmetric(
                              //                           horizontal: 10),
                              //                       child: Row(
                              //                         children: [
                              //                           Image.asset(
                              //                             "assets/Location.png",
                              //                             height: 20,
                              //                             width: 20,
                              //                           ),
                              //                           SizedBox(
                              //                             width: 5,
                              //                           ),
                              //                           SizedBox(
                              //                             width:
                              //                                 Get.size.width *
                              //                                     0.3,
                              //                             child: Text(
                              //                               homePageController
                              //                                       .homeInfo
                              //                                       ?.homeData
                              //                                       .spotlightStore[
                              //                                           index]
                              //                                       .storeAddress ??
                              //                                   "",
                              //                               maxLines: 1,
                              //                               style: TextStyle(
                              //                                 fontFamily: FontFamily
                              //                                     .gilroyMedium,
                              //                                 color: BlackColor,
                              //                                 fontSize: 13,
                              //                                 overflow:
                              //                                     TextOverflow
                              //                                         .ellipsis,
                              //                               ),
                              //                             ),
                              //                           ),
                              //                           SizedBox(
                              //                             width: 10,
                              //                           ),
                              //                           Image.asset(
                              //                             "assets/Sport-mode.png",
                              //                             height: 18,
                              //                             width: 18,
                              //                           ),
                              //                           SizedBox(
                              //                             width: 5,
                              //                           ),
                              //                           Text(
                              //                             homePageController
                              //                                     .homeInfo
                              //                                     ?.homeData
                              //                                     .spotlightStore[
                              //                                         index]
                              //                                     .restDistance ??
                              //                                 "",
                              //                             maxLines: 1,
                              //                             style: TextStyle(
                              //                               fontFamily: FontFamily
                              //                                   .gilroyMedium,
                              //                               color: BlackColor,
                              //                               fontSize: 13,
                              //                               overflow:
                              //                                   TextOverflow
                              //                                       .ellipsis,
                              //                             ),
                              //                           ),
                              //                         ],
                              //                       ),
                              //                     )
                              //                   ],
                              //                 ),
                              //               ),
                              //             );
                              //           },
                              //         )
                              //       : Container(
                              //           height: 300,
                              //           width: Get.size.width,
                              //           alignment: Alignment.center,
                              //           child: Text(
                              //             "No store available \nin your area."
                              //                 .tr,
                              //             textAlign: TextAlign.center,
                              //             style: TextStyle(
                              //               fontFamily: FontFamily.gilroyBold,
                              //               fontSize: 15,
                              //               color: BlackColor,
                              //             ),
                              //           ),
                              //         ),
                              // ),
                            ],
                          ),
                        ),
                        // homePageController.homeInfo!.homeData.favlist.isNotEmpty
                        //     ? SizedBox(
                        //         height: 10,
                        //       )
                        //     : SizedBox(),
                        // homePageController
                        //         .homeInfo!.homeData.favlist.isNotEmpty
                        //     ?
                        // Container(
                        //         width: Get.size.width,
                        //         color: WhiteColor,
                        //         padding:
                        //             EdgeInsets.symmetric(horizontal: 10),
                        //         child: Column(
                        //           children: [
                        //             SizedBox(
                        //               height: 15,
                        //             ),
                        //             Container(
                        //               alignment: Alignment.topLeft,
                        //               padding: EdgeInsets.only(left: 15),
                        //               child: Text(
                        //                 "Your favorites".tr,
                        //                 style: TextStyle(
                        //                   color: BlackColor,
                        //                   fontFamily:
                        //                       FontFamily.gilroyExtraBold,
                        //                   fontSize: 20,
                        //                 ),
                        //               ),
                        //             ),
                        //             SizedBox(
                        //               height: 5,
                        //             ),
                        //             Container(
                        //               alignment: Alignment.topLeft,
                        //               padding: EdgeInsets.only(left: 15),
                        //               child: Row(
                        //                 children: [
                        //                   Text(
                        //                     "Milkman your love".tr,
                        //                     style: TextStyle(
                        //                       color: BlackColor,
                        //                       fontFamily:
                        //                           FontFamily.gilroyMedium,
                        //                       fontSize: 17,
                        //                     ),
                        //                   ),
                        //                   SizedBox(
                        //                     width: 3,
                        //                   ),
                        //                   Image.asset(
                        //                     "assets/heart.png",
                        //                     height: 18,
                        //                     width: 18,
                        //                     color: gradient.defoultColor,
                        //                   ),
                        //                 ],
                        //               ),
                        //             ),
                        //             SizedBox(
                        //               height: 150,
                        //               width: Get.size.width,
                        //               child: ListView.builder(
                        //                 itemCount: homePageController
                        //                     .homeInfo
                        //                     ?.homeData
                        //                     .favlist
                        //                     .length ?? 0,
                        //                 physics: BouncingScrollPhysics(),
                        //                 scrollDirection: Axis.horizontal,
                        //                 itemBuilder: (context, index) {
                        //                   return InkWell(
                        //                     onTap: () async {
                        //                       catDetailsController.strId =
                        //                           homePageController.homeInfo?.homeData.favlist[index].storeId ?? "";
                        //                       await storeDataContoller.getStoreData(
                        //                         storeId: homePageController.homeInfo?.homeData.favlist[index].storeId,
                        //                       );
                        //                       Get.toNamed(Routes
                        //                           .bottombarProScreen);
                        //                     },
                        //                     child: Column(
                        //                       children: [
                        //                         Container(
                        //                           height: 110,
                        //                           width: 90,
                        //                           margin:
                        //                               EdgeInsets.all(8),
                        //                           child: ClipRRect(
                        //                             borderRadius:
                        //                                 BorderRadius
                        //                                     .circular(15),
                        //                             child: FadeInImage
                        //                                 .assetNetwork(
                        //                               placeholderCacheHeight:
                        //                                   110,
                        //                               placeholderCacheWidth:
                        //                                   90,
                        //                               placeholderFit:
                        //                                   BoxFit.cover,
                        //                               placeholder:
                        //                                   "assets/ezgif.com-crop.gif",
                        //                               image:
                        //                                   "${Config.imageUrl}${homePageController.homeInfo?.homeData.favlist[index].storeCover ?? ""}",
                        //                               fit: BoxFit.cover,
                        //                             ),
                        //                           ),
                        //                           decoration:
                        //                               BoxDecoration(
                        //                             borderRadius:
                        //                                 BorderRadius
                        //                                     .circular(15),
                        //                             // image: DecorationImage(
                        //                             //   image: AssetImage(
                        //                             //       "assets/foodimg.jpg"),
                        //                             //   fit: BoxFit.cover,
                        //                             // ),
                        //                           ),
                        //                         ),
                        //                         SizedBox(
                        //                           width: 95,
                        //                           child: Text(
                        //                             homePageController
                        //                                     .homeInfo
                        //                                     ?.homeData
                        //                                     .favlist[
                        //                                         index]
                        //                                     .storeTitle ??
                        //                                 "",
                        //                             maxLines: 1,
                        //                             textAlign:
                        //                                 TextAlign.center,
                        //                             style: TextStyle(
                        //                               fontFamily: FontFamily
                        //                                   .gilroyMedium,
                        //                               overflow:
                        //                                   TextOverflow
                        //                                       .ellipsis,
                        //                               fontSize: 15,
                        //                               color: BlackColor,
                        //                             ),
                        //                           ),
                        //                         ),
                        //                       ],
                        //                     ),
                        //                   );
                        //                 },
                        //               ),
                        //             ),
                        //             SizedBox(
                        //               height: 8,
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        // : SizedBox(),
                        // SizedBox(
                        //   height: 10,
                        // ),
                        // Container(
                        //   color: WhiteColor,
                        //   padding: EdgeInsets.symmetric(horizontal: 10),
                        //   child: Column(
                        //     children: [
                        //       SizedBox(
                        //         height: 15,
                        //       ),
                        //       Container(
                        //         alignment: Alignment.topLeft,
                        //         padding: EdgeInsets.only(left: 15),
                        //         child: Text(
                        //           "Shop by category".tr,
                        //           style: TextStyle(
                        //             color: BlackColor,
                        //             fontFamily:
                        //                 FontFamily.gilroyExtraBold,
                        //             fontSize: 20,
                        //           ),
                        //         ),
                        //       ),
                        //       SizedBox(
                        //         height: 15,
                        //       ),
                        //       homePageController.homeInfo!.homeData
                        //               .catlist.isNotEmpty
                        //           ? Padding(
                        //               padding: const EdgeInsets.symmetric(
                        //                   horizontal: 10),
                        //               child: GridView.builder(
                        //                 itemCount: homePageController
                        //                     .homeInfo
                        //                     ?.homeData
                        //                     .catlist
                        //                     .length,
                        //                 shrinkWrap: true,
                        //                 physics:
                        //                     NeverScrollableScrollPhysics(),
                        //                 padding: EdgeInsets.zero,
                        //                 gridDelegate:
                        //                     SliverGridDelegateWithFixedCrossAxisCount(
                        //                   crossAxisCount: 4,
                        //                   mainAxisExtent: 130,
                        //                   crossAxisSpacing: 15,
                        //                   mainAxisSpacing: 3,
                        //                 ),
                        //                 itemBuilder: (context, index) {
                        //                   return InkWell(
                        //                     onTap: () async {
                        //                       await catDetailsController
                        //                           .getCatWiseData(
                        //                               catId: homePageController
                        //                                       .homeInfo
                        //                                       ?.homeData
                        //                                       .catlist[
                        //                                           index]
                        //                                       .id ??
                        //                                   "");
                        //                       Get.toNamed(
                        //                         Routes.categoryScreen,
                        //                         arguments: {
                        //                           "catName":
                        //                               homePageController
                        //                                       .homeInfo
                        //                                       ?.homeData
                        //                                       .catlist[
                        //                                           index]
                        //                                       .title ??
                        //                                   "",
                        //                           "catImag":
                        //                               homePageController
                        //                                       .homeInfo
                        //                                       ?.homeData
                        //                                       .catlist[
                        //                                           index]
                        //                                       .cover ??
                        //                                   "",
                        //                         },
                        //                       );
                        //                     },
                        //                     child: Column(
                        //                       children: [
                        //                         Container(
                        //                           height: 80,
                        //                           width: 70,
                        //                           child: ClipRRect(
                        //                             borderRadius:
                        //                                 BorderRadius
                        //                                     .circular(12),
                        //                             child: FadeInImage
                        //                                 .assetNetwork(
                        //                               fadeInCurve: Curves
                        //                                   .easeInCirc,
                        //                               placeholder:
                        //                                   "assets/ezgif.com-crop.gif",
                        //
                        //                               placeholderCacheHeight:
                        //                                   80,
                        //                               placeholderCacheWidth:
                        //                                   90,
                        //                               placeholderFit:
                        //                                   BoxFit.fill,
                        //                               // placeholderScale: 1.0,
                        //                               image:
                        //                                   "${Config.imageUrl}${homePageController.homeInfo?.homeData.catlist[index].img ?? ""}",
                        //                               // fit: BoxFit.cover,
                        //                             ),
                        //                           ),
                        //                           decoration:
                        //                               BoxDecoration(
                        //                             // color:
                        //                             //     Color(0xFFcfefe0),
                        //                             borderRadius:
                        //                                 BorderRadius
                        //                                     .circular(12),
                        //                           ),
                        //                         ),
                        //                         Container(
                        //                           height: 40,
                        //                           width: 100,
                        //                           alignment:
                        //                               Alignment.center,
                        //                           child: Text(
                        //                             homePageController
                        //                                     .homeInfo
                        //                                     ?.homeData
                        //                                     .catlist[
                        //                                         index]
                        //                                     .title ??
                        //                                 "",
                        //                             maxLines: 2,
                        //                             textAlign:
                        //                                 TextAlign.center,
                        //                             style: TextStyle(
                        //                               fontFamily: FontFamily
                        //                                   .gilroyMedium,
                        //                               overflow:
                        //                                   TextOverflow
                        //                                       .ellipsis,
                        //                             ),
                        //                           ),
                        //                         )
                        //                       ],
                        //                     ),
                        //                   );
                        //                 },
                        //               ),
                        //             )
                        //           : Container(
                        //               height: 200,
                        //               width: Get.size.width,
                        //               alignment: Alignment.center,
                        //               child: Text(
                        //                 "The category \nis unavailable in your area."
                        //                     .tr,
                        //                 textAlign: TextAlign.center,
                        //                 style: TextStyle(
                        //                   fontFamily:
                        //                       FontFamily.gilroyBold,
                        //                   fontSize: 15,
                        //                   color: BlackColor,
                        //                 ),
                        //               ),
                        //             ),
                        //       SizedBox(
                        //         height: 10,
                        //       ),
                        //       Container(
                        //         alignment: Alignment.topLeft,
                        //         padding: EdgeInsets.only(left: 15),
                        //         child: Text(
                        //           "Shop by store".tr,
                        //           style: TextStyle(
                        //             color: BlackColor,
                        //             fontFamily:
                        //                 FontFamily.gilroyExtraBold,
                        //             fontSize: 20,
                        //           ),
                        //         ),
                        //       ),
                        //       SizedBox(
                        //         height: 7,
                        //       ),
                        //       homePageController.homeInfo!.homeData
                        //               .topStore.isNotEmpty
                        //           ? ListView.builder(
                        //               itemCount: homePageController
                        //                   .homeInfo
                        //                   ?.homeData
                        //                   .topStore
                        //                   .length,
                        //               shrinkWrap: true,
                        //               physics:
                        //                   NeverScrollableScrollPhysics(),
                        //               itemBuilder: (context, index) {
                        //                 return InkWell(
                        //                   onTap: () async {
                        //                     catDetailsController.strId =
                        //                         homePageController
                        //                                 .homeInfo
                        //                                 ?.homeData
                        //                                 .topStore[index]
                        //                                 .storeId ??
                        //                             "";
                        //                     await storeDataContoller
                        //                         .getStoreData(
                        //                       storeId: homePageController
                        //                           .homeInfo
                        //                           ?.homeData
                        //                           .topStore[index]
                        //                           .storeId,
                        //                     );
                        //                     save("changeIndex", true);
                        //                     homePageController.isback =
                        //                         "1";
                        //                     Get.toNamed(Routes
                        //                         .bottombarProScreen);
                        //                   },
                        //                   child: Container(
                        //                     height: 180,
                        //                     width: Get.size.width,
                        //                     margin: EdgeInsets.all(10),
                        //                     child: Stack(
                        //                       clipBehavior: Clip.none,
                        //                       children: [
                        //                         Container(
                        //                           height: 180,
                        //                           width: Get.size.width,
                        //                           child: ClipRRect(
                        //                             borderRadius:
                        //                                 BorderRadius
                        //                                     .circular(15),
                        //                             child: FadeInImage
                        //                                 .assetNetwork(
                        //                               placeholder:
                        //                                   "assets/ezgif.com-crop.gif",
                        //                               placeholderCacheHeight:
                        //                                   180,
                        //                               placeholderFit:
                        //                                   BoxFit.fill,
                        //                               // placeholderScale: 1.0,
                        //                               image:
                        //                                   "${Config.imageUrl}${homePageController.homeInfo?.homeData.topStore[index].storeCover ?? ""}",
                        //                               fit: BoxFit.cover,
                        //                             ),
                        //                           ),
                        //                         ),
                        //                         Positioned(
                        //                           bottom: 0,
                        //                           right: 1,
                        //                           left: 1,
                        //                           child: Container(
                        //                             height: 65,
                        //                             width: Get.size.width,
                        //                             child: Padding(
                        //                               padding:
                        //                                   EdgeInsets.only(
                        //                                       left: 15,
                        //                                       right: 15),
                        //                               child: Row(
                        //                                 children: [
                        //                                   Container(
                        //                                     height: 45,
                        //                                     width: 45,
                        //                                     child:
                        //                                         ClipRRect(
                        //                                       borderRadius:
                        //                                           BorderRadius.circular(
                        //                                               30),
                        //                                       child: FadeInImage
                        //                                           .assetNetwork(
                        //                                         placeholder:
                        //                                             "assets/ezgif.com-crop.gif",
                        //                                         image:
                        //                                             "${Config.imageUrl}${homePageController.homeInfo?.homeData.topStore[index].storeLogo ?? ""}",
                        //                                       ),
                        //                                     ),
                        //                                     decoration:
                        //                                         BoxDecoration(
                        //                                       shape: BoxShape
                        //                                           .circle,
                        //                                       color: Color(
                        //                                               0xFF000000)
                        //                                           .withOpacity(
                        //                                               0.5),
                        //                                     ),
                        //                                   ),
                        //                                   SizedBox(
                        //                                     width: 8,
                        //                                   ),
                        //                                   Column(
                        //                                     crossAxisAlignment:
                        //                                         CrossAxisAlignment
                        //                                             .start,
                        //                                     children: [
                        //                                       SizedBox(
                        //                                         height:
                        //                                             10,
                        //                                       ),
                        //                                       SizedBox(
                        //                                         width: Get
                        //                                                 .size
                        //                                                 .width *
                        //                                             0.6,
                        //                                         child:
                        //                                             Text(
                        //                                           homePageController.homeInfo?.homeData.topStore[index].storeTitle ??
                        //                                               "",
                        //                                           maxLines:
                        //                                               1,
                        //                                           style:
                        //                                               TextStyle(
                        //                                             color:
                        //                                                 WhiteColor,
                        //                                             fontFamily:
                        //                                                 FontFamily.gilroyExtraBold,
                        //                                             fontSize:
                        //                                                 20,
                        //                                             overflow:
                        //                                                 TextOverflow.ellipsis,
                        //                                           ),
                        //                                         ),
                        //                                       ),
                        //                                       SizedBox(
                        //                                         height: 3,
                        //                                       ),
                        //                                       SizedBox(
                        //                                         width: Get
                        //                                                 .size
                        //                                                 .width *
                        //                                             0.63,
                        //                                         child:
                        //                                             Text(
                        //                                           homePageController.homeInfo?.homeData.topStore[index].storeSlogan ??
                        //                                               "",
                        //                                           maxLines:
                        //                                               1,
                        //                                           style:
                        //                                               TextStyle(
                        //                                             color:
                        //                                                 WhiteColor,
                        //                                             fontFamily:
                        //                                                 FontFamily.gilroyMedium,
                        //                                             fontSize:
                        //                                                 14,
                        //                                             overflow:
                        //                                                 TextOverflow.ellipsis,
                        //                                           ),
                        //                                         ),
                        //                                       ),
                        //                                     ],
                        //                                   ),
                        //                                 ],
                        //                               ),
                        //                             ),
                        //                             decoration:
                        //                                 BoxDecoration(
                        //                               borderRadius:
                        //                                   BorderRadius
                        //                                       .only(
                        //                                 bottomLeft: Radius
                        //                                     .circular(15),
                        //                                 bottomRight:
                        //                                     Radius
                        //                                         .circular(
                        //                                             15),
                        //                               ),
                        //                               image:
                        //                                   DecorationImage(
                        //                                 image: AssetImage(
                        //                                     "assets/Rectangle.png"),
                        //                                 fit: BoxFit.fill,
                        //                               ),
                        //                             ),
                        //                           ),
                        //                         ),
                        //                         homePageController
                        //                                         .homeInfo
                        //                                         ?.homeData
                        //                                         .topStore[
                        //                                             index]
                        //                                         .couponTitle !=
                        //                                     "0" &&
                        //                                 homePageController
                        //                                         .homeInfo
                        //                                         ?.homeData
                        //                                         .topStore[
                        //                                             index]
                        //                                         .couponTitle !=
                        //                                     ""
                        //                             ? Positioned(
                        //                                 top: -10,
                        //                                 left: -11,
                        //                                 child: Container(
                        //                                   height: 35,
                        //                                   width: 80,
                        //                                   alignment:
                        //                                       Alignment
                        //                                           .center,
                        //                                   padding: EdgeInsets
                        //                                       .only(
                        //                                           bottom:
                        //                                               4),
                        //                                   child: Text(
                        //                                     homePageController
                        //                                             .homeInfo
                        //                                             ?.homeData
                        //                                             .topStore[
                        //                                                 index]
                        //                                             .couponTitle ??
                        //                                         "",
                        //                                     style:
                        //                                         TextStyle(
                        //                                       fontFamily:
                        //                                           FontFamily
                        //                                               .gilroyMedium,
                        //                                       color:
                        //                                           WhiteColor,
                        //                                       fontSize:
                        //                                           12,
                        //                                     ),
                        //                                   ),
                        //                                   decoration:
                        //                                       BoxDecoration(
                        //                                     image:
                        //                                         DecorationImage(
                        //                                       image: AssetImage(
                        //                                           "assets/topstorelable.png"),
                        //                                       fit: BoxFit
                        //                                           .fill,
                        //                                     ),
                        //                                   ),
                        //                                 ),
                        //                               )
                        //                             : SizedBox(),
                        //                         Positioned(
                        //                           top: 10,
                        //                           right: 10,
                        //                           child: Container(
                        //                             height: 25,
                        //                             padding: EdgeInsets
                        //                                 .symmetric(
                        //                                     horizontal:
                        //                                         8),
                        //                             alignment:
                        //                                 Alignment.center,
                        //                             child: Row(
                        //                               mainAxisAlignment:
                        //                                   MainAxisAlignment
                        //                                       .center,
                        //                               crossAxisAlignment:
                        //                                   CrossAxisAlignment
                        //                                       .center,
                        //                               children: [
                        //                                 Image.asset(
                        //                                   "assets/ic_star_review.png",
                        //                                   height: 15,
                        //                                   width: 15,
                        //                                 ),
                        //                                 SizedBox(
                        //                                   width: 4,
                        //                                 ),
                        //                                 Text(
                        //                                   homePageController
                        //                                           .homeInfo
                        //                                           ?.homeData
                        //                                           .topStore[
                        //                                               index]
                        //                                           .storeRate ??
                        //                                       "",
                        //                                   style:
                        //                                       TextStyle(
                        //                                     fontFamily:
                        //                                         FontFamily
                        //                                             .gilroyMedium,
                        //                                     fontSize: 13,
                        //                                     color:
                        //                                         WhiteColor,
                        //                                   ),
                        //                                 ),
                        //                               ],
                        //                             ),
                        //                             decoration:
                        //                                 BoxDecoration(
                        //                               color: Color(
                        //                                       0xFF000000)
                        //                                   .withOpacity(
                        //                                       0.5),
                        //                               borderRadius:
                        //                                   BorderRadius
                        //                                       .circular(
                        //                                           20),
                        //                             ),
                        //                           ),
                        //                         ),
                        //                       ],
                        //                     ),
                        //                     decoration: BoxDecoration(
                        //                       color: WhiteColor,
                        //                       borderRadius:
                        //                           BorderRadius.circular(
                        //                               15),
                        //                       boxShadow: [
                        //                         BoxShadow(
                        //                           color: Colors
                        //                               .grey.shade300,
                        //                           offset: const Offset(
                        //                             0.5,
                        //                             0.5,
                        //                           ),
                        //                           blurRadius: 0.5,
                        //                           spreadRadius: 0.5,
                        //                         ), //BoxShadow
                        //                         BoxShadow(
                        //                           color: Colors.white,
                        //                           offset: const Offset(
                        //                               0.0, 0.0),
                        //                           blurRadius: 0.0,
                        //                           spreadRadius: 0.0,
                        //                         ), //BoxShadow
                        //                       ],
                        //                     ),
                        //                   ),
                        //                 );
                        //               },
                        //             )
                        //           : Container(
                        //               height: 200,
                        //               width: Get.size.width,
                        //               alignment: Alignment.center,
                        //               child: Text(
                        //                 "No store available \nin your area."
                        //                     .tr,
                        //                 textAlign: TextAlign.center,
                        //                 style: TextStyle(
                        //                   fontFamily:
                        //                       FontFamily.gilroyBold,
                        //                   fontSize: 15,
                        //                   color: BlackColor,
                        //                 ),
                        //               ),
                        //             ),
                        //     ],
                        //   ),
                        // ),
                      ],
                    );
                    // : SizedBox(
                    //     height: Get.size.height,
                    //     width: Get.size.width,
                    //     child: Center(
                    //       child: CircularProgressIndicator(
                    //         color: gradient.defoultColor,
                    //       ),
                    //     ),
                    //   );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // final List<Widget> imageSliders = homePageController
  //                                             .homeInfo!.homeData.banlist .map((item) => Container(
  //         child: Container(
  //           margin: EdgeInsets.all(5.0),
  //           child: ClipRRect(
  //               borderRadius: BorderRadius.all(Radius.circular(5.0)),
  //               child: Image.network("${item}", fit: BoxFit.cover, width: 1000.0),),
  //         ),
  //       ))
  //   .toList();
}

class Indicator extends StatelessWidget {
  final bool isActive;
  const Indicator({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Container(
        height: isActive ? 9 : 6,
        width: isActive ? 9 : 6,
        decoration: BoxDecoration(
          color: isActive ? Color(0xFF36393D) : Color(0xFFB3B2B7),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
