import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mealknight/constants/api.dart';
import 'package:mealknight/models/api_response.dart';
import 'package:mealknight/services/firebase_token.service.dart';
import 'package:mealknight/services/http.service.dart';

class AuthRequest extends HttpService {
  //
  Future<ApiResponse> loginRequest({
    required String email,
    required String password,
  }) async {
    final apiResult = await post(
      Api.login,
      body:{
        "email": email,
        "password": password,
        "tokens": await FirebaseTokenService().getDeviceToken(),
      },
    );
    print({
      "email": email,
      "password": password,
      "tokens": await FirebaseTokenService().getDeviceToken(),
    });
    return ApiResponse.fromResponse(apiResult);
  }

  //
  Future<ApiResponse> qrLoginRequest({
    required String code,
  }) async {
    final apiResult = await post(
      Api.qrlogin,
      body:{
        "code": code,
        "tokens": await FirebaseTokenService().getDeviceToken(),
      },
    );

    return ApiResponse.fromResponse(apiResult);
  }

  //
  Future<ApiResponse> resetPasswordRequest({
    required String phone,
    required String password,
    String? firebaseToken,
    String? customToken,
  }) async {
    final apiResult = await post(
      Api.forgotPassword,
      body:{
        "phone": phone,
        "password": password,
        "firebase_id_token": firebaseToken,
        "verification_token": customToken,
      },
    );

    return ApiResponse.fromResponse(apiResult);
  }

  //
  Future<ApiResponse> registerRequest({
    File? photo,
    required String name,
    required String email,
    required String phone,
    required String countryCode,
    required String password,
    String code = "",
  }) async {
    final apiResult = await postWithFiles(
      Api.register,
      {
        "name": name,
        "email": email,
        "phone": phone,
        "country_code": countryCode,
        "password": password,
        "code": code,
        "role": "client",
        "tokens": await FirebaseTokenService().getDeviceToken(),
        "photo": photo != null
            ? await MultipartFile.fromFile(
                photo.path,
              )
            : null,
      },
    );
    var params = {
      "name": name,
      "email": email,
      "phone": phone,
      "country_code": countryCode,
      "password": password,
      "code": code,
      "role": "client",
      "tokens": await FirebaseTokenService().getDeviceToken(),
      "photo": photo != null
          ? await MultipartFile.fromFile(
              photo.path,
            )
          : null,
    };
    print("register params: ${params}");
    return ApiResponse.fromResponse(apiResult);
  }

  //
  Future<ApiResponse> logoutRequest() async {
    final apiResult = await get(Api.logout);
    return ApiResponse.fromResponse(apiResult);
  }

  //
  Future<ApiResponse> updateProfile({
    File? photo,
    String? name,
    String? email,
    String? phone,
    String? countryCode,
    String? squareupDefaultCardId,
  }) async {
    Map<String, dynamic> postData = {};
    postData["_method"] = "PUT";
    if (null != name) {
      postData["name"] = name;
    }
    if (null != email) {
      postData["email"] = email;
    }
    if (null != phone) {
      postData["phone"] = phone;
    }
    if (null != countryCode) {
      postData["country_code"] = countryCode;
    }
    if (null != squareupDefaultCardId) {
      postData["squareup_default_card_id"] = squareupDefaultCardId;
    }
    if (null != photo) {
      postData["photo"] = await MultipartFile.fromFile(
        photo.path,
      );
    }

    final apiResult = await postWithFiles(Api.updateProfile, postData);
    return ApiResponse.fromResponse(apiResult);
  }

  Future<ApiResponse> updatePassword({
    String? password,
    String? newPassword,
    String? newPasswordConfirmation,
  }) async {
    final apiResult = await post(
      Api.updatePassword,
      body:{
        "_method": "PUT",
        "password": password,
        "new_password": newPassword,
        "new_password_confirmation": newPasswordConfirmation,
      },
    );
    return ApiResponse.fromResponse(apiResult);
  }

  //
  Future<ApiResponse> verifyPhoneAccount(String phone) async {
    final apiResult = await get(
      Api.verifyPhoneAccount,
      queryParameters: {
        "phone": phone,
      },
    );

    return ApiResponse.fromResponse(apiResult);
  }

  Future<ApiResponse> sendOTP(String phoneNumber,
      {bool isLogin = false}) async {
    final apiResult = await post(
      Api.sendOtp,
      body:{
        "phone": phoneNumber,
        "is_login": isLogin,
      },
    );
    print('sendOTP data======${{
      "phone": phoneNumber,
      "is_login": isLogin,
    }}');
    final apiResponse = ApiResponse.fromResponse(apiResult);
    print('sendOTP apiResponse======${apiResponse.data}');
    if (apiResponse.allGood) {
      return apiResponse;
    } else {
      throw apiResponse.message ?? apiResponse;
    }
  }

  Future<ApiResponse> verifyOTP(String phoneNumber, String code,
      {bool isLogin = false}) async {
    print('verifyOTP body===============${{
      "phone": phoneNumber,
      "code": code,
      "is_login": isLogin,
      "tokens": await FirebaseTokenService().getDeviceToken(),
    }}');
    final apiResult = await post(
      Api.verifyOtp,
      body:{
        "phone": phoneNumber,
        "code": code,
        "is_login": isLogin,
        "tokens": await FirebaseTokenService().getDeviceToken(),
      },
    );
    final apiResponse = ApiResponse.fromResponse(apiResult);
    print('verifyOTP data===============${apiResponse.data}');
    print('verifyOTP message===============${apiResponse.message}');
    print('verifyOTP code===============${apiResponse.code}');
    if (apiResponse.allGood) {
      return apiResponse;
    } else {
      throw apiResponse.message ?? apiResponse;
    }
  }

//
  Future<ApiResponse> verifyFirebaseToken(
    String phoneNumber,
    String firebaseVerificationId,
  ) async {
    //
    final apiResult = await post(
      Api.verifyFirebaseOtp,
      body:{
        "phone": phoneNumber,
        "firebase_id_token": firebaseVerificationId,
      },
    );
    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      return apiResponse;
    } else {
      throw apiResponse.message ?? apiResponse;
    }
  }

  //
  Future<ApiResponse?> socialLogin(
    String email,
    String? firebaseVerificationId,
    String provider, {
    String? nonce,
    String? uid,
  }) async {
    //
    final apiResult = await post(
      Api.socialLogin,
      body:{
        "provider": provider,
        "email": email,
        "firebase_id_token": firebaseVerificationId,
        "nonce": nonce,
        "uid": uid,
        "tokens": await FirebaseTokenService().getDeviceToken(),
      },
    );
    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      return apiResponse;
    } else if (apiResponse.code == 401) {
      return null;
    } else {
      throw apiResponse.message!;
    }
  }

  Future<ApiResponse> deleteProfile({
    String? password,
    String? reason,
  }) async {
    final apiResult = await post(
      Api.accountDelete,
      body:{
        "_method": "DELETE",
        "password": password,
        "reason": reason,
      },
    );
    return ApiResponse.fromResponse(apiResult);
  }

  Future<ApiResponse> updateDeviceToken(String token) async {
    final apiResult = await post(
      Api.tokenSync,
      body:{
        "tokens": token,
      },
    );
    return ApiResponse.fromResponse(apiResult);
  }
}
