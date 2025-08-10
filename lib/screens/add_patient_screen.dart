
import 'package:flutter/material.dart';
import 'package:my_app/services/database_service.dart';

class AddPatientScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  AddPatientScreen({super.key});

  void _savePatient(BuildContext context) {
    Map<String, String> newPatient = {
      'name': nameController.text,
      'phone': phoneController.text,
      'dob': dobController.text,
      'notes': notesController.text,
    };
    // حفظ المريض الجديد في قاعدة البيانات
    DatabaseService.patientsBox.add(newPatient);
    Navigator.pop(context); // العودة إلى الشاشة السابقة
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('إضافة مريض')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'اسم المريض'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(labelText: 'رقم الهاتف'),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 10),
              TextField(
                controller: dobController,
                decoration: InputDecoration(labelText: 'تاريخ الميلاد'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: notesController,
                decoration: InputDecoration(labelText: 'ملاحظات طبية'),
                maxLines: 3,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _savePatient(context),
                child: Text('حفظ المريض'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
