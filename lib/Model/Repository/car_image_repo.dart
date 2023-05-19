import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class CarImageRepo {
  static String carDamageChecking = '';

  static Future<bool> getCarDamageImage(
    BuildContext ctx,
    String cnic,
    String image,
    String numberPlate,
  ) async {
    print('Api calling');

    try {
      var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              'http://ec2-3-95-5-213.compute-1.amazonaws.com:8000/api/image/'));
      request.fields.addAll({
        'cnic': cnic,
        'car_number': numberPlate,
      });
      print("IMAGESSSSSS$image");
      request.files.add(await http.MultipartFile.fromPath('image', image));

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        print('----------som na ');
        var checking = await response.stream.bytesToString();
        print(checking);
        var jsonDecode = json.decode(checking);
        jsonDecode["classification"];
        Fluttertoast.showToast(msg: jsonDecode["classification"]);
        carDamageChecking = jsonDecode["classification"];
        return true;
      } else {
        print(response.reasonPhrase);

        return false;
      }
    } on Exception catch (e) {
      print(e.toString());
      return false;
    }
  }
}
