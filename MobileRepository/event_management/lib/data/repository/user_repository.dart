import 'package:dio/dio.dart';
import 'package:event_management/core/api_url/api_url.dart';
import 'package:event_management/data/core/http_service.dart';
import 'package:event_management/services/service.dart';

class UserRepositoryImpl implements UserRepository {
  final HttpService httpService;
  UserRepositoryImpl(this.httpService);

  @override
  Future<void> profileDetails() async {
    try {
      final Response response = await httpService.getData(
        ApiUrl.profileDetail,
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}
