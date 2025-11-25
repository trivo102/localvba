import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vba/domain/usecase/user/get_user.dart';
import 'package:vba/service_locator.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(Unauthenticated()) {
    on<AppStarted>(_apAppStartedToState);
    on<LoggedIn>(_apLoggedInToState);
    on<SignOut>(_apLoggedOutToState);
  }

  AuthenticationState get initialState => Uninitialized();

  Future<void> _apAppStartedToState(
    AppStarted event,
    Emitter<AuthenticationState> emit,
  ) async {
    final user = await sl<GetUserUseCase>().call();
    emit(Unauthenticated());
    return;
    if (user.isRight()) {
      emit(Authenticated(user.toString()));
    } else {
      emit(Unauthenticated());
    }
  }

  Future<void> _apLoggedInToState(
    LoggedIn event,
    Emitter<AuthenticationState> emit,
  ) async {
    final user = await sl<GetUserUseCase>().call();
    emit(Authenticated(user.toString()));
  }

  Future<void> _apLoggedOutToState(
    SignOut event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(Unauthenticated());
  }
}
