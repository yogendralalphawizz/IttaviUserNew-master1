// ignore_for_file: prefer_const_constructors, unnecessary_brace_in_string_interps, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:milkman/controller/wallet_controller.dart';
import 'package:milkman/helpar/routes_helper.dart';
import 'package:milkman/model/fontfamily_model.dart';
import 'package:milkman/screen/home_screen.dart';
import 'package:milkman/utils/Colors.dart';
import 'package:milkman/utils/Custom_widget.dart';

class WalletHistoryScreen extends StatefulWidget {
  const WalletHistoryScreen({super.key});

  @override
  State<WalletHistoryScreen> createState() => _WalletHistoryScreenState();
}

class _WalletHistoryScreenState extends State<WalletHistoryScreen> {
  WalletController walletController = Get.find();

  @override
  void initState() {
    super.initState();
    walletController.getWalletReportData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WhiteColor,
      appBar: AppBar(
        backgroundColor: WhiteColor,
        elevation: 0,
        leading: BackButton(
          color: BlackColor,
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          "Wallet".tr,
          style: TextStyle(
            fontFamily: FontFamily.gilroyBold,
            fontSize: 17,
            color: BlackColor,
          ),
        ),
      ),
      body: SizedBox(
        height: Get.size.height,
        width: Get.size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GetBuilder<WalletController>(builder: (context) {
              return Container(
                height: Get.height * 0.28,
                width: Get.size.width,
                margin: EdgeInsets.only(left: 15, top: 15, right: 15),
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.only(top: 0, left: 15),
                      child: Text(
                        "Available Balance".tr,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 22,
                          fontFamily: FontFamily.gilroyBold,
                          color: WhiteColor,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, left: 15),
                      child: Text(
                        "${currency}${walletController.walletInfo?.wallet}",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 45,
                          fontFamily: FontFamily.gilroyBold,
                          color: WhiteColor,
                        ),
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 0, left: 15),
                    //   child: Text(
                    //     "Your current Balance".tr,
                    //     style: TextStyle(
                    //       fontSize: 20,
                    //       fontFamily: FontFamily.gilroyBold,
                    //       color: WhiteColor,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/walletIMage.png"),
                    fit: BoxFit.fill,
                  ),
                ),
              );
            }),
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 25),
              child: Text(
                "History".tr,
                style: TextStyle(
                  fontSize: 17,
                  color: BlackColor,
                  fontFamily: FontFamily.gilroyMedium,
                ),
              ),
            ),
            Expanded(
              child: GetBuilder<WalletController>(builder: (context) {
                return walletController.isLoading
                    ? walletController.walletInfo?.walletitem == true
                        ? ListView.builder(
                            itemCount: walletController.walletInfo?.walletitem.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.all(10),
                                child: ListTile(
                                  leading: Container(
                                    height: 70,
                                    width: 60,
                                    padding: EdgeInsets.all(12),
                                    child: Image.asset(
                                      "assets/wallet.png",
                                      color: blueColor,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Color(0xFFf6f7f9),
                                    ),
                                  ),
                                  title: Text(
                                    walletController.walletInfo?.walletitem[index].tdate ?? "",
                                    maxLines: 1,
                                    style: TextStyle(
                                      color: BlackColor,
                                      fontFamily: FontFamily.gilroyBold,
                                      // fontSize: 16,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  subtitle: Text(
                                    walletController.walletInfo?.walletitem[index].status ?? "",
                                    maxLines: 1,
                                    style: TextStyle(
                                      color: BlackColor,
                                      fontFamily: FontFamily.gilroyMedium,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  trailing: walletController.walletInfo?.walletitem[index].status ==
                                          "Credit"
                                      ? TextButton(
                                          onPressed: () {},
                                          child: Text(
                                              "${walletController.walletInfo?.walletitem[index].amt ?? ""}${currency} +"),
                                        )
                                      : TextButton(
                                          onPressed: () {},
                                          child: Text(
                                            "${walletController.walletInfo?.walletitem[index].amt ?? ""}${currency} -",
                                            style: TextStyle(
                                              color: Colors.orange.shade300,
                                            ),
                                          ),
                                        ),
                                ),
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey.shade200),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              );
                            },
                          )
                        : Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Padding(
                                //   padding: const EdgeInsets.only(left: 30),
                                //   child: Image.asset(
                                //     "assets/images/bookingEmpty.png",
                                //     height: 110,
                                //     width: 100,
                                //   ),
                                // ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "Go & Add your Amount".tr,
                                  style: TextStyle(
                                    color: greytext,
                                    fontFamily: FontFamily.gilroyBold,
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
            GestButton(
              Width: Get.size.width,
              height: 50,
              margin: EdgeInsets.only(top: 15, left: 35, right: 35),
              buttontext: "ADD AMOUNT".tr,
              style: TextStyle(
                fontFamily: FontFamily.gilroyBold,
                color: WhiteColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              onclick: () {
                Get.toNamed(Routes.addWalletScreen);
              },
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
