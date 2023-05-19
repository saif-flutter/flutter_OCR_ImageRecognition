part of 'cnic_cubit.dart';


abstract class CnicState {}

class CnicInitial extends CnicState {}
class CnicLoading extends CnicState {}
class CnicLoaded extends CnicState {}
class CnicError extends CnicState {
  String error;

  CnicError({required this.error});
}

