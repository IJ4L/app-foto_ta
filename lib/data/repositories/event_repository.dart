import 'package:foto_ta/data/models/face_detection_model.dart';
import 'package:foto_ta/data/services/event_service.dart';

class EventAccessResult {
  final bool success;
  final String message;
  final String? accessToken;
  final String? tokenType;

  EventAccessResult({
    required this.success,
    required this.message,
    this.accessToken,
    this.tokenType,
  });

  factory EventAccessResult.success(String accessToken, String tokenType) {
    return EventAccessResult(
      success: true,
      message: 'Access granted',
      accessToken: accessToken,
      tokenType: tokenType,
    );
  }

  factory EventAccessResult.failure(String message) {
    return EventAccessResult(success: false, message: message);
  }
}

class EventImagesResult {
  final bool success;
  final String message;
  final List<EventImage>? images;
  final int? totalPages;
  final int? currentPage;

  EventImagesResult({
    required this.success,
    required this.message,
    this.images,
    this.totalPages,
    this.currentPage,
  });

  factory EventImagesResult.success(
    List<EventImage> images,
    int totalPages,
    int currentPage,
  ) {
    return EventImagesResult(
      success: true,
      message: 'Images retrieved successfully',
      images: images,
      totalPages: totalPages,
      currentPage: currentPage,
    );
  }

  factory EventImagesResult.failure(String message) {
    return EventImagesResult(success: false, message: message);
  }
}

class FindFaceResult {
  final bool success;
  final String message;
  final List<FaceDetectionResult> faces;

  FindFaceResult({
    required this.success,
    required this.message,
    this.faces = const [],
  });

  factory FindFaceResult.success(List<FaceDetectionResult> faces) {
    return FindFaceResult(
      success: true,
      message: 'Faces detected successfully',
      faces: faces,
    );
  }

  factory FindFaceResult.failure(String message) {
    return FindFaceResult(success: false, message: message);
  }
}

abstract class EventRepository {
  Future<EventAccessResult> accessEvent(int eventId, String password);
  Future<EventImagesResult> getEventImages(
    int eventId,
    String accessToken, {
    int page = 1,
    int limit = 10,
  });
  Future<FindFaceResult> findMyFace(int eventId, String accessToken);
}

class EventRepositoryImpl implements EventRepository {
  final EventService _eventService;

  EventRepositoryImpl({required EventService eventService})
    : _eventService = eventService;

  @override
  Future<EventAccessResult> accessEvent(int eventId, String password) async {
    try {
      final response = await _eventService.accessEvent(eventId, password);
      return EventAccessResult.success(
        response.eventAccessToken,
        response.tokenType,
      );
    } catch (e) {
      return EventAccessResult.failure(
        e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  @override
  Future<EventImagesResult> getEventImages(
    int eventId,
    String accessToken, {
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await _eventService.getEventImages(
        eventId,
        accessToken,
        page: page,
        limit: limit,
      );

      return EventImagesResult.success(
        response.images,
        response.totalPages,
        response.currentPage,
      );
    } catch (e) {
      return EventImagesResult.failure(
        e.toString().replaceAll('Exception: ', ''),
      );
    }
  }
  @override
  Future<FindFaceResult> findMyFace(int eventId, String accessToken) async {
    try {
      final response = await _eventService.findMyFace(eventId, accessToken);
      return FindFaceResult.success(response.data);
    } catch (e) {
      return FindFaceResult.failure(e.toString().replaceAll('Exception: ', ''));
    }
  }
}
