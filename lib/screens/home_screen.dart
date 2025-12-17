import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_app/models/booking_model.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userName = "جاري التحميل ....";
  bool loading = true;
  List<BookingModel> bookings = [];

  // قائمة أسماء الأيام للتحويل
  final List<String> weekDaysAr = [
    '',
    'الاثنين',
    'الثلاثاء',
    'الأربعاء',
    'الخميس',
    'الجمعة',
    'السبت',
    'الأحد',
  ];

  @override
  void initState() {
    super.initState();
    initPage();
  }

  Future<void> initPage() async {
    await loadUser();
    await loadBookings();
    setState(() => loading = false);
  }

  // ---------------------- LOAD USER (HIVE) ----------------------
  Future<void> loadUser() async {
    var box = Hive.box("userBox");
    var currentEmail = box.get("currentUser");

    if (currentEmail == null) {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
      return;
    }

    var userData = box.get(currentEmail);
    if (userData != null && userData is Map) {
      if (mounted) {
        setState(() {
          userName = userData['name'] ?? "مستخدم";
        });
      }
    } else {
      if (mounted) {
        setState(() {
          userName = "زائر";
        });
      }
    }
  }

  // ---------------------- LOAD BOOKINGS (HIVE) ----------------------
  Future<void> loadBookings() async {
    if (!Hive.isBoxOpen("bookings")) return;
    var box = Hive.box<BookingModel>("bookings");
    bookings = box.values.toList();
  }

  // ---------------------- LOGOUT (HIVE) ----------------------
  Future<void> logout() async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("تأكيد"),
        content: const Text("هل تريد تسجيل الخروج؟"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("إلغاء"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFD700),
              foregroundColor: Colors.black,
            ),
            child: const Text("تأكيد"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      var box = Hive.box("userBox");
      await box.delete("currentUser");
      if (!mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFD4AF37),
        body: loading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.black),
              )
            : SafeArea(
                child: Center(
                  // 🚀 التعديل 1 و 2: ضبط العرض ليكون مثل صفحة البوكينق وجعل الصفحة كلها قابلة للسكرول
                  child: SingleChildScrollView(
                    child: ConstrainedBox(
                      // تحديد أقصى عرض بـ 420 ليكون مناسباً وشبيهاً بتطبيقات الجوال
                      constraints: const BoxConstraints(maxWidth: 420),
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          vertical: 24,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFD700),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            // ignore: deprecated_member_use
                            color: Colors.black.withOpacity(.15),
                            width: 3,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black45,
                              blurRadius: 18,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        // حذفنا Expanded لأننا داخل SingleChildScrollView
                        child: Column(
                          children: [
                            buildHero(),
                            buildHeader(),
                            buildWelcomeCard(),
                            buildCalendarCard(), // التقويم أصبح جزءاً من السكرول العام
                            const SizedBox(
                              height: 20,
                            ), // مساحة إضافية في الأسفل
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  // -----------------------------------------------------
  //                       HERO SECTION
  // -----------------------------------------------------
  Widget buildHero() {
    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              // إضافة انحناء للصورة من الأعلى لتناسب الكونتينر
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(17),
                topRight: Radius.circular(17),
              ),
              child: Image.asset(
                "assets/nov.jpeg",
                fit: BoxFit.cover,
                // ignore: deprecated_member_use
                color: Colors.black.withOpacity(0.45),
                colorBlendMode: BlendMode.darken,
              ),
            ),
          ),
          const Positioned(
            right: 16,
            bottom: 16,
            child: Text(
              "اختر نوع الموعد المناسب لحالتك الجمالية",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18, // تصغير الخط قليلاً ليناسب العرض
                fontWeight: FontWeight.w700,
                height: 1.1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // -----------------------------------------------------
  //                          HEADER
  // -----------------------------------------------------
  Widget buildHeader() {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.all(12),
      width: double.infinity,
      child: const Text(
        "الصفحة الرئيسية",
        style: TextStyle(
          color: Color(0xFFFFD700),
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  // -----------------------------------------------------
  //                       WELCOME CARD
  // -----------------------------------------------------
  Widget buildWelcomeCard() {
    return buildCard(
      Column(
        children: [
          const Text(
            "مرحباً بك",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          Text(
            userName,
            style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
          ),
          const SizedBox(height: 15),
          Wrap(
            spacing: 10,
            runSpacing: 10, // مسافة عمودية في حال نزول الأزرار لسطر جديد
            alignment: WrapAlignment.center,
            children: [
              GestureDetector(
                onTap: () async {
                  await Navigator.pushNamed(context, "/booking");
                  await initPage();
                },
                child: buttonStyle("حجز جديد"),
              ),
              buildButton("صفحتي", "/Profile"),
              GestureDetector(onTap: logout, child: buttonStyle("تسجيل خروج")),
            ],
          ),
        ],
      ),
    );
  }

  // -----------------------------------------------------
  //                       CALENDAR CARD
  // -----------------------------------------------------
  Widget buildCalendarCard() {
    return buildCard(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "تقويم الحجوزات",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          buildCalendarGrid(),
        ],
      ),
    );
  }

  // -----------------------------------------------------
  //                       CALENDAR GRID
  // -----------------------------------------------------
  Widget buildCalendarGrid() {
    DateTime today = DateTime.now();
    int year = today.year;
    int month = today.month;

    int firstDay = DateTime(year, month, 1).weekday;
    int daysInMonth = DateTime(year, month + 1, 0).day;

    List<Widget> items = [];

    // ضبط بداية الأسبوع (الأحد = 0 في اللوجيك الخاص بنا للعرض)
    int startDayIndex = firstDay == 7 ? 0 : firstDay;
    for (int i = 0; i < startDayIndex; i++) {
      // إزالة -1 لضبط المحاذاة بدقة
      items.add(const SizedBox());
    }

    for (int d = 1; d <= daysInMonth; d++) {
      String dateStr =
          "$year-${month.toString().padLeft(2, "0")}-${d.toString().padLeft(2, "0")}";

      // الحصول على اسم اليوم
      DateTime currentDate = DateTime(year, month, d);
      String dayName = weekDaysAr[currentDate.weekday]; // 1..7

      List<BookingModel> dayBookings = bookings
          .where((b) => b.date == dateStr)
          .toList();

      bool isToday = d == today.day;

      items.add(
        Container(
          // إزالة AnimatedContainer لتجنب مشاكل الأداء في القوائم الكبيرة
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: isToday ? const Color(0xFFFFF2A0) : Colors.white,
            border: Border.all(color: Colors.black, width: 1.5),
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 25,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 🚀 التعديل 3: إضافة اسم اليوم وتصغير الخطوط
              Text(
                dayName,
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "$d",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              if (dayBookings.isNotEmpty)
                ...dayBookings.map(
                  (b) => Container(
                    margin: const EdgeInsets.only(top: 2),
                    padding: const EdgeInsets.symmetric(
                      vertical: 2,
                      horizontal: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFD700),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      "${b.time} – ${b.serviceName}",
                      style: const TextStyle(
                        fontSize: 9,
                      ), // خط صغير جداً ليناسب المربع
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              else
                // عنصر فارغ لحفظ الشكل إذا لم يكن هناك حجز
                const SizedBox(height: 2),
            ],
          ),
        ),
      );
    }

    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount:
          4, // 🚀 التعديل: جعلناها 4 أعمدة بدلاً من 3 لتصغير المربعات
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      childAspectRatio:
          0.75, // نسبة الطول للعرض (جعل البطاقة أطول قليلاً لتسع البيانات)
      children: items,
    );
  }

  // -----------------------------------------------------
  //                         CARD STYLE
  // -----------------------------------------------------
  Widget buildCard(Widget child) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(12), // تقليل الهوامش
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        // ignore: deprecated_member_use
        border: Border.all(color: Colors.black.withOpacity(0.1)),
      ),
      child: child,
    );
  }

  // -----------------------------------------------------
  //                         BUTTON STYLE
  // -----------------------------------------------------
  Widget buildButton(String text, String route) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: buttonStyle(text),
    );
  }

  Widget buttonStyle(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFD700),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black, width: 2),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
