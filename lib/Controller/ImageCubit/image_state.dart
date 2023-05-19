part of 'image_cubit.dart';

abstract class ImageState {}

class ImageInitial extends ImageState {}
class ImageLoading extends ImageState {}
class ImageLoaded extends ImageState {}
class ImageError extends ImageState {

  String error;

  ImageError({required this.error});
}
