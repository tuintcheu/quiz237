import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class QuestionWidget extends StatefulWidget {
  final Map<String, dynamic> question;
  final Function(int) onAnswerSelected;

  QuestionWidget({required this.question, required this.onAnswerSelected});

  @override
  _QuestionWidgetState createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  int? selectedAnswer;
  bool isAnswered = false;

  void _checkAnswer(int answer) {
    setState(() {
      selectedAnswer = answer;
      isAnswered = true;
    });

    if (answer == widget.question['correctAnswer']) {
      widget.onAnswerSelected(5); // Ajouter 5 points pour une bonne réponse
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.question['question'],
          style: GoogleFonts.lato(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        ...List.generate(widget.question['options'].length, (index) {
          final option = widget.question['options'][index];
          final isCorrect = index == widget.question['correctAnswer'];
          final isSelected = selectedAnswer == index;

          Color buttonColor = Colors.blue;
          if (isAnswered) {
            if (isSelected) {
              buttonColor = isCorrect ? Colors.green : Colors.red;
            } else if (isCorrect) {
              buttonColor = Colors.green;
            }
          }

          return GestureDetector(
            onTap: () {
              if (!isAnswered) {
                _checkAnswer(index);
              }
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 8),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: buttonColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  option,
                  style: GoogleFonts.lato(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}