import 'package:foto_ta/data/models/drive_search_model.dart';
import 'package:foto_ta/data/services/drive_search_service.dart';

abstract class DriveSearchRepository {
  Future<DriveSearchResponse> searchDrive(String driveUrl, String accessToken);
  Future<DriveSearchResponse> getDriveSearches(String accessToken);
}

class DriveSearchRepositoryImpl implements DriveSearchRepository {
  final DriveSearchService driveSearchService;

  DriveSearchRepositoryImpl({required this.driveSearchService});

  @override
  Future<DriveSearchResponse> searchDrive(
    String driveUrl,
    String accessToken,
  ) async {
    try {
      return await driveSearchService.searchDrive(driveUrl, accessToken);
    } catch (e) {
      print('Repository error while searching drive: $e');
      throw Exception('Failed to search drive: $e');
    }
  }

  @override
  Future<DriveSearchResponse> getDriveSearches(String accessToken) async {
    try {
      return await driveSearchService.getDriveSearches(accessToken);
    } catch (e) {
      print('Repository error while getting drive searches: $e');
      throw Exception('Failed to get drive searches: $e');
    }
  }
}
