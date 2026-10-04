import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {

  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState
    extends State<EditProfileScreen> {

  final nameController =
  TextEditingController(
    text: "Sakr Alix",
  );

  final emailController =
  TextEditingController(
    text: "sakr@example.com",
  );

  final phoneController =
  TextEditingController(
    text: "+967777777777",
  );

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          "Edit Profile",
        ),
      ),

      body: SingleChildScrollView(

        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            /// PROFILE IMAGE
            Stack(
              children: [

                const CircleAvatar(
                  radius: 60,

                  backgroundImage:
                  NetworkImage(
                    "https://i.pravatar.cc/300",
                  ),
                ),

                Positioned(

                  bottom: 0,
                  right: 0,

                  child: Container(

                    padding:
                    const EdgeInsets.all(8),

                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),

                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 35),

            /// NAME
            TextField(
              controller: nameController,

              decoration: InputDecoration(

                labelText: "Full Name",

                prefixIcon: const Icon(
                  Icons.person,
                ),

                border: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(
                    18,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// EMAIL
            TextField(
              controller: emailController,

              decoration: InputDecoration(

                labelText: "Email",

                prefixIcon: const Icon(
                  Icons.email,
                ),

                border: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(
                    18,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// PHONE
            TextField(
              controller: phoneController,

              decoration: InputDecoration(

                labelText: "Phone Number",

                prefixIcon: const Icon(
                  Icons.phone,
                ),

                border: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(
                    18,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 35),

            /// SAVE BUTTON
            SizedBox(
              width: double.infinity,
              height: 55,

              child: ElevatedButton(

                style:
                ElevatedButton.styleFrom(
                  backgroundColor:
                  Colors.blue,
                ),

                onPressed: () {

                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(

                    const SnackBar(
                      content: Text(
                        "Profile Updated Successfully ✅",
                      ),
                    ),
                  );
                },

                child: const Text(

                  "Save Changes",

                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}