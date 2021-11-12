import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../configs/data_config.dart';
import '../../domain/core/exception.dart';
import 'storage_helper.dart';

class ApiHelper extends GetConnect {
  @override
  String get baseUrl => ApiConfig.prefixUrl;

  static Map<String, String> get headers => {
        "Content-type": "application/json",
        'Authorization': StorageHelper(StorageName.token).read(),
      };

  static getResponseResult<T>({required Response response, required T Function() onSuccess}) {
    final logger = Logger();

    if (response.status.isOk) {
      if (response.isOk) {
        logger.d('Status Code: ${response.statusCode}');
        logger.v(response.body);

        try {
          return onSuccess();
        } catch (e) {
          throw ServerException();
        }
      } else {
        logger.d('Status Code: ${response.statusCode}');
        logger.v(response.body);

        throw ServerException();
      }
    } else {
      logger.e(response.status.toString());

      throw ServerException();
    }
  }

  @override
  Future<Response<T>> get<T>(String url, {Map<String, String>? headers, String? contentType, Map<String, dynamic>? query, Decoder<T>? decoder}) async {
    Future<Response<T>> response = super.get(url, headers: headers, contentType: contentType, query: query, decoder: decoder);

    return response;
  }

  @override
  Future<Response<T>> post<T>(String? url, body, {String? contentType, Map<String, String>? headers, Map<String, dynamic>? query, Decoder<T>? decoder, Progress? uploadProgress}) {
    Future<Response<T>> response = super.post(url, body, headers: headers, contentType: contentType, query: query, decoder: decoder);

    return response;
  }

  @override
  Future<Response<T>> put<T>(String url, body, {String? contentType, Map<String, String>? headers, Map<String, dynamic>? query, Decoder<T>? decoder, Progress? uploadProgress}) {
    Future<Response<T>> response = super.put(url, body, headers: headers, contentType: contentType, query: query, decoder: decoder);

    return response;
  }

  @override
  Future<Response<T>> delete<T>(String url, {Map<String, String>? headers, String? contentType, Map<String, dynamic>? query, Decoder<T>? decoder}) {
    Future<Response<T>> response = super.delete(url, headers: headers, contentType: contentType, query: query, decoder: decoder);

    return response;
  }

  @override
  void onInit() {
    httpClient.baseUrl = baseUrl;
    httpClient.timeout = const Duration(seconds: 30);
  }
}
