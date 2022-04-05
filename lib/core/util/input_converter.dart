import 'package:dartz/dartz.dart';

import '../error/failures.dart';

class InputConverter {
  Either<Failure, int> stringToUnsignedInteger(String str) {
    try {
      final integer = int.parse(str);
      if (integer < 0) throw FormatException();
      return Right(integer);
    } on FormatException {
      return Left(InvalidInputFailure());
    }
  }

  String checkStringNullSafety(Object? object) {
    try {
      if (object == null) {
        return "";
      } else {
        return object.toString();
      }
    }
    catch(e)
    {
      return "";
    }
  }
}

class InvalidInputFailure extends Failure {}
