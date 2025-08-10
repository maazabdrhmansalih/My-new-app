
// import 'package:flutter/material.dart';

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('الصفحة الرئيسية'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             ElevatedButton(
//               onPressed: () => Navigator.pushNamed(context, '/add-patient'),
//               child: Text('إضافة مريض'),
//             ),
//             SizedBox(height: 10),
//             ElevatedButton(
//               onPressed: () => Navigator.pushNamed(context, '/add-appointment'),
//               child: Text('إضافة موعد'),
//             ),
//             SizedBox(height: 10),
//             ElevatedButton(
//               onPressed: () => Navigator.pushNamed(context, '/view-patients'),
//               child: Text('عرض المرضى'),
//             ),
//             SizedBox(height: 10),
//             ElevatedButton(
//               onPressed: () => Navigator.pushNamed(context, '/view-appointments'),
//               child: Text('عرض المواعيد'),
//             ),
//             SizedBox(height: 10),
//             ElevatedButton(
//               onPressed: () => Navigator.pushNamed(context, '/settings'),
//               child: Text('الإعدادات'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }





import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
   const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الرئيسية'),
        centerTitle: true,
        // إضافة زر تسجيل الخروج
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // توجيه المستخدم إلى شاشة تسجيل الدخول وإزالة الصفحة الحالية من الذاكرة
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildGridItem(context, 'إضافة مريض', Icons.person_add, '/add-patient'),
            _buildGridItem(context, 'إضافة موعد', Icons.calendar_today, '/add-appointment'),
            _buildGridItem(context, 'عرض المرضى', Icons.group, '/view-patients'),
            _buildGridItem(context, 'عرض المواعيد', Icons.event, '/view-appointments'),
            _buildGridItem(context, 'الاعدادات', Icons.settings, '/settings'),
          ],
        ),
      ),
    );
  }

  Widget _buildGridItem(
      BuildContext context, String title, IconData icon, String route) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, route);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Theme.of(context).primaryColor),
            SizedBox(height: 8),
            Text(title, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
