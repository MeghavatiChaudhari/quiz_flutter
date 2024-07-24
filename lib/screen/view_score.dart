import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz/controllers/Score_controller.dart';
import 'package:google_fonts/google_fonts.dart';

class ViewScore extends StatelessWidget {
  const ViewScore({super.key});

  @override
  Widget build(BuildContext context) {
    final QuizController quizController = Get.put(QuizController());

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.grey[800]!, Colors.grey[900]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Obx(() {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[700]!.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(15.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white,
                          blurRadius: 15.0,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.yellow,
                          size: 60.0,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'You can do better!',
                          style: GoogleFonts.roboto(
                            color: Colors.white,
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  Container(
                    padding: EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[700]!.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(15.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 15.0,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.score,
                          color: Colors.white,
                          size: 60.0,
                        ),
                        SizedBox(height: 10),
                        Text(
                          '${quizController.score.value}',
                          style: GoogleFonts.roboto(
                            color: Colors.white,
                            fontSize: 48.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 50),
                  ElevatedButton(
                    onPressed: () {
                      Get.back();
                      quizController.resetScore(); // Reset the score if needed
                      quizController.index.value =
                          0; // Reset the question index
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          horizontal: 25.0, vertical: 15.0),
                      backgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      elevation: 0,
                      shadowColor: Colors.transparent,
                      textStyle: GoogleFonts.roboto(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.greenAccent, Colors.black26],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      child: Container(
                        height: 60,
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.refresh, color: Colors.white),
                            SizedBox(width: 10),
                            Text(
                              'Play Again',
                              style: GoogleFonts.roboto(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
