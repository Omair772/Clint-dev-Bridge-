import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateProjectScreen extends StatefulWidget {
  const CreateProjectScreen({super.key});

  @override
  State<CreateProjectScreen> createState() =>
      _CreateProjectScreenState();
}

class _CreateProjectScreenState
    extends State<CreateProjectScreen> {

  final titleController =
  TextEditingController();

  final descriptionController =
  TextEditingController();

  final budgetController =
  TextEditingController();

  bool isLoading = false;

  Future<void> createProject() async {

    try {

      setState(() {
        isLoading = true;
      });

      final user =
          FirebaseAuth.instance.currentUser;

      if (user == null) return;

      await FirebaseFirestore.instance
          .collection('projects')
          .add({

        'title':
        titleController.text.trim(),

        'description':
        descriptionController.text.trim(),

        'budget':
        double.tryParse(
          budgetController.text,
        ) ??
            0,

        'status':
        'Open',

        'userId':
        user.uid,

        'createdAt':
        DateTime.now()
            .toIso8601String(),
      });

      if (!mounted) return;

      Navigator.pop(context, true);

    } catch (e) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    } finally {

      if (mounted) {

        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          'Create Project',
        ),
      ),

      body: SingleChildScrollView(

        padding:
        const EdgeInsets.all(20),

        child: Column(

          children: [

            TextField(
              controller:
              titleController,
              decoration:
              const InputDecoration(
                labelText:
                'Project Title',
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            TextField(
              controller:
              descriptionController,
              maxLines: 4,
              decoration:
              const InputDecoration(
                labelText:
                'Description',
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            TextField(
              controller:
              budgetController,
              keyboardType:
              TextInputType.number,
              decoration:
              const InputDecoration(
                labelText:
                'Budget (\$)',
              ),
            ),

            const SizedBox(
              height: 30,
            ),

            SizedBox(

              width:
              double.infinity,

              height: 55,

              child:
              ElevatedButton(

                onPressed:
                isLoading
                    ? null
                    : createProject,

                child:
                isLoading

                    ? const CircularProgressIndicator(
                  color:
                  Colors.white,
                )

                    : const Text(
                  'Create Project',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}