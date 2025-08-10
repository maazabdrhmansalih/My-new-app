import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_app/services/database_service.dart';

class ViewAppointmentsScreen extends StatelessWidget {
  const ViewAppointmentsScreen({super.key});

  // دالة لتعديل الموعد
  void _editAppointment(
    BuildContext context,
    int index,
    Map<String, dynamic> appointment,
  ) {
    // يمكنك فتح شاشة تعديل أو حوار هنا
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController patientController = TextEditingController(
          text: appointment['patient'],
        );
        final TextEditingController dateController = TextEditingController(
          text: appointment['date'],
        );
        return AlertDialog(
          title: Text('تعديل موعد'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: patientController,
                decoration: InputDecoration(labelText: 'اسم المريض'),
              ),
              TextField(
                controller: dateController,
                decoration: InputDecoration(labelText: 'التاريخ'),
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
                Map<String, String> updatedAppointment = {
                  'patient': patientController.text,
                  'date': dateController.text,
                  'time': appointment['time'],
                  'notes': appointment['notes'],
                };
                DatabaseService.appointmentsBox.putAt(
                  index,
                  updatedAppointment,
                );
                Navigator.pop(context);
              },
              child: Text('حفظ'),
            ),
          ],
        );
      },
    );
  }

  // دالة لحذف الموعد
  void _deleteAppointment(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('حذف موعد'),
          content: Text('هل أنت متأكد من حذف هذا الموعد؟'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                DatabaseService.appointmentsBox.deleteAt(index);
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
      appBar: AppBar(title: Text('قائمة المواعيد')),
      body: ValueListenableBuilder(
        valueListenable: DatabaseService.appointmentsBox.listenable(),
        builder: (context, box, _) {
          if (box.isEmpty) {
            return Center(child: Text('لا يوجد مواعيد حاليًا.'));
          }
          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final appointment = box.getAt(index);
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(appointment['patient']!),
                  subtitle: Text(
                    '${appointment['date']} - ${appointment['time']}',
                  ),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/appointment-details',
                      arguments: appointment,
                    );
                  },
                  onLongPress: () => _deleteAppointment(context, index),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () =>
                        _editAppointment(context, index, appointment),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add-appointment');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
