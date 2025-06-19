import 'package:bloc/bloc.dart';

class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);
}

class ObscureCubit extends Cubit<bool> {
  ObscureCubit() : super(true);

  void toggleObscure() {
    emit(!state);
  }
}
