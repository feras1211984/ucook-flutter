import 'package:dartz/dartz.dart';

import '../error/failures.dart';

class PhoneNumberConverter {
  Either<Failure, String> stringToUnsignedInteger(String str) {
    try {
      final phonenumber = str;
      if (phonenumber.length < 7) throw FormatException();
      return Right(phonenumber);
    } on FormatException {
      return Left(InvalidPhoneNumberFailure());
    }
  }
}

class InvalidPhoneNumberFailure extends Failure {}
