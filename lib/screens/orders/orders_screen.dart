import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/constants/app_colors.dart';
import '../projects/create_project_screen.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {

  // الدالة التي طلبت دمجها
  void _openServiceSelection(BuildContext context, String projectId) async {
    final servicesSnapshot = await FirebaseFirestore.instance.collection('services').get();
    List<Map<String, dynamic>> selectedServices = [];
    double totalPrice = 0.0;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, setDialogState) {
        return AlertDialog(
          title: const Text("اختر ميزات مشروعك"),
          content: SizedBox(
            width: 300,
            height: 400,
            child: ListView(
              children: servicesSnapshot.docs.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                final serviceName = data['name'];
                final servicePrice = (data['price'] as num).toDouble();
                final isSelected = selectedServices.any((s) => s['name'] == serviceName);

                return CheckboxListTile(
                  title: Text(serviceName),
                  subtitle: Text("\$$servicePrice"),
                  value: isSelected,
                  onChanged: (val) {
                    setDialogState(() {
                      if (val == true) {
                        selectedServices.add({'name': serviceName, 'price': servicePrice});
                        totalPrice += servicePrice;
                      } else {
                        selectedServices.removeWhere((s) => s['name'] == serviceName);
                        totalPrice -= servicePrice;
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("الإجمالي: \$$totalPrice", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ),
            ElevatedButton(
              onPressed: () async {
                await FirebaseFirestore.instance.collection('projects').doc(projectId).update({
                  'selectedServices': selectedServices,
                  'finalPrice': totalPrice,
                  'status': 'Payment_Pending',
                });
                if (context.mounted) Navigator.pop(context);
              },
              child: const Text("تأكيد الطلب"),
            ),
          ],
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: const Text("My Projects"), actions: [
        IconButton(icon: const Icon(Icons.add), onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateProjectScreen()));
          setState(() {});
        }),
      ]),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('projects')
              .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
            final projects = snapshot.data!.docs;
            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                ...projects.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  // التعديل هنا: جعل الكارد قابلاً للضغط
                  return GestureDetector(
                    onTap: () => _openServiceSelection(context, doc.id),
                    child: _projectCard(
                      context: context,
                      title: data['title'] ?? '',
                      status: data['status'] ?? 'Open',
                      progress: 0.25,
                      progressText: "Project Created",
                      color: Colors.blue,
                      team: "Client",
                      delivery: "\$${data['budget'] ?? '0'}",
                    ),
                  );
                }).toList(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _projectCard({required BuildContext context, required String title, required String status, required double progress, required String progressText, required Color color, required String team, required String delivery}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 22),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(30), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20)]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [Expanded(child: Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold))), Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8), decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(20)), child: Text(status, style: TextStyle(color: color, fontWeight: FontWeight.bold)))]),
          const SizedBox(height: 25),
          LinearProgressIndicator(value: progress, minHeight: 12, backgroundColor: Colors.grey.shade300, color: color),
          const SizedBox(height: 12),
          Text(progressText),
        ],
      ),
    );
  }
}