import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ocr/Controller/ImageCubit/attachment.dart';
import 'package:ocr/Controller/ImageCubit/image_cubit.dart';
import 'package:ocr/Widgets/back_ground_logo.dart';
import 'package:ocr/main.dart';

import '../Utils/image_picker_class.dart';
import '../Widgets/modal_dialog.dart';

class NumberPlateScreen extends StatefulWidget {
  final String? path;
  final String number;
  final String cnic;

  const NumberPlateScreen(
      {Key? key, required this.cnic, required this.path, required this.number})
      : super(key: key);

  @override
  State<NumberPlateScreen> createState() => _NumberPlateScreenState();
}

class _NumberPlateScreenState extends State<NumberPlateScreen> {
  bool _isBusy = false;

  TextEditingController controller = TextEditingController();
  var image;
  List<String> images = [];

  @override
  void initState() {
    final InputImage inputImage = InputImage.fromFilePath(widget.path!);

    processImage(inputImage);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ImagePicker picker = ImagePicker();

    return Scaffold(
        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: BlocBuilder<ImageCubit, ImageState>(
            builder: (context, state) {
              if (state is ImageLoaded) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) {
                      return const MyHomePage();
                    }));
                  },
                  child: Container(
                    margin: const EdgeInsets.all(15),
                    height: 55,
                    decoration: BoxDecoration(
                        color: const Color(0xff1e3d59),
                        borderRadius: BorderRadius.circular(20)),
                    child: const Center(
                      child: Text(
                        'Back To Main Menu',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 18),
                      ),
                    ),
                  ),
                );
              }
              return BlocBuilder<AttachmentCubit, List<String>>(
                builder: (context, state) {
                  return GestureDetector(
                    onTap: () {
                      context.read<ImageCubit>().getCarDamageImage(
                          ctx: context,
                          cnic: widget.cnic,
                          image: state[0],
                          numberPlate: widget.number);

                      print('------- Clicked');

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
                          'Submit Car Images',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 18),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
        appBar: AppBar(
            centerTitle: true,
            backgroundColor: const Color(0xff1e3d59),
            title: const Text("Number Plate Screen")),
        body: _isBusy == true
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : BackGroundLogo(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: TextFormField(
                        // maxLines: MediaQuery.of(context).size.height.toInt(),
                        controller: controller,
                        decoration: const InputDecoration(
                          hintText: "Text goes here...",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const Center(
                        child: Text(
                      'Capture Image From The Car',
                      style: TextStyle(
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.w700,
                          fontSize: 20),
                    )),
                    const SizedBox(
                      height: 20,
                    ),
                    BlocBuilder<AttachmentCubit, List<String>>(
                      builder: (context, state) {
                        return state.length < 4
                            ? GestureDetector(
                                onTap: () {
                                  imagePickerModal(context, onCameraTap: () {
                                    log("Camera");
                                    pickImage(source: ImageSource.camera)
                                        .then((value) {
                                      if (value != '') {
                                        image = value;
                                        images.add(image);

                                        BlocProvider.of<AttachmentCubit>(
                                                context)
                                            .changePageIndex(images);
                                        setState(() {});
                                      }
                                    });
                                  }, onGalleryTap: () async {
                                    Navigator.pop(context);

                                    await ImagePicker.platform
                                        .getImageFromSource(
                                            source: ImageSource.gallery)
                                        .then((value) {
                                      if (value != null) {
                                        print(
                                            '==================??????????????????');

                                        images.add(value.path);

                                        BlocProvider.of<AttachmentCubit>(
                                                context)
                                            .changePageIndex(images);
                                        setState(() {});
                                      }
                                    });
                                  });
                                },
                                child: Container(
                                  height: 45,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 40),
                                  decoration: BoxDecoration(
                                      color: const Color(0xff1e3d59),
                                      borderRadius: BorderRadius.circular(16)),
                                  child: Center(
                                    child: BlocBuilder<AttachmentCubit,
                                        List<String>>(
                                      builder: (context, state) {
                                        return Text(
                                          state.length == 0
                                              ? 'Take Image From Front Side'
                                              : state.length == 1
                                                  ? "Take Image From Left Side"
                                                  : state.length == 2
                                                      ? "Take Image From Right Side"
                                                      : 'Take Image From Back Side',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 18),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox();
                      },
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    BlocBuilder<AttachmentCubit, List<String>>(
                      builder: (context, state) {
                        print("State is ${state.length}");
                        return GridView.builder(
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 200,
                                    childAspectRatio: 3 / 2,
                                    crossAxisSpacing: 20,
                                    mainAxisSpacing: 20),
                            itemCount: state.length,
                            itemBuilder: (BuildContext ctx, index) {
                              return Container(
                                  height: 200,
                                  width: 200,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Image.file(File(state[index])));
                            });
                      },
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    BlocListener<ImageCubit, ImageState>(
                      listener: (context, state) {
                        if (state is ImageLoaded || state is ImageError) {
                          var snackBar = const SnackBar(
                            backgroundColor: Color(0xff1e3d59),
                            content: Text(
                              'Car is successfully checked in',
                              textAlign: TextAlign.center,
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      },
                      child: BlocBuilder<ImageCubit, ImageState>(
                        builder: (context, state) {
                          print("state $state");
                          if (state is ImageLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          return const SizedBox();
                        },
                      ),
                    ),
                  ],
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

    print('----$data');
    data = recognizedText.text;
    var value = data.replaceAll(RegExp(r'[^0-9]'), '');
    if (value == widget.number) {
      print('*****After $value');
      controller.text = value;
    } else {
      Fluttertoast.showToast(msg: 'Number plate Didn\'t Match Try Again ....');
      Navigator.pop(context);
    }

    setState(() {
      _isBusy = false;
    });
  }
}
