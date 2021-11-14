class JsonFormatHelper {
  static int asInt(dynamic value) {
    if (value == null) {
      return 0;
    }

    if (value is int || value is double || value is num) {
      try {
        return value.data.toInt();
      } on FormatException {
        return 0;
      }
    } else {
      try {
        return int.parse(value);
      } on FormatException {
        return 0;
      }
    }
  }

  static double asDouble(dynamic value) {
    if (value == null) {
      return 0;
    }

    if (value is int || value is double || value is num) {
      try {
        return value.data.toDouble();
      } on FormatException {
        return 0;
      }
    } else {
      try {
        return double.parse(value);
      } on FormatException {
        return 0;
      }
    }
  }

  static String asString(dynamic value) {
    if (value == null) {
      return '';
    }

    if (value is String) {
      return value;
    } else {
      return value.toString();
    }
  }

  static bool asBoolean(dynamic value) {
    if (value is bool) {
      return value;
    } else {
      return false;
    }
  }
}
