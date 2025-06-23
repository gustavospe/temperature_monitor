import 'package:flutter/material.dart';

class StatisticsCard extends StatelessWidget {
  final double averageTemperature;
  final int totalReadings;

  const StatisticsCard({
    Key? key,
    required this.averageTemperature,
    required this.totalReadings,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.analytics,
                  color: Colors.green[600],
                ),
                SizedBox(width: 8),
                Text(
                  'Estatísticas',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  'Média',
                  '${averageTemperature.toStringAsFixed(1)}°C',
                  Colors.green,
                ),
                _buildStatItem(
                  'Leituras',
                  totalReadings.toString(),
                  Colors.blue,
                ),
                _buildStatItem(
                  'Status',
                  _getAverageStatus(),
                  _getStatusColor(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  String _getAverageStatus() {
    if (averageTemperature < 18) return 'Frio';
    if (averageTemperature < 25) return 'Ideal';
    if (averageTemperature < 30) return 'Quente';
    return 'Muito Quente';
  }

  Color _getStatusColor() {
    if (averageTemperature < 18) return Colors.blue;
    if (averageTemperature < 25) return Colors.green;
    if (averageTemperature < 30) return Colors.orange;
    return Colors.red;
  }
}
