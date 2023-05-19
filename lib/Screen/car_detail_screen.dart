import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../Model/car_detail.dart';
import '../Utils/image_cropper_page.dart';
import '../Utils/image_picker_class.dart';
import '../Widgets/modal_dialog.dart';
import 'number_plate_screen.dart';

class CarDetailScreen extends StatefulWidget {
  final List<CarDetail> data;

  const CarDetailScreen({Key? key, required this.data}) : super(key: key);

  @override
  State<CarDetailScreen> createState() => _CarDetailScreenState();
}

class _CarDetailScreenState extends State<CarDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          backgroundColor: Color(0xff1e3d59),
          title: const Text("Car Details")),
      body: ListView.builder(
          itemCount: widget.data.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                imagePickerModal(context, onCameraTap: () {
                  log("Camera");
                  pickImage(source: ImageSource.camera).then((value) {
                    if (value != '') {
                      imageCropperView(value, context).then((value) {
                        if (value != '') {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (_) => NumberPlateScreen(
                                number: widget.data[index].numberPlate,
                                path: value,
                                cnic: widget.data[index].cnic,
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
                              builder: (_) => NumberPlateScreen(
                                cnic: widget.data[index].cnic,
                                number: widget.data[index].numberPlate,
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
              child: Container(
                  margin: const EdgeInsets.all(10),
                  height: 120,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Color(0xff1e3d59),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            'ID:${widget.data[index].id}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            'Cnic:${widget.data[index].cnic}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            'Number Plate:${widget.data[index].numberPlate}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            'Car Model:${widget.data[index].carModel}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            'Car Name:${widget.data[index].carName}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ],
                  )),
            );
          }),
    );
  }
}
