import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app_mansour/layout/shop/cubit/shop_cubit.dart';
import 'package:shop_app_mansour/layout/shop/shop_layout.dart';
import 'package:shop_app_mansour/modules/login/login_screen.dart';
import 'package:shop_app_mansour/modules/onboarding/on_boarding_screen.dart';
import 'package:shop_app_mansour/shared/bloc_observer.dart';
import 'package:shop_app_mansour/shared/components/constants.dart';
import 'package:shop_app_mansour/shared/network/local/cache_helper.dart';
import 'package:shop_app_mansour/shared/network/remote/dio_helper.dart';
import 'package:shop_app_mansour/shared/styles/themes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'layout/cubit/app_cubit.dart';
import 'layout/cubit/app_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  DioHelper.init();
  await CacheHelper.init();
  if (CacheHelper.getData(key: 'isDark') == null) {
    CacheHelper.saveData(key: 'isDark', value: isDark);}
  if (CacheHelper.getData(key: 'language') == null) {
    CacheHelper.saveData(key: 'language', value: appLanguage);
    if (kDebugMode) {
      print(appLanguage);
    }
  }
  appLanguage = CacheHelper.getData(key: 'language');
  bool? onBoarding = CacheHelper.getData(key: 'onBoarding');
  token = CacheHelper.getData(key: 'token');
  isDark = CacheHelper.getData(key: 'isDark');

    Widget widget;

  if (onBoarding != null) {
    if (token != null) {
      widget = const ShopLayout();
    } else {
      widget = LoginScreen();
    }
  } else {
    widget = OnBoardingScreen();
  }

  if (kDebugMode) {
    print(onBoarding);
  }
  BlocOverrides.runZoned(
    () {
      runApp(MyApp(
        widget: widget,
      ));
      // Use blocs...
    },
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, this.widget}) : super(key: key);

// final bool? isDark;
  final Widget? widget;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print(appLanguage);
      print(dropdownValue);
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => AppCubit(),
        ),
        BlocProvider(
          create: (BuildContext context) => ShopCubit()
            ..getUserData()
            ..getFavorites()
            ..getCategories()
            ..getHomeData()
            ..getAddresses()
            ..getFAQs()
            ..getSettings()
            ..getCart()
            ..getOrders(),
        ),
      ],
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, state) {},
        builder: (BuildContext context, Object? state) {
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: lightTheme,
              darkTheme: darkTheme,
              themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
              locale:
                  appLanguage == 'en' ? const Locale('en') : const Locale('ar'),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              localeResolutionCallback: (locale, supportedLocales) {
                for (var supportedLocale in supportedLocales) {
                  if (supportedLocale.languageCode == locale?.languageCode &&
                      supportedLocale.countryCode == locale?.countryCode) {
                    return supportedLocale;
                  }
                }
                return supportedLocales.first;
              },
              home: widget);
        },
      ),
    );
  }
}
