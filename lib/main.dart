import 'package:flutter/material.dart';
import 'package:my_app/screens/booking_page.dart';
import 'package:my_app/screens/profile.dart';
import 'package:my_app/screens/regester_screen.dart';
import 'package:my_app/screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:my_app/models/booking_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(BookingModelAdapter());
  // افتح الصناديق
  await Hive.openBox<BookingModel>('Bookings');
  await Hive.openBox('userBox');

  runApp(const DentalClinicApp());
}

class DentalClinicApp extends StatelessWidget {
  const DentalClinicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'الحجز في صالون التجميل نوفا',
      // اتجاه التطبيق rtl
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar', 'AE'), // اللغة العربية
      ],
      locale: const Locale('ar', 'AE'), // إجبار التطبيق على استخدام العربية

      theme: ThemeData(fontFamily: 'Tajawal-Regular'),

      debugShowCheckedModeBanner: false,
      initialRoute: '/',

      routes: {
        '/': (context) => WelcomePage(),
        '/home': (context) => HomePage(),
        '/login': (context) => LoginPage(),
        '/Register': (context) => Register(),
        '/booking': (context) => BookingPage(),
        '/Profile': (context) => ProfilePage(),
      },
    );
  }
}
