import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app_mansour/layout/shop/cubit/shop_cubit.dart';
import 'package:shop_app_mansour/layout/shop/cubit/shop_states.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:shop_app_mansour/modules/cart/cart_screen.dart';
import 'package:shop_app_mansour/modules/search/search_screen.dart';
import 'package:shop_app_mansour/shared/components/components.dart';

class ShopLayout extends StatelessWidget {
  const ShopLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (BuildContext context, state) {

      },
      builder: (BuildContext context, Object? state) {

        var cubit = ShopCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title:  Text(AppLocalizations.of(context)!.app_title)
            ,
            actions: [IconButton(onPressed: (){
              navigateTo(context, const SearchScreen());
            }, icon: const Icon(Icons.search)),IconButton(onPressed: (){
              ShopCubit.get(context).isCartInit = true;
              navigateTo(context, const CartScreen());}, icon: const Icon(Icons.shopping_cart))],
          ),
          body: cubit.bottomScreens[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            // backgroundColor: ColorScheme.dark(),
            items:  [
              BottomNavigationBarItem(icon: const Icon(Icons.home), label: AppLocalizations.of(context)!.bottom_nav_1),
              BottomNavigationBarItem(
                  icon: const Icon(Icons.apps), label: AppLocalizations.of(context)!.bottom_nav_2_and_title),
              BottomNavigationBarItem(
                  icon: const Icon(Icons.favorite), label: AppLocalizations.of(context)!.bottom_nav_3),
              BottomNavigationBarItem(
                  icon: const Icon(Icons.settings), label: AppLocalizations.of(context)!.bottom_nav_4),
            ],
            onTap: (index) => cubit.changeBottomNav(index),
            currentIndex: cubit.currentIndex,
          ),
        );
      },
    );
  }
}
