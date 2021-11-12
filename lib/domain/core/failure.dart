import 'alert.dart';

class Failure {
  String title = "Failed";
  String message = "Failed processing your request";
  AlertType type = AlertType.danger;

  Failure({
    required this.title,
    required this.message,
    required this.type,
  });
}

class ServerFailure extends Failure {
  ServerFailure({
    String title = "Server Failure",
    String message = "There has been a problem with the server, please try again!",
    AlertType type = AlertType.danger,
  }) : super(
          title: title,
          message: message,
          type: type,
        );
}

class NetworkFailure extends Failure {
  NetworkFailure({
    String title = "Network Failure",
    String message = "Please check your network connection",
    AlertType type = AlertType.danger,
  }) : super(
          title: title,
          message: message,
          type: type,
        );
}
