class Owner {
  final int id;
  final String name;
  final String picture;

  Owner({required this.id, required this.name, required this.picture});

  factory Owner.fromJson(Map<String, dynamic> json) {
    return Owner(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      picture: json['picture'] as String? ?? '',
    );
  }
}

class ActivityModel {
  final int id;
  final String name;
  final String description;
  final String date;
  final String? link;
  final String? shareCode;
  final bool indexedByRobota;
  final String createdAt;
  final String updatedAt;
  final List<String> imagesPreview;
  final Owner? owner;

  ActivityModel({
    required this.id,
    required this.name,
    required this.description,
    required this.date,
    this.link,
    this.shareCode,
    required this.indexedByRobota,
    required this.createdAt,
    required this.updatedAt,
    required this.imagesPreview,
    this.owner,
  });
  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      date: json['date'] as String? ?? '',
      link: json['link'] as String?,
      shareCode: json['share_code'] as String?,
      indexedByRobota: json['indexed_by_robota'] as bool? ?? false,
      createdAt: json['created_at'] as String? ?? '',
      updatedAt: json['updated_at'] as String? ?? '',
      imagesPreview:
          (json['images_preview'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      owner: json['owner'] != null ? Owner.fromJson(json['owner']) : null,
    );
  }
}

class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;

  ApiResponse({required this.success, required this.message, this.data});

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) {
    return ApiResponse<T>(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'] != null ? fromJsonT(json['data']) : null,
    );
  }
}
