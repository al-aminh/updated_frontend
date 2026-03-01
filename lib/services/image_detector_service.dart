
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../config/api_config.dart';
import '../models/picked_media.dart';

class ImageDetectorService {
  Future<Map<String, dynamic>> detect(PickedMedia media) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}/detect/image');

    final mime = media.mimeType.isNotEmpty ? media.mimeType : 'image/jpeg';
    final parts = mime.split('/');
    final contentType = MediaType(parts[0], parts.length > 1 ? parts[1] : 'jpeg');

    final req = http.MultipartRequest('POST', uri);

    if (kIsWeb) {
      final bytes = media.bytes;
      if (bytes == null) throw Exception('No bytes found for web upload.');

      req.files.add(
        http.MultipartFile.fromBytes(
          'file',
          bytes,
          filename: media.name,
          contentType: contentType,
        ),
      );
    } else {
      final file = media.file;
      if (file == null) throw Exception('No file found for non-web upload.');

      req.files.add(
        await http.MultipartFile.fromPath(
          'file',
          file.path,
          filename: media.name,
          contentType: contentType,
        ),
      );
    }

    final streamed = await req.send().timeout(const Duration(seconds: 60));
    final res = await http.Response.fromStream(streamed);

    if (res.statusCode >= 200 && res.statusCode < 300) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    throw Exception('Image detect failed: ${res.statusCode} ${res.body}');
  }
}