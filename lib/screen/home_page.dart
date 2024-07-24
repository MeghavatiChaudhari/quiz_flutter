import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz/screen/quiz_page.dart';
import 'package:quiz/controllers/Score_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  bool _visible = true;
  final QuizController quizController = Get.put(QuizController());
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _startAnimation();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.repeat(reverse: true);
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
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Spacer(),
              ScaleTransition(
                scale: _animation,
                child: Column(
                  children: [
                    Icon(
                      Icons.quiz,
                      color: Colors.white,
                      size: 100,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Quiz Game',
                      style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: AnimatedOpacity(
                  opacity: _visible ? 1.0 : 0.0,
                  duration: Duration(seconds: 1),
                  child: Text(
                    'Test your knowledge with our fun and engaging quizzes!',
                    style: GoogleFonts.roboto(
                      color: Colors.white70,
                      fontSize: 19.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Spacer(),
              ElevatedButton.icon(
                onPressed: () {
                  quizController.resetScore();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => QuizPage()),
                  );
                },
                icon: Icon(Icons.play_arrow, color: Colors.white),
                label: Text(
                  'Start Quiz',
                  style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding:
                      EdgeInsets.symmetric(horizontal: 40.0, vertical: 15.0),
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  elevation: 5,
                  shadowColor: Colors.black26,
                ),
              ),
              SizedBox(height: 20.0),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.info_outline, color: Colors.white),
                iconSize: 30,
                tooltip: 'About the Quiz',
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
