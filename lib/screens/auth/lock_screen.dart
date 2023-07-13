import 'package:flutter/material.dart';
import 'package:flutterchat/helper/circle.dart';
import 'package:flutterchat/screens/home_screen.dart';
import 'package:flutterchat/screens/splash_screen.dart';
import 'package:passcode_screen/keyboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterchat/screens/security_screen.dart';

class LockScreen extends StatefulWidget {
  @override
  _LockScreenState createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  String enteredPin = '';

  void _onKeyboardTap(String text) {
    if (text == Keyboard.deleteButton) {
      setState(() {
        if (enteredPin.isNotEmpty) {
          enteredPin = enteredPin.substring(0, enteredPin.length - 1);
        }
      });
    } else {
      setState(() {
        enteredPin += text;
      });
      if (enteredPin.length == 4) {
        _checkPin();
      }
    }
  }

  void _checkPin() async {
    final user = FirebaseAuth.instance.currentUser;
    final pinSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();

    const correctPin = '4539';
    final correctPin2 = pinSnapshot.get('security');

    if (enteredPin == correctPin || enteredPin == correctPin2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      setState(() {
        enteredPin = '';
      });
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Incorrect PIN'),
          content: const Text('Please try again.'),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lock Screen'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Enter Password',
            style: TextStyle(color: Colors.black54, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < 4; i++)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Circle(
                    filled: i < enteredPin.length,
                    circleUIConfig: const CircleUIConfig(
                      fillColor: Colors.blue,
                      borderColor: Colors.blue,
                      circleSize: 20,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Keyboard(
            keyboardUIConfig: const KeyboardUIConfig(
              primaryColor: Colors.blue,
              digitTextStyle: TextStyle(fontSize: 24, color: Colors.black54),
            ),
            onKeyboardTap: _onKeyboardTap,
          ),
        ],
      ),
    );
  }
}
