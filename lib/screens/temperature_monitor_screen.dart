import 'package:flutter/material.dart';
import '../services/temperature_service.dart';
import '../models/temperature_data.dart';
import '../widgets/temperature_card.dart';
import '../widgets/temperature_chart.dart';
import '../widgets/statistics_card.dart';

class TemperatureMonitorScreen extends StatefulWidget {
  @override
  _TemperatureMonitorScreenState createState() => _TemperatureMonitorScreenState();
}

class _TemperatureMonitorScreenState extends State<TemperatureMonitorScreen> {
  final TemperatureService _temperatureService = TemperatureService();
  TemperatureData? currentData;
  bool isLoading = false;
  bool isCalculating = false;
  double? averageTemperature;

  @override
  void dispose() {
    _temperatureService.dispose();
    super.dispose();
  }

  Future<void> _loadInitialTemperature() async {
    setState(() {
      isLoading = true;
    });

    try {
      final temperature = await _temperatureService.loadInitialTemperature();
      setState(() {
        currentData = TemperatureData(
          temperature: temperature,
          timestamp: DateTime.now(),
          city: 'São Paulo',
        );
        isLoading = false;
      });
      _temperatureService.startTemperatureStream();
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar temperatura: $e')),
      );
    }
  }

  Future<void> _calculateAverage() async {
    if (_temperatureService.temperatureHistory.isEmpty) return;

    setState(() {
      isCalculating = true;
    });

    try {
      final average = await _temperatureService.calculateAverageWithIsolate();
      setState(() {
        averageTemperature = average;
        isCalculating = false;
      });
    } catch (e) {
      setState(() {
        isCalculating = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro no cálculo: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Monitor de Temperatura'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadInitialTemperature,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Botão de carregamento inicial
            ElevatedButton.icon(
              onPressed: isLoading ? null : _loadInitialTemperature,
              icon: isLoading 
                ? SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Icon(Icons.thermostat),
              label: Text(isLoading ? 'Carregando...' : 'Carregar Previsão'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
              ),
            ),

            SizedBox(height: 20),

            // Card de temperatura atual
            StreamBuilder<TemperatureData>(
              stream: _temperatureService.temperatureStream,
              initialData: currentData,
              builder: (context, snapshot) {
                final data = snapshot.data;
                return TemperatureCard(
                  temperatureData: data,
                  isLoading: isLoading,
                );
              },
            ),

            SizedBox(height: 20),

            // Botão de cálculo de média
            ElevatedButton.icon(
              onPressed: (_temperatureService.temperatureHistory.isEmpty || isCalculating) 
                ? null 
                : _calculateAverage,
              icon: isCalculating 
                ? SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Icon(Icons.calculate),
              label: Text(isCalculating ? 'Calculando...' : 'Calcular Média (Isolate)'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[600],
                foregroundColor: Colors.white,
              ),
            ),

            SizedBox(height: 20),

            // Card de estatísticas
            if (averageTemperature != null)
              StatisticsCard(
                averageTemperature: averageTemperature!,
                totalReadings: _temperatureService.temperatureHistory.length,
              ),

            SizedBox(height: 20),

            // Gráfico de temperatura
            if (_temperatureService.temperatureHistory.isNotEmpty)
              TemperatureChart(
                temperatureHistory: _temperatureService.temperatureHistory,
              ),
          ],
        ),
      ),
    );
  }
}
