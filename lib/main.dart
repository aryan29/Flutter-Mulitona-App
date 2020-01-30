import 'dart:io';

import 'package:flutter/material.dart';
import 'package:speech_recognition/speech_recognition.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'gridview.dart';

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
        home: HomeScreen());
  }
}

class VoiceHome extends StatefulWidget {
  @override
  _VoiceHomeState createState() => _VoiceHomeState();
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Home Screen"),
        ),
        body: MyGridView().build(context));
  }
}

class _VoiceHomeState extends State<VoiceHome> {
  SpeechRecognition _speechRecognition;
  bool avil = false;
  bool listen = false;
  String res = "";
  String prev = "";
  String filename = "";

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
    _speechRecognition.setRecognitionResultHandler((String speech) {
      setState(() => res = (speech));
    });
    _speechRecognition.setRecognitionCompleteHandler(() {
      if (listen) {
        setState(() {
          listen = false;
          prev = prev + " " + res;
          print("Prev is " + prev);
        });
      }
    });
    _speechRecognition
        .activate()
        .then((result) => setState(() => avil = result));
  }

  _ackAlert(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Save File'),
          content: Row(
            children: <Widget>[
              Expanded(
                  child: TextField(
                autofocus: true,
                decoration: InputDecoration(labelText: 'File Name'),
                onChanged: (value) {
                  filename = value;
                },
              ))
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Submit'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _write(String text) async {
    await _ackAlert(context);
    if (filename != "") {
      print(filename);
      print(text + "Going to download");
      final directory = await DownloadsPathProvider.downloadsDirectory;
      print(directory);
      final File file = new File('${directory.path}/$filename.txt');
      print(file);
      await file.writeAsString(text);
    }
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            FloatingActionButton(
              heroTag: "btn1",
              child: Icon(FontAwesomeIcons.trash),
              onPressed: () {
                print("Erase is pressed");
                print(!listen);
                if (!listen) {
                  setState(() {
                    res = "";
                    prev = "";
                  });
                }
                print(res);
              },
            ),
            FloatingActionButton(
              heroTag: "btn2",
              child: listen
                  ? Icon(FontAwesomeIcons.stop)
                  : Icon(FontAwesomeIcons.play),
              onPressed: () {
                print("Mid Button Pressed");
                print(avil);
                if (avil && !listen) {
                  _speechRecognition.listen(locale: "en_US");
                }
                if (avil && listen) {
                  _speechRecognition.stop().then((result) {
                    setState(() {
                      prev = prev + " " + res;
                      listen = false;
                    });
                  });
                }
              },
            ),
            FloatingActionButton(
                child: Icon(FontAwesomeIcons.download),
                onPressed: () {
                  _write(prev);
                }),
          ],
        ),
        Container(
            margin: EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width * 0.6,
            decoration: BoxDecoration(color: Colors.cyanAccent[100]),
            padding: EdgeInsets.all(5),
            child: Text(prev))
      ],
    )));
  }
}
