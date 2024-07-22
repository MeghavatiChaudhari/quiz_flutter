import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:quiz/screen/quiz_page.dart';
import 'package:get/get.dart';
import 'package:quiz/controllers/Score_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _visible = true;
  final QuizController quizController = Get.put(QuizController());
  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  void _startAnimation() {
    Timer.periodic(Duration(seconds: 2), (timer) {
      setState(() {
        _visible = !_visible;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Spacer(),
            Text(
              'Quiz Game',
              style: TextStyle(
                color: Colors.white,
                fontSize: 40.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: AnimatedOpacity(
                opacity: _visible ? 1.0 : 0.0,
                duration: Duration(seconds: 1),
                child: Text(
                  'Test your knowledge with our fun and engaging quizzes!',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 19.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                quizController.resetScore();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QuizPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 15.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: Text(
                'Start Quiz',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 20.0,
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
