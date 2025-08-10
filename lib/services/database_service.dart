import 'package:hive_flutter/hive_flutter.dart';

class DatabaseService {
  static late Box patientsBox;
  static late Box appointmentsBox;

  static Future<void> init() async {
    await Hive.initFlutter();
    patientsBox = await Hive.openBox('patients');
    appointmentsBox = await Hive.openBox('appointments');
  }
}
