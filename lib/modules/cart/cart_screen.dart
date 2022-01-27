import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
import 'package:shop_app_mansour/layout/shop/cubit/shop_states.dart';
import 'package:shop_app_mansour/layout/shop/shop_layout.dart';
import 'package:shop_app_mansour/models/cart_model.dart';
import 'package:shop_app_mansour/modules/orders/check_out_screen.dart';
import 'package:shop_app_mansour/modules/products/product_details_screen.dart';
import 'package:shop_app_mansour/shared/components/components.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


import '../../layout/shop/cubit/shop_cubit.dart';
import 'cart_item.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (BuildContext context, state) {},
      builder: (BuildContext context, Object? state) {
        Data? cart = ShopCubit.get(context).cartModel?.data;
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.black),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  constraints: BoxConstraints(minHeight: (MediaQuery.of(context).size.height - AppBar().preferredSize.height) / 1.8),
                  child: Conditional.single(
                    context: context,
                    conditionBuilder: (context) => true,
                    // cartList.isNotEmpty,
                    fallbackBuilder: (context) =>
                        Image.asset("assets/images/bag1.png"),
                    widgetBuilder: (context) {
                      return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            elevation: 20,
                            child: ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),

                                itemCount: cart!.cartItems!.length,
                                itemBuilder: (ctx, index) {
                                  return InkWell(
                                      onTap: () {
                                        navigateTo(
                                            context,
                                            ProductDetailsScreen(
                                                product: ShopCubit.get(context)
                                                    .homeModel!
                                                    .data!
                                                    .products
                                                    .firstWhere((element) =>
                                                        element.id ==
                                                        cart.cartItems![index]
                                                            .product!.id)));
                                      },
                                      child: CartListItem(
                                        cartItem: cart.cartItems![index],
                                      ));
                                }),
                          ));
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(elevation: 20,
                    child: Column(children:  [
                     Text(AppLocalizations.of(context)!.add_coupon,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                    const Divider(),
                    Row(mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                       SizedBox(width: MediaQuery.of(context).size.width / 1.5,
                           child: defaultTextFormField(label: AppLocalizations.of(context)!.coupon,)),
                      defaultButton(onPressed: (){} ,text: AppLocalizations.of(context)!.add,width: 80.0)
                    ],)
                  ],),),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(elevation: 20,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children:  [
                              Text(
                                AppLocalizations.of(context)!.subtotal,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                AppLocalizations.of(context)!.total,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                "${AppLocalizations.of(context)!.currency_egp} ${cart!.subTotal.toString()}",
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                "${AppLocalizations.of(context)!.currency_egp} ${cart.total.toString()}",
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Center(
                  child: defaultTextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        ShopCubit.get(context).currentIndex = 0;
                        navigateTo(context, const ShopLayout());
                      },
                      text: AppLocalizations.of(context)!.add_more_items),
                ),

              ],
            ),
          ),
          bottomNavigationBar: defaultButton(
            onPressed: () {
              navigateTo(context, const CheckOutScreen());
            },
            text: AppLocalizations.of(context)!.checkOut,
          ),
        );
      },
    );
  }
}
