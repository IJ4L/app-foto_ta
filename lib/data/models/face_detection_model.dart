class FacePosition {
  final int x;
  final int y;
  final int w;
  final int h;

  FacePosition({
    required this.x,
    required this.y,
    required this.w,
    required this.h,
  });

  factory FacePosition.fromJson(Map<String, dynamic> json) {
    return FacePosition(
      x: json['x'] ?? 0,
      y: json['y'] ?? 0,
      w: json['w'] ?? 0,
      h: json['h'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'x': x,
      'y': y,
      'w': w,
      'h': h,
    };
  }
}

class FaceDetectionResult {
  final int id;
  final String fileName;
  final String url;
  final int idEvent;
  final String createdAt;
  final FacePosition face;

  FaceDetectionResult({
    required this.id,
    required this.fileName,
    required this.url,
    required this.idEvent,
    required this.createdAt,
    required this.face,
  });

  factory FaceDetectionResult.fromJson(Map<String, dynamic> json) {
    return FaceDetectionResult(
      id: json['id'] ?? 0,
      fileName: json['file_name'] ?? '',
      url: json['url'] ?? '',
      idEvent: json['id_event'] ?? 0,
      createdAt: json['created_at'] ?? '',
      face: json['face'] != null
          ? FacePosition.fromJson(json['face'])
          : FacePosition(x: 0, y: 0, w: 0, h: 0),
    );
  }
}

class FaceDetectionResponse {
  final List<FaceDetectionResult> data;

  FaceDetectionResponse({required this.data});

  factory FaceDetectionResponse.fromJson(Map<String, dynamic> json) {
    List<FaceDetectionResult> results = [];
    
    if (json['data'] != null && json['data'] is List) {
      results = (json['data'] as List)
          .map((item) => FaceDetectionResult.fromJson(item))
          .toList();
    }

    return FaceDetectionResponse(data: results);
  }
}
