// ignore_for_file: prefer_typing_uninitialized_variables, prefer_const_constructors, sort_child_properties_last, unnecessary_brace_in_string_interps, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:milkman/Api/config.dart';
import 'package:milkman/controller/myorder_controller.dart';
import 'package:milkman/controller/subscription_controller.dart';
import 'package:milkman/helpar/routes_helper.dart';
import 'package:milkman/model/fontfamily_model.dart';
import 'package:milkman/screen/home_screen.dart';
import 'package:milkman/utils/Colors.dart';

class MySubscriptionOrder extends StatefulWidget {
  const MySubscriptionOrder({super.key});

  @override
  State<MySubscriptionOrder> createState() => _MySubscriptionOrderState();
}

class _MySubscriptionOrderState extends State<MySubscriptionOrder>
    with TickerProviderStateMixin {
  TabController? _tabController;
  PreScriptionControllre preScriptionControllre = Get.find();
  MyOrderController myOrderController = Get.find();

  final note = TextEditingController();
  var selectedRadioTile;
  String? rejectmsg = '';

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
    _tabController?.index == 0;
    if (_tabController?.index == 0) {
      preScriptionControllre.subScriptionOrderHistory(statusWise: "Current");
    }
  }

  @override
  void dispose() {
    super.dispose();
    _tabController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      appBar: AppBar(
        backgroundColor: WhiteColor,
        centerTitle: true,
        elevation: 0,
        leading: BackButton(
          color: BlackColor,
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          "My Subscription Order".tr,
          style: TextStyle(
            fontFamily: FontFamily.gilroyBold,
            fontSize: 18,
            color: BlackColor,
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 40,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: TabBar(
                controller: _tabController,
                unselectedLabelColor: greyColor,
                labelStyle: const TextStyle(
                  fontFamily: FontFamily.gilroyBold,
                  fontSize: 15,
                ),
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    10.0,
                  ),
                  color: WhiteColor,
                ),
                labelColor: gradient.defoultColor,
                onTap: (value) {
                  if (value == 0) {
                    preScriptionControllre.subScriptionOrderHistory(
                        statusWise: "Current");
                  } else {
                    preScriptionControllre.subScriptionOrderHistory(
                        statusWise: "Past");
                  }
                },
                tabs: [
                  Tab(
                    text: "Current Order".tr,
                  ),
                  Tab(
                    text: "Past Orders".tr,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Expanded(
            flex: 1,
            child: TabBarView(
              controller: _tabController,
              physics: NeverScrollableScrollPhysics(),
              children: [
                currentOrder(),
                pastOrder(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget currentOrder() {
    return GetBuilder<PreScriptionControllre>(builder: (context) {
      return SizedBox(
        height: Get.size.height,
        width: Get.size.width,
        child: preScriptionControllre.isLoading
            ? preScriptionControllre.sOrderInfo!.orderHistory.isNotEmpty
                ? ListView.builder(
                    itemCount: preScriptionControllre.sOrderInfo?.orderHistory.length,
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          preScriptionControllre.subScriptionOrderInfo(
                            orderID: preScriptionControllre.sOrderInfo?.orderHistory[index].id ?? "",
                          );
                          Get.toNamed(Routes.mySubscriptionInfo, arguments: {
                            "oID": preScriptionControllre.sOrderInfo?.orderHistory[index].id ?? "",
                          });
                        },
                        child: Container(
                          width: Get.size.width,
                          margin:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Text(
                                    preScriptionControllre.sOrderInfo
                                            ?.orderHistory[index].date
                                            .toString()
                                            .split(" ")
                                            .first ??
                                        "",
                                    style: TextStyle(
                                      fontFamily: FontFamily.gilroyMedium,
                                    ),
                                  ),
                                  Spacer(),
                                  preScriptionControllre.sOrderInfo
                                              ?.orderHistory[index].status ==
                                          "Pending"
                                      ? Row(
                                          children: [
                                            Image.asset(
                                              "assets/info-circle1.png",
                                              height: 20,
                                              width: 20,
                                            ),
                                            Text(
                                              preScriptionControllre
                                                      .sOrderInfo
                                                      ?.orderHistory[index]
                                                      .status ??
                                                  "",
                                              style: TextStyle(
                                                fontFamily:
                                                    FontFamily.gilroyBold,
                                                color: Color(0xFFFFBB00),
                                              ),
                                            ),
                                          ],
                                        )
                                      : preScriptionControllre
                                                  .sOrderInfo
                                                  ?.orderHistory[index]
                                                  .status ==
                                              "Processing"
                                          ? Row(
                                              children: [
                                                Image.asset(
                                                  "assets/boxStatus.png",
                                                  height: 20,
                                                  width: 20,
                                                  color: gradient.defoultColor,
                                                ),
                                                Text(
                                                  preScriptionControllre
                                                          .sOrderInfo
                                                          ?.orderHistory[index]
                                                          .status ??
                                                      "",
                                                  style: TextStyle(
                                                    fontFamily:
                                                        FontFamily.gilroyBold,
                                                    color:
                                                        gradient.defoultColor,
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Row(
                                              children: [
                                                Image.asset(
                                                  "assets/rocket-launchStatus.png",
                                                  height: 20,
                                                  width: 20,
                                                  color: gradient.defoultColor,
                                                ),
                                                Text(
                                                  preScriptionControllre
                                                          .sOrderInfo
                                                          ?.orderHistory[index]
                                                          .status ??
                                                      "",
                                                  style: TextStyle(
                                                    fontFamily:
                                                        FontFamily.gilroyBold,
                                                    color:
                                                        gradient.defoultColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Text(
                                    "${"Order ID:".tr} #${preScriptionControllre.sOrderInfo?.orderHistory[index].id ?? ""}",
                                    style: TextStyle(
                                      fontFamily: FontFamily.gilroyBold,
                                      color: BlackColor,
                                      fontSize: 16,
                                    ),
                                  ),
                                  // Spacer(),
                                  // preScriptionControllre
                                  //             .sOrderInfo?.orderHistory[index]
                                  //             .orderType !=
                                  //         ""
                                  //     ? Text(
                                  //         preScriptionControllre
                                  //                 .priscriptionInfo
                                  //                 ?.pOrderHistory[index]
                                  //                 .orderType ??
                                  //             "",
                                  //         style: TextStyle(
                                  //           fontFamily: FontFamily.gilroyBold,
                                  //           fontSize: 13,
                                  //           color: gradient.defoultColor,
                                  //         ),
                                  //       )
                                  //     : SizedBox(),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Container(
                                    height: 60,
                                    width: 60,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey.shade200,
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            "${Config.imageUrl}${preScriptionControllre.sOrderInfo?.orderHistory[index].storeImg ?? ""}"),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: Text(
                                                preScriptionControllre
                                                        .sOrderInfo
                                                        ?.orderHistory[index]
                                                        .storeTitle ??
                                                    "",
                                                maxLines: 1,
                                                style: TextStyle(
                                                  fontFamily:
                                                      FontFamily.gilroyBold,
                                                  fontSize: 15,
                                                  color: BlackColor,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                            // preScriptionControllre
                                            //             .sOrderInfo?.orderHistory[index]
                                            //             .paymentTitle !=
                                            //         ""
                                            //     ? Expanded(
                                            //         child: Text(
                                            //           "${preScriptionControllre.priscriptionInfo?.pOrderHistory[index].paymentTitle ?? ""}",
                                            //           maxLines: 1,
                                            //           textAlign: TextAlign.end,
                                            //           style: TextStyle(
                                            //             fontFamily: FontFamily
                                            //                 .gilroyBold,
                                            //             fontSize: 15,
                                            //             color: BlackColor,
                                            //             overflow: TextOverflow
                                            //                 .ellipsis,
                                            //           ),
                                            //         ),
                                            //       )
                                            //     : SizedBox(),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: Text(
                                                preScriptionControllre
                                                        .sOrderInfo
                                                        ?.orderHistory[index]
                                                        .storeAddress ??
                                                    "",
                                                maxLines: 1,
                                                style: TextStyle(
                                                  fontFamily:
                                                      FontFamily.gilroyBold,
                                                  fontSize: 13,
                                                  color: BlackColor,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                            preScriptionControllre
                                                        .sOrderInfo
                                                        ?.orderHistory[index]
                                                        .total !=
                                                    "0"
                                                ? Expanded(
                                                    child: Text(
                                                      "${currency}${preScriptionControllre.sOrderInfo?.orderHistory[index].total ?? ""}",
                                                      maxLines: 1,
                                                      textAlign: TextAlign.end,
                                                      style: TextStyle(
                                                        fontFamily: FontFamily
                                                            .gilroyBold,
                                                        fontSize: 15,
                                                        color: BlackColor,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  )
                                                : SizedBox(),
                                          ],
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
                                  // preScriptionControllre.sOrderInfo
                                  //             ?.orderHistory[index].flowId ==
                                  //         "0"
                                  //     ?

                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        preScriptionControllre
                                            .subScriptionOrderInfo(
                                          orderID: preScriptionControllre
                                                  .sOrderInfo
                                                  ?.orderHistory[index]
                                                  .id ??
                                              "",
                                        );
                                        Get.toNamed(Routes.mySubscriptionInfo,
                                            arguments: {
                                              "oID": preScriptionControllre
                                                      .sOrderInfo
                                                      ?.orderHistory[index]
                                                      .id ??
                                                  "",
                                            });
                                      },
                                      child: Container(
                                        height: 40,
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.all(10),
                                        child: Text(
                                          "Info".tr,
                                          style: TextStyle(
                                            fontFamily: FontFamily.gilroyMedium,
                                            color: WhiteColor,
                                            fontSize: 15,
                                          ),
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          gradient: gradient.btnGradient,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          decoration: BoxDecoration(
                            color: WhiteColor,
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      );
                    },
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 150,
                          width: 200,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/emptyOrder.png"),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "No orders placed!".tr,
                          style: TextStyle(
                            fontFamily: FontFamily.gilroyBold,
                            color: BlackColor,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Currently you don’t have any orders.".tr,
                          style: TextStyle(
                            fontFamily: FontFamily.gilroyMedium,
                            color: greytext,
                          ),
                        ),
                      ],
                    ),
                  )
            : Center(
                child: CircularProgressIndicator(
                  color: gradient.defoultColor,
                ),
              ),
      );
    });
  }

  Widget pastOrder() {
    return GetBuilder<PreScriptionControllre>(builder: (context) {
      return SizedBox(
        height: Get.size.height,
        width: Get.size.width,
        child: preScriptionControllre.isLoading
            ? preScriptionControllre.sOrderInfo!.orderHistory.isNotEmpty
                ? ListView.builder(
                    itemCount:
                        preScriptionControllre.sOrderInfo?.orderHistory.length,
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          preScriptionControllre.subScriptionOrderInfo(
                            orderID: preScriptionControllre
                                    .sOrderInfo?.orderHistory[index].id ??
                                "",
                          );
                          Get.toNamed(Routes.mySubscriptionInfo, arguments: {
                            "oID": preScriptionControllre
                                    .sOrderInfo?.orderHistory[index].id ??
                                "",
                          });
                        },
                        child: Container(
                          width: Get.size.width,
                          margin:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Text(
                                    preScriptionControllre.sOrderInfo
                                            ?.orderHistory[index].date
                                            .toString()
                                            .split(" ")
                                            .first ??
                                        "",
                                    style: TextStyle(
                                      fontFamily: FontFamily.gilroyMedium,
                                    ),
                                  ),
                                  Spacer(),
                                  preScriptionControllre.sOrderInfo
                                              ?.orderHistory[index].status !=
                                          "Cancelled"
                                      ? Row(
                                          children: [
                                            Image.asset(
                                              "assets/badge-check.png",
                                              height: 20,
                                              width: 20,
                                            ),
                                            Text(
                                              preScriptionControllre
                                                      .sOrderInfo
                                                      ?.orderHistory[index]
                                                      .status ??
                                                  "",
                                              style: TextStyle(
                                                fontFamily:
                                                    FontFamily.gilroyBold,
                                                color: Color(0xFF06B730),
                                              ),
                                            ),
                                          ],
                                        )
                                      : Row(
                                          children: [
                                            Image.asset(
                                              "assets/life-ring.png",
                                              height: 20,
                                              width: 20,
                                            ),
                                            Text(
                                              preScriptionControllre
                                                      .sOrderInfo
                                                      ?.orderHistory[index]
                                                      .status ??
                                                  "",
                                              style: TextStyle(
                                                fontFamily:
                                                    FontFamily.gilroyBold,
                                                color: Color(0xFFF44A52),
                                              ),
                                            ),
                                          ],
                                        ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Text(
                                    "${"Order ID:".tr} #${preScriptionControllre.sOrderInfo?.orderHistory[index].id ?? ""}",
                                    style: TextStyle(
                                      fontFamily: FontFamily.gilroyBold,
                                      color: BlackColor,
                                      fontSize: 16,
                                    ),
                                  ),
                                  // Spacer(),
                                  // preScriptionControllre
                                  //             .sOrderInfo?.orderHistory[index]
                                  //             .orderType !=
                                  //         ""
                                  //     ? Text(
                                  //         preScriptionControllre
                                  //                 .priscriptionInfo
                                  //                 ?.pOrderHistory[index]
                                  //                 .orderType ??
                                  //             "",
                                  //         style: TextStyle(
                                  //           fontFamily: FontFamily.gilroyBold,
                                  //           fontSize: 13,
                                  //           color: gradient.defoultColor,
                                  //         ),
                                  //       )
                                  //     : SizedBox(),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Container(
                                    height: 60,
                                    width: 60,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey.shade200,
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            "${Config.imageUrl}${preScriptionControllre.sOrderInfo?.orderHistory[index].storeImg ?? ""}"),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: Text(
                                                preScriptionControllre
                                                        .sOrderInfo
                                                        ?.orderHistory[index]
                                                        .storeTitle ??
                                                    "",
                                                maxLines: 1,
                                                style: TextStyle(
                                                  fontFamily:
                                                      FontFamily.gilroyBold,
                                                  fontSize: 15,
                                                  color: BlackColor,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                            // preScriptionControllre
                                            //             .sOrderInfo?.orderHistory[index]
                                            //             .paymentTitle !=
                                            //         ""
                                            //     ? Expanded(
                                            //         child: Text(
                                            //           "${preScriptionControllre.priscriptionInfo?.pOrderHistory[index].paymentTitle ?? ""}",
                                            //           maxLines: 1,
                                            //           textAlign: TextAlign.end,
                                            //           style: TextStyle(
                                            //             fontFamily: FontFamily
                                            //                 .gilroyBold,
                                            //             fontSize: 15,
                                            //             color: BlackColor,
                                            //             overflow: TextOverflow
                                            //                 .ellipsis,
                                            //           ),
                                            //         ),
                                            //       )
                                            //     : SizedBox(),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                              child: Text(
                                                preScriptionControllre
                                                        .sOrderInfo
                                                        ?.orderHistory[index]
                                                        .storeAddress ??
                                                    "",
                                                maxLines: 1,
                                                style: TextStyle(
                                                  fontFamily:
                                                      FontFamily.gilroyBold,
                                                  fontSize: 13,
                                                  color: BlackColor,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                            preScriptionControllre
                                                        .sOrderInfo
                                                        ?.orderHistory[index]
                                                        .total !=
                                                    "0"
                                                ? Expanded(
                                                    child: Text(
                                                      "${currency}${preScriptionControllre.sOrderInfo?.orderHistory[index].total ?? ""}",
                                                      maxLines: 1,
                                                      textAlign: TextAlign.end,
                                                      style: TextStyle(
                                                        fontFamily: FontFamily
                                                            .gilroyBold,
                                                        fontSize: 15,
                                                        color: BlackColor,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  )
                                                : SizedBox(),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      preScriptionControllre
                                          .subScriptionOrderInfo(
                                        orderID: preScriptionControllre
                                                .sOrderInfo
                                                ?.orderHistory[index]
                                                .id ??
                                            "",
                                      );
                                      Get.toNamed(Routes.mySubscriptionInfo,
                                          arguments: {
                                            "oID": preScriptionControllre
                                                    .sOrderInfo
                                                    ?.orderHistory[index]
                                                    .id ??
                                                "",
                                          });
                                    },
                                    child: Container(
                                      height: 40,
                                      alignment: Alignment.center,
                                      margin: EdgeInsets.all(10),
                                      child: Text(
                                        "Info".tr,
                                        style: TextStyle(
                                          fontFamily: FontFamily.gilroyMedium,
                                          color: WhiteColor,
                                          fontSize: 15,
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        gradient: gradient.btnGradient,
                                      ),
                                    ),
                                  ),
                                ),
                              ])
                            ],
                          ),
                          decoration: BoxDecoration(
                            color: WhiteColor,
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      );
                    },
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 150,
                          width: 200,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/emptyOrder.png"),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "No orders placed!".tr,
                          style: TextStyle(
                            fontFamily: FontFamily.gilroyBold,
                            color: BlackColor,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Currently you don’t have any orders.".tr,
                          style: TextStyle(
                            fontFamily: FontFamily.gilroyMedium,
                            color: greytext,
                          ),
                        ),
                      ],
                    ),
                  )
            : Center(
                child: CircularProgressIndicator(
                  color: gradient.defoultColor,
                ),
              ),
      );
    });
  }
}
