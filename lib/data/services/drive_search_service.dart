import 'dart:convert';
import 'package:foto_ta/config/env_config.dart';
import 'package:foto_ta/data/models/drive_search_model.dart';
import 'package:http/http.dart' as http;

abstract class DriveSearchService {
  Future<DriveSearchResponse> searchDrive(String driveUrl, String accessToken);
  Future<DriveSearchResponse> getDriveSearches(String accessToken);
}

class DriveSearchServiceImpl implements DriveSearchService {
  final http.Client client;

  DriveSearchServiceImpl({required this.client});

  @override
  Future<DriveSearchResponse> searchDrive(
    String driveUrl,
    String accessToken,
  ) async {
    try {
      final url = Uri.parse('${EnvConfig.apiUrl}/drive-searches');

      final response = await client.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({'drive_url': driveUrl}),
      );

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 202) {
        final jsonData = jsonDecode(response.body);
        return DriveSearchResponse.fromJson(jsonData);
      } else {
        print(
          'Failed to search drive. Status code: ${response.statusCode}, Response: ${response.body}',
        );
        throw Exception('Failed to search drive: ${response.reasonPhrase}');
      }
    } catch (e, stackTrace) {
      print('Error searching drive: $e');
      print('Stack trace: $stackTrace');
      throw Exception('Error searching drive: $e');
    }
  }

  @override
  Future<DriveSearchResponse> getDriveSearches(String accessToken) async {
    try {
      final url = Uri.parse('${EnvConfig.apiUrl}/drive-searches');

      final response = await client.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return DriveSearchResponse.fromJson(jsonData);
      } else {
        print(
          'Failed to get drive searches. Status code: ${response.statusCode}, Response: ${response.body}',
        );
        throw Exception(
          'Failed to get drive searches: ${response.reasonPhrase}',
        );
      }
    } catch (e, stackTrace) {
      print('Error getting drive searches: $e');
      print('Stack trace: $stackTrace');
      throw Exception('Error getting drive searches: $e');
    }
  }
}
