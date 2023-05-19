
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ocr/Model/Repository/cnic_repo.dart';

part 'cnic_state.dart';

class CnicCubit extends Cubit<CnicState> {
  CnicCubit() : super(CnicInitial());

  Future<void> getCnic(
      {required BuildContext ctxx,
      required String cnic,
      }) async {
    ///initial State
    emit(CnicInitial());

    final checkData = await CnicRepoApi.getCnicData(ctxx, cnic,);

    //debugPrint(checkData);

    if (checkData == true) {
      /// Loaded State
      Future.delayed(const Duration(seconds: 2));
      emit(CnicLoaded());
      Fluttertoast.showToast(msg: 'Send Successfully');
    } else {
      /// Error State
      emit(CnicError(error: 'Error Found'));
    }
  }
}
