import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vba/core/commom/helpers/log_helpers.dart';
import 'package:vba/data/models/auth/signin_user_req.dart';
import 'package:vba/domain/usecase/user/signin.dart';
import 'package:vba/service_locator.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginState.empty()) {
    on<LoginSubmitEmailPasswordEvent>(_onLoginSubmitEmailPasswordEvent);
    on<LoginEmailChanged>(_onLoginEmailChanged);
    on<LoginPasswordChanged>(_onLoginPasswordChanged);
  }

   Future<void> _onLoginSubmitEmailPasswordEvent(
    LoginSubmitEmailPasswordEvent event,
    Emitter<LoginState> emit,
  ) async {
    LogHelper.debug(
      tag: "LoginBloc",
      message: 'Start _onLoginSubmitEmailPasswordEvent',
    );
    try {
      emit(LoginState.loading()); // Emit loading state while processing login.

      // Call authentication use case.
      final isSignedIn = await sl<SigninUseCase>().call(
        params: SigninUserReq(email: 'participant100@vba.net.vn', password: 'user@123A'),
      );

      // Handle authentication result.
      isSignedIn.fold(
        (l) {
          emit(LoginState.failure());
        },
        (r) {
          emit(LoginState.success());
        },
      );
    } catch (e) {
      LogHelper.error(
        tag: "LoginBloc",
        message: 'Error _onLoginSubmitEmailPasswordEvent: $e',
      );
      emit(LoginState.failure()); // Emit failure state in case of an exception.
    }
  }

  Future<void> _onLoginEmailChanged(
    LoginEmailChanged event,
    Emitter<LoginState> emit,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300)); // Debounce input
    // emit(state.update(isEmailValid: Validators.isValidEmail(event.email)));
    emit(state.update(isEmailValid: true));
  }

  Future<void> _onLoginPasswordChanged(
    LoginPasswordChanged event,
    Emitter<LoginState> emit,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300)); // Debounce input
    // emit( state.update(isPasswordValid: Validators.isValidPassword(event.password)));
    emit(state.update(isPasswordValid: true));
  }
}
