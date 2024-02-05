// ignore_for_file: prefer_const_constructors

import 'package:get/get.dart';
import 'package:milkman/screen/addlocation/addressdetails_screen.dart';
import 'package:milkman/screen/addlocation/deliveryaddress1.dart';
import 'package:milkman/screen/addlocation/deliveryaddress2.dart';
import 'package:milkman/screen/bottombarpro_screen.dart';
import 'package:milkman/screen/category_screen.dart';
import 'package:milkman/screen/categorydetails_screen.dart';
import 'package:milkman/screen/coupon_screen.dart';
import 'package:milkman/screen/home_screen.dart';
import 'package:milkman/screen/home_search.dart';
import 'package:milkman/screen/language/language_screen.dart';
import 'package:milkman/screen/loginAndsignup/login_screen.dart';
import 'package:milkman/screen/loginAndsignup/otp_screen.dart';
import 'package:milkman/screen/loginAndsignup/resetpassword_screen.dart';
import 'package:milkman/screen/loginAndsignup/signup_screen.dart';
import 'package:milkman/screen/loream_screen.dart';
import 'package:milkman/screen/my%20booking/mybooking_screen.dart';
import 'package:milkman/screen/my%20booking/mybookinginfo_screen.dart';
import 'package:milkman/screen/notification_screen.dart';
import 'package:milkman/screen/onbording_screen.dart';
import 'package:milkman/screen/profile_screen.dart';
import 'package:milkman/screen/refer&earn_screen.dart';
import 'package:milkman/screen/subscribe/subscribe_screen.dart';
import 'package:milkman/screen/wallet/addwallet_screen.dart';
import 'package:milkman/screen/wallet/wallethistory_screen.dart';

import '../screen/mysubscription/mysubscription_order.dart';
import '../screen/mysubscription/mysubscriptioninfo_screen.dart';


class Routes {
  static String initial = "/";
  static String homeScreen = "/homeScreen";
  static String categoryScreen = "/categoryScreen";
  static String categoryDetailsScreen = "/categoryDetailsScreen";
  static String productDetailsScreen = "/productDetailsScreen";
  static String bottombarProScreen = "/bottombarProScreen";
  static String couponScreen = "/couponScreen";
  static String deliveryaddress1 = "/deliveryaddress1";
  static String deliveryaddress2 = "/deliveryaddress2";
  static String addressDetailsScreen = "/addressDetailsScreen";
  static String prescriptionDetails = "/prescriptionDetails";
  static String profileScreen = "/profileScreen";
  static String myBookingScreen = "/myBookingScreen";
  //! ----------- Login And Signup -----------!//
  static String loginScreen = "/loginScreen";
  static String signUpScreen = "/signUpScreen";
  static String otpScreen = '/otpScreen';
  static String resetPassword = "/resetPassword";
  //!---------------------------------------!//
  static String loream = "/loream";
  static String orderdetailsScreen = "/OrderdetailsScreen";
  static String mySubscriptionOrder = "/MySubscriptionOrder";
  static String mySubscriptionInfo = "/MySubscriptionInfo";

  static String walletHistoryScreen = "/walletHistoryScreen";
  static String addWalletScreen = "/addWalletScreen";

  static String homeSearchScreen = "/homeSearchScreen";

  static String referFriendScreen = "/referFriendScreen";
  static String notificationScreen = "/notificationScreen";

  static String subScribeScreen = "/subScribeScreen";
  static String languageScreen = "/languageScreen";
}

final getPages = [
  GetPage(
    name: Routes.initial,
    page: () => onbording(),
  ),
  GetPage(
    name: Routes.homeScreen,
    page: () => HomeScreen(),
  ),
  GetPage(
    name: Routes.categoryScreen,
    page: () => CategoryScreen(),
  ),
  GetPage(
    name: Routes.categoryDetailsScreen,
    page: () => CategoryDetailsScreen(),
  ),
  // GetPage(
  //   name: Routes.productDetailsScreen,
  //   page: () => ProductDetailsScreen(),
  // ),
  GetPage(
    name: Routes.bottombarProScreen,
    page: () => BottombarProScreen(),
  ),
  GetPage(
    name: Routes.couponScreen,
    page: () => CouponScreen(),
  ),
  GetPage(
    name: Routes.deliveryaddress1,
    page: () => DeliveryAddress1(),
  ),
  GetPage(
    name: Routes.deliveryaddress2,
    page: () => DelieryAddress2(),
  ),
  GetPage(
    name: Routes.addressDetailsScreen,
    page: () => AddressDetailsScreen(),
  ),
  GetPage(
    name: Routes.profileScreen,
    page: () => ProfileScreen(),
  ),
  GetPage(
    name: Routes.myBookingScreen,
    page: () => MyBookingScreen(),
  ),
  GetPage(
    name: Routes.loginScreen,
    page: () => LoginScreen(),
  ),
  GetPage(
    name: Routes.signUpScreen,
    page: () => SignUpScreen(),
  ),
  GetPage(
    name: Routes.otpScreen,
    page: () => OtpScreen(),
  ),
  GetPage(
    name: Routes.resetPassword,
    page: () => ResetPasswordScreen(),
  ),
  GetPage(
    name: Routes.loream,
    page: () => Loream(),
  ),
  GetPage(
    name: Routes.orderdetailsScreen,
    page: () => OrderdetailsScreen(),
  ),
  GetPage(
    name: Routes.mySubscriptionOrder,
    page: () => MySubscriptionOrder(),
  ),
  GetPage(
    name: Routes.mySubscriptionInfo,
    page: () => MySubscriptionInfo(),
  ),
  GetPage(
    name: Routes.walletHistoryScreen,
    page: () => WalletHistoryScreen(),
  ),
  GetPage(
    name: Routes.addWalletScreen,
    page: () => AddWalletScreen(),
  ),
  GetPage(
    name: Routes.homeSearchScreen,
    page: () => HomeSearchScreen(),
  ),
  GetPage(
    name: Routes.referFriendScreen,
    page: () => ReferFriendScreen(),
  ),
  GetPage(
    name: Routes.languageScreen,
    page: () => LanguageScreen(),
  ),

  GetPage(
    name: Routes.notificationScreen,
    page: () => NotificationScreen(),
  ),
  GetPage(
    name: Routes.subScribeScreen,
    page: () => SubScribeScreen(),
  ),
];
