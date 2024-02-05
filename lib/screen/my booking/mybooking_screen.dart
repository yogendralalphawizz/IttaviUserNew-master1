// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, unnecessary_brace_in_string_interps, unnecessary_string_interpolations, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:milkman/Api/config.dart';
import 'package:milkman/controller/myorder_controller.dart';
import 'package:milkman/helpar/routes_helper.dart';
import 'package:milkman/model/fontfamily_model.dart';
import 'package:milkman/screen/home_screen.dart';
import 'package:milkman/utils/Colors.dart';

class MyBookingScreen extends StatefulWidget {
  const MyBookingScreen({super.key});

  @override
  State<MyBookingScreen> createState() => _MyBookingScreenState();
}

class _MyBookingScreenState extends State<MyBookingScreen>
    with TickerProviderStateMixin {
  TabController? _tabController;
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
      myOrderController.normalOrderHistory(statusWise: "Current");
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
          "My Orders".tr,
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
                    myOrderController.normalOrderHistory(statusWise: "Current");
                  } else {
                    myOrderController.normalOrderHistory(statusWise: "Past");
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
    return GetBuilder<MyOrderController>(builder: (context) {
      return SizedBox(
        height: Get.size.height,
        width: Get.size.width,
        child: myOrderController.isLoading
            ? myOrderController.nOrderInfo!.orderHistory.isNotEmpty
                ? ListView.builder(
                    itemCount:
                        myOrderController.nOrderInfo?.orderHistory.length,
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          myOrderController.normalOrderDetails(
                            orderID: myOrderController.nOrderInfo?.orderHistory[index].id ?? "",
                          );
                          Get.toNamed(Routes.orderdetailsScreen, arguments: {
                            "oID": myOrderController.nOrderInfo?.orderHistory[index].id ?? "",
                          });
                          // myOrderController.myOrderInformetion(
                          //   orderId: myOrderController
                          //           .orderInfo?.orderHistory[index].id ??
                          //       "",
                          // );
                          // Get.toNamed(Routes.orderdetailsScreen, arguments: {
                          //   "oID": myOrderController
                          //           .orderInfo?.orderHistory[index].id ??
                          //       "",
                          // });
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
                                    myOrderController.nOrderInfo
                                            ?.orderHistory[index].odate
                                            .toString()
                                            .split(" ")
                                            .first ??
                                        "",
                                    style: TextStyle(
                                      fontFamily: FontFamily.gilroyMedium,
                                    ),
                                  ),
                                  Spacer(),
                                  myOrderController.nOrderInfo
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
                                              myOrderController
                                                      .nOrderInfo
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
                                      : myOrderController
                                                  .nOrderInfo
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
                                                  myOrderController
                                                          .nOrderInfo
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
                                                  myOrderController
                                                          .nOrderInfo
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
                                    "Order ID: #${myOrderController.nOrderInfo?.orderHistory[index].id ?? ""}",
                                    style: TextStyle(
                                      fontFamily: FontFamily.gilroyBold,
                                      color: BlackColor,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    myOrderController.nOrderInfo
                                            ?.orderHistory[index].oType ??
                                        "",
                                    style: TextStyle(
                                      fontFamily: FontFamily.gilroyBold,
                                      fontSize: 13,
                                      color: gradient.defoultColor,
                                    ),
                                  ),
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
                                            "${Config.imageUrl}${myOrderController.nOrderInfo?.orderHistory[index].storeImg ?? ""}"),
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
                                                myOrderController
                                                        .nOrderInfo
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
                                            // Expanded(
                                            //   child: Text(
                                            //     "${myOrderController.nOrderInfo?.orderHistory[index].paymentTitle ?? ""}",
                                            //     maxLines: 1,
                                            //     textAlign: TextAlign.end,
                                            //     style: TextStyle(
                                            //       fontFamily:
                                            //           FontFamily.gilroyBold,
                                            //       fontSize: 15,
                                            //       color: BlackColor,
                                            //       overflow:
                                            //           TextOverflow.ellipsis,
                                            //     ),
                                            //   ),
                                            // ),
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
                                                myOrderController
                                                        .nOrderInfo
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
                                            Expanded(
                                              child: Text(
                                                "${currency}${myOrderController.nOrderInfo?.orderHistory[index].oTotal ?? ""}",
                                                maxLines: 1,
                                                textAlign: TextAlign.end,
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
                                  myOrderController.nOrderInfo
                                              ?.orderHistory[index].status ==
                                          "Pending"
                                      ? Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              ticketCancell(myOrderController
                                                      .nOrderInfo
                                                      ?.orderHistory[index]
                                                      .id ??
                                                  "");
                                            },
                                            child: Container(
                                              height: 40,
                                              alignment: Alignment.center,
                                              margin: EdgeInsets.all(10),
                                              child: Text(
                                                "Cancle".tr,
                                                style: TextStyle(
                                                  fontFamily:
                                                      FontFamily.gilroyMedium,
                                                  color: WhiteColor,
                                                  fontSize: 15,
                                                ),
                                              ),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: RedColor,
                                              ),
                                            ),
                                          ),
                                        )
                                      : SizedBox(),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        myOrderController.normalOrderDetails(
                                          orderID: myOrderController.nOrderInfo
                                                  ?.orderHistory[index].id ??
                                              "",
                                        );
                                        Get.toNamed(Routes.orderdetailsScreen,
                                            arguments: {
                                              "oID": myOrderController
                                                      .nOrderInfo
                                                      ?.orderHistory[index]
                                                      .id ??
                                                  "",
                                            });
                                        // myOrderController.myOrderInformetion(
                                        //   orderId: myOrderController.nOrderInfo
                                        //           ?.orderHistory[index].id ??
                                        //       "",
                                        // );
                                        // Get.toNamed(Routes.orderdetailsScreen,
                                        //     arguments: {
                                        //       "oID": myOrderController
                                        //               .nOrderInfo
                                        //               ?.orderHistory[index]
                                        //               .id ??
                                        //           "",
                                        //     });
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
    return GetBuilder<MyOrderController>(builder: (context) {
      return SizedBox(
        height: Get.size.height,
        width: Get.size.width,
        child: myOrderController.isLoading
            ? myOrderController.nOrderInfo!.orderHistory.isNotEmpty
                ? ListView.builder(
                    itemCount:
                        myOrderController.nOrderInfo?.orderHistory.length,
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          myOrderController.normalOrderDetails(
                            orderID: myOrderController.nOrderInfo?.orderHistory[index].id ?? "",
                          );
                          Get.toNamed(Routes.orderdetailsScreen, arguments: {
                            "oID": myOrderController.nOrderInfo?.orderHistory[index].id ?? "",
                          });
                          // myOrderController.myOrderInformetion(
                          //   orderId: myOrderController
                          //           .orderInfo?.orderHistory[index].id ??
                          //       "",
                          // );
                          // Get.toNamed(Routes.orderdetailsScreen, arguments: {
                          //   "oID": myOrderController
                          //           .orderInfo?.orderHistory[index].id ??
                          //       "",
                          // });
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
                                    myOrderController.nOrderInfo
                                            ?.orderHistory[index].odate
                                            .toString()
                                            .split(" ")
                                            .first ??
                                        "",
                                    style: TextStyle(
                                      fontFamily: FontFamily.gilroyMedium,
                                    ),
                                  ),
                                  Spacer(),
                                  myOrderController.nOrderInfo
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
                                              myOrderController
                                                      .nOrderInfo
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
                                              myOrderController
                                                      .nOrderInfo
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
                                    "Order ID: #${myOrderController.nOrderInfo?.orderHistory[index].id ?? ""}",
                                    style: TextStyle(
                                      fontFamily: FontFamily.gilroyBold,
                                      color: BlackColor,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    myOrderController.nOrderInfo
                                            ?.orderHistory[index].oType ??
                                        "",
                                    style: TextStyle(
                                      fontFamily: FontFamily.gilroyBold,
                                      fontSize: 13,
                                      color: gradient.defoultColor,
                                    ),
                                  ),
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
                                            "${Config.imageUrl}${myOrderController.nOrderInfo?.orderHistory[index].storeImg ?? ""}"),
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
                                                myOrderController
                                                        .nOrderInfo
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
                                            Expanded(
                                              child: Text(
                                                "${myOrderController.nOrderInfo?.orderHistory[index].commentReject ?? ""}",
                                                maxLines: 1,
                                                textAlign: TextAlign.end,
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
                                                myOrderController.nOrderInfo?.orderHistory[index].storeAddress ?? "",
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
                                            Expanded(
                                              child: Text(
                                                "${currency}${myOrderController.nOrderInfo?.orderHistory[index].oTotal ?? ""}",
                                                maxLines: 1,
                                                textAlign: TextAlign.end,
                                                style: TextStyle(
                                                  fontFamily: FontFamily.gilroyBold,
                                                  fontSize: 15,
                                                  color: BlackColor,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
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
                                      myOrderController.normalOrderDetails(
                                        orderID: myOrderController.nOrderInfo
                                                ?.orderHistory[index].id ??
                                            "",
                                      );
                                      Get.toNamed(Routes.orderdetailsScreen,
                                          arguments: {
                                            "oID": myOrderController.nOrderInfo?.orderHistory[index].id ?? "",
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

  ticketCancell(orderId) {
    showModalBottomSheet(
        isDismissible: false,
        isScrollControlled: true,
        backgroundColor: WhiteColor,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: Get.height * 0.02),
                    Container(
                        height: 6,
                        width: 80,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(25))),
                    SizedBox(height: Get.height * 0.02),
                    Text(
                      "Select Reason".tr,
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Gilroy Bold',
                          color: BlackColor),
                    ),
                    SizedBox(height: Get.height * 0.02),
                    Text(
                      "Please select the reason for cancellation:".tr,
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Gilroy Medium',
                          color: BlackColor),
                    ),
                    SizedBox(height: Get.height * 0.02),
                    ListView.builder(
                      itemCount: cancelList.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (ctx, i) {
                        return InkWell(
                          onTap: () {
                            setState(() {});
                            selectedRadioTile = i;
                            rejectmsg = cancelList[i]["title"];
                          },
                          child: SizedBox(
                            height: 40,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 25,
                                ),
                                Radio(
                                  activeColor: gradient.defoultColor,
                                  value: i,
                                  groupValue: selectedRadioTile,
                                  onChanged: (value) {
                                    setState(() {});
                                    selectedRadioTile = value;
                                    rejectmsg = cancelList[i]["title"];
                                  },
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  cancelList[i]["title"],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Gilroy Medium',
                                    color: BlackColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );

                      },
                    ),
                    rejectmsg == "Others".tr
                        ? SizedBox(
                            height: 50,
                            width: Get.width * 0.85,
                            child: TextField(
                              controller: note,
                              decoration: InputDecoration(
                                  isDense: true,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    borderSide: BorderSide(
                                        color: Color(0xFF246BFD), width: 1),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    borderSide: BorderSide(
                                        color: Color(0xFF246BFD), width: 1),
                                  ),
                                  hintText: 'Enter reason'.tr,
                                  hintStyle: TextStyle(
                                      fontFamily: 'Gilroy Medium',
                                      fontSize: Get.size.height / 55,
                                      color: Colors.grey)),
                            ),
                          )
                        : const SizedBox(),
                    SizedBox(height: Get.height * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: Get.width * 0.35,
                          height: Get.height * 0.05,
                          child: ticketbutton(
                            title: "Cancel".tr,
                            bgColor: RedColor,
                            titleColor: Colors.white,
                            ontap: () {
                              Get.back();
                            },
                          ),
                        ),
                        SizedBox(
                          width: Get.width * 0.35,
                          height: Get.height * 0.05,
                          child: ticketbutton(
                            title: "Confirm".tr,
                            gradient1: gradient.btnGradient,
                            titleColor: Colors.white,
                            ontap: () {
                              myOrderController.cancleOrder(
                                orderId1: orderId,
                                reason: rejectmsg == "Others".tr
                                    ? note.text
                                    : rejectmsg,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: Get.height * 0.04),
                  ],
                ),
              ),
            );
          });
        });
  }

  List cancelList = [
    {"id": 1, "title": "Financing fell through".tr},
    {"id": 2, "title": "Inspection issues".tr},
    {"id": 3, "title": "Change in financial situation".tr},
    {"id": 4, "title": "Title issues".tr},
    {"id": 5, "title": "Seller changes their mind".tr},
    {"id": 6, "title": "Competing offer".tr},
    {"id": 7, "title": "Personal reasons".tr},
    {"id": 8, "title": "Others".tr},
  ];

  ticketbutton(
      {Function()? ontap,
      String? title,
      Color? bgColor,
      titleColor,
      Gradient? gradient1}) {
    return InkWell(
      onTap: ontap,
      child: Container(
        height: Get.height * 0.04,
        width: Get.width * 0.40,
        decoration: BoxDecoration(
          color: bgColor,
          gradient: gradient1,
          borderRadius: (BorderRadius.circular(18)),
        ),
        child: Center(
          child: Text(title!,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: titleColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  fontFamily: 'Gilroy Medium')),
        ),
      ),
    );
  }
}
