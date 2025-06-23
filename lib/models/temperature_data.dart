class TemperatureData {
  final double temperature;
  final DateTime timestamp;
  final String city;
  final String? description;

  TemperatureData({
    required this.temperature,
    required this.timestamp,
    required this.city,
    this.description,
  });

  String get formattedTemperature => '${temperature.toStringAsFixed(1)}°C';
  
  String get formattedTime {
    return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
  }

  String get temperatureStatus {
    if (temperature < 18) return 'Frio';
    if (temperature < 25) return 'Agradável';
    if (temperature < 30) return 'Quente';
    return 'Muito Quente';
  }

  Map<String, dynamic> toJson() {
    return {
      'temperature': temperature,
      'timestamp': timestamp.toIso8601String(),
      'city': city,
      'description': description,
    };
  }

  factory TemperatureData.fromJson(Map<String, dynamic> json) {
    return TemperatureData(
      temperature: json['temperature'].toDouble(),
      timestamp: DateTime.parse(json['timestamp']),
      city: json['city'],
      description: json['description'],
    );
  }
}
