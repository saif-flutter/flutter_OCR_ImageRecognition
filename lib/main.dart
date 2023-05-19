import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ocr/Controller/ImageCubit/attachment.dart';
import 'package:ocr/Controller/ImageCubit/image_cubit.dart';
import 'package:ocr/Screen/recognization_page.dart';
import 'package:ocr/Screen/splash_screen.dart';
import 'package:ocr/Utils/image_cropper_page.dart';
import 'package:ocr/Utils/image_picker_class.dart';
import 'package:ocr/Widgets/modal_dialog.dart';

import 'Controller/cnic_cubit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => CnicCubit()),
        BlocProvider(create: (context) => ImageCubit()),
        BlocProvider(create: (context) => AttachmentCubit()),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Car WorkShop',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: SplashScreen()),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        backgroundColor: const Color(0xff1e3d59),
        centerTitle: true,
        title: const Text('Car WorkShop'),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          Expanded(
            flex: 1,
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.transparent, shape: BoxShape.circle),
              child: Image.asset(
                'assets/elm.png',
                height: 10,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Align(
              alignment: Alignment.bottomCenter,
              child:
                  Opacity(opacity: 0.3, child: Image.asset("assets/car.gif")),
            ),
          ),
          const Expanded(
            flex: 2,
            child: Center(
                child: Text(
              'Please Scan Your CNIC Card...',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w400),
            )),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xff1e3d59),
        onPressed: () {
          imagePickerModal(context, onCameraTap: () {
            log("Camera");
            pickImage(source: ImageSource.camera).then((value) {
              if (value != '') {
                imageCropperView(value, context).then((value) {
                  if (value != '') {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (_) => RecognizePage(
                          path: value,
                        ),
                      ),
                    );
                  }
                });
              }
            });
          }, onGalleryTap: () {
            log("Gallery");
            pickImage(source: ImageSource.gallery).then((value) {
              if (value != '') {
                imageCropperView(value, context).then((value) {
                  if (value != '') {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (_) => RecognizePage(
                          path: value,
                        ),
                      ),
                    );
                  }
                });
              }
            });
          });
        },
        label: const Text("Scan CNIC"),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
