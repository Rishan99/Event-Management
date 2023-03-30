import 'package:event_management/model/user_model.dart';

import 'user_repository.dart';

class UserService {
  final UserRepository userRepository;
  UserService(this.userRepository);

  Future<UserModel> getProfileDetail() async {
    final data = await userRepository.profileDetails();
    return UserModel.fromMap(data);
  }
}
