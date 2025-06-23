import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:isolate';
import 'dart:math';
import 'routes/app_router.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Monitor de Temperatura',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: AppRouter.splash,
      routes: AppRouter.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}

class TemperatureMonitor extends StatefulWidget {
  @override
  _TemperatureMonitorState createState() => _TemperatureMonitorState();
}

class _TemperatureMonitorState extends State<TemperatureMonitor> {
  double? currentTemperature;
  bool isLoading = false;
  StreamController<double>? _temperatureStreamController;
  Timer? _timer;
  List<double> temperatureHistory = [];
  double? averageTemperature;
  bool isCalculating = false;
  
  final String cityName = "São Paulo";
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _temperatureStreamController?.close();
    _timer?.cancel();
    super.dispose();
  }

  // 1. Future para carregar temperatura inicial
  Future<double> loadInitialTemperature() async {
    setState(() {
      isLoading = true;
    });
    
    // Simula delay de carregamento
    await Future.delayed(Duration(seconds: 2));
    
    // Simula temperatura inicial entre 15°C e 35°C
    double temperature = 15 + _random.nextDouble() * 20;
    
    setState(() {
      isLoading = false;
      currentTemperature = temperature;
      temperatureHistory.add(temperature);
    });
    
    return temperature;
  }

  // 2. Stream para atualização em tempo real
  void startTemperatureStream() {
    _temperatureStreamController = StreamController<double>();
    
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      if (currentTemperature != null) {
        // Simula variação de temperatura (-2°C a +2°C)
        double variation = -2 + _random.nextDouble() * 4;
        double newTemperature = currentTemperature! + variation;
        
        // Mantém temperatura entre 10°C e 40°C
        newTemperature = newTemperature.clamp(10.0, 40.0);
        
        currentTemperature = newTemperature;
        temperatureHistory.add(newTemperature);
        
        // Mantém apenas os últimos 10 valores
        if (temperatureHistory.length > 10) {
          temperatureHistory.removeAt(0);
        }
        
        _temperatureStreamController!.add(newTemperature);
      }
    });
  }

  // 3. Função para executar no Isolate
  static void calculateAverageInIsolate(SendPort sendPort) {
    ReceivePort receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);
    
    receivePort.listen((data) {
      List<double> temperatures = List<double>.from(data);
      
      // Simula cálculo pesado
      double sum = 0;
      for (int i = 0; i < 1000000; i++) {
        for (double temp in temperatures) {
          sum += temp * 0.000001;
        }
      }
      
      // Calcula a média real
      double average = temperatures.reduce((a, b) => a + b) / temperatures.length;
      
      sendPort.send(average);
    });
  }

  // Função para calcular média usando Isolate
  Future<void> calculateAverageWithIsolate() async {
    if (temperatureHistory.isEmpty) return;
    
    setState(() {
      isCalculating = true;
    });

    try {
      ReceivePort receivePort = ReceivePort();
      Isolate isolate = await Isolate.spawn(calculateAverageInIsolate, receivePort.sendPort);
      
      SendPort? sendPort;
      
      await for (var data in receivePort) {
        if (data is SendPort) {
          sendPort = data;
          sendPort.send(temperatureHistory);
        } else if (data is double) {
          setState(() {
            averageTemperature = data;
            isCalculating = false;
          });
          isolate.kill();
          receivePort.close();
          break;
        }
      }
    } catch (e) {
      setState(() {
        isCalculating = false;
      });
      print('Erro no Isolate: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Monitor de Temperatura'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Card da cidade
            Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.location_city,
                      size: 48,
                      color: Theme.of(context).primaryColor,
                    ),
                    SizedBox(height: 8),
                    Text(
                      cityName,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 20),
            
            // Botão para carregar temperatura inicial
            ElevatedButton.icon(
              onPressed: isLoading ? null : () async {
                await loadInitialTemperature();
                startTemperatureStream();
              },
              icon: Icon(Icons.thermostat),
              label: Text('Carregar Previsão de Temperatura'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12),
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
              ),
            ),
            
            SizedBox(height: 20),
            
            // Exibição da temperatura atual
            Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text(
                      'Temperatura Atual',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 10),
                    if (isLoading)
                      Column(
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 10),
                          Text('Carregando...'),
                        ],
                      )
                    else if (currentTemperature != null)
                      StreamBuilder<double>(
                        stream: _temperatureStreamController?.stream,
                        initialData: currentTemperature,
                        builder: (context, snapshot) {
                          double temp = snapshot.data ?? currentTemperature!;
                          return Column(
                            children: [
                              Text(
                                '${temp.toStringAsFixed(1)}°C',
                                style: TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                  color: _getTemperatureColor(temp),
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Atualizado em tempo real',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          );
                        },
                      )
                    else
                      Text(
                        'Clique no botão para carregar',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 20),
            
            // Botão para calcular média
            ElevatedButton.icon(
              onPressed: (temperatureHistory.isEmpty || isCalculating) ? null : calculateAverageWithIsolate,
              icon: isCalculating 
                ? SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Icon(Icons.calculate),
              label: Text(isCalculating ? 'Calculando...' : 'Calcular Média (Isolate)'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12),
                backgroundColor: Colors.green[600],
                foregroundColor: Colors.white,
              ),
            ),
            
            SizedBox(height: 10),
            
            // Exibição da média calculada
            if (averageTemperature != null)
              Card(
                elevation: 2,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Média dos Últimos ${temperatureHistory.length} Valores',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '${averageTemperature!.toStringAsFixed(2)}°C',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            
            SizedBox(height: 20),
            
            // Histórico de temperaturas
            if (temperatureHistory.isNotEmpty)
              Expanded(
                child: Card(
                  elevation: 2,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Histórico de Temperaturas',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 10),
                        Expanded(
                          child: ListView.builder(
                            itemCount: temperatureHistory.length,
                            itemBuilder: (context, index) {
                              double temp = temperatureHistory[index];
                              return ListTile(
                                leading: Icon(
                                  Icons.thermostat,
                                  color: _getTemperatureColor(temp),
                                ),
                                title: Text('${temp.toStringAsFixed(1)}°C'),
                                subtitle: Text('Leitura ${index + 1}'),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _getTemperatureColor(double temperature) {
    if (temperature < 18) {
      return Colors.blue;
    } else if (temperature < 25) {
      return Colors.green;
    } else if (temperature < 30) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}
