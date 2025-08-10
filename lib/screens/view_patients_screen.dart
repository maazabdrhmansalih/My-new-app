

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_app/services/database_service.dart';

class ViewPatientsScreen extends StatelessWidget {
  const ViewPatientsScreen({super.key});

  // دالة لتعديل المريض
  void _editPatient(BuildContext context, int index, Map<String, dynamic> patient) {
    // يمكنك فتح شاشة تعديل أو حوار هنا
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController nameController =
            TextEditingController(text: patient['name']);
        final TextEditingController phoneController =
            TextEditingController(text: patient['phone']);
        return AlertDialog(
          title: Text('تعديل المريض'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'الاسم'),
              ),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(labelText: 'رقم الهاتف'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                Map<String, String> updatedPatient = {
                  'name': nameController.text,
                  'phone': phoneController.text,
                  'dob': patient['dob'],
                  'notes': patient['notes'],
                };
                DatabaseService.patientsBox.putAt(index, updatedPatient);
                Navigator.pop(context);
              },
              child: Text('حفظ'),
            ),
          ],
        );
      },
    );
  }

  // دالة لحذف المريض
  void _deletePatient(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('حذف مريض'),
          content: Text('هل أنت متأكد من حذف هذا المريض؟'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                DatabaseService.patientsBox.deleteAt(index);
                Navigator.pop(context);
              },
              child: Text('حذف'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('قائمة المرضى')),
      body: ValueListenableBuilder(
        valueListenable: DatabaseService.patientsBox.listenable(),
        builder: (context, box, _) {
          if (box.isEmpty) {
            return Center(child: Text('لا يوجد مرضى حاليًا.'));
          }
          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final patient = box.getAt(index);
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(patient['name']!),
                  subtitle: Text(patient['phone']!),
                  onTap: () {
                    Navigator.pushNamed(context, '/patient-details', arguments: patient);
                  },
                  onLongPress: () => _deletePatient(context, index),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => _editPatient(context, index, patient),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add-patient');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
