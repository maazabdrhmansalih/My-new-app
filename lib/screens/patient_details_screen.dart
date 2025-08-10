
import 'package:flutter/material.dart';

class PatientDetailsScreen extends StatelessWidget {
  const PatientDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final patient = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    return Scaffold(
      appBar: AppBar(
        title: Text('تفاصيل المريض'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('الاسم: ${patient['name']}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('رقم الهاتف: ${patient['phone']}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('تاريخ الميلاد: ${patient['dob']}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('ملاحظات: ${patient['notes']}', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}

