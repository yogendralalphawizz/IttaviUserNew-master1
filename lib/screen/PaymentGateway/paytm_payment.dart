// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_final_fields, await_only_futures, prefer_typing_uninitialized_variables, use_key_in_widget_constructors, unused_local_variable, prefer_collection_literals, unused_field, avoid_print, prefer_interpolation_to_compose_strings, unnecessary_string_interpolations, avoid_unnecessary_containers, file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:milkman/Api/config.dart';
import 'package:milkman/controller/cart_controller.dart';
import 'package:milkman/model/fontfamily_model.dart';
import 'package:milkman/utils/Custom_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PayTmPayment extends StatefulWidget {
  final String? uid;
  final String? totalAmount;

  const PayTmPayment({this.uid, this.totalAmount});

  @override
  State<PayTmPayment> createState() => _PayTmPaymentState();
}

class _PayTmPaymentState extends State<PayTmPayment> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late WebViewController _controller;
  var progress;
  String? accessToken;
  String? payerID;
  bool isLoading = true;
  CartController cartController = Get.find();

  @override
  Widget build(BuildContext context) {
    if (_scaffoldKey.currentState == null) {
      return WillPopScope(
        onWillPop: () {
          cartController.setOrderLoadingOff();
          return Future.value(true);
        },
        child: Scaffold(
          body: SafeArea(
            child: Stack(
              children: [
                WebView(
                  initialUrl:
                      "${Config.paymentBaseUrl + "paytm/index.php?amt=${widget.totalAmount}&uid=${widget.uid}"}",
                  javascriptMode: JavascriptMode.unrestricted,
                  navigationDelegate: (NavigationRequest request) async {
                    final uri = Uri.parse(request.url);

                    if (uri.queryParameters["status"] == null) {
                      accessToken = uri.queryParameters["token"];
                    } else {
                      if (uri.queryParameters["status"] == "successful") {
                        payerID = await uri.queryParameters["transaction_id"];
                        Get.back(result: payerID);
                      } else {
                        cartController.setOrderLoadingOff();
                        Get.back();
                        showToastMessage("${uri.queryParameters["status"]}");
                      }
                    }

                    return NavigationDecision.navigate;
                  },
                  gestureNavigationEnabled: true,
                  onWebViewCreated: (controller) {
                    _controller = controller;
                  },
                  onPageFinished: (finish) {
                    setState(() async {
                      isLoading = false;
                    });
                  },
                  onProgress: (val) {
                    progress = val;
                    setState(() {});
                  },
                ),
                isLoading
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              child: CircularProgressIndicator(
                                color: gradient.defoultColor,
                              ),
                            ),
                            SizedBox(height: Get.height * 0.02),
                            SizedBox(
                              width: Get.width * 0.80,
                              child: Text(
                                'Please don`t press back until the transaction is complete'
                                    .tr,
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.5),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Stack(),
              ],
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Get.back(),
          ),
          backgroundColor: Colors.black12,
          elevation: 0.0,
        ),
        body: Center(
          child: Container(
            child: CircularProgressIndicator(
              color: gradient.defoultColor,
            ),
          ),
        ),
      );
    }
  }
}
