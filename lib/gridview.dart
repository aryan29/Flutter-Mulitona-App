import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:practice/main.dart';
import 'package:practice/let.dart';
import 'package:flutter/material.dart';

class MyGridView {
  Widget mybuild(name) {
    if (name == "Screen2")
      return Icon(FontAwesomeIcons.photoVideo,size:70);
    else
      return Icon(FontAwesomeIcons.fileAudio,size:70);
  }

  GestureDetector getStructuredGridCell(name, image, context) {
    // Wrap the child under GestureDetector to setup a on click action
    return GestureDetector(
      onTap: () {
        if (name == "Screen2") {
          print("Pressed Screen2 ");
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Screen2()));
        } else {
          print("Going to Voice");
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => VoiceHome()));
        }
      },
      child: Card(
          elevation: 1.5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            verticalDirection: VerticalDirection.down,
            children: <Widget>[
              Expanded(
                child: Center(
                  child: mybuild(name)
                ),
              )
            ],
          )),
    );
  }

  GridView build(BuildContext context) {
    return GridView.count(
      primary: true,
      padding: const EdgeInsets.all(1.0),
      crossAxisCount: 2,
      childAspectRatio: 0.85,
      mainAxisSpacing: 1.0,
      crossAxisSpacing: 1.0,
      children: <Widget>[
        getStructuredGridCell(
            "Voice Notes App", "social/facebook.png", context),
        getStructuredGridCell("Screen2", "social/facebook.png", context),
        // getStructuredGridCell("Advance Calci", "social/twitter.png", context),
        // getStructuredGridCell("Hasher", "social/instagram.png", context),
        // getStructuredGridCell("Email Bomber", "social/linkedin.png", context),
        // getStructuredGridCell(
        //     "Hack your Phone", "social/google_plus.png", context),
        // getStructuredGridCell(".....", "ic_launcher.png", context),
      ],
    );
  }
}
