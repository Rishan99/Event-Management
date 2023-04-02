import 'package:dio/dio.dart';
import 'package:event_management/core/api_url/api_url.dart';
import 'package:event_management/data/core/http_service.dart';
import 'package:event_management/demoData.dart';
import 'package:event_management/model/user_model.dart';
import 'package:event_management/services/service.dart';

class UserRepositoryImpl implements UserRepository {
  final HttpService httpService;
  UserRepositoryImpl(this.httpService);

  @override
  Future<dynamic> profileDetails() async {
    try {
      await demoDelay();
      return UserModel(createdDate: DateTime.now().toIso8601String(), id: "1", name: 'Test', username: 'test@gmail.com').toMap();
      final data = await httpService.getData(
        ApiUrl.profileDetail,
      );
      return data;
    } catch (e) {
      rethrow;
    }
  }
}
