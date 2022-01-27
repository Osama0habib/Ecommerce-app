import 'package:flutter/foundation.dart';
import 'package:shop_app_mansour/modules/login/login_screen.dart';
import 'package:shop_app_mansour/shared/components/components.dart';
import 'package:shop_app_mansour/shared/network/local/cache_helper.dart';

import '../../layout/shop/cubit/shop_cubit.dart';

void signOut(context){

  CacheHelper.removeData(key: 'token').then((value) {
    if(value!){
      token  = '';
      ShopCubit.get(context).clearUserData();

      navigateAndFinish(context, LoginScreen());

    }
  });

}

void printFullText(String text){
  final  pattern = RegExp('.{1,800}'); //800 is the size of each chunk
  pattern.allMatches(text).forEach((match) {
    if (kDebugMode) {
      print(match.group(0));
    }
  });
}

String? token ;

bool isDark = false ;


String appLanguage = "en";
String dropdownValue  = appLanguage == "en" ? "English" : "عربي" ;

const googleApiKey = "YOUR_GOOGLE_MAPS_API_KEY";

