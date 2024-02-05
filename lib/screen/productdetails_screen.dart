// // ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, unrelated_type_equality_checks, unnecessary_brace_in_string_interps, prefer_interpolation_to_compose_strings, avoid_print, unused_local_variable, prefer_is_empty

// import 'dart:ui' as ui;
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:milkman/Api/config.dart';
// import 'package:milkman/controller/cart_controller.dart';
// import 'package:milkman/controller/catdetails_controller.dart';
// import 'package:milkman/controller/fav_controller.dart';
// import 'package:milkman/controller/home_controller.dart';
// import 'package:milkman/controller/productdetails_controller.dart';
// import 'package:milkman/controller/stordata_controller.dart';
// import 'package:milkman/model/fontfamily_model.dart';
// import 'package:milkman/screen/home_screen.dart';
// import 'package:milkman/utils/Colors.dart';
// import 'package:milkman/utils/Custom_widget.dart';
// import 'package:milkman/utils/cart_item.dart';

// class ProductDetailsScreen extends StatefulWidget {
//   const ProductDetailsScreen({super.key});

//   @override
//   State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
// }

// class _ProductDetailsScreenState extends State<ProductDetailsScreen>
//     with SingleTickerProviderStateMixin {
//   ProductDetailsController productDetailsController = Get.find();
//   FavController favController = Get.find();
//   CartController cartController = Get.find();
//   StoreDataContoller storeDataContoller = Get.find();
//   CatDetailsController catDetailsController = Get.find();
//   HomePageController homePageController = Get.find();
//   int selectIndex = 0;

//   late GoogleMapController mapController;
//   final List<Marker> _markers = <Marker>[];
//   late Box<CartItem> cart;
//   late final List<CartItem> items;

//   late AnimationController controller;
//   late Animation<Offset> offset;

//   @override
//   void initState() {
//     cart = Hive.box<CartItem>('cart');
//     super.initState();
//     controller =
//         AnimationController(vsync: this, duration: Duration(milliseconds: 500));

//     offset = Tween<Offset>(begin: Offset.zero, end: Offset(0.0, 1.0))
//         .animate(controller);
//     setupHive();
//     loadData();
//   }

//   Future<void> setupHive() async {
//     await Hive.initFlutter();
//     cart = Hive.box<CartItem>('cart');
//     AsyncSnapshot.waiting();
//     List list = [];
//     for (var element in cart.values) {
//       if (element.storeID == productDetailsController.sID) {
//         list.add(element.id);
//       }
//     }
//     if (list.length == 0) {
//       controller.forward();
//     } else {
//       controller.reverse();
//     }
//   }

//   Future<Uint8List> getImages(String path, int width) async {
//     ByteData data = await rootBundle.load(path);
//     ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
//         targetHeight: width);
//     ui.FrameInfo fi = await codec.getNextFrame();
//     return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
//         .buffer
//         .asUint8List();
//   }

//   loadData() async {
//     final Uint8List markIcons =
//         await getImages("assets/ic_destination_long.png", 50);
//     // makers added according to index
//     _markers.add(
//       Marker(
//         // given marker id
//         markerId: MarkerId("1"),
//         // given marker icon
//         icon: BitmapDescriptor.fromBytes(markIcons),
//         // given position
//         position: LatLng(
//           productDetailsController.lat,
//           productDetailsController.long,
//         ),
//         infoWindow: InfoWindow(),
//       ),
//     );
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: bgcolor,
//       appBar: AppBar(
//         backgroundColor: WhiteColor,
//         elevation: 0,
//         leading: BackButton(
//           color: BlackColor,
//           onPressed: () {
//             Get.back();
//           },
//         ),
//         title: Text(
//           productDetailsController.productInfo?.productData.title ?? "",
//           maxLines: 1,
//           style: TextStyle(
//             color: BlackColor,
//             fontFamily: FontFamily.gilroyBold,
//             fontSize: 18,
//             overflow: TextOverflow.ellipsis,
//           ),
//         ),
//       ),
//       body: GetBuilder<ProductDetailsController>(builder: (context) {
//         return Stack(
//           children: [
//             SizedBox(
//               height: Get.size.height,
//               width: Get.size.width,
//               child: productDetailsController.isLoading
//                   ? SingleChildScrollView(
//                       child: Column(
//                         children: [
//                           Stack(
//                             children: [
//                               Container(
//                                 color: WhiteColor,
//                                 height: Get.size.height * 0.4,
//                                 child: PageView.builder(
//                                   itemCount: productDetailsController
//                                       .productInfo?.productData.img.length,
//                                   physics: BouncingScrollPhysics(),
//                                   itemBuilder: (context, index) {
//                                     return Stack(
//                                       children: [
//                                         Container(
//                                           alignment: Alignment.center,
//                                           margin: EdgeInsets.symmetric(
//                                               horizontal: 15, vertical: 8),
//                                           child: ClipRRect(
//                                             borderRadius:
//                                                 BorderRadius.circular(15),
//                                             child: FadeInImage.assetNetwork(
//                                               placeholder:
//                                                   "assets/ezgif.com-crop.gif",
//                                               placeholderFit: BoxFit.fill,
//                                               image:
//                                                   "${Config.imageUrl}${productDetailsController.productInfo?.productData.img[index] ?? ""}",
//                                               fit: BoxFit.cover,
//                                             ),
//                                           ),
//                                           decoration: BoxDecoration(
//                                             borderRadius:
//                                                 BorderRadius.circular(15),
//                                           ),
//                                         ),
//                                         Positioned(
//                                           bottom: 10,
//                                           left: 15,
//                                           right: 15,
//                                           child: Container(
//                                             height: 50,
//                                             width: Get.size.width,
//                                             decoration: BoxDecoration(
//                                               image: DecorationImage(
//                                                 image: AssetImage(
//                                                     "assets/Rectangle.png"),
//                                                 fit: BoxFit.fill,
//                                               ),
//                                               borderRadius: BorderRadius.only(
//                                                 bottomLeft: Radius.circular(15),
//                                                 bottomRight:
//                                                     Radius.circular(15),
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     );
//                                   },
//                                   onPageChanged: (value) {
//                                     setState(() {
//                                       selectIndex = value;
//                                     });
//                                   },
//                                 ),
//                               ),
//                               Positioned(
//                                 bottom: 10,
//                                 child: SizedBox(
//                                   height: 25,
//                                   width: Get.size.width,
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       ...List.generate(
//                                           productDetailsController.productInfo!
//                                               .productData.img.length, (index) {
//                                         return Indicator(
//                                           isActive: selectIndex == index
//                                               ? true
//                                               : false,
//                                         );
//                                       }),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           Container(
//                             color: WhiteColor,
//                             padding: EdgeInsets.only(right: 15),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 SizedBox(
//                                   height: 15,
//                                 ),
//                                 // Padding(
//                                 //   padding: const EdgeInsets.only(left: 15),
//                                 //   child: Text(
//                                 //     "Meraki By Shilpa",
//                                 //     style: TextStyle(
//                                 //       fontFamily: FontFamily.gilroyMedium,
//                                 //       fontWeight: FontWeight.w400,
//                                 //       fontSize: 17,
//                                 //       color: gradient.defoultColor,
//                                 //     ),
//                                 //   ),
//                                 // ),
//                                 // SizedBox(
//                                 //   height: 12,
//                                 // ),
//                                 // Padding(
//                                 //   padding: const EdgeInsets.only(left: 15),
//                                 //   child: Container(
//                                 //     height: 30,
//                                 //     width: 130,
//                                 //     alignment: Alignment.center,
//                                 //     child: Text(
//                                 //       "RECOMMENDED",
//                                 //       style: TextStyle(
//                                 //         fontFamily: FontFamily.gilroyMedium,
//                                 //         color: WhiteColor,
//                                 //         fontSize: 14,
//                                 //       ),
//                                 //     ),
//                                 //     decoration: BoxDecoration(
//                                 //       borderRadius: BorderRadius.only(
//                                 //         topRight: Radius.circular(10),
//                                 //         bottomLeft: Radius.circular(10),
//                                 //       ),
//                                 //       gradient: gradient.btnGradient,
//                                 //     ),
//                                 //   ),
//                                 // ),
//                                 // SizedBox(
//                                 //   height: 10,
//                                 // ),
//                                 Padding(
//                                   padding: const EdgeInsets.only(left: 15),
//                                   child: Text(
//                                     productDetailsController
//                                             .productInfo?.productData.title ??
//                                         "",
//                                     maxLines: 2,
//                                     style: TextStyle(
//                                       fontFamily: FontFamily.gilroyBold,
//                                       fontSize: 18,
//                                       color: BlackColor,
//                                       overflow: TextOverflow.ellipsis,
//                                     ),
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding:
//                                       const EdgeInsets.only(left: 15, top: 5),
//                                   child: HtmlWidget(
//                                     productDetailsController.productInfo
//                                             ?.productData.description ??
//                                         "",
//                                     textStyle: TextStyle(
//                                       fontFamily: FontFamily.gilroyMedium,
//                                       fontSize: 11,
//                                       color: BlackColor,
//                                     ),
//                                   ),
//                                 ),
//                                 // Padding(
//                                 //   padding: const EdgeInsets.only(left: 15, top: 5),
//                                 //   child: Text(
//                                 //     "Primium SLS-free.",
//                                 //     style: TextStyle(
//                                 //       fontFamily: FontFamily.gilroyMedium,
//                                 //       fontSize: 13,
//                                 //       color: BlackColor,
//                                 //     ),
//                                 //   ),
//                                 // ),
//                                 // Padding(
//                                 //   padding: const EdgeInsets.only(left: 15, top: 2),
//                                 //   child: Text(
//                                 //     "Mica free.",
//                                 //     style: TextStyle(
//                                 //       fontFamily: FontFamily.gilroyMedium,
//                                 //       fontSize: 13,
//                                 //       color: BlackColor,
//                                 //     ),
//                                 //   ),
//                                 // ),
//                                 // Padding(
//                                 //   padding: const EdgeInsets.only(left: 15, top: 2),
//                                 //   child: Text(
//                                 //     "Fragrance oil free.",
//                                 //     style: TextStyle(
//                                 //       fontFamily: FontFamily.gilroyMedium,
//                                 //       fontSize: 13,
//                                 //       color: BlackColor,
//                                 //     ),
//                                 //   ),
//                                 // ),
//                                 // Padding(
//                                 //   padding: const EdgeInsets.only(left: 15, top: 2),
//                                 //   child: Text(
//                                 //     "Artificial colors free.",
//                                 //     style: TextStyle(
//                                 //       fontFamily: FontFamily.gilroyMedium,
//                                 //       fontSize: 13,
//                                 //       color: BlackColor,
//                                 //     ),
//                                 //   ),
//                                 // ),
//                                 // SizedBox(
//                                 //   height: 15,
//                                 // ),
//                                 // Padding(
//                                 //   padding: const EdgeInsets.only(left: 15, top: 2),
//                                 //   child: Text(
//                                 //     "Key Ingredients - kaolin cly,",
//                                 //     style: TextStyle(
//                                 //       fontFamily: FontFamily.gilroyMedium,
//                                 //       fontSize: 14,
//                                 //       color: BlackColor,
//                                 //     ),
//                                 //   ),
//                                 // ),
//                                 // SizedBox(
//                                 //   height: 15,
//                                 // ),
//                                 // Padding(
//                                 //   padding: const EdgeInsets.only(left: 15, top: 2),
//                                 //   child: Text(
//                                 //     "Gently cleanses the skin.",
//                                 //     style: TextStyle(
//                                 //       fontFamily: FontFamily.gilroyMedium,
//                                 //       fontSize: 15,
//                                 //       color: BlackColor,
//                                 //     ),
//                                 //   ),
//                                 // ),
//                                 // SizedBox(
//                                 //   height: 15,
//                                 // ),
//                                 // Padding(
//                                 //   padding: const EdgeInsets.only(left: 15, top: 2),
//                                 //   child: Text(
//                                 //     "Extend the life of your soap: Place your soap in a dish that drains and not on a flat surface or in a non-draining dish.",
//                                 //     maxLines: 3,
//                                 //     style: TextStyle(
//                                 //       fontFamily: FontFamily.gilroyMedium,
//                                 //       fontSize: 15,
//                                 //       color: BlackColor,
//                                 //       overflow: TextOverflow.ellipsis,
//                                 //     ),
//                                 //   ),
//                                 // ),
//                                 SizedBox(
//                                   height: 15,
//                                 ),
//                                 Padding(
//                                   padding:
//                                       const EdgeInsets.only(left: 15, top: 2),
//                                   child: Text(
//                                     "Disclaimer:",
//                                     style: TextStyle(
//                                       fontFamily: FontFamily.gilroyMedium,
//                                       fontSize: 15,
//                                       color: BlackColor,
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   height: 15,
//                                 ),
//                                 Padding(
//                                   padding:
//                                       const EdgeInsets.only(left: 15, top: 2),
//                                   child: HtmlWidget(
//                                     productDetailsController.productInfo
//                                             ?.productData.disclaimer ??
//                                         "",
//                                     textStyle: TextStyle(
//                                       fontFamily: FontFamily.gilroyMedium,
//                                       fontSize: 11,
//                                       color: BlackColor,
//                                     ),
//                                   ),
//                                 ),
//                                 productDetailsController.productInfo
//                                             ?.productData.isRequire ==
//                                         "1"
//                                     ? SizedBox(
//                                         height: 10,
//                                       )
//                                     : SizedBox(),
//                                 productDetailsController.productInfo
//                                             ?.productData.isRequire ==
//                                         "1"
//                                     ? Padding(
//                                         padding: EdgeInsets.only(left: 15),
//                                         child: Row(
//                                           children: [
//                                             Image.asset(
//                                               "assets/rx1.png",
//                                               height: 20,
//                                               width: 20,
//                                             ),
//                                             SizedBox(
//                                               width: 5,
//                                             ),
//                                             Text(
//                                               "Rx Required".tr,
//                                               style: TextStyle(
//                                                 fontFamily:
//                                                     FontFamily.gilroyMedium,
//                                                 fontSize: 15,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       )
//                                     : SizedBox(),
//                                 SizedBox(
//                                   height: 15,
//                                 ),
//                                 Row(
//                                   children: [
//                                     SizedBox(
//                                       width: 5,
//                                     ),
//                                     Expanded(
//                                       child: Padding(
//                                         padding: EdgeInsets.only(left: 10),
//                                         child: Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Row(
//                                               children: [
//                                                 Text(
//                                                   "${currency}${productDetailsController.productInfo?.productData.sprice}",
//                                                   style: TextStyle(
//                                                     color: BlackColor,
//                                                     fontSize: 17,
//                                                     fontFamily:
//                                                         FontFamily.gilroyBold,
//                                                   ),
//                                                 ),
//                                                 SizedBox(
//                                                   width: 10,
//                                                 ),
//                                                 Container(
//                                                   height: 30,
//                                                   width: 80,
//                                                   alignment: Alignment.center,
//                                                   child: Text(
//                                                     "(${productDetailsController.productInfo?.productData.percentage}% Off)",
//                                                     style: TextStyle(
//                                                       fontFamily: FontFamily
//                                                           .gilroyMedium,
//                                                       fontSize: 14,
//                                                       color: WhiteColor,
//                                                     ),
//                                                   ),
//                                                   decoration: BoxDecoration(
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                               8),
//                                                       gradient:
//                                                           gradient.btnGradient),
//                                                 )
//                                               ],
//                                             ),
//                                             Text(
//                                               "${currency}${productDetailsController.productInfo?.productData.aprice}",
//                                               style: TextStyle(
//                                                   color: greytext,
//                                                   fontFamily:
//                                                       FontFamily.gilroyBold,
//                                                   fontSize: 15,
//                                                   decoration: TextDecoration
//                                                       .lineThrough),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       width: 5,
//                                     ),
//                                     isItem(productDetailsController
//                                                 .productInfo?.productData.id
//                                                 .toString()) !=
//                                             "0"
//                                         ? Container(
//                                             height: 40,
//                                             width: 130,
//                                             margin: EdgeInsets.all(5),
//                                             alignment: Alignment.center,
//                                             child: Row(
//                                               children: [
//                                                 SizedBox(
//                                                   width: 7,
//                                                 ),
//                                                 InkWell(
//                                                   onTap: () {
//                                                     setState(() {
//                                                       onRemoveItem(
//                                                           0,
//                                                           isItem(
//                                                               productDetailsController
//                                                                   .productInfo
//                                                                   ?.productData
//                                                                   .id
//                                                                   .toString()));
//                                                     });
//                                                   },
//                                                   child: Container(
//                                                     height: 30,
//                                                     width: 30,
//                                                     alignment: Alignment.center,
//                                                     child: Icon(
//                                                       Icons.remove,
//                                                       color:
//                                                           gradient.defoultColor,
//                                                       size: 18,
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 Expanded(
//                                                   child: Container(
//                                                     alignment: Alignment.center,
//                                                     child: Text(
//                                                       isItem(productDetailsController
//                                                               .productInfo
//                                                               ?.productData
//                                                               .id)
//                                                           .toString(),
//                                                       style: TextStyle(
//                                                         color: gradient
//                                                             .defoultColor,
//                                                         fontFamily: FontFamily
//                                                             .gilroyBold,
//                                                         fontSize: 15,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 InkWell(
//                                                   onTap: () {
//                                                     setState(() {
//                                                       onAddItem(
//                                                           0,
//                                                           isItem(
//                                                               productDetailsController
//                                                                   .productInfo
//                                                                   ?.productData
//                                                                   .id));
//                                                     });
//                                                   },
//                                                   child: Container(
//                                                     height: 30,
//                                                     width: 30,
//                                                     alignment: Alignment.center,
//                                                     child: Icon(
//                                                       Icons.add,
//                                                       color:
//                                                           gradient.defoultColor,
//                                                       size: 18,
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 SizedBox(
//                                                   width: 7,
//                                                 ),
//                                               ],
//                                             ),
//                                             decoration: BoxDecoration(
//                                               borderRadius:
//                                                   BorderRadius.circular(10),
//                                               border: Border.all(
//                                                   color: Colors.grey.shade300),
//                                             ),
//                                           )
//                                         : InkWell(
//                                             onTap: () {
//                                               setState(() {
//                                                 onAddItem(
//                                                     0,
//                                                     isItem(
//                                                         productDetailsController
//                                                             .productInfo
//                                                             ?.productData
//                                                             .id));
//                                               });
//                                             },
//                                             child: Container(
//                                               height: 40,
//                                               width: 130,
//                                               margin: EdgeInsets.all(5),
//                                               alignment: Alignment.center,
//                                               child: Text(
//                                                 "Add".tr,
//                                                 style: TextStyle(
//                                                   color: gradient.defoultColor,
//                                                   fontFamily:
//                                                       FontFamily.gilroyBold,
//                                                   fontSize: 15,
//                                                 ),
//                                               ),
//                                               decoration: BoxDecoration(
//                                                 borderRadius:
//                                                     BorderRadius.circular(10),
//                                                 border: Border.all(
//                                                     color:
//                                                         Colors.grey.shade300),
//                                               ),
//                                             ),
//                                           ),
//                                   ],
//                                 ),

//                                 SizedBox(
//                                   height: 8,
//                                 ),
//                                 Padding(
//                                   padding: EdgeInsets.symmetric(horizontal: 10),
//                                   child: Divider(),
//                                 ),
//                                 SizedBox(
//                                   height: 8,
//                                 ),
//                                 Padding(
//                                   padding: EdgeInsets.only(left: 10),
//                                   child: Text(
//                                     "Orders and delivery".tr,
//                                     maxLines: 1,
//                                     style: TextStyle(
//                                       fontFamily: FontFamily.gilroyBold,
//                                       fontSize: 18,
//                                       color: BlackColor,
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   height: 5,
//                                 ),
//                                 catDRow(
//                                   img: "assets/box.png",
//                                   text:
//                                       "${"All orders will be Delivered by".tr} ${productDetailsController.strName}",
//                                 ),
//                                 SizedBox(
//                                   height: 5,
//                                 ),
//                                 catDRow(
//                                   img: "assets/star.png",
//                                   text: "Delivery fee will apply".tr,
//                                 ),
//                                 SizedBox(
//                                   height: 5,
//                                 ),
//                                 catDRow(
//                                   img: "assets/clock.png",
//                                   text:
//                                       "Usually dispatches orders on the same day"
//                                           .tr,
//                                 ),
//                                 SizedBox(
//                                   height: 8,
//                                 ),
//                                 Padding(
//                                   padding: EdgeInsets.symmetric(horizontal: 10),
//                                   child: Divider(),
//                                 ),
//                                 SizedBox(
//                                   height: 8,
//                                 ),
//                                 Row(
//                                   children: [
//                                     SizedBox(
//                                       width: 10,
//                                     ),
//                                     Container(
//                                       height: 50,
//                                       width: 50,
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(10),
//                                         image: DecorationImage(
//                                           image: NetworkImage(Config.imageUrl +
//                                               productDetailsController.logo),
//                                           fit: BoxFit.cover,
//                                         ),
//                                       ),
//                                     ),
//                                     SizedBox(width: 10),
//                                     Expanded(
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         children: [
//                                           Text(
//                                             productDetailsController.strName,
//                                             maxLines: 1,
//                                             style: TextStyle(
//                                               fontFamily: FontFamily.gilroyBold,
//                                               fontSize: 18,
//                                               color: BlackColor,
//                                               overflow: TextOverflow.ellipsis,
//                                             ),
//                                           ),
//                                           Text(
//                                             productDetailsController.slogan,
//                                             maxLines: 1,
//                                             style: TextStyle(
//                                               fontFamily:
//                                                   FontFamily.gilroyMedium,
//                                               fontSize: 15,
//                                               color: BlackColor,
//                                               overflow: TextOverflow.ellipsis,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     InkWell(
//                                       onTap: () {
//                                         if (productDetailsController.isFev ==
//                                             0) {
//                                           favController.addFavAndRemoveApi(
//                                             storeId:
//                                                 productDetailsController.sID,
//                                           );
//                                           setState(() {
//                                             productDetailsController.isFev = 1;
//                                           });
//                                         } else {
//                                           favController.addFavAndRemoveApi(
//                                             storeId:
//                                                 productDetailsController.sID,
//                                           );
//                                           setState(() {
//                                             productDetailsController.isFev = 0;
//                                           });
//                                         }
//                                       },
//                                       child: Container(
//                                         height: 50,
//                                         width: 50,
//                                         alignment: Alignment.center,
//                                         child: productDetailsController.isFev ==
//                                                 0
//                                             ? Image.asset(
//                                                 "assets/heartOutlinded.png",
//                                                 height: 25,
//                                                 width: 25,
//                                                 color: gradient.defoultColor,
//                                               )
//                                             : Image.asset(
//                                                 "assets/heart.png",
//                                                 height: 25,
//                                                 width: 25,
//                                               ),
//                                         decoration: BoxDecoration(
//                                           gradient: gradient.lightGradient,
//                                           borderRadius:
//                                               BorderRadius.circular(10),
//                                         ),
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       width: 15,
//                                     ),
//                                   ],
//                                 ),
//                                 SizedBox(
//                                   height: 10,
//                                 ),
//                                 Container(
//                                   height: 120,
//                                   width: Get.size.width,
//                                   margin: EdgeInsets.all(10),
//                                   child: ClipRRect(
//                                     borderRadius: BorderRadius.circular(10),
//                                     child: GoogleMap(
//                                       initialCameraPosition: CameraPosition(
//                                         target: LatLng(
//                                           productDetailsController.lat,
//                                           productDetailsController.long,
//                                         ),
//                                         zoom: 8,
//                                       ),
//                                       mapType: MapType.normal,
//                                       markers: Set<Marker>.of(_markers),
//                                       myLocationEnabled: true,
//                                       compassEnabled: true,
//                                       zoomGesturesEnabled: true,
//                                       tiltGesturesEnabled: true,
//                                       zoomControlsEnabled: true,
//                                       onMapCreated: (controller) {
//                                         setState(() {
//                                           mapController = controller;
//                                         });
//                                       },
//                                     ),
//                                   ),
//                                   decoration: BoxDecoration(
//                                     border: Border.all(color: greyColor),
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding: EdgeInsets.only(left: 10),
//                                   child: Text(
//                                     productDetailsController.strAddress,
//                                     maxLines: 2,
//                                     style: TextStyle(
//                                       fontFamily: FontFamily.gilroyMedium,
//                                       fontSize: 14,
//                                       overflow: TextOverflow.ellipsis,
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   height: 30,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     )
//                   : Center(
//                       child: CircularProgressIndicator(),
//                     ),
//             ),
//           ],
//         );
//       }),
//     );
//   }

//   Widget catDRow({String? img, text}) {
//     return Padding(
//       padding: EdgeInsets.only(top: 5),
//       child: Row(
//         children: [
//           SizedBox(
//             width: 10,
//           ),
//           Image.asset(
//             img ?? "",
//             height: 15,
//             width: 15,
//             color: BlackColor,
//           ),
//           SizedBox(
//             width: 5,
//           ),
//           Expanded(
//             child: Text(
//               text,
//               maxLines: 1,
//               style: TextStyle(
//                 color: BlackColor,
//                 fontFamily: FontFamily.gilroyMedium,
//                 fontSize: 15,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),
//           ),
//           SizedBox(
//             width: 10,
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> onAddItem(int index, String qtys, {String? object}) async {
//     String? id =
//         productDetailsController.productInfo?.productData.id.toString();
//     String? price =
//         productDetailsController.productInfo?.productData.sprice.toString();
//     int? qty = int.parse(qtys);

//     qty = qty + 1;

//     cart = Hive.box<CartItem>('cart');
//     final newItem = CartItem();
//     newItem.id = id;
//     newItem.price = double.parse(price!);
//     newItem.quantity = qty;
//     newItem.productPrice = double.parse(price);
//     newItem.strTitle =
//         productDetailsController.productInfo?.productData.title ?? "";
//     newItem.per =
//         productDetailsController.productInfo?.productData.percentage.toString();
//     newItem.isRequride =
//         productDetailsController.productInfo?.productData.isRequire.toString();
//     newItem.qLimit = productDetailsController.productInfo?.productData.qlimit;
//     newItem.storeID = storeDataContoller.storeDataInfo?.storeInfo.storeId;
//     newItem.sPrice = double.parse(
//         productDetailsController.productInfo?.productData.aprice.toString() ??
//             "");

//     if (qtys == "0") {
//       cart.put(id, newItem);
//       catDetailsController.getCartLangth();
//       if (controller.status == AnimationStatus.completed) {
//         controller.reverse();
//       }
//       // showDefaultSnackbar();
//       // catDetailsController.getCartLangth();
//       setState(() {});
//     } else {
//       if (int.parse(
//               isItem(productDetailsController.productInfo?.productData.id)) <
//           int.parse(
//               productDetailsController.productInfo?.productData.qlimit ?? "")) {
//         var item = cart.get(id);
//         item?.quantity = qty;
//         cart.put(id, item!);
//       } else {
//         showToastMessage("Exceeded the maximum quantity limit per order!".tr);
//       }
//     }
//   }

//   void onRemoveItem(int index, String qtys) {
//     String? id =
//         productDetailsController.productInfo?.productData.id.toString();
//     String? price =
//         productDetailsController.productInfo?.productData.sprice.toString();
//     int? qty = int.parse(qtys);
//     qty = qty - 1;
//     cart = Hive.box<CartItem>('cart');
//     if (qtys == "1") {
//       cart.delete(id);
//       if (controller.status == AnimationStatus.dismissed) {
//         controller.forward();
//       }
//       setState(() {});
//     } else {
//       var item = cart.get(id);
//       item?.quantity = qty;
//       cart.put(id, item!);
//     }
//   }

//   String isItem(String? index) {
//     for (final item in cart.values) {
//       if (item.id == index) {
//         return item.quantity.toString();
//       }
//     }
//     return "0";
//   }
// }

// class Indicator extends StatelessWidget {
//   final bool isActive;
//   const Indicator({required this.isActive});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(2),
//       child: Container(
//         height: isActive ? 12 : 8,
//         width: isActive ? 12 : 8,
//         decoration: BoxDecoration(
//           color: isActive ? WhiteColor : Colors.grey,
//           borderRadius: BorderRadius.circular(8),
//         ),
//       ),
//     );
//   }
// }
