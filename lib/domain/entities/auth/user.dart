import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? id;
  final String? fullName;
  final String? email;
  final bool? isActive;
  final String? companyName;
  final String? role;
  final String? avatar;
  final String? appLogo;
  final String? createdAt;
  final String? subscription;

  const UserEntity({
    this.id,
    this.fullName,
    this.email,
    this.isActive,
    this.companyName,
    this.role,
    this.avatar,
    this.appLogo,
    this.createdAt,
    this.subscription,
  });

  @override
  List<Object?> get props => [
    id,
    fullName,
    email,
    isActive,
    companyName,
    role,
    avatar,
    appLogo,
    createdAt,
    subscription,
  ];
}
