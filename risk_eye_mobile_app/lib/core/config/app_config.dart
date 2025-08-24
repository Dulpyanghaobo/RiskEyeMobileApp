
/// Available application environments.
enum AppEnv { dev, staging, prod }

/// Configuration values for different environments.
class AppConfig {
  final String baseUrl;
  final Duration connectTimeout;
  final Duration receiveTimeout;
  final bool enableLog;

  const AppConfig({
    required this.baseUrl,
    this.connectTimeout = const Duration(seconds: 10),
    this.receiveTimeout = const Duration(seconds: 10),
    this.enableLog = true,
  });

  /// Retrieve current environment from `--dart-define APP_ENV`.
  static final AppEnv _env = () {
    const envStr = String.fromEnvironment('APP_ENV', defaultValue: 'dev');
    return AppEnv.values.firstWhere(
      (e) => e.name == envStr,
      orElse: () => AppEnv.dev,
    );
  }();

  /// Static accessor for current configuration.
  static AppConfig get current {
    switch (_env) {
      case AppEnv.staging:
        return const AppConfig(
          baseUrl: 'https://staging.example.com',
          enableLog: true,
        );
      case AppEnv.prod:
        return const AppConfig(
          baseUrl: 'https://api.example.com',
          enableLog: false,
        );
      case AppEnv.dev:
      default:
        return const AppConfig(
          baseUrl: 'https://dev.example.com',
          enableLog: true,
        );
    }
  }

  /// Example of switching environment at runtime.
  static AppEnv get env => _env;
}
