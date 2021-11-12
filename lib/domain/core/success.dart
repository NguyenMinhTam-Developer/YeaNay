import 'alert.dart';

class Success<T> {
  String? title;
  String? message;
  AlertType? type;
  T data;

  Success({
    this.title = "Success",
    this.message = "Successfully processing your request",
    this.type = AlertType.success,
    required this.data,
  });
}
