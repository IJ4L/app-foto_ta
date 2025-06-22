import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../data/repositories/auth_repository.dart';

part 'auth_state.dart';

class SignInCubit extends Cubit<SignInState> {
  final AuthRepositoryImpl authRepository;

  SignInCubit(this.authRepository) : super(SignInInitial());

  @override
  void onChange(Change<SignInState> change) {
    super.onChange(change);
    debugPrint(
      'SignInCubit state changed: ${change.currentState} -> ${change.nextState}',
    );
  }

  Future<void> signInWithGoogle(String username, String password) async {
    try {
      emit(SignInLoading());
      Future.delayed(
        const Duration(seconds: 2),
      ).then((_) => emit(SignInSuccess()));
    } catch (_) {
      emit(SignInFailure());
    }
  }
}
