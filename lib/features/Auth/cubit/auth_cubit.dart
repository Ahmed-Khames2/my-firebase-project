import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_firebase_app/features/Auth/cubit/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthCubit() : super(AuthInitial());

  Future<void> loginUser(String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      emit(AuthSuccess(user.user!.uid));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(AuthFailure("User not found"));
      } else if (e.code == 'wrong-password') {
        emit(AuthFailure("Wrong password"));
      } else {
        emit(AuthFailure(e.message ?? "Login failed"));
      }
    } catch (e) {
      emit(AuthFailure("Unexpected error"));
    }
  }

  Future<void> registerUser(String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      emit(AuthSuccess(user.user!.uid));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(AuthFailure("Weak password"));
      } else if (e.code == 'email-already-in-use') {
        emit(AuthFailure("Email already in use"));
      } else {
        emit(AuthFailure(e.message ?? "Register failed"));
      }
    } catch (e) {
      emit(AuthFailure("Unexpected error"));
    }
  }
}
