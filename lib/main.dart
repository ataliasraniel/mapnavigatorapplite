import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapnavigatorapp/features/home/home_controller.dart';
import 'package:mapnavigatorapp/shared/config/app_configs.dart';
import 'package:mapnavigatorapp/shared/visual/default_theme.dart';
import 'package:mapnavigatorapp/shared/config/env_config.dart';
import 'package:provider/provider.dart';
import 'shared/providers/location_provider.dart';
import 'shared/providers/sensor_provider.dart';
import 'shared/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: ".env");

    EnvConfig.validateConfig();
    AppConfigs.setupDependencies();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    runApp(const MainApp());
  } catch (e) {
    debugPrint('Erro na configuração: $e');
    runApp(ConfigErrorApp(error: e.toString()));
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            final homeController = HomeController();
            return homeController;
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            final locationProvider = LocationProvider();
            locationProvider.initializeLocation();
            return locationProvider;
          },
        ),
        ChangeNotifierProvider(
          create: (context) {
            final sensorProvider = SensorProvider();
            return sensorProvider;
          },
        ),
      ],
      child: MaterialApp.router(title: 'Map Navigator', debugShowCheckedModeBanner: false, theme: DefaultTheme.themeData, routerConfig: AppRouter.router),
    );
  }
}

class ConfigErrorApp extends StatelessWidget {
  final String error;

  const ConfigErrorApp({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Erro de Configuração',
      home: Scaffold(
        backgroundColor: Colors.red.shade50,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red.shade600),
                const SizedBox(height: 24),
                Text(
                  'Erro de Configuração',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red.shade700),
                ),
                const SizedBox(height: 16),
                Text(
                  error,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.red.shade600),
                ),
                const SizedBox(height: 24),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Para corrigir:',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade700),
                        ),
                        const SizedBox(height: 8),
                        const Text('1. Verifique se o arquivo .env existe na raiz do projeto'),
                        const Text('2. Adicione a variável GOOGLE_MAPS_API_KEY no arquivo .env'),
                        const Text('3. Reinicie o aplicativo'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
