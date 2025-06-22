class FaceCoordinates {
  final int x;
  final int y;
  final int w;
  final int h;

  FaceCoordinates({
    required this.x,
    required this.y,
    required this.w,
    required this.h,
  });

  factory FaceCoordinates.fromJson(Map<String, dynamic> json) {
    return FaceCoordinates(
      x: json['x'] ?? 0,
      y: json['y'] ?? 0,
      w: json['w'] ?? 0,
      h: json['h'] ?? 0,
    );
  }
}

class DriveSearchImage {
  final int id;
  final String imageUrl;
  final FaceCoordinates? faceCoords;
  final double similarity;
  final String createdAt;

  DriveSearchImage({
    required this.id,
    required this.imageUrl,
    this.faceCoords,
    required this.similarity,
    required this.createdAt,
  });

  factory DriveSearchImage.fromJson(Map<String, dynamic> json) {
    return DriveSearchImage(
      id: json['id'] ?? 0,
      imageUrl: json['url'] ?? '',
      faceCoords: json['face_coords'] != null
          ? FaceCoordinates.fromJson(json['face_coords'])
          : null,
      similarity: json['similarity'] != null
          ? json['similarity'].toDouble()
          : 0.0,
      createdAt: json['created_at'] ?? '',
    );
  }
}

class DriveSearchDetail {
  final int id;
  final String status;
  final String driveFolderId;
  final String driveName;
  final String driveUrl;
  final String createdAt;
  final List<DriveSearchImage> foundImages;

  DriveSearchDetail({
    required this.id,
    required this.status,
    required this.driveFolderId,
    required this.driveName,
    required this.driveUrl,
    required this.createdAt,
    required this.foundImages,
  });

  factory DriveSearchDetail.fromJson(Map<String, dynamic> json) {
    List<DriveSearchImage> images = [];

    if (json['found_images'] != null && json['found_images'] is List) {
      images = (json['found_images'] as List)
          .map((item) => DriveSearchImage.fromJson(item))
          .toList();
    }

    return DriveSearchDetail(
      id: json['id'] ?? 0,
      status: json['status'] ?? '',
      driveFolderId: json['drive_folder_id'] ?? '',
      driveName: json['drive_name'] ?? '',
      driveUrl: json['drive_url'] ?? '',
      createdAt: json['created_at'] ?? '',
      foundImages: images,
    );
  }
}

class DriveSearchDetailResponse {
  final DriveSearchDetail data;
  final String message;

  DriveSearchDetailResponse({required this.data, required this.message});

  factory DriveSearchDetailResponse.fromJson(Map<String, dynamic> json) {
    return DriveSearchDetailResponse(
      data: DriveSearchDetail.fromJson(json['data'] ?? {}),
      message: json['message'] ?? '',
    );
  }
}
