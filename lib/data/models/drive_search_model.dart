class DriveSearchResult {
  final int id;
  final String status;
  final String driveFolderId;
  final String driveName;
  final String driveUrl;
  final String createdAt;

  DriveSearchResult({
    required this.id,
    required this.status,
    required this.driveFolderId,
    required this.driveName,
    required this.driveUrl,
    required this.createdAt,
  });

  factory DriveSearchResult.fromJson(Map<String, dynamic> json) {
    return DriveSearchResult(
      id: json['id'] ?? 0,
      status: json['status'] ?? '',
      driveFolderId: json['drive_folder_id'] ?? '',
      driveName: json['drive_name'] ?? '',
      driveUrl: json['drive_url'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }

  bool get isCompleted => status == 'completed';
  bool get isProcessing => status == 'processing';
  bool get isFailed => status == 'failed';
}

class DriveSearchResponse {
  final List<DriveSearchResult> results;
  final String message;

  DriveSearchResponse({required this.results, required this.message});

  factory DriveSearchResponse.fromJson(Map<String, dynamic> json) {
    List<DriveSearchResult> results = [];
    if (json['data'] != null && json['data'] is List) {
      results = (json['data'] as List)
          .map((item) => DriveSearchResult.fromJson(item))
          .toList();
    }

    return DriveSearchResponse(
      results: results,
      message: json['message'] ?? '',
    );
  }
}
