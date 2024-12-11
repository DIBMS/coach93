enum Environment { dev, prod }

class EnvConfig {
  static final EnvConfig _instance = EnvConfig._internal();
  factory EnvConfig() => _instance;
  EnvConfig._internal();

  Environment _environment = Environment.dev;
  
  void setEnvironment(Environment env) {
    _environment = env;
  }

  String get apiBaseUrl {
    switch (_environment) {
      case Environment.dev:
        return 'http://localhost:3000/api';
      case Environment.prod:
        // We'll update this with the Render.com URL once we deploy
        return 'https://coach93-api.onrender.com/api';
    }
  }

  bool get isDevelopment => _environment == Environment.dev;
  bool get isProduction => _environment == Environment.prod;
}
