import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../Model/Repository/car_image_repo.dart';

part 'image_state.dart';

class ImageCubit extends Cubit<ImageState> {
  ImageCubit() : super(ImageInitial());

  Future<void> getCarDamageImage(
      {required BuildContext ctx,
        required String cnic,
        required String image,
        required String numberPlate,

      }) async {
    ///initial State
    emit(ImageLoading());

    final checkData = await CarImageRepo.getCarDamageImage(ctx, cnic, image, numberPlate);

    //debugPrint(checkData);

    if (checkData == true) {
      emit(ImageLoaded());
    } else {
      /// Error State
      emit(ImageError(error: 'Error Found'));
    }
  }
}
