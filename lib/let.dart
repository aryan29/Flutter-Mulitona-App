import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:io';

class Screen2 extends StatefulWidget {
  @override
  _Screen2 createState() => _Screen2();
}

class _Screen2 extends State<Screen2> {
  String mytext = "";
  String buxt = "Send Image";
  File img;
  void myhttp() async {
    img = await ImagePicker.pickImage(source: ImageSource.gallery)
        .whenComplete(() {
      setState(() {
        img = img;
      });
    });
    String baseimg = base64Encode(img.readAsBytesSync());
    //print(baseimg);
    Dio dio = new Dio();
    try {
      String url = "https://api.ocr.space/parse/image";
      FormData formData = new FormData.fromMap({
        "apikey": "da8546ce3d88957",
        "base64image": "data:image/png;base64," + baseimg,
        "filetype": "PNG",
        "language": "eng",
        //"url":"https://pluspng.com/img-png/download-love-text-png-images-transparent-gallery-advertisement-500.png"
        // "base64image":"data:image/png;base64,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"
      });

      Response response;
      print("Going to send req");
      response = await dio.post(url,
          data: formData, options: Options(contentType: 'multipart/form-data'));
      print(response.statusCode);
      var res = json.decode(response.toString());
      String s = res['ParsedResults'][0]['ParsedText'];
      print(s);
      setState(() {
        mytext = s;
        buxt = "Send Image";
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.all(10),
            child: ListView(
              shrinkWrap: true,
              //mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Container(
                      height: 400,
                      width: MediaQuery.of(context).size.width,
                      child: (img == null)
                          ? Text("Image Not Uploaded",textAlign: TextAlign.center,)
                          : Image.file(img)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.all(10),
                        width: MediaQuery.of(context).size.width*0.8,
                        decoration:
                            BoxDecoration(color: Colors.lightBlue[50]),
                        child: Text(mytext))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FloatingActionButton.extended(
                      icon: Icon(FontAwesomeIcons.paperPlane),
                      isExtended: true,
                      label: Text(buxt),
                      onPressed: () {
                        myhttp();
                                                setState(() {
                          buxt = "Uploading....";
                        });

                      },
                    )
                  ],
                )
              ],
            )));
  }
}
