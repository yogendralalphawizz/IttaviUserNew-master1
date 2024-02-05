// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, unnecessary_brace_in_string_interps, unnecessary_string_interpolations, unrelated_type_equality_checks, use_key_in_widget_constructors, must_be_immutable, library_private_types_in_public_api, unused_field, prefer_final_fields, avoid_print, prefer_interpolation_to_compose_strings, unused_local_variable, avoid_unnecessary_containers, sized_box_for_whitespace, prefer_is_empty

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:milkman/Api/config.dart';
import 'package:milkman/controller/cart_controller.dart';
import 'package:milkman/controller/catdetails_controller.dart';
import 'package:milkman/controller/fav_controller.dart';
import 'package:milkman/controller/productdetails_controller.dart';
import 'package:milkman/controller/stordata_controller.dart';
import 'package:milkman/helpar/routes_helper.dart';
import 'package:milkman/model/fontfamily_model.dart';

import 'package:milkman/screen/home_screen.dart';
import 'package:milkman/utils/Colors.dart';
import 'package:milkman/utils/cart_item.dart';
import 'package:readmore/readmore.dart';

class CategoryDetailsScreen extends StatefulWidget {
  const CategoryDetailsScreen({super.key});

  @override
  State<CategoryDetailsScreen> createState() => _CategoryDetailsScreenState();
}

class _CategoryDetailsScreenState extends State<CategoryDetailsScreen> {
  CatDetailsController catDetailsController = Get.find();
  StoreDataContoller storeDataContoller = Get.find();
  ProductDetailsController productDetailsController = Get.find();
  CartController cartController = Get.find();
  FavController favController = Get.find();
  int cnt = 0;
  ScrollController? _scrollController;
  bool lastStatus = true;
  double height = Get.height * 0.56;

  late Box<CartItem> cart;
  late final List<CartItem> items;
  double productPrice = 0;

  List<String> img = [
    "assets/star2.png",
    "assets/location-pin2.png",
    "assets/door-open.png",
    "assets/like.png",
  ];

  void _scrollListener() {
    if (_isShrink != lastStatus) {
      setState(() {
        lastStatus = _isShrink;
      });
    }
  }

  bool get _isShrink {
    return _scrollController != null &&
        _scrollController!.hasClients &&
        _scrollController!.offset > (height - kToolbarHeight);
  }

  @override
  void initState() {
    cart = Hive.box<CartItem>('cart');
    super.initState();
    _scrollController = ScrollController()..addListener(_scrollListener);
    setupHive();

    print("............." + scrollController.keepScrollOffset.toString());
  }

  Future<void> setupHive() async {
    await Hive.initFlutter();
    cart = Hive.box<CartItem>('cart');
    AsyncSnapshot.waiting();
    List<CartItem> tempList = [];
    catDetailsController.getCartLangth();
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_scrollListener);
    _scrollController?.dispose();
    super.dispose();
  }

  ScrollController scrollController = ScrollController();

  // final double _height = 300;
  // void _scrollToIndex(index) {
  //   scrollController.animateTo(_height * index,
  //       duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
  // }

  @override
  Widget build(BuildContext context) {
    //!----------
    Future.delayed(
      Duration(milliseconds: 100),
      () {
        setState(() {});
      },
    );

    return Scaffold(
      body:
      GetBuilder<StoreDataContoller>(builder: (context) {
        return
          storeDataContoller.isLoading
            ? RefreshIndicator(
                color: gradient.defoultColor,
                onRefresh: () {
                  return Future.delayed(
                    Duration(seconds: 2),
                    () {
                      storeDataContoller.getStoreData(
                          storeId: catDetailsController.strId);
                    },
                  );
                },
                child: CustomScrollView(
                  controller: scrollController,
                  slivers: [
                    SliverAppBar(
                      pinned: true,
                      leading: InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                          height: 40,
                          width: 40,
                          margin: EdgeInsets.all(5),
                          padding: EdgeInsets.all(7),
                          child: Icon(
                            Icons.arrow_back,
                            color: WhiteColor,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFF000000).withOpacity(0.4),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      actions: [
                        InkWell(
                          onTap: () {
                            Get.toNamed(
                              Routes.homeSearchScreen,
                              arguments: {
                                "statusWiseSearch": false,
                              },
                            );
                          },
                          child: Container(
                            height: 40,
                            width: 40,
                            margin: EdgeInsets.all(5),
                            alignment: Alignment.center,
                            child: Image.asset(
                              "assets/Search.png",
                              height: 20,
                              width: 20,
                              color: WhiteColor,
                            ),
                            decoration: BoxDecoration(
                              color: Color(0xFF000000).withOpacity(0.4),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            favController.addFavAndRemoveApi(
                              storeId: storeDataContoller
                                  .storeDataInfo?.storeInfo.storeId,
                            );
                          },
                          child: Container(
                            height: 40,
                            width: 40,
                            margin: EdgeInsets.all(5),
                            alignment: Alignment.center,
                            child: storeDataContoller.storeDataInfo?.storeInfo.isFavourite == 0
                                ? Image.asset(
                                    "assets/heartOutlinded.png",
                                    height: 20,
                                    width: 20,
                                    color: WhiteColor,
                                  )
                                : Image.asset(
                                    "assets/heart.png",
                                    height: 25,
                                    width: 25,
                                    color: gradient.defoultColor,
                                  ),
                            decoration: BoxDecoration(
                              color: Color(0xFF000000).withOpacity(0.4),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                      ],
                      expandedHeight: Get.height * 0.29,
                      bottom: PreferredSize(
                        child: Container(),
                        preferredSize: Size(0, 20),
                      ),
                      flexibleSpace: Stack(
                        children: [
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: Container(
                              height: Get.height * 0.34,
                              width: double.infinity,
                              child: Image.network(
                                "${Config.imageUrl}${storeDataContoller.storeDataInfo?.storeInfo.storeCover ?? ""}",
                                fit: BoxFit.cover,
                              ),
                              decoration: BoxDecoration(
                                color: transparent,
                              ),
                            ),
                          ),
                          Positioned(
                            child: Container(
                              height: 10,
                              decoration: BoxDecoration(
                                color: WhiteColor,
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(50),
                                ),
                              ),
                            ),
                            bottom: -1,
                            left: 0,
                            right: 0,
                          ),
                        ],
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            color: WhiteColor,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        storeDataContoller.storeDataInfo?.storeInfo.storeTitle ?? "",
                                        maxLines: 2,
                                        style: TextStyle(
                                          fontFamily: FontFamily.gilroyBold,
                                          fontSize: 20,
                                          color: BlackColor,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Container(
                                      height: 45,
                                      width: 45,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(30),
                                        child: FadeInImage.assetNetwork(
                                          placeholder:
                                              "assets/ezgif.com-crop.gif",
                                          image:
                                              "${Config.imageUrl}${storeDataContoller.storeDataInfo?.storeInfo.storeLogo ?? ""}",
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: WhiteColor,
                                        border: Border.all(
                                            color: Colors.grey.shade300),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: 70,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  img[0],
                                                  height: 18,
                                                  width: 18,
                                                ),
                                                SizedBox(
                                                  width: 3,
                                                ),
                                                Text(
                                                  storeDataContoller
                                                          .storeDataInfo
                                                          ?.storeInfo
                                                          .storeRate ??
                                                      "",
                                                  style: TextStyle(
                                                    fontFamily:
                                                        FontFamily.gilroyMedium,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 3,
                                            ),
                                            Text(
                                              "Rating".tr,
                                              style: TextStyle(
                                                fontFamily:
                                                    FontFamily.gilroyMedium,
                                                fontSize: 13,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 70,
                                      child: VerticalDivider(
                                        color: Colors.grey.shade200,
                                        endIndent: 15,
                                        width: 2,
                                        indent: 15,
                                        thickness: 1,
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        height: 70,
                                        width: Get.size.width,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  img[1],
                                                  height: 18,
                                                  width: 18,
                                                ),
                                                SizedBox(
                                                  width: 1,
                                                ),
                                                SizedBox(
                                                  width: Get.size.width * 0.15,
                                                  child: Text(
                                                    "${storeDataContoller.storeDataInfo?.storeInfo.restDistance.split(" ").first ?? ""}Km",
                                                    maxLines: 1,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontFamily: FontFamily
                                                          .gilroyMedium,
                                                      fontSize: 13,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 3,
                                            ),
                                            Text(
                                              "Distance".tr,
                                              style: TextStyle(
                                                fontFamily:
                                                    FontFamily.gilroyMedium,
                                                fontSize: 13,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 70,
                                      child: VerticalDivider(
                                        color: Colors.grey.shade200,
                                        endIndent: 15,
                                        width: 2,
                                        indent: 15,
                                        thickness: 1,
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        height: 70,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  img[2],
                                                  height: 18,
                                                  width: 18,
                                                ),
                                                SizedBox(
                                                  width: 3,
                                                ),
                                                Text(
                                                  "Time".tr,
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                    fontFamily:
                                                        FontFamily.gilroyMedium,
                                                    fontSize: 13,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 3,
                                            ),
                                            Text(
                                              "${DateFormat.jm().format(DateTime.parse("2023-03-20T${storeDataContoller.storeDataInfo?.storeInfo.storeOpentime}")).toString().split(":").first}AM - ${DateFormat.jm().format(DateTime.parse("2023-03-20T${storeDataContoller.storeDataInfo?.storeInfo.storeClosetime}")).toString().split(":").first}PM",
                                              style: TextStyle(
                                                fontFamily:
                                                    FontFamily.gilroyMedium,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 70,
                                      child: VerticalDivider(
                                        color: Colors.grey.shade200,
                                        endIndent: 15,
                                        width: 2,
                                        indent: 15,
                                        thickness: 1,
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        height: 70,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  img[3],
                                                  height: 18,
                                                  width: 18,
                                                ),
                                                SizedBox(
                                                  width: 3,
                                                ),
                                                Text(
                                                  storeDataContoller
                                                          .storeDataInfo
                                                          ?.storeInfo
                                                          .totalFav
                                                          .toString() ??
                                                      "",
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                    fontFamily:
                                                        FontFamily.gilroyMedium,
                                                    fontSize: 13,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 3,
                                            ),
                                            Text(
                                              "Likes".tr,
                                              style: TextStyle(
                                                fontFamily:
                                                    FontFamily.gilroyMedium,
                                                fontSize: 13,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                SizedBox(
                                  height: 50,
                                  width: Get.size.width,
                                  child: ListView.builder(
                                    itemCount: storeDataContoller
                                        .storeDataInfo?.catwiseproduct.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      return storeDataContoller
                                              .storeDataInfo!
                                              .catwiseproduct[index]
                                              .productdata
                                              .isNotEmpty
                                          ? InkWell(
                                              onTap: () {
                                                scrollController.animateTo(
                                                  index * 450,
                                                  curve: Curves.easeOut,
                                                  duration: const Duration(
                                                      milliseconds: 300),
                                                );
                                              },
                                              child: Container(
                                                height: 50,
                                                margin: EdgeInsets.all(5),
                                                alignment: Alignment.center,
                                                padding: EdgeInsets.only(left: 10, right: 15),
                                                child: Row(
                                                  children: [
                                                    storeDataContoller.storeDataInfo?.catwiseproduct[index].img != ""
                                                        ? Container(
                                                            height: 30,
                                                            width: 30,
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          30),
                                                              child: FadeInImage
                                                                  .assetNetwork(
                                                                placeholder:
                                                                    "assets/ezgif.com-crop.gif",
                                                                placeholderCacheHeight:
                                                                    30,
                                                                placeholderCacheWidth:
                                                                    30,
                                                                placeholderFit:
                                                                    BoxFit
                                                                        .cover,
                                                                image:
                                                                    "${Config.imageUrl}${storeDataContoller.storeDataInfo?.catwiseproduct[index].img}",
                                                                height: 30,
                                                                width: 30,
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                            ),
                                                          )
                                                        : SizedBox(),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          storeDataContoller
                                                                  .storeDataInfo
                                                                  ?.catwiseproduct[
                                                                      index]
                                                                  .catTitle ??
                                                              "",
                                                          style: TextStyle(
                                                            fontFamily:
                                                                FontFamily
                                                                    .gilroyBold,
                                                            fontSize: 13,
                                                          ),
                                                        ),
                                                        Text(
                                                          "${storeDataContoller.storeDataInfo?.catwiseproduct[index].productdata.length.toString()} items",
                                                          style: TextStyle(
                                                            fontFamily: FontFamily
                                                                .gilroyMedium,
                                                            color: greytext,
                                                            fontSize: 10,
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  color: WhiteColor,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color:
                                                          Colors.grey.shade300,
                                                      offset: const Offset(
                                                        0.3,
                                                        0.3,
                                                      ),
                                                      blurRadius: 0.3,
                                                      spreadRadius: 0.3,
                                                    ), //BoxShadow
                                                    BoxShadow(
                                                      color: Colors.white,
                                                      offset: const Offset(
                                                          0.0, 0.0),
                                                      blurRadius: 0.0,
                                                      spreadRadius: 0.0,
                                                    ), //BoxShadow
                                                  ],
                                                ),
                                              ),
                                            )
                                          : SizedBox();
                                    },
                                  ),
                                ),

                                SizedBox(
                                  height: 10,
                                ),

                                Container(
                                  color: WhiteColor,
                                  child: ListView.builder(
                                    itemCount: storeDataContoller
                                        .storeDataInfo?.catwiseproduct.length,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.zero,
                                    itemBuilder: (context, index1) {
                                      return storeDataContoller
                                              .storeDataInfo!
                                              .catwiseproduct[index1]
                                              .productdata
                                              .isNotEmpty
                                          ? Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  storeDataContoller
                                                          .storeDataInfo
                                                          ?.catwiseproduct[
                                                              index1]
                                                          .catTitle ??
                                                      "",
                                                  style: TextStyle(
                                                    color: BlackColor,
                                                    fontFamily:
                                                        FontFamily.gilroyBold,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                GridView.builder(
                                                  itemCount: storeDataContoller
                                                      .storeDataInfo
                                                      ?.catwiseproduct[index1]
                                                      .productdata
                                                      .length,
                                                  shrinkWrap: true,
                                                  padding: EdgeInsets.zero,
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  gridDelegate:
                                                      SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 2,
                                                    mainAxisSpacing: 8,
                                                    crossAxisSpacing: 8,
                                                    mainAxisExtent: 250,
                                                  ),
                                                  itemBuilder:
                                                      (context, index) {
                                                    double price = (double.parse(storeDataContoller
                                                                    .storeDataInfo
                                                                    ?.catwiseproduct[
                                                                        index1]
                                                                    .productdata[
                                                                        index]
                                                                    .productInfo[
                                                                        0]
                                                                    .normalPrice ??
                                                                "") *
                                                            double.parse(storeDataContoller
                                                                    .storeDataInfo
                                                                    ?.catwiseproduct[
                                                                        index1]
                                                                    .productdata[
                                                                        index]
                                                                    .productInfo[
                                                                        0]
                                                                    .productDiscount ??
                                                                "")) /
                                                        100;
                                                    return Stack(
                                                      clipBehavior: Clip.none,
                                                      children: [
                                                        Container(
                                                          margin:
                                                              EdgeInsets.all(1),
                                                          alignment:
                                                              Alignment.center,
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              SizedBox(
                                                                height: 5,
                                                              ),
                                                              InkWell(
                                                                onTap: () {
                                                                  productDetailsController
                                                                      .getProductDetailsApi(
                                                                    pId: storeDataContoller
                                                                        .storeDataInfo
                                                                        ?.catwiseproduct[
                                                                            index1]
                                                                        .productdata[
                                                                            index]
                                                                        .productId,
                                                                  );
                                                                  detailsSheet(storeDataContoller
                                                                          .storeDataInfo
                                                                          ?.storeInfo
                                                                          .storeShortDesc ??
                                                                      "");
                                                                },
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    InkWell(
                                                                      onTap:
                                                                          () {
                                                                        productDetailsController
                                                                            .getProductDetailsApi(
                                                                          pId: storeDataContoller
                                                                              .storeDataInfo
                                                                              ?.catwiseproduct[index1]
                                                                              .productdata[index]
                                                                              .productId,
                                                                        );
                                                                        detailsSheet(storeDataContoller.storeDataInfo?.storeInfo.storeShortDesc ??
                                                                            "");
                                                                      },
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            Container(
                                                                          height:
                                                                              125,
                                                                          width:
                                                                              Get.size.width * 0.35,
                                                                          child:
                                                                              ClipRRect(
                                                                            borderRadius:
                                                                                BorderRadius.circular(12),
                                                                            child:
                                                                                FadeInImage.assetNetwork(
                                                                              fadeInCurve: Curves.easeInCirc,
                                                                              placeholder: "assets/ezgif.com-crop.gif",
                                                                              placeholderCacheHeight: 125,
                                                                              placeholderCacheWidth: 125,
                                                                              height: 125,
                                                                              width: 125,
                                                                              placeholderFit: BoxFit.fill,
                                                                              image: "${Config.imageUrl}${storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productImg}",
                                                                              fit: BoxFit.cover,
                                                                            ),
                                                                          ),
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(12),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height: 5,
                                                                    ),
                                                                    Padding(
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              8),
                                                                      child:
                                                                          Text(
                                                                        storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productTitle ??
                                                                            "",
                                                                        maxLines:
                                                                            2,
                                                                        style:
                                                                            TextStyle(
                                                                          fontFamily:
                                                                              FontFamily.gilroyBold,
                                                                          fontSize:
                                                                              12,
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height: 5,
                                                                    ),
                                                                    Padding(
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              8),
                                                                      child:
                                                                          InkWell(
                                                                        onTap:
                                                                            () {
                                                                          productDetailsController
                                                                              .getProductDetailsApi(
                                                                            pId:
                                                                                storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productId,
                                                                          );
                                                                          detailsSheet(storeDataContoller.storeDataInfo?.storeInfo.storeShortDesc ??
                                                                              "");
                                                                        },
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            Flexible(
                                                                              child: Text(
                                                                                storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].title ?? "",
                                                                                maxLines: 1,
                                                                                overflow: TextOverflow.ellipsis,
                                                                                style: TextStyle(
                                                                                  fontFamily: FontFamily.gilroyMedium,
                                                                                  fontSize: 12,
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                  color: gradient.defoultColor,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              width: 4,
                                                                            ),
                                                                            1 < storeDataContoller.storeDataInfo!.catwiseproduct[index1].productdata[index].productInfo.length
                                                                                ? Image.asset(
                                                                                    "assets/angle-down.png",
                                                                                    height: 10,
                                                                                    width: 10,
                                                                                    color: gradient.defoultColor,
                                                                                  )
                                                                                : SizedBox()
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Container(
                                                                height: 70,
                                                                alignment: Alignment
                                                                    .bottomCenter,
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].productOutStock ==
                                                                            "0"
                                                                        ? Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.end,
                                                                            children: [
                                                                              storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].subscriptionRequired != "0"
                                                                                  ? isSubscibe(storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].attributeId.toString()) != "0"
                                                                                      ? InkWell(
                                                                                          onTap: () {
                                                                                            print("!!!!!!!!!!!!!!!!!!!!");
                                                                                            productDetailsController.getProductDetailsApi(
                                                                                              pId: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productId,
                                                                                            );
                                                                                            Get.toNamed(Routes.subScribeScreen, arguments: {
                                                                                              "img": storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productImg,
                                                                                              "name": storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productTitle,
                                                                                              "sprice": storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].subscribePrice,
                                                                                              "aprice": storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].normalPrice,
                                                                                              "per": storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].productDiscount,
                                                                                              "attributeId": storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].attributeId,
                                                                                              "productTitle": storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].title,
                                                                                              "isEmpty": "0",
                                                                                              "productId": storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productId,
                                                                                            });
                                                                                            // }
                                                                                          },
                                                                                          child: Container(
                                                                                            height: 25,
                                                                                            padding: EdgeInsets.symmetric(horizontal: 8),
                                                                                            alignment: Alignment.center,
                                                                                            child: Text(
                                                                                              "SUBSCRIBED".tr,
                                                                                              style: TextStyle(
                                                                                                color: gradient.defoultColor,
                                                                                                fontFamily: FontFamily.gilroyBold,
                                                                                                fontSize: 11,
                                                                                              ),
                                                                                            ),
                                                                                            decoration: BoxDecoration(
                                                                                              borderRadius: BorderRadius.circular(5),
                                                                                              border: Border.all(color: Colors.grey.shade300),
                                                                                            ),
                                                                                          ),
                                                                                        )
                                                                                      : InkWell(
                                                                                          onTap: () {
                                                                                            print("!!!!!!!!!!!!!!!!!!!!");
                                                                                            productDetailsController.getProductDetailsApi(
                                                                                              pId: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productId,
                                                                                            );
                                                                                            Get.toNamed(Routes.subScribeScreen, arguments: {
                                                                                              "img": storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productImg,
                                                                                              "name": storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productTitle,
                                                                                              "sprice": storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].subscribePrice,
                                                                                              "aprice": storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].normalPrice,
                                                                                              "per": storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].productDiscount,
                                                                                              "attributeId": storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].attributeId,
                                                                                              "productTitle": storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].title,
                                                                                              "isEmpty": "0",
                                                                                              "productId": storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productId,
                                                                                            });
                                                                                            // }
                                                                                          },
                                                                                          child: Container(
                                                                                            height: 25,
                                                                                            padding: EdgeInsets.symmetric(horizontal: 8),
                                                                                            alignment: Alignment.center,
                                                                                            child: Text(
                                                                                              "SUBSCRIBE".tr,
                                                                                              style: TextStyle(
                                                                                                color: gradient.defoultColor,
                                                                                                fontFamily: FontFamily.gilroyBold,
                                                                                                fontSize: 11,
                                                                                              ),
                                                                                            ),
                                                                                            decoration: BoxDecoration(
                                                                                              borderRadius: BorderRadius.circular(5),
                                                                                              border: Border.all(color: Colors.grey.shade300),
                                                                                            ),
                                                                                          ),
                                                                                        )
                                                                                  : SizedBox(),
                                                                              SizedBox(
                                                                                width: 5,
                                                                              ),
                                                                            ],
                                                                          )
                                                                        : SizedBox(),
                                                                    //! ------------ Add Product Widget -------------!//
                                                                    Row(
                                                                      children: [
                                                                        SizedBox(
                                                                          width:
                                                                              8,
                                                                        ),
                                                                        Column(
                                                                          children: [
                                                                            Text(
                                                                              "${currency}${double.parse(storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].normalPrice ?? "") - price}",
                                                                              maxLines: 1,
                                                                              style: TextStyle(
                                                                                fontFamily: FontFamily.gilroyBold,
                                                                                fontSize: 13,
                                                                              ),
                                                                            ),
                                                                            storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].productDiscount != "0"
                                                                                ? Text(
                                                                                    "${currency}${storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].normalPrice ?? ""}",
                                                                                    maxLines: 1,
                                                                                    style: TextStyle(
                                                                                      color: greyColor,
                                                                                      fontFamily: FontFamily.gilroyMedium,
                                                                                      decoration: TextDecoration.lineThrough,
                                                                                      fontSize: 11,
                                                                                    ),
                                                                                  )
                                                                                : SizedBox(),
                                                                          ],
                                                                        ),
                                                                        Spacer(),
                                                                        storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].productOutStock ==
                                                                                "0"
                                                                            ? isItem(storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].attributeId.toString()) != "0"
                                                                                ? isSubscibe(storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].attributeId.toString()) != "1"
                                                                                    ? Container(
                                                                                        height: 25,
                                                                                        width: 80,
                                                                                        margin: EdgeInsets.all(5),
                                                                                        alignment: Alignment.center,
                                                                                        child: Row(
                                                                                          children: [
                                                                                            SizedBox(
                                                                                              width: 5,
                                                                                            ),
                                                                                            InkWell(
                                                                                              onTap: () {
                                                                                                setState(() {
                                                                                                  onRemoveItem(
                                                                                                    index,
                                                                                                    isItem(storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].attributeId.toString()),
                                                                                                    id1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].attributeId ?? "",
                                                                                                    price1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].normalPrice ?? "",
                                                                                                  );
                                                                                                });
                                                                                              },
                                                                                              child: Container(
                                                                                                height: 30,
                                                                                                width: 15,
                                                                                                alignment: Alignment.center,
                                                                                                child: Icon(
                                                                                                  Icons.remove,
                                                                                                  color: gradient.defoultColor,
                                                                                                  size: 15,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                            Expanded(
                                                                                              child: Container(
                                                                                                alignment: Alignment.center,
                                                                                                child: Text(
                                                                                                  isItem(storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].attributeId).toString(),
                                                                                                  style: TextStyle(
                                                                                                    color: gradient.defoultColor,
                                                                                                    fontFamily: FontFamily.gilroyBold,
                                                                                                    fontSize: 12,
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                            InkWell(
                                                                                              onTap: () {
                                                                                                for (var element in cart.values) {
                                                                                                  if (element.storeID == storeDataContoller.storeDataInfo?.storeInfo.storeId) {
                                                                                                    if (element.cartCheck == "1") {
                                                                                                      Get.bottomSheet(
                                                                                                        Container(
                                                                                                          height: 200,
                                                                                                          width: Get.size.width,
                                                                                                          child: Column(
                                                                                                            children: [
                                                                                                              SizedBox(
                                                                                                                height: 15,
                                                                                                              ),
                                                                                                              Padding(
                                                                                                                padding: EdgeInsets.only(top: 5, left: 15, right: 15),
                                                                                                                child: Text(
                                                                                                                  "Would you like to empty your cart and add new items, or do you want to keep the current items in your cart?".tr,
                                                                                                                  style: TextStyle(
                                                                                                                    fontFamily: FontFamily.gilroyMedium,
                                                                                                                    fontSize: 16,
                                                                                                                    height: 1.2,
                                                                                                                    letterSpacing: 1,
                                                                                                                    color: BlackColor,
                                                                                                                  ),
                                                                                                                ),
                                                                                                              ),
                                                                                                              SizedBox(
                                                                                                                height: 10,
                                                                                                              ),
                                                                                                              Padding(
                                                                                                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                                                                                                child: Divider(
                                                                                                                  color: Colors.grey,
                                                                                                                ),
                                                                                                              ),
                                                                                                              Spacer(),
                                                                                                              Row(
                                                                                                                children: [
                                                                                                                  Expanded(
                                                                                                                    child: InkWell(
                                                                                                                      onTap: () {
                                                                                                                        Get.back();
                                                                                                                      },
                                                                                                                      child: Container(
                                                                                                                        height: 40,
                                                                                                                        width: Get.size.width,
                                                                                                                        alignment: Alignment.center,
                                                                                                                        margin: EdgeInsets.symmetric(horizontal: 10),
                                                                                                                        child: Text(
                                                                                                                          "No".tr,
                                                                                                                          style: TextStyle(
                                                                                                                            fontFamily: FontFamily.gilroyBold,
                                                                                                                            color: gradient.defoultColor,
                                                                                                                            fontSize: 16,
                                                                                                                          ),
                                                                                                                        ),
                                                                                                                        decoration: BoxDecoration(
                                                                                                                          color: gradient.defoultColor.withOpacity(0.1),
                                                                                                                          borderRadius: BorderRadius.circular(25),
                                                                                                                        ),
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                  Expanded(
                                                                                                                    child: InkWell(
                                                                                                                      onTap: () {
                                                                                                                        for (var element in cart.values) {
                                                                                                                          if (element.storeID == storeDataContoller.storeDataInfo?.storeInfo.storeId) {
                                                                                                                            if (element.cartCheck == "1") {
                                                                                                                              cart.delete(element.id);
                                                                                                                              catDetailsController.getCartLangth();
                                                                                                                              setState(() {});
                                                                                                                            }
                                                                                                                          }
                                                                                                                        }
                                                                                                                        onAddItem(
                                                                                                                          index,
                                                                                                                          isItem(storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].attributeId),
                                                                                                                          id1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].attributeId ?? "",
                                                                                                                          price1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].normalPrice ?? "",
                                                                                                                          strTitle1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productTitle,
                                                                                                                          isRequride1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].subscriptionRequired ?? "",
                                                                                                                          per1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].productDiscount.toString() ?? "",
                                                                                                                          storeId1: storeDataContoller.storeDataInfo?.storeInfo.storeId,
                                                                                                                          sPrice1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].subscribePrice ?? "",
                                                                                                                          img1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productImg,
                                                                                                                          productTitle1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].title,
                                                                                                                          productId: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productId,
                                                                                                                        );
                                                                                                                        Get.back();
                                                                                                                      },
                                                                                                                      child: Container(
                                                                                                                        height: 40,
                                                                                                                        width: Get.size.width,
                                                                                                                        alignment: Alignment.center,
                                                                                                                        margin: EdgeInsets.symmetric(horizontal: 10),
                                                                                                                        child: Text(
                                                                                                                          "Clear Cart".tr,
                                                                                                                          style: TextStyle(
                                                                                                                            fontFamily: FontFamily.gilroyBold,
                                                                                                                            color: WhiteColor,
                                                                                                                            fontSize: 16,
                                                                                                                          ),
                                                                                                                        ),
                                                                                                                        decoration: BoxDecoration(
                                                                                                                          gradient: gradient.btnGradient,
                                                                                                                          borderRadius: BorderRadius.circular(25),
                                                                                                                        ),
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                ],
                                                                                                              ),
                                                                                                              SizedBox(
                                                                                                                height: 20,
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
                                                                                                      break;
                                                                                                    } else {
                                                                                                      setState(() {
                                                                                                        onAddItem(
                                                                                                          index,
                                                                                                          isItem(storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].attributeId),
                                                                                                          id1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].attributeId ?? "",
                                                                                                          price1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].normalPrice ?? "",
                                                                                                          strTitle1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productTitle,
                                                                                                          isRequride1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].subscriptionRequired ?? "",
                                                                                                          per1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].productDiscount.toString() ?? "",
                                                                                                          storeId1: storeDataContoller.storeDataInfo?.storeInfo.storeId,
                                                                                                          sPrice1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].subscribePrice ?? "",
                                                                                                          img1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productImg,
                                                                                                          productTitle1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].title,
                                                                                                          productId: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productId,
                                                                                                        );
                                                                                                      });
                                                                                                      break;
                                                                                                    }
                                                                                                  }
                                                                                                }
                                                                                              },
                                                                                              child: Container(
                                                                                                height: 30,
                                                                                                width: 15,
                                                                                                alignment: Alignment.center,
                                                                                                child: Icon(
                                                                                                  Icons.add,
                                                                                                  color: gradient.defoultColor,
                                                                                                  size: 15,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                            SizedBox(
                                                                                              width: 5,
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                        decoration: BoxDecoration(
                                                                                          borderRadius: BorderRadius.circular(5),
                                                                                          border: Border.all(color: Colors.grey.shade300),
                                                                                        ),
                                                                                      )
                                                                                    : InkWell(
                                                                                        onTap: () {
                                                                                          print(".-.-.-.-.-.-.-.-.-.-.-.-.-.--.--->>" + cart.values.length.toString());
                                                                                          setState(() {
                                                                                            if (cart.values.isNotEmpty) {
                                                                                              for (var element in cart.values) {
                                                                                                if (element.storeID == storeDataContoller.storeDataInfo?.storeInfo.storeId) {
                                                                                                  if (element.cartCheck == "1") {
                                                                                                    Get.bottomSheet(
                                                                                                      Container(
                                                                                                        height: 200,
                                                                                                        width: Get.size.width,
                                                                                                        child: Column(
                                                                                                          children: [
                                                                                                            SizedBox(
                                                                                                              height: 15,
                                                                                                            ),
                                                                                                            Padding(
                                                                                                              padding: EdgeInsets.only(top: 5, left: 15, right: 15),
                                                                                                              child: Text(
                                                                                                                "Would you like to empty your cart and add new items, or do you want to keep the current items in your cart?".tr,
                                                                                                                style: TextStyle(
                                                                                                                  fontFamily: FontFamily.gilroyMedium,
                                                                                                                  fontSize: 16,
                                                                                                                  height: 1.2,
                                                                                                                  letterSpacing: 1,
                                                                                                                  color: BlackColor,
                                                                                                                ),
                                                                                                              ),
                                                                                                            ),
                                                                                                            SizedBox(
                                                                                                              height: 10,
                                                                                                            ),
                                                                                                            Padding(
                                                                                                              padding: const EdgeInsets.symmetric(horizontal: 15),
                                                                                                              child: Divider(
                                                                                                                color: Colors.grey,
                                                                                                              ),
                                                                                                            ),
                                                                                                            Spacer(),
                                                                                                            Row(
                                                                                                              children: [
                                                                                                                Expanded(
                                                                                                                  child: InkWell(
                                                                                                                    onTap: () {
                                                                                                                      Get.back();
                                                                                                                    },
                                                                                                                    child: Container(
                                                                                                                      height: 40,
                                                                                                                      width: Get.size.width,
                                                                                                                      alignment: Alignment.center,
                                                                                                                      margin: EdgeInsets.symmetric(horizontal: 10),
                                                                                                                      child: Text(
                                                                                                                        "No".tr,
                                                                                                                        style: TextStyle(
                                                                                                                          fontFamily: FontFamily.gilroyBold,
                                                                                                                          color: gradient.defoultColor,
                                                                                                                          fontSize: 16,
                                                                                                                        ),
                                                                                                                      ),
                                                                                                                      decoration: BoxDecoration(
                                                                                                                        color: gradient.defoultColor.withOpacity(0.1),
                                                                                                                        borderRadius: BorderRadius.circular(25),
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                ),
                                                                                                                Expanded(
                                                                                                                  child: InkWell(
                                                                                                                    onTap: () {
                                                                                                                      for (var element in cart.values) {
                                                                                                                        if (element.storeID == storeDataContoller.storeDataInfo?.storeInfo.storeId) {
                                                                                                                          if (element.cartCheck == "1") {
                                                                                                                            cart.delete(element.id);
                                                                                                                            catDetailsController.getCartLangth();
                                                                                                                            setState(() {});
                                                                                                                          }
                                                                                                                        }
                                                                                                                      }
                                                                                                                      onAddItem(
                                                                                                                        index,
                                                                                                                        isItem(storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].attributeId),
                                                                                                                        id1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].attributeId ?? "",
                                                                                                                        price1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].normalPrice ?? "",
                                                                                                                        strTitle1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productTitle,
                                                                                                                        isRequride1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].subscriptionRequired ?? "",
                                                                                                                        per1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].productDiscount.toString() ?? "",
                                                                                                                        storeId1: storeDataContoller.storeDataInfo?.storeInfo.storeId,
                                                                                                                        sPrice1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].subscribePrice ?? "",
                                                                                                                        img1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productImg,
                                                                                                                        productTitle1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].title,
                                                                                                                        productId: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productId,
                                                                                                                      );
                                                                                                                      Get.back();
                                                                                                                    },
                                                                                                                    child: Container(
                                                                                                                      height: 40,
                                                                                                                      width: Get.size.width,
                                                                                                                      alignment: Alignment.center,
                                                                                                                      margin: EdgeInsets.symmetric(horizontal: 10),
                                                                                                                      child: Text(
                                                                                                                        "Clear Cart".tr,
                                                                                                                        style: TextStyle(
                                                                                                                          fontFamily: FontFamily.gilroyBold,
                                                                                                                          color: WhiteColor,
                                                                                                                          fontSize: 16,
                                                                                                                        ),
                                                                                                                      ),
                                                                                                                      decoration: BoxDecoration(
                                                                                                                        gradient: gradient.btnGradient,
                                                                                                                        borderRadius: BorderRadius.circular(25),
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                ),
                                                                                                              ],
                                                                                                            ),
                                                                                                            SizedBox(
                                                                                                              height: 20,
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
                                                                                                    break;
                                                                                                  } else {
                                                                                                    onAddItem(
                                                                                                      index,
                                                                                                      isItem(storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].attributeId),
                                                                                                      id1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].attributeId ?? "",
                                                                                                      price1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].normalPrice ?? "",
                                                                                                      strTitle1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productTitle,
                                                                                                      isRequride1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].subscriptionRequired ?? "",
                                                                                                      per1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].productDiscount.toString() ?? "",
                                                                                                      storeId1: storeDataContoller.storeDataInfo?.storeInfo.storeId,
                                                                                                      sPrice1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].subscribePrice ?? "",
                                                                                                      img1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productImg,
                                                                                                      productTitle1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].title,
                                                                                                      productId: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productId,
                                                                                                    );
                                                                                                    break;
                                                                                                  }
                                                                                                }
                                                                                              }
                                                                                            } else {
                                                                                              onAddItem(
                                                                                                index,
                                                                                                isItem(storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].attributeId),
                                                                                                id1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].attributeId ?? "",
                                                                                                price1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].normalPrice ?? "",
                                                                                                strTitle1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productTitle,
                                                                                                isRequride1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].subscriptionRequired ?? "",
                                                                                                per1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].productDiscount.toString() ?? "",
                                                                                                storeId1: storeDataContoller.storeDataInfo?.storeInfo.storeId,
                                                                                                sPrice1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].subscribePrice ?? "",
                                                                                                img1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productImg,
                                                                                                productTitle1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].title,
                                                                                                productId: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productId,
                                                                                              );
                                                                                            }
                                                                                          });
                                                                                        },
                                                                                        child: Container(
                                                                                          height: 25,
                                                                                          width: 80,
                                                                                          margin: EdgeInsets.all(5),
                                                                                          alignment: Alignment.center,
                                                                                          child: Text(
                                                                                            "ADD".tr,
                                                                                            style: TextStyle(
                                                                                              color: gradient.defoultColor,
                                                                                              fontFamily: FontFamily.gilroyBold,
                                                                                              fontSize: 12,
                                                                                            ),
                                                                                          ),
                                                                                          decoration: BoxDecoration(
                                                                                            borderRadius: BorderRadius.circular(5),
                                                                                            border: Border.all(color: Colors.grey.shade300),
                                                                                          ),
                                                                                        ),
                                                                                      )
                                                                                : InkWell(
                                                                                    onTap: () {
                                                                                      print(".-.-.-.-.-.-.-.-.-.-.-.-.-.--.--->>" + cart.values.length.toString());
                                                                                      setState(() {
                                                                                        if (cart.values.isNotEmpty) {
                                                                                          print("-=-=-=-=-=-=-=-=-=---1");
                                                                                          for (var element in cart.values) {
                                                                                            print("-=-=-=-=-=-=-=-=-=---2");
                                                                                            print("**************" + element.storeID.toString());
                                                                                            print("**************" + storeDataContoller.storeDataInfo!.storeInfo.storeId.toString());
                                                                                            if (element.storeID == storeDataContoller.storeDataInfo?.storeInfo.storeId) {
                                                                                              if (element.cartCheck == "1") {
                                                                                                Get.bottomSheet(
                                                                                                  Container(
                                                                                                    height: 200,
                                                                                                    width: Get.size.width,
                                                                                                    child: Column(
                                                                                                      children: [
                                                                                                        SizedBox(
                                                                                                          height: 15,
                                                                                                        ),
                                                                                                        Padding(
                                                                                                          padding: EdgeInsets.only(top: 5, left: 15, right: 15),
                                                                                                          child: Text(
                                                                                                            "Would you like to empty your cart and add new items, or do you want to keep the current items in your cart?".tr,
                                                                                                            style: TextStyle(
                                                                                                              fontFamily: FontFamily.gilroyMedium,
                                                                                                              fontSize: 16,
                                                                                                              height: 1.2,
                                                                                                              letterSpacing: 1,
                                                                                                              color: BlackColor,
                                                                                                            ),
                                                                                                          ),
                                                                                                        ),
                                                                                                        SizedBox(
                                                                                                          height: 10,
                                                                                                        ),
                                                                                                        Padding(
                                                                                                          padding: const EdgeInsets.symmetric(horizontal: 15),
                                                                                                          child: Divider(
                                                                                                            color: Colors.grey,
                                                                                                          ),
                                                                                                        ),
                                                                                                        Spacer(),
                                                                                                        Row(
                                                                                                          children: [
                                                                                                            Expanded(
                                                                                                              child: InkWell(
                                                                                                                onTap: () {
                                                                                                                  Get.back();
                                                                                                                },
                                                                                                                child: Container(
                                                                                                                  height: 40,
                                                                                                                  width: Get.size.width,
                                                                                                                  alignment: Alignment.center,
                                                                                                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                                                                                                  child: Text(
                                                                                                                    "No".tr,
                                                                                                                    style: TextStyle(
                                                                                                                      fontFamily: FontFamily.gilroyBold,
                                                                                                                      color: gradient.defoultColor,
                                                                                                                      fontSize: 16,
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                  decoration: BoxDecoration(
                                                                                                                    color: gradient.defoultColor.withOpacity(0.1),
                                                                                                                    borderRadius: BorderRadius.circular(25),
                                                                                                                  ),
                                                                                                                ),
                                                                                                              ),
                                                                                                            ),
                                                                                                            Expanded(
                                                                                                              child: InkWell(
                                                                                                                onTap: () {
                                                                                                                  for (var element in cart.values) {
                                                                                                                    if (element.storeID == storeDataContoller.storeDataInfo?.storeInfo.storeId) {
                                                                                                                      if (element.cartCheck == "1") {
                                                                                                                        cart.delete(element.id);
                                                                                                                        catDetailsController.getCartLangth();
                                                                                                                        setState(() {});
                                                                                                                      }
                                                                                                                    }
                                                                                                                  }
                                                                                                                  onAddItem(
                                                                                                                    index,
                                                                                                                    isItem(storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].attributeId),
                                                                                                                    id1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].attributeId ?? "",
                                                                                                                    price1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].normalPrice ?? "",
                                                                                                                    strTitle1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productTitle,
                                                                                                                    isRequride1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].subscriptionRequired ?? "",
                                                                                                                    per1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].productDiscount.toString() ?? "",
                                                                                                                    storeId1: storeDataContoller.storeDataInfo?.storeInfo.storeId,
                                                                                                                    sPrice1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].subscribePrice ?? "",
                                                                                                                    img1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productImg,
                                                                                                                    productTitle1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].title,
                                                                                                                    productId: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productId,
                                                                                                                  );
                                                                                                                  Get.back();
                                                                                                                },
                                                                                                                child: Container(
                                                                                                                  height: 40,
                                                                                                                  width: Get.size.width,
                                                                                                                  alignment: Alignment.center,
                                                                                                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                                                                                                  child: Text(
                                                                                                                    "Clear Cart".tr,
                                                                                                                    style: TextStyle(
                                                                                                                      fontFamily: FontFamily.gilroyBold,
                                                                                                                      color: WhiteColor,
                                                                                                                      fontSize: 16,
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                  decoration: BoxDecoration(
                                                                                                                    gradient: gradient.btnGradient,
                                                                                                                    borderRadius: BorderRadius.circular(25),
                                                                                                                  ),
                                                                                                                ),
                                                                                                              ),
                                                                                                            ),
                                                                                                          ],
                                                                                                        ),
                                                                                                        SizedBox(
                                                                                                          height: 20,
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
                                                                                                break;
                                                                                              } else {
                                                                                                print("-=-=-=-=-=-=-=-=-=---3");
                                                                                                onAddItem(
                                                                                                  index,
                                                                                                  isItem(storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].attributeId),
                                                                                                  id1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].attributeId ?? "",
                                                                                                  price1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].normalPrice ?? "",
                                                                                                  strTitle1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productTitle,
                                                                                                  isRequride1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].subscriptionRequired ?? "",
                                                                                                  per1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].productDiscount.toString() ?? "",
                                                                                                  storeId1: storeDataContoller.storeDataInfo?.storeInfo.storeId,
                                                                                                  sPrice1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].subscribePrice ?? "",
                                                                                                  img1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productImg,
                                                                                                  productTitle1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].title,
                                                                                                  productId: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productId,
                                                                                                );
                                                                                                break;
                                                                                              }
                                                                                            } else {
                                                                                              onAddItem(
                                                                                                index,
                                                                                                isItem(storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].attributeId),
                                                                                                id1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].attributeId ?? "",
                                                                                                price1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].normalPrice ?? "",
                                                                                                strTitle1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productTitle,
                                                                                                isRequride1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].subscriptionRequired ?? "",
                                                                                                per1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].productDiscount.toString() ?? "",
                                                                                                storeId1: storeDataContoller.storeDataInfo?.storeInfo.storeId,
                                                                                                sPrice1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].subscribePrice ?? "",
                                                                                                img1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productImg,
                                                                                                productTitle1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].title,
                                                                                                productId: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productId,
                                                                                              );
                                                                                              break;
                                                                                            }
                                                                                          }
                                                                                        } else {
                                                                                          print("-=-=-=-=-=-=-=-=-=---4");
                                                                                          onAddItem(
                                                                                            index,
                                                                                            isItem(storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].attributeId),
                                                                                            id1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].attributeId ?? "",
                                                                                            price1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].normalPrice ?? "",
                                                                                            strTitle1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productTitle,
                                                                                            isRequride1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].subscriptionRequired ?? "",
                                                                                            per1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].productDiscount.toString() ?? "",
                                                                                            storeId1: storeDataContoller.storeDataInfo?.storeInfo.storeId,
                                                                                            sPrice1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].subscribePrice ?? "",
                                                                                            img1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productImg,
                                                                                            productTitle1: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].title,
                                                                                            productId: storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productId,
                                                                                          );
                                                                                        }
                                                                                      });
                                                                                    },
                                                                                    child: Container(
                                                                                      height: 25,
                                                                                      width: 80,
                                                                                      margin: EdgeInsets.all(5),
                                                                                      alignment: Alignment.center,
                                                                                      child: Text(
                                                                                        "ADD".tr,
                                                                                        style: TextStyle(
                                                                                          color: gradient.defoultColor,
                                                                                          fontFamily: FontFamily.gilroyBold,
                                                                                          fontSize: 12,
                                                                                        ),
                                                                                      ),
                                                                                      decoration: BoxDecoration(
                                                                                        borderRadius: BorderRadius.circular(5),
                                                                                        border: Border.all(color: Colors.grey.shade300),
                                                                                      ),
                                                                                    ),
                                                                                  )
                                                                            : Container(
                                                                                height: 22,
                                                                                width: 90,
                                                                                margin: EdgeInsets.all(5),
                                                                                alignment: Alignment.center,
                                                                                child: Text(
                                                                                  "Out of stock",
                                                                                  style: TextStyle(
                                                                                    fontFamily: FontFamily.gilroyMedium,
                                                                                    fontSize: 12,
                                                                                    color: RedColor,
                                                                                  ),
                                                                                ),
                                                                                decoration: BoxDecoration(
                                                                                  border: Border.all(color: RedColor),
                                                                                  borderRadius: BorderRadius.circular(5),
                                                                                ),
                                                                              ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: WhiteColor,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Colors
                                                                    .grey
                                                                    .shade300,
                                                                offset:
                                                                    const Offset(
                                                                  0.3,
                                                                  0.3,
                                                                ),
                                                                blurRadius: 0.3,
                                                                spreadRadius:
                                                                    0.3,
                                                              ), //BoxShadow
                                                              BoxShadow(
                                                                color: Colors
                                                                    .white,
                                                                offset:
                                                                    const Offset(
                                                                        0.0,
                                                                        0.0),
                                                                blurRadius: 0.0,
                                                                spreadRadius:
                                                                    0.0,
                                                              ), //BoxShadow
                                                            ],
                                                          ),
                                                        ),
                                                        storeDataContoller
                                                                    .storeDataInfo
                                                                    ?.catwiseproduct[
                                                                        index1]
                                                                    .productdata[
                                                                        index]
                                                                    .productInfo[
                                                                        0]
                                                                    .productDiscount !=
                                                                "0"
                                                            ? Positioned(
                                                                top: -5,
                                                                left: 4,
                                                                child:
                                                                    Container(
                                                                  height: 40,
                                                                  width: 40,
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child: Text(
                                                                    "${storeDataContoller.storeDataInfo?.catwiseproduct[index1].productdata[index].productInfo[0].productDiscount}%\nOFF",
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          FontFamily
                                                                              .gilroyMedium,
                                                                      color:
                                                                          WhiteColor,
                                                                      fontSize:
                                                                          11,
                                                                      height:
                                                                          1.1,
                                                                    ),
                                                                  ),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    image:
                                                                        DecorationImage(
                                                                      image:
                                                                          AssetImage(
                                                                        "assets/lable1.png",
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                            : SizedBox(),
                                                      ],
                                                    );
                                                  },
                                                )
                                              ],
                                            )
                                          : SizedBox();
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : Center(
                child: CircularProgressIndicator(
                  color: gradient.defoultColor,
                ),
              );
      }),
    );
  }

  Future<void> onAddItem(
    int index,
    String qtys, {
    String? id1,
    price1,
    strTitle1,
    per1,
    isRequride1,
    storeId1,
    sPrice1,
    img1,
    productTitle1,
    productId,
  }) async {
    String? id = id1;
    String? price = price1.toString();
    int? qty = int.parse(qtys);
    qty = qty + 1;
    cart = Hive.box<CartItem>('cart');
    final newItem = CartItem();

    String finalPrice =
        "${(double.parse(price1.toString()) * double.parse(per1)) / 100}";

    print("@@@@@@@@@<FinalPrice>@@@@@@@@@" + finalPrice);

    newItem.id = id; //attribute ID
    newItem.price = double.parse(price1.toString()) -
        double.parse(finalPrice); // normal Price
    newItem.quantity = qty; // product Qty
    newItem.productPrice = double.parse(price1.toString()) -
        double.parse(finalPrice); // product Normal Price
    newItem.strTitle = strTitle1; // Store Title
    newItem.per = per1; // Product Descount
    newItem.isRequride = isRequride1; // SubScripTion Requride
    newItem.storeID = storeId1; // Store ID
    newItem.sPrice = double.parse(sPrice1); // SubScription Price
    newItem.img = img1; // Product Image
    newItem.productTitle = productTitle1; // Product Title
    newItem.selectDelivery = ""; // Select Delivery
    newItem.startDate = ""; // Start Date
    newItem.startTime = ""; // Start Time
    newItem.daysList = []; // daysList
    newItem.cartCheck = "0"; // CartCheck
    newItem.productID = productId;

    print("<<<<<<<<ID>>>>>>>>" + id1.toString());
    print("<<<<<<<<Price1>>>>>>>>" + price1.toString());
    print("<<<<<<<<Qty>>>>>>>>" + qty.toString());
    print("<<<<<<<<StrTitle1>>>>>>>>" + strTitle1.toString());
    print("<<<<<<<<Per1>>>>>>>>" + per1.toString());
    print("<<<<<<<<IsRequride1>>>>>>>>" + isRequride1.toString());
    print("<<<<<<<<StoreId1>>>>>>>>" + storeId1.toString());

    if (qtys == "0") {
      cart.put(id, newItem);
      catDetailsController.getCartLangth();
    } else {
      // if (int.parse(isItem(id)) < int.parse(qLimit1)) {
      var item = cart.get(id);
      item?.quantity = qty;
      cart.put(id, item!);
      // } else {
      //   showToastMessage("Exceeded the maximum quantity limit per order!".tr);
      // }
    }
  }

  void onRemoveItem(int index, String qtys, {String? id1, price1}) {
    String? id = id1;
    String? price = price1;
    int? qty = int.parse(qtys);
    qty = qty - 1;
    cart = Hive.box<CartItem>('cart');
    if (qtys == "1") {
      cart.delete(id);
      catDetailsController.getCartLangth();
    } else {
      var item = cart.get(id);
      item?.quantity = qty;
      cart.put(id, item!);
    }
  }

  String isItem(String? index) {
    for (final item in cart.values) {
      if (item.id == index) {
        return item.quantity.toString();
      }
    }
    return "0";
  }

  String isSubscibe(String? index) {
    for (final item in cart.values) {
      if (item.id == index) {
        return item.cartCheck.toString();
      }
    }
    return "0";
  }

  Widget catDRow({String? img, text}) {
    return Padding(
      padding: EdgeInsets.only(top: 5, right: 5),
      child: Row(
        children: [
          SizedBox(
            width: 10,
          ),
          Image.asset(
            img ?? "",
            height: 13,
            width: 13,
            color: greytext,
          ),
          SizedBox(
            width: 5,
          ),
          Expanded(
            child: Text(
              text,
              maxLines: 2,
              style: TextStyle(
                color: greytext,
                fontFamily: FontFamily.gilroyMedium,
                fontSize: 13,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> onAddItem1(
    int index,
    String qtys, {
    String? id1,
    price1,
    strTitle1,
    per1,
    isRequride1,
    storeId1,
    sPrice1,
    img1,
    productTitle1,
    productId,
  }) async {
    String? id = productDetailsController.productInfo?.productData.productInfo[index].attributeId;

    String finalPrice = "${(double.parse(price1) * double.parse(per1)) / 100}";

    String? price = price1.toString();

    int? qty = int.parse(qtys);
    qty = qty + 1;
    cart = Hive.box<CartItem>('cart');
    final newItem = CartItem();
    newItem.id = id; //attribute ID
    newItem.price = double.parse(price1.toString()) -
        double.parse(finalPrice); // normal Price
    newItem.quantity = qty; // product Qty
    newItem.productPrice = double.parse(price1.toString()) -
        double.parse(finalPrice); // product Normal Price
    newItem.strTitle = strTitle1; // Store Title
    newItem.per = per1; // Product Descount
    newItem.isRequride = isRequride1; // SubScripTion Requride
    newItem.storeID = storeId1; // Store ID
    newItem.sPrice = double.parse(sPrice1); // SubScription Price
    newItem.img = img1; // Product Image
    newItem.productTitle = productTitle1; // Product Title
    newItem.selectDelivery = ""; // Select Delivery
    newItem.startDate = ""; // Start Date
    newItem.startTime = ""; // Start Time
    newItem.daysList = []; // daysList
    newItem.cartCheck = "0"; // CartCheck
    newItem.productID = productId; // Product ID
    if (qtys == "0") {
      cart.put(id, newItem);
      catDetailsController.getCartLangth();
      setState(() {});
    } else {
      var item = cart.get(id);
      item?.quantity = qty;
      cart.put(id, item!);
    }
  }

  void onRemoveItem1(
    int index,
    String qtys, {
    String? pr1,
  }) {
    String? id = productDetailsController
        .productInfo?.productData.productInfo[index].attributeId
        .toString();
    String? price = productDetailsController
        .productInfo?.productData.productInfo[index].normalPrice
        .toString();
    int? qty = int.parse(qtys);
    qty = qty - 1;
    cart = Hive.box<CartItem>('cart');
    if (qtys == "1") {
      cart.delete(id);

      catDetailsController.getCartLangth();
      setState(() {});
    } else {
      var item = cart.get(id);
      item?.quantity = qty;
      cart.put(id, item!);

      setState(() {});
    }
  }

  String isItem1(String? index) {
    for (final item in cart.values) {
      if (item.id == index) {
        return item.quantity.toString();
      }
    }
    return "0";
  }

  String isSubscibe1(String? index) {
    for (final item in cart.values) {
      if (item.id == index) {
        return item.cartCheck.toString();
      }
    }
    return "0";
  }

  List itemList = [];

  getSubScriptionProductTypeList() {
    print('.......+++++++++.........' +
        productDetailsController.productInfo!.productData.productInfo.length
            .toString());
    itemList = [];
    for (var element
        in productDetailsController.productInfo!.productData.productInfo) {
      if (element.subscriptionRequired != "0" &&
          element.productOutStock == "0") {
        itemList.add(element.title);
      }
    }
  }

  detailsSheet(String desc) {
    int selectIndex = 0;
    return showModalBottomSheet(
        backgroundColor: WhiteColor,
        isScrollControlled: true,
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15))),
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: Get.height * 0.8,
              // padding: const EdgeInsets.symmetric(vertical: 12),
              child: Scaffold(
                backgroundColor: WhiteColor,
                floatingActionButton: Container(
                  transform: Matrix4.translationValues(
                      0.0, -80, 0.0), // translate up by 30
                  child: FloatingActionButton(
                    backgroundColor: WhiteColor.withOpacity(0.5),
                    onPressed: () {
                      Get.back();
                    },
                    child: Icon(Icons.close),
                  ),
                ),
                bottomNavigationBar:
                    GetBuilder<ProductDetailsController>(builder: (context) {
                  if (productDetailsController.isLoading == true) {
                    getSubScriptionProductTypeList();
                  }
                  return productDetailsController.isLoading
                      ? Container(
                          height: 50,
                          width: Get.size.width,
                          color: WhiteColor,
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "${catDetailsController.count.length.toString()} Piece",
                                      style: TextStyle(
                                        fontFamily: FontFamily.gilroyBold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    // SizedBox(
                                    //   height: 8,
                                    // ),
                                    // Text(
                                    //   // "${currency}${double.parse(productDetailsController.productInfo?.productData.productInfo[0].normalPrice.toString() ?? "") * int.parse(isItem1(productDetailsController.productInfo?.productData.id).toString())}",
                                    //   "${tempTotal}",
                                    //   style: TextStyle(
                                    //     fontFamily: FontFamily.gilroyBold,
                                    //     fontSize: 14,
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Get.back();
                                  catDetailsController.changeIndex(2);
                                },
                                child: Container(
                                  height: 40,
                                  width: 110,
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: Text(
                                    "View Cart".tr,
                                    style: TextStyle(
                                      fontFamily: FontFamily.gilroyMedium,
                                      fontSize: 14,
                                      color: WhiteColor,
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: gradient.btnGradient,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      : SizedBox();
                }),
                body: GetBuilder<ProductDetailsController>(builder: (context) {
                  return productDetailsController.isLoading
                      ? SizedBox(
                          height: Get.size.height,
                          width: Get.size.width,
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      color: WhiteColor,
                                      height: Get.size.height * 0.3,
                                      child: PageView.builder(
                                        itemCount: productDetailsController
                                            .productInfo
                                            ?.productData
                                            .img
                                            .length,
                                        physics: BouncingScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          return Stack(
                                            children: [
                                              Container(
                                                alignment: Alignment.center,
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 15,
                                                    vertical: 8),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  child:
                                                      FadeInImage.assetNetwork(
                                                    placeholder:
                                                        "assets/ezgif.com-crop.gif",
                                                    placeholderFit: BoxFit.fill,
                                                    image:
                                                        "${Config.imageUrl}${productDetailsController.productInfo?.productData.img[index] ?? ""}",
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                              ),
                                              // Positioned(
                                              //   bottom: 15,
                                              //   left: 15,
                                              //   right: 15,
                                              //   child: Container(
                                              //     height: 50,
                                              //     width: Get.size.width,
                                              //     decoration: BoxDecoration(
                                              //       image: DecorationImage(
                                              //         image: AssetImage(
                                              //             "assets/Rectangle.png"),
                                              //         fit: BoxFit.fill,
                                              //       ),
                                              //       borderRadius: BorderRadius.only(
                                              //         bottomLeft:
                                              //             Radius.circular(15),
                                              //         bottomRight:
                                              //             Radius.circular(15),
                                              //       ),
                                              //     ),
                                              //   ),
                                              // ),
                                            ],
                                          );
                                        },
                                        onPageChanged: (value) {
                                          setState(() {
                                            selectIndex = value;
                                          });
                                        },
                                      ),
                                    ),
                                    Positioned(
                                      bottom: -8,
                                      child: SizedBox(
                                        height: 25,
                                        width: Get.size.width,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            ...List.generate(
                                                productDetailsController
                                                    .productInfo!
                                                    .productData
                                                    .img
                                                    .length, (index) {
                                              return Indicator(
                                                isActive: selectIndex == index
                                                    ? true
                                                    : false,
                                              );
                                            }),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Divider(
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 15),
                                  child: Text(
                                    productDetailsController
                                            .productInfo?.productData.title ??
                                        "",
                                    maxLines: 2,
                                    style: TextStyle(
                                      fontFamily: FontFamily.gilroyBold,
                                      fontSize: 18,
                                      color: BlackColor,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Row(
                                    children: [
                                      Spacer(),
                                      itemList.isNotEmpty
                                          ? InkWell(
                                              onTap: () {
                                                for (var i = 0;
                                                    i <
                                                        productDetailsController
                                                            .productInfo!
                                                            .productData
                                                            .productInfo
                                                            .length;
                                                    i++) {
                                                  if (productDetailsController
                                                              .productInfo!
                                                              .productData
                                                              .productInfo[i]
                                                              .subscriptionRequired ==
                                                          "1" &&
                                                      productDetailsController
                                                              .productInfo!
                                                              .productData
                                                              .productInfo[i]
                                                              .productOutStock ==
                                                          "0") {
                                                    productDetailsController
                                                        .getProductDetailsApi(
                                                      pId:
                                                          productDetailsController
                                                                  .productInfo
                                                                  ?.productData
                                                                  .id ??
                                                              "",
                                                    );
                                                    Get.toNamed(
                                                        Routes.subScribeScreen,
                                                        arguments: {
                                                          "img":
                                                              productDetailsController
                                                                  .productInfo!
                                                                  .productData
                                                                  .img[0],
                                                          "name":
                                                              productDetailsController
                                                                  .productInfo!
                                                                  .productData
                                                                  .title,
                                                          "sprice":
                                                              productDetailsController
                                                                  .productInfo!
                                                                  .productData
                                                                  .productInfo[
                                                                      i]
                                                                  .subscribePrice,
                                                          "aprice":
                                                              productDetailsController
                                                                  .productInfo!
                                                                  .productData
                                                                  .productInfo[
                                                                      i]
                                                                  .normalPrice,
                                                          "per": productDetailsController
                                                              .productInfo!
                                                              .productData
                                                              .productInfo[i]
                                                              .productDiscount,
                                                          "attributeId":
                                                              productDetailsController
                                                                  .productInfo!
                                                                  .productData
                                                                  .productInfo[
                                                                      i]
                                                                  .attributeId,
                                                          "productTitle":
                                                              productDetailsController
                                                                  .productInfo!
                                                                  .productData
                                                                  .productInfo[
                                                                      i]
                                                                  .title,
                                                          "isEmpty": "0",
                                                          "productId":
                                                              productDetailsController
                                                                  .productInfo!
                                                                  .productData
                                                                  .id,
                                                        });
                                                    break;
                                                  }
                                                }
                                              },
                                              child: Container(
                                                height: 25,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 8),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  "SUBSCRIBE".tr,
                                                  style: TextStyle(
                                                    color:
                                                        gradient.defoultColor,
                                                    fontFamily:
                                                        FontFamily.gilroyBold,
                                                    fontSize: 11,
                                                  ),
                                                ),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  border: Border.all(
                                                      color:
                                                          Colors.grey.shade300),
                                                ),
                                              ),
                                            )
                                          : SizedBox(),
                                      SizedBox(
                                        width: 10,
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Divider(
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Text(
                                    "Select unit".tr,
                                    style: TextStyle(
                                      fontFamily: FontFamily.gilroyBold,
                                      fontSize: 18,
                                      color: BlackColor,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 120,
                                  child: ListView.builder(
                                    itemCount: productDetailsController.productInfo?.productData.productInfo.length,
                                    scrollDirection: Axis.horizontal,
                                    padding: EdgeInsets.zero,
                                    itemBuilder: (context, index) {
                                      String currentPrice = "${(double.parse(productDetailsController.productInfo?.productData.productInfo[index].normalPrice ?? "") * double.parse(productDetailsController.productInfo?.productData.productInfo[index].productDiscount ?? "")) / 100}";
                                      return Stack(
                                        children: [
                                          Container(
                                            height: 120,
                                            width: 120,
                                            child: Column(
                                              children: [
                                                Container(
                                                  height: 70,
                                                  width: 120,
                                                  alignment: Alignment.center,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      SizedBox(
                                                        width: 120,
                                                        child: Text(
                                                          productDetailsController
                                                                  .productInfo
                                                                  ?.productData
                                                                  .productInfo[
                                                                      index]
                                                                  .title ??
                                                              "",
                                                          maxLines: 1,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            fontFamily:
                                                                FontFamily
                                                                    .gilroyBold,
                                                            fontSize: 15,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 7,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            "${currency}${double.parse(productDetailsController.productInfo?.productData.productInfo[index].normalPrice.toString() ?? "") - double.parse(currentPrice)}",
                                                            style: TextStyle(
                                                              color: BlackColor,
                                                              fontFamily:
                                                                  FontFamily
                                                                      .gilroyBold,
                                                              fontSize: 15,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 4,
                                                          ),
                                                          productDetailsController
                                                                      .productInfo
                                                                      ?.productData
                                                                      .productInfo[
                                                                          index]
                                                                      .productDiscount !=
                                                                  "0"
                                                              ? Text(
                                                                  "${currency}${productDetailsController.productInfo?.productData.productInfo[index].normalPrice}",
                                                                  style: TextStyle(
                                                                      color:
                                                                          greytext,
                                                                      fontFamily:
                                                                          FontFamily
                                                                              .gilroyBold,
                                                                      fontSize:
                                                                          13,
                                                                      decoration:
                                                                          TextDecoration
                                                                              .lineThrough),
                                                                )
                                                              : SizedBox(),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: WhiteColor,
                                                    border: Border.all(
                                                      color:
                                                          Colors.grey.shade300,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            margin: EdgeInsets.all(8),
                                          ),
                                          Positioned(
                                            bottom: 18,
                                            left: 20,
                                            right: 20,
                                            child: productDetailsController
                                                        .productInfo
                                                        ?.productData
                                                        .productInfo[index]
                                                        .productOutStock ==
                                                    "0"
                                                ? isItem1(productDetailsController
                                                            .productInfo
                                                            ?.productData
                                                            .productInfo[index]
                                                            .attributeId
                                                            .toString()) !=
                                                        "0"
                                                    ? isSubscibe(productDetailsController
                                                                .productInfo
                                                                ?.productData
                                                                .productInfo[
                                                                    index]
                                                                .attributeId
                                                                .toString()) !=
                                                            "1"
                                                        ? Container(
                                                            height: 28,
                                                            width: 70,
                                                            margin:
                                                                EdgeInsets.all(
                                                                    5),
                                                            alignment: Alignment
                                                                .center,
                                                            child: Row(
                                                              children: [
                                                                SizedBox(
                                                                  width: 7,
                                                                ),
                                                                InkWell(
                                                                  onTap: () {
                                                                    setState(
                                                                        () {
                                                                      onRemoveItem1(
                                                                        index,
                                                                        isItem1(productDetailsController
                                                                            .productInfo
                                                                            ?.productData
                                                                            .productInfo[index]
                                                                            .attributeId
                                                                            .toString()),
                                                                        pr1:
                                                                            "${(double.parse(productDetailsController.productInfo?.productData.productInfo[index].normalPrice ?? "") * double.parse(productDetailsController.productInfo?.productData.productInfo[index].productDiscount ?? "")) / 100}",
                                                                      );
                                                                    });
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    height: 30,
                                                                    width: 15,
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    child: Icon(
                                                                      Icons
                                                                          .remove,
                                                                      color: gradient
                                                                          .defoultColor,
                                                                      size: 15,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child:
                                                                      Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    child: Text(
                                                                      isItem1(productDetailsController
                                                                              .productInfo
                                                                              ?.productData
                                                                              .productInfo[index]
                                                                              .attributeId)
                                                                          .toString(),
                                                                      style:
                                                                          TextStyle(
                                                                        color: gradient
                                                                            .defoultColor,
                                                                        fontFamily:
                                                                            FontFamily.gilroyBold,
                                                                        fontSize:
                                                                            15,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                InkWell(
                                                                  onTap: () {
                                                                    setState(
                                                                        () {
                                                                      onAddItem1(
                                                                        index,
                                                                        isItem(productDetailsController
                                                                            .productInfo
                                                                            ?.productData
                                                                            .productInfo[index]
                                                                            .attributeId),
                                                                        id1: productDetailsController
                                                                            .productInfo
                                                                            ?.productData
                                                                            .productInfo[index]
                                                                            .attributeId,
                                                                        price1: productDetailsController
                                                                            .productInfo
                                                                            ?.productData
                                                                            .productInfo[index]
                                                                            .normalPrice,
                                                                        strTitle1: productDetailsController
                                                                            .productInfo
                                                                            ?.productData
                                                                            .title,
                                                                        isRequride1: productDetailsController
                                                                            .productInfo
                                                                            ?.productData
                                                                            .productInfo[index]
                                                                            .subscriptionRequired,
                                                                        per1: productDetailsController
                                                                            .productInfo
                                                                            ?.productData
                                                                            .productInfo[index]
                                                                            .productDiscount,
                                                                        storeId1: storeDataContoller
                                                                            .storeDataInfo
                                                                            ?.storeInfo
                                                                            .storeId,
                                                                        sPrice1: productDetailsController
                                                                            .productInfo
                                                                            ?.productData
                                                                            .productInfo[index]
                                                                            .subscribePrice,
                                                                        img1: productDetailsController
                                                                            .productInfo
                                                                            ?.productData
                                                                            .img[0],
                                                                        productTitle1: productDetailsController
                                                                            .productInfo
                                                                            ?.productData
                                                                            .productInfo[index]
                                                                            .title,
                                                                        productId: productDetailsController
                                                                            .productInfo
                                                                            ?.productData
                                                                            .id,
                                                                      );
                                                                    });
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    height: 30,
                                                                    width: 15,
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    child: Icon(
                                                                      Icons.add,
                                                                      color: gradient
                                                                          .defoultColor,
                                                                      size: 15,
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 7,
                                                                ),
                                                              ],
                                                            ),
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              color: WhiteColor,
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .grey
                                                                      .shade300),
                                                            ),
                                                          )
                                                        : InkWell(
                                                            onTap: () {
                                                              setState(() {
                                                                if (cart.values
                                                                    .isNotEmpty) {
                                                                  for (var element
                                                                      in cart
                                                                          .values) {
                                                                    if (element
                                                                            .storeID ==
                                                                        storeDataContoller
                                                                            .storeDataInfo
                                                                            ?.storeInfo
                                                                            .storeId) {
                                                                      if (element
                                                                              .cartCheck ==
                                                                          "1") {
                                                                        Get.bottomSheet(
                                                                          Container(
                                                                            height:
                                                                                200,
                                                                            width:
                                                                                Get.size.width,
                                                                            child:
                                                                                Column(
                                                                              children: [
                                                                                SizedBox(
                                                                                  height: 15,
                                                                                ),
                                                                                Padding(
                                                                                  padding: EdgeInsets.only(top: 5, left: 15, right: 15),
                                                                                  child: Text(
                                                                                    "Would you like to empty your cart and add new items, or do you want to keep the current items in your cart?".tr,
                                                                                    style: TextStyle(
                                                                                      fontFamily: FontFamily.gilroyMedium,
                                                                                      fontSize: 16,
                                                                                      height: 1.2,
                                                                                      letterSpacing: 1,
                                                                                      color: BlackColor,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                SizedBox(
                                                                                  height: 10,
                                                                                ),
                                                                                Padding(
                                                                                  padding: const EdgeInsets.symmetric(horizontal: 15),
                                                                                  child: Divider(
                                                                                    color: Colors.grey,
                                                                                  ),
                                                                                ),
                                                                                Spacer(),
                                                                                Row(
                                                                                  children: [
                                                                                    Expanded(
                                                                                      child: InkWell(
                                                                                        onTap: () {
                                                                                          Get.back();
                                                                                        },
                                                                                        child: Container(
                                                                                          height: 40,
                                                                                          width: Get.size.width,
                                                                                          alignment: Alignment.center,
                                                                                          margin: EdgeInsets.symmetric(horizontal: 10),
                                                                                          child: Text(
                                                                                            "No".tr,
                                                                                            style: TextStyle(
                                                                                              fontFamily: FontFamily.gilroyBold,
                                                                                              color: gradient.defoultColor,
                                                                                              fontSize: 16,
                                                                                            ),
                                                                                          ),
                                                                                          decoration: BoxDecoration(
                                                                                            color: gradient.defoultColor.withOpacity(0.1),
                                                                                            borderRadius: BorderRadius.circular(25),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    Expanded(
                                                                                      child: InkWell(
                                                                                        onTap: () {
                                                                                          for (var element in cart.values) {
                                                                                            if (element.storeID == storeDataContoller.storeDataInfo?.storeInfo.storeId) {
                                                                                              if (element.cartCheck == "1") {
                                                                                                cart.delete(element.id);
                                                                                                catDetailsController.getCartLangth();
                                                                                                setState(() {});
                                                                                              }
                                                                                            }
                                                                                          }
                                                                                          //!
                                                                                          onAddItem1(
                                                                                            index,
                                                                                            isItem(productDetailsController.productInfo?.productData.productInfo[index].attributeId),
                                                                                            id1: productDetailsController.productInfo?.productData.productInfo[index].attributeId,
                                                                                            price1: productDetailsController.productInfo?.productData.productInfo[index].normalPrice,
                                                                                            strTitle1: productDetailsController.productInfo?.productData.title,
                                                                                            isRequride1: productDetailsController.productInfo?.productData.productInfo[index].subscriptionRequired,
                                                                                            per1: productDetailsController.productInfo?.productData.productInfo[index].productDiscount,
                                                                                            storeId1: storeDataContoller.storeDataInfo?.storeInfo.storeId,
                                                                                            sPrice1: productDetailsController.productInfo?.productData.productInfo[index].subscribePrice,
                                                                                            img1: productDetailsController.productInfo?.productData.img[0],
                                                                                            productTitle1: productDetailsController.productInfo?.productData.productInfo[index].title,
                                                                                            productId: productDetailsController.productInfo?.productData.id,
                                                                                          );

                                                                                          Get.back();
                                                                                        },
                                                                                        child: Container(
                                                                                          height: 40,
                                                                                          width: Get.size.width,
                                                                                          alignment: Alignment.center,
                                                                                          margin: EdgeInsets.symmetric(horizontal: 10),
                                                                                          child: Text(
                                                                                            "Clear Cart".tr,
                                                                                            style: TextStyle(
                                                                                              fontFamily: FontFamily.gilroyBold,
                                                                                              color: WhiteColor,
                                                                                              fontSize: 16,
                                                                                            ),
                                                                                          ),
                                                                                          decoration: BoxDecoration(
                                                                                            gradient: gradient.btnGradient,
                                                                                            borderRadius: BorderRadius.circular(25),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                SizedBox(
                                                                                  height: 20,
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: WhiteColor,
                                                                              borderRadius: BorderRadius.only(
                                                                                topLeft: Radius.circular(30),
                                                                                topRight: Radius.circular(30),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        );
                                                                        break;
                                                                      } else {
                                                                        onAddItem1(
                                                                          index,
                                                                          isItem(productDetailsController
                                                                              .productInfo
                                                                              ?.productData
                                                                              .productInfo[index]
                                                                              .attributeId),
                                                                          id1: productDetailsController
                                                                              .productInfo
                                                                              ?.productData
                                                                              .productInfo[index]
                                                                              .attributeId,
                                                                          price1: productDetailsController
                                                                              .productInfo
                                                                              ?.productData
                                                                              .productInfo[index]
                                                                              .normalPrice,
                                                                          strTitle1: productDetailsController
                                                                              .productInfo
                                                                              ?.productData
                                                                              .title,
                                                                          isRequride1: productDetailsController
                                                                              .productInfo
                                                                              ?.productData
                                                                              .productInfo[index]
                                                                              .subscriptionRequired,
                                                                          per1: productDetailsController
                                                                              .productInfo
                                                                              ?.productData
                                                                              .productInfo[index]
                                                                              .productDiscount,
                                                                          storeId1: storeDataContoller
                                                                              .storeDataInfo
                                                                              ?.storeInfo
                                                                              .storeId,
                                                                          sPrice1: productDetailsController
                                                                              .productInfo
                                                                              ?.productData
                                                                              .productInfo[index]
                                                                              .subscribePrice,
                                                                          img1: productDetailsController
                                                                              .productInfo
                                                                              ?.productData
                                                                              .img[0],
                                                                          productTitle1: productDetailsController
                                                                              .productInfo
                                                                              ?.productData
                                                                              .productInfo[index]
                                                                              .title,
                                                                          productId: productDetailsController
                                                                              .productInfo
                                                                              ?.productData
                                                                              .id,
                                                                        );
                                                                        break;
                                                                      }
                                                                    }
                                                                  }
                                                                } else {
                                                                  onAddItem1(
                                                                    index,
                                                                    isItem(productDetailsController
                                                                        .productInfo
                                                                        ?.productData
                                                                        .productInfo[
                                                                            index]
                                                                        .attributeId),
                                                                    id1: productDetailsController
                                                                        .productInfo
                                                                        ?.productData
                                                                        .productInfo[
                                                                            index]
                                                                        .attributeId,
                                                                    price1: productDetailsController
                                                                        .productInfo
                                                                        ?.productData
                                                                        .productInfo[
                                                                            index]
                                                                        .normalPrice,
                                                                    strTitle1: productDetailsController
                                                                        .productInfo
                                                                        ?.productData
                                                                        .title,
                                                                    isRequride1: productDetailsController
                                                                        .productInfo
                                                                        ?.productData
                                                                        .productInfo[
                                                                            index]
                                                                        .subscriptionRequired,
                                                                    per1: productDetailsController
                                                                        .productInfo
                                                                        ?.productData
                                                                        .productInfo[
                                                                            index]
                                                                        .productDiscount,
                                                                    storeId1: storeDataContoller
                                                                        .storeDataInfo
                                                                        ?.storeInfo
                                                                        .storeId,
                                                                    sPrice1: productDetailsController
                                                                        .productInfo
                                                                        ?.productData
                                                                        .productInfo[
                                                                            index]
                                                                        .subscribePrice,
                                                                    img1: productDetailsController
                                                                        .productInfo
                                                                        ?.productData
                                                                        .img[0],
                                                                    productTitle1: productDetailsController
                                                                        .productInfo
                                                                        ?.productData
                                                                        .productInfo[
                                                                            index]
                                                                        .title,
                                                                    productId: productDetailsController
                                                                        .productInfo
                                                                        ?.productData
                                                                        .id,
                                                                  );
                                                                }
                                                              });
                                                            },
                                                            child: Container(
                                                              height: 30,
                                                              width: 70,
                                                              margin: EdgeInsets
                                                                  .all(5),
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Text(
                                                                "ADD".tr,
                                                                style:
                                                                    TextStyle(
                                                                  color: gradient
                                                                      .defoultColor,
                                                                  fontFamily:
                                                                      FontFamily
                                                                          .gilroyBold,
                                                                  fontSize: 13,
                                                                ),
                                                              ),
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                                color:
                                                                    WhiteColor,
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade300),
                                                              ),
                                                            ),
                                                          )
                                                    : InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            if (cart.values
                                                                .isNotEmpty) {
                                                              for (var element
                                                                  in cart
                                                                      .values) {
                                                                if (element
                                                                        .storeID ==
                                                                    storeDataContoller
                                                                        .storeDataInfo
                                                                        ?.storeInfo
                                                                        .storeId) {
                                                                  if (element
                                                                          .cartCheck ==
                                                                      "1") {
                                                                    Get.bottomSheet(
                                                                      Container(
                                                                        height:
                                                                            200,
                                                                        width: Get
                                                                            .size
                                                                            .width,
                                                                        child:
                                                                            Column(
                                                                          children: [
                                                                            SizedBox(
                                                                              height: 15,
                                                                            ),
                                                                            Padding(
                                                                              padding: EdgeInsets.only(top: 5, left: 15, right: 15),
                                                                              child: Text(
                                                                                "Would you like to empty your cart and add new items, or do you want to keep the current items in your cart?".tr,
                                                                                style: TextStyle(
                                                                                  fontFamily: FontFamily.gilroyMedium,
                                                                                  fontSize: 16,
                                                                                  height: 1.2,
                                                                                  letterSpacing: 1,
                                                                                  color: BlackColor,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              height: 10,
                                                                            ),
                                                                            Padding(
                                                                              padding: const EdgeInsets.symmetric(horizontal: 15),
                                                                              child: Divider(
                                                                                color: Colors.grey,
                                                                              ),
                                                                            ),
                                                                            Spacer(),
                                                                            Row(
                                                                              children: [
                                                                                Expanded(
                                                                                  child: InkWell(
                                                                                    onTap: () {
                                                                                      Get.back();
                                                                                    },
                                                                                    child: Container(
                                                                                      height: 40,
                                                                                      width: Get.size.width,
                                                                                      alignment: Alignment.center,
                                                                                      margin: EdgeInsets.symmetric(horizontal: 10),
                                                                                      child: Text(
                                                                                        "No".tr,
                                                                                        style: TextStyle(
                                                                                          fontFamily: FontFamily.gilroyBold,
                                                                                          color: gradient.defoultColor,
                                                                                          fontSize: 16,
                                                                                        ),
                                                                                      ),
                                                                                      decoration: BoxDecoration(
                                                                                        color: gradient.defoultColor.withOpacity(0.1),
                                                                                        borderRadius: BorderRadius.circular(25),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Expanded(
                                                                                  child: InkWell(
                                                                                    onTap: () {
                                                                                      for (var element in cart.values) {
                                                                                        if (element.storeID == storeDataContoller.storeDataInfo?.storeInfo.storeId) {
                                                                                          if (element.cartCheck == "1") {
                                                                                            cart.delete(element.id);
                                                                                            catDetailsController.getCartLangth();
                                                                                            setState(() {});
                                                                                          }
                                                                                        }
                                                                                      }
                                                                                      //!
                                                                                      onAddItem1(
                                                                                        index,
                                                                                        isItem(productDetailsController.productInfo?.productData.productInfo[index].attributeId),
                                                                                        id1: productDetailsController.productInfo?.productData.productInfo[index].attributeId,
                                                                                        price1: productDetailsController.productInfo?.productData.productInfo[index].normalPrice,
                                                                                        strTitle1: productDetailsController.productInfo?.productData.title,
                                                                                        isRequride1: productDetailsController.productInfo?.productData.productInfo[index].subscriptionRequired,
                                                                                        per1: productDetailsController.productInfo?.productData.productInfo[index].productDiscount,
                                                                                        storeId1: storeDataContoller.storeDataInfo?.storeInfo.storeId,
                                                                                        sPrice1: productDetailsController.productInfo?.productData.productInfo[index].subscribePrice,
                                                                                        img1: productDetailsController.productInfo?.productData.img[0],
                                                                                        productTitle1: productDetailsController.productInfo?.productData.productInfo[index].title,
                                                                                        productId: productDetailsController.productInfo?.productData.id,
                                                                                      );

                                                                                      Get.back();
                                                                                    },
                                                                                    child: Container(
                                                                                      height: 40,
                                                                                      width: Get.size.width,
                                                                                      alignment: Alignment.center,
                                                                                      margin: EdgeInsets.symmetric(horizontal: 10),
                                                                                      child: Text(
                                                                                        "Clear Cart".tr,
                                                                                        style: TextStyle(
                                                                                          fontFamily: FontFamily.gilroyBold,
                                                                                          color: WhiteColor,
                                                                                          fontSize: 16,
                                                                                        ),
                                                                                      ),
                                                                                      decoration: BoxDecoration(
                                                                                        gradient: gradient.btnGradient,
                                                                                        borderRadius: BorderRadius.circular(25),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            SizedBox(
                                                                              height: 20,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              WhiteColor,
                                                                          borderRadius:
                                                                              BorderRadius.only(
                                                                            topLeft:
                                                                                Radius.circular(30),
                                                                            topRight:
                                                                                Radius.circular(30),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    );
                                                                    break;
                                                                  } else {
                                                                    onAddItem1(
                                                                      index,
                                                                      isItem(productDetailsController
                                                                          .productInfo
                                                                          ?.productData
                                                                          .productInfo[
                                                                              index]
                                                                          .attributeId),
                                                                      id1: productDetailsController
                                                                          .productInfo
                                                                          ?.productData
                                                                          .productInfo[
                                                                              index]
                                                                          .attributeId,
                                                                      price1: productDetailsController
                                                                          .productInfo
                                                                          ?.productData
                                                                          .productInfo[
                                                                              index]
                                                                          .normalPrice,
                                                                      strTitle1: productDetailsController
                                                                          .productInfo
                                                                          ?.productData
                                                                          .title,
                                                                      isRequride1: productDetailsController
                                                                          .productInfo
                                                                          ?.productData
                                                                          .productInfo[
                                                                              index]
                                                                          .subscriptionRequired,
                                                                      per1: productDetailsController
                                                                          .productInfo
                                                                          ?.productData
                                                                          .productInfo[
                                                                              index]
                                                                          .productDiscount,
                                                                      storeId1: storeDataContoller
                                                                          .storeDataInfo
                                                                          ?.storeInfo
                                                                          .storeId,
                                                                      sPrice1: productDetailsController
                                                                          .productInfo
                                                                          ?.productData
                                                                          .productInfo[
                                                                              index]
                                                                          .subscribePrice,
                                                                      img1: productDetailsController
                                                                          .productInfo
                                                                          ?.productData
                                                                          .img[0],
                                                                      productTitle1: productDetailsController
                                                                          .productInfo
                                                                          ?.productData
                                                                          .productInfo[
                                                                              index]
                                                                          .title,
                                                                      productId: productDetailsController
                                                                          .productInfo
                                                                          ?.productData
                                                                          .id,
                                                                    );
                                                                    break;
                                                                  }
                                                                } else {
                                                                  onAddItem1(
                                                                    index,
                                                                    isItem(productDetailsController
                                                                        .productInfo
                                                                        ?.productData
                                                                        .productInfo[
                                                                            index]
                                                                        .attributeId),
                                                                    id1: productDetailsController
                                                                        .productInfo
                                                                        ?.productData
                                                                        .productInfo[
                                                                            index]
                                                                        .attributeId,
                                                                    price1: productDetailsController
                                                                        .productInfo
                                                                        ?.productData
                                                                        .productInfo[
                                                                            index]
                                                                        .normalPrice,
                                                                    strTitle1: productDetailsController
                                                                        .productInfo
                                                                        ?.productData
                                                                        .title,
                                                                    isRequride1: productDetailsController
                                                                        .productInfo
                                                                        ?.productData
                                                                        .productInfo[
                                                                            index]
                                                                        .subscriptionRequired,
                                                                    per1: productDetailsController
                                                                        .productInfo
                                                                        ?.productData
                                                                        .productInfo[
                                                                            index]
                                                                        .productDiscount,
                                                                    storeId1: storeDataContoller
                                                                        .storeDataInfo
                                                                        ?.storeInfo
                                                                        .storeId,
                                                                    sPrice1: productDetailsController
                                                                        .productInfo
                                                                        ?.productData
                                                                        .productInfo[
                                                                            index]
                                                                        .subscribePrice,
                                                                    img1: productDetailsController
                                                                        .productInfo
                                                                        ?.productData
                                                                        .img[0],
                                                                    productTitle1: productDetailsController
                                                                        .productInfo
                                                                        ?.productData
                                                                        .productInfo[
                                                                            index]
                                                                        .title,
                                                                    productId: productDetailsController
                                                                        .productInfo
                                                                        ?.productData
                                                                        .id,
                                                                  );
                                                                  break;
                                                                }
                                                              }
                                                            } else {
                                                              onAddItem1(
                                                                index,
                                                                isItem(productDetailsController
                                                                    .productInfo
                                                                    ?.productData
                                                                    .productInfo[
                                                                        index]
                                                                    .attributeId),
                                                                id1: productDetailsController
                                                                    .productInfo
                                                                    ?.productData
                                                                    .productInfo[
                                                                        index]
                                                                    .attributeId,
                                                                price1: productDetailsController
                                                                    .productInfo
                                                                    ?.productData
                                                                    .productInfo[
                                                                        index]
                                                                    .normalPrice,
                                                                strTitle1: productDetailsController
                                                                    .productInfo
                                                                    ?.productData
                                                                    .title,
                                                                isRequride1: productDetailsController
                                                                    .productInfo
                                                                    ?.productData
                                                                    .productInfo[
                                                                        index]
                                                                    .subscriptionRequired,
                                                                per1: productDetailsController
                                                                    .productInfo
                                                                    ?.productData
                                                                    .productInfo[
                                                                        index]
                                                                    .productDiscount,
                                                                storeId1: storeDataContoller
                                                                    .storeDataInfo
                                                                    ?.storeInfo
                                                                    .storeId,
                                                                sPrice1: productDetailsController
                                                                    .productInfo
                                                                    ?.productData
                                                                    .productInfo[
                                                                        index]
                                                                    .subscribePrice,
                                                                img1: productDetailsController
                                                                    .productInfo
                                                                    ?.productData
                                                                    .img[0],
                                                                productTitle1: productDetailsController
                                                                    .productInfo
                                                                    ?.productData
                                                                    .productInfo[
                                                                        index]
                                                                    .title,
                                                                productId: productDetailsController
                                                                    .productInfo
                                                                    ?.productData
                                                                    .id,
                                                              );
                                                            }
                                                          });
                                                        },
                                                        child: Container(
                                                          height: 30,
                                                          width: 70,
                                                          margin:
                                                              EdgeInsets.all(5),
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                            "ADD".tr,
                                                            style: TextStyle(
                                                              color: gradient
                                                                  .defoultColor,
                                                              fontFamily:
                                                                  FontFamily
                                                                      .gilroyBold,
                                                              fontSize: 13,
                                                            ),
                                                          ),
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            color: WhiteColor,
                                                            border: Border.all(
                                                                color: Colors
                                                                    .grey
                                                                    .shade300),
                                                          ),
                                                        ),
                                                      )
                                                : Container(
                                                    height: 27,
                                                    width: 80,
                                                    margin: EdgeInsets.all(5),
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      "Out of stock".tr,
                                                      style: TextStyle(
                                                        color: RedColor,
                                                        fontFamily: FontFamily
                                                            .gilroyMedium,
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      color: WhiteColor,
                                                      border: Border.all(
                                                          color: RedColor),
                                                    ),
                                                  ),
                                          ),
                                          productDetailsController
                                                      .productInfo
                                                      ?.productData
                                                      .productInfo[index]
                                                      .productDiscount !=
                                                  "0"
                                              ? Positioned(
                                                  top: 5,
                                                  left: 20,
                                                  right: 20,
                                                  child: Container(
                                                    height: 15,
                                                    width: 40,
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      "${productDetailsController.productInfo?.productData.productInfo[index].productDiscount}% OFF",
                                                      style: TextStyle(
                                                        fontFamily: FontFamily
                                                            .gilroyMedium,
                                                        color: WhiteColor,
                                                        fontSize: 11,
                                                      ),
                                                    ),
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        image: AssetImage(
                                                          "assets/selectUnitLable.png",
                                                        ),
                                                        fit: BoxFit.fill,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : SizedBox(),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Text(
                                    "a".tr,
                                    style: TextStyle(
                                      fontFamily: FontFamily.gilroyBold,
                                      fontSize: 15,
                                      color: BlackColor,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: ReadMoreText(
                                    productDetailsController.productInfo
                                            ?.productData.productDescription ??
                                        "",
                                    trimLines: 2,
                                    trimMode: TrimMode.Line,
                                    trimCollapsedText: 'Show more',
                                    trimExpandedText: 'Show less',
                                    moreStyle: TextStyle(
                                      fontFamily: FontFamily.gilroyBold,
                                      fontSize: 14,
                                      color: gradient.defoultColor,
                                    ),
                                    lessStyle: TextStyle(
                                      fontFamily: FontFamily.gilroyBold,
                                      fontSize: 14,
                                      color: gradient.defoultColor,
                                    ),
                                    style: TextStyle(
                                      fontFamily: FontFamily.gilroyMedium,
                                      fontSize: 12,
                                      color: BlackColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Center(
                          child: CircularProgressIndicator(
                            color: gradient.defoultColor,
                          ),
                        );
                }),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerTop,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
            );
          });
        });
  }
}
