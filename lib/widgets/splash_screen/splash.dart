import 'package:flutter/material.dart';
import 'package:expenses_wise/widgets/expenses.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // بعد 3 ثواني ننتقل إلى الصفحة الرئيسية
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (ctx) => const Expenses()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(
        255,
        0,
        217,
        255,
      ), // نفس لون الثيم الأساسي
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'lib/assets/EXPENSES_WISE.png',
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 20),
            const Text(
              "Expenses Wise",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const Text(
              "Track Your Monthly Expenses Effortlessly",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 30),
            const CircularProgressIndicator(color: Colors.black),
          ],
        ),
      ),
    );
  }
}
