import 'package:hive/hive.dart';

// 🚀 التعديل الأول والضروري: ربط هذا الملف بملف الكود المُولَّد
part 'booking_model.g.dart';

// تأكد من أن TypeId فريد (يبدو أنك استخدمت 1، وهو جيد)
@HiveType(typeId: 1)
class BookingModel extends HiveObject {
  // 💡 يفضل جعل الحقول النهائية (final) بعد البناء
  @HiveField(0)
  late final String id;

  @HiveField(1)
  late final String userId;

  @HiveField(2)
  late final String userName;

  @HiveField(3)
  late final String staffId;

  @HiveField(4)
  final String staffName;

  @HiveField(5)
  late final String serviceId;

  @HiveField(6)
  late final String serviceName;

  @HiveField(7)
  late final String date;

  @HiveField(8)
  late final String time;

  @HiveField(9)
  late final int duration;

  @HiveField(10)
  late final String status;

  BookingModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.staffId,
    required this.staffName,
    required this.serviceId,
    required this.serviceName,
    required this.date,
    required this.time,
    required this.duration,
    required this.status,
  });
}
