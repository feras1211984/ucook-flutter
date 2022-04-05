import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:ucookfrontend/features/data/datasources/Cash/cash_auth_data_source.dart';
import 'package:ucookfrontend/features/domain/usecases/confirm_verification_code.dart';
import 'package:ucookfrontend/features/presentation/bloc/verificationcode/vcode_event.dart';
import 'package:ucookfrontend/features/presentation/bloc/verificationcode/vcode_state.dart';
import 'package:ucookfrontend/injection_container.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE = '';
const String Unknow_ERROR = '';

class VerificationCodeBloc extends Bloc<VerificationCodeEvent, VCodeStates> {
  final ConfirmVCodeUseCase confirmVCodeUseCase;

  static TokenCashDataSourceImpl _tokenCashDataSourceImpl = sl();
  String phoneNumber = '';
  String code = '';
  VerificationCodeBloc({
    required ConfirmVCodeUseCase confirmVCodeUseCase,
  })  : assert(confirmVCodeUseCase != null),
        this.confirmVCodeUseCase = confirmVCodeUseCase,
        super(VCodeStates());

  @override
  Stream<VCodeStates> mapEventToState(
    VerificationCodeEvent event,
  ) async* {
    if (event is SendVerificationCodeEvent) {
      var mobileNumber = '';
      if (event.mobileNumber == "") {
        mobileNumber = _tokenCashDataSourceImpl.getPhoneAsString();
        if (mobileNumber.isEmpty)
          yield Error(message: INVALID_INPUT_FAILURE_MESSAGE);
      } else {
        mobileNumber = event.mobileNumber;
        ConfirmVCodeParams confirmVCodeParams =
            ConfirmVCodeParams(mobileNumber: mobileNumber);
        final res = await confirmVCodeUseCase(confirmVCodeParams);
        yield* res.fold(
          (failure) async* {
            yield Error(message: Unknow_ERROR);
          },
          (res) async* {
            code = res.code.toString();
            if (res.status.contains('OK'))
              yield GettingVCodeState(code: res.code);
            else
              yield Error(message: Unknow_ERROR);
          },
        );
      }
    }
    if (event is CheckVerificationCodeEvent) {
      if (code == event.code.toString()) {
        _tokenCashDataSourceImpl.saveToken();
        yield RightVCodeState();
      } else {
        yield WrongVCodeState();
      }
    }
  }
}
