import 'package:flutter_bloc/flutter_bloc.dart';

class MultiSelectState {
  final bool isMultiSelectMode;
  final Set<int> selectedIndices;

  MultiSelectState({
    required this.isMultiSelectMode,
    required this.selectedIndices,
  });

  factory MultiSelectState.initial() {
    return MultiSelectState(isMultiSelectMode: false, selectedIndices: {});
  }

  MultiSelectState copyWith({
    bool? isMultiSelectMode,
    Set<int>? selectedIndices,
  }) {
    return MultiSelectState(
      isMultiSelectMode: isMultiSelectMode ?? this.isMultiSelectMode,
      selectedIndices: selectedIndices ?? this.selectedIndices,
    );
  }
}

class MultiSelectCubit extends Cubit<MultiSelectState> {
  MultiSelectCubit() : super(MultiSelectState.initial());

  void toggleMultiSelectMode() {
    if (state.isMultiSelectMode) {
      emit(state.copyWith(isMultiSelectMode: false, selectedIndices: {}));
    } else {
      emit(state.copyWith(isMultiSelectMode: true));
    }
  }

  void toggleItemSelection(int index) {
    final currentIndices = Set<int>.from(state.selectedIndices);

    if (currentIndices.contains(index)) {
      currentIndices.remove(index);
    } else {
      currentIndices.add(index);
    }

    emit(state.copyWith(selectedIndices: currentIndices));
  }

  void selectItem(int index) {
    final currentIndices = Set<int>.from(state.selectedIndices);
    currentIndices.add(index);
    emit(state.copyWith(selectedIndices: currentIndices));
  }

  void enterMultiSelectModeAndSelectItem(int index) {
    final currentIndices = Set<int>.from(state.selectedIndices);
    currentIndices.add(index);
    emit(
      state.copyWith(isMultiSelectMode: true, selectedIndices: currentIndices),
    );
  }

  void selectAll(int totalItems) {
    final allIndices = Set<int>.from({for (int i = 0; i < totalItems; i++) i});
    emit(state.copyWith(selectedIndices: allIndices));
  }

  void clearSelection() {
    emit(state.copyWith(selectedIndices: {}));
  }

  void toggleSelectAll(int totalItems) {
    if (state.selectedIndices.length == totalItems) {
      clearSelection();
    } else {
      selectAll(totalItems);
    }
  }

  void exitMultiSelectMode() {
    emit(state.copyWith(isMultiSelectMode: false, selectedIndices: {}));
  }
}
