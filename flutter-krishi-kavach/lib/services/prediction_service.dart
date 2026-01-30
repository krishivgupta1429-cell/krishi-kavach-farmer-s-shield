import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/prediction_result.dart';
import '../utils/constants.dart';

/// Service for handling plant disease prediction API calls
/// All AI logic is server-side; this service only handles communication
class PredictionService {
  /// Sends image to prediction API and returns result
  /// 
  /// [imageFile] - The leaf image file to analyze
  /// [metadata] - Optional metadata (crop, state, etc.) to improve accuracy
  /// 
  /// Returns [PredictionResult] with disease info or error
  static Future<PredictionResult> predictDisease({
    required File imageFile,
    Map<String, String>? metadata,
  }) async {
    try {
      // Validate file exists and is readable
      if (!await imageFile.exists()) {
        return PredictionResult.error('Image file not found. Please try again.');
      }
      
      // Check file size
      final fileSize = await imageFile.length();
      if (fileSize > ApiConstants.maxImageSize) {
        return PredictionResult.error(
          'Image is too large. Please use an image under 5MB.',
        );
      }
      
      // Create multipart request
      final uri = Uri.parse(ApiConstants.predictUrl);
      final request = http.MultipartRequest('POST', uri);
      
      // Add image file
      final imageBytes = await imageFile.readAsBytes();
      final multipartFile = http.MultipartFile.fromBytes(
        'image',
        imageBytes,
        filename: 'leaf_image.jpg',
      );
      request.files.add(multipartFile);
      
      // Add metadata if provided
      if (metadata != null) {
        metadata.forEach((key, value) {
          if (value.isNotEmpty) {
            request.fields[key] = value;
          }
        });
      }
      
      // Add headers
      request.headers['Accept'] = 'application/json';
      
      // Send request with timeout
      final streamedResponse = await request.send().timeout(
        ApiConstants.requestTimeout,
        onTimeout: () {
          throw TimeoutException('Request timed out. Please check your internet connection.');
        },
      );
      
      // Read response
      final response = await http.Response.fromStream(streamedResponse);
      
      // Handle response codes
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        
        final result = PredictionResult.fromJson(jsonResponse);
        
        // Check if it's a valid leaf
        if (!result.isLeaf) {
          return PredictionResult.notLeaf();
        }
        
        // Return result with image path
        return result.copyWith(imagePath: imageFile.path);
        
      } else if (response.statusCode == 400) {
        // Bad request - likely invalid image
        final errorBody = json.decode(response.body);
        return PredictionResult.error(
          errorBody['message'] ?? 'Invalid image format. Please upload a clear leaf photo.',
        );
        
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        return PredictionResult.error(
          'Authentication failed. Please restart the app and try again.',
        );
        
      } else if (response.statusCode == 429) {
        return PredictionResult.error(
          'Too many requests. Please wait a moment and try again.',
        );
        
      } else if (response.statusCode >= 500) {
        return PredictionResult.error(
          'Server is temporarily unavailable. Please try again later.',
        );
        
      } else {
        return PredictionResult.error(
          'Unexpected error (${response.statusCode}). Please try again.',
        );
      }
      
    } on SocketException {
      return PredictionResult.error(
        'No internet connection. Please check your network and try again.',
      );
      
    } on TimeoutException {
      return PredictionResult.error(
        'Request timed out. Please check your internet connection and try again.',
      );
      
    } on FormatException {
      return PredictionResult.error(
        'Invalid response from server. Please try again later.',
      );
      
    } catch (e) {
      return PredictionResult.error(
        'Something went wrong: ${e.toString()}',
      );
    }
  }
  
  /// Check if the API server is reachable
  static Future<bool> checkApiHealth() async {
    try {
      final uri = Uri.parse('${ApiConstants.baseUrl}/health');
      final response = await http.get(uri).timeout(
        const Duration(seconds: 5),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}

/// Custom exception for prediction errors
class PredictionException implements Exception {
  final String message;
  final String? code;
  
  PredictionException(this.message, {this.code});
  
  @override
  String toString() => message;
}
