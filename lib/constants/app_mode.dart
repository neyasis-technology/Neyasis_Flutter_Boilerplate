enum AppMode { unknown, development, production, uat, test }

extension AppModeExtension on AppMode {
  String get path {
    switch (this) {
      case AppMode.development:
        return "development";
      case AppMode.test:
        return "test";
      case AppMode.uat:
        return "uat";
      case AppMode.production:
        return "production";
      default:
        return '';
    }
  }
}
