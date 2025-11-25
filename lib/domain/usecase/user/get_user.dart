

import 'package:fpdart/fpdart.dart';
import 'package:vba/core/usecase/usecase.dart';
import 'package:vba/domain/repository/auth/auth.dart';
import 'package:vba/service_locator.dart';

class GetUserUseCase implements UseCase<Either, dynamic> {
  @override
  Future<Either> call({params}) async {
    return await sl<AuthRepository>().getUser();
  }
}