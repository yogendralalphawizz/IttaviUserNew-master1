// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables, unused_field, sized_box_for_whitespace, prefer_final_fields, no_leading_underscores_for_local_identifiers, deprecated_member_use, avoid_print, prefer_interpolation_to_compose_strings, unnecessary_brace_in_string_interps, unused_local_variable, must_be_immutable, prefer_if_null_operators, unused_element, non_constant_identifier_names, unnecessary_new

import 'dart:io';
import 'dart:math';

import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:milkman/Api/config.dart';
import 'package:milkman/Api/data_store.dart';
import 'package:milkman/controller/cart_controller.dart';
import 'package:milkman/controller/catdetails_controller.dart';
import 'package:milkman/controller/home_controller.dart';
import 'package:milkman/controller/subscription_controller.dart';
import 'package:milkman/controller/productdetails_controller.dart';
import 'package:milkman/controller/stordata_controller.dart';
import 'package:milkman/controller/subscribe_controller.dart';
import 'package:milkman/helpar/routes_helper.dart';
import 'package:milkman/model/fontfamily_model.dart';
import 'package:milkman/screen/PaymentGateway/FlutterWave.dart';
import 'package:milkman/screen/PaymentGateway/InputFormater.dart';
import 'package:milkman/screen/PaymentGateway/PaymentCard.dart';
import 'package:milkman/screen/PaymentGateway/StripeWeb.dart';
import 'package:milkman/screen/PaymentGateway/flutter_paypal.dart';
import 'package:milkman/screen/PaymentGateway/paytm_payment.dart';
import 'package:milkman/screen/home_screen.dart';
import 'package:milkman/utils/Colors.dart';
import 'package:milkman/utils/Custom_widget.dart';
import 'package:milkman/utils/cart_item.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:table_calendar/table_calendar.dart';

class YourCartScreen extends StatefulWidget {
  String? CartStatus;
  String? oID;
  YourCartScreen({super.key, this.CartStatus, this.oID});

  @override
  State<YourCartScreen> createState() => _YourCartScreenState();
}

double total = 0.0;
double getTotal = 0.0;
List<CartItem> cartViewList = [];
int groupValue = 0;
int getMaxDelivery = 1;

class _YourCartScreenState extends State<YourCartScreen> {
  PreScriptionControllre preScriptionControllre = Get.find();
  StoreDataContoller storeDataContoller = Get.find();
  CartController cartController = Get.find();
  TextEditingController _textEditingController=TextEditingController();
  CatDetailsController catDetailsController = Get.find();
  HomePageController homePageController = Get.find();
  SubScibeController subScibeController = Get.find();
  ProductDetailsController productDetailsController = Get.find();

  String couponCode = "";

  double proTotal = 0;

  var useWallet = 0.0;
  String wallet = "";
  var tempWallet = 0.0;

  int? _groupValue;
  String? selectidPay = "0";
  String razorpaykey = "";
  String? paymenttital;

  int cnt = 1;
  bool status = false;

  int? timeSlotValue;
  String timeSlot = "";

  List<int> maxDelivery = [];

  TextEditingController writeinstruction = TextEditingController();
  GlobalKey _toolTipKey = GlobalKey();
  late Box<CartItem> cart;
  late final List<CartItem> items;

  late Razorpay _razorpay;

  final plugin = PaystackPlugin();

  String formattedDate = "";

  @override
  void initState() {
    print("++++++******+++++++" + widget.CartStatus.toString());
    setState(() {
      save("subClc", true);
    });

    // plugin.initialize(publicKey: Config.publicKeyTest);
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    cart = Hive.box<CartItem>('cart');
    setupHive();
    setState(() {
      cartController.isOrderLoading = false;
      total = 0.0;
      getTotal = 0.0;
      groupValue = 0;
      cartController.subTotal = 0;
      cartController.isRq = [];
      maxDelivery = [];
      getMaxDelivery = 1;
    });
    super.initState();
    cartViewList = listOfCart();
    if (cartViewList.isNotEmpty) {
      if (cartViewList[0].cartCheck == "1") {
        groupValue = 1;
        setState(() {});
      } else if (cartViewList[0].cartCheck == "0") {
        groupValue = 0;
        setState(() {});
      }
    }
    cartController.getCartDataApi(storeID: storeDataContoller.storeid);
    setState(() {
      wallet = wallat1.toString();
      tempWallet = double.parse(wallat1.toString());
      save("clc", true);
    });

    var now = new DateTime.now();
    var formatter = new DateFormat('dd-MM-yyyy'); // yyyy-MM-dd
    formattedDate = formatter.format(now);
    print(formattedDate);
  }

  Future<void> setupHive() async {
    await Hive.initFlutter();
    cart = Hive.box<CartItem>('cart');
    AsyncSnapshot.waiting();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (cartController.isOrderLoading != true) {
          if (widget.CartStatus == "1") {
            catDetailsController.changeIndex(0);
          } else if (widget.CartStatus == "2") {
            Get.back();
          }
        }
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: cartViewList.isNotEmpty ? bgcolor : WhiteColor,
        appBar: AppBar(
          backgroundColor: WhiteColor,
          elevation: 0,
          leading: BackButton(
            color: BlackColor,
            onPressed: () {
              if (cartController.isOrderLoading != true) {
                if (widget.CartStatus == "1") {
                  catDetailsController.changeIndex(0);
                } else if (widget.CartStatus == "2") {
                  Get.back();
                }
              }
            },
          ),
          title: Text(
            "Your Cart".tr,
            style: TextStyle(
              color: BlackColor,
              fontFamily: FontFamily.gilroyBold,
              fontSize: 18,
            ),
          ),
          // actions: [
          //   Container(
          //     height: 40,
          //     width: 40,
          //     padding: EdgeInsets.all(8),
          //     child: Image.asset(
          //       "assets/comment.png",
          //       height: 20,
          //       width: 20,
          //       color: WhiteColor,
          //     ),
          //     decoration: BoxDecoration(
          //       shape: BoxShape.circle,
          //       gradient: gradient.btnGradient,
          //     ),
          //   ),
          //   SizedBox(
          //     width: 5,
          //   ),
          //   IconButton(
          //     onPressed: () {},
          //     icon: Icon(
          //       Icons.more_vert_rounded,
          //       color: BlackColor,
          //     ),
          //   ),
          //   SizedBox(
          //     width: 5,
          //   ),
          // ],
        ),
        body: GetBuilder<CartController>(builder: (context) {
          return !cartController.isOrderLoading
              ? cartViewList.isNotEmpty
                  ? Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Container(
                                  // height: 280,
                                  width: Get.size.width,
                                  margin: EdgeInsets.all(10),
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            height: 55,
                                            width: 55,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: FadeInImage.assetNetwork(
                                                placeholder:
                                                    "assets/ezgif.com-crop.gif",
                                                placeholderCacheHeight: 55,
                                                placeholderCacheWidth: 55,
                                                placeholderFit: BoxFit.cover,
                                                image:
                                                    "${Config.imageUrl}${storeDataContoller.storeDataInfo?.storeInfo.storeLogo ?? ""}",
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            decoration: BoxDecoration(
                                              color: WhiteColor,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                  color: Colors.grey.shade300),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  storeDataContoller
                                                          .storeDataInfo
                                                          ?.storeInfo
                                                          .storeTitle ??
                                                      "",
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                    color: BlackColor,
                                                    fontFamily:
                                                        FontFamily.gilroyBold,
                                                    fontSize: 17,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  storeDataContoller
                                                          .storeDataInfo
                                                          ?.storeInfo
                                                          .storeAddress ??
                                                      "",
                                                  style: TextStyle(
                                                    color: BlackColor,
                                                    fontSize: 14,
                                                    fontFamily:
                                                        FontFamily.gilroyMedium,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      GetBuilder<CartController>(
                                          builder: (context) {
                                        return ListView.builder(
                                          itemCount: cartViewList.length,
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            return cartViewList[index]
                                                        .cartCheck !=
                                                    "0"
                                                ? Container(
                                                    height: 190,
                                                    width: Get.size.width,
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 5,
                                                            vertical: 5),
                                                    child: Column(
                                                      children: [
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Row(
                                                          children: [
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            Image.asset(
                                                              "assets/calendar-check-alt.png",
                                                              height: 22,
                                                              width: 22,
                                                            ),
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                            Text(
                                                              "${"Starting on".tr} ${cartViewList[index].startDate}",
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    FontFamily
                                                                        .gilroyBold,
                                                                color: greytext,
                                                                fontSize: 15,
                                                              ),
                                                            ),
                                                            Spacer(),
                                                            InkWell(
                                                              onTap: () {
                                                                save("subClc", true);
                                                                cart.delete(cartViewList[index].id);
                                                                cartController.subTotal = 0;
                                                                cartViewList = listOfCart();
                                                                total = cartController.subTotal +
                                                                    (int.parse(cartController.cartDataInfo?.storeData.storeCharge ?? "") * getMaxDelivery) +
                                                                    (int.parse(cartController.cartDataInfo?.storeData.restDcharge ?? "") * getMaxDelivery);
                                                                getTotal = total;
                                                                setState(() {});
                                                              },
                                                              child: Image.asset(
                                                                "assets/Thrash.png",
                                                                color: RedColor,
                                                                height: 20,
                                                                width: 20,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 8,
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Container(
                                                              height: 100,
                                                              width: 120,
                                                              margin: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          10,
                                                                      vertical:
                                                                          5),
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                child: FadeInImage
                                                                    .assetNetwork(
                                                                  placeholder:
                                                                      "assets/ezgif.com-crop.gif",
                                                                  placeholderCacheHeight:
                                                                      100,
                                                                  placeholderCacheWidth:
                                                                      120,
                                                                  height: 100,
                                                                  width: 120,
                                                                  image:
                                                                      "${Config.imageUrl}${cartViewList[index].img}",
                                                                  placeholderFit:
                                                                      BoxFit
                                                                          .cover,
                                                                ),
                                                              ),
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                color:
                                                                    WhiteColor,
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade300,
                                                                    offset:
                                                                        const Offset(
                                                                      0.4,
                                                                      0.4,
                                                                    ),
                                                                    blurRadius:
                                                                        0.4,
                                                                    spreadRadius:
                                                                        0.4,
                                                                  ), //BoxShadow
                                                                  BoxShadow(
                                                                    color: Colors
                                                                        .white,
                                                                    offset:
                                                                        const Offset(
                                                                            0.0,
                                                                            0.0),
                                                                    blurRadius:
                                                                        0.0,
                                                                    spreadRadius:
                                                                        0.0,
                                                                  ), //BoxShadow
                                                                ],
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      InkWell(
                                                                        onTap:
                                                                            () {
                                                                          status =
                                                                              false;
                                                                          walletCalculation(
                                                                              false);
                                                                          total =
                                                                              total + cartController.couponAmt;
                                                                          cartController.couponAmt =
                                                                              0;
                                                                          couponCode =
                                                                              "";
                                                                          productDetailsController.getProductDetailsApi(
                                                                              pId: cartViewList[index].productID);
                                                                          setState(
                                                                              () {});
                                                                          subScibeController
                                                                              .getSelectedItemEditValue(
                                                                            selectDay1:
                                                                                cartViewList[index].daysList,
                                                                            selectDeliveris1:
                                                                                cartViewList[index].selectDelivery,
                                                                            selectTime1:
                                                                                cartViewList[index].startTime,
                                                                            selectDate1:
                                                                                cartViewList[index].startDate,
                                                                          );
                                                                          Get.toNamed(Routes.subScribeScreen, arguments: {
                                                                            "img":
                                                                                cartViewList[index].img,
                                                                            "name":
                                                                                cartViewList[index].strTitle,
                                                                            "sprice":
                                                                                cartViewList[index].sPrice.toString(),
                                                                            "aprice":
                                                                                cartViewList[index].productPrice.toString(),
                                                                            "per":
                                                                                cartViewList[index].per,
                                                                            "attributeId":
                                                                                cartViewList[index].id,
                                                                            "productTitle":
                                                                                cartViewList[index].productTitle,
                                                                            "isEmpty":
                                                                                "1",
                                                                            "productId": cartViewList[index].productID,
                                                                            // "product_subscripition_discount": cartViewList[index].p

                                                                          })!
                                                                              .then((value) => {
                                                                                    save("subClc", true),
                                                                                    cartController.subTotal = 0,
                                                                                    cartViewList = listOfCart(),
                                                                                    total = cartController.subTotal + (int.parse(cartController.cartDataInfo?.storeData.storeCharge ?? "") * getMaxDelivery) + (int.parse(cartController.cartDataInfo?.storeData.restDcharge ?? "") * getMaxDelivery),
                                                                                    getTotal = total,
                                                                                    print("-=-=-=-=-=-=-=-=-=-=--=-=-==-=" + getTotal.toString()),
                                                                                    setState(() {}),
                                                                                  });
                                                                        },
                                                                        child:
                                                                        // Text(""),
                                                                        Image.asset(
                                                                          "assets/Editpen.png",
                                                                          color:
                                                                              BlackColor,
                                                                          height:
                                                                              20,
                                                                          width:
                                                                              20,
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            8,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    height: 5,
                                                                  ),
                                                                  Text(
                                                                    "${cartViewList[index].strTitle}",
                                                                    maxLines: 1,
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          FontFamily
                                                                              .gilroyBold,
                                                                      fontSize:
                                                                          15,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      color:
                                                                          BlackColor,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Text(
                                                                        cartViewList[index].productTitle ??
                                                                            "",
                                                                        style:
                                                                            TextStyle(
                                                                          fontFamily:
                                                                              FontFamily.gilroyMedium,
                                                                          fontSize:
                                                                              13,
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          color:
                                                                              BlackColor,
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        " x " +
                                                                            isItem(cartViewList[index].id).toString(),
                                                                        style:
                                                                            TextStyle(
                                                                          fontFamily:
                                                                              FontFamily.gilroyMedium,
                                                                          fontSize:
                                                                              13,
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          color:
                                                                              BlackColor,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    height: 5,
                                                                  ),
                                                                  SizedBox(
                                                                    height: 5,
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Text(
                                                                        cartViewList[index].selectDelivery ??
                                                                            "",
                                                                        style:
                                                                            TextStyle(
                                                                          fontFamily:
                                                                              FontFamily.gilroyMedium,
                                                                          fontSize:
                                                                              13,
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          color:
                                                                              BlackColor,
                                                                        ),
                                                                      ),
                                                                      Spacer(),
                                                                      Text(
                                                                        "${
                                                                          cartController.getTotel(
                                                                        pPrice:
                                                                          double.parse(cartViewList[index].price?.toStringAsFixed(2).toString() ?? ""),
                                                                          discount:
                                                                          double.parse(cartViewList[index].per?.toString() ?? ""),
                                                                           qyt:
                                                                           int.parse(isItem(cartViewList[index].id).toString()))
                                                                      }",
                                                                      //   "${
                                                                      //
                                                                      //       double.parse(cartViewList[index].price?.toStringAsFixed(2).toString() ?? "") * int.parse(isItem(cartViewList[index].id).toString())-
                                                                      //
                                                                      //
                                                                      //           double.parse(cartViewList[index].price?.toStringAsFixed(2).toString() ?? "")
                                                                      //
                                                                      //
                                                                      //               *
                                                                      //
                                                                      //
                                                                      //     (double.parse(cartViewList[index].per?.toString() ?? "")
                                                                      //           * int.parse(isItem(cartViewList[index].id).toString())/100)
                                                                      //   }${currency}",
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              gradient.defoultColor,
                                                                          fontSize:
                                                                              15,
                                                                          fontFamily:
                                                                              FontFamily.gilroyBold,
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            5,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    height: 5,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 8,
                                                        ),
                                                        Row(
                                                          children: [
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            Image.asset(
                                                              "assets/calendar-minus-alt.png",
                                                              height: 22,
                                                              width: 22,
                                                            ),
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                            Text(
                                                              "${"Starting time on".tr} ${cartViewList[index].startTime}",
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    FontFamily
                                                                        .gilroyBold,
                                                                color: greytext,
                                                                fontSize: 15,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      border: Border.all(
                                                          color: Colors
                                                              .grey.shade300),
                                                    ),
                                                  )
                                                : Container(
                                                    height: 50,
                                                    width: Get.size.width,
                                                    alignment: Alignment.center,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            SizedBox(
                                                              width: Get.size
                                                                      .width *
                                                                  0.4,
                                                              child: Text(
                                                                "${cartViewList[index].strTitle}",
                                                                maxLines: 2,
                                                                style:
                                                                    TextStyle(
                                                                  color:
                                                                      BlackColor,
                                                                  fontSize: 13,
                                                                  fontFamily:
                                                                      FontFamily
                                                                          .gilroyBold,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Container(
                                                          height: 30,
                                                          width: 100,
                                                          margin:
                                                              EdgeInsets.all(5),
                                                          alignment:
                                                              Alignment.center,
                                                          child: Row(
                                                            children: [
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              InkWell(
                                                                onTap: () {
                                                                  status =
                                                                      false;
                                                                  walletCalculation(
                                                                      false);
                                                                  total = total +
                                                                      cartController
                                                                          .couponAmt;
                                                                  cartController
                                                                      .couponAmt = 0;
                                                                  couponCode =
                                                                      "";
                                                                  setState(
                                                                      () {});
                                                                  if (widget
                                                                          .CartStatus ==
                                                                      "1") {
                                                                    setState(
                                                                        () {
                                                                      onRemoveItem(
                                                                          index,
                                                                          isItem(cartViewList[index]
                                                                              .id
                                                                              .toString()));
                                                                    });
                                                                  }
                                                                  if (cartController
                                                                          .cartDataInfo
                                                                          ?.storeData
                                                                          .storeIsPickup ==
                                                                      "1") {
                                                                    if (groupValue ==
                                                                        1) {
                                                                      total = cartController
                                                                              .subTotal +
                                                                          int.parse(cartController.cartDataInfo?.storeData.storeCharge ??
                                                                              "") +
                                                                          int.parse(cartController.cartDataInfo?.storeData.restDcharge ??
                                                                              "");
                                                                      getTotal =
                                                                          total;
                                                                    } else {
                                                                      total = cartController
                                                                              .subTotal +
                                                                          int.parse(cartController.cartDataInfo?.storeData.storeCharge ??
                                                                              "");
                                                                      getTotal =
                                                                          total;
                                                                    }
                                                                    setState(
                                                                        () {});
                                                                  } else {
                                                                    total = cartController
                                                                            .subTotal +
                                                                        int.parse(cartController.cartDataInfo?.storeData.storeCharge ??
                                                                            "") +
                                                                        int.parse(cartController.cartDataInfo?.storeData.restDcharge ??
                                                                            "");
                                                                    getTotal =
                                                                        total;
                                                                  }
                                                                },
                                                                child:
                                                                    Container(
                                                                  height: 25,
                                                                  width: 25,
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child: Icon(
                                                                    Icons
                                                                        .remove,
                                                                    color: gradient
                                                                        .defoultColor,
                                                                    size: 18,
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
                                                                    isItem(cartViewList[index]
                                                                            .id)
                                                                        .toString(),
                                                                    style:
                                                                        TextStyle(
                                                                      color: gradient
                                                                          .defoultColor,
                                                                      fontFamily:
                                                                          FontFamily
                                                                              .gilroyBold,
                                                                      fontSize:
                                                                          15,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              InkWell(
                                                                onTap: () {
                                                                  if (widget
                                                                          .CartStatus ==
                                                                      "1") {
                                                                    status =
                                                                        false;
                                                                    walletCalculation(
                                                                        false);
                                                                    total = total +
                                                                        cartController
                                                                            .couponAmt;
                                                                    cartController
                                                                        .couponAmt = 0;
                                                                    couponCode =
                                                                        "";
                                                                    setState(
                                                                        () {});
                                                                    if (widget
                                                                            .CartStatus ==
                                                                        "1") {
                                                                      setState(
                                                                          () {
                                                                        onAddItem(
                                                                            index,
                                                                            isItem(cartViewList[index].id));
                                                                      });

                                                                      cartController.getSubTotalClc(
                                                                          pPrice: cartViewList[index]
                                                                              .price,
                                                                          subdiv:
                                                                              "pluse");
                                                                    }
                                                                    if (cartController
                                                                            .cartDataInfo
                                                                            ?.storeData
                                                                            .storeIsPickup ==
                                                                        "1") {
                                                                      if (groupValue ==
                                                                          1) {
                                                                        total = cartController.subTotal +
                                                                            int.parse(cartController.cartDataInfo?.storeData.storeCharge ??
                                                                                "") +
                                                                            int.parse(cartController.cartDataInfo?.storeData.restDcharge ??
                                                                                "");
                                                                        getTotal =
                                                                            total;
                                                                      } else {
                                                                        total = cartController.subTotal +
                                                                            int.parse(cartController.cartDataInfo?.storeData.storeCharge ??
                                                                                "");
                                                                        getTotal =
                                                                            total;
                                                                      }
                                                                    } else {
                                                                      total = cartController
                                                                              .subTotal +
                                                                          int.parse(cartController.cartDataInfo?.storeData.storeCharge ??
                                                                              "") +
                                                                          int.parse(cartController.cartDataInfo?.storeData.restDcharge ??
                                                                              "");
                                                                      getTotal =
                                                                          total;
                                                                    }
                                                                  } else {
                                                                    showToastMessage(
                                                                        "The quantity cannot be modified as it has been prescribed by the doctors."
                                                                            .tr);
                                                                  }
                                                                },
                                                                child:
                                                                    Container(
                                                                  height: 25,
                                                                  width: 25,
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child: Icon(
                                                                    Icons.add,
                                                                    color: gradient
                                                                        .defoultColor,
                                                                    size: 18,
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                            ],
                                                          ),
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            border: Border.all(
                                                                color: Colors
                                                                    .grey
                                                                    .shade300),
                                                          ),
                                                        ),
                                                        Text(
                                                          "${double.parse(cartViewList[index].productPrice?.toStringAsFixed(2).toString() ?? "") * int.parse(isItem(cartViewList[index].id).toString())}",
                                                          style: TextStyle(
                                                            color: BlackColor,
                                                            fontSize: 15,
                                                            fontFamily: FontFamily.gilroyBold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                          },
                                        );
                                      }),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      DottedLine(dashColor: greyColor),
                                      TextFormField(
                                        controller: writeinstruction,
                                        minLines: 1,
                                        maxLines: 5,
                                        decoration: InputDecoration(
                                          contentPadding:
                                              EdgeInsets.only(left: 8, top: 5),
                                          hintText:
                                              "Write instructions, gifting ideas etc.."
                                                  .tr,
                                          border: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          hintStyle: TextStyle(
                                            color: greyColor,
                                            fontSize: 15,
                                            fontFamily: FontFamily.gilroyMedium,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                  decoration: BoxDecoration(
                                    color: WhiteColor,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                cartController.cartDataInfo?.storeData.storeIsPickup == "1"
                                    ? cartViewList[0].cartCheck == "0"
                                        ? Container(
                                            height: 110,
                                            width: Get.size.width,
                                            margin: EdgeInsets.all(10),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Padding(
                                                  padding:
                                                      EdgeInsets.only(left: 10),
                                                  child: Text(
                                                    "Delivery Type".tr,
                                                    style: TextStyle(
                                                      color: BlackColor,
                                                      fontFamily:
                                                          FontFamily.gilroyBold,
                                                      fontSize: 17,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        status = false;
                                                        walletCalculation(
                                                            false);
                                                        setState(() {});
                                                        // status = false;
                                                        // total = total + useWallet;
                                                        // useWallet = 0;
                                                        total = total +
                                                            cartController
                                                                .couponAmt;
                                                        cartController
                                                            .couponAmt = 0;
                                                        couponCode = "";
                                                        print(
                                                            "-------*******------" +
                                                                total
                                                                    .toString());
                                                        if (groupValue == 1) {
                                                          setState(() {
                                                            total = total -
                                                                double.parse(cartController
                                                                        .cartDataInfo
                                                                        ?.storeData
                                                                        .restDcharge ??
                                                                    "0");
                                                            getTotal = total;
                                                          });
                                                          print("+++++=====++++" +
                                                              cartController
                                                                  .subTotal
                                                                  .toString());
                                                          print("-------*******------" +
                                                              total.toString());
                                                        }
                                                        setState(() {
                                                          groupValue = 0;
                                                        });
                                                      },
                                                      child: Row(
                                                        children: [
                                                          Radio(
                                                            activeColor:
                                                                groupValue == 0
                                                                    ? gradient
                                                                        .defoultColor
                                                                    : greyColor,
                                                            value: 0,
                                                            groupValue:
                                                                groupValue,
                                                            onChanged: (value) {
                                                              status = false;
                                                              walletCalculation(
                                                                  false);
                                                              setState(() {});
                                                              // status = false;
                                                              // total = total + useWallet;
                                                              // useWallet = 0;
                                                              total = total +
                                                                  cartController
                                                                      .couponAmt;
                                                              cartController
                                                                  .couponAmt = 0;
                                                              couponCode = "";
                                                              print("-------*******------" +
                                                                  total
                                                                      .toString());
                                                              if (groupValue ==
                                                                  1) {
                                                                setState(() {
                                                                  total = total -
                                                                      double.parse(cartController
                                                                              .cartDataInfo
                                                                              ?.storeData
                                                                              .restDcharge ??
                                                                          "0");
                                                                  getTotal =
                                                                      total;
                                                                });
                                                                print("+++++=====++++" +
                                                                    cartController
                                                                        .subTotal
                                                                        .toString());
                                                                print("-------*******------" +
                                                                    total
                                                                        .toString());
                                                              }
                                                              setState(() {
                                                                groupValue =
                                                                    value!;
                                                              });
                                                            },
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Text(
                                                            "Self Pickup".tr,
                                                            style: TextStyle(
                                                              color: groupValue ==
                                                                      0
                                                                  ? gradient
                                                                      .defoultColor
                                                                  : greyColor,
                                                              fontFamily: FontFamily
                                                                  .gilroyMedium,
                                                              fontSize: 17,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 25,
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        status = false;
                                                        walletCalculation(
                                                            false);
                                                        setState(() {});
                                                        // total = total + useWallet;
                                                        // useWallet = 0;
                                                        total = total +
                                                            cartController
                                                                .couponAmt;
                                                        cartController
                                                            .couponAmt = 0;
                                                        couponCode = "";
                                                        print(
                                                            "-------*******------" +
                                                                total
                                                                    .toString());
                                                        setState(() {
                                                          groupValue = 1;
                                                          total = cartController
                                                                  .subTotal +
                                                              double.parse(cartController
                                                                      .cartDataInfo
                                                                      ?.storeData
                                                                      .restDcharge ??
                                                                  "0") +
                                                              double.parse(cartController
                                                                      .cartDataInfo
                                                                      ?.storeData
                                                                      .storeCharge ??
                                                                  "0");
                                                          print("+++++=====++++" +
                                                              cartController
                                                                  .subTotal
                                                                  .toString());
                                                          print("-------*******------" +
                                                              total.toString());
                                                          getTotal = total;
                                                        });
                                                      },
                                                      child: Row(
                                                        children: [
                                                          Radio(
                                                            activeColor:
                                                                groupValue == 1
                                                                    ? gradient
                                                                        .defoultColor
                                                                    : greyColor,
                                                            value: 1,
                                                            groupValue:
                                                                groupValue,
                                                            onChanged: (value) {
                                                              status = false;
                                                              walletCalculation(
                                                                  false);
                                                              setState(() {});
                                                              // total = total + useWallet;
                                                              // useWallet = 0;
                                                              total = total +
                                                                  cartController
                                                                      .couponAmt;
                                                              cartController
                                                                  .couponAmt = 0;
                                                              couponCode = "";
                                                              print("-------*******------" +
                                                                  total
                                                                      .toString());
                                                              setState(() {
                                                                groupValue = 1;
                                                                total = cartController
                                                                        .subTotal +
                                                                    double.parse(cartController
                                                                            .cartDataInfo
                                                                            ?.storeData
                                                                            .restDcharge ??
                                                                        "0") +
                                                                    double.parse(cartController
                                                                            .cartDataInfo
                                                                            ?.storeData
                                                                            .storeCharge ??
                                                                        "0");
                                                                print("+++++=====++++" +
                                                                    cartController
                                                                        .subTotal
                                                                        .toString());
                                                                print("-------*******------" +
                                                                    total
                                                                        .toString());
                                                                getTotal =
                                                                    total;
                                                              });
                                                              setState(() {
                                                                groupValue =
                                                                    value!;
                                                              });
                                                            },
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Text(
                                                            "Delivery".tr,
                                                            style: TextStyle(
                                                              color: groupValue ==
                                                                      1
                                                                  ? gradient
                                                                      .defoultColor
                                                                  : greyColor,
                                                              fontFamily: FontFamily
                                                                  .gilroyMedium,
                                                              fontSize: 17,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: WhiteColor,
                                            ),
                                          )
                                        : SizedBox()
                                    : SizedBox(),
                                cartViewList[0].cartCheck == "0"
                                    ? Container(
                                        height: 85,
                                        width: Get.size.width,
                                        margin: EdgeInsets.all(10),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(left: 10),
                                              child: Text(
                                                "Delivery Date".tr,
                                                style: TextStyle(
                                                  color: BlackColor,
                                                  fontFamily:
                                                      FontFamily.gilroyBold,
                                                  fontSize: 17,
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                selectStartDate()
                                                    .then((value) => {
                                                          if (subScibeController
                                                                  .selectDay !=
                                                              "")
                                                            {
                                                              formattedDate =
                                                                  "${subScibeController.selectDay}-${subScibeController.selectMonth}-${subScibeController.selectYear}",
                                                              setState(() {})
                                                            },
                                                        });
                                              },
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Radio(
                                                    value: 0,
                                                    groupValue: 0,
                                                    activeColor:
                                                        gradient.defoultColor,
                                                    onChanged: (value) {},
                                                  ),
                                                  Text(
                                                    formattedDate,
                                                    style: TextStyle(
                                                      fontFamily: FontFamily
                                                          .gilroyMedium,
                                                      fontSize: 15,
                                                      color: BlackColor,
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  Image.asset(
                                                    "assets/calendar1.png",
                                                    height: 25,
                                                    width: 25,
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: WhiteColor,
                                        ),
                                      )
                                    : SizedBox(),
                                cartController.cartDataInfo?.storeData
                                            .storeIsPickup ==
                                        "1"
                                    ? cartViewList[0].cartCheck == "0"
                                        ? GetBuilder<CartController>(
                                            builder: (context) {
                                            return Container(
                                              height: 50,
                                              width: Get.size.width,
                                              margin: EdgeInsets.all(10),
                                              child: cartController.isLoading
                                                  ? ListView.builder(
                                                      itemCount: cartController
                                                          .cartDataInfo
                                                          ?.timeslotlist
                                                          .length,
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      itemBuilder:
                                                          (context, index) {
                                                        String maxTime =
                                                            "2023-03-20T${cartController.cartDataInfo?.timeslotlist[index].maxtime}";
                                                        String minTime =
                                                            "2023-03-20T${cartController.cartDataInfo?.timeslotlist[index].mintime}";
                                                        return InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              timeSlotValue =
                                                                  index;
                                                              timeSlot =
                                                                  "${DateFormat.jm().format(DateTime.parse(minTime))} to ${DateFormat.jm().format(DateTime.parse(maxTime))}";
                                                            });
                                                          },
                                                          child: Container(
                                                            height: 50,
                                                            padding:
                                                                EdgeInsets.only(
                                                                    right: 10),
                                                            margin:
                                                                EdgeInsets.all(
                                                                    5),
                                                            child: Row(
                                                              children: [
                                                                SizedBox(
                                                                  width: 8,
                                                                ),
                                                                Radio(
                                                                  activeColor:
                                                                      gradient
                                                                          .defoultColor,
                                                                  value: index,
                                                                  groupValue:
                                                                      timeSlotValue,
                                                                  onChanged:
                                                                      (value) {
                                                                    setState(
                                                                        () {
                                                                      timeSlot =
                                                                          "${DateFormat.jm().format(DateTime.parse(minTime))} to ${DateFormat.jm().format(DateTime.parse(maxTime))}";
                                                                      timeSlotValue =
                                                                          index;
                                                                    });
                                                                  },
                                                                ),
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                Text(
                                                                  DateFormat
                                                                          .jm()
                                                                      .format(DateTime
                                                                          .parse(
                                                                              minTime)),
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        FontFamily
                                                                            .gilroyMedium,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 2,
                                                                ),
                                                                Text(
                                                                  "to",
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        FontFamily
                                                                            .gilroyMedium,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 2,
                                                                ),
                                                                Text(
                                                                  DateFormat
                                                                          .jm()
                                                                      .format(DateTime
                                                                          .parse(
                                                                              maxTime)),
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        FontFamily
                                                                            .gilroyMedium,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            decoration:
                                                                BoxDecoration(
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .grey
                                                                      .shade300),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    )
                                                  : Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                        color: gradient
                                                            .defoultColor,
                                                      ),
                                                    ),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: WhiteColor,
                                              ),
                                            );
                                          })
                                        : SizedBox()
                                    : SizedBox(),
                                //! ---------- Wallet Widget -----------!//
                                wallet != "0"
                                    ? Container(
                                        height: 140,
                                        width: Get.size.width,
                                        margin: EdgeInsets.all(10),
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  "Wallet information".tr,
                                                  style: TextStyle(
                                                    fontFamily:
                                                        FontFamily.gilroyBold,
                                                    fontSize: 17,
                                                    color: BlackColor,
                                                  ),
                                                ),
                                                // Spacer(),
                                                // Text(
                                                //   "Recharge".tr,
                                                //   style: TextStyle(
                                                //     fontFamily:
                                                //         FontFamily.gilroyBold,
                                                //     fontSize: 17,
                                                //     color:
                                                //         gradient.defoultColor,
                                                //   ),
                                                // ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Container(
                                              height: 60,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    width: 15,
                                                  ),
                                                  Image.asset(
                                                    "assets/wallet.png",
                                                    height: 30,
                                                    width: 30,
                                                  ),
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                  Text(
                                                    "${"Balance".tr} $currency${tempWallet.toStringAsFixed(2)}",
                                                    style: TextStyle(
                                                      fontFamily:
                                                          FontFamily.gilroyBold,
                                                      fontSize: 17,
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  Transform.scale(
                                                    scale: 0.8,
                                                    child: CupertinoSwitch(
                                                      activeColor:
                                                          gradient.defoultColor,
                                                      value: status,
                                                      onChanged: (value) {
                                                        setState(() {});
                                                        status = value;
                                                        walletCalculation(
                                                            value);
                                                      },
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                ],
                                              ),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                    color:
                                                        Colors.grey.shade300),
                                              ),
                                            ),
                                          ],
                                        ),
                                        decoration: BoxDecoration(
                                          color: WhiteColor,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                      )
                                    : SizedBox(),
                                //! ---------- Coupon Widget -----------!//
                                Container(
                                  height: 150,
                                  width: Get.size.width,
                                  margin: EdgeInsets.all(10),
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: InkWell(
                                    onTap: () {
                                      if (couponCode == "") {
                                        status = false;
                                        walletCalculation(false);
                                        setState(() {});
                                        Get.toNamed(Routes.couponScreen,
                                                arguments: {
                                              "price": cartController.subTotal
                                            })!
                                            .then((value) {
                                          setState(() {
                                            couponCode = value;
                                          });
                                          couponSucsessFullyApplyed();
                                        });
                                      } else {
                                        status = false;
                                        walletCalculation(false);
                                        setState(() {});
                                        // total = total + useWallet;
                                        // useWallet = 0;
                                        total =
                                            total + cartController.couponAmt;
                                        cartController.couponAmt = 0;
                                        couponCode = "";
                                        setState(() {});
                                      }
                                    },
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Container(
                                          height: 60,
                                          alignment: Alignment.center,
                                          child: InkWell(
                                            child: Row(
                                              children: [
                                                Image.asset(
                                                  "assets/badge-discount.png",
                                                  height: 40,
                                                  width: 40,
                                                  color: gradient.defoultColor,
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "Apply Coupon".tr,
                                                        style: TextStyle(
                                                          color: gradient
                                                              .defoultColor,
                                                          fontFamily: FontFamily
                                                              .gilroyBold,
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 4,
                                                      ),
                                                      couponCode != ""
                                                          ? Row(
                                                              children: [
                                                                Text(
                                                                  "Use code:"
                                                                      .tr,
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        FontFamily
                                                                            .gilroyMedium,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  couponCode,
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        FontFamily
                                                                            .gilroyBold,
                                                                  ),
                                                                ),
                                                              ],
                                                            )
                                                          : SizedBox(),
                                                    ],
                                                  ),
                                                ),
                                                couponCode != ""
                                                    ? InkWell(
                                                        onTap: () {
                                                          status = false;
                                                          walletCalculation(
                                                              false);
                                                          setState(() {});
                                                          // total = total + useWallet;
                                                          // useWallet = 0;
                                                          total = total +
                                                              cartController
                                                                  .couponAmt;
                                                          cartController
                                                              .couponAmt = 0;
                                                          couponCode = "";
                                                          setState(() {});
                                                        },
                                                        child: Text(
                                                          "Remove".tr,
                                                          style: TextStyle(
                                                            fontFamily:
                                                                FontFamily
                                                                    .gilroyBold,
                                                            color: RedColor,
                                                            fontSize: 15,
                                                          ),
                                                        ),
                                                      )
                                                    : InkWell(
                                                        onTap: () {
                                                          status = false;
                                                          walletCalculation(
                                                              false);
                                                          setState(() {});
                                                          // cartController.getCouponList(
                                                          //   sId: storeDataContoller
                                                          //           .storeDataInfo
                                                          //           ?.storeInfo
                                                          //           .storeId ??
                                                          //       "",
                                                          // );
                                                          Get.toNamed(
                                                                  Routes
                                                                      .couponScreen,
                                                                  arguments: {
                                                                "price":
                                                                    cartController
                                                                        .subTotal
                                                              })!
                                                              .then((value) {
                                                            setState(() {
                                                              couponCode =
                                                                  value;
                                                            });
                                                            couponSucsessFullyApplyed();
                                                          });
                                                        },
                                                        child: Text(
                                                          "Apply".tr,
                                                          style: TextStyle(
                                                            fontFamily:
                                                                FontFamily
                                                                    .gilroyBold,
                                                            color: gradient
                                                                .defoultColor,
                                                            fontSize: 15,
                                                          ),
                                                        ),
                                                      ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Divider(),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        InkWell(
                                          onTap: () {},
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                "View all coupons".tr,
                                                style: TextStyle(
                                                  color: greyColor,
                                                  fontSize: 15,
                                                  fontFamily:
                                                      FontFamily.gilroyMedium,
                                                ),
                                              ),
                                              Spacer(),
                                              Icon(
                                                Icons.arrow_forward_ios,
                                                size: 15,
                                                color: greyColor,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    color: WhiteColor,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                GetBuilder<CartController>(builder: (context) {
                                  return Container(
                                    width: Get.size.width,
                                    margin: EdgeInsets.all(10),
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          "Bill details".tr,
                                          style: TextStyle(
                                            fontFamily: FontFamily.gilroyBold,
                                            color: BlackColor,
                                            fontSize: 17,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "Cart total".tr,
                                              style: TextStyle(
                                                fontFamily:
                                                    FontFamily.gilroyMedium,
                                                fontSize: 15,
                                              ),
                                            ),
                                            Spacer(),
                                            Text(
                                              "${cartController.subTotal.toStringAsFixed(2)}${currency}",
                                              style: TextStyle(
                                                fontFamily:
                                                    FontFamily.gilroyBold,
                                                fontSize: 15,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        // DottedLine(
                                        //   dashColor: greyColor,
                                        // ),
                                        // SizedBox(
                                        //   height: 8,
                                        // ),
                                        // Row(
                                        //   children: [
                                        //     Text(
                                        //       "Store Charge".tr,
                                        //       style: TextStyle(
                                        //         fontFamily:
                                        //             FontFamily.gilroyMedium,
                                        //         fontSize: 15,
                                        //       ),
                                        //     ),
                                        //     Spacer(),
                                        //     // maxDelivery.isEmpty
                                        //     //     ? Text(
                                        //     //         "${cartController.cartDataInfo?.storeData.storeCharge ?? ""}${currency}",
                                        //     //         style: TextStyle(
                                        //     //           fontFamily:
                                        //     //               FontFamily.gilroyBold,
                                        //     //           fontSize: 15,
                                        //     //         ),
                                        //     //       )
                                        //     //     :
                                        //     cartController.isLoading
                                        //         ? Text(
                                        //             "${double.parse(cartController.cartDataInfo?.storeData.storeCharge ?? "") * getMaxDelivery}${currency}",
                                        //             style: TextStyle(
                                        //               fontFamily:
                                        //                   FontFamily.gilroyBold,
                                        //               fontSize: 15,
                                        //             ),
                                        //           )
                                        //         : SizedBox(),
                                        //     SizedBox(
                                        //       width: 10,
                                        //     ),
                                        //   ],
                                        // ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        status
                                            ? Row(
                                                children: [
                                                  Text(
                                                    "Wallet".tr,
                                                    style: TextStyle(
                                                      fontFamily: FontFamily
                                                          .gilroyMedium,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  Text(
                                                    "${useWallet.toStringAsFixed(2)}${currency}",
                                                    style: TextStyle(
                                                      fontFamily:
                                                          FontFamily.gilroyBold,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                ],
                                              )
                                            : SizedBox(),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        couponCode != ""
                                            ? Row(
                                                children: [
                                                  Text(
                                                    "Coupon".tr,
                                                    style: TextStyle(
                                                      fontFamily: FontFamily
                                                          .gilroyMedium,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  Text(
                                                    "${cartController.couponAmt}${currency}",
                                                    style: TextStyle(
                                                      fontFamily:
                                                          FontFamily.gilroyBold,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                ],
                                              )
                                            : SizedBox(),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        DottedLine(
                                          dashColor: greyColor,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "Delivery Fee".tr,
                                              style: TextStyle(
                                                fontFamily:
                                                    FontFamily.gilroyMedium,
                                                fontSize: 15,
                                              ),
                                            ),
                                            Spacer(),
                                            cartController.isLoading
                                                ? Text(
                                                    cartController
                                                                .cartDataInfo
                                                                ?.storeData
                                                                .storeIsPickup ==
                                                            "1"
                                                        ? groupValue == 1
                                                            ? "${double.parse(cartController.cartDataInfo?.storeData.restDcharge ?? "") * getMaxDelivery}${currency}"
                                                            : "Free"
                                                        : "${double.parse(cartController.cartDataInfo?.storeData.restDcharge ?? "") * getMaxDelivery}${currency}",
                                                    style: TextStyle(
                                                      fontFamily:
                                                          FontFamily.gilroyBold,
                                                      fontSize: 15,
                                                    ),
                                                  )
                                                : SizedBox(),
                                            SizedBox(
                                              width: 10,
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        DottedLine(
                                          dashColor: greyColor,
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "To pay".tr,
                                              style: TextStyle(
                                                fontFamily:
                                                    FontFamily.gilroyBold,
                                                fontSize: 15,
                                              ),
                                            ),
                                            Spacer(),
                                            Text(
                                              "${total.toStringAsFixed(2)}${currency}",
                                              style: TextStyle(
                                                fontFamily:
                                                    FontFamily.gilroyBold,
                                                fontSize: 15,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                    decoration: BoxDecoration(
                                      color: WhiteColor,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  );
                                }),
                                cartController.cartDataInfo?.storeData
                                            .storeIsPickup ==
                                        "1"
                                    ? groupValue == 0
                                        ? selfPickUpWidget()
                                        : deliveryWidget()
                                    : deliveryWidget(),
                              ],
                            ),
                          ),
                        ),
                        GetBuilder<CartController>(builder: (context) {
                          return Container(
                            width: Get.size.width,
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${currency}${total.toStringAsFixed(2)}",
                                        style: TextStyle(
                                          fontFamily: FontFamily.gilroyBold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        "View Detailed Bill".tr,
                                        style: TextStyle(
                                          fontFamily: FontFamily.gilroyMedium,
                                          fontSize: 15,
                                          color: gradient.defoultColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                GetBuilder<CartController>(builder: (context) {
                                  return groupValue == 1
                                      ? InkWell(
                                          onTap: () {
                                            if (widget.CartStatus == "1") {
                                              if (cartViewList[0].cartCheck ==
                                                  "0") {
                                                if (int.parse(
                                                        "${cartController.cartDataInfo?.storeData.storeMorder}") <=
                                                    cartController.subTotal) {
                                                  if (timeSlot != "") {
                                                    if (cartController
                                                            .addresTitle ==
                                                        "") {
                                                      cartController
                                                          .addressListApi();
                                                      addressShit();
                                                    } else {
                                                      if (cartController
                                                              .cartDataInfo
                                                              ?.storeData
                                                              .storeIsDeliver ==
                                                          "1") {
                                                        if (status == true) {
                                                          if (double.parse(total
                                                                  .toString()) >
                                                              0) {
                                                            paymentSheett();
                                                          } else {
                                                            if (cartViewList[0]
                                                                    .cartCheck ==
                                                                "0") {
                                                              buyNormalOrderInStore(
                                                                  "0");
                                                            } else {
                                                              subScriptionOrderInStore(
                                                                  "0");
                                                            }
                                                          }
                                                        } else {
                                                          paymentSheett();
                                                        }
                                                      } else {
                                                        setState(() {
                                                          cartController
                                                              .addresTitle = "";
                                                        });
                                                        showToastMessage(
                                                            "Please Change Address"
                                                                .tr);
                                                      }
                                                    }
                                                  } else {
                                                    showToastMessage(
                                                        "Please Select Timeslot"
                                                            .tr);
                                                  }
                                                } else {
                                                  showToastMessage(
                                                      "${"A minimum cart total of".tr} ${cartController.cartDataInfo?.storeData.storeMorder} ${"is required for this order.".tr}");
                                                }
                                              } else {
                                                if (int.parse(
                                                        "${cartController.cartDataInfo?.storeData.storeMorder}") <=
                                                    cartController.subTotal) {
                                                  if (cartController
                                                          .addresTitle ==
                                                      "") {
                                                    cartController
                                                        .addressListApi();
                                                    addressShit();
                                                  } else {
                                                    if (cartController
                                                            .cartDataInfo
                                                            ?.storeData
                                                            .storeIsDeliver ==
                                                        "1") {
                                                      if (status == true) {
                                                        if (double.parse(total
                                                                .toString()) >
                                                            0) {
                                                          paymentSheett();
                                                        } else {
                                                          if (cartViewList[0]
                                                                  .cartCheck ==
                                                              "0") {
                                                            buyNormalOrderInStore(
                                                                "0");
                                                          } else {
                                                            subScriptionOrderInStore(
                                                                "0");
                                                          }
                                                        }
                                                      } else {
                                                        paymentSheett();
                                                      }
                                                    } else {
                                                      setState(() {
                                                        cartController
                                                            .addresTitle = "";
                                                      });
                                                      showToastMessage(
                                                          "Please Change Address"
                                                              .tr);
                                                    }
                                                  }
                                                }
                                                // else {
                                                //   showToastMessage(
                                                //       "${"A minimum cart total of".tr} ${cartController.cartDataInfo?.storeData.storeMorder} ${"is required for this order.".tr}");
                                                // }
                                              }
                                            } else {
                                              if (cartController.addresTitle ==
                                                  "") {
                                                cartController.addressListApi();
                                                addressShit();
                                              } else {
                                                if (cartController
                                                        .cartDataInfo
                                                        ?.storeData
                                                        .storeIsDeliver ==
                                                    "1") {
                                                  if (status == true) {
                                                    if (double.parse(
                                                            total.toString()) >
                                                        0) {
                                                      paymentSheett();
                                                    } else {
                                                      // priscriptionOrderComplete(
                                                      //     "0");
                                                    }
                                                  } else {
                                                    paymentSheett();
                                                  }
                                                } else {
                                                  setState(() {
                                                    cartController.addresTitle =
                                                        "";
                                                  });
                                                  showToastMessage(
                                                      "Please Change Address"
                                                          .tr);
                                                }
                                              }
                                            }
                                          },
                                          child: Container(
                                            height: 45,
                                            margin: EdgeInsets.all(8),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 5),
                                            alignment: Alignment.center,
                                            child: cartController.addresTitle == ""
                                                ? Text(
                                                    "Enter Address".tr,
                                                    style: TextStyle(
                                                      fontFamily:
                                                          FontFamily.gilroyBold,
                                                      color: WhiteColor,
                                                    ),
                                                  )
                                                : Text(
                                                    "Continue".tr,
                                                    style: TextStyle(
                                                      fontFamily:
                                                          FontFamily.gilroyBold,
                                                      color: WhiteColor,
                                                    ),
                                                  ),
                                            decoration: BoxDecoration(
                                              gradient: gradient.btnGradient,
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                          ),
                                        )
                                      : InkWell(
                                          onTap: () {
                                            if (widget.CartStatus == "1") {
                                              // if (cartController.isRq.isEmpty) {
                                              if (int.parse(
                                                      "${cartController.cartDataInfo?.storeData.storeMorder}") <=
                                                  cartController.subTotal) {
                                                if (cartController.cartDataInfo?.storeData.storeIsPickup == "1") {
                                                  if (timeSlot != "") {
                                                    if (status == true) {
                                                      if (double.parse(total
                                                              .toString()) >
                                                          0) {
                                                        paymentSheett();
                                                      } else {
                                                        if (cartViewList[0].cartCheck == "0") {
                                                          buyNormalOrderInStore(
                                                              "0");
                                                        } else {
                                                          subScriptionOrderInStore(
                                                              "0");
                                                        }
                                                      }
                                                    } else {
                                                      paymentSheett();
                                                    }
                                                  } else {
                                                    showToastMessage("Please Select Timeslot".tr);
                                                  }
                                                } else {
                                                  if (cartController
                                                          .addresTitle !=
                                                      "") {
                                                    if (status == true) {
                                                      if (double.parse(total
                                                              .toString()) >
                                                          0) {
                                                        paymentSheett();
                                                      } else {
                                                        if (cartViewList[0]
                                                                .cartCheck ==
                                                            "0") {
                                                          buyNormalOrderInStore(
                                                              "0");
                                                        } else {
                                                          subScriptionOrderInStore(
                                                              "0");
                                                        }
                                                      }
                                                    } else {
                                                      paymentSheett();
                                                    }
                                                  } else {
                                                    showToastMessage(
                                                        "Please Select Address"
                                                            .tr);
                                                  }
                                                }
                                              }
                                              // else {
                                              //   showToastMessage(
                                              //       "${"A minimum cart total of".tr} ${cartController.cartDataInfo?.storeData.storeMorder}"
                                              //           " ${"is required for this order.".tr}");
                                              // }
                                              //!-------
                                            } else {
                                              if (cartController.cartDataInfo?.storeData.storeIsPickup == "1") {
                                                if (timeSlot != "") {
                                                  if (status == true) {
                                                    if (double.parse(total.toString()) > 0) {
                                                      paymentSheett();
                                                    } else {
                                                      // priscriptionOrderComplete(
                                                      //     "0");
                                                    }
                                                  } else {
                                                    paymentSheett();
                                                  }
                                                } else {
                                                  showToastMessage(
                                                      "Please Select Timeslot"
                                                          .tr);
                                                }
                                              } else {
                                                if (cartController
                                                        .addresTitle !=
                                                    "") {
                                                  if (status == true) {
                                                    if (double.parse(
                                                            total.toString()) >
                                                        0) {
                                                      paymentSheett();
                                                    } else {
                                                      // priscriptionOrderComplete(
                                                      //     "0");
                                                    }
                                                  } else {
                                                    paymentSheett();
                                                  }
                                                } else {
                                                  showToastMessage("Please Select Address".tr);
                                                }
                                              }
                                            }
                                          },
                                          child: Container(
                                            height: 40,
                                            width: 120,
                                            padding: EdgeInsets.all(10),
                                            margin: EdgeInsets.all(8),
                                            alignment: Alignment.center,
                                            child: Text(
                                              "Proceed".tr,
                                              style: TextStyle(
                                                fontFamily:
                                                    FontFamily.gilroyBold,
                                                color: WhiteColor,
                                              ),
                                            ),
                                            decoration: BoxDecoration(
                                              gradient: gradient.btnGradient,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                        );
                                }),
                              ],
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                              color: WhiteColor,
                            ),
                          );
                        }),
                      ],
                    )
                  : Container(
                      height: Get.size.height,
                      width: Get.size.width,
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: Get.size.height * 0.2,
                            width: Get.size.width * 0.4,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/cartEmpty.png'),
                              ),
                            ),
                          ),
                          Text(
                            "Is's Lonely in here...".tr,
                            style: TextStyle(
                              fontFamily: FontFamily.gilroyBold,
                              fontSize: 17,
                              color: BlackColor,
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            "Why don't you check some products on our \n Pharmafast".tr,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: FontFamily.gilroyMedium,
                              fontSize: 15,
                              height: 1.2,
                              color: BlackColor,
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          InkWell(
                            onTap: () {
                              catDetailsController.changeIndex(0);
                            },
                            child: Container(
                              height: 50,
                              width: Get.size.width,
                              alignment: Alignment.center,
                              margin: EdgeInsets.all(15),
                              child: Text(
                                "Explore more".tr,
                                style: TextStyle(
                                  fontFamily: FontFamily.gilroyBold,
                                  fontSize: 15,
                                  color: WhiteColor,
                                ),
                              ),
                              decoration: BoxDecoration(
                                gradient: gradient.btnGradient,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
              : Center(
                  child: CircularProgressIndicator(
                    color: gradient.defoultColor,
                  ),
                );
        }),
      ),
    );
  }

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  Future selectStartDate() {
    return Get.bottomSheet(
      isScrollControlled: true,
      GetBuilder<SubScibeController>(builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return Container(
            height: Get.size.height * 0.6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20,
                    left: 20,
                  ),
                  child: Text(
                    "Select the delivery date".tr,
                    style: TextStyle(
                      fontFamily: FontFamily.gilroyBold,
                      color: greytext,
                      fontSize: 18,
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TableCalendar(
                    firstDay: DateTime.now(),
                    lastDay: DateTime.utc(2040, 10, 20),
                    focusedDay: DateTime.now(),
                    headerVisible: true,
                    daysOfWeekVisible: true,
                    sixWeekMonthsEnforced: false,
                    shouldFillViewport: false,
                    headerStyle: HeaderStyle(
                      titleCentered: true,
                      formatButtonShowsNext: false,
                      formatButtonVisible: false,
                      leftChevronVisible: false,
                      rightChevronVisible: false,
                      rightChevronMargin: EdgeInsets.zero,
                      formatButtonPadding: EdgeInsets.zero,
                      rightChevronPadding: EdgeInsets.zero,
                      leftChevronPadding: EdgeInsets.zero,
                      titleTextStyle: TextStyle(
                        fontSize: 20,
                        color: gradient.defoultColor,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    calendarStyle: CalendarStyle(
                      todayTextStyle: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                      selectedDecoration: BoxDecoration(
                        gradient: gradient.btnGradient,
                        shape: BoxShape.circle,
                      ),
                      todayDecoration: BoxDecoration(
                        color: gradient.defoultColor.withOpacity(0.8),
                        shape: BoxShape.circle,
                      ),
                    ),
                    selectedDayPredicate: (day) {
                      return isSameDay(_selectedDay, day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      formattedDate =
                          "${subScibeController.selectDay}-${subScibeController.selectMonth}-${subScibeController.selectYear}";
                      setState(() {});
                      subScibeController.getDate(
                        day1: selectedDay.day.toString(),
                        month1: selectedDay.month.toString(),
                        year1: selectedDay.year.toString(),
                        selectdate1: "",
                      );
                      selectedDay;
                      print("========--------" + selectedDay.day.toString());
                      print("========--------" + selectedDay.month.toString());
                      print("========--------" + selectedDay.year.toString());
                      if (!isSameDay(_selectedDay, selectedDay)) {
                        setState(() {
                          _selectedDay = selectedDay;
                          _focusedDay = focusedDay;
                        });
                      }
                    },
                    onFormatChanged: (format) {
                      if (_calendarFormat != format) {
                        setState(() {
                          _calendarFormat = format;
                        });
                      }
                    },
                    onPageChanged: (focusedDay) {
                      _focusedDay = focusedDay;
                    },
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        // cart = Hive.box<CartItem>('cart');
                        // var item = cart.get(attributeId);
                        // item?.startDate =
                        //     "${subScibeController.selectDay}-${subScibeController.selectMonth}-${subScibeController.selectYear}";
                        // cart.put(attributeId, item!);
                        Get.back();
                      },
                      child: Container(
                        height: 40,
                        width: Get.size.width * 0.8,
                        alignment: Alignment.center,
                        child: Text(
                          "Confirm".tr,
                          style: TextStyle(
                            fontFamily: FontFamily.gilroyBold,
                            fontSize: 15,
                            color: WhiteColor,
                          ),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: gradient.btnGradient,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
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
          );
        });
      }),
    );
  }

  //!---------Coupon Dialoag-----------!//
  Future couponSucsessFullyApplyed() {
    return Get.defaultDialog(
      title: "",
      content: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            // height: 270,
            width: Get.size.width,
            margin: EdgeInsets.symmetric(horizontal: 20),
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Container(
                  height: 80,
                  width: 100,
                  decoration: BoxDecoration(
                    color: transparent,
                    image: DecorationImage(
                      image: AssetImage("assets/discount-voucher.png"),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "${"Yey! You've saved".tr} ${currency}${cartController.couponAmt} ${"With this coupon".tr}",
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  style: TextStyle(
                    fontFamily: FontFamily.gilroyExtraBold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Supporting small businesses has never been so rewarding!".tr,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: TextStyle(
                    fontFamily: FontFamily.gilroyMedium,
                    height: 1.2,
                    fontSize: 15,
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Text(
                    "Awesome!".tr,
                    style: TextStyle(
                      fontFamily: FontFamily.gilroyBold,
                      color: gradient.defoultColor,
                      fontSize: 17,
                    ),
                  ),
                )
              ],
            ),
            decoration: BoxDecoration(
              color: WhiteColor,
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          Positioned(
            top: -160,
            left: 0,
            right: 0,
            child: Container(
              color: transparent,
              child: Lottie.asset(
                'assets/L6o2mVij1E.json',
                repeat: false,
                fit: BoxFit.fill,
              ),
            ),
          )
        ],
      ),
    );
  }

  //!---------Address Sheet-----------!//
  Future addressShit() {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Wrap(
          children: [
            Container(
              height: Get.height * 0.72,
              width: Get.size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20, top: 15),
                    child: Text(
                      "Choose a delivery address".tr,
                      style: TextStyle(
                        color: BlackColor,
                        fontFamily: FontFamily.gilroyBold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Container(
                    height: 100,
                    width: Get.size.width,
                    margin: EdgeInsets.all(15),
                    child: Row(
                      children: [
                        Container(
                          height: 100,
                          width: 80,
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/ChooseAddress.png"),
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "${storeDataContoller.storeDataInfo?.storeInfo.storeTitle ?? ""} ${"Will manage delivery and send tracking updates for the selected address".tr}",
                            maxLines: 3,
                            style: TextStyle(
                              fontFamily: FontFamily.gilroyMedium,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Color(0xFFeef4ff),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () {
                      Get.back();
                      Get.toNamed(Routes.deliveryaddress1);
                    },
                    child: Row(
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                        Container(
                          height: 35,
                          width: 50,
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.add,
                            color: gradient.defoultColor,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: gradient.defoultColor),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: Get.size.width * 0.5,
                          child: Text(
                            "Add New Address".tr,
                            style: TextStyle(
                              fontFamily: FontFamily.gilroyBold,
                              color: gradient.defoultColor,
                              fontSize: 17,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  GetBuilder<CartController>(builder: (context) {
                    return Expanded(
                      child: cartController.isLoading
                          // ? cartController.addressInfo?.addressList.isNotEmpty
                              ? ListView.builder(
                                  itemCount: cartController
                                      .addressInfo?.addressList.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            status = false;
                                            walletCalculation(false);
                                            setState(() {});
                                            total = total +
                                                cartController.couponAmt;
                                            cartController.couponAmt = 0;
                                            couponCode = "";
                                            save("clc", true);
                                            setState(() {});
                                            cartController.getAddress(
                                              aLat: cartController.addressInfo
                                                  ?.addressList[index].aLat,
                                              aLong: cartController.addressInfo
                                                  ?.addressList[index].aLong,
                                              aTitle: cartController
                                                      .addressInfo
                                                      ?.addressList[index]
                                                      .address ??
                                                  "",
                                              aType1: cartController
                                                      .addressInfo
                                                      ?.addressList[index]
                                                      .aType ??
                                                  "",
                                            );
                                            cartController.getCartDataApi(
                                                storeID:
                                                    storeDataContoller.storeid);
                                            print("========+++++++++========" +
                                                cartController.cartDataInfo!
                                                    .storeData.restDcharge
                                                    .toString());
                                            Get.back();
                                          },
                                          child: Container(
                                            // height: 70,
                                            width: Get.size.width,
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 8),
                                            padding: EdgeInsets.all(10),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Container(
                                                  height: 40,
                                                  width: 40,
                                                  alignment: Alignment.center,
                                                  child: Image.asset(
                                                    "assets/location-pin.png",
                                                    height: 25,
                                                    width: 25,
                                                    color:
                                                        gradient.defoultColor,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    border: Border.all(
                                                        color: Colors
                                                            .grey.shade300),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 15,
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        cartController
                                                                .addressInfo
                                                                ?.addressList[
                                                                    index]
                                                                .aType ??
                                                            "",
                                                        style: TextStyle(
                                                          fontFamily: FontFamily
                                                              .gilroyBold,
                                                          fontSize: 17,
                                                          color: BlackColor,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                        cartController
                                                                .addressInfo
                                                                ?.addressList[
                                                                    index]
                                                                .address ??
                                                            "",
                                                        maxLines: 3,
                                                        style: TextStyle(
                                                          fontFamily: FontFamily
                                                              .gilroyMedium,
                                                          color: greycolor,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15),
                                          child: Divider(),
                                        ),
                                      ],
                                    );
                                  },
                                )
                              : Center(
                                  child: Text(
                                    "Add Your Address".tr,
                                    style: TextStyle(
                                      fontFamily: FontFamily.gilroyBold,
                                      fontSize: 15,
                                      color: BlackColor,
                                    ),
                                  ),
                                )
                          // : Center(
                          //     child: CircularProgressIndicator(
                          //       color: gradient.defoultColor,
                          //     ),
                          //   ),
                    );
                  }),
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
          ],
        );
      },
    );
  }

  Widget deliveryWidget() {
    return Container(
      width: Get.size.width,
      padding: EdgeInsets.symmetric(horizontal: 10),
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: GetBuilder<CartController>(builder: (context) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // cartController.addresTitle == ""
                      //     ? Text(
                      //         "Select delivery address".tr,
                      //         style: TextStyle(
                      //           fontFamily: FontFamily.gilroyBold,
                      //           fontSize: 17,
                      //         ),
                      //       )
                      //     :
                      TextField(
                        controller: _textEditingController,
                        decoration: InputDecoration(
                          labelText: 'Enter Address',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (text) {
                          // Do something with the text input
                          print('Input text: $text');
                          cartController.getAddress(aTitle:_textEditingController.text );
                        },
                      ),
                      // Text(
                      //         cartController.addresTitle,
                      //         style: TextStyle(
                      //           fontFamily: FontFamily.gilroyBold,
                      //           fontSize: 15,
                      //         ),
                      //       ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "We deliver items to this address.".tr,
                        style: TextStyle(
                          fontFamily: FontFamily.gilroyMedium,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  );
                }),
              ),
              // InkWell(
              //   onTap: () {
              //     cartController.addressListApi();
              //     addressShit();
              //   },
              //   child: Container(
              //     height: 50,
              //     width: 90,
              //     alignment: Alignment.center,
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         Image.asset(
              //           "assets/location-pin.png",
              //           height: 25,
              //           width: 25,
              //           color: gradient.defoultColor,
              //         ),
              //         SizedBox(
              //           width: 5,
              //         ),
              //         Image.asset(
              //           "assets/angle-down.png",
              //           height: 15,
              //           width: 15,
              //           color: gradient.defoultColor,
              //         )
              //       ],
              //     ),
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(10),
              //       border: Border.all(color: Colors.grey.shade300),
              //     ),
              //   ),
              // )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          DottedLine(
            dashColor: greyColor,
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            "${"The order delivery is managed by".tr} ${storeDataContoller.storeDataInfo?.storeInfo.storeTitle ?? ""}. ${"Orders are usually dispatched in 3 - 5 day".tr}",
            maxLines: 2,
            style: TextStyle(
              fontFamily: FontFamily.gilroyMedium,
              fontSize: 15,
              height: 1.2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          DottedLine(
            dashColor: greyColor,
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
      decoration: BoxDecoration(
        color: WhiteColor,
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }

  Widget selfPickUpWidget() {
    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          width: Get.size.width,
          padding: EdgeInsets.symmetric(horizontal: 10),
          margin: EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Pickup from Stores".tr,
                          style: TextStyle(
                            fontFamily: FontFamily.gilroyBold,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "You required to collect medicine from Below address"
                              .tr,
                          maxLines: 2,
                          style: TextStyle(
                            fontFamily: FontFamily.gilroyMedium,
                            fontSize: 15,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Image.asset(
                    "assets/selfPickupPin.png",
                    height: 70,
                    width: 70,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              DottedLine(
                dashColor: greyColor,
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  // Image.asset(
                  //   "assets/location-pin.png",
                  //   height: 25,
                  //   width: 25,
                  // ),
                  SizedBox(
                    width: 10,
                  ),
                  GetBuilder<CartController>(builder: (context) {
                    return Expanded(
                      child: Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                        child: TextField(
                          controller: _textEditingController,
                          decoration: InputDecoration(
                            labelText: 'Enter Address',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (text) {
                            // Do something with the text input
                            print('Input text: $text');
                            cartController.getAddress(aTitle:_textEditingController.text);
                          },
                        ),
                      ),
                    );
                  })
                ],
              ),
              SizedBox(
                height: 15,
              ),
              DottedLine(
                dashColor: greyColor,
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
          decoration: BoxDecoration(
            color: WhiteColor,
            borderRadius: BorderRadius.circular(15),
          ),
        );
      },
    );
  }

  //!---------CameraAndGallery----------!//
  Future cameraAndGallarySheet() {
    return Get.bottomSheet(
      Container(
        height: 150,
        width: Get.size.width,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              onTap: () {
                _openCamera(context);
              },
              child: Container(
                height: 50,
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    Image.asset(
                      "assets/camera-circle.png",
                      height: 30,
                      width: 30,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      "CAMERA".tr,
                      style: TextStyle(
                        fontFamily: FontFamily.gilroyBold,
                        fontSize: 16,
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
            InkWell(
              onTap: () {
                _openGallery(context);
              },
              child: Container(
                height: 50,
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    Image.asset(
                      "assets/image-gallery.png",
                      height: 30,
                      width: 30,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      "GALLARY".tr,
                      style: TextStyle(
                        fontFamily: FontFamily.gilroyBold,
                        fontSize: 16,
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
        decoration: BoxDecoration(
          color: WhiteColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
      ),
    );
  }

  void _openGallery(BuildContext context) async {
    List<XFile> images = await ImagePicker().pickMultiImage();
    if (images.isNotEmpty) {
      for (var i = 0; i < images.length; i++) {
        preScriptionControllre.path.add(images[i].path);
      }
      setState(() {});
      Get.back();
    }
  }

  void _openCamera(BuildContext context) async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      preScriptionControllre.path.add(pickedFile.path);
      setState(() {});
      Get.back();
    } else {
      print("Null Image");
    }
  }

  Future<void> onAddItem(int index, String qtys, {String? object}) async {
    String? id = cartViewList[index].id.toString();
    String? price = cartViewList[index].productPrice.toString();
    int? qty = int.parse(qtys);
    String? isRequride = cartViewList[index].isRequride;
    qty = qty + 1;
    final newItem = CartItem();
    cart = Hive.box<CartItem>('cart');
    newItem.id = id;
    newItem.quantity = qty;
    newItem.strTitle = cartViewList[index].strTitle ?? "";
    newItem.per = cartViewList[index].per.toString();
    newItem.isRequride = isRequride;
    newItem.sPrice = double.parse(cartViewList[index].sPrice.toString());
    newItem.img = cartViewList[index].img;
    newItem.productTitle = cartViewList[index].productTitle;
    newItem.selectDelivery = cartViewList[index].selectDelivery;
    newItem.startDate = cartViewList[index].startDate;
    newItem.startTime = cartViewList[index].startTime;
    if (qtys == "0") {
      cart.put(id, newItem);
    } else {
      var item = cart.get(id);
      item?.quantity = qty;
      print("------------${item?.quantity.toString()}");
      cart.put(id, item!);
      cartViewList = listOfCart();
    }
  }

  void onRemoveItem(int index, String qtys) {
    String? id = cartViewList[index].id.toString();
    String? price = cartViewList[index].productPrice.toString();
    int? qty = int.parse(qtys);
    qty = qty - 1;
    if (qtys == "1") {
      cart.delete(id);
      save("subClc", true);
      cartController.subTotal = 0;
      catDetailsController.getCartLangth();
      cartViewList = listOfCart();
    } else {
      var item = cart.get(id);
      item?.quantity = qty;
      cart.put(id, item!);
      cartController.getSubTotalClc(
          pPrice: cartViewList[index].price, subdiv: "div");
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

  List<CartItem> listOfCart() {
    List<CartItem> tempList = [];
    cartController.isRq = [];
    maxDelivery = [];
    print("&&&&&&&&&&&&&&&&&&&&" + cart.values.length.toString());
    for (var element in cart.values) {
      CartItem item = CartItem();
      // print(element.storeID.toString());
      // print(storeDataContoller.storeid.toString());
      if (element.storeID == storeDataContoller.storeid) {
        print("iiiiiiiiiiiiiiii" + element.id.toString());
        item.id = element.id;
        item.price = element.price;
        item.quantity = element.quantity;
        item.productPrice = element.price;
        item.strTitle = element.strTitle;
        item.per = element.per;
        item.isRequride = element.isRequride;
        item.storeID = element.storeID;
        item.sPrice = element.sPrice;
        item.img = element.img;
        item.productTitle = element.productTitle;
        item.selectDelivery = element.selectDelivery;
        item.startDate = element.startDate;
        item.startTime = element.startTime;
        item.daysList = element.daysList;
        item.cartCheck = element.cartCheck;
        item.productID = element.productID;
        print("________________" + element.selectDelivery.toString());
        if (element.cartCheck == "1") {
          // maxDelivery.add(
          //     int.parse(element.selectDelivery.toString().split(" ").first));
          maxDelivery.add(int.parse("1"));
        }
        if (getData.read("subClc") == true) {
          if (element.cartCheck == "0") {
            print("...........0............");
            setState(() {
              cartController.subTotal = cartController.subTotal +
                  (double.parse(
                          element.productPrice?.toStringAsFixed(2).toString() ??
                              "") *
                      int.parse(element.quantity.toString()));
            });
          } else if (element.cartCheck == "1") {
            print("............1............");
            setState(() {
              cartController.subTotal = cartController.subTotal +
                  (double.parse(element.productPrice
                                  ?.toStringAsFixed(2)
                                  .toString() ??
                              "") *
                          int.parse(element.quantity.toString())) *
                      int.parse(
                          "1");
              // if (element.selectDelivery != "") {
              //   cartController.subTotal = cartController.subTotal +
              //       (double.parse(element.productPrice
              //                   ?.toStringAsFixed(2)
              //                   .toString() ??
              //               "") *
              //           int.parse(element.selectDelivery
              //               .toString()
              //               .split(" ")
              //               .first));
              // }
            });
          }
        }
        print("SSSSSSSSSSSSSSS" + cartController.subTotal.toString());
        tempList.add(item);
        if (element.isRequride == "1") {
          cartController.isRq.add(element.isRequride);
        }
        setState(() {});
      }
    }
    if (cartController.isRq.isEmpty) {
      preScriptionControllre.path = [];
    }
    if (maxDelivery.isNotEmpty) {
      setState(() {
        getMaxDelivery = maxDelivery.reduce(max);
      });
    }
    print("------------(Max)-----------" + getMaxDelivery.toString());
    save("subClc", false);
    return tempList;
  }

  //! ------------- Wallet Clc ----------- !//
  walletCalculation(value) {
    if (value == true) {
      if (double.parse(wallet.toString()) < double.parse(total.toString())) {
        tempWallet =
            double.parse(total.toString()) - double.parse(wallet.toString());
        useWallet = double.parse(wallet.toString());
        total =
            (double.parse(total.toString()) - double.parse(wallet.toString()));
        tempWallet = 0;
        setState(() {});
      } else {
        tempWallet =
            double.parse(wallet.toString()) - double.parse(total.toString());
        useWallet = double.parse(wallet.toString()) - tempWallet;
        total = 0;
      }
    } else {
      tempWallet = 0;
      tempWallet = double.parse(wallet.toString());
      total = total + useWallet;
      useWallet = 0;
      setState(() {});
    }
  }

  //!-------- PaymentSheet --------//
  Future paymentSheett() {
    return showModalBottomSheet(
      backgroundColor: WhiteColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      context: context,
      builder: (context) {
        return Wrap(children: [
          StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 10),
                Center(
                  child: Container(
                    height: Get.height / 80,
                    width: Get.width / 5,
                    decoration: const BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                  ),
                ),
                SizedBox(height: Get.height / 50),
                Row(children: [
                  SizedBox(width: Get.width / 14),
                  Text("Select Payment Method".tr,
                      style: TextStyle(
                          color: BlackColor,
                          fontSize: Get.height / 40,
                          fontFamily: FontFamily.gilroyBold)),
                ]),
                SizedBox(height: Get.height / 50),
                //! --------- List view paymente ----------
                SizedBox(
                  height: Get.height * 0.50,
                  child: GetBuilder<CartController>(builder: (context) {
                    return cartController.isLoading
                        ? ListView.builder(
                            shrinkWrap: true,
                            itemCount:
                                cartController.cartDataInfo?.paymentData.length,
                            itemBuilder: (ctx, i) {
                              return cartViewList[0].cartCheck == "1" &&
                                      cartController.cartDataInfo
                                              ?.paymentData[i].title ==
                                          "Cash On Delivery"
                                  ? SizedBox()
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: sugestlocationtype(
                                        borderColor: selectidPay ==
                                                cartController.cartDataInfo
                                                    ?.paymentData[i].id
                                            ? gradient.defoultColor
                                            : const Color(0xffD6D6D6),
                                        title: cartController.cartDataInfo
                                                    ?.storeData.storeIsPickup ==
                                                "1"
                                            ? groupValue == 0
                                                ? cartController
                                                            .cartDataInfo
                                                            ?.paymentData[i]
                                                            .title ==
                                                        "Cash On Delivery"
                                                    ? "Pay at Store"
                                                    : cartController
                                                            .cartDataInfo
                                                            ?.paymentData[i]
                                                            .title ??
                                                        ""
                                                : cartController
                                                        .cartDataInfo
                                                        ?.paymentData[i]
                                                        .title ??
                                                    ""
                                            : cartController.cartDataInfo
                                                    ?.paymentData[i].title ??
                                                "",
                                        titleColor: BlackColor,
                                        val: 0,
                                        image: Config.imageUrl +
                                            cartController.cartDataInfo!
                                                .paymentData[i].img,
                                        adress: cartController.cartDataInfo
                                                    ?.storeData.storeIsPickup ==
                                                "1"
                                            ? groupValue == 0
                                                ? cartController
                                                            .cartDataInfo
                                                            ?.paymentData[i]
                                                            .title ==
                                                        "Cash On Delivery"
                                                    ? "Stores may also accept personal checks or money orders as payment."
                                                    : cartController
                                                            .cartDataInfo
                                                            ?.paymentData[i]
                                                            .subtitle ??
                                                        ""
                                                : cartController
                                                        .cartDataInfo
                                                        ?.paymentData[i]
                                                        .subtitle ??
                                                    ""
                                            : cartController.cartDataInfo
                                                    ?.paymentData[i].subtitle ??
                                                "",
                                        ontap: () async {
                                          setState(() {
                                            razorpaykey = cartController
                                                .cartDataInfo!
                                                .paymentData[i]
                                                .attributes;
                                            paymenttital = cartController
                                                .cartDataInfo!
                                                .paymentData[i]
                                                .title;
                                            selectidPay = cartController
                                                .cartDataInfo!
                                                .paymentData[i]
                                                .id;
                                            _groupValue = i;
                                          });
                                        },
                                        radio: Radio(
                                          activeColor: gradient.defoultColor,
                                          value: i,
                                          groupValue: _groupValue,
                                          onChanged: (value) {
                                            setState(() {});
                                          },
                                        ),
                                      ),
                                    );
                            },
                          )
                        : Center(
                            child: CircularProgressIndicator(
                              color: gradient.defoultColor,
                            ),
                          );
                  }),
                ),
                Container(
                  height: 80,
                  width: Get.size.width,
                  alignment: Alignment.center,
                  child: GestButton(
                    Width: Get.size.width,
                    height: 50,
                    margin: EdgeInsets.only(top: 10, left: 30, right: 30),
                    buttontext: "Continue".tr,
                    style: TextStyle(
                      fontFamily: FontFamily.gilroyBold,
                      color: WhiteColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    onclick: () async {
                      // //!---- Stripe Payment ------
                      if (paymenttital == "Razorpay") {
                        cartController.setOrderLoading();
                        Get.back();
                        openCheckout();
                      } else if (paymenttital == "Cash On Delivery") {
                        cartController.setOrderLoading();
                        Get.back();
                        if (widget.CartStatus == "1") {
                          if (cartViewList[0].cartCheck == "0") {
                            buyNormalOrderInStore("0");
                          } else {
                            subScriptionOrderInStore("0");
                          }
                        } else {
                          // priscriptionOrderComplete("0");
                        }
                      } else if (paymenttital == "Paypal") {
                        cartController.setOrderLoading();
                        paypalPayment(total.toString());
                      } else if (paymenttital == "Stripe") {
                        Get.back();
                        stripePayment();
                      } else if (paymenttital == "Paystack") {
                        String key = razorpaykey.split(",").first;
                        print("**********(Key)*********" + key.toString());
                        await plugin.initialize(publicKey: key);
                        cartController.setOrderLoading();
                        chargeCard(
                          int.parse(total.toString().split(".").first),
                          getData.read("UserLogin")["email"],
                        );
                      } else if (paymenttital == "Flutterwave") {
                        cartController.setOrderLoading();
                        Get.to(() => Flutterwave(
                                  totalAmount: total.toString(),
                                  email: getData
                                      .read("UserLogin")["email"]
                                      .toString(),
                                ))!
                            .then((otid) {
                          if (otid != null) {
                            if (widget.CartStatus == "1") {
                              if (cartViewList[0].cartCheck == "0") {
                                buyNormalOrderInStore(otid);
                              } else {
                                subScriptionOrderInStore(otid);
                              }
                            } else {
                              // priscriptionOrderComplete(otid);
                            }
                          } else {
                            Get.back();
                          }
                        });
                      } else if (paymenttital == "Paytm") {
                        cartController.setOrderLoading();
                        Get.to(() => PayTmPayment(
                                  totalAmount: total.toString(),
                                  uid: getData
                                      .read("UserLogin")["id"]
                                      .toString(),
                                ))!
                            .then((otid) {
                          if (otid != null) {
                            if (widget.CartStatus == "1") {
                              if (cartViewList[0].cartCheck == "0") {
                                buyNormalOrderInStore(otid);
                              } else {
                                subScriptionOrderInStore(otid);
                              }
                            } else {
                              // priscriptionOrderComplete(otid);
                            }
                          } else {
                            Get.back();
                          }
                        });
                      } else if (paymenttital == "SenangPay") {
                        print(paymenttital.toString());
                      } else if (paymenttital == "SSLCOMMERZ") {}
                    },
                  ),
                  decoration: BoxDecoration(
                    color: WhiteColor,
                  ),
                ),
              ],
            );
          }),
        ]);
      },
    );
  }

  Widget sugestlocationtype(
      {Function()? ontap,
      title,
      val,
      image,
      adress,
      radio,
      Color? borderColor,
      Color? titleColor}) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return InkWell(
        splashColor: Colors.transparent,
        onTap: ontap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Get.width / 18),
          child: Container(
            height: Get.height / 10,
            decoration: BoxDecoration(
                border: Border.all(color: borderColor!, width: 1),
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(11)),
            child: Row(
              children: [
                SizedBox(width: Get.width / 55),
                Container(
                    height: Get.height / 12,
                    width: Get.width / 5.5,
                    decoration: BoxDecoration(
                        color: const Color(0xffF2F4F9),
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: FadeInImage(
                          placeholder: const AssetImage("assets/loading2.gif"),
                          image: NetworkImage(image)),
                      // Image.network(image, height: Get.height / 08)
                    )),
                SizedBox(width: Get.width / 30),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: Get.height * 0.01),
                    Text(title,
                        style: TextStyle(
                          fontSize: Get.height / 55,
                          fontFamily: FontFamily.gilroyBold,
                          color: titleColor,
                        )),
                    SizedBox(
                      width: Get.width * 0.50,
                      child: Text(adress,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: Get.height / 65,
                              fontFamily: 'Gilroy_Medium',
                              color: Colors.grey)),
                    ),
                  ],
                ),
                const Spacer(),
                radio,
                SizedBox(
                  width: 10,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  buyNormalOrderInStore(otid) {
    cartController.normalOrderApi(
      cartViewList,
      storeId: storeDataContoller.storeid,
      orderType: cartController.cartDataInfo?.storeData.storeIsPickup == "1"
          ? groupValue == 0
              ? "Self Pickup"
              : "Delivery"
          : "Delivery",
      mobile: getData.read("UserLogin")['mobile'],
      name: getData.read("UserLogin")['name'],
      anote: writeinstruction.text != "" ? writeinstruction.text : "",
      storeCharge:
          cartController.cartDataInfo?.storeData.storeCharge.toString() ?? "",
      subTotal: cartController.subTotal.toString(),
      total: getTotal.toString(),
      otid: otid.toString(),
      ndate: formattedDate,
      wallAmt: useWallet.toString(),
      couId: cartController.couponId != ""
          ? cartController.couponId.toString()
          : "0",
      couAmt: cartController.couponAmt != 0.0
          ? cartController.couponAmt.toString()
          : "0",
      dCharge: cartController.cartDataInfo?.storeData.storeIsPickup == "1"
          ? groupValue == 0
              ? "0"
              : cartController.cartDataInfo?.storeData.restDcharge.toString() ??
                  ""
          : cartController.cartDataInfo?.storeData.restDcharge.toString() ?? "",
      fullAddress: cartController.getAddress(aTitle:_textEditingController.text ),
      // cartController.cartDataInfo?.storeData.storeIsPickup == "1"
      //     ? groupValue == 0
      //         ? cartController.cartDataInfo?.storeData.storeFullAddress ?? ""
      //         : cartController.addresTitle
      //     : cartController.addresTitle,
      landMark: "",
      pMethod: double.parse(total.toString()) > 0 ? selectidPay ?? "" : "3",
      type: "Normal",
      tSlot: timeSlot != "" ? timeSlot : "0",
    );
  }

  subScriptionOrderInStore(otid) {
    cartController.subscriptionOrderApi(
      cartViewList,
      storeId: storeDataContoller.storeid,
      mobile: getData.read("UserLogin")['mobile'],
      name: getData.read("UserLogin")['name'],
      anote: writeinstruction.text != "" ? writeinstruction.text : "",
      storeCharge:
          "${double.parse(cartController.cartDataInfo?.storeData.storeCharge.toString() ?? "") * getMaxDelivery}",
      subTotal: cartController.subTotal.toString(),
      total: getTotal.toString(),
      otid: otid.toString(),
      walAmt: useWallet.toString(),
      couId: cartController.couponId != ""
          ? cartController.couponId.toString()
          : "0",
      couAmt: cartController.couponAmt != 0.0
          ? cartController.couponAmt.toString()
          : "0",
      dCharge: cartController.cartDataInfo?.storeData.storeIsPickup == "1"
          ? groupValue == 0
              ? "0"
              : "${double.parse(cartController.cartDataInfo?.storeData.restDcharge.toString() ?? "") * getMaxDelivery}"
          : "${double.parse(cartController.cartDataInfo?.storeData.restDcharge.toString() ?? "") * getMaxDelivery}",
      fullAddress: cartController.cartDataInfo?.storeData.storeIsPickup == "1"
          ? groupValue == 0
              ? cartController.cartDataInfo?.storeData.storeFullAddress ?? ""
              : cartController.addresTitle
          : cartController.addresTitle,
      landMark: "",
      pMethodId: double.parse(total.toString()) > 0 ? selectidPay ?? "" : "3",
      type: "Subscribe",
    );
  }

  @override
  void dispose() {
    numberController.removeListener(_getCardTypeFrmNumber);
    numberController.dispose();
    _razorpay.clear();
    super.dispose();
  }

  //!--------- Razorpay ----------//
  void openCheckout() async {
    var username = getData.read("UserLogin")["name"] ?? "";
    var mobile = getData.read("UserLogin")["mobile"] ?? "";
    var email = getData.read("UserLogin")["email"] ?? "";
    var options = {
      'key': razorpaykey,
      'amount': (double.parse(total.toString()) * 100).toString(),
      'name': username,
      'description': "",
      'timeout': 300,
      'prefill': {'contact': mobile, 'email': email},
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // buyOrderInStore(response.paymentId);
    if (widget.CartStatus == "1") {
      if (cartViewList[0].cartCheck == "0") {
        buyNormalOrderInStore(response.paymentId);
      } else {
        subScriptionOrderInStore(response.paymentId);
      }
    } else {
      // priscriptionOrderComplete(response.paymentId);
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print(
        'Error Response: ${"ERROR: " + response.code.toString() + " - " + response.message!}');
    setState(() {
      cartController.isOrderLoading = false;
    });
    showToastMessage(response.message!);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    showToastMessage(response.walletName!);
  }

  //!--------- PayPal ----------//
  paypalPayment(String amt) {
    Get.back();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return UsePaypal(
            sandboxMode: true,
            clientId:
                "Aa0Yim_XLAz89S4cqO-kT4pK3QbFsruHvEm8zDYX_Y-wIKgsGyv4TzL84dGgtWYUoJqTvKUh0JonIaKa",
            secretKey:
                "ECZEZmIjx0j_3_RStM7eT3Bc0Ehdd_yW4slqTnCtNI8WtVOVL1qwRh__u1W_8qKygnPDs0XaviNlb7-z",
            returnURL:
                "https://www.sandbox.paypal.com/cgi-bin/webscr?cmd=_express-checkout&token=EC-35S7886705514393E",
            cancelURL: Config.paymentBaseUrl + "milkman/paypal/cancle.php",
            transactions: [
              {
                "amount": {
                  "total": amt,
                  "currency": "USD",
                  "details": {
                    "subtotal": amt,
                    "shipping": '0',
                    "shipping_discount": 0
                  }
                },
                "description": "The payment transaction description.",
                // "payment_options": {
                //   "allowed_payment_method":
                //       "INSTANT_FUNDING_SOURCE"
                // },
                "item_list": {
                  "items": [
                    {
                      "name": "A demo product",
                      "quantity": 1,
                      "price": amt,
                      "currency": "USD"
                    }
                  ],

                }
              }
            ],
            note: "Contact us for any questions on your order.",
            onSuccess: (Map params) {
              if (widget.CartStatus == "1") {
                // buyOrderInStore(params["paymentId"].toString());
                if (cartViewList[0].cartCheck == "0") {
                  buyNormalOrderInStore(params["paymentId"].toString());
                } else {
                  subScriptionOrderInStore(params["paymentId"].toString());
                }
              } else {
                // priscriptionOrderComplete(params["paymentId"].toString());
              }
            },
            onError: (error) {
              showToastMessage(error.toString());
            },
            onCancel: (params) {
              setState(() {
                cartController.isOrderLoading = false;
              });
              showToastMessage(params.toString());
            },
          );
        },
      ),
    );
  }

  //!--------- Stripe ----------//
  final _formKey = GlobalKey<FormState>();
  var numberController = TextEditingController();
  final _paymentCard = PaymentCardCreated();
  var _autoValidateMode = AutovalidateMode.disabled;
  bool isloading = false;

  final _card = PaymentCardCreated();
  stripePayment() {
    return showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      backgroundColor: WhiteColor,
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Ink(
                child: Column(
                  children: [
                    SizedBox(height: Get.height / 45),
                    Center(
                      child: Container(
                        height: Get.height / 85,
                        width: Get.width / 5,
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.4),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20))),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(height: Get.height * 0.03),
                          Text("Add Your payment information".tr,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  letterSpacing: 0.5)),
                          SizedBox(height: Get.height * 0.02),
                          Form(
                            key: _formKey,
                            autovalidateMode: _autoValidateMode,
                            child: Column(
                              children: [
                                const SizedBox(height: 16),
                                TextFormField(
                                  style: TextStyle(color: Colors.black),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(19),
                                    CardNumberInputFormatter()
                                  ],
                                  controller: numberController,
                                  onSaved: (String? value) {
                                    _paymentCard.number =
                                        CardUtils.getCleanedNumber(value!);

                                    CardTypee cardType =
                                        CardUtils.getCardTypeFrmNumber(
                                            _paymentCard.number.toString());
                                    setState(() {
                                      _card.name = cardType.toString();
                                      _paymentCard.type = cardType;
                                    });
                                  },
                                  onChanged: (val) {
                                    CardTypee cardType =
                                        CardUtils.getCardTypeFrmNumber(val);
                                    setState(() {
                                      _card.name = cardType.toString();
                                      _paymentCard.type = cardType;
                                    });
                                  },
                                  validator: CardUtils.validateCardNum,
                                  decoration: InputDecoration(
                                    prefixIcon: SizedBox(
                                      height: 10,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 14,
                                          horizontal: 6,
                                        ),
                                        child: CardUtils.getCardIcon(
                                          _paymentCard.type,
                                        ),
                                      ),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: gradient.defoultColor,
                                      ),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: gradient.defoultColor,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: gradient.defoultColor,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: gradient.defoultColor,
                                      ),
                                    ),
                                    hintText:
                                        "What number is written on card?".tr,
                                    hintStyle: TextStyle(color: Colors.grey),
                                    labelStyle: TextStyle(color: Colors.grey),
                                    labelText: "Number".tr,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  children: [
                                    Flexible(
                                      flex: 4,
                                      child: TextFormField(
                                        style: TextStyle(color: Colors.grey),
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                          LengthLimitingTextInputFormatter(4),
                                        ],
                                        decoration: InputDecoration(
                                            prefixIcon: SizedBox(
                                              height: 10,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 14),
                                                child: Image.asset(
                                                  'assets/card_cvv.png',
                                                  width: 6,
                                                  color: gradient.defoultColor,
                                                ),
                                              ),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: gradient.defoultColor,
                                              ),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: gradient.defoultColor,
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: gradient.defoultColor,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color:
                                                        gradient.defoultColor)),
                                            hintText:
                                                "Number behind the card".tr,
                                            hintStyle:
                                                TextStyle(color: Colors.grey),
                                            labelStyle:
                                                TextStyle(color: Colors.grey),
                                            labelText: 'CVV'),
                                        validator: CardUtils.validateCVV,
                                        keyboardType: TextInputType.number,
                                        onSaved: (value) {
                                          _paymentCard.cvv = int.parse(value!);
                                        },
                                      ),
                                    ),
                                    SizedBox(width: Get.width * 0.03),
                                    Flexible(
                                      flex: 4,
                                      child: TextFormField(
                                        style: TextStyle(color: Colors.black),
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                          LengthLimitingTextInputFormatter(4),
                                          CardMonthInputFormatter()
                                        ],
                                        decoration: InputDecoration(
                                          prefixIcon: SizedBox(
                                            height: 10,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 14),
                                              child: Image.asset(
                                                'assets/calender.png',
                                                width: 10,
                                                color: gradient.defoultColor,
                                              ),
                                            ),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: gradient.defoultColor,
                                            ),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: gradient.defoultColor,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: gradient.defoultColor,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: gradient.defoultColor,
                                            ),
                                          ),
                                          hintText: 'MM/YY',
                                          hintStyle:
                                              TextStyle(color: Colors.black),
                                          labelStyle:
                                              TextStyle(color: Colors.grey),
                                          labelText: "Expiry Date".tr,
                                        ),
                                        validator: CardUtils.validateDate,
                                        keyboardType: TextInputType.number,
                                        onSaved: (value) {
                                          List<int> expiryDate =
                                              CardUtils.getExpiryDate(value!);
                                          _paymentCard.month = expiryDate[0];
                                          _paymentCard.year = expiryDate[1];
                                        },
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height: Get.height * 0.055),
                                Container(
                                  alignment: Alignment.center,
                                  child: SizedBox(
                                    width: Get.width,
                                    child: CupertinoButton(
                                      onPressed: () {
                                        cartController.setOrderLoading();
                                        _validateInputs();
                                      },
                                      color: gradient.defoultColor,
                                      child: Text(
                                        "Pay ${currency}${total}",
                                        style: TextStyle(fontSize: 17.0),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: Get.height * 0.065),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }

  void _validateInputs() {
    final FormState form = _formKey.currentState!;
    if (!form.validate()) {
      setState(() {
        _autoValidateMode =
            AutovalidateMode.always; // Start validating on every change.
      });
      showToastMessage("Please fix the errors in red before submitting.".tr);
    } else {
      var username = getData.read("UserLogin")["name"] ?? "";
      var email = getData.read("UserLogin")["email"] ?? "";
      _paymentCard.name = username;
      _paymentCard.email = email;
      _paymentCard.amount = total.toString();
      form.save();

      Get.to(() => StripePaymentWeb(paymentCard: _paymentCard))!.then((otid) {
        Get.back();
        //! order Api call
        if (otid != null) {
          //! Api Call Payment Success
          // buyOrderInStore(otid);
          if (widget.CartStatus == "1") {
            if (cartViewList[0].cartCheck == "0") {
              buyNormalOrderInStore(otid);
            } else {
              subScriptionOrderInStore(otid);
            }
          } else {
            // priscriptionOrderComplete(otid);
          }
        }
      });
      showToastMessage("Payment card is valid".tr);
    }
  }

  void _getCardTypeFrmNumber() {
    String input = CardUtils.getCleanedNumber(numberController.text);
    CardTypee cardType = CardUtils.getCardTypeFrmNumber(input);
    setState(() {
      _paymentCard.type = cardType;
    });
  }

  //!-------- PayStack ----------//
  chargeCard(int amount, String email) async {
    Get.back();
    print(amount.toString());
    print(email.toString());
    var charge = Charge()
      ..amount = amount * 100
      ..reference = _getReference()
      ..putCustomField(
        'custom_id',
        '846gey6w',
      ) //to pass extra parameters to be retrieved on the response from Paystack
      ..email = email;

    CheckoutResponse response = await plugin.checkout(
      context,
      method: CheckoutMethod.card,
      charge: charge,
    );
    if (response.status == true) {
      if (widget.CartStatus == "1") {
        if (cartViewList[0].cartCheck == "0") {
          buyNormalOrderInStore(response.reference);
        } else {
          subScriptionOrderInStore(response.reference);
        }
      } else {
        // priscriptionOrderComplete(response.reference);
      }
      // buyOrderInStore(response.reference);
    } else {
      setState(() {
        cartController.isOrderLoading = false;
      });
      showToastMessage('Payment Failed!!!'.tr);
    }
  }

  String _getReference() {
    var platform = (Platform.isIOS) ? 'iOS' : 'Android';
    final thisDate = DateTime.now().millisecondsSinceEpoch;
    return 'ChargedFrom${platform}_$thisDate';
  }
}
