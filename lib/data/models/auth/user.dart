import 'package:vba/domain/entities/auth/user.dart';

class UserModel {
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
  final String? birthdate;
  final String? taxCode;
  final String? phone;
  final String? gender;
  final String? companyIndustry;
  final String? position;
  final String? companyPhone;
  final String? companyAddress;
  final String? companyUrl;
  final String? companyIntroduction;
  final String? productsAndServices;
  final List<String>? groupRoleNames;

  UserModel({
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
    this.birthdate,
    this.taxCode,
    this.phone,
    this.gender,
    this.companyIndustry,
    this.position,
    this.companyPhone,
    this.companyAddress,
    this.companyUrl,
    this.companyIntroduction,
    this.productsAndServices,
    this.groupRoleNames,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'] as String?,
    fullName: json['fullName'] as String?,
    email: json['email'] as String?,
    isActive: json['isActive'] as bool?,
    companyName: json['companyName'] as String?,
    role: json['role'] as String?,
    avatar: json['avatar'] as String?,
    appLogo: json['appLogo'] as String?,
    createdAt: json['createdAt'] as String?,
    subscription: json['subscription'] as String?,
    birthdate: json['birthdate'] as String?,
    taxCode: json['taxCode'] as String?,
    phone: json['phone'] as String?,
    gender: json['gender'] as String?,
    companyIndustry: json['companyIndustry'] as String?,
    position: json['position'] as String?,
    companyPhone: json['companyPhone'] as String?,
    companyAddress: json['companyAddress'] as String?,
    companyUrl: json['companyUrl'] as String?,
    companyIntroduction: json['companyIntroduction'] as String?,
    productsAndServices: json['productsAndServices'] as String?,
    groupRoleNames: (json['groupRoleNames'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'fullName': fullName,
    'email': email,
    'isActive': isActive,
    'companyName': companyName,
    'role': role,
    'avatar': avatar,
    'appLogo': appLogo,
    'createdAt': createdAt,
    'subscription': subscription,
    'birthdate': birthdate,
    'taxCode': taxCode,
    'phone': phone,
    'gender': gender,
    'companyIndustry': companyIndustry,
    'position': position,
    'companyPhone': companyPhone,
    'companyAddress': companyAddress,
    'companyUrl': companyUrl,
    'companyIntroduction': companyIntroduction,
    'productsAndServices': productsAndServices,
    'groupRoleNames': groupRoleNames,
  };
}

extension UserModelX on UserModel {
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      fullName: fullName,
      isActive: isActive,
      companyName: companyName,
      role: role,
      appLogo: appLogo,
      avatar: avatar,
      createdAt: createdAt,
      subscription: subscription,
    );
  }
}
