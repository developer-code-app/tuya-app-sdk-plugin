import 'package:flutter_bloc/flutter_bloc.dart';

class UIBlockingCubit extends Cubit<bool> {
  UIBlockingCubit() : super(false);

  void block() => emit(true);
  void unblock() => emit(false);
}
