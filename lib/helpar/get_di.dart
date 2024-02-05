import 'package:get/get.dart';
import 'package:milkman/controller/addlocation_controller.dart';
import 'package:milkman/controller/cart_controller.dart';
import 'package:milkman/controller/catdetails_controller.dart';
import 'package:milkman/controller/fav_controller.dart';
import 'package:milkman/controller/home_controller.dart';
import 'package:milkman/controller/login_controller.dart';
import 'package:milkman/controller/myorder_controller.dart';
import 'package:milkman/controller/notification_controller.dart';
import 'package:milkman/controller/productdetails_controller.dart';
import 'package:milkman/controller/search_controller.dart';
import 'package:milkman/controller/signup_controller.dart';
import 'package:milkman/controller/stordata_controller.dart';
import 'package:milkman/controller/subscribe_controller.dart';
import 'package:milkman/controller/subscription_controller.dart';
import 'package:milkman/controller/wallet_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

init() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.lazyPut(() => sharedPreferences);
  Get.lazyPut(() => CatDetailsController());
  Get.lazyPut(() => AddLocationController());
  Get.lazyPut(() => PreScriptionControllre());
  Get.lazyPut(() => LoginController());
  Get.lazyPut(() => SignUpController());
  Get.lazyPut(() => HomePageController());
  Get.lazyPut(() => StoreDataContoller());
  Get.lazyPut(() => CartController());
  Get.lazyPut(() => ProductDetailsController());
  Get.lazyPut(() => FavController());
  Get.lazyPut(() => MyOrderController());
  Get.lazyPut(() => WalletController());
  Get.lazyPut(() => SearchController1());
  Get.lazyPut(() => NotificationController());
  Get.lazyPut(() => SubScibeController());
}
