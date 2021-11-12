import 'package:internet_connection_checker/internet_connection_checker.dart';

class NetworkConnection {
  static Future<bool> get isConnected => InternetConnectionChecker().hasConnection;
}
