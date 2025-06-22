import 'package:foto_ta/data/models/drive_search_detail_model.dart';
import 'package:foto_ta/data/services/drive_search_detail_service.dart';

abstract class DriveSearchDetailRepository {
  Future<List<DriveSearchImage>> fetchDriveSearchImages(
    int searchId,
    String accessToken,
  );
}

class DriveSearchDetailRepositoryImpl implements DriveSearchDetailRepository {
  final DriveSearchDetailService driveSearchDetailService;

  DriveSearchDetailRepositoryImpl({required this.driveSearchDetailService});

  @override
  Future<List<DriveSearchImage>> fetchDriveSearchImages(
    int searchId,
    String accessToken,
  ) async {
    try {
      final response = await driveSearchDetailService.fetchDriveSearchImages(
        searchId,
        accessToken,
      );

      return response.data.foundImages;
    } catch (e) {
      print('Repository error while fetching drive search images: $e');
      throw Exception('Failed to fetch drive search images: $e');
    }
  }
}
