// ignore_for_file: prefer_const_constructors, prefer_if_null_operators, sort_child_properties_last, prefer_interpolation_to_compose_strings, avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:milkman/Api/data_store.dart';
import 'package:milkman/model/fontfamily_model.dart';
import 'package:milkman/utils/Colors.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  int? _value = 0;
  int currentIndex = 0;

  final List locale = [
    {'name': 'ENGLISH', 'locale': const Locale('en', 'US')},
    {'name': 'عربى', 'locale': const Locale('ar', 'IN')},
    {'name': 'हिंदी', 'locale': const Locale('hi', 'IN')},
    {'name': 'Spanish', 'locale': const Locale('es', 'ES')},
    {'name': 'France', 'locale': const Locale('fr', 'ES')},
    {'name': 'Germany', 'locale': const Locale('de', 'ES')},
    {'name': 'Indonesia', 'locale': const Locale('in', 'ES')},
    // **********************************************************
    {'name': 'South Africa', 'locale': const Locale('ZA', 'ES')},
    {'name': 'Turkish', 'locale': const Locale('tr', 'ES')},
    {'name': 'Portuguese', 'locale': const Locale('pt', 'ES')},
  ];
  updateLanguage(Locale locale) {
    Get.back();
    save("lan1", locale.countryCode);
    save("lan2", locale.languageCode);
    Get.updateLocale(locale);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      appBar: AppBar(
        backgroundColor: WhiteColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back,
            color: BlackColor,
          ),
        ),
        title: Text(
          "Language".tr,
          style: TextStyle(
            fontSize: 17,
            fontFamily: FontFamily.gilroyBold,
            color: BlackColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: SizedBox(
          height: Get.size.height,
          width: Get.size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15, top: 10),
                child: Text(
                  "Suggested".tr,
                  style: TextStyle(
                    fontSize: 17,
                    fontFamily: FontFamily.gilroyBold,
                  ),
                ),
              ),
              SizedBox(
                height: 4,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: locale.length,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _value = index;
                          save("lanValue", _value);
                          updateLanguage(locale[index]['locale']);
                          // save("lCode", locale[index]['locale']);
                        });
                      },
                      child: languageWidget(
                        name: locale[index]['name'],
                        value: index,
                        radio: Radio(
                          value: index,
                          groupValue: getData.read("lanValue") != null
                              ? getData.read("lanValue")
                              : _value,
                          hoverColor: gradient.defoultColor,
                          onChanged: (value4) {
                            setState(() {});
                          },
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget languageWidget(
      {String? name, int? value, void Function(int?)? onChanged, radio}) {
    return Container(
      height: 50,
      margin: EdgeInsets.all(6),
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.only(left: 15),
        child: Row(
          children: [
            Text(
              name ?? "",
              style: TextStyle(
                fontFamily: FontFamily.gilroyMedium,
                fontSize: 16,
                color: BlackColor,
              ),
            ),
            Spacer(),
            radio,
            SizedBox(
              width: 10,
            ),
          ],
        ),
      ),
      decoration: BoxDecoration(
        color: WhiteColor,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
