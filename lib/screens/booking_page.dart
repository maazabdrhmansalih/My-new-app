import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:my_app/models/booking_model.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  String? selectedStaff;
  String? selectedService;
  DateTime? selectedDate;
  String? selectedSlot;

  late Box<BookingModel> bookingBox;
  late Box userBox;

  final staffList = [
    {"id": "st1", "name": "ليلى"},
    {"id": "st2", "name": "مريم"},
    {"id": "st3", "name": "هدى"},
  ];

  final services = [
    {"id": "sv1", "name": "تصفيف الشعر", "duration": 60},
    {"id": "sv2", "name": "تلوين جزئي", "duration": 90},
    {"id": "sv3", "name": "مانيكير", "duration": 45},
  ];

  List<Map<String, dynamic>> timeSlots = [];

  @override
  void initState() {
    super.initState();
    bookingBox = Hive.box<BookingModel>("bookings");
    userBox = Hive.box("userBox");

    selectedStaff = staffList.first["id"];
    selectedService = services.first["id"] as String?;
  }

  // ---------------- LOGIC (بدون تغيير) ----------------
  void generateTimeSlots() {
    timeSlots.clear();

    for (int h = 9; h < 18; h++) {
      timeSlots.add({
        "time": "${h.toString().padLeft(2, '0')}:00",
        "busy": false,
      });
      timeSlots.add({
        "time": "${h.toString().padLeft(2, '0')}:30",
        "busy": false,
      });
    }

    if (selectedDate != null) {
      String dateStr = DateFormat("yyyy-MM-dd").format(selectedDate!);
      final booked = bookingBox.values.where(
        (b) => b.date == dateStr && b.staffId == selectedStaff,
      );

      for (var slot in timeSlots) {
        if (booked.any((b) => b.time == slot["time"])) {
          slot["busy"] = true;
        }
      }
    }
    setState(() {});
  }

  void confirmBooking() {
    if (selectedDate == null || selectedSlot == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("اختر التاريخ والوقت")));
      return;
    }

    final currentEmail = userBox.get("currentUser");
    final userData = userBox.get(currentEmail);

    final service = services.firstWhere((s) => s["id"] == selectedService);

    final booking = BookingModel(
      id: "bk${DateTime.now().millisecondsSinceEpoch}",
      userId: currentEmail,
      userName: userData?["name"] ?? "زبونة",
      staffId: selectedStaff!,
      staffName: staffList.firstWhere(
        (s) => s["id"] == selectedStaff!,
      )["name"]!,
      serviceId: selectedService!,
      serviceName: service["name"].toString(),
      date: DateFormat("yyyy-MM-dd").format(selectedDate!),
      time: selectedSlot!,
      duration: service["duration"] as int,
      status: "confirmed",
    );

    bookingBox.add(booking);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("تم الحجز بنجاح")));

    Navigator.pop(context);
  }
  

  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD4AF37),
      body: SafeArea(
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * .95,
            margin: const EdgeInsets.symmetric(vertical: 15),
            decoration: BoxDecoration(
              color: const Color(0xFFFFD700),
              borderRadius: BorderRadius.circular(16),
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
            child: Column(
              children: [
                buildHero(),
                buildHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        buildCard(buildSelectors()),
                        buildCard(buildDatePicker()),
                        buildCard(buildTimeSlots()),
                        const SizedBox(height: 10),
                        buildConfirmButton(),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildHero() {
    return SizedBox(
      height: 180,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/nov.jpeg",
              fit: BoxFit.cover,
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(.45),
              colorBlendMode: BlendMode.darken,
            ),
          ),
          const Positioned(
            right: 16,
            bottom: 16,
            child: Text(
              "احجزي موعدك بكل سهولة",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      color: Colors.black,
      child: const Text(
        "صفحة الحجز",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Color(0xFFFFD700),
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget buildCard(Widget child) {
    return Container(
      margin: const EdgeInsets.all(15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }

  Widget buildSelectors() {
    return Column(
      children: [
        DropdownButtonFormField(
          value: selectedStaff,
          decoration: const InputDecoration(labelText: "اختيار الموظفة"),
          items: staffList
              .map(
                (s) =>
                    DropdownMenuItem(value: s["id"], child: Text(s["name"]!)),
              )
              .toList(),
          onChanged: (v) {
            selectedStaff = v.toString();
            selectedSlot = null;
            generateTimeSlots();
          },
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField(
          value: selectedService,
          decoration: const InputDecoration(labelText: "نوع الخدمة"),
          items: services
              .map(
                (s) => DropdownMenuItem(
                  value: s["id"],
                  child: Text(s["name"].toString()),
                ),
              )
              .toList(),
          onChanged: (v) => setState(() => selectedService = v.toString()),
        ),
      ],
    );
  }

  Widget buildDatePicker() {
    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (picked != null) {
          selectedDate = picked;
          selectedSlot = null;
          generateTimeSlots();
        }
      },
      child: Row(
        children: [
          const Icon(Icons.calendar_month),
          const SizedBox(width: 10),
          Text(
            selectedDate == null
                ? "اختيار التاريخ"
                : DateFormat("yyyy-MM-dd").format(selectedDate!),
          ),
        ],
      ),
    );
  }

  Widget buildTimeSlots() {
    return Wrap(
      children: timeSlots.map((s) {
        final busy = s["busy"];
        final time = s["time"];
        final selected = selectedSlot == time;

        return GestureDetector(
          onTap: busy ? null : () => setState(() => selectedSlot = time),
          child: Container(
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
            decoration: BoxDecoration(
              color: busy
                  ? Colors.red.shade200
                  : selected
                  ? const Color(0xFFFFD700)
                  : Colors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.black12),
            ),
            child: Text(time),
          ),
        );
      }).toList(),
    );
  }

  Widget buildConfirmButton() {
    return ElevatedButton(
      onPressed: confirmBooking,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
      ),
      child: const Text(
        "تأكيد الحجز",
        style: TextStyle(color: Color(0xFFFFD700), fontSize: 16),
      ),
    );
  }
}
