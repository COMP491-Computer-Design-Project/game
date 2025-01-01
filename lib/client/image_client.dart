import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'api_client.dart';

class ImageClient {
  static final ImageClient _instance = ImageClient._internal();
  factory ImageClient() {
    return _instance;
  }

  ImageClient._internal();

  final String baseUrl = 'http://ec2-13-61-142-172.eu-north-1.compute.amazonaws.com:5000';

  Future<List<Image>> getImage(String movieName, String? message) async {
    final uri = Uri.parse('$baseUrl/image/generate');
    var completeMessage = '';
    if (message!=null){
      completeMessage = """
      Imagine a cinematic scene inspired by the movie '$movieName'. 
      The environment should be immersive and reflect the movie's unique theme, 
      whether it is futuristic, historical, magical, or realistic. 
      Include dynamic lighting, compelling characters, and intricate details in the setting 
      to capture the mood and essence of the film. 
      Make it visually dramatic and captivating, as though it's a still frame from an iconic moment in the movie.
      """;
    }else{
      completeMessage = """
      Imagine a cinematic scene inspired by the movie '$movieName'. 
      The scene should depict a moment where a character is $message. 
      The environment should be immersive and reflect the movie's unique theme, 
      whether it is futuristic, historical, magical, or realistic. 
      Include dynamic lighting, compelling characters, and intricate details in the setting 
      to capture the mood and essence of the film. 
      Make it visually dramatic and captivating, as though it's a still frame from an iconic moment in the movie.
      """;
    }
    print(completeMessage);
    final requestBody = jsonEncode({
      "prompt": completeMessage
    });

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: requestBody,
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final body = jsonDecode(response.body);

      if (body.containsKey('images') && body['images'] is List) {
        final List<String> imageUrls = List<String>.from(body['images']);
        final List<Image> images = [];

        for (final url in imageUrls) {
          try {
            print('Retrieving image from ${url}');
            final imageResponse = await http.get(Uri.parse(url));
            if (imageResponse.statusCode >= 200 && imageResponse.statusCode < 300) {
              final Uint8List imageData = imageResponse.bodyBytes;
              images.add(Image.memory(imageData));
            } else {
              throw ApiException(
                statusCode: imageResponse.statusCode,
                message: 'Failed to download image from $url',
              );
            }
          } catch (e) {
            throw ApiException(
              statusCode: 500,
              message: 'Error downloading image from $url',
              details: {'error': e.toString()},
            );
          }
        }
        return images;
      } else {
        throw ApiException(
          statusCode: 500,
          message: 'Invalid response format: missing or invalid "images" key',
          details: body,
        );
      }
    } else {
      final body = response.body.isNotEmpty ? jsonDecode(response.body) : {};
      throw ApiException(
        statusCode: response.statusCode,
        message: body['message'] ?? 'An unknown error occurred',
        details: body,
      );
    }
  }
}
