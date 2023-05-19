import 'package:bloc/bloc.dart';

class AttachmentCubit extends Cubit<List<String>> {
  AttachmentCubit() : super([]);

  changePageIndex(List<String> attachment) => emit(attachment);
}
