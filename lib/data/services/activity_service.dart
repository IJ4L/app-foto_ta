import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:foto_ta/config/env_config.dart';
import 'package:foto_ta/data/models/activity_model.dart';
import 'package:foto_ta/data/models/bookmarked_photos_model.dart';

abstract class ActivityService {
  Future<List<ActivityModel>> getRecentActivities();
  Future<bool> bookmarkImages(List<int> imageIds, String accessToken);
  Future<BookmarkedPhotosResponse> getBookmarkedPhotos(String accessToken);
  Future<bool> deleteBookmarkedPhotos(List<int> imageIds, String accessToken);
}

class ActivityServiceImpl implements ActivityService {
  final http.Client client;

  ActivityServiceImpl({required this.client});

  @override
  Future<List<ActivityModel>> getRecentActivities() async {
    try {
      final url = Uri.parse('${EnvConfig.apiUrl}/activity/me/recent');

      final response = await client.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${EnvConfig.authToken}',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData is List) {
          return jsonData.map((item) => ActivityModel.fromJson(item)).toList();
        } else if (jsonData is Map<String, dynamic> &&
            jsonData.containsKey('data')) {
          final dataField = jsonData['data'];
          if (dataField is List) {
            return dataField
                .map((item) => ActivityModel.fromJson(item))
                .toList();
          }
        }

        print('Unexpected API response structure: $jsonData');
        return [];
      } else {
        throw Exception(
          'Failed to load recent activities: ${response.statusCode}',
        );
      }
    } catch (e, stackTrace) {
      print('Error fetching recent activities: $e');
      print('Stack trace: $stackTrace');
      throw Exception('Error fetching recent activities: $e');
    }
  }

  @override
  Future<bool> bookmarkImages(List<int> imageIds, String accessToken) async {
    try {
      final url = Uri.parse('${EnvConfig.apiUrl}/fotota');

      final response = await client.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${EnvConfig.authToken}',
        },
        body: jsonEncode({'image_ids': imageIds}),
      );


      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        print(
          'Failed to bookmark images. Status code: ${response.statusCode}, Response: ${response.body}',
        );
        return false;
      }
    } catch (e, stackTrace) {
      print('Error bookmarking images: $e');
      print('Stack trace: $stackTrace');
      return false;
    }
  }

  @override
  Future<BookmarkedPhotosResponse> getBookmarkedPhotos(String accessToken) async {
    try {
      final url = Uri.parse('${EnvConfig.apiUrl}/fotota');

      final response = await client.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${EnvConfig.authToken}',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        
        return BookmarkedPhotosResponse.fromJson(jsonData);
      } else {
        print(
          'Failed to fetch bookmarked photos. Status code: ${response.statusCode}, Response: ${response.body}',
        );
        throw Exception('Failed to fetch bookmarked photos: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      print('Error fetching bookmarked photos: $e');
      print('Stack trace: $stackTrace');
      throw Exception('Error fetching bookmarked photos: $e');
    }
  }

  @override
  Future<bool> deleteBookmarkedPhotos(List<int> imageIds, String accessToken) async {
    try {
      if (imageIds.isEmpty) {
        return false;
      }

      // Build URL with query parameters
      final queryParams = imageIds.map((id) => 'ids=$id').join('&');
      final url = Uri.parse('${EnvConfig.apiUrl}/fotota?$queryParams');

      final response = await client.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${EnvConfig.authToken}',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        print(
          'Failed to delete bookmarked photos. Status code: ${response.statusCode}, Response: ${response.body}',
        );
        return false;
      }
    } catch (e, stackTrace) {
      print('Error deleting bookmarked photos: $e');
      print('Stack trace: $stackTrace');
      return false;
    }
  }
}
