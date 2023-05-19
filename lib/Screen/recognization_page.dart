import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import '../Controller/cnic_cubit.dart';

class RecognizePage extends StatefulWidget {
  final String? path;

  const RecognizePage({Key? key, this.path}) : super(key: key);

  @override
  State<RecognizePage> createState() => _RecognizePageState();
}

class _RecognizePageState extends State<RecognizePage> {
  bool _isBusy = false;

  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    final InputImage inputImage = InputImage.fromFilePath(widget.path!);

    processImage(inputImage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: GestureDetector(
            onTap: () {
              context
                  .read<CnicCubit>()
                  .getCnic(ctxx: context, cnic: controller.text);

              print('------- Clicked');
              print(controller.text);
            },
            child: Container(
              margin: const EdgeInsets.all(15),
              height: 55,
              decoration: BoxDecoration(
                  color: const Color(0xff1e3d59),
                  borderRadius: BorderRadius.circular(20)),
              child: const Center(
                child: Text(
                  'Submit CNIC',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 18),
                ),
              ),
            ),
          ),
        ),
        appBar: AppBar(
            centerTitle: true,
            backgroundColor: const Color(0xff1e3d59),
            title: const Text("Check Car Details")),
        body: _isBusy == true
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                padding: const EdgeInsets.all(20),
                child: TextFormField(
                  //maxLines: MediaQuery.of(context).size.height.toInt(),
                  controller: controller,
                  decoration: const InputDecoration(
                    hintText: "Text goes here...",
                    border: InputBorder.none,
                  ),
                ),
              ));
  }

  void processImage(InputImage image) async {
    String? data;
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    setState(() {
      _isBusy = true;
    });

    log(image.filePath!);
    final RecognizedText recognizedText =
        await textRecognizer.processImage(image);
//    // final cnicPattern = RegExp(r"(\d{5}-\d{7}-\d)");
//     final arabicPattern =RegExp(r'^[0-9]+$');
//
//
//    // final cnicMatch = cnicPattern.firstMatch(recognizedText.text);
//     final arabicMatch = arabicPattern.firstMatch(recognizedText.text);
//
//     // if (cnicMatch != null && cnicMatch.groupCount >= 1) {
//     //   data = cnicMatch.group(1);
//     // }
//     if (arabicMatch != null && arabicMatch.groupCount >= 1) {
//       data = arabicMatch.group(1);
//     }
//     print('===============%%%%%%%%%%%===== $data');
//
//
//
//     print(arabicMatch);
//      if (arabicMatch != null && arabicMatch.groupCount >= 1) {
//       print(arabicMatch);
//       print('======================= arabmatch');
//     var cnic = recognizedText.text;
// print('==============cnic $cnic');
//
//
//  data = cnic;
//       print(cnic);
//     }
//     else {
//       data = recognizedText.text;
//     }
//
//     controller.text = data!;

    final cnicPattern = RegExp(r"(\d{5}-\d{7}-\d)");
    final arabicPattern = RegExp(r"(\d{10})");
    final cnicMatch = cnicPattern.firstMatch(recognizedText.text);
    final arabicMatch = arabicPattern.firstMatch(recognizedText.text);
    print('----------------$arabicMatch');
    print('-----------$cnicMatch');
    if (cnicMatch != null && cnicMatch.groupCount >= 1) {
      data = cnicMatch.group(1);
      print('===============%%%%%%%%%%%===== $data');
    } else if (arabicMatch != null && arabicMatch.groupCount >= 1) {
      data = arabicMatch.group(1);
      print('------------------------###################$data');
    } else {
      data = recognizedText.text;
    }
    controller.text = data!;

    ///End busy state
    setState(() {
      _isBusy = false;
    });
  }
}
