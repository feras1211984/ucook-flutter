import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:ucookfrontend/features/domain/enums/userstatus.dart';
import 'package:ucookfrontend/features/domain/usecases/login.dart';
import 'package:ucookfrontend/features/domain/usecases/register.dart';
import 'package:ucookfrontend/features/presentation/bloc/userManager/user_event.dart';
import 'package:ucookfrontend/features/presentation/bloc/userManager/user_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE = 'Please Enter phone Number';
const String Unknow_ERROR = 'Please Enter Phone Number';

class MobileUserBloc extends Bloc<MobileUserEvent, UserState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;

  String phoneNumber = '';
  MobileUserBloc({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
  })  : assert(loginUseCase != null),
        assert(registerUseCase != null),
        this.loginUseCase = loginUseCase,
        this.registerUseCase = registerUseCase,
        super(UserState());

  UserState get initialState => NoUser();

  @override
  Stream<UserState> mapEventToState(
    MobileUserEvent event,
  ) async* {
    // yield LoggingInState();
    if (event is LoginUser) {
      if (event.mobileNumber == "") {
        yield Error(message: INVALID_INPUT_FAILURE_MESSAGE);
      } else {
        LoginUserInfoParams userInfoParams =
            LoginUserInfoParams(mobileNumber: event.mobileNumber);
        final res = await loginUseCase(userInfoParams);
        yield* res.fold(
          (failure) async* {
            yield Error(message: Unknow_ERROR);
          },
          (mobileUser) async* {
            if (mobileUser.status == UserStatus.NewAccount)
              yield NewUser(mobileUser: mobileUser);
            else if (mobileUser.status == UserStatus.AccountNotApprovedYet)
              yield NotApprovedUser(mobileUser: mobileUser);
            else if (mobileUser.status == UserStatus.AccountApproved) {
              yield LoggedIn(mobileUser: mobileUser);
            } else if (mobileUser.status == UserStatus.AccountBlocked)
              yield BlockedUser(mobileUser: mobileUser);
            else if (mobileUser.status == UserStatus.NoUser) yield NoUser();
          },
        );
      }
    }
    if (event is RegisterUser) {
      if (event.mobileNumber == "" || event.name == "") {
        yield Error(message: INVALID_INPUT_FAILURE_MESSAGE);
      } else {
        RegisterUserInfoParams userInfoParams = RegisterUserInfoParams(
            name: event.name, mobileNumber: event.mobileNumber);
        final res = await registerUseCase(userInfoParams);
        yield* res.fold(
          (failure) async* {
            yield Error(message: Unknow_ERROR);
          },
          (mobileUser) async* {
            if (mobileUser.status == UserStatus.NewAccount)
              yield NewUser(mobileUser: mobileUser);
            if (mobileUser.status == UserStatus.AccountNotApprovedYet)
              yield NotApprovedUser(mobileUser: mobileUser);
            if (mobileUser.status == UserStatus.AccountApproved) {
              yield LoggedIn(mobileUser: mobileUser);
            }
            if (mobileUser.status == UserStatus.AccountBlocked)
              yield BlockedUser(mobileUser: mobileUser);
          },
        );
      }
    }
  }
}
