import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  double _updateInterval = 2.0;
  String _temperatureUnit = 'Celsius';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configurações'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Notificações',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 16),
                  SwitchListTile(
                    title: Text('Ativar Notificações'),
                    subtitle: Text('Receber alertas de temperatura'),
                    value: _notificationsEnabled,
                    onChanged: (value) {
                      setState(() {
                        _notificationsEnabled = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          
          SizedBox(height: 16),
          
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Aparência',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 16),
                  SwitchListTile(
                    title: Text('Modo Escuro'),
                    subtitle: Text('Ativar tema escuro'),
                    value: _darkModeEnabled,
                    onChanged: (value) {
                      setState(() {
                        _darkModeEnabled = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          
          SizedBox(height: 16),
          
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Monitoramento',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 16),
                  ListTile(
                    title: Text('Intervalo de Atualização'),
                    subtitle: Text('${_updateInterval.toInt()} segundos'),
                    trailing: Icon(Icons.chevron_right),
                    onTap: () => _showUpdateIntervalDialog(),
                  ),
                  ListTile(
                    title: Text('Unidade de Temperatura'),
                    subtitle: Text(_temperatureUnit),
                    trailing: Icon(Icons.chevron_right),
                    onTap: () => _showTemperatureUnitDialog(),
                  ),
                ],
              ),
            ),
          ),
          
          SizedBox(height: 16),
          
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sobre',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 16),
                  ListTile(
                    title: Text('Versão do App'),
                    subtitle: Text('1.0.0'),
                    leading: Icon(Icons.info_outline),
                  ),
                  ListTile(
                    title: Text('Desenvolvedor'),
                    subtitle: Text('Monitor de Temperatura Team'),
                    leading: Icon(Icons.person_outline),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showUpdateIntervalDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Intervalo de Atualização'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Escolha o intervalo em segundos:'),
              SizedBox(height: 16),
              Slider(
                value: _updateInterval,
                min: 1.0,
                max: 10.0,
                divisions: 9,
                label: '${_updateInterval.toInt()}s',
                onChanged: (value) {
                  setState(() {
                    _updateInterval = value;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  void _showTemperatureUnitDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Unidade de Temperatura'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: Text('Celsius (°C)'),
                value: 'Celsius',
                groupValue: _temperatureUnit,
                onChanged: (value) {
                  setState(() {
                    _temperatureUnit = value!;
                  });
                  Navigator.pop(context);
                },
              ),
              RadioListTile<String>(
                title: Text('Fahrenheit (°F)'),
                value: 'Fahrenheit',
                groupValue: _temperatureUnit,
                onChanged: (value) {
                  setState(() {
                    _temperatureUnit = value!;
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
