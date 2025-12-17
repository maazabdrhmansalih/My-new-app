import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:my_app/models/booking_model.dart';
import 'package:my_app/screens/login_screen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? user;
  List<BookingModel> bookings = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  Future<void> _loadAll() async {
    final userBox = Hive.box("userBox");
    final bookingBox = Hive.box<BookingModel>("bookings");

    final currentEmail = userBox.get("currentUser");

    if (currentEmail == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
      return;
    }

    user = Map<String, dynamic>.from(userBox.get(currentEmail));
    user!["email"] = currentEmail;

    bookings = bookingBox.values
        .where((b) => b.userId == currentEmail)
        .toList();

    setState(() => loading = false);
  }

  Future<void> _cancelBooking(String id) async {
    final bookingBox = Hive.box<BookingModel>("bookings");

    final key = bookingBox.keys.firstWhere((k) => bookingBox.get(k)!.id == id);

    await bookingBox.delete(key);
    await _loadAll();
  }

  @override
  Widget build(BuildContext context) {
    if (loading || user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
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
                          buildUserCard(),
                          buildBookingsCard(),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                icon: const Icon(
                                  Icons.home,
                                  color: Color(0xFFFFD700),
                                ),
                                label: const Text(
                                  "الصفحة الرئيسية",
                                  style: TextStyle(
                                    color: Color(0xFFFFD700),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --------------------------------------------------
  // HERO
  // --------------------------------------------------
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
              "ملفي الشخصي",
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

  // --------------------------------------------------
  // HEADER
  // --------------------------------------------------
  Widget buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      color: Colors.black,
      child: const Text(
        "معلومات الحساب",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Color(0xFFFFD700),
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // --------------------------------------------------
  // USER CARD
  // --------------------------------------------------
  Widget buildUserCard() {
    return buildCard(
      Column(
        children: [
          const Icon(Icons.person, size: 60),
          const SizedBox(height: 10),
          Text(
            user!["name"],
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(user!["email"], style: TextStyle(color: Colors.grey.shade700)),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // BOOKINGS CARD
  // --------------------------------------------------
  Widget buildBookingsCard() {
    return buildCard(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "حجوزاتي",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          if (bookings.isEmpty)
            const Text("لا توجد حجوزات حالياً")
          else
            ...bookings.map(buildBookingItem),
        ],
      ),
    );
  }

  Widget buildBookingItem(BookingModel b) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF2A0),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            b.serviceName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text("📅 ${b.date}"),
          Text("⏰ ${b.time}"),
          Text("👩‍🎨 ${b.staffName}"),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () => _cancelBooking(b.id),
              icon: const Icon(Icons.delete, color: Colors.red),
              label: const Text(
                "إلغاء الحجز",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // CARD STYLE
  // --------------------------------------------------
  Widget buildCard(Widget child) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }
}
