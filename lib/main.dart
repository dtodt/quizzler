import 'dart:math';

import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'package:quizzler/question.dart';

void main() => runApp(QuizzlerApp());

class QuizzlerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: QuizPage(),
          ),
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  QuizPage({Key key}) : super(key: key);

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final player = AudioCache();

  final List<Question> questions = [
    Question(
        text: 'You can lead a cow down stairs but not up stairs.',
        answer: false),
    Question(
        text: 'Approximately one quarter of human bones are in the feet.',
        answer: true),
    Question(text: 'A slug\'s blood is green.', answer: true),
  ];
  final List<Icon> scoreKeeper = [];

  int currentQuestion;

  @override
  void initState() {
    super.initState();
    findNextQuestion();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          flex: 5,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                questions[currentQuestion].text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        buildQuizButton(
            label: 'True',
            color: Colors.green,
            onPressed: () => checkAnswer(answer: true)),
        buildQuizButton(
            label: 'False',
            color: Colors.red,
            onPressed: () => checkAnswer(answer: false)),
        Row(
          children: scoreKeeper,
        ),
      ],
    );
  }

  Expanded buildQuizButton(
      {Color color, String label, VoidCallback onPressed}) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: FlatButton(
          color: color,
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
            ),
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }

  Icon buildRightAnswer() {
    return Icon(
      Icons.check,
      color: Colors.green,
    );
  }

  Icon buildWrongAnswer() {
    return Icon(
      Icons.close,
      color: Colors.red,
    );
  }

  void findNextQuestion() {
    int nextQuestion = Random().nextInt(3);
    if (nextQuestion != currentQuestion) {
      setState(() {
        currentQuestion = nextQuestion;
      });
    } else {
      findNextQuestion();
    }
  }

  void checkAnswer({bool answer}) {
    if (questions[currentQuestion].answer == answer) {
      player.play('sounds/correct.wav');
      scoreKeeper.add(buildRightAnswer());
    } else {
      player.play('sounds/incorrect.wav');
      scoreKeeper.add(buildWrongAnswer());
    }

    findNextQuestion();
  }
}

/*
question1: 'You can lead a cow down stairs but not up stairs.', false,
question2: 'Approximately one quarter of human bones are in the feet.', true,
question3: 'A slug\'s blood is green.', true,
*/
