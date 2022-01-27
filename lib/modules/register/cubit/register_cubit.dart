import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app_mansour/modules/register/cubit/register_states.dart';
import 'package:shop_app_mansour/shared/network/remote/dio_helper.dart';

import '../../../models/login_model.dart';
import '../../../shared/network/end_points.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialState());

  static RegisterCubit get(context) => BlocProvider.of(context);

  LoginModel? loginModel;

  void userRegister({required String email, required String password , required String  name   , required phone}) {

    emit(RegisterLoadingState());
    DioHelper.postData(
      url: register,
      data: {
        "name": name,
        "email": email,
        "password": password,
        "phone": phone,

      },
    ).then((value) {
      if (kDebugMode) {
        print(value.data);
      }
      loginModel = LoginModel.fromJson(value.data);
      emit(RegisterSuccessState(loginModel!));
    }).catchError((error)  {
      emit(RegisterErrorState(error.toString()));
    });
  }
  IconData suffix = Icons.visibility_outlined;
  bool obscure = true ;

  void changeObscure(){
    obscure = !obscure;

    suffix = obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(RegisterObscureChangeState());
  }
}
