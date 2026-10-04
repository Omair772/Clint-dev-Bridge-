import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

import '../auth/welcome_screen.dart';

class SplashScreen
    extends StatefulWidget {

  const SplashScreen({
    super.key,
  });

  @override
  State<SplashScreen> createState() =>
      _SplashScreenState();
}

class _SplashScreenState
    extends State<SplashScreen>
    with TickerProviderStateMixin {

  late AnimationController
  animationController;

  late Animation<double>
  scaleAnimation;

  @override
  void initState() {
    super.initState();

    animationController =
        AnimationController(

          vsync: this,

          duration:
          const Duration(
            seconds: 2,
          ),
        );

    scaleAnimation =
        CurvedAnimation(

          parent: animationController,

          curve:
          Curves.easeInOutBack,
        );

    animationController.forward();

    Timer(
      const Duration(seconds: 3),
          () {

        Navigator.pushReplacement(

          context,

          MaterialPageRoute(
            builder: (_) =>
            const WelcomeScreen(),
          ),
        );
      },
    );
  }

  @override
  void dispose() {

    animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Container(

        width: double.infinity,

        decoration: const BoxDecoration(
          gradient:
          AppColors.primaryGradient,
        ),

        child: Center(

          child: ScaleTransition(

            scale: scaleAnimation,

            child: Column(

              mainAxisAlignment:
              MainAxisAlignment.center,

              children: [

                Container(

                  width: 130,
                  height: 130,

                  decoration: BoxDecoration(

                    color:
                    Colors.white,

                    borderRadius:
                    BorderRadius.circular(
                      35,
                    ),

                    boxShadow: [

                      BoxShadow(
                        color:
                        Colors.black
                            .withOpacity(
                          0.2,
                        ),

                        blurRadius: 30,
                      ),
                    ],
                  ),

                  child: const Icon(

                    Icons.auto_awesome,

                    size: 70,

                    color:
                    AppColors.primary,
                  ),
                ),

                const SizedBox(height: 35),

                const Text(

                  "Client Dev Bridge",

                  style: TextStyle(

                    fontSize: 34,

                    fontWeight:
                    FontWeight.bold,

                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 12),

                const Text(

                  "Build Your Omair Sadeq IT_level3",

                  style: TextStyle(

                    color:
                    Colors.white70,

                    fontSize: 17,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}