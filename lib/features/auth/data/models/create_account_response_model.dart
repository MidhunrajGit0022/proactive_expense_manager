import 'package:dummyexpense/features/auth/domain/entities/create_account_response.dart';

class CreateAccountResponseModel extends CreateAccountResponse {
  const CreateAccountResponseModel({
    required super.status,
    required super.token,
  });

  factory CreateAccountResponseModel.fromJson(Map<String, dynamic> json) {
    return CreateAccountResponseModel(
      status: json['status'] as String? ?? '',
      token: json['token'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'token': token,
    };
  }
}
