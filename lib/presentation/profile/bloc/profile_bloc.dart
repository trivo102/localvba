import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vba/data/models/auth/user.dart';
import 'package:vba/domain/usecase/user/logout.dart';
import 'package:vba/domain/usecase/user/user_public.dart';
import 'package:vba/service_locator.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileState()) {
    on<ProfileEventStarted>(_profileEventStarted);
    on<ProfileEventLogout>(_profileEventLogout);
  }

  Future<void> _profileEventStarted(
    ProfileEventStarted event,
    Emitter<ProfileState> emit,
  ) async {
    final respose = await sl<UserPublicUseCase>().call();
    if (respose.isRight()) {
      final user = respose.getRight().toNullable();
      emit(ProfileState(user: user));
    }
  }

  Future<void> _profileEventLogout(
    ProfileEventLogout event,
    Emitter<ProfileState> emit,
  ) async {
    final response = await sl<LogoutUseCase>().call();
    if (response.isRight()) {
      emit(state.copyWith(isLoggedOut: true, user: null));
    }
  }
}
