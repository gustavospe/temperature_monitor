import 'package:flutter/material.dart';
import '../models/temperature_data.dart';

class TemperatureCard extends StatelessWidget {
  final TemperatureData? temperatureData;
  final bool isLoading;

  const TemperatureCard({
    Key? key,
    this.temperatureData,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.location_city,
                  color: Colors.blue[600],
                ),
                SizedBox(width: 8),
                Text(
                  temperatureData?.city ?? 'Cidade',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            if (isLoading)
              Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Carregando temperatura...'),
                ],
              )
            else if (temperatureData != null)
              Column(
                children: [
                  Text(
                    temperatureData!.formattedTemperature,
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: _getTemperatureColor(temperatureData!.temperature),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    temperatureData!.temperatureStatus,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Atualizado às ${temperatureData!.formattedTime}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
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
    );
  }

  Color _getTemperatureColor(double temperature) {
    if (temperature < 18) return Colors.blue;
    if (temperature < 25) return Colors.green;
    if (temperature < 30) return Colors.orange;
    return Colors.red;
  }
}
