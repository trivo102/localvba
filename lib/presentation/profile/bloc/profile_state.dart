part of 'profile_bloc.dart';

final class ProfileState extends Equatable {

  final UserModel? user;
  final bool isLoggedOut;

  const ProfileState({this.user, this.isLoggedOut = false});
  @override
  List<Object?> get props => [user, isLoggedOut];

  ProfileState copyWith({
    UserModel? user,
    bool? isLoggedOut,
  }) {
    return ProfileState(
      user: user ?? this.user,
      isLoggedOut: isLoggedOut ?? this.isLoggedOut,
    );
  }
}