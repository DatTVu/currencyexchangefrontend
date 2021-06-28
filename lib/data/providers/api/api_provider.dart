import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:currencyexchangeservice/data/providers/api/custom_exception.dart';
import 'package:http/http.dart' as http;

class ApiProvider {
  final String _baseUrl =
      "https://jq660phus7.execute-api.ap-southeast-1.amazonaws.com/prod/";

  Future<dynamic> get(String path) async {
    var responseJson;
    try {
      final uri = Uri.parse(_baseUrl + path);
      final response = await http.get(uri);
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> post(String path, Map<String, dynamic> data) async {
    var responseJson;
    try {
      final uri = Uri.parse(_baseUrl + path);
      final response = await http.post(uri, body: data);
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> put(String path, Map<String, dynamic> data) async {
    var responseJson;
    try {
      final uri = Uri.parse(_baseUrl + path);
      final response = await http.put(uri, body: data);
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> getWithToken(String path, String token) async {
    var responseJson;
    try {
      final uri = Uri.parse(_baseUrl + path);
      final response = await http.get(uri, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> postWithToken(
      String path, String token, Map<String, dynamic> data) async {
    var responseJson;
    try {
      final uri = Uri.parse(_baseUrl + path);
      final response = await http.post(uri,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(data));
      print(response);
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> putWithToken(
      String path, String token, Map<String, dynamic> data) async {
    var responseJson;
    try {
      final uri = Uri.parse(_baseUrl + path);
      final response = await http.put(uri,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(data));
      print(response);
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> deleteWithToken(String path, String token) async {
    var responseJson;
    try {
      final uri = Uri.parse(_baseUrl + path);
      final response = await http.delete(uri, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });
      print(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  dynamic _response(http.Response response) {
    var responseJson = json.decode(response.body.toString());
    switch (response.statusCode) {
      case 200:
        return responseJson;
      case 400:
        throw BadRequestException(responseJson["message"]);
      case 401:
        throw UnauthorizedException(responseJson["message"]);
      case 403:
        throw ForbiddenException(responseJson["message"]);
      case 404:
        throw NotFoundException(responseJson["message"]);
      case 500:
        throw InternalServerException(responseJson["message"]);
      case 503:
        throw ServiceUnavailableException(responseJson["message"]);
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
