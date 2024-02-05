// ignore_for_file: camel_case_types, use_key_in_widget_constructors, annotate_overrides, prefer_const_literals_to_create_immutables, file_names, unused_element, prefer_const_constructors, prefer_typing_uninitialized_variables, sort_child_properties_last, prefer_interpolation_to_compose_strings, unused_local_variable

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:milkman/Api/data_store.dart';
import 'package:milkman/helpar/routes_helper.dart';
import 'package:milkman/model/fontfamily_model.dart';
import 'package:milkman/screen/home_screen.dart';
import 'package:milkman/screen/loginAndsignup/login_screen.dart';
import 'package:milkman/utils/Colors.dart';
import 'package:milkman/utils/String.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bottombarpro_screen.dart';

// ignore: unused_import
var lat;
var long;
var address;

class onbording extends StatefulWidget {
  const onbording({Key? key}) : super(key: key);

  @override
  State<onbording> createState() => _onbordingState();
}

class _onbordingState extends State<onbording> {
  @override
  void initState() {
    super.initState();
    getCurrentLatAndLong();
  }

  Future<Position> locateUser() async {
    return Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  getCurrentLatAndLong() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {}
    var currentLocation = await locateUser();
    List<Placemark> addresses = await placemarkFromCoordinates(
        currentLocation.latitude, currentLocation.longitude);
    await placemarkFromCoordinates(
            currentLocation.latitude, currentLocation.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      address =
          '${placemarks.first.name!.isNotEmpty ? placemarks.first.name! + ', ' : ''}${placemarks.first.thoroughfare!.isNotEmpty ? placemarks.first.thoroughfare! + ', ' : ''}${placemarks.first.subLocality!.isNotEmpty ? placemarks.first.subLocality! + ', ' : ''}${placemarks.first.locality!.isNotEmpty ? placemarks.first.locality! + ', ' : ''}${placemarks.first.subAdministrativeArea!.isNotEmpty ? placemarks.first.subAdministrativeArea! + ', ' : ''}${placemarks.first.postalCode!.isNotEmpty ? placemarks.first.postalCode! + ', ' : ''}${placemarks.first.administrativeArea!.isNotEmpty ? placemarks.first.administrativeArea : ''}';
    });
    setState(() {
      lat = currentLocation.latitude;
      long = currentLocation.longitude;
      setScreen();
    });
  }

  setScreen() async {
    Timer(
      const Duration(seconds: 0),
      () =>
      // getData.read('Firstuser') != true
      //     ? Navigator.pushReplacement(
      //         context,
      //         MaterialPageRoute(
      //           builder: (context) => BoardingPage(),
      //         ),
      //       )
      //     :
      getData.read('Remember') != true
              ? Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                )
              : Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BottombarProScreen(),
                  ),
                ),
    );
  }

  void _incrementCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = ((prefs.getInt('counter') ?? 0) + 1);
      prefs.setInt('counter', _counter);
    });
  }

  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      body: Container(
        decoration: BoxDecoration(
          // image: DecorationImage(
          //     image: AssetImage("assets/SplashScreen.png"), fit: BoxFit.fill),
          // gradient: gradient.btnGradient,
            color: Colors.white
        ),
        child: Center(
          child: Image.asset("assets/SpleshLogo.png", height: 250, width: 250),
        ),
      ),
    );
  }
}

class BoardingPage extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _BoardingScreenState createState() => _BoardingScreenState();
}

class _BoardingScreenState extends State<BoardingPage> {
  // creating all the widget before making our home screeen

  void initState() {
    super.initState();

    _currentPage = 0;

    _slides = [
      Slide("assets/Onboarding1.png", provider.discover, provider.healthy),
      Slide("assets/Onboarding2.png", provider.order, provider.orderthe),
      Slide("assets/Onboarding3.png", provider.lets, provider.cooking),
    ];
    _pageController = PageController(initialPage: _currentPage);
    super.initState();
  }

  int _currentPage = 0;
  List<Slide> _slides = [];
  PageController _pageController = PageController();

  // the list which contain the build slides
  List<Widget> _buildSlides() {
    return _slides.map(_buildSlide).toList();
  }

  Widget _buildSlide(Slide slide) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: gradient.defoultColor,
      body: Column(
        children: <Widget>[
          // ignore: sized_box_for_whitespace
          Container(
            height: Get.height * 0.45, //imagee size
            width: Get.width,
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: Get.size.height * 0.1),
            padding: EdgeInsets.all(10),
            child: Image.asset(slide.image, fit: BoxFit.cover),
            // decoration: BoxDecoration(
            //     image: DecorationImage(
            //         image: AssetImage(slide.image), fit: BoxFit.cover)),
          ),
          // Container(
          //   height: Get.size.height * 0.35,
          //   width: Get.size.width,
          //   margin: EdgeInsets.only(
          //       top: Get.size.height * 0.08, left: 10, right: 10, bottom: 10),
          //   child:
          //! --------

          // Column(
          //   children: [
          //     SizedBox(height: Get.height * 0.16),
          //     SizedBox(
          //       width: Get.width * 0.70,
          //       child: Text(
          //         slide.heading,
          //         textAlign: TextAlign.center,
          //         style: TextStyle(
          //             fontSize: 21,
          //             fontFamily: "Gilroy Bold",
          //             color: BlackColor), //heding Text
          //       ),
          //     ),
          //     SizedBox(height: Get.height * 0.02),
          //     SizedBox(
          //       width: Get.width * 0.70,
          //       child: Text(
          //         slide.subtext,
          //         textAlign: TextAlign.center,
          //         style: TextStyle(
          //             fontSize: 13,
          //             color: greycolor,
          //             fontFamily: "Gilroy Medium"), //subtext
          //       ),
          //     ),
          //   ],
          // ),
          //! ---------
          // decoration: BoxDecoration(
          //   color: WhiteColor,
          //   borderRadius: BorderRadius.circular(25),
          // ),
          // ),
        ],
      ),
    );
  }

  // handling the on page changed
  void _handlingOnPageChanged(int page) {
    setState(() => _currentPage = page);
  }

  // building page indicator
  Widget _buildPageIndicator() {
    Row row = Row(mainAxisAlignment: MainAxisAlignment.center, children: []);
    for (int i = 0; i < _slides.length; i++) {
      row.children.add(_buildPageIndicatorItem(i));
      if (i != _slides.length - 1)
        // ignore: curly_braces_in_flow_control_structures
        row.children.add(const SizedBox(
          width: 10,
        ));
    }
    return row;
  }

  Widget _buildPageIndicatorItem(int index) {
    return Container(
      width: index == _currentPage ? 12 : 8,
      height: index == _currentPage ? 12 : 8,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: index == _currentPage
              ? gradient.defoultColor
              : gradient.defoultColor.withOpacity(0.5)),
    );
  }

  sliderText() {
    return Column(
      children: [
        SizedBox(height: Get.height * 0.05),
        SizedBox(
          width: Get.width * 0.70,
          child: Text(
            _currentPage == 0
                ? "Milk made modern!".tr
                : _currentPage == 1
                    ? "Never miss a delivery again!".tr
                    : _currentPage == 2
                        ? "Milk at your fingertips!".tr
                        : "",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 21,
                fontFamily: "Gilroy Bold",
                color: BlackColor), //heding Text
          ),
        ),
        SizedBox(height: Get.height * 0.02),
        SizedBox(
          width: Get.width * 0.70,
          child: Text(
            _currentPage == 0
                ? "Our app combines the convenience of technology with the tradition of the milkman"
                    .tr
                : _currentPage == 1
                    ? "With our app, you'll receive real-time notifications about your milk deliveries"
                        .tr
                    : _currentPage == 2
                        ? "order fresh milk and dairy products for delivery straight to your doorstep"
                            .tr
                        : "",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 13,
                color: greycolor,
                fontFamily: "Gilroy Medium"), //subtext
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: gradient.defoultColor,
      body: Stack(
        children: <Widget>[
          PageView(
            controller: _pageController,
            onPageChanged: _handlingOnPageChanged,
            physics: const BouncingScrollPhysics(),
            children: _buildSlides(),
          ),
          GestureDetector(
            onTap: () {
              Get.toNamed(Routes.loginScreen);
              save("isBack", true);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 40),
              child: Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () {
                    Get.toNamed(Routes.loginScreen);
                    save("isBack", true);
                  },
                  child: Container(
                    height: 40,
                    width: 80,
                    margin: EdgeInsets.symmetric(vertical: 5),
                    alignment: Alignment.center,
                    child: Text(
                      "Skip".tr,
                      style: TextStyle(
                        fontFamily: FontFamily.gilroyBold,
                        fontSize: 14,
                        color: WhiteColor,
                      ),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.green[300],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: Get.size.height * 0.35,
              width: Get.size.width,
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: WhiteColor,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: Get.size.height * 0.03,
                  ),
                  _buildPageIndicator(),
                  sliderText(),
                  Spacer(),
                  _currentPage == 2
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: GestureDetector(
                            onTap: () {
                              Get.toNamed(Routes.loginScreen);
                              save("isBack", true);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: gradient.btnGradient,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              height: 50,
                              width: double.infinity,
                              child: Center(
                                child: Text(
                                  provider.getstart,
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: WhiteColor,
                                      fontFamily: "Gilroy Bold"),
                                ),
                              ),
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: GestureDetector(
                            onTap: () {
                              _pageController.nextPage(
                                  duration: const Duration(microseconds: 300),
                                  curve: Curves.easeIn);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  gradient: gradient.btnGradient,
                                  borderRadius: BorderRadius.circular(15)),
                              height: 50,
                              width: double.infinity,
                              child: Center(
                                child: Text(
                                  provider.next,
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: WhiteColor,
                                      fontFamily: "Gilroy Bold"),
                                ),
                              ),
                            ),
                          ),
                        ),
                  SizedBox(
                    height: Get.height * 0.012, //indicator set screen
                  ),
                  const SizedBox(height: 20)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class Slide {
  String image;
  String heading;
  String subtext;

  Slide(this.image, this.heading, this.subtext);
}
