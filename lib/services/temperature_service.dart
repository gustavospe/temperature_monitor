import 'dart:async';
import 'dart:isolate';
import 'dart:math';
import '../models/temperature_data.dart';

class TemperatureService {
  static final TemperatureService _instance = TemperatureService._internal();
  factory TemperatureService() => _instance;
  TemperatureService._internal();

  final Random _random = Random();
  StreamController<TemperatureData>? _temperatureStreamController;
  Timer? _timer;
  List<double> temperatureHistory = [];
  double? _currentTemperature;

  Stream<TemperatureData> get temperatureStream => 
      _temperatureStreamController?.stream ?? Stream.empty();

  Future<double> loadInitialTemperature() async {
    // Simula delay de carregamento
    await Future.delayed(Duration(seconds: 2));
    
    // Simula temperatura inicial entre 15°C e 35°C
    double temperature = 15 + _random.nextDouble() * 20;
    _currentTemperature = temperature;
    temperatureHistory.add(temperature);
    
    return temperature;
  }

  void startTemperatureStream() {
    _temperatureStreamController?.close();
    _temperatureStreamController = StreamController<TemperatureData>.broadcast();
    
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      if (_currentTemperature != null) {
        // Simula variação de temperatura (-2°C a +2°C)
        double variation = -2 + _random.nextDouble() * 4;
        double newTemperature = _currentTemperature! + variation;
        
        // Mantém temperatura entre 10°C e 40°C
        newTemperature = newTemperature.clamp(10.0, 40.0);
        
        _currentTemperature = newTemperature;
        temperatureHistory.add(newTemperature);
        
        // Mantém apenas os últimos 20 valores
        if (temperatureHistory.length > 20) {
          temperatureHistory.removeAt(0);
        }
        
        final temperatureData = TemperatureData(
          temperature: newTemperature,
          timestamp: DateTime.now(),
          city: 'São Paulo',
        );
        
        _temperatureStreamController?.add(temperatureData);
      }
    });
  }

  Future<double> calculateAverageWithIsolate() async {
    if (temperatureHistory.isEmpty) return 0.0;

    final receivePort = ReceivePort();
    final isolate = await Isolate.spawn(_calculateAverageInIsolate, receivePort.sendPort);
    
    SendPort? sendPort;
    final completer = Completer<double>();
    
    receivePort.listen((data) {
      if (data is SendPort) {
        sendPort = data;
        sendPort!.send(temperatureHistory);
      } else if (data is double) {
        completer.complete(data);
        isolate.kill();
        receivePort.close();
      }
    });
    
    return completer.future;
  }

  static void _calculateAverageInIsolate(SendPort sendPort) {
    final receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);
    
    receivePort.listen((data) {
      if (data is List<double>) {
        // Simula cálculo pesado
        double sum = 0;
        for (int i = 0; i < 1000000; i++) {
          for (double temp in data) {
            sum += temp * 0.000001;
          }
        }
        
        // Calcula a média real
        double average = data.reduce((a, b) => a + b) / data.length;
        sendPort.send(average);
      }
    });
  }

  void clearHistory() {
    temperatureHistory.clear();
  }

  void dispose() {
    _temperatureStreamController?.close();
    _timer?.cancel();
  }
}
