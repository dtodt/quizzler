import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'package:quizzler/quiz_brain.dart';

final audioPlayer = AudioCache();
final QuizBrain quizBrain = QuizBrain();

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
  final List<Icon> scoreKeeper = [];

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
                quizBrain.getQuestionText(),
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

  void checkAnswer({bool answer}) {
    setState(() {
      if (quizBrain.getQuestionAnswer() == answer) {
        audioPlayer.play('sounds/correct.wav');
        scoreKeeper.add(buildRightAnswer());
      } else {
        audioPlayer.play('sounds/incorrect.wav');
        scoreKeeper.add(buildWrongAnswer());
      }

      quizBrain.findNextQuestion();
    });
  }
}
