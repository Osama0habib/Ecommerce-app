import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app_mansour/layout/shop/cubit/shop_cubit.dart';

import '../../shared/components/constants.dart';
import '../../shared/network/local/cache_helper.dart';
import 'app_state.dart';

class AppCubit extends Cubit<AppStates>{
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);



  String stringConversion(String fromShared){
    if(fromShared == "English"){
      dropdownValue = 'English' ;
      return "en";
    }else{
      dropdownValue = 'عربي' ;
      return "ar";
    }

  }

  void toggleLanguage({String? fromShared,context}) {
      appLanguage = stringConversion(fromShared!);
      CacheHelper.saveData(value: stringConversion(fromShared), key: 'language').then((value) =>
          emit(LanguageChangeState()));
      ShopCubit.get(context)..getUserData()..getFavorites()..getCategories()..getHomeData()..getAddresses()..getFAQs()..getSettings()..getCart()..getOrders();

  }

  void toggleDarkMode({bool? fromShared}){

    if(fromShared  !=  null) {
      isDark =  fromShared;
      if (kDebugMode) {
        print(isDark);
      }
      emit(NewsDarkModeState());
    }else{
      isDark = !isDark ;
      CacheHelper.saveData(value: isDark , key: 'isDark').then((value) => emit(NewsDarkModeState()));
    }


  }

}

