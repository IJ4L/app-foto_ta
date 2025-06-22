import 'package:foto_ta/data/services/event_service.dart';

class BookmarkedPhotosModel {
  final int id;
  final String eventName;
  final String eventDate;
  final List<BookmarkedPhoto> bookmarkedPhotos;

  BookmarkedPhotosModel({
    required this.id,
    required this.eventName,
    required this.eventDate,
    required this.bookmarkedPhotos,
  });

  factory BookmarkedPhotosModel.fromJson(Map<String, dynamic> json) {
    try {
      return BookmarkedPhotosModel(
        id: json['event']?['id'] ?? 0,
        eventName: json['event_name'] ?? '',
        eventDate: json['event_date'] ?? '',
        bookmarkedPhotos: (json['bookmarked_photos'] as List<dynamic>?)
                ?.map((e) => BookmarkedPhoto.fromJson(e))
                .toList() ??
            [],
      );
    } catch (e) {
      print('❌ Error parsing BookmarkedPhotosModel: $e');
      print('❌ Input data: $json');
      return BookmarkedPhotosModel(
        id: 0,
        eventName: 'Unknown Event',
        eventDate: '',
        bookmarkedPhotos: [],
      );
    }
  }
}

class BookmarkedPhoto {
  final int id;
  final EventImage image;

  BookmarkedPhoto({
    required this.id,
    required this.image,
  });

  factory BookmarkedPhoto.fromJson(Map<String, dynamic> json) {
    try {
      return BookmarkedPhoto(
        id: json['id'] ?? 0,
        image: json['image'] != null
            ? EventImage.fromJson(json['image'])
            : EventImage(
                id: 0,
                url: 'https://via.placeholder.com/150?text=No+Image',
                createdAt: DateTime.now().toIso8601String(),
                fileName: 'unknown.jpg',
                idEvent: 0,
              ),
      );
    } catch (e) {
      print('❌ Error parsing BookmarkedPhoto: $e');
      print('❌ Input data: $json');
      return BookmarkedPhoto(
        id: 0,
        image: EventImage(
          id: 0,
          url: 'https://via.placeholder.com/150?text=Error',
          createdAt: DateTime.now().toIso8601String(),
          fileName: 'error.jpg',
          idEvent: 0,
        ),
      );
    }
  }
}

class BookmarkedPhotosResponse {
  final List<BookmarkedPhotosModel> data;

  BookmarkedPhotosResponse({
    required this.data,
  });

  factory BookmarkedPhotosResponse.fromJson(Map<String, dynamic> json) {
    try {
      if (json['data'] is List) {
        return BookmarkedPhotosResponse(
          data: (json['data'] as List<dynamic>)
              .map((e) => BookmarkedPhotosModel.fromJson(e))
              .toList(),
        );
      } else {
        // Handle case where data might be a single object
        return BookmarkedPhotosResponse(
          data: json['data'] != null
              ? [BookmarkedPhotosModel.fromJson(json['data'])]
              : [],
        );
      }
    } catch (e) {
      print('❌ Error parsing BookmarkedPhotosResponse: $e');
      print('❌ Input data: $json');
      return BookmarkedPhotosResponse(data: []);
    }
  }
}
