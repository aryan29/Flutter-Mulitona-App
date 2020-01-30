import 'package:flutter/material.dart';
import 'package:speech_recognition/speech_recognition.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: VoiceHome(),
    );
  }
}

class VoiceHome extends StatefulWidget {
  @override
  _VoiceHomeState createState() => _VoiceHomeState();
}

class _VoiceHomeState extends State<VoiceHome> {
  SpeechRecognition _speechRecognition;
  bool avil = false;
  bool listen = false;
  String res = "h";

  @override
  void initState() {
    // print("here i am");
    super.initState();
    initSpeechRecognizer();
  }

  void initSpeechRecognizer() {
    // print("Coming Here");
    _speechRecognition = SpeechRecognition();
    _speechRecognition
        .setAvailabilityHandler((bool result) => setState(() => avil = result));
    _speechRecognition
        .setRecognitionStartedHandler(() => setState(() => listen = true));
    _speechRecognition.setRecognitionResultHandler(
        (String speech) => setState(() => res = speech));
    _speechRecognition
        .setRecognitionCompleteHandler(() => setState(() => listen = false));
    _speechRecognition
        .activate()
        .then((result) => setState(() => avil = result));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FloatingActionButton(
              mini: true,
              onPressed: () {
                print("Erase is pressed");
                print(listen);
                if (listen) {
                  _speechRecognition.cancel().then((result) => setState(() {
                        listen = result;
                        res = "";
                      }));
                }
                print(res);
              },
            ),
            FloatingActionButton(
              onPressed: () {
                print("Mid Button Pressed");
                print(avil);
                if (avil && !listen) {
                  _speechRecognition.listen(locale: "en_US");
                }
              },
            ),
            FloatingActionButton(
              mini: true,
              onPressed: () {
                if (listen) {
                  _speechRecognition
                      .stop()
                      .then((result) => setState(() => listen = false));
                }
              },
            )
          ],
        ),
        Container(
            width: MediaQuery.of(context).size.width * 0.6,
            decoration: BoxDecoration(color: Colors.cyanAccent[100]),
            padding: EdgeInsets.all(5),
            child: Text(res))
      ],
    )));
  }
}
