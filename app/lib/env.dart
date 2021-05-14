class BuildEnv {
  static const proxyPort = String.fromEnvironment('proxyPort', defaultValue: '8081');
  static final randomPackageUrl = Uri.parse('https://random-wedvmfrxia-uw.a.run.app');
}
