/// Model representing the prediction result from the AI API
class PredictionResult {
  /// Whether the uploaded image is a valid leaf
  final bool isLeaf;
  
  /// Detected crop name (e.g., "Tomato", "Rice")
  final String crop;
  
  /// Detected disease name (e.g., "Early Blight", "Healthy")
  final String disease;
  
  /// Confidence score (0.0 to 1.0)
  final double confidence;
  
  /// List of remedy suggestions
  final List<String> remedies;
  
  /// Image path (local file path of the scanned image)
  final String? imagePath;
  
  /// Timestamp when the scan was performed
  final DateTime? scannedAt;
  
  /// Optional error message if prediction failed
  final String? errorMessage;
  
  PredictionResult({
    required this.isLeaf,
    required this.crop,
    required this.disease,
    required this.confidence,
    required this.remedies,
    this.imagePath,
    this.scannedAt,
    this.errorMessage,
  });
  
  /// Create from JSON response
  factory PredictionResult.fromJson(Map<String, dynamic> json) {
    return PredictionResult(
      isLeaf: json['is_leaf'] as bool? ?? false,
      crop: json['crop'] as String? ?? 'Unknown',
      disease: json['disease'] as String? ?? 'Unknown',
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
      remedies: (json['remedies'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ?? [],
      imagePath: json['image_path'] as String?,
      scannedAt: json['scanned_at'] != null 
          ? DateTime.parse(json['scanned_at'] as String)
          : null,
      errorMessage: json['error_message'] as String?,
    );
  }
  
  /// Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'is_leaf': isLeaf,
      'crop': crop,
      'disease': disease,
      'confidence': confidence,
      'remedies': remedies,
      'image_path': imagePath,
      'scanned_at': scannedAt?.toIso8601String(),
      'error_message': errorMessage,
    };
  }
  
  /// Create a copy with optional new values
  PredictionResult copyWith({
    bool? isLeaf,
    String? crop,
    String? disease,
    double? confidence,
    List<String>? remedies,
    String? imagePath,
    DateTime? scannedAt,
    String? errorMessage,
  }) {
    return PredictionResult(
      isLeaf: isLeaf ?? this.isLeaf,
      crop: crop ?? this.crop,
      disease: disease ?? this.disease,
      confidence: confidence ?? this.confidence,
      remedies: remedies ?? this.remedies,
      imagePath: imagePath ?? this.imagePath,
      scannedAt: scannedAt ?? this.scannedAt,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
  
  /// Get confidence as percentage string
  String get confidencePercent => '${(confidence * 100).toStringAsFixed(1)}%';
  
  /// Check if this is a healthy plant (no disease)
  bool get isHealthy => disease.toLowerCase() == 'healthy';
  
  /// Create an error result
  factory PredictionResult.error(String message) {
    return PredictionResult(
      isLeaf: false,
      crop: '',
      disease: '',
      confidence: 0.0,
      remedies: [],
      errorMessage: message,
    );
  }
  
  /// Create a "not a leaf" result
  factory PredictionResult.notLeaf() {
    return PredictionResult(
      isLeaf: false,
      crop: '',
      disease: '',
      confidence: 0.0,
      remedies: [],
      errorMessage: 'The uploaded image does not appear to be a plant leaf. Please try again with a clear leaf photo.',
    );
  }
  
  @override
  String toString() {
    return 'PredictionResult(crop: $crop, disease: $disease, confidence: $confidencePercent)';
  }
}
