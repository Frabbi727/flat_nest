import 'user_model.dart';

class RegistrationStepResponse {
  final UserModel user;
  final int registrationStep;

  const RegistrationStepResponse({
    required this.user,
    required this.registrationStep,
  });

  factory RegistrationStepResponse.fromJson(Map<String, dynamic> json) {
    return RegistrationStepResponse(
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      registrationStep: json['registration_step'] as int,
    );
  }
}
