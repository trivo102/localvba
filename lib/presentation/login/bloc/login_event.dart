part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginEmailChanged extends LoginEvent {
  final String email;

  const LoginEmailChanged({required this.email});

  @override
  List<Object> get props => [email];

  @override
  String toString() {
    return 'LoginEmailChanged{email: $email}';
  }
}

class LoginPasswordChanged extends LoginEvent {
  final String password;

  const LoginPasswordChanged({required this.password});

  @override
  List<Object> get props => [password];

  @override
  String toString() {
    return 'LoginPasswordChanged{password: $password}';
  }
}


class LoginSubmitEmailPasswordEvent extends LoginEvent {
  final String email;
  final String password;

  const LoginSubmitEmailPasswordEvent({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}