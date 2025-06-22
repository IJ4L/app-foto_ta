import 'dart:io';
import 'package:dio/dio.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadHelper {
  static final Dio _dio = Dio();

  /// Downloads multiple images from URLs and saves them to the gallery
  /// Returns a map with URL as key and success status as value
  static Future<Map<String, bool>> downloadImages(
    List<String> imageUrls,
  ) async {
    Map<String, bool> results = {};

    // Check permissions
    if (!await _requestPermissions()) {
      return {for (var url in imageUrls) url: false};
    }

    for (String imageUrl in imageUrls) {
      try {
        // Get temp directory
        final tempDir = await getTemporaryDirectory();
        final fileName =
            '${DateTime.now().millisecondsSinceEpoch}_${imageUrl.split('/').last}';
        final path = '${tempDir.path}/$fileName';

        // Download file
        await _dio.download(
          imageUrl,
          path,
          onReceiveProgress: (received, total) {
            if (total != -1) {
              print(
                'Downloading ${(received / total * 100).toStringAsFixed(0)}%',
              );
            }
          },
        );

        // Save to gallery
        final result = await GallerySaver.saveImage(path, albumName: 'FotoTA');
        results[imageUrl] = result ?? false;

        // Delete the temp file
        final file = File(path);
        if (await file.exists()) {
          await file.delete();
        }
      } catch (e) {
        print('Error downloading $imageUrl: $e');
        results[imageUrl] = false;
      }
    }

    return results;
  }

  /// Downloads and saves a single image from a URL
  /// Returns true if successful, false otherwise
  static Future<bool> downloadAndSaveImage(String imageUrl) async {
    // Check permissions
    if (!await _requestPermissions()) {
      return false;
    }

    try {
      // Get temp directory
      final tempDir = await getTemporaryDirectory();
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${imageUrl.split('/').last}';
      final path = '${tempDir.path}/$fileName';

      // Download file
      await _dio.download(
        imageUrl,
        path,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            print(
              'Downloading ${(received / total * 100).toStringAsFixed(0)}%',
            );
          }
        },
      );

      // Save to gallery
      final result = await GallerySaver.saveImage(path, albumName: 'FotoTA');

      // Delete the temp file
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
      }

      return result ?? false;
    } catch (e) {
      print('Error downloading image: $e');
      return false;
    }
  }

  static Future<bool> _requestPermissions() async {
    if (Platform.isAndroid) {
      final status = await Permission.storage.request();
      return status.isGranted;
    } else if (Platform.isIOS) {
      final status = await Permission.photos.request();
      return status.isGranted;
    }
    return false;
  }
}
