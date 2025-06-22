import 'package:foto_ta/data/models/activity_model.dart';
import 'package:foto_ta/data/models/bookmarked_photos_model.dart';
import 'package:foto_ta/data/services/activity_service.dart';

abstract class ActivityRepository {
  Future<List<ActivityModel>> getRecentActivities();
  Future<bool> bookmarkImages(List<int> imageIds, String accessToken);
  Future<BookmarkedPhotosResponse> getBookmarkedPhotos(String accessToken);
  Future<bool> deleteBookmarkedPhotos(List<int> imageIds, String accessToken);
}

class ActivityRepositoryImpl implements ActivityRepository {
  final ActivityService activityService;

  ActivityRepositoryImpl({required this.activityService});

  @override
  Future<List<ActivityModel>> getRecentActivities() async {
    try {
      return await activityService.getRecentActivities();
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }

  @override
  Future<bool> bookmarkImages(List<int> imageIds, String accessToken) async {
    try {
      return await activityService.bookmarkImages(imageIds, accessToken);
    } catch (e) {
      print('Repository error while bookmarking: $e');
      return false;
    }
  }

  @override
  Future<BookmarkedPhotosResponse> getBookmarkedPhotos(String accessToken) async {
    try {
      return await activityService.getBookmarkedPhotos(accessToken);
    } catch (e) {
      print('Repository error while fetching bookmarked photos: $e');
      throw Exception('Failed to get bookmarked photos: $e');
    }
  }

  @override
  Future<bool> deleteBookmarkedPhotos(List<int> imageIds, String accessToken) async {
    try {
      return await activityService.deleteBookmarkedPhotos(imageIds, accessToken);
    } catch (e) {
      print('Repository error while deleting bookmarked photos: $e');
      return false;
    }
  }
}
