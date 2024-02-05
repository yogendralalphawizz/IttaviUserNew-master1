// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:milkman/Api/data_store.dart';
import 'package:milkman/controller/signup_controller.dart';
import 'package:milkman/controller/wallet_controller.dart';
import 'package:milkman/helpar/routes_helper.dart';
import 'package:milkman/model/fontfamily_model.dart';
import 'package:milkman/model/model.dart';
import 'package:milkman/screen/language/language_screen.dart';
import 'package:milkman/utils/Colors.dart';
import 'package:milkman/utils/Custom_widget.dart';

import 'loginAndsignup/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  SignUpController signUpController = Get.find();
  WalletController walletController = Get.find();

  TextEditingController name = TextEditingController();
  TextEditingController number = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    setState(() {
      name.text = getData.read("UserLogin")["name"];
      number.text = getData.read("UserLogin")["mobile"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WhiteColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: WhiteColor,
        centerTitle: true,
        leading: BackButton(
          color: BlackColor,
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          "Profile".tr,
          style: TextStyle(
            fontFamily: FontFamily.gilroyBold,
            fontSize: 18,
            color: BlackColor,
          ),
        ),
      ),
      body: GetBuilder<SignUpController>(builder: (context) {
        return Column(
          children: [
            SizedBox(
              height: 5,
            ),
            Container(
              height: 70,
              width: Get.size.width,
              padding: EdgeInsets.symmetric(vertical: 8),
              margin: EdgeInsets.symmetric(horizontal: 15),
              alignment: Alignment.center,
              child: Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    height: 55,
                    width: 55,
                    alignment: Alignment.center,
                    child: Text(
                      getData.read("UserLogin")["name"][0],
                      style: TextStyle(
                        fontFamily: FontFamily.gilroyBold,
                        fontSize: 22,
                        color: gradient.defoultColor,
                      ),
                    ),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.shade200,
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          getData.read("UserLogin")["name"],
                          style: TextStyle(
                            fontFamily: FontFamily.gilroyBold,
                            fontSize: 15,
                            color: BlackColor,
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            Image.asset(
                              "assets/phone-call.png",
                              height: 15,
                              width: 15,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "${getData.read("UserLogin")["ccode"]} ${getData.read("UserLogin")["mobile"]}",
                              style: TextStyle(
                                fontFamily: FontFamily.gilroyMedium,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      editProfileBottomSheet();
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(5),
                      child: Image.asset(
                        "assets/edit.png",
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: model().profileList.length,
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      if (index == 0) {
                        Get.toNamed(Routes.myBookingScreen);
                      } else if (index == 1) {
                        Get.toNamed(Routes.mySubscriptionOrder);
                      } else if (index == 2) {
                        Get.toNamed(Routes.walletHistoryScreen);
                      } else if (index == 3) {
                        walletController.getReferData();
                        Get.toNamed(Routes.referFriendScreen);
                      }
                      // else if (index == 4) {
                      //   Get.toNamed(Routes.languageScreen);
                      //   // Get.to(LanguageScreen());
                      // }
                      else if (index == 4) {
                        deleteSheet();
                      } else if (index == 5) {
                        logoutSheet();
                      }
                    },
                    child: index == 6
                        ? GetBuilder<SignUpController>(builder: (context) {
                            return signUpController.isLoading
                                ? ListView.builder(
                                    itemCount: signUpController
                                        .pageListInfo?.pagelist.length,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () {
                                          Get.toNamed(Routes.loream,
                                              arguments: {
                                                "title": signUpController
                                                        .pageListInfo
                                                        ?.pagelist[index]
                                                        .title ??
                                                    "",
                                                "discription": signUpController
                                                        .pageListInfo
                                                        ?.pagelist[index]
                                                        .description ??
                                                    "",
                                              });
                                        },
                                        child: Container(
                                          height: 50,
                                          width: Get.size.width,
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 5),
                                          alignment: Alignment.center,
                                          child: Row(
                                            children: [
                                              Container(
                                                height: 35,
                                                width: 35,
                                                padding: EdgeInsets.all(6),
                                                alignment: Alignment.center,
                                                child: Image.asset(
                                                  "assets/ic_product.png",
                                                  color: BlackColor,
                                                ),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.grey.shade100,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  signUpController
                                                          .pageListInfo
                                                          ?.pagelist[index]
                                                          .title ??
                                                      "",
                                                  style: TextStyle(
                                                    fontFamily:
                                                        FontFamily.gilroyBold,
                                                    fontSize: 15,
                                                    color: BlackColor,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                height: 50,
                                                width: 50,
                                                padding: EdgeInsets.all(15),
                                                alignment: Alignment.center,
                                                child: Image.asset(
                                                  "assets/chevron-right.png",
                                                  color: Colors.grey.shade300,
                                                ),
                                              ),
                                            ],
                                          ),
                                          decoration: BoxDecoration(
                                            color: WhiteColor,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                : Center(
                                    child: CircularProgressIndicator(
                                      color: gradient.defoultColor,
                                    ),
                                  );
                          })
                        : Container(
                            height: 50,
                            width: Get.size.width,
                            margin: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 5),
                            alignment: Alignment.center,
                            child: Row(
                              children: [
                                Container(
                                  height: 35,
                                  width: 35,
                                  padding: EdgeInsets.all(6),
                                  alignment: Alignment.center,
                                  child: Image.asset(
                                    model().profileImg[index],
                                    color: BlackColor,
                                  ),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.grey.shade100,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Text(
                                    model().profileList[index],
                                    style: TextStyle(
                                      fontFamily: FontFamily.gilroyBold,
                                      fontSize: 15,
                                      color: BlackColor,
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 50,
                                  width: 50,
                                  padding: EdgeInsets.all(15),
                                  alignment: Alignment.center,
                                  child: Image.asset(
                                    "assets/chevron-right.png",
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                              ],
                            ),
                            decoration: BoxDecoration(
                              color: WhiteColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }

  Future logoutSheet() {
    return Get.bottomSheet(
      Container(
        height: 220,
        width: Get.size.width,
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
              "Logout".tr,
              style: TextStyle(
                fontSize: 20,
                fontFamily: FontFamily.gilroyBold,
                color: RedColor,
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
                color: greycolor,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Are you sure you want to log out?".tr,
              style: TextStyle(
                fontFamily: FontFamily.gilroyMedium,
                fontSize: 16,
                color: BlackColor,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      height: 60,
                      margin: EdgeInsets.all(15),
                      alignment: Alignment.center,
                      child: Text(
                        "Cancle".tr,
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
                    onTap: () async {
                      save("isBack", false);
                      getData.remove('Firstuser');
                      getData.remove("UserLogin");
                      getData.remove("lan");
                      getData.remove("lan1");
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                    },
                    child: Container(
                      height: 60,
                      margin: EdgeInsets.all(15),
                      alignment: Alignment.center,
                      child: Text(
                        "Yes, Logout".tr,
                        style: TextStyle(
                          color: WhiteColor,
                          fontFamily: FontFamily.gilroyBold,
                          fontSize: 16,
                        ),
                      ),
                      decoration: BoxDecoration(
                        gradient: gradient.btnGradient,
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
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
      ),
    );
  }

  Future editProfileBottomSheet() {
    return Get.bottomSheet(
      GetBuilder<SignUpController>(builder: (context) {
        return SingleChildScrollView(
          child: Container(
            height: 350,
            width: Get.size.width,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Edit Profile".tr,
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: FontFamily.gilroyBold,
                      color: BlackColor,
                    ),
                  ),
                  SizedBox(
                    height: 15,
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
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: TextFormField(
                      controller: name,
                      cursorColor: BlackColor,
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: FontFamily.gilroyMedium,
                        color: BlackColor,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter full name'.tr;
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Image.asset(
                            "assets/user.png",
                            height: 25,
                            width: 25,
                            color: greytext,
                          ),
                        ),
                        labelText: "Full Name".tr,
                        labelStyle: TextStyle(
                          color: greytext,
                          fontFamily: FontFamily.gilroyMedium,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: TextFormField(
                      controller: number,
                      cursorColor: BlackColor,
                      readOnly: true,
                      style: TextStyle(
                        fontFamily: FontFamily.gilroyMedium,
                        fontSize: 14,
                        color: BlackColor,
                      ),
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Image.asset(
                            "assets/phone-call.png",
                            height: 25,
                            width: 25,
                            color: greytext,
                          ),
                        ),
                        labelText: "Number".tr,
                        labelStyle: TextStyle(
                          color: greytext,
                          fontFamily: FontFamily.gilroyMedium,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GestButton(
                    Width: Get.size.width,
                    height: 50,
                    buttoncolor: gradient.defoultColor,
                    margin: EdgeInsets.only(top: 15, left: 30, right: 30),
                    buttontext: "Continue".tr,
                    style: TextStyle(
                      fontFamily: "Gilroy Bold",
                      color: WhiteColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    onclick: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        signUpController.editProfileApi(
                          name: name.text,
                          password: getData.read("UserLogin")["password"],
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            decoration: BoxDecoration(
              color: bgcolor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
          ),
        );
      }),
    );
  }

  Future deleteSheet() {
    return Get.bottomSheet(
      Container(
        height: 220,
        width: Get.size.width,
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
              "Delete Account".tr,
              style: TextStyle(
                fontSize: 20,
                fontFamily: FontFamily.gilroyBold,
                color: RedColor,
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
                color: greycolor,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Are you sure you want to delete account?".tr,
              style: TextStyle(
                fontFamily: FontFamily.gilroyMedium,
                fontSize: 16,
                color: BlackColor,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      height: 60,
                      margin: EdgeInsets.all(15),
                      alignment: Alignment.center,
                      child: Text(
                        "Cancle".tr,
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
                      walletController.deletAccount();
                    },
                    child: Container(
                      height: 60,
                      margin: EdgeInsets.all(15),
                      alignment: Alignment.center,
                      child: Text(
                        "Yes, Remove".tr,
                        style: TextStyle(
                          color: WhiteColor,
                          fontFamily: FontFamily.gilroyBold,
                          fontSize: 16,
                        ),
                      ),
                      decoration: BoxDecoration(
                        gradient: gradient.btnGradient,
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
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
      ),
    );
  }
}
