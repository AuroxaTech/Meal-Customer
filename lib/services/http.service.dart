import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';

//import 'package:dio_http_cache_lts/dio_http_cache_lts.dart';
import 'package:mealknight/constants/api.dart';

// import 'package:mealknight/services/app.service.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

// import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'auth.service.dart';
import 'local_storage.service.dart';

class HttpService {
  BaseOptions? baseOptions;
  Dio? dio;
  SharedPreferences? prefs;

  Future<Map<String, String>> getHeaders() async {
    final userToken = await AuthServices.getAuthBearerToken();

    return {
      HttpHeaders.acceptHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $userToken",
      "lang": LocalizeAndTranslate.getLocale().languageCode,
    };
  }

  HttpService() {
    LocalStorageService.getPrefs();

    baseOptions = BaseOptions(
      baseUrl: Api.baseUrl,
      validateStatus: (status) {
        return status != null && status <= 500;
      },
      // connectTimeout: 300,
    );
    dio = Dio(baseOptions);
    //dio!.interceptors.add(getCacheManager().interceptor);
  }

  /*DioCacheManager getCacheManager() {
    return DioCacheManager(
      CacheConfig(
        baseUrl: host,
        defaultMaxAge: Duration(hours: 1),
      ),
    );
  }*/

  //

  getAPIRequest(String url) async {
    var headersWithAuth = await getHeaders();
    var request = http.Request('GET', Uri.parse(url));
    request.headers.addAll(headersWithAuth);
    http.StreamedResponse response = await request.send();
    return await response.stream.bytesToString();
  }

  postAPIRequest(String url, Map<dynamic, dynamic> body) async {
    var headersWithAuth = await getHeaders();

    var request = http.Request('POST', Uri.parse(url));
    request.body = jsonEncode(body);
    request.headers.addAll(headersWithAuth);
    http.StreamedResponse response = await request.send();
    return await response.stream.bytesToString();
  }

  putAPIRequest(String url, Map<dynamic, dynamic>? body) async {
    var headersWithAuth = await getHeaders();
    var request = http.Request('PUT', Uri.parse(url));
    request.body = jsonEncode(body);
    request.headers.addAll(headersWithAuth);
    http.StreamedResponse response = await request.send();
    return await response.stream.bytesToString();
  }

  deleteAPIRequest(String url) async {
    var headersWithAuth = await getHeaders();
    var request = http.Request('DELETE', Uri.parse(url));
    request.headers.addAll(headersWithAuth);
    http.StreamedResponse response = await request.send();
    return await response.stream.bytesToString();
  }

  //for get api calls
  Future<Response> get(String url,
      {Map<String, dynamic>? queryParameters,
      bool includeHeaders = true,
      String baseUrl = Api.baseUrl,
      Map<String, String>? headers}) async {
    //preparing the api uri/url
    String uri = "$baseUrl$url";
    print(uri);
    print(queryParameters);
    //preparing the post options if header is required
    final mOptions = includeHeaders
        ? Options(
            headers: headers ?? (await getHeaders()),
          )
        : null;

    Response response;

    print("${Api.baseUrl}$url");
    print("Headers: ${await getHeaders()}");
    try {
      response = await dio!.get(
        uri,
        options: mOptions,
        queryParameters: queryParameters,
      );
    } on DioException catch (error) {
      print("DioException");
      response = formatDioExecption(error);
    }
    print("Response $response");
    return response;
  }

  //for post api calls
  Future<Response> post(
    String url,{
    bool includeHeaders = true,
    String baseUrl = Api.baseUrl,
    Map<String, String>? headers,
    Object? body,
  }) async {
    //preparing the api uri/url
    String uri = "$baseUrl$url";
    print(uri);
    print(body);
    //preparing the post options if header is required
    final mOptions = includeHeaders
        ? Options(
            headers: headers ?? (await getHeaders()),
          )
        : null;

    Response response;
    try {
      response = await dio!.post(
        uri,
        data: body,
        options: mOptions,
      );
    } on DioException catch (error) {
      response = formatDioExecption(error);
    }

    return response;
  }

  //for post api calls with file upload
  Future<Response> postWithFiles(
    String url,
    body, {
    bool includeHeaders = true,
  }) async {
    //preparing the api uri/url
    String uri = "${Api.baseUrl}$url";
    //preparing the post options if header is required
    final mOptions = !includeHeaders
        ? null
        : Options(
            headers: await getHeaders(),
          );

    Response response;
    try {
      response = await dio!.post(
        uri,
        data: body is FormData ? body : FormData.fromMap(body),
        options: mOptions,
      );
    } on DioException catch (error) {
      response = formatDioExecption(error);
    }

    return response;
  }

  //for patch api calls
  Future<Response> patch(String url, Map<String, dynamic> body) async {
    String uri = "${Api.baseUrl}$url";
    Response response;

    try {
      response = await dio!.patch(
        uri,
        data: body,
        options: Options(
          headers: await getHeaders(),
        ),
      );
    } on DioException catch (error) {
      response = formatDioExecption(error);
    }

    return response;
  }

  //for delete api calls
  Future<Response> delete(
    String url,
  ) async {
    String uri = "${Api.baseUrl}$url";

    Response response;
    try {
      response = await dio!.delete(
        uri,
        options: Options(
          headers: await getHeaders(),
        ),
      );
    } on DioException catch (error) {
      response = formatDioExecption(error);
    }
    return response;
  }

  Response formatDioExecption(DioException ex) {
    var response = Response(requestOptions: ex.requestOptions);

    response.statusCode = 400;
    String? msg = response.statusMessage;

    try {
      if (ex.type == DioExceptionType.connectionTimeout) {
        msg =
            "Connection timeout. Please check your internet connection and try again"
                .tr();
      } else if (ex.type == DioExceptionType.sendTimeout) {
        msg =
            "Timeout. Please check your internet connection and try again".tr();
      } else if (ex.type == DioExceptionType.receiveTimeout) {
        msg =
            "Timeout. Please check your internet connection and try again".tr();
      } else if (ex.type == DioExceptionType.badResponse) {
        msg =
            "Connection timeout. Please check your internet connection and try again"
                .tr();
      } else {
        msg = "Please check your internet connection and try again".tr();
      }
      response.data = {"message": msg};
    } catch (error) {
      response.statusCode = 400;
      msg = "Please check your internet connection and try again".tr();
      response.data = {"message": msg};
    }

    throw msg;
  }

  //NEUTRALS
  Future<Response> getExternal(
    String url, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return dio!.get(
      url,
      queryParameters: queryParameters,
    );
  }
}
