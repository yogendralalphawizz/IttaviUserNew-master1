// ignore_for_file: non_constant_identifier_names

import 'package:get_storage/get_storage.dart';

final getData = GetStorage();
save(Key, val) {
  final data = GetStorage();
  data.write(Key, val);
}
