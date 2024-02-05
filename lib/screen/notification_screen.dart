// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables, unnecessary_string_interpolations, unused_local_variable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:milkman/controller/notification_controller.dart';
import 'package:milkman/model/fontfamily_model.dart';
import 'package:milkman/utils/Colors.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  NotificationController notificationController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
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
          "Notification".tr,
          style: TextStyle(
            fontSize: 17,
            fontFamily: FontFamily.gilroyBold,
            color: BlackColor,
          ),
        ),
      ),
      body: GetBuilder<NotificationController>(builder: (context) {
        return Column(
          children: [
            Expanded(
              child: notificationController.isLoading
                  // ? notificationController.notificationInfo?.notificationData.isNotEmpty
                      ? ListView.builder(
                        // reverse: true,
                          itemCount: notificationController.notificationInfo?.notificationData.length,
                          itemBuilder: (context, index) {
                            // String time = "${DateFormat.jm().format(DateTime.parse("2023-03-20T${notificationController.notificationInfo?.notificationData[index].datetime.toString().split(" ").last}"))}";
                            return Container(
                              margin: EdgeInsets.all(10),
                              child: ListTile(
                                leading: Container(
                                  height: 60,
                                  width: 60,
                                  padding: EdgeInsets.all(15),
                                  child: Image.asset(
                                    "assets/Notification1.png",
                                    color: gradient.defoultColor,
                                  ),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color:
                                        gradient.defoultColor.withOpacity(0.1),
                                  ),
                                ),
                                title: Text(
                                  notificationController.notificationInfo?.notificationData[index].title ?? "",
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontFamily: FontFamily.gilroyBold,
                                    color: BlackColor,
                                  ),
                                ),
                                subtitle: Row(
                                  children: [
                                    Text(
                                      notificationController.notificationInfo?.notificationData[index].datetime.toString().split(" ").first ?? "",
                                      style: TextStyle(
                                        color: greytext,
                                        fontFamily: FontFamily.gilroyMedium,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    // Text(
                                    //   time,
                                    //   style: TextStyle(
                                    //     color: greytext,
                                    //     fontFamily: FontFamily.gilroyMedium,
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                              decoration: BoxDecoration(
                                color: WhiteColor,
                                borderRadius: BorderRadius.circular(15),
                              ),
                            );
                          },
                        )
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Padding(
                              //   padding: const EdgeInsets.only(left: 30),
                              //   child: Image.asset(
                              //     "assets/images/bookingEmpty.png",
                              //     height: 120,
                              //     width: 120,
                              //   ),
                              // ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                "We'll let you know when we\nget news for you"
                                    .tr,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: greytext,
                                  fontFamily: FontFamily.gilroyBold,
                                ),
                              )
                            ],
                          ),
                        )
                  // : Center(
                  //     child: CircularProgressIndicator(
                  //       color: gradient.defoultColor,
                  //     ),
                  //   ),
            ),
          ],
        );
      }),
    );
  }
}
