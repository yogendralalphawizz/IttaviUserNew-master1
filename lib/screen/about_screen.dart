// ignore_for_file: prefer_const_constructors, unused_field, prefer_const_literals_to_create_immutables, sort_child_properties_last, must_be_immutable, use_key_in_widget_constructors, unnecessary_null_comparison, unnecessary_new, library_private_types_in_public_api, unused_local_variable, no_leading_underscores_for_local_identifiers, prefer_const_declarations

import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:milkman/Api/config.dart';
import 'package:milkman/controller/fav_controller.dart';
import 'package:milkman/controller/stordata_controller.dart';
import 'package:milkman/model/fontfamily_model.dart';
import 'package:milkman/utils/Colors.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen>
    with TickerProviderStateMixin {
  StoreDataContoller storeDataContoller = Get.find();
  FavController favController = Get.find();
  TabController? _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      appBar: AppBar(
        backgroundColor: WhiteColor,
        elevation: 0,
        leading: BackButton(
          color: BlackColor,
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          storeDataContoller.storeDataInfo?.storeInfo.storeTitle ?? "",
          style: TextStyle(
            fontFamily: FontFamily.gilroyBold,
            fontSize: 18,
            color: BlackColor,
          ),
        ),
      ),
      body: SizedBox(
        height: Get.size.height,
        width: Get.size.width,
        child: Column(
          children: [
            // Container(
            //   color: WhiteColor,
            //   height: 50,
            //   child: TabBar(
            //     indicatorColor: gradient.defoultColor,
            //     controller: _tabController,
            //     unselectedLabelColor: greyColor,
            //     indicatorSize: TabBarIndicatorSize.label,
            //     labelStyle: const TextStyle(
            //       fontWeight: FontWeight.w600,
            //       fontFamily: FontFamily.gilroyBold,
            //       fontSize: 16,
            //     ),
            //     indicator: MD2Indicator(
            //       indicatorSize: MD2IndicatorSize.full,
            //       indicatorHeight: 5,
            //       indicatorColor: gradient.defoultColor,
            //     ),
            //     labelColor: BlackColor,
            //     onTap: (value) {},
            //     tabs: [
            //       // Tab(
            //       //   // text: "Overview",
            //       //   child: Text(
            //       //     "Overview".tr,
            //       //     maxLines: 1,
            //       //     style: TextStyle(
            //       //       fontFamily: FontFamily.gilroyMedium,
            //       //       fontSize: 15,
            //       //       overflow: TextOverflow.ellipsis,
            //       //       color: BlackColor,
            //       //     ),
            //       //   ),
            //       // ),
            //       // Tab(
            //       //   // text:
            //       //   //     "Photos(${storeDataContoller.storeDataInfo?.photos.length})",
            //       //   child: Text(
            //       //     "Photos".tr,
            //       //     style: TextStyle(
            //       //       fontFamily: FontFamily.gilroyMedium,
            //       //       fontSize: 15,
            //       //       color: BlackColor,
            //       //     ),
            //       //   ),
            //       // ),
            //       // Tab(
            //       //   // text: "Review",
            //       //   child: Text(
            //       //     "Review".tr,
            //       //     style: TextStyle(
            //       //       fontFamily: FontFamily.gilroyMedium,
            //       //       fontSize: 15,
            //       //       color: BlackColor,
            //       //     ),
            //       //   ),
            //       // ),
            //       // Tab(
            //       //   // text: "FAQ",
            //       //   child: Text(
            //       //     "FAQ".tr,
            //       //     style: TextStyle(
            //       //       fontFamily: FontFamily.gilroyMedium,
            //       //       fontSize: 15,
            //       //       color: BlackColor,
            //       //     ),
            //       //   ),
            //       // ),
            //     ],
            //   ),
            // ),
            Expanded(
              flex: 1,
              child: TabBarView(
                controller: _tabController,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  overViewWidget(),
                  // photoWidget(),
                  // reviewWidget(),
                  // faqWidget()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget overViewWidget() {
    List<String> stringList = storeDataContoller
        .storeDataInfo!.storeInfo.storeCanclePolicy
        .split(". ");
    return GetBuilder<StoreDataContoller>(builder: (context) {
      return storeDataContoller.isLoading
          ? Container(
              height: Get.size.height,
              width: Get.size.width,
              color: WhiteColor,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  storeDataContoller.storeDataInfo?.storeInfo
                                          .storeTitle ??
                                      "",
                                  style: TextStyle(
                                    color: BlackColor,
                                    fontFamily: FontFamily.gilroyBold,
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  storeDataContoller.storeDataInfo?.storeInfo
                                          .storeAddress ??
                                      "",
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: BlackColor,
                                    fontFamily: FontFamily.gilroyMedium,
                                    fontSize: 15,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          // AnimatedContainer(
                          //   height: 40,
                          //   width: storeDataContoller
                          //               .storeDataInfo?.storeInfo.isFavourite ==
                          //           0
                          //       ? Get.size.width * 0.4
                          //       : Get.size.width * 0.17,
                          //   duration: const Duration(seconds: 1),
                          //   curve: Curves.fastOutSlowIn,
                          //   alignment: Alignment.center,
                          //   margin: EdgeInsets.all(10),
                          //   child: InkWell(
                          //     onTap: () {
                          //       favController.addFavAndRemoveApi(
                          //         storeId: storeDataContoller
                          //             .storeDataInfo?.storeInfo.storeId,
                          //       );
                          //     },
                          //     child: Row(
                          //       mainAxisAlignment: MainAxisAlignment.center,
                          //       children: [
                          //         storeDataContoller.storeDataInfo?.storeInfo
                          //                     .isFavourite ==
                          //                 0
                          //             ? Image.asset(
                          //                 "assets/heartOutlinded.png",
                          //                 height: 20,
                          //                 width: 20,
                          //                 color: gradient.defoultColor,
                          //               )
                          //             : Image.asset(
                          //                 "assets/heart.png",
                          //                 height: 20,
                          //                 width: 20,
                          //                 color: gradient.defoultColor,
                          //               ),
                          //         storeDataContoller.storeDataInfo?.storeInfo.isFavourite == 0
                          //             ? SizedBox(
                          //                 width: 8,
                          //               )
                          //             : SizedBox(),
                          //         storeDataContoller.storeDataInfo?.storeInfo.isFavourite == 0
                          //             ? Text(
                          //                 "Love This".tr,
                          //                 maxLines: 1,
                          //                 style: TextStyle(
                          //                   color: gradient.defoultColor,
                          //                   fontFamily: FontFamily.gilroyBold,
                          //                   fontSize: 16,
                          //                   overflow: TextOverflow.ellipsis,
                          //                 ),
                          //               )
                          //             : SizedBox(),
                          //       ],
                          //     ),
                          //   ),
                          //   decoration: BoxDecoration(
                          //     border: Border.all(color: Colors.grey.shade300),
                          //     borderRadius: BorderRadius.circular(10),
                          //   ),
                          // ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      // Row(
                      //   children: [
                      //     Image.asset(
                      //       "assets/heart.png",
                      //       height: 20,
                      //       width: 20,
                      //       color: gradient.defoultColor,
                      //     ),
                      //     SizedBox(
                      //       width: 5,
                      //     ),
                      //     Expanded(
                      //       child: Text(
                      //         "${storeDataContoller.storeDataInfo?.storeInfo.totalFav} ${"Love this".tr}",
                      //         maxLines: 1,
                      //         style: TextStyle(
                      //           color: BlackColor,
                      //           fontFamily: FontFamily.gilroyMedium,
                      //           overflow: TextOverflow.ellipsis,
                      //         ),
                      //       ),
                      //     ),
                      //     SizedBox(
                      //       width: 10,
                      //     ),
                      //   ],
                      // ),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      // Text(
                      //   storeDataContoller.storeDataInfo?.storeInfo.storeTags
                      //           .join(", ") ??
                      //       "",
                      //   maxLines: 3,
                      //   style: TextStyle(
                      //     color: BlackColor,
                      //     fontFamily: FontFamily.gilroyMedium,
                      //     overflow: TextOverflow.ellipsis,
                      //   ),
                      // ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Orders and delivery".tr,
                        style: TextStyle(
                          color: BlackColor,
                          fontFamily: FontFamily.gilroyBold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      catDRow(
                        img: "assets/box.png",
                        text: "Delivery across your zone".tr,
                      ),
                      catDRow(
                        img: "assets/clock.png",
                        text: "Usually dispatches orders on the same day".tr,
                      ),
                      catDRow(
                        img: "assets/star.png",
                        text: "Delivery fee will apply".tr,
                      ),
                      catDRow(
                        img: "assets/shopping-bag-alt.png",
                        text:
                            "${"All orders will be Delivered by".tr} ${storeDataContoller.storeDataInfo?.storeInfo.storeTitle ?? ""}",
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Cancellation policy".tr,
                        style: TextStyle(
                          color: BlackColor,
                          fontFamily: FontFamily.gilroyBold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      ListView.builder(
                        itemCount: stringList.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 8),
                            child: HtmlWidget(
                              stringList[index],
                              textStyle: TextStyle(
                                color: BlackColor,
                                fontSize: 15,
                                overflow: TextOverflow.ellipsis,
                                fontFamily: FontFamily.gilroyMedium,
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Store info".tr,
                        style: TextStyle(
                          color: BlackColor,
                          fontFamily: FontFamily.gilroyBold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      catDRow(
                        img: "assets/location-pin.png",
                        text: storeDataContoller
                                .storeDataInfo?.storeInfo.storeAddress ??
                            "",
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      catDRow(
                        img: "assets/phone-call.png",
                        text: storeDataContoller
                                .storeDataInfo?.storeInfo.storeMobile ??
                            "",
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      catDRow(
                        img: "assets/envelopes.png",
                        text: storeDataContoller
                                .storeDataInfo?.storeInfo.storeEmail ??
                            "",
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      catDRow(
                        img: "assets/clock.png",
                        text:
                            "${DateFormat.jm().format(DateTime.parse("2023-03-20T${storeDataContoller.storeDataInfo?.storeInfo.storeOpentime ?? ""}"))} to ${DateFormat.jm().format(DateTime.parse("2023-03-20T${storeDataContoller.storeDataInfo?.storeInfo.storeClosetime ?? ""}"))}",
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            )
          : Center(
              child: CircularProgressIndicator(
                color: gradient.defoultColor,
              ),
            );
    });
  }

  Widget photoWidget() {
    return Container(
      height: Get.size.height,
      width: Get.size.width,
      color: WhiteColor,
      child: storeDataContoller.storeDataInfo!.photos.isNotEmpty
          ? Padding(
              padding: EdgeInsets.only(left: 8, right: 8, top: 8),
              child: GridView.builder(
                itemCount: storeDataContoller.storeDataInfo?.photos.length,
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  mainAxisExtent: 120,
                ),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Get.to(
                        FullScreenImage(
                          imageUrl:
                              "${Config.imageUrl}${storeDataContoller.storeDataInfo?.photos[index].img ?? ""}",
                          tag: "generate_a_unique_tag",
                        ),
                      );
                    },
                    child: Container(
                      height: 110,
                      width: 110,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: FadeInImage.assetNetwork(
                          placeholder: "assets/ezgif.com-crop.gif",
                          placeholderCacheWidth: 110,
                          placeholderCacheHeight: 110,
                          image:
                              "${Config.imageUrl}${storeDataContoller.storeDataInfo?.photos[index].img ?? ""}",
                          fit: BoxFit.cover,
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: WhiteColor,
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                },
              ),
            )
          : Center(
              child: Text(
                "Sorry, there are no photos \n available to display at this time"
                    .tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: FontFamily.gilroyBold,
                  fontSize: 15,
                ),
              ),
            ),
    );
  }

  Widget reviewWidget() {
    return Container(
      height: Get.size.height,
      width: Get.size.width,
      color: WhiteColor,
      child: storeDataContoller.storeDataInfo!.reviewdata.isNotEmpty
          ? ListView.builder(
              itemCount: storeDataContoller.storeDataInfo?.reviewdata.length,
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      leading: Container(
                        height: 60,
                        width: 60,
                        alignment: Alignment.center,
                        child: Text(
                          storeDataContoller.storeDataInfo?.reviewdata[index]
                                  .userTitle[0] ??
                              "",
                          style: TextStyle(
                            fontFamily: FontFamily.gilroyBold,
                            fontSize: 22,
                          ),
                        ),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.shade200,
                        ),
                      ),
                      title: Text(
                        storeDataContoller
                                .storeDataInfo?.reviewdata[index].userTitle ??
                            "",
                        style: TextStyle(
                          color: BlackColor,
                          fontFamily: FontFamily.gilroyBold,
                          fontSize: 17,
                        ),
                      ),
                      subtitle: Text(
                        storeDataContoller
                                .storeDataInfo?.reviewdata[index].reviewDate
                                .toString()
                                .split(" ")
                                .first ??
                            "",
                        textAlign: TextAlign.start,
                        maxLines: 2,
                        style: TextStyle(
                          color: greycolor,
                          fontFamily: FontFamily.gilroyMedium,
                        ),
                      ),
                      trailing: Container(
                        height: 40,
                        width: 70,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/reviewStar.png",
                              height: 15,
                              width: 15,
                              color: gradient.defoultColor,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              storeDataContoller.storeDataInfo
                                      ?.reviewdata[index].userRate ??
                                  "",
                              style: TextStyle(
                                fontSize: 15,
                                fontFamily: FontFamily.gilroyBold,
                                color: gradient.defoultColor,
                              ),
                            )
                          ],
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: gradient.defoultColor,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        storeDataContoller
                                .storeDataInfo?.reviewdata[index].userDesc ??
                            "",
                        textAlign: TextAlign.start,
                        maxLines: 2,
                        style: TextStyle(
                          color: greycolor,
                          fontFamily: FontFamily.gilroyMedium,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                  ],
                );
              },
            )
          : Center(
              child: Text(
                "Sorry, there are no reviews \nto display at this time".tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: FontFamily.gilroyBold,
                  fontSize: 15,
                ),
              ),
            ),
    );
  }

  Widget faqWidget() {
    final _contentStyle = const TextStyle(
        color: Color(0xff999999), fontSize: 14, fontWeight: FontWeight.normal);
    return Container(
      height: Get.size.height,
      width: Get.size.width,
      color: WhiteColor,
      child: storeDataContoller.storeDataInfo!.faQdata.isNotEmpty
          ? SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Accordion(
                disableScrolling: true,
                flipRightIconIfOpen: true,
                contentVerticalPadding: 0,
                scrollIntoViewOfItems: ScrollIntoViewOfItems.fast,
                contentBorderColor: Colors.transparent,
                maxOpenSections: 1,
                headerBackgroundColorOpened: Colors.grey.shade100,
                headerPadding:
                    const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
                children: [
                  for (var j = 0;
                      j < storeDataContoller.storeDataInfo!.faQdata.length;
                      j++)
                    AccordionSection(
                      rightIcon: Image.asset(
                        "assets/Arrow - Down.png",
                        height: 20,
                        width: 20,
                        color: gradient.defoultColor,
                      ),
                      headerPadding: const EdgeInsets.all(15),
                      headerBackgroundColor: Colors.grey.shade100,
                      contentBackgroundColor: Colors.grey.shade100,
                      header: Text(
                          storeDataContoller
                                  .storeDataInfo?.faQdata[j].question ??
                              "",
                          style: TextStyle(
                              color: BlackColor,
                              fontSize: 15,
                              fontWeight: FontWeight.bold)),
                      content: Text(
                        storeDataContoller.storeDataInfo?.faQdata[j].answer ??
                            "",
                        style: _contentStyle,
                      ),
                      contentHorizontalPadding: 20,
                      contentBorderWidth: 1,
                    ),
                ],
              ),
            )
          : Center(
              child: Text(
                "Sorry, there are no photos \navailable to display at this time"
                    .tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: FontFamily.gilroyBold,
                  fontSize: 15,
                  color: BlackColor,
                ),
              ),
            ),
    );
  }

  Widget catDRow({String? img, text}) {
    return Padding(
      padding: EdgeInsets.only(top: 8),
      child: Row(
        children: [
          Image.asset(
            img ?? "",
            height: 15,
            width: 15,
            color: BlackColor,
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text(
              text,
              maxLines: 2,
              style: TextStyle(
                color: BlackColor,
                fontFamily: FontFamily.gilroyMedium,
                fontSize: 14,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FullScreenImage extends StatelessWidget {
  String? imageUrl;
  String? tag;
  FullScreenImage({this.imageUrl, this.tag});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: tag ?? "",
            child: CachedNetworkImage(
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.contain,
              imageUrl: imageUrl ?? "",
            ),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}

class MD2Indicator extends Decoration {
  final double indicatorHeight;
  final Color indicatorColor;
  final MD2IndicatorSize indicatorSize;

  const MD2Indicator({
    required this.indicatorHeight,
    required this.indicatorColor,
    required this.indicatorSize,
  });

  @override
  _MD2Painter createBoxPainter([VoidCallback? onChanged]) {
    return new _MD2Painter(this, onChanged!);
  }
}

enum MD2IndicatorSize {
  tiny,
  normal,
  full,
}

class _MD2Painter extends BoxPainter {
  final MD2Indicator decoration;

  _MD2Painter(this.decoration, VoidCallback onChanged)
      : assert(decoration != null),
        super(onChanged);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration != null);
    assert(configuration.size != null);

    Rect? rect;
    if (decoration.indicatorSize == MD2IndicatorSize.full) {
      rect = Offset(offset.dx,
              (configuration.size!.height - decoration.indicatorHeight)) &
          Size(configuration.size!.width, decoration.indicatorHeight);
    } else if (decoration.indicatorSize == MD2IndicatorSize.normal) {
      rect = Offset(offset.dx + 6,
              (configuration.size!.height - decoration.indicatorHeight)) &
          Size(configuration.size!.width - 12, decoration.indicatorHeight);
    } else if (decoration.indicatorSize == MD2IndicatorSize.tiny) {
      rect = Offset(offset.dx + configuration.size!.width / 2 - 8,
              (configuration.size!.height - decoration.indicatorHeight)) &
          Size(16, decoration.indicatorHeight);
    }

    final Paint paint = Paint();
    paint.color = decoration.indicatorColor;
    paint.style = PaintingStyle.fill;
    canvas.drawRRect(
        RRect.fromRectAndCorners(rect!,
            topRight: Radius.circular(8), topLeft: Radius.circular(8)),
        paint);
  }
}
