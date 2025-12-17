// ignore_for_file: await_only_futures

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _birthDate = TextEditingController();

  DateTime? selectedDate;

  Future<void> _selectBirthDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        _birthDate.text = "${picked.year}/${picked.month}/${picked.day}";
      });
    }
  }

  // دالة التسجيل والحفظ والتوجيه
  Future<void> _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      var userBox = await Hive.box('userBox');
      final email = _email.text.trim();

      if (userBox.containsKey(email)) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("هذا البريد الإلكتروني مسجل بالفعل!")),
          );
        }
        return;
      }
      //حفظ البيانات في hive
      await userBox.put(email, {
        'name': _name.text,
        'password': _password.text,
        'birthDay': _birthDate.text,
      });
      if (!mounted) return;
      //اظهار رسالة النجاح في التسجيل
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("تم التسجيل بنجاح ،الان يمكنك تسجيل الدخول"),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      await Future.delayed(const Duration(seconds: 1));

      if (!mounted) return;

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // أبعاد الشاشة

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFD4AF37),
        body: Center(
          child: LayoutBuilder(
            builder: (context, constraints) {
              // العرض المتجاوب للجوال
              double containerWidth = constraints.maxWidth < 500
                  ? constraints.maxWidth * 0.9
                  : 420;

              return SingleChildScrollView(
                child: Center(
                  child: Container(
                    width: containerWidth,
                    padding: const EdgeInsets.all(30),
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
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD4AF37),
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
                              "إنشاء حساب",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),

                            _inputField(
                              "الاسم الكامل",
                              controller: _name,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "الرجاء إدخال الاسم";
                                }
                                return null;
                              },
                            ),

                            _inputField(
                              "البريد الإلكتروني",
                              controller: _email,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "الرجاء إدخال البريد";
                                }
                                if (!value.contains("@") ||
                                    !value.contains(".")) {
                                  return "رجاءً أدخل بريد إلكتروني صالح";
                                }
                                return null;
                              },
                            ),

                            _inputField(
                              "كلمة المرور",
                              controller: _password,
                              isPassword: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "الرجاء إدخال كلمة المرور";
                                }
                                if (value.length < 6) {
                                  return "كلمة المرور يجب أن تكون 6 أحرف على الأقل";
                                }
                                return null;
                              },
                            ),

                            GestureDetector(
                              onTap: () => _selectBirthDate(context),
                              child: AbsorbPointer(
                                child: _inputField(
                                  "تاريخ الميلاد",
                                  controller: _birthDate,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "الرجاء اختيار تاريخ الميلاد";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),

                            const SizedBox(height: 10),

                            _mainButton(
                              "تسجيل",
                              onTap: () async {
                                await _handleRegister();
                              },
                            ),
                            const SizedBox(height: 10),
                            _outlineButton(
                              "العودة",
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
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

  // ------------------------------------
  // INPUT FIELD
  // ------------------------------------
  Widget _inputField(
    String hint, {
    bool isPassword = false,
    TextEditingController? controller,
    String? Function(String?)? validator,
  }) {
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

  // ------------------------------------
  // MAIN BUTTON
  // ------------------------------------
  Widget _mainButton(String text, {required VoidCallback onTap}) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFFD700),
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
            style: const TextStyle(color: Colors.black, fontSize: 16),
          ),
        ),
      ),
    );
  }

  // ------------------------------------
  // OUTLINE BUTTON
  // ------------------------------------
  Widget _outlineButton(String text, {required VoidCallback onTap}) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.black, width: 2),
          backgroundColor: Colors.white,
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
    );
  }
}
