import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:tflite/tflite.dart';

class PictureRecognition extends StatefulWidget {
  final imagePath;
  const PictureRecognition({Key? key, required this.imagePath}) : super(key: key);

  @override
  State<StatefulWidget> createState() => PictureRecognitionState();
}

class PictureRecognitionState extends State<PictureRecognition> {
  bool isLoading = false;
  var result;

  @override
  void initState(){
    super.initState();
    loadModel();
    runModelOnImage();
  }

  Future loadModel() async {
    Tflite.close();
    await Tflite.loadModel(
        model: "assets/ssd_mobilenet.tflite",
        labels: "assets/ssd_mobilenet.txt");
  }

  runModelOnImage() async {
      setState(() {
        isLoading = true;
      });

        var recognitions = await Tflite.detectObjectOnImage(
        path: widget.imagePath,
        threshold: 0.3,
        imageMean: 0.0,
        imageStd: 127.5,
        numResultsPerClass: 1
    );

        setState(() {
          isLoading = false;
          result = recognitions;
        });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: isLoading ? buildProgressIndicator(context) : another(context, widget.imagePath, result)
    );
  }
}

Widget another(BuildContext context, imagePath, result){
  return Scaffold(
    appBar: AppBar(title: Text('')),
    body : SingleChildScrollView(
      child: Column(
        children: [
          Image.file(File(imagePath)),
          Text(
            result.join(', ')
          ),
        ],
      ),
    )

  );

}
Widget buildProgressIndicator(BuildContext context) {
  return const CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(
        Colors.black,
      ) //Color of indicator
  );
}