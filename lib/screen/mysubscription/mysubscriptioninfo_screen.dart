// ignore_for_file: prefer_const_constructors, sort_child_properties_last, sized_box_for_whitespace, prefer_typing_uninitialized_variables, prefer_interpolation_to_compose_strings, avoid_print, unused_local_variable, unnecessary_brace_in_string_interps, unnecessary_string_interpolations, non_constant_identifier_names, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:milkman/Api/config.dart';
import 'package:milkman/controller/catdetails_controller.dart';
import 'package:milkman/controller/stordata_controller.dart';
import 'package:milkman/controller/subscription_controller.dart';
import 'package:milkman/model/fontfamily_model.dart';
import 'package:milkman/screen/home_screen.dart';
import 'package:milkman/utils/Colors.dart';
import 'package:milkman/utils/Custom_widget.dart';
import 'package:milkman/utils/cart_item.dart';

class MySubscriptionInfo extends StatefulWidget {
  const MySubscriptionInfo({super.key});

  @override
  State<MySubscriptionInfo> createState() => _MySubscriptionInfoState();
}

class _MySubscriptionInfoState extends State<MySubscriptionInfo> {
  PreScriptionControllre preScriptionControllre = Get.find();
  CatDetailsController catDetailsController = Get.find();
  StoreDataContoller storeDataContoller = Get.find();

  String oID = Get.arguments["oID"];

  final note = TextEditingController();
  var selectedRadioTile;
  String? rejectmsg = '';

  late Box<CartItem> cart;
  late final List<CartItem> items;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      appBar: AppBar(
        leading: BackButton(
          color: BlackColor,
        ),
        title: Text(
          "${"Order ID:".tr} #$oID",
          style: TextStyle(
              fontFamily: FontFamily.gilroyBold,
              color: BlackColor,
              fontSize: 17),
        ),
        elevation: 0,
        backgroundColor: WhiteColor,
        // actions: [
        //   Container(
        //     height: Get.size.height,
        //     child: Column(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         SizedBox(
        //           height: 30,
        //           child: TextButton(
        //             onPressed: () {
        //               skipOrExtendSheet();
        //             },
        //             style: TextButton.styleFrom(
        //               side: BorderSide(
        //                 color: gradient.defoultColor,
        //               ),
        //             ),
        //             child: Text(
        //               "Vacation Mode".tr,
        //               style: TextStyle(
        //                 fontFamily: FontFamily.gilroyBold,
        //                 fontSize: 14,
        //                 color: gradient.defoultColor,
        //               ),
        //             ),
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        //   SizedBox(
        //     width: 5,
        //   ),
        // ],
      ),
      bottomNavigationBar: GetBuilder<PreScriptionControllre>(builder: (context) {
        return preScriptionControllre.sDetailsInfo?.orderProductList.isRate == "0" &&
                preScriptionControllre.sDetailsInfo?.orderProductList.orderStatus == "Completed"
            ? InkWell(
                onTap: () {
                  reviewSheet();
                },
                child: Container(
                  height: 45,
                  width: Get.size.width,
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  alignment: Alignment.center,
                  child: Text(
                    "Review".tr,
                    style: TextStyle(
                      fontFamily: FontFamily.gilroyBold,
                      fontSize: 17,
                      color: WhiteColor,
                    ),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: gradient.btnGradient,
                  ),
                ),
              )
            : SizedBox();
      }),
      body: GetBuilder<PreScriptionControllre>(builder: (context) {
        return SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: preScriptionControllre.isLoading
                ? Column(
                    children: [
                      SizedBox(height: Get.height * 0.02),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: WhiteColor),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Product Info".tr,
                              style: TextStyle(
                                fontFamily: FontFamily.gilroyBold,
                                fontSize: 14,
                                color: gradient.defoultColor,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            SizedBox(
                              height: 120,
                              width: double.infinity,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: preScriptionControllre.sDetailsInfo
                                    ?.orderProductList.orderProductData.length,
                                padding: EdgeInsets.zero,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      preScriptionControllre
                                          .changeIndexProductWise(index: index);
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      margin: EdgeInsets.all(5),
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 80,
                                            width: 100,
                                            padding: EdgeInsets.all(5),
                                            alignment: Alignment.center,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              child: FadeInImage.assetNetwork(
                                                placeholder:
                                                    "assets/ezgif.com-crop.gif",
                                                placeholderCacheHeight: 80,
                                                placeholderCacheWidth: 100,
                                                placeholderFit: BoxFit.cover,
                                                image:
                                                    "${Config.imageUrl}${preScriptionControllre.sDetailsInfo?.orderProductList.orderProductData[index].productImage}",
                                                height: 80,
                                                width: 100,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 100,
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 2),
                                              child: Text(
                                                "${preScriptionControllre.sDetailsInfo?.orderProductList.orderProductData[index].productName}",
                                                maxLines: 2,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontFamily:
                                                      FontFamily.gilroyBold,
                                                  color: greytext,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      decoration: BoxDecoration(
                                        border: preScriptionControllre
                                                    .currentIndex ==
                                                index
                                            ? Border.all(
                                                color: gradient.defoultColor)
                                            : Border.all(
                                                color: Colors.grey.shade300),
                                        // color: preScriptionControllre
                                        //             .currentIndex ==
                                        //         index
                                        //     ? Color(0xffdaedfd)
                                        //     : WhiteColor,
                                        color: WhiteColor,
                                        borderRadius: BorderRadius.circular(7),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: Get.size.height * 0.02),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Delivery Date".tr,
                              style: TextStyle(
                                fontFamily: FontFamily.gilroyBold,
                                fontSize: 14,
                                color: gradient.defoultColor,
                              ),
                            ),
                            SizedBox(
                              height: 60,
                              child: ListView.builder(
                                itemCount: preScriptionControllre
                                    .sDetailsInfo
                                    ?.orderProductList
                                    .orderProductData[
                                        preScriptionControllre.currentIndex]
                                    .totaldates
                                    .length,
                                scrollDirection: Axis.horizontal,
                                padding: EdgeInsets.zero,
                                itemBuilder: (context, index) {
                                  return Stack(
                                    children: [
                                      Container(
                                        height: 60,
                                        width: 50,
                                        margin: EdgeInsets.all(5),
                                        alignment: Alignment.center,
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 8),
                                        child: Text(
                                          preScriptionControllre
                                                  .sDetailsInfo
                                                  ?.orderProductList
                                                  .orderProductData[
                                                      preScriptionControllre
                                                          .currentIndex]
                                                  .totaldates[index]
                                                  .formatDate ??
                                              "",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: FontFamily.gilroyMedium,
                                            fontSize: 12,
                                            color: Colors.grey,
                                            height: 1.2,
                                            letterSpacing: 1,
                                          ),
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(7),
                                          border: preScriptionControllre
                                                      .sDetailsInfo
                                                      ?.orderProductList
                                                      .orderProductData[
                                                          preScriptionControllre
                                                              .currentIndex]
                                                      .totaldates[index]
                                                      .isComplete ==
                                                  1
                                              ? Border.all(
                                                  color: gradient.defoultColor)
                                              : Border.all(
                                                  color: Colors.grey.shade300),
                                        ),
                                      ),
                                      preScriptionControllre
                                                  .sDetailsInfo
                                                  ?.orderProductList
                                                  .orderProductData[
                                                      preScriptionControllre
                                                          .currentIndex]
                                                  .totaldates[index]
                                                  .isComplete ==
                                              1
                                          ? Positioned(
                                              right: 0,
                                              child: Container(
                                                height: 20,
                                                width: 20,
                                                padding: EdgeInsets.all(1),
                                                alignment: Alignment.center,
                                                child: Image.asset(
                                                  "assets/double-check.png",
                                                  color: WhiteColor,
                                                  height: 15,
                                                  width: 15,
                                                ),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: gradient.defoultColor,
                                                ),
                                              ),
                                            )
                                          : SizedBox(),
                                    ],
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: WhiteColor,
                        ),
                      ),
                      SizedBox(height: Get.size.height * 0.02),
                      Container(
                        padding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Delivery Month".tr,
                              style: TextStyle(
                                fontFamily: FontFamily.gilroyBold,
                                fontSize: 14,
                                color: gradient.defoultColor,
                              ),
                            ),
                            SizedBox(
                              height: 60,
                              child: ListView.builder(
                                itemCount: preScriptionControllre.sDetailsInfo?.orderProductList.orderProductData[preScriptionControllre.currentIndex].selectmonth.length ?? 0,
                                scrollDirection: Axis.horizontal,
                                padding: EdgeInsets.zero,
                                itemBuilder: (context, index) {
                                  return Stack(
                                    children: [
                                      Container(
                                        height: 60,
                                        width: 80,
                                        margin: EdgeInsets.all(5),
                                        alignment: Alignment.center,
                                        padding:
                                        EdgeInsets.symmetric(horizontal: 0),
                                        child: Text(
                                          preScriptionControllre.sDetailsInfo?.orderProductList.orderProductData[preScriptionControllre.currentIndex].selectmonth[index] ?? "",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: FontFamily.gilroyMedium,
                                            fontSize: 12,
                                            color: Colors.black45,
                                            height: 1.2,
                                            letterSpacing: 1,
                                          ),
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(7),
                                        ),
                                      ),
                                      // preScriptionControllre.sDetailsInfo?.orderProductList.orderProductData[
                                      // preScriptionControllre.currentIndex].totaldates[index].isComplete == 1
                                      //     ? Positioned(
                                      //   right: 0,
                                      //   child: Container(
                                      //     height: 20,
                                      //     width: 20,
                                      //     padding: EdgeInsets.all(1),
                                      //     alignment: Alignment.center,
                                      //     child: Image.asset(
                                      //       "assets/double-check.png",
                                      //       color: WhiteColor,
                                      //       height: 15,
                                      //       width: 15,
                                      //     ),
                                      //     decoration: BoxDecoration(
                                      //       shape: BoxShape.circle,
                                      //       color: gradient.defoultColor,
                                      //     ),
                                      //   ),
                                      // )
                                      //     : SizedBox(),
                                    ],
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: WhiteColor,
                        ),
                      ),
                      SizedBox(height: Get.size.height * 0.02),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Item Info".tr,
                              style: TextStyle(
                                fontFamily: FontFamily.gilroyBold,
                                fontSize: 14,
                                color: gradient.defoultColor,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Price".tr,
                                        style: TextStyle(
                                          fontFamily: FontFamily.gilroyBold,
                                          fontSize: 13,
                                          color: greytext,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 2,
                                      ),
                                      Text(
                                        ":",
                                        style: TextStyle(
                                          fontFamily: FontFamily.gilroyBold,
                                          fontSize: 13,
                                          color: greytext,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "${currency}${preScriptionControllre.sDetailsInfo?.orderProductList.orderProductData[preScriptionControllre.currentIndex].productPrice}",
                                        style: TextStyle(
                                          fontFamily: FontFamily.gilroyBold,
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        "Total".tr,
                                        style: TextStyle(
                                          fontFamily: FontFamily.gilroyBold,
                                          fontSize: 13,
                                          color: greytext,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 2,
                                      ),
                                      Text(
                                        ":",
                                        style: TextStyle(
                                          fontFamily: FontFamily.gilroyBold,
                                          fontSize: 13,
                                          color: greytext,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "${currency}${preScriptionControllre.sDetailsInfo?.orderProductList.orderProductData[preScriptionControllre.currentIndex].productTotal}",
                                        style: TextStyle(
                                          fontFamily: FontFamily.gilroyBold,
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Variation".tr,
                                        style: TextStyle(
                                          fontFamily: FontFamily.gilroyBold,
                                          fontSize: 13,
                                          color: greytext,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 2,
                                      ),
                                      Text(
                                        ":",
                                        style: TextStyle(
                                          fontFamily: FontFamily.gilroyBold,
                                          fontSize: 13,
                                          color: greytext,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "${preScriptionControllre.sDetailsInfo?.orderProductList.orderProductData[preScriptionControllre.currentIndex].productVariation}",
                                        style: TextStyle(
                                          fontFamily: FontFamily.gilroyBold,
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        "Qty".tr,
                                        style: TextStyle(
                                          fontFamily: FontFamily.gilroyBold,
                                          fontSize: 13,
                                          color: greytext,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 2,
                                      ),
                                      Text(
                                        ":",
                                        style: TextStyle(
                                          fontFamily: FontFamily.gilroyBold,
                                          fontSize: 13,
                                          color: greytext,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "${preScriptionControllre.sDetailsInfo?.orderProductList.orderProductData[preScriptionControllre.currentIndex].productQuantity}",
                                        style: TextStyle(
                                          fontFamily: FontFamily.gilroyBold,
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Start Date".tr,
                                        style: TextStyle(
                                          fontFamily: FontFamily.gilroyBold,
                                          fontSize: 13,
                                          color: greytext,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 2,
                                      ),
                                      Text(
                                        ":",
                                        style: TextStyle(
                                          fontFamily: FontFamily.gilroyBold,
                                          fontSize: 13,
                                          color: greytext,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "${preScriptionControllre.sDetailsInfo?.orderProductList.orderProductData[preScriptionControllre.currentIndex].startdate.toString().split(" ").first}",
                                        style: TextStyle(
                                          fontFamily: FontFamily.gilroyBold,
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        "Total Delivery".tr,
                                        style: TextStyle(
                                          fontFamily: FontFamily.gilroyBold,
                                          fontSize: 13,
                                          color: greytext,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 2,
                                      ),
                                      Text(
                                        ":",
                                        style: TextStyle(
                                          fontFamily: FontFamily.gilroyBold,
                                          fontSize: 13,
                                          color: greytext,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "${preScriptionControllre.sDetailsInfo?.orderProductList.orderProductData[preScriptionControllre.currentIndex].totaldelivery}",
                                        style: TextStyle(
                                          fontFamily: FontFamily.gilroyBold,
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            OrderInfo(
                              title: "Delivery time".tr,
                              subtitle:
                                  "${preScriptionControllre.sDetailsInfo?.orderProductList.orderProductData[preScriptionControllre.currentIndex].deliveryTimeslot}",
                            )
                          ],
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: WhiteColor,
                        ),
                      ),
                      SizedBox(height: Get.height * 0.02),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        width: Get.size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Order Info".tr,
                              style: TextStyle(
                                fontFamily: FontFamily.gilroyBold,
                                fontSize: 14,
                                color: gradient.defoultColor,
                              ),
                            ),
                            SizedBox(
                              height: 13,
                            ),
                            OrderInfo(
                              title: "Subtotal".tr,
                              subtitle:
                                  "${currency}${preScriptionControllre.sDetailsInfo?.orderProductList.orderSubTotal}",
                            ),
                            SizedBox(
                              height: 13,
                            ),
                            OrderInfo(
                              title: "Delivery Charge".tr,
                              subtitle:
                                  "${currency}${preScriptionControllre.sDetailsInfo?.orderProductList.deliveryCharge}",
                            ),
                            SizedBox(
                              height: 13,
                            ),
                            OrderInfo(
                              title: "Store Charge".tr,
                              subtitle:
                                  "${currency}${preScriptionControllre.sDetailsInfo?.orderProductList.storeCharge}",
                            ),
                            preScriptionControllre.sDetailsInfo
                                        ?.orderProductList.couponAmount !=
                                    "0"
                                ? SizedBox(
                                    height: 13,
                                  )
                                : SizedBox(),
                            preScriptionControllre.sDetailsInfo
                                        ?.orderProductList.couponAmount !=
                                    "0"
                                ? OrderInfo(
                                    title: "Coupon Amount".tr,
                                    subtitle:
                                        "${currency}${preScriptionControllre.sDetailsInfo?.orderProductList.couponAmount}",
                                  )
                                : SizedBox(),
                            SizedBox(
                              height: 13,
                            ),
                            OrderInfo(
                              title: "Total".tr,
                              subtitle:
                                  "${currency}${preScriptionControllre.sDetailsInfo?.orderProductList.orderTotal}",
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Payment Method".tr,
                                  style: TextStyle(
                                    fontFamily: FontFamily.gilroyBold,
                                    fontSize: 13,
                                    color: greytext,
                                  ),
                                ),
                                SizedBox(
                                  width: 2,
                                ),
                                Text(
                                  ":",
                                  style: TextStyle(
                                    fontFamily: FontFamily.gilroyBold,
                                    fontSize: 13,
                                    color: greytext,
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                SizedBox(
                                  width: Get.size.width * 0.45,
                                  height: 35,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        preScriptionControllre.sDetailsInfo?.orderProductList.pMethodName ?? "",
                                        style: TextStyle(
                                          fontFamily: FontFamily.gilroyBold,
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        "(${preScriptionControllre.sDetailsInfo?.orderProductList.orderTransactionId})",
                                        style: TextStyle(
                                          fontFamily: FontFamily.gilroyBold,
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            // myOrderController.nDetailsInfo?.orderProductList
                            //             .deliveryTimeslot !=
                            //         "0"
                            //     ?

                            // : SizedBox(),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Address".tr,
                                  style: TextStyle(
                                    fontFamily: FontFamily.gilroyBold,
                                    fontSize: 13,
                                    color: greytext,
                                  ),
                                ),
                                SizedBox(
                                  width: 2,
                                ),
                                Text(
                                  ":",
                                  style: TextStyle(
                                    fontFamily: FontFamily.gilroyBold,
                                    fontSize: 13,
                                    color: greytext,
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                SizedBox(
                                  width: Get.size.width * 0.72,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        preScriptionControllre
                                                .sDetailsInfo
                                                ?.orderProductList
                                                .customerAddress ??
                                            "",
                                        maxLines: 3,
                                        style: TextStyle(
                                          fontFamily: FontFamily.gilroyBold,
                                          fontSize: 14,
                                          color: Colors.grey,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            preScriptionControllre.sDetailsInfo
                                        ?.orderProductList.orderStatus ==
                                    "Cancelled"
                                ? OrderInfo(
                                    title: "Cancel Comment".tr,
                                    subtitle: preScriptionControllre
                                        .sDetailsInfo
                                        ?.orderProductList
                                        .commentReject,
                                  )
                                : SizedBox(),
                          ],
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: WhiteColor,
                        ),
                      ),
                      SizedBox(height: Get.height * 0.02),
                      preScriptionControllre.sDetailsInfo?.orderProductList
                                  .additionalNote !=
                              ""
                          ? Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 12),
                              width: Get.size.width,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Addition Note".tr,
                                    style: TextStyle(
                                      fontFamily: FontFamily.gilroyBold,
                                      color: gradient.defoultColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    preScriptionControllre.sDetailsInfo
                                            ?.orderProductList.additionalNote ??
                                        "",
                                    style: TextStyle(
                                      fontFamily: FontFamily.gilroyBold,
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: WhiteColor,
                              ),
                            )
                          : SizedBox(),
                      preScriptionControllre
                                  .sDetailsInfo?.orderProductList.riderTitle !=
                              ""
                          ? Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 12),
                              width: Get.size.width,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Delivery Boy Info",
                                    style: TextStyle(
                                      fontFamily: FontFamily.gilroyBold,
                                      color: gradient.defoultColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 50,
                                    child: ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      leading: Container(
                                        height: 50,
                                        width: 50,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          child: FadeInImage.assetNetwork(
                                            placeholder:
                                                "assets/ezgif.com-crop.gif",
                                            placeholderCacheHeight: 50,
                                            placeholderCacheWidth: 50,
                                            placeholderFit: BoxFit.cover,
                                            image:
                                                "${Config.imageUrl}${preScriptionControllre.sDetailsInfo?.orderProductList.riderImage}",
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: greycolor,
                                        ),
                                      ),
                                      title: Text(
                                        preScriptionControllre.sDetailsInfo
                                                ?.orderProductList.riderTitle ??
                                            "",
                                        style: TextStyle(
                                          fontFamily: FontFamily.gilroyBold,
                                          fontSize: 15,
                                        ),
                                      ),
                                      subtitle: Text(
                                        preScriptionControllre
                                                .sDetailsInfo
                                                ?.orderProductList
                                                .riderMobile ??
                                            "",
                                        style: TextStyle(
                                          fontFamily: FontFamily.gilroyMedium,
                                          color: greytext,
                                          fontSize: 14,
                                        ),
                                      ),
                                      trailing: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8),
                                        child: Image.asset(
                                          "assets/phone-call.png",
                                          height: 25,
                                          width: 25,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                ],
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: WhiteColor,
                              ),
                            )
                          : SizedBox(),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  )
                : SizedBox(
                    height: Get.height,
                    width: Get.width,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: gradient.defoultColor,
                      ),
                    ),
                  ),
          ),
        );
      }),
    );
  }

  skipOrExtendSheet() {
    return Get.bottomSheet(
      isScrollControlled: true,
      GetBuilder<PreScriptionControllre>(builder: (context) {
        return Container(
          height: Get.size.height * 0.5,
          width: Get.size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: EdgeInsets.only(left: 15),
                child: Text(
                  "Choose Skip or Extend Vaction days".tr,
                  style: TextStyle(
                    fontFamily: FontFamily.gilroyBold,
                    fontSize: 18,
                    color: Colors.blueGrey,
                  ),
                ),
              ),
              SizedBox(
                height: 7,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: GridView.builder(
                    itemCount: preScriptionControllre
                        .sDetailsInfo
                        ?.orderProductList
                        .orderProductData[preScriptionControllre.currentIndex]
                        .totaldates
                        .length,
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      mainAxisExtent: 70,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 10,
                    ),
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          InkWell(
                            onTap: () {
                              if (preScriptionControllre
                                      .sDetailsInfo
                                      ?.orderProductList
                                      .orderProductData[
                                          preScriptionControllre.currentIndex]
                                      .totaldates[index]
                                      .isComplete ==
                                  0) {
                                preScriptionControllre.changeDateIndex(
                                  index: index,
                                  date: preScriptionControllre
                                      .sDetailsInfo
                                      ?.orderProductList
                                      .orderProductData[
                                          preScriptionControllre.currentIndex]
                                      .totaldates[index]
                                      .date
                                      .toString()
                                      .split(" ")
                                      .first,
                                );
                              }
                            },
                            child: Container(
                              height: 70,
                              alignment: Alignment.center,
                              margin: EdgeInsets.all(5),
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                preScriptionControllre
                                        .sDetailsInfo
                                        ?.orderProductList
                                        .orderProductData[
                                            preScriptionControllre.currentIndex]
                                        .totaldates[index]
                                        .formatDate ??
                                    "",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: FontFamily.gilroyMedium,
                                  fontSize: 13,
                                  color: Colors.grey,
                                  height: 1.2,
                                  letterSpacing: 1,
                                ),
                              ),
                              decoration: BoxDecoration(
                                color: WhiteColor,
                                borderRadius: BorderRadius.circular(8),
                                border: preScriptionControllre.selectDate
                                            .contains(preScriptionControllre
                                                .sDetailsInfo
                                                ?.orderProductList
                                                .orderProductData[
                                                    preScriptionControllre
                                                        .currentIndex]
                                                .totaldates[index]
                                                .date
                                                .toString()
                                                .split(" ")
                                                .first) &&
                                        preScriptionControllre
                                                .sDetailsInfo
                                                ?.orderProductList
                                                .orderProductData[
                                                    preScriptionControllre
                                                        .currentIndex]
                                                .totaldates[index]
                                                .isComplete ==
                                            0
                                    ? Border.all(color: gradient.defoultColor)
                                    : preScriptionControllre
                                                .sDetailsInfo
                                                ?.orderProductList
                                                .orderProductData[
                                                    preScriptionControllre
                                                        .currentIndex]
                                                .totaldates[index]
                                                .isComplete ==
                                            1
                                        ? Border.all(
                                            color: gradient.defoultColor)
                                        : Border.all(color: Colors.grey.shade300),
                              ),
                            ),
                          ),
                          preScriptionControllre.selectDate.contains(
                                      preScriptionControllre
                                          .sDetailsInfo
                                          ?.orderProductList
                                          .orderProductData[
                                              preScriptionControllre
                                                  .currentIndex]
                                          .totaldates[index]
                                          .date
                                          .toString()
                                          .split(" ")
                                          .first) &&
                                  preScriptionControllre
                                          .sDetailsInfo
                                          ?.orderProductList
                                          .orderProductData[
                                              preScriptionControllre
                                                  .currentIndex]
                                          .totaldates[index]
                                          .isComplete ==
                                      0
                              ? Positioned(
                                  right: 0,
                                  child: Container(
                                    height: 20,
                                    width: 20,
                                    padding: EdgeInsets.all(5),
                                    alignment: Alignment.center,
                                    child: Image.asset(
                                      "assets/right.png",
                                      color: WhiteColor,
                                      height: 15,
                                      width: 15,
                                    ),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: gradient.defoultColor,
                                    ),
                                  ),
                                )
                              : preScriptionControllre
                                          .sDetailsInfo
                                          ?.orderProductList
                                          .orderProductData[
                                              preScriptionControllre
                                                  .currentIndex]
                                          .totaldates[index]
                                          .isComplete ==
                                      1
                                  ? Positioned(
                                      right: 0,
                                      child: Container(
                                        height: 20,
                                        width: 20,
                                        padding: EdgeInsets.all(1),
                                        alignment: Alignment.center,
                                        child: Image.asset(
                                          "assets/double-check.png",
                                          color: WhiteColor,
                                          height: 15,
                                          width: 15,
                                        ),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: gradient.defoultColor,
                                        ),
                                      ),
                                    )
                                  : SizedBox(),
                        ],
                      );
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                height: 55,
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          if (preScriptionControllre.selectDate.isNotEmpty) {
                            preScriptionControllre.skipOrExtendDay(
                              itemId: preScriptionControllre
                                  .sDetailsInfo
                                  ?.orderProductList
                                  .orderProductData[
                                      preScriptionControllre.currentIndex]
                                  .subscribeId,
                              orderId: oID,
                              total: preScriptionControllre
                                  .sDetailsInfo
                                  ?.orderProductList
                                  .orderProductData[
                                      preScriptionControllre.currentIndex]
                                  .productTotal,
                              status: "skip",
                            );
                            Get.back();
                          } else {
                            showToastMessage("Please Select Data".tr);
                            Get.back();
                          }
                        },
                        child: Container(
                          height: 50,
                          width: Get.size.width,
                          alignment: Alignment.center,
                          margin:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: Text(
                            "Skip".tr,
                            style: TextStyle(
                              fontFamily: FontFamily.gilroyBold,
                              color: WhiteColor,
                              fontSize: 15,
                            ),
                          ),
                          decoration: BoxDecoration(
                            gradient: gradient.btnGradient,
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          if (preScriptionControllre.selectDate.isNotEmpty) {
                            preScriptionControllre.skipOrExtendDay(
                              itemId: preScriptionControllre
                                  .sDetailsInfo
                                  ?.orderProductList
                                  .orderProductData[
                                      preScriptionControllre.currentIndex]
                                  .subscribeId,
                              orderId: oID,
                              total: preScriptionControllre
                                  .sDetailsInfo
                                  ?.orderProductList
                                  .orderProductData[
                                      preScriptionControllre.currentIndex]
                                  .productTotal,
                              status: "extended",
                            );
                            Get.back();
                          } else {
                            showToastMessage("Please Select Data".tr);
                            Get.back();
                          }
                        },
                        child: Container(
                          height: 50,
                          width: Get.size.width,
                          alignment: Alignment.center,
                          margin:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: Text(
                            "Extend".tr,
                            style: TextStyle(
                              fontFamily: FontFamily.gilroyBold,
                              color: WhiteColor,
                              fontSize: 15,
                            ),
                          ),
                          decoration: BoxDecoration(
                            gradient: gradient.btnGradient,
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 8,
              ),
            ],
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            color: WhiteColor,
          ),
        );
      }),
    );
  }

  OrderInfo({String? title, subtitle}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          title ?? "",
          style: TextStyle(
            fontFamily: FontFamily.gilroyBold,
            fontSize: 13,
            color: greytext,
          ),
        ),
        SizedBox(
          width: 2,
        ),
        Text(
          ":",
          style: TextStyle(
            fontFamily: FontFamily.gilroyBold,
            fontSize: 13,
            color: greytext,
          ),
        ),
        SizedBox(
          width: 5,
        ),
        Text(
          subtitle ?? "",
          style: TextStyle(
            fontFamily: FontFamily.gilroyBold,
            fontSize: 14,
            color: Colors.grey,
          ),
        )
      ],
    );
  }

  Paymentinfo({String? text, infotext}) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text!,
              style: TextStyle(
                fontFamily: FontFamily.gilroyMedium,
                color: Colors.grey.shade400,
                fontSize: 14,
              ),
            ),
            Text(
              infotext,
              style: TextStyle(
                fontFamily: FontFamily.gilroyBold,
                color: BlackColor,
                fontSize: 15,
              ),
            ),
          ],
        ),
        SizedBox(height: Get.height * 0.015),
      ],
    );
  }

  Future reviewSheet() {
    return Get.bottomSheet(
      isScrollControlled: true,
      GetBuilder<PreScriptionControllre>(builder: (context) {
        return Container(
          height: 520,
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                "Leave a Review".tr,
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: FontFamily.gilroyBold,
                  color: BlackColor,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Divider(
                  color: greytext,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "How was your experience".tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                  fontFamily: FontFamily.gilroyBold,
                  color: BlackColor,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              RatingBar(
                initialRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                ratingWidget: RatingWidget(
                  full: Image.asset(
                    'assets/starBold.png',
                    color: gradient.defoultColor,
                  ),
                  half: Image.asset(
                    'assets/star-half.png',
                    color: gradient.defoultColor,
                  ),
                  empty: Image.asset(
                    'assets/star.png',
                    color: gradient.defoultColor,
                  ),
                ),
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                onRatingUpdate: (rating) {
                  preScriptionControllre.totalRateUpdate(rating);
                },
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Divider(
                  color: greytext,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 15),
                child: Text(
                  "Write Your Review".tr,
                  style: TextStyle(
                    fontSize: 17,
                    fontFamily: FontFamily.gilroyBold,
                    color: BlackColor,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(15),
                child: TextFormField(
                  controller: preScriptionControllre.ratingText,
                  minLines: 4,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  cursorColor: BlackColor,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    focusedBorder: InputBorder.none,
                    border: InputBorder.none,
                    hintText: "Your review here...".tr,
                    hintStyle: TextStyle(
                      fontFamily: FontFamily.gilroyMedium,
                      fontSize: 15,
                    ),
                  ),
                  style: TextStyle(
                    fontFamily: FontFamily.gilroyMedium,
                    fontSize: 16,
                    color: BlackColor,
                  ),
                ),
                decoration: BoxDecoration(
                  color: WhiteColor,
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Divider(
                  color: greytext,
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        height: 50,
                        margin: EdgeInsets.all(15),
                        alignment: Alignment.center,
                        child: Text(
                          "Maybe Later".tr,
                          style: TextStyle(
                            color: gradient.defoultColor,
                            fontFamily: FontFamily.gilroyBold,
                            fontSize: 16,
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: gradient.defoultColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(45),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        preScriptionControllre.orderReviewApi(orderID: oID);
                      },
                      child: Container(
                        height: 50,
                        margin: EdgeInsets.all(15),
                        alignment: Alignment.center,
                        child: Text(
                          "Submit".tr,
                          style: TextStyle(
                            color: WhiteColor,
                            fontFamily: FontFamily.gilroyBold,
                            fontSize: 16,
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: gradient.defoultColor,
                          borderRadius: BorderRadius.circular(45),
                        ),
                      ),
                    ),
                  )
                ],
              )
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
      }),
    );
  }
}
