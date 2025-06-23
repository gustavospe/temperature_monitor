import 'package:flutter/material.dart';
import '../routes/app_router.dart';
import '../widgets/menu_card.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Monitor de Temperatura'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, AppRouter.settings);
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Bem-vindo!',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Escolha uma opção para começar',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 30),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  MenuCard(
                    icon: Icons.thermostat,
                    title: 'Monitor',
                    subtitle: 'Temperatura em tempo real',
                    color: Colors.blue,
                    onTap: () {
                      Navigator.pushNamed(context, AppRouter.temperatureMonitor);
                    },
                  ),
                  MenuCard(
                    icon: Icons.history,
                    title: 'Histórico',
                    subtitle: 'Ver dados anteriores',
                    color: Colors.green,
                    onTap: () {
                      Navigator.pushNamed(context, AppRouter.history);
                    },
                  ),
                  MenuCard(
                    icon: Icons.analytics,
                    title: 'Análises',
                    subtitle: 'Estatísticas detalhadas',
                    color: Colors.orange,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Em desenvolvimento!')),
                      );
                    },
                  ),
                  MenuCard(
                    icon: Icons.settings,
                    title: 'Configurações',
                    subtitle: 'Personalizar app',
                    color: Colors.purple,
                    onTap: () {
                      Navigator.pushNamed(context, AppRouter.settings);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
