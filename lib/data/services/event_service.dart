import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:foto_ta/config/env_config.dart';
import 'package:foto_ta/data/models/face_detection_model.dart';

class EventAccessResponse {
  final String eventAccessToken;
  final String tokenType;

  EventAccessResponse({
    required this.eventAccessToken,
    required this.tokenType,
  });

  factory EventAccessResponse.fromJson(Map<String, dynamic> json) {
    return EventAccessResponse(
      eventAccessToken: json['data']['event_access_token'],
      tokenType: json['data']['token_type'],
    );
  }
}

class EventImage {
  final int id;
  final String url;
  final String createdAt;
  final String fileName;
  final int idEvent;

  EventImage({
    required this.id,
    required this.url,
    required this.createdAt,
    required this.fileName,
    required this.idEvent,
  });
  factory EventImage.fromJson(Map<String, dynamic> json) {
    try {
      print('🖼️ Parsing EventImage: $json');

      int id = 0;
      String url = '';
      String createdAt = '';
      String fileName = '';
      int idEvent = 0;

      try {
        if (json['id'] != null) {
          id = json['id'] is int
              ? json['id']
              : int.parse(json['id'].toString());
        }
      } catch (e) {
        print('⚠️ Error parsing id, using default: $e');
        id = 0;
      }

      try {
        if (json['url'] != null) {
          url = json['url'].toString();
        } else {
          print('⚠️ No URL found in image data');
          url = 'https://via.placeholder.com/150?text=No+Image';
        }
      } catch (e) {
        print('⚠️ Error parsing url: $e');
        url = 'https://via.placeholder.com/150?text=Error';
      }

      try {
        if (json['created_at'] != null) {
          createdAt = json['created_at'].toString();
        } else {
          createdAt = DateTime.now().toIso8601String();
        }
      } catch (e) {
        print('⚠️ Error parsing created_at: $e');
        createdAt = DateTime.now().toIso8601String();
      }

      try {
        if (json['file_name'] != null) {
          fileName = json['file_name'].toString();
        } else {
          fileName = url.split('/').last;
        }
      } catch (e) {
        print('⚠️ Error parsing file_name: $e');
        fileName = 'unknown.jpg';
      }

      try {
        if (json['id_event'] != null) {
          idEvent = json['id_event'] is int
              ? json['id_event']
              : int.parse(json['id_event'].toString());
        }
      } catch (e) {
        print('⚠️ Error parsing id_event: $e');
        idEvent = 0;
      }

      return EventImage(
        id: id,
        url: url,
        createdAt: createdAt,
        fileName: fileName,
        idEvent: idEvent,
      );
    } catch (e) {
      print('❌ Fatal error in EventImage.fromJson: $e');
      print('❌ Input data: $json');

      return EventImage(
        id: 0,
        url: 'https://via.placeholder.com/150?text=Error',
        createdAt: DateTime.now().toIso8601String(),
        fileName: 'error.jpg',
        idEvent: 0,
      );
    }
  }
}

class EventImagesResponse {
  final List<EventImage> images;
  final int totalPages;
  final int currentPage;

  EventImagesResponse({
    required this.images,
    required this.totalPages,
    required this.currentPage,
  });
  factory EventImagesResponse.fromJson(Map<String, dynamic> json) {
    print('🔍 Parsing EventImagesResponse: ${json.keys}');
    print('📄 Response structure check...');

    final data = json['data'];

    if (data == null) {
      print('⚠️ Warning: No data section found in API response');
      print('⚠️ Full JSON: $json');
      return EventImagesResponse(images: [], totalPages: 1, currentPage: 1);
    }

    print('📦 Data section keys: ${data.keys.toList()}');

    int totalPages = 1;
    int currentPage = 1;

    try {
      if (data['total_pages'] != null) {
        totalPages = data['total_pages'] is int
            ? data['total_pages']
            : int.parse(data['total_pages'].toString());
      }

      if (data['current_page'] != null) {
        currentPage = data['current_page'] is int
            ? data['current_page']
            : int.parse(data['current_page'].toString());
      }

      print(
        '📊 Pagination - Total Pages: $totalPages, Current Page: $currentPage',
      );
    } catch (e) {
      print('⚠️ Error parsing pagination: $e');
    }

    List<EventImage> images = [];

    try {
      List<dynamic>? imagesJson;

      if (data['items'] != null && data['items'] is List) {
        imagesJson = data['items'] as List;
      } else if (data['images'] != null && data['images'] is List) {
        imagesJson = data['images'] as List;
      } else if (data['data'] != null && data['data'] is List) {
        imagesJson = data['data'] as List;
      }

      if (imagesJson == null) {
        print('⚠️ Could not find image array in response');
        print('⚠️ Available fields: ${data.keys.toList()}');
      } else {
        print('🖼️ Found images array with ${imagesJson.length} items');

        for (var imageJson in imagesJson) {
          try {
            if (imageJson is Map<String, dynamic>) {
              final image = EventImage.fromJson(imageJson);
              images.add(image);
            } else {
              print('⚠️ Image data is not a map: $imageJson');
            }
          } catch (e) {
            print('⚠️ Error parsing image: $e');
            print('⚠️ Image data: $imageJson');
          }
        }
      }
    } catch (e) {
      print('❌ Critical error parsing images array: $e');
    }


    return EventImagesResponse(
      images: images,
      totalPages: totalPages,
      currentPage: currentPage,
    );
  }
}

abstract class EventService {
  Future<EventAccessResponse> accessEvent(int eventId, String password);
  Future<EventImagesResponse> getEventImages(
    int eventId,
    String accessToken, {
    int page = 1,
    int limit = 10,
  });
  Future<FaceDetectionResponse> findMyFace(int eventId, String accessToken);
}

class EventServiceImpl implements EventService {
  final http.Client _client;

  EventServiceImpl({http.Client? client}) : _client = client ?? http.Client();

  @override
  Future<EventAccessResponse> accessEvent(int eventId, String password) async {
    final url = '${EnvConfig.apiUrl}/events/$eventId/access';
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${EnvConfig.authToken}',
    };

    try {
      final response = await _client.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode({'password': password}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return EventAccessResponse.fromJson(data);
      } else {
        String errorMessage;
        try {
          final Map<String, dynamic> errorData = jsonDecode(response.body);
          errorMessage = errorData['message'] ?? 'Failed to access event';
        } catch (_) {
          errorMessage = 'Failed to access event';
        }
        throw Exception(errorMessage);
      }
    } catch (e) {
      throw Exception('Error accessing event: ${e.toString()}');
    }
  }

  @override
  Future<EventImagesResponse> getEventImages(
    int eventId,
    String accessToken, {
    int page = 1,
    int limit = 10,
  }) async {
    final url =
        '${EnvConfig.apiUrl}/events/$eventId/images?page=$page&limit=50&sort_by=created_at&sort_order=desc';
    final headers = {'Authorization': 'Bearer $accessToken'};

    try {
      final response = await _client.get(Uri.parse(url), headers: headers);


      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        final result = EventImagesResponse.fromJson(data);

        return result;
      } else {
        String errorMessage;
        try {
          final Map<String, dynamic> errorData = jsonDecode(response.body);
          errorMessage = errorData['message'] ?? 'Failed to get event images';
        } catch (_) {
          errorMessage = 'Failed to get event images';
        }
        throw Exception(errorMessage);
      }
    } catch (e) {
      throw Exception('Error getting event images: ${e.toString()}');
    }
  }

  @override
  Future<FaceDetectionResponse> findMyFace(
    int eventId,
    String accessToken,
  ) async {
    final url = '${EnvConfig.apiUrl}/events/$eventId/find-my-face';
    final headers = {'Authorization': 'Bearer ${EnvConfig.authToken}'};

    try {
      final response = await _client.get(Uri.parse(url), headers: headers);
      print('🔍 Finding my face in event $eventId with token $accessToken');
      print('📄 Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return FaceDetectionResponse.fromJson(data);
      } else {
        String errorMessage;
        try {
          final Map<String, dynamic> errorData = jsonDecode(response.body);
          errorMessage = errorData['message'] ?? 'Failed to find faces';
        } catch (_) {
          errorMessage = 'Failed to find faces';
        }
        throw Exception(errorMessage);
      }
    } catch (e) {
      throw Exception('Error finding faces: ${e.toString()}');
    }
  }
}
