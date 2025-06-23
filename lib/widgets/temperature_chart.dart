import 'package:flutter/material.dart';

class TemperatureChart extends StatelessWidget {
  final List<double> temperatureHistory;

  const TemperatureChart({
    Key? key,
    required this.temperatureHistory,
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
                  Icons.show_chart,
                  color: Colors.purple[600],
                ),
                SizedBox(width: 8),
                Text(
                  'Gráfico de Temperatura',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Container(
              height: 200,
              child: CustomPaint(
                painter: TemperatureChartPainter(temperatureHistory),
                size: Size.infinite,
              ),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Min: ${temperatureHistory.reduce((a, b) => a < b ? a : b).toStringAsFixed(1)}°C',
                  style: TextStyle(fontSize: 12, color: Colors.blue),
                ),
                Text(
                  'Max: ${temperatureHistory.reduce((a, b) => a > b ? a : b).toStringAsFixed(1)}°C',
                  style: TextStyle(fontSize: 12, color: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TemperatureChartPainter extends CustomPainter {
  final List<double> temperatures;

  TemperatureChartPainter(this.temperatures);

  @override
  void paint(Canvas canvas, Size size) {
    if (temperatures.isEmpty) return;

    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final pointPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    final path = Path();
    
    final minTemp = temperatures.reduce((a, b) => a < b ? a : b);
    final maxTemp = temperatures.reduce((a, b) => a > b ? a : b);
    final tempRange = maxTemp - minTemp;
    
    if (tempRange == 0) return;

    for (int i = 0; i < temperatures.length; i++) {
      final x = (i / (temperatures.length - 1)) * size.width;
      final y = size.height - ((temperatures[i] - minTemp) / tempRange) * size.height;
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
      
      // Desenha pontos
      canvas.drawCircle(Offset(x, y), 3, pointPaint);
    }
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
