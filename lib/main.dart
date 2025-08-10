import 'package:flutter/material.dart';
import 'package:my_app/services/database_service.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/add_patient_screen.dart';
import 'screens/add_appointment_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/view_patients_screen.dart';
import 'screens/view_appointments_screen.dart';
import 'screens/patient_details_screen.dart';
import 'screens/appointment_details_screen.dart';

Future<void> main() async {
  // تهيئة Flutter
  WidgetsFlutterBinding.ensureInitialized();
  // تهيئة Hive
  await DatabaseService.init();

  runApp(DentalClinicApp());
}

class DentalClinicApp extends StatelessWidget {
  const DentalClinicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'عيادة الأسنان',
      theme: ThemeData(primarySwatch: Colors.teal),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      
      routes: {
        '/': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
        '/add-patient': (context) => AddPatientScreen(),
        '/add-appointment': (context) => AddAppointmentScreen(),
        '/settings': (context) => SettingsScreen(),
        '/view-patients': (context) => ViewPatientsScreen(),
        '/view-appointments': (context) => ViewAppointmentsScreen(),
        '/patient-details': (context) => PatientDetailsScreen(),
        '/appointment-details': (context) => AppointmentDetailsScreen(),
      },
    );
  }
}
