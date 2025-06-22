import 'package:flutter_bloc/flutter_bloc.dart';

class FotoPageState {
  final bool isMultiSelectMode;

  FotoPageState({this.isMultiSelectMode = false});

  FotoPageState copyWith({bool? isMultiSelectMode}) {
    return FotoPageState(
      isMultiSelectMode: isMultiSelectMode ?? this.isMultiSelectMode,
    );
  }
}

class FotoPageCubit extends Cubit<FotoPageState> {
  FotoPageCubit() : super(FotoPageState());

  void setMultiSelectMode(bool isMultiSelectMode) {
    emit(state.copyWith(isMultiSelectMode: isMultiSelectMode));
  }
}
