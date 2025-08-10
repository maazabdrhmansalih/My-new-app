
import 'package:flutter/material.dart';

class AppointmentDetailsScreen extends StatelessWidget {
  const AppointmentDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appointment = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    return Scaffold(
      appBar: AppBar(
        title: Text('تفاصيل الموعد'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('المريض: ${appointment['patient']}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('التاريخ: ${appointment['date']}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('الوقت: ${appointment['time']}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('ملاحظات: ${appointment['notes']}', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
