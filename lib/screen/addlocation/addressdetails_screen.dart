// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:milkman/Api/data_store.dart';
import 'package:milkman/controller/addlocation_controller.dart';
import 'package:milkman/controller/catdetails_controller.dart';
import 'package:milkman/controller/home_controller.dart';
import 'package:milkman/model/fontfamily_model.dart';
import 'package:milkman/utils/Colors.dart';

class AddressDetailsScreen extends StatefulWidget {
  const AddressDetailsScreen({super.key});

  @override
  State<AddressDetailsScreen> createState() => _AddressDetailsScreenState();
}

class _AddressDetailsScreenState extends State<AddressDetailsScreen> {
  AddLocationController addLocationController = Get.find();
  late GoogleMapController mapController;
  final List<Marker> _markers = <Marker>[];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  CatDetailsController catDetailsController = Get.find();
  HomePageController homePageController = Get.find();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<Uint8List> getImages(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetHeight: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  loadData() async {
    final Uint8List markIcons =
        await getImages("assets/ic_destination_long.png", 100);
    // makers added according to index
    _markers.add(
      Marker(
        // given marker id
        markerId: MarkerId("1"),
        // given marker icon
        icon: BitmapDescriptor.fromBytes(markIcons),
        // given position
        position: LatLng(
          addLocationController.lat,
          addLocationController.long,
        ),
        infoWindow: InfoWindow(),
      ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      appBar: AppBar(
        backgroundColor: WhiteColor,
        elevation: 0,
        leading: BackButton(
          onPressed: () {
            Get.back();
          },
          color: BlackColor,
        ),
        title: Text(
          "Enter address details".tr,
          maxLines: 1,
          style: TextStyle(
            fontFamily: FontFamily.gilroyBold,
            color: BlackColor,
            fontSize: 17,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        actions: [
          Container(
            height: 50,
            width: 40,
            alignment: Alignment.center,
            child: Text.rich(
              TextSpan(
                text: '3',
                style: TextStyle(
                  color: BlackColor,
                  fontFamily: FontFamily.gilroyBold,
                  fontSize: 17,
                ),
                children: <InlineSpan>[
                  TextSpan(
                    text: '/3',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: FontFamily.gilroyMedium,
                      color: greyColor,
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      bottomNavigationBar: InkWell(
        onTap: () {
          if (_formKey.currentState?.validate() ?? false) {
            save("changeIndex", true);
            homePageController.isback = "2";
            addLocationController.addAddressApi();
          }
        },
        child: Container(
          height: 50,
          width: Get.size.width,
          margin: EdgeInsets.only(left: 15, right: 15, bottom: 15),
          alignment: Alignment.center,
          child: Text(
            "Save Address".tr,
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
      body: Container(
        height: Get.size.height,
        width: Get.size.width,
        color: WhiteColor,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      height: 240,
                      width: Get.size.width,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: LatLng(
                              addLocationController.lat,
                              addLocationController.long,
                            ), //initial position
                            zoom: 15.0, //initial zoom level
                          ),
                          markers: Set<Marker>.of(_markers),
                          mapType: MapType.normal,
                          myLocationEnabled: true,
                          compassEnabled: true,
                          zoomGesturesEnabled: true,
                          tiltGesturesEnabled: true,
                          zoomControlsEnabled: true,
                          onMapCreated: (controller) {
                            setState(() {
                              mapController = controller;
                            });
                          },
                        ),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: WhiteColor,
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      right: 20,
                      left: 20,
                      child: Container(
                        height: 70,
                        width: Get.size.width,
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  "assets/location-crosshairs1.png",
                                  height: 20,
                                  width: 20,
                                ),
                                SizedBox(
                                  width: 7,
                                ),
                                Text(
                                  "Near".tr,
                                  style: TextStyle(
                                    fontFamily: FontFamily.gilroyBold,
                                    color: BlackColor,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              addLocationController.address.toString(),
                              maxLines: 1,
                              style: TextStyle(
                                fontFamily: FontFamily.gilroyMedium,
                                fontSize: 15,
                                color: BlackColor,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        decoration: BoxDecoration(
                          color: WhiteColor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    )
                  ],
                ),
                Container(
                  margin: EdgeInsets.all(15),
                  alignment: Alignment.center,
                  child: TextFormField(
                    controller: addLocationController.completeAddress,
                    minLines: 5,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.done,
                    cursorColor: BlackColor,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      focusedBorder: InputBorder.none,
                      border: InputBorder.none,
                      hintText: "Complete address".tr,
                      hintStyle: TextStyle(
                        fontFamily: FontFamily.gilroyMedium,
                        fontSize: 15,
                      ),
                    ),
                    style: TextStyle(
                      fontFamily: FontFamily.gilroyMedium,
                      fontSize: 16,
                      color: BlackColor,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Complete address'.tr;
                      }
                      return null;
                    },
                  ),
                  decoration: BoxDecoration(
                    color: WhiteColor,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: TextFormField(
                    controller: addLocationController.landMark,
                    keyboardType: TextInputType.multiline,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textInputAction: TextInputAction.done,
                    cursorColor: BlackColor,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                        ),
                      ),
                      hintText: "Landmark".tr,
                      hintStyle: TextStyle(
                        fontFamily: FontFamily.gilroyMedium,
                        fontSize: 15,
                      ),
                    ),
                    style: TextStyle(
                      fontFamily: FontFamily.gilroyMedium,
                      fontSize: 16,
                      color: BlackColor,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Landmark'.tr;
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(15),
                  alignment: Alignment.center,
                  child: TextFormField(
                    controller: addLocationController.reach,
                    minLines: 5,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.done,
                    maxLines: null,
                    cursorColor: BlackColor,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      focusedBorder: InputBorder.none,
                      border: InputBorder.none,
                      hintText: "How to reach instructions (Optional)".tr,
                      hintStyle: TextStyle(
                        fontFamily: FontFamily.gilroyMedium,
                        fontSize: 15,
                      ),
                    ),
                    style: TextStyle(
                      fontFamily: FontFamily.gilroyMedium,
                      fontSize: 16,
                      color: BlackColor,
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: WhiteColor,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(left: 17),
                  child: Text(
                    "Save address as".tr,
                    style: TextStyle(
                      color: BlackColor,
                      fontFamily: FontFamily.gilroyBold,
                      fontSize: 15,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: TextFormField(
                    controller: addLocationController.homeAddress,
                    keyboardType: TextInputType.multiline,
                    cursorColor: BlackColor,
                    textInputAction: TextInputAction.done,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                        ),
                      ),
                      hintText: "Eg: Home, Store".tr,
                      hintStyle: TextStyle(
                        fontFamily: FontFamily.gilroyMedium,
                        fontSize: 15,
                      ),
                    ),
                    style: TextStyle(
                      fontFamily: FontFamily.gilroyMedium,
                      fontSize: 16,
                      color: BlackColor,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter save address as'.tr;
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
