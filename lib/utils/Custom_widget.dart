// ignore_for_file: non_constant_identifier_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, file_names, avoid_print, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:milkman/Api/config.dart';
import 'package:milkman/controller/home_controller.dart';
import 'package:milkman/helpar/routes_helper.dart';
import 'package:milkman/model/fontfamily_model.dart';
import 'package:milkman/screen/home_screen.dart';
import 'package:milkman/utils/Colors.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../screen/bottombarpro_screen.dart';

Button(
    {String? buttontext,
    Function()? onclick,
    double? Width,
    Color? buttoncolor}) {
  return GestureDetector(
    onTap: onclick,
    child: Container(
      height: 50,
      width: Width,
      margin: EdgeInsets.all(15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: buttoncolor),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Image.asset(
              "assets/images/phone.png",
              color: WhiteColor,
            ),
          ),
          Text(
            buttontext!,
            style: TextStyle(
              fontFamily: "Gilroy Bold",
              color: WhiteColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
  );
}

GestButton({
  String? buttontext,
  Function()? onclick,
  double? Width,
  double? height,
  Color? buttoncolor,
  EdgeInsets? margin,
  TextStyle? style,
}) {
  return GestureDetector(
    onTap: onclick,
    child: Container(
      height: height,
      width: Width,
      // margin: EdgeInsets.only(top: 15, left: 30, right: 30),
      margin: margin,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: gradient.btnGradient,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: const Offset(
              0.5,
              0.5,
            ),
            blurRadius: 1,
          ), //BoxShadow
        ],
      ),
      child: Text(buttontext!, style: style),
    ),
  );
}

showToastMessage(message) {
  Fluttertoast.showToast(
    msg: message,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: BlackColor.withOpacity(0.9),
    textColor: Colors.white,
    fontSize: 14.0,
  );
}

void showDefaultSnackbar() {
  Get.showSnackbar(
    GetSnackBar(
        animationDuration: Duration(seconds: 0),
        backgroundGradient: gradient.btnGradient,
        snackStyle: SnackStyle.FLOATING,
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        borderRadius: 15,
        icon: Image.asset(
          "assets/shopping-bag-outline.png",
          scale: 25,
          color: WhiteColor,
        ),
        messageText: Text(
          "Your Cart".tr,
          style: TextStyle(
            fontFamily: FontFamily.gilroyBold,
            color: WhiteColor,
          ),
        ),
        mainButton: Container(
          height: 40,
          alignment: Alignment.center,
          padding: EdgeInsets.only(right: 15),
          child: Icon(
            Icons.arrow_forward,
            color: WhiteColor,
          ),
        )),
  );
}

Future<void> initPlatformState() async {
  OneSignal.initialize(Config.oneSignel);

  OneSignal.User.pushSubscription.addObserver((state) {
    print(OneSignal.User.pushSubscription.optedIn);
    print(OneSignal.User.pushSubscription.id);
    print(OneSignal.User.pushSubscription.token);
    print(state.current.jsonRepresentation());
  });
  OneSignal.Notifications.addPermissionObserver((state) {
    print("Has permission " + state.toString());
  });

  // print("--------------__uID : ${getData.read("UserLogin")["id"]}");
}

bgdecoration({Widget? child, EdgeInsetsGeometry? margin}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    margin: margin,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300)),
    child: child,
  );
}

//!-------- Order Placed Successfully! Sheet ---------!//
Future OrderPlacedSuccessfully() {
  HomePageController homePageController = Get.find();
  return Get.bottomSheet(
    enableDrag: false,
    WillPopScope(
      onWillPop: () async {
        homePageController.getHomeDataApi();
        Get.offAll(HomeScreen());
        return Future.value(false);
      },
      child: Container(
        height: Get.size.height,
        width: Get.size.width,
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    homePageController.getHomeDataApi();
                    Get.offAll(BottombarProScreen());
                  },
                  icon: Icon(
                    Icons.close,
                    color: BlackColor,
                  ),
                )
              ],
            ),
            Container(
              height: 135,
              width: 150,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/order1.png"),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Order Placed Successfully!".tr,
              style: TextStyle(
                fontFamily: FontFamily.gilroyBold,
                fontSize: 20,
                color: BlackColor,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "Thank you for your order! Our team is \n working hard to package and ship your \n items as soon as possible."
                  .tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: FontFamily.gilroyMedium,
                height: 1.4,
                fontSize: 15,
              ),
            ),
            Spacer(),
            GestButton(
              height: 50,
              Width: Get.size.width,
              margin: EdgeInsets.only(top: 10, left: 15, right: 15),
              buttontext: "Home".tr,
              style: TextStyle(
                fontFamily: FontFamily.gilroyBold,
                color: WhiteColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              onclick: () {
                homePageController.getHomeDataApi();
                Get.offAll(BottombarProScreen());
              },
            ),
            SizedBox(
              height: 20,
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
      ),
    ),
  );
}

priscriptionSuccessFullSheet() {
  return showModalBottomSheet(
    context: Get.context!,
    backgroundColor: boxcolor,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
    ),
    enableDrag: false,
    builder: (context) {
      return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Container(
          height: 400,
          width: Get.size.width,
          child: Column(
            children: [
              SizedBox(
                height: 25,
              ),
              Image.asset(
                "assets/order1.png",
                height: 130,
                width: 150,
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 220,
                child: Text(
                  "Your prescription was uploaded and sent successfully".tr,
                  maxLines: 3,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: FontFamily.gilroyBold,
                    height: 1.3,
                    fontSize: 20,
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  "Once the store processes your order,\n your cart will be ready for checkout."
                      .tr,
                  style: TextStyle(
                    fontFamily: FontFamily.gilroyMedium,
                    color: greyColor,
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              InkWell(
                onTap: () {
                  Get.offAndToNamed(Routes.bottombarProScreen);
                },
                child: Container(
                  height: 50,
                  width: Get.size.width,
                  margin: EdgeInsets.only(left: 15, right: 15, bottom: 15),
                  alignment: Alignment.center,
                  child: Text(
                    "Home".tr,
                    style: TextStyle(
                      color: WhiteColor,
                      fontFamily: FontFamily.gilroyBold,
                      fontSize: 17,
                    ),
                  ),
                  decoration: BoxDecoration(
                    gradient: gradient.btnGradient,
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ],
          ),
          decoration: BoxDecoration(
            color: WhiteColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
        ),
      );
    },
  );
}

ordermassage({String? massage}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    alignment: Alignment.center,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12), color: WhiteColor),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          "assets/info-circle.png",
          height: 20,
          width: 20,
          color: gradient.defoultColor,
        ),
        SizedBox(width: Get.height * 0.01),
        SizedBox(
          width: Get.width * 0.7,
          child: Text(massage!,
              textAlign: TextAlign.start,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontFamily: FontFamily.gilroyBold,
                  color: gradient.defoultColor,
                  fontSize: 16)),
        ),
      ],
    ),
  );
}

Widget passwordtextfield(
    {Widget? suffixIcon,
    Widget? prefixIcon,
    String? lebaltext,
    double? width,
    bool? obscureText,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    TextEditingController? controller}) {
  return Container(
    width: width,
    // height: 50,
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
    child: TextFormField(
      controller: controller,
      obscureText: obscureText!,
      readOnly: false,
      validator: validator,
      keyboardType: keyboardType,
      style: TextStyle(
        fontSize: 16,
        fontFamily: "Gilroy Medium",
        color: BlackColor,
      ),
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        labelText: lebaltext,
        labelStyle: TextStyle(color: greycolor, fontSize: 16),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: greytext),
          borderRadius: BorderRadius.circular(15),
        ),
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15))),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: greycolor,
            ),
            borderRadius: BorderRadius.circular(15)),
      ),
    ),
  );
}
