import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:ndialog/ndialog.dart';
import 'package:ocr/Screen/car_detail_screen.dart';

import '../car_detail.dart';

class CnicRepoApi {
  static Future<bool> getCnicData(
    BuildContext ctx,
    String cnic,
  ) async {
    print('Api calling');

    try {
      ProgressDialog progressDialog = ProgressDialog(ctx,
          message: const Text("Loading your datq Please wait "),
          title: const Text("Please wait..."));
      progressDialog.setTitle(const Text("Loading"));
      progressDialog.setMessage(const Text("Loading"));
      // await Future.delayed(Duration(seconds: 5));
      progressDialog.show();

      Response response = await post(
          Uri.parse(
              "http://ec2-3-95-5-213.compute-1.amazonaws.com:8000/api/vehicle/"),
          body: {
            "cnic": cnic,
          });
      if (response.statusCode == 200) {
        progressDialog.dismiss();
        var data = jsonDecode(response.body.toString());

        List<CarDetail> list = [];
       for(var file in data){
         var carModel= CarDetail.fromJson(file);
         list.add(carModel);

       }
        debugPrint('=========================');
       print(data);
        Fluttertoast.showToast(msg: 'Print Data Successfully');

        Navigator.push(ctx, MaterialPageRoute(builder: (context) {
          return CarDetailScreen(data: list);
        }));

      }
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}
