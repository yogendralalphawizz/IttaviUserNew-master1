// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, sort_child_properties_last, must_be_immutable, unnecessary_brace_in_string_interps, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:milkman/Api/config.dart';
import 'package:milkman/controller/myorder_controller.dart';
import 'package:milkman/model/fontfamily_model.dart';
import 'package:milkman/screen/home_screen.dart';
import 'package:milkman/utils/Colors.dart';

class OrderdetailsScreen extends StatefulWidget {
  const OrderdetailsScreen({super.key});

  @override
  State<OrderdetailsScreen> createState() => _OrderdetailsScreenState();
}

class _OrderdetailsScreenState extends State<OrderdetailsScreen> {
  MyOrderController myOrderController = Get.find();

  String oID = Get.arguments["oID"];
  bool usercontect = false;

  @override
  void initState() {
    super.initState();
  }

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
          backgroundColor: WhiteColor),
      bottomNavigationBar: GetBuilder<MyOrderController>(builder: (context) {
        return myOrderController.nDetailsInfo?.orderProductList.isRate == "0" &&
                myOrderController.nDetailsInfo?.orderProductList.orderStatus ==
                    "Completed"
            ? InkWell(
                onTap: () {
                  reviewSheet();
                },
                child: Container(
                  height: 45,
                  width: Get.size.width,
                  margin:
                      EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
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
      body:  SingleChildScrollView(
        child: GetBuilder<MyOrderController>(builder: (context) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: myOrderController.isLoading
                ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: Get.height * 0.02),
                myOrderController.nDetailsInfo?.orderProductList
                    .orderProductData == true
                    ? Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 12, vertical: 12),
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
                          itemCount: myOrderController.nDetailsInfo?.orderProductList.orderProductData.length,
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {myOrderController.changeIndexProductWise(index: index);},
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
                                        BorderRadius.circular(
                                            5),
                                        child: FadeInImage.assetNetwork(
                                          placeholder:
                                          "assets/ezgif.com-crop.gif",
                                          placeholderCacheHeight: 80,
                                          placeholderCacheWidth: 100,
                                          placeholderFit: BoxFit.cover,
                                          image: "${Config.imageUrl}${myOrderController.nDetailsInfo?.orderProductList.orderProductData[index].productImage}",
                                          height: 80,
                                          width: 100,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 100,
                                      child: Text(
                                        "${myOrderController.nDetailsInfo?.orderProductList.orderProductData[index].productName}",
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
                                  ],
                                ),
                                decoration: BoxDecoration(
                                  border: myOrderController
                                      .currentIndex ==
                                      index
                                      ? Border.all(
                                      color:
                                      gradient.defoultColor)
                                      : Border.all(
                                      color:
                                      Colors.grey.shade300),
                                  // color: myOrderController
                                  //             .currentIndex ==
                                  //         index
                                  //     ? Color(0xffdaedfd)
                                  //     : WhiteColor,
                                  color: WhiteColor,
                                  borderRadius:
                                  BorderRadius.circular(7),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                )
                    : SizedBox(),
                SizedBox(height: Get.height * 0.02),
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
                                  "${currency}${myOrderController.nDetailsInfo?.orderProductList.orderProductData[myOrderController.currentIndex].productPrice}",
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
                                  "${currency}${myOrderController.nDetailsInfo?.orderProductList.orderProductData[myOrderController.currentIndex].productTotal}",
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
                                  "${myOrderController.nDetailsInfo?.orderProductList.orderProductData[myOrderController.currentIndex].productVariation}",
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
                                  "${myOrderController.nDetailsInfo?.orderProductList.orderProductData[myOrderController.currentIndex].productQuantity}",
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
                        "${currency}${myOrderController.nDetailsInfo?.orderProductList.orderSubTotal}",
                      ),
                      SizedBox(
                        height: 13,
                      ),
                      OrderInfo(
                        title: "Delivery Charge".tr,
                        subtitle:
                        "${currency}${myOrderController.nDetailsInfo?.orderProductList.deliveryCharge}",
                      ),
                      SizedBox(
                        height: 13,
                      ),
                      OrderInfo(
                        title: "Store Charge".tr,
                        subtitle:
                        "${currency}${myOrderController.nDetailsInfo?.orderProductList.storeCharge}",
                      ),
                      // SizedBox(
                      //   height: 13,
                      // ),

                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.start,
                      //   children: [
                      //     Text(
                      //       "Store Address",
                      //       style: TextStyle(
                      //         fontFamily: FontFamily.gilroyBold,
                      //         fontSize: 13,
                      //         color: greytext,
                      //       ),
                      //     ),
                      //     SizedBox(
                      //       width: 2,
                      //     ),
                      //     Text(
                      //       ":",
                      //       style: TextStyle(
                      //         fontFamily: FontFamily.gilroyBold,
                      //         fontSize: 13,
                      //         color: greytext,
                      //       ),
                      //     ),
                      //     SizedBox(
                      //       width: 5,
                      //     ),
                      //     SizedBox(
                      //       width: Get.size.width * 0.7,
                      //       child: Text(
                      //         "${myOrderController.nDetailsInfo?.orderProductList.storeAddress}",
                      //         maxLines: 1,
                      //         style: TextStyle(
                      //           fontFamily: FontFamily.gilroyBold,
                      //           fontSize: 14,
                      //           color: Colors.grey,
                      //           overflow: TextOverflow.ellipsis,
                      //         ),
                      //       ),
                      //     )
                      //   ],
                      // ),

                      myOrderController.nDetailsInfo?.orderProductList
                          .couponAmount !=
                          "0"
                          ? SizedBox(
                        height: 13,
                      )
                          : SizedBox(),
                      myOrderController.nDetailsInfo?.orderProductList
                          .couponAmount !=
                          "0"
                          ? OrderInfo(
                        title: "Coupon Amount".tr,
                        subtitle:
                        "${currency}${myOrderController.nDetailsInfo?.orderProductList.couponAmount}",
                      )
                          : SizedBox(),
                      myOrderController.nDetailsInfo?.orderProductList
                          .wallAmt !=
                          "0"
                          ? SizedBox(
                        height: 13,
                      )
                          : SizedBox(),
                      myOrderController.nDetailsInfo?.orderProductList
                          .wallAmt !=
                          "0"
                          ? OrderInfo(
                        title: "Wallet Amount".tr,
                        subtitle:
                        "${currency}${myOrderController.nDetailsInfo?.orderProductList.wallAmt}",
                      )
                          : SizedBox(),
                      SizedBox(
                        height: 13,
                      ),
                      OrderInfo(
                        title: "Total".tr,
                        subtitle:
                        "${currency}${myOrderController.nDetailsInfo?.orderProductList.orderTotal}",
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
                                  myOrderController
                                      .nDetailsInfo
                                      ?.orderProductList
                                      .pMethodName ??
                                      "",
                                  style: TextStyle(
                                    fontFamily: FontFamily.gilroyBold,
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  "(${myOrderController.nDetailsInfo?.orderProductList.orderTransactionId})",
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
                      OrderInfo(
                        title: "Delivery time".tr,
                        subtitle: myOrderController.nDetailsInfo
                            ?.orderProductList.deliveryTimeslot,
                      ),
                      // : SizedBox(),
                      SizedBox(
                        height: 10,
                      ),
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
                                  myOrderController
                                      .nDetailsInfo
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
                      myOrderController.nDetailsInfo?.orderProductList.orderStatus == "Cancelled"
                          ? OrderInfo(
                        title: "Cancel Comment".tr,
                        subtitle: myOrderController.nDetailsInfo?.orderProductList.commentReject,
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
                myOrderController.nDetailsInfo?.orderProductList
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
                        myOrderController.nDetailsInfo
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
                myOrderController
                    .nDetailsInfo?.orderProductList.riderTitle !=
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
                                "${Config.imageUrl}${myOrderController.nDetailsInfo?.orderProductList.riderImage}",
                                fit: BoxFit.cover,
                              ),
                            ),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: greycolor,
                            ),
                          ),
                          title: Text(
                            myOrderController.nDetailsInfo
                                ?.orderProductList.riderTitle ??
                                "",
                            style: TextStyle(
                              fontFamily: FontFamily.gilroyBold,
                              fontSize: 15,
                            ),
                          ),
                          subtitle: Text(
                            myOrderController
                                .nDetailsInfo
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
          );
        }),
      ),
      // SingleChildScrollView(
      //   physics: BouncingScrollPhysics(),
      //   child:
      //
      // ),
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

  Future reviewSheet() {
    return Get.bottomSheet(
      isScrollControlled: true,
      GetBuilder<MyOrderController>(builder: (context) {
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
                  myOrderController.totalRateUpdate(rating);
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
                  controller: myOrderController.ratingText,
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
                        // bookingDetailsController.reviewUpdateApi(
                        //   bookId: bookingDetailsController
                        //       .bookDetailsInfo?.bookdetails.bookId,
                        // );
                        myOrderController.orderReviewApi(orderID: oID);
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
