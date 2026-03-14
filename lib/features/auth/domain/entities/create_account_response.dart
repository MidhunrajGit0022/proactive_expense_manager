import 'package:equatable/equatable.dart';

class CreateAccountResponse extends Equatable {
  final String status;
  final String token;

  const CreateAccountResponse({
    required this.status,
    required this.token,
  });

  @override
  List<Object?> get props => [status, token];
}
