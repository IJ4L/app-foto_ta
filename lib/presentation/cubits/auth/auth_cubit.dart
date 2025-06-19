import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../data/repositories/auth_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepositoryImpl authRepository;

  AuthCubit(this.authRepository) : super(AuthInitial());

  @override
  void onChange(Change<AuthState> change) {
    super.onChange(change);
    debugPrint('AuthCubit state changed: ${change.currentState} -> ${change.nextState}');
  }

  Future<void> signInWithGoogle(String username, String password) async {
    try {
      emit(AuthLoading());
      Future.delayed(const Duration(seconds: 2));
      emit(AuthSuccess());
    } catch (_) {
      emit(AuthFailure());
    }
  }
}
