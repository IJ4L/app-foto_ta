import 'package:bloc/bloc.dart';

class ObscureCubit extends Cubit<bool> {
  ObscureCubit() : super(true);

  void toggleObscure() {
    emit(!state);
  }
}

class ObscureCubitConfirmPassword extends Cubit<bool> {
  ObscureCubitConfirmPassword() : super(true);

  void toggleObscure() {
    emit(!state);
  }
}
