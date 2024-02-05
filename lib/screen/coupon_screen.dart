// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:milkman/Api/config.dart';
import 'package:milkman/controller/cart_controller.dart';
import 'package:milkman/model/fontfamily_model.dart';
import 'package:milkman/screen/yourcart_screen.dart';
import 'package:milkman/utils/Colors.dart';

class CouponScreen extends StatefulWidget {
  const CouponScreen({super.key});

  @override
  State<CouponScreen> createState() => _CouponScreenState();
}

class _CouponScreenState extends State<CouponScreen> {
  CartController cartController = Get.find();
  TextEditingController search = TextEditingController();

  double price = Get.arguments["price"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 53,
              width: Get.size.width,
              child: Column(
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      BackButton(
                        onPressed: () {
                          Get.back();
                        },
                        color: BlackColor,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "All coupons".tr,
                              style: TextStyle(
                                fontFamily: FontFamily.gilroyBold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // SizedBox(
                  //   height: 15,
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 20),
                  //   child: TextFormField(
                  //     controller: search,
                  //     cursorColor: BlackColor,
                  //     style: TextStyle(
                  //       fontFamily: 'Gilroy',
                  //       fontSize: 14,
                  //       height: 1.5,
                  //       fontWeight: FontWeight.w600,
                  //       color: BlackColor,
                  //     ),
                  //     decoration: InputDecoration(
                  //       contentPadding:
                  //           EdgeInsets.only(top: 5, bottom: 5, left: 8),
                  //       focusedBorder: OutlineInputBorder(
                  //         borderRadius: BorderRadius.circular(10),
                  //         borderSide: BorderSide(color: Color(0xFFC2C5CA)),
                  //       ),
                  //       enabledBorder: OutlineInputBorder(
                  //         borderSide: BorderSide(
                  //           color: Color(0xFFC2C5CA),
                  //         ),
                  //         borderRadius: BorderRadius.circular(10),
                  //       ),
                  //       border: OutlineInputBorder(
                  //         borderRadius: BorderRadius.circular(10),
                  //       ),
                  //       // suffixText: "APPLY",
                  //       suffixIcon: Container(
                  //         width: 70,
                  //         alignment: Alignment.center,
                  //         child: Text(
                  //           "APPLY".tr,
                  //           style: TextStyle(
                  //             fontFamily: FontFamily.gilroyBold,
                  //             color: greycolor,
                  //           ),
                  //         ),
                  //       ),
                  //       hintText: "Enter Coupon Code".tr,
                  //       hintStyle: TextStyle(
                  //         color: greyColor,
                  //         fontFamily: FontFamily.gilroyMedium,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
              decoration: BoxDecoration(
                color: WhiteColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.only(left: 15),
              child: Text(
                "Best Coupon".tr,
                style: TextStyle(
                  fontFamily: FontFamily.gilroyBold,
                  fontSize: 18,
                  color: BlackColor,
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            GetBuilder<CartController>(builder: (context) {
              return Expanded(
                child: cartController.isLoading
                    ? cartController.cartDataInfo!.couponList.isNotEmpty
                        ? ListView.builder(
                            itemCount:
                                cartController.cartDataInfo?.couponList.length,
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) {
                              return Container(
                                height: 180,
                                width: Get.size.width,
                                margin: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            cartController
                                                    .cartDataInfo
                                                    ?.couponList[index]
                                                    .couponTitle ??
                                                "",
                                            maxLines: 1,
                                            style: TextStyle(
                                              fontFamily:
                                                  FontFamily.gilroyExtraBold,
                                              color: BlackColor,
                                              fontSize: 18,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Text(
                                            cartController
                                                    .cartDataInfo
                                                    ?.couponList[index]
                                                    .couponSubtitle ??
                                                "",
                                            style: TextStyle(
                                              color: greyColor,
                                              fontSize: 14,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 12,
                                          ),
                                          Text.rich(
                                            TextSpan(
                                              text: 'Coupon Code: '.tr,
                                              style: TextStyle(
                                                color: BlackColor,
                                                fontFamily:
                                                    FontFamily.gilroyMedium,
                                                fontSize: 15,
                                              ),
                                              children: <InlineSpan>[
                                                TextSpan(
                                                  text: cartController
                                                          .cartDataInfo
                                                          ?.couponList[index]
                                                          .couponCode ??
                                                      "",
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontFamily:
                                                        FontFamily.gilroyBold,
                                                    color:
                                                        gradient.defoultColor,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text.rich(
                                            TextSpan(
                                              text: 'Minimum Amount: '.tr,
                                              style: TextStyle(
                                                color: BlackColor,
                                                fontFamily:
                                                    FontFamily.gilroyMedium,
                                                fontSize: 15,
                                              ),
                                              children: <InlineSpan>[
                                                TextSpan(
                                                  text: cartController
                                                          .cartDataInfo
                                                          ?.couponList[index]
                                                          .minAmt ??
                                                      "",
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontFamily:
                                                        FontFamily.gilroyBold,
                                                    color: BlackColor,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text.rich(
                                            TextSpan(
                                              text: 'Ex Date: '.tr,
                                              style: TextStyle(
                                                color: BlackColor,
                                                fontFamily:
                                                    FontFamily.gilroyMedium,
                                                fontSize: 15,
                                              ),
                                              children: <InlineSpan>[
                                                TextSpan(
                                                  text: cartController
                                                          .cartDataInfo
                                                          ?.couponList[index]
                                                          .expireDate
                                                          .toString()
                                                          .split(" ")
                                                          .first ??
                                                      "",
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontFamily:
                                                        FontFamily.gilroyBold,
                                                    color: BlackColor,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              if (double.parse(
                                                      price.toString()) >=
                                                  double.parse(cartController
                                                          .cartDataInfo
                                                          ?.couponList[index]
                                                          .minAmt ??
                                                      "0")) {
                                                cartController
                                                    .checkCouponDataApi(
                                                        cid: cartController
                                                            .cartDataInfo
                                                            ?.couponList[index]
                                                            .id);
                                                setState(() {
                                                  cartController.couponAmt =
                                                      double.parse(
                                                          cartController
                                                                  .cartDataInfo
                                                                  ?.couponList[
                                                                      index]
                                                                  .couponVal ??
                                                              "");
                                                });
                                                total = total -
                                                    cartController.couponAmt;
                                                cartController.couponId =
                                                    cartController
                                                            .cartDataInfo
                                                            ?.couponList[index]
                                                            .id ??
                                                        "";
                                                Get.back(
                                                    result: cartController
                                                            .cartDataInfo
                                                            ?.couponList[index]
                                                            .couponCode ??
                                                        "");
                                              }
                                            },
                                            child: Container(
                                              height: 40,
                                              width: 150,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 15),
                                              alignment: Alignment.center,
                                              child: Text(
                                                "Apply coupons".tr,
                                                style: TextStyle(
                                                  fontFamily:
                                                      FontFamily.gilroyBold,
                                                  color: double.parse(price
                                                              .toString()) >=
                                                          double.parse(cartController
                                                                  .cartDataInfo
                                                                  ?.couponList[
                                                                      index]
                                                                  .minAmt ??
                                                              "0")
                                                      ? gradient.defoultColor
                                                      : Colors.grey.shade300,
                                                ),
                                              ),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                border: double.parse(
                                                            price.toString()) >=
                                                        double.parse(
                                                            cartController
                                                                    .cartDataInfo
                                                                    ?.couponList[
                                                                        index]
                                                                    .minAmt ??
                                                                "0")
                                                    ? Border.all(
                                                        color: gradient
                                                            .defoultColor)
                                                    : Border.all(
                                                        color: Colors
                                                            .grey.shade300),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 130,
                                      width: 100,
                                      alignment: Alignment.center,
                                      child: Container(
                                        height: 60,
                                        width: 60,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: FadeInImage.assetNetwork(
                                            placeholderCacheHeight: 50,
                                            placeholderCacheWidth: 50,
                                            placeholderFit: BoxFit.cover,
                                            placeholder:
                                                "assets/ezgif.com-crop.gif",
                                            image:
                                                "${Config.imageUrl}${cartController.cartDataInfo?.couponList[index].couponImg ?? ""}",
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.grey.shade300),
                                          borderRadius:
                                              BorderRadius.circular(40),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              );
                            },
                          )
                        : Center(
                            child: Text(
                              "The Coupon is unavailable \n in your Store.".tr,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: FontFamily.gilroyBold,
                                fontSize: 15,
                                color: BlackColor,
                              ),
                            ),
                          )
                    : Center(
                        child: CircularProgressIndicator(
                          color: gradient.defoultColor,
                        ),
                      ),
              );
            })
          ],
        ),
      ),
    );
  }
}
