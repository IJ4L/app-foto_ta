import 'dart:convert';
import 'package:foto_ta/config/env_config.dart';
import 'package:foto_ta/data/models/drive_search_detail_model.dart';
import 'package:http/http.dart' as http;
import 'package:logger/web.dart';

abstract class DriveSearchDetailService {
  Future<DriveSearchDetailResponse> fetchDriveSearchImages(
    int searchId,
    String accessToken,
  );
}

class DriveSearchDetailServiceImpl implements DriveSearchDetailService {
  final http.Client client;

  DriveSearchDetailServiceImpl({required this.client});
  @override
  Future<DriveSearchDetailResponse> fetchDriveSearchImages(
    int searchId,
    String accessToken,
  ) async {
    try {
      final url = Uri.parse('${EnvConfig.apiUrl}/drive-searches/$searchId');

      final response = await client.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      Logger().i(
        'Drive search detail request sent. URL: $url, Status code: ${response.statusCode}, Response: ${response.body}',
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return DriveSearchDetailResponse.fromJson(jsonData);
      } else {
        print(
          'Failed to fetch drive search images. Status code: ${response.statusCode}, Response: ${response.body}',
        );
        throw Exception(
          'Failed to fetch drive search images: ${response.reasonPhrase}',
        );
      }
    } catch (e, stackTrace) {
      print('Error fetching drive search images: $e');
      print('Stack trace: $stackTrace');
      throw Exception('Error fetching drive search images: $e');
    }
  }
}
