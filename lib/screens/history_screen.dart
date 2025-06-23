import 'package:flutter/material.dart';
import '../services/temperature_service.dart';

class HistoryScreen extends StatelessWidget {
  final TemperatureService _temperatureService = TemperatureService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Histórico de Temperaturas'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_outline),
            onPressed: () {
              _showClearHistoryDialog(context);
            },
          ),
        ],
      ),
      body: _temperatureService.temperatureHistory.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.history,
                  size: 64,
                  color: Colors.grey[400],
                ),
                SizedBox(height: 16),
                Text(
                  'Nenhum dado disponível',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Inicie o monitoramento para ver o histórico',
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          )
        : ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: _temperatureService.temperatureHistory.length,
            itemBuilder: (context, index) {
              final temperature = _temperatureService.temperatureHistory[index];
              return Card(
                margin: EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _getTemperatureColor(temperature),
                    child: Icon(
                      Icons.thermostat,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    '${temperature.toStringAsFixed(1)}°C',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Text('Leitura ${index + 1}'),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () {
                    _showTemperatureDetails(context, temperature, index + 1);
                  },
                ),
              );
            },
          ),
    );
  }

  Color _getTemperatureColor(double temperature) {
    if (temperature < 18) return Colors.blue;
    if (temperature < 25) return Colors.green;
    if (temperature < 30) return Colors.orange;
    return Colors.red;
  }

  void _showClearHistoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Limpar Histórico'),
          content: Text('Tem certeza que deseja limpar todo o histórico?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                _temperatureService.clearHistory();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Histórico limpo com sucesso!')),
                );
              },
              child: Text('Limpar'),
            ),
          ],
        );
      },
    );
  }

  void _showTemperatureDetails(BuildContext context, double temperature, int reading) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Detalhes da Leitura'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Leitura: $reading'),
              SizedBox(height: 8),
              Text('Temperatura: ${temperature.toStringAsFixed(2)}°C'),
              SizedBox(height: 8),
              Text('Status: ${_getTemperatureStatus(temperature)}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  String _getTemperatureStatus(double temperature) {
    if (temperature < 18) return 'Frio';
    if (temperature < 25) return 'Agradável';
    if (temperature < 30) return 'Quente';
    return 'Muito Quente';
  }
}
