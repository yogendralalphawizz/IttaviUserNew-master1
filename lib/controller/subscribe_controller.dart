// ignore_for_file: unused_field, prefer_final_fields, avoid_print, unnecessary_brace_in_string_interps, prefer_interpolation_to_compose_strings

import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:table_calendar/table_calendar.dart';

class SubScibeController extends GetxController implements GetxService {
  bool isLoading = false;

  List<String> selectedIndexes = [];

  String selectDate = "";

  int? currentIndex;
  String deliveries = "";
  String selectTime = "";

  String selectDay = "";
  String selectMonth = "";
  String selectYear = "";

  String editDate = "";

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime focusedDay = DateTime.now();
  DateTime? selectedDay;

  List<String> day = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
  ];

  addAndRemovedays(index) {
    if (selectedIndexes.contains(day[index])) {
      selectedIndexes.remove(day[index]);
      update();
    } else {
      selectedIndexes.add(day[index]);
      update();
    }
  }

  dailySelection() {
    selectedIndexes = [];
    for (var i = 0; i < day.length; i++) {
      selectedIndexes.add(day[i]);
    }
    update();
  }

  weekdaysSelection() {
    selectedIndexes = [];
    for (var i = 0; i < 5; i++) {
      selectedIndexes.add(day[i]);
    }
    update();
  }

  weekendsSelection() {
    selectedIndexes = [];
    for (var i = 0; i < day.length; i++) {
      if (day[i] == "Saturday" || day[i] == "Sunday") {
        selectedIndexes.add(day[i]);
      }
    }
    update();
  }

  changeIndex(index, title) {
    currentIndex = index;
    deliveries = title;
    update();
  }

  changeIndexWiseValue({String? time}) {
    selectTime = time ?? "";
    update();
  }

  getDate({String? day1, month1, year1, selectdate1}) {
    selectDay = day1 ?? "";
    selectMonth = month1;
    selectYear = year1;
    selectDate = selectdate1;
    editDate = "${selectDay}-${selectMonth}-${selectYear}";
    update();
  }

  getSelectedItemEditValue({
    List<String>? selectDay1,
    String? selectDeliveris1,
    selectTime1,
    selectDate1,
  }) {
    print("----------(selectDay1)------->>" + selectDay1.toString());
    print(
        "----------(selectDeliveris1)------->>" + selectDeliveris1.toString());
    print("----------(selectTime1)------->>" + selectTime1.toString());
    print("----------(selectDate1)------->>" + selectDate1.toString());
    selectedIndexes = [];
    selectedIndexes = selectDay1 ?? [];
    deliveries = selectDeliveris1 ?? "";
    editDate = selectDate1;
    selectTime = selectTime1;
    update();
  }
}
