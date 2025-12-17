import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart'; 
// تأكد من استيراد الشاشات الأخرى بشكل صحيح:
import 'package:my_app/screens/home_screen.dart'; 
import 'package:my_app/screens/regester_screen.dart'; // افترضنا أن اسم الكلاس هو RegisterPage

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  
  // تعريف الألوان
  final gold = const Color(0xFFFFD700);
  final bg = const Color(0xFFD4AF37);


  // -------------------------------------------------------------
  // 🔥 دالة معالجة الدخول والتحقق (المنطق المصحح) 🔥
  // -------------------------------------------------------------
  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // نفتح الصندوق لضمان الجاهزية (حتى لو تم فتحه في main.dart، هذا آمن)
    final userBox = await Hive.openBox("userBox"); 
    final emailText = _email.text.trim();
    final passwordText = _password.text;

    // 1. التحقق مما إذا كان الإيميل موجوداً كمفتاح في الصندوق
    if (!userBox.containsKey(emailText)) {
        if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("هذا البريد الإلكتروني غير مسجل!"), backgroundColor: Colors.red),
            );
        }
        return; 
    }

    // 2. جلب بيانات المستخدم الكاملة (يجب أن تكون Map)
    final dynamic userData = userBox.get(emailText);
    
    // التحقق من نوع البيانات وكلمة المرور
    if (userData is Map) {
      final storedPassword = userData['password']; 

      if (storedPassword == passwordText) {
        // ✅ النجاح: حفظ الإيميل كـ "currentUser" للـ Session
        await userBox.put("currentUser", emailText);
        
        // 3. الانتقال إلى الصفحة الرئيسية
        if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("تم تسجيل الدخول بنجاح"), duration: Duration(seconds: 1), backgroundColor: Colors.green),
            );
            // يتم التوجيه للصفحة الرئيسية
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const HomePage()),
            );
        }
      } else {
        // 🛑 كلمة مرور خاطئة
        if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("كلمة المرور غير صحيحة!"), backgroundColor: Colors.red),
            );
        }
      }
    } else {
      // 🛑 خطأ: البيانات المحفوظة ليست بصيغة Map
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("خطأ في قراءة بيانات المستخدم."), backgroundColor: Colors.red),
        );
      }
    }
  }


  // -------------------------------------------------------------
  // دالة بناء الواجهة (Build Method)
  // -------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: bg,
        body: Center(
          child: LayoutBuilder(
            builder: (context, constraints) {
              double width = constraints.maxWidth < 500
                  ? constraints.maxWidth * 0.9
                  : 420;

              return SingleChildScrollView(
                child: Container(
                  width: width,
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: gold,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        // ignore: deprecated_member_use
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 25,
                      ),
                    ],
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: bg,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black, width: 2),
                      boxShadow: [
                        BoxShadow(
                          // ignore: deprecated_member_use
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 40,
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const Text(
                            "تسجيل الدخول",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 25),

                          // حقل البريد الإلكتروني
                          _inputField(
                            "البريد الإلكتروني",
                            controller: _email,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "الرجاء إدخال البريد الإلكتروني";
                              }
                              if (!value.contains("@") || !value.contains(".")) {
                                return "رجاءً أدخل بريد إلكتروني صالح";
                              }
                              return null;
                            },
                          ),

                          // حقل كلمة المرور
                          _inputField(
                            "كلمة المرور",
                            controller: _password,
                            isPassword: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "الرجاء إدخال كلمة المرور";
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 12),

                          // زر الدخول (الذي يستدعي دالة التحقق)
                          _mainButton(
                            "دخول",
                            onTap: () async {
                              if (_formKey.currentState!.validate()) {
                                await _handleLogin(); 
                              }
                            },
                          ),

                          const SizedBox(height: 20),

                          // رابط إنشاء حساب
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "ليس لديك حساب؟ ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  // التوجيه إلى صفحة التسجيل
                                  Navigator.of(context).push(
                                     MaterialPageRoute(builder: (_) => const Register()),
                                  );
                                },
                                child: Text(
                                  "إنشاء حساب",
                                  style: TextStyle(
                                      color: Colors.white, // لون مميز للرابط
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // -----------------------
  // INPUT FIELD Widget
  // -----------------------
  Widget _inputField(
    String hint, {
    bool isPassword = false,
    required TextEditingController controller,
    String? Function(String?)? validator,
  }) {
    // ... (كود حقل الإدخال كما هو) ...
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        validator: validator,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  // -----------------------
  // MAIN BUTTON Widget
  // -----------------------
  Widget _mainButton(String text, {required VoidCallback onTap}) {
    // ... (كود الزر الرئيسي كما هو) ...
    return SizedBox(
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          color: gold,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            // ignore: deprecated_member_use
            BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 8),
          ],
        ),
        child: TextButton(
          onPressed: onTap,
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
