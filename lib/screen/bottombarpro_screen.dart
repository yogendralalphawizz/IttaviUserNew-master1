// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unused_element, prefer_is_empty, unused_local_variable, prefer_interpolation_to_compose_strings, avoid_print

import 'package:badges/badges.dart' as bg;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:milkman/Api/data_store.dart';
import 'package:milkman/controller/catdetails_controller.dart';
import 'package:milkman/controller/home_controller.dart';
import 'package:milkman/model/fontfamily_model.dart';
import 'package:milkman/screen/about_screen.dart';
import 'package:milkman/screen/categorydetails_screen.dart';
import 'package:milkman/screen/profile_screen.dart';
import 'package:milkman/screen/yourcart_screen.dart';
import 'package:milkman/utils/Colors.dart';

import 'home_screen.dart';

class BottombarProScreen extends StatefulWidget {
  const BottombarProScreen({super.key});

  @override
  State<BottombarProScreen> createState() => _BottombarProScreenState();
}

int currentIndex = 0;
final GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();

class _BottombarProScreenState extends State<BottombarProScreen>
    with TickerProviderStateMixin {
  CatDetailsController catDetailsController = Get.find();
  HomePageController homePageController = Get.find();

  late TabController tabController;
  List<Widget> myChilders = [
    HomeScreen(),
    // CategoryDetailsScreen(),
    AboutScreen(),
    // PreScriptionScreen(),
    YourCartScreen(CartStatus: "1"),
    ProfileScreen(),
  ];

  @override
  void initState() {
    if (getData.read("changeIndex") != null) {
      if (getData.read("changeIndex") != true) {
        currentIndex = 0;
        setState(() {});
        save("changeIndex", false);
      } else {
        if (homePageController.isback == "1") {
          currentIndex = 0;
        }
      }
    } else {
      currentIndex = 0;
    }
    // currentIndex = 0;
    tabController =
        TabController(length: 4, vsync: this, initialIndex: currentIndex);
    super.initState();
    tabController.addListener(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<CatDetailsController>(builder: (context) {
        return TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          controller:
              TabController(length: 4, vsync: this, initialIndex: currentIndex),
          children: myChilders,
        );
      }),
      // body: Navigator(
      //   key: navKey,
      //   onGenerateRoute: (settings) {
      //     return MaterialPageRoute(
      //       builder: (context) {
      //         return TabBarView(
      //           physics: const NeverScrollableScrollPhysics(),
      //           controller: tabController,
      //           children: myChilders,
      //         );
      //       },
      //     );
      //   },
      // ),
      bottomNavigationBar: BottomAppBar(
        color: WhiteColor,
        child: GetBuilder<CatDetailsController>(builder: (context) {
          return TabBar(
            onTap: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            indicator: UnderlineTabIndicator(
              insets: EdgeInsets.only(bottom: 52),
              borderSide: BorderSide(color: Colors.white, width: 2),
            ),
            labelColor: Colors.blueAccent,
            indicatorSize: TabBarIndicatorSize.label,
            unselectedLabelColor: Colors.grey,
            controller: TabController(
                length: 4, vsync: this, initialIndex: currentIndex),
            padding: const EdgeInsets.symmetric(vertical: 6),
            tabs: [
              Tab(
                child: Column(
                  children: [
                    currentIndex == 0
                        ? Image.asset(
                            "assets/storeBold.png",
                            scale: 25,
                            color: gradient.defoultColor,
                          )
                        : Image.asset(
                            "assets/store.png",
                            scale: 25,
                            color: BlackColor,
                          ),
                    SizedBox(height: 4),
                    Text(
                      "Shop".tr,
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 11,
                        fontFamily: FontFamily.gilroyBold,
                        color: currentIndex == 0
                            ? gradient.defoultColor
                            : BlackColor,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Tab(
                child: Column(
                  children: [
                    currentIndex == 1
                        ? Image.asset(
                            "assets/info-circleBold.png",
                            scale: 25,
                            color: gradient.defoultColor,
                          )
                        : Image.asset(
                            "assets/info-circle.png",
                            scale: 25,
                            color: BlackColor,
                          ),
                    SizedBox(height: 4),
                    Text(
                      "About".tr,
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 11,
                        fontFamily: FontFamily.gilroyBold,
                        color: currentIndex == 1
                            ? gradient.defoultColor
                            : BlackColor,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              // Tab(
              //   child: Column(
              //     children: [
              //       currentIndex == 2
              //           ? Image.asset(
              //               "assets/receipt-text.png",
              //               scale: 25,
              //               color: gradient.defoultColor,
              //             )
              //           : Image.asset(
              //               "assets/receipt-list.png",
              //               scale: 25,
              //               color: BlackColor,
              //             ),
              //       SizedBox(height: 4),
              //       Text(
              //         "Prescription".tr,
              //         maxLines: 1,
              //         style: TextStyle(
              //           fontSize: 11,
              //           overflow: TextOverflow.ellipsis,
              //           fontFamily: FontFamily.gilroyBold,
              //           color: currentIndex == 2
              //               ? gradient.defoultColor
              //               : BlackColor,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              Tab(
                child: bg.Badge(
                  position: bg.BadgePosition.topEnd(end: -5, top: -8),
                  badgeAnimation: bg.BadgeAnimation.fade(),
                  badgeContent: Text(
                    catDetailsController.count.length.toString(),
                    style: TextStyle(color: WhiteColor, fontSize: 10),
                  ),
                  badgeStyle: bg.BadgeStyle(
                    badgeColor: gradient.defoultColor,
                    elevation: 0,
                    shape: bg.BadgeShape.circle,
                  ),
                  showBadge:
                      catDetailsController.count.length == 0 ? false : true,
                  child: Column(
                    children: [
                      currentIndex == 2
                          ? Image.asset(
                              "assets/shopping-bag-bold.png",
                              scale: 25,
                              color: gradient.defoultColor,
                            )
                          : Image.asset(
                              "assets/shopping-bag-outline.png",
                              scale: 25,
                              color: BlackColor,
                            ),
                      SizedBox(height: 4),
                      Text(
                        "Cart".tr,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 11,
                          fontFamily: FontFamily.gilroyBold,
                          color: currentIndex == 2
                              ? gradient.defoultColor
                              : BlackColor,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Tab(
                child: Column(
                  children: [
                    currentIndex == 3
                        ? Image.asset(
                            "assets/user1.png",
                            scale: 25,
                            color: gradient.defoultColor,
                          )
                        : Image.asset(
                            "assets/ic_user.png",
                            scale: 25,
                            color: BlackColor,
                          ),
                    SizedBox(height: 4),
                    Text(
                      "Profile".tr,
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 11,
                        fontFamily: FontFamily.gilroyBold,
                        color: currentIndex == 3
                            ? gradient.defoultColor
                            : BlackColor,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
