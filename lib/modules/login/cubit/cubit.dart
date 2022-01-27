import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app_mansour/models/login_model.dart';
import 'package:shop_app_mansour/modules/login/cubit/states.dart';
import 'package:shop_app_mansour/shared/network/remote/dio_helper.dart';

import '../../../shared/network/end_points.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);

  LoginModel? loginModel;

  void userLogin({required String email, required String password}) {

    emit(LoginLoadingState());
    DioHelper.postData(
      url: login,
      data: {
        "email": email,
        "password": password,
      },
    ).then((value) {
      if (kDebugMode) {
        print(value.data);
      }

      loginModel = LoginModel.fromJson(value.data);
      emit(LoginSuccessState(loginModel!));
    }).catchError((error)  {
      print("error : ${error.toString()}");
      emit(LoginErrorState(error.toString()));
    });
  }
  IconData suffix = Icons.visibility_outlined;
  bool obscure = true ;

  void changeObscure(){
    obscure = !obscure;

    suffix = obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(ObscureChangeState());
  }
}
