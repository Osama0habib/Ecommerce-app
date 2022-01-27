
import 'package:dio/dio.dart';
import 'package:shop_app_mansour/shared/components/constants.dart';




class DioHelper {
  static late Dio dio;
  static init() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://student.valuxapps.com/api/',
        receiveDataWhenStatusError: true,

      ),
    );
  }

  static Future<Response> getData({
    required String url,
     Map<String, dynamic>? query,
    // String lang = 'en',
    String? token ,
  }) async {
    dio.options.headers ={
      'Content-Type': 'application/json',
      'lang' : appLanguage,
      'Authorization' : token,
      // 'force': true
    };
    return await dio.get(
      url,
      queryParameters: query,
    );
  }

  static Future<Response> postData({
    required String url,
    required Map<String, dynamic> data,
    Map<String, dynamic>? query,
    // String lang = 'en',
    String? token ,
  }) async {
    dio.options.headers = {
      'Content-Type': 'application/json',
      'lang' : appLanguage,
      'Authorization' : token
    };
    return await dio.post(
      url,
      queryParameters: query,
      data: data,
    );
  }

  static Future<Response> updateData({
    required String url,
    required Map<String, dynamic> data,
    Map<String, dynamic>? query,
    // String lang = 'en',
    String? token ,
  }) async {
    dio.options.headers = {

      'lang': appLanguage,
      'Content-Type': 'application/json',
      'Authorization': token,
      'User-Agent': 'PostmanRuntime/7.29.0',
      'Accept': '*/*',
      'Postman-Token': '072ab1ae-5e55-45ec-a9c8-820a340e63ab',
      'Host': 'student.valuxapps.com',
      'Accept-Encoding': 'gzip, deflate, br',
      'Connection': 'keep-alive',
      'Content-Length': 590,



    };
    return await dio.put(
      url,
      queryParameters: query,
      data: data,
    );
  }

  static Future<Response> updateUserData({
    required String url,
    required Map<String, dynamic> data,
    Map<String, dynamic>? query,
    // String lang = 'en',
    String? token ,
  }) async {
    dio.options.headers = {
      'Content-Type': 'application/json',
      'lang' : appLanguage,
      'Authorization' : token,

    };
    return await dio.put(
      url,
      queryParameters: query,
      data: data,
    );
  }

  static Future<Response> deleteData({
    required String url,
    required Map<String, dynamic> data,
    Map<String, dynamic>? query,
    // String lang = 'en',
    String? token ,
  }) async {
    dio.options.headers = {
      'Content-Type': 'application/json',
      'lang' : appLanguage,
      'Authorization' : token
    };
    return await dio.delete(
      url,
      queryParameters: query,
      data: data,
    );
  }

  static Future<Response> getMapPicture({
    zoom,
    String center = 'Cairo,Egypt' ,

  }) async {
    Dio googleDio  ;
   googleDio = Dio(
      BaseOptions(
        baseUrl: 'https://maps.googleapis.com/maps/api/',

      ),
    );
    return await googleDio.get(
      'staticmap',
      queryParameters: {
        'center' : center,
        'zoom' : zoom ,
        'size' :  '600x300',
        'maptype' : 'roadmap',
        'markers' : 'color:red%7Clabel:A%7C$center',
        'key' : googleApiKey ,

      },
    );
  }


  static Future<Response> postCartData({
    required String url,
    required Map<String, dynamic> data,
    Map<String, dynamic>? query,
    // String lang = 'en',
    String? token ,
  }) async {
    dio.options.headers = {
      'Content-Type': 'application/json',
      'lang' : appLanguage,
      'Authorization' : token,
      'User-Agent': 'PostmanRuntime/7.29.0',
      'Accept': '*/*',
      'Postman-Token': '072ab1ae-5e55-45ec-a9c8-820a340e63ab',
      'Host': 'student.valuxapps.com',
      'Accept-Encoding': 'gzip, deflate, br',
      'Connection': 'keep-alive',
      'Content-Length': 21,
    };
    return await dio.post(
      url,
      queryParameters: query,
      data: data,
    );
  }

}
