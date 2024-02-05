// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_interpolation_to_compose_strings, avoid_print, unnecessary_new, file_names

import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:get/get.dart';
import 'package:milkman/controller/wallet_controller.dart';
import 'package:milkman/model/fontfamily_model.dart';
import 'package:milkman/screen/home_screen.dart';
import 'package:milkman/utils/Colors.dart';
import 'package:milkman/utils/Custom_widget.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ReferFriendScreen extends StatefulWidget {
  const ReferFriendScreen({super.key});

  @override
  State<ReferFriendScreen> createState() => _ReferFriendScreenState();
}

class _ReferFriendScreenState extends State<ReferFriendScreen> {
  WalletController walletController = Get.find();
  PackageInfo? packageInfo;
  String? appName;
  String? packageName;

  @override
  void initState() {
    super.initState();
    getPackage();
  }

  void getPackage() async {
    //! App details get
    packageInfo = await PackageInfo.fromPlatform();
    appName = packageInfo!.appName;
    packageName = packageInfo!.packageName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WhiteColor,
      appBar: AppBar(
        backgroundColor: WhiteColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back,
            color: BlackColor,
          ),
        ),
        title: Text(
          "Refer a Friend".tr,
          style: TextStyle(
            fontSize: 17,
            fontFamily: FontFamily.gilroyBold,
            color: BlackColor,
          ),
        ),
      ),
      body: GetBuilder<WalletController>(builder: (context) {
        return SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: SizedBox(
            height: Get.size.height,
            width: Get.size.width,
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                Image.asset(
                  "assets/money-bag.png",
                  height: 220,
                  width: Get.size.width,
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "Refer Application with \nYour Friends",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25,
                    fontFamily: FontFamily.gilroyBold,
                    color: BlackColor,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                // Container(
                //   alignment: Alignment.center,
                //   padding: EdgeInsets.symmetric(horizontal: 15),
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       Row(
                //         mainAxisAlignment: MainAxisAlignment.start,
                //         children: [
                //           Image.asset(
                //             "assets/lovef.png",
                //             height: 28,
                //             width: 28,
                //           ),
                //           SizedBox(
                //             width: 15,
                //           ),
                //           Text(
                //             "Share the referral link with your friends".tr,
                //             textAlign: TextAlign.start,
                //             style: TextStyle(
                //               fontFamily: FontFamily.gilroyMedium,
                //               fontSize: 16,
                //               color: BlackColor,
                //             ),
                //           ),
                //         ],
                //       ),
                //       SizedBox(
                //         height: 15,
                //       ),
                //       Row(
                //         mainAxisAlignment: MainAxisAlignment.start,
                //         children: [
                //           Image.asset(
                //             "assets/lovef.png",
                //             height: 28,
                //             width: 28,
                //           ),
                //           SizedBox(
                //             width: 15,
                //           ),
                //           Text(
                //             "${"Friend get".tr} ${currency + walletController.refercredit} ${"on their first complete\ntransaction".tr}",
                //             textAlign: TextAlign.start,
                //             style: TextStyle(
                //               fontFamily: FontFamily.gilroyMedium,
                //               fontSize: 16,
                //               color: BlackColor,
                //             ),
                //           ),
                //         ],
                //       ),
                //       SizedBox(
                //         height: 15,
                //       ),
                //       Row(
                //         mainAxisAlignment: MainAxisAlignment.start,
                //         children: [
                //           Image.asset(
                //             "assets/lovef.png",
                //             height: 28,
                //             width: 28,
                //           ),
                //           SizedBox(
                //             width: 15,
                //           ),
                //           Text(
                //             "${"You get".tr} ${currency + walletController.signupcredit} ${"on your wallet".tr}",
                //             textAlign: TextAlign.start,
                //             style: TextStyle(
                //               fontFamily: FontFamily.gilroyMedium,
                //               fontSize: 16,
                //               color: BlackColor,
                //             ),
                //           ),
                //         ],
                //       ),
                //     ],
                //   ),
                // ),
                // SizedBox(
                //   height: 15,
                // ),
                // SizedBox(
                //   height: 50,
                // ),
                // Container(
                //   height: 50,
                //   width: Get.size.width,
                //   alignment: Alignment.center,
                //   margin: EdgeInsets.only(top: 15, left: 35, right: 35),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       SizedBox(
                //         width: 40,
                //       ),
                //       Expanded(
                //         child: Container(
                //           alignment: Alignment.center,
                //           child: Text(
                //             walletController.rCode,
                //             style: TextStyle(
                //               fontFamily: FontFamily.gilroyBold,
                //               fontSize: 15,
                //             ),
                //           ),
                //         ),
                //       ),
                //       InkWell(
                //         onTap: () {
                //           Clipboard.setData(
                //             new ClipboardData(text: walletController.rCode),
                //           );
                //           showToastMessage("Copy");
                //         },
                //         child: Image.asset(
                //           "assets/copy.png",
                //           height: 20,
                //           width: 20,
                //           color: gradient.defoultColor,
                //         ),
                //       ),
                //       SizedBox(
                //         width: 20,
                //       ),
                //     ],
                //   ),
                //   decoration: BoxDecoration(
                //     color: gradient.defoultColor.withOpacity(0.1),
                //     borderRadius: BorderRadius.circular(15),
                //   ),
                // ),
                // SizedBox(
                //   height: 15,
                // ),
                // GestButton(
                //   Width: Get.size.width,
                //   height: 50,
                //   buttoncolor: blueColor,
                //   margin: EdgeInsets.only(top: 15, left: 35, right: 35),
                //   buttontext: "Refer a Friend".tr,
                //   style: TextStyle(
                //     fontFamily: FontFamily.gilroyBold,
                //     color: WhiteColor,
                //     fontSize: 16,
                //     fontWeight: FontWeight.bold,
                //   ),
                //   onclick: () async {
                //     await FlutterShare.share(
                //         title: '$appName',
                //         text:
                //             'Hey! Now use our app to share with your family or friends. User will get wallet amount on your 1st successful transaction. Enter my referral code ${walletController.rCode} & Enjoy your shopping !!!',
                //         linkUrl: Platform.isAndroid
                //             ? 'https://play.google.com/store/apps/details?id=$packageName'
                //             : Platform.isIOS
                //                 ? 'https://play.google.com/store/apps/details?id=$packageName'
                //                 : "",
                //         chooserTitle: '$appName');
                //   },
                // ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Future<void> share() async {
    print("!!!!!!!!!!" + appName.toString());
    print("!!!!!!!!!!" + packageName.toString());
    await FlutterShare.share(
        title: '$appName',
        text:
            'Hey! Now use our app to share with your family or friends. User will get wallet amount on your 1st successful transaction. Enter my referral code ${walletController.rCode} & Enjoy your shopping !!!',
        linkUrl: 'https://play.google.com/store/apps/details?id=$packageName',
        chooserTitle: '$appName');
  }
}
