import 'dart:async';
import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  double _opacity = 0;
  double _scale = 0.85;

  @override
  void initState() {
    super.initState();

    // تشغيل الأنيميشن
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        _opacity = 1;
        _scale = 1;
      });
    });

    // الانتقال بعد 4 ثواني
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, "/login");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD4AF37), // ذهبي
      body: Center(
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 1800),
          opacity: _opacity,
          curve: Curves.easeInOut,
          child: AnimatedScale(
            duration: const Duration(milliseconds: 1800),
            scale: _scale,
            curve: Curves.easeInOut,
            child: Container(
              width: 420,
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: const Color(0xFFFFD700),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    // ignore: deprecated_member_use
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 25,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // الصورة
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          // ignore: deprecated_member_use
                          color: Colors.black.withOpacity(0.7),
                          blurRadius: 15,
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        "assets/images/maaz.jpg", // ضع الصورة داخل مجلد assets
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "مرحباً بكم في صالون التجميل",
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.black,
                      fontFamily: "Tajawal",
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "احجزي موعدك الآن وتمتعي بتجربة فاخرة.",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black87,
                      fontFamily: "Tajawal",
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
