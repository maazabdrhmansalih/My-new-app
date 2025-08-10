
import 'package:flutter/material.dart';
import 'package:my_app/services/database_service.dart';

class AddAppointmentScreen extends StatefulWidget {
  const AddAppointmentScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddAppointmentScreenState createState() => _AddAppointmentScreenState();
}

class _AddAppointmentScreenState extends State<AddAppointmentScreen> {
  final TextEditingController patientController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  void _saveAppointment() {
    Map<String, String> newAppointment = {
      'patient': patientController.text,
      'date': dateController.text,
      'time': timeController.text,
      'notes': notesController.text,
    };
    // حفظ الموعد الجديد في قاعدة البيانات
    DatabaseService.appointmentsBox.add(newAppointment);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('إضافة موعد')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: patientController,
                decoration: InputDecoration(labelText: 'اسم المريض'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: dateController,
                decoration: InputDecoration(labelText: 'التاريخ'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: timeController,
                decoration: InputDecoration(labelText: 'الوقت'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: notesController,
                decoration: InputDecoration(labelText: 'ملاحظات الموعد'),
                maxLines: 3,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveAppointment,
                child: Text('حفظ الموعد'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

