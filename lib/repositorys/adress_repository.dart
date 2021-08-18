import 'package:dio/dio.dart';
import 'package:points_map/models/adress_model.dart';
import 'package:points_map/.env.dart';

class AdressRepository{
  static const String _baseUrl =
      'https://maps.googleapis.com/maps/api/geocode/json?';

  final Dio _dio;

  AdressRepository({Dio? dio}) : _dio = dio ?? Dio();


  Future<Adress?> getAdress({
    required String adress
  }) async {

    final response = await _dio.get(_baseUrl, queryParameters: {
      'address': '${adress.replaceAll(RegExp(r' '), '+')}',
      'key': googleAPIKey,
    });

    if (response.statusCode == 200) {
      return Adress.fromJson(response.data);
    }
    return null;
  }
}