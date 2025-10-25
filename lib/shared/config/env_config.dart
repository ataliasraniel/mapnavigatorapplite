import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static String get googleMapsApiKey => dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';

  static bool get isDevelopment => dotenv.env['ENVIRONMENT'] == 'development';
  static bool get isProduction => dotenv.env['ENVIRONMENT'] == 'production';

  static bool get isConfigValid {
    return googleMapsApiKey.isNotEmpty;
  }

  static void validateConfig() {
    if (!isConfigValid) {
      throw Exception('Configuração inválida: GOOGLE_MAPS_API_KEY não encontrada no arquivo .env');
    }
  }
}
