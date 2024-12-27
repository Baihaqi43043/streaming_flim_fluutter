import 'package:video_thumbnail/video_thumbnail.dart';
import 'dart:typed_data';

class VideoService {
  Future<Uint8List?> generateThumbnail(String videoUrl) async {
    try {
      return await VideoThumbnail.thumbnailData(
        video: videoUrl,
        imageFormat: ImageFormat.JPEG, // Format thumbnail
        maxHeight: 150, // Tinggi maksimum gambar
        quality: 75, // Kualitas gambar (1-100)
      );
    } catch (e) {
      print('Error generating thumbnail: $e');
      return null; // Jika gagal, kembalikan null
    }
  }
}
