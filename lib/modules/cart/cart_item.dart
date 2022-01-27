
import 'package:flutter/material.dart';
import 'package:shop_app_mansour/layout/shop/cubit/shop_cubit.dart';

import '../../models/cart_model.dart';
import '../../shared/components/components.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class CartListItem extends StatelessWidget {

  const CartListItem( {Key? key,required this.cartItem}) : super(key: key);

  final CartItems cartItem ;
  @override
  Widget build(BuildContext context) {

    return Dismissible(
      confirmDismiss:(direction) {return showDialog(context: context, builder: (ctx) =>AlertDialog(title: const Text("Are you Sure"),
        content: const Text(
            "you are about to remove this item from Cart if you want to Continue Press I'm Sure , if not press Cancel"),
        actions: [
          defaultTextButton(onPressed: (){
            return Navigator.of(ctx).pop(false);
          }, text: "Cancel"),
          defaultTextButton(onPressed: (){
            return Navigator.of(ctx).pop(true);
          }, text: "I'm Sure"),
        ],));},
      onDismissed: (direction) {
        ShopCubit.get(context).addToCart(id: cartItem.product!.id!);
        ShopCubit.get(context).cartModel?.data?.cartItems?.removeWhere((element) => element.id == cartItem.id);
        // ShopCubit.get(context).inCart[cartItem.id!] = false ;
      },
      background: Container(
        color: Theme
            .of(context)
            .errorColor,
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white, size: 40,),
        alignment: Alignment.centerRight,
      ),
      direction: DismissDirection.endToStart,
      key: ValueKey(cartItem.id),
      child: Card(
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height:120 ,
            child: Row(
              children: [
                Expanded(flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Container(
                      color: Colors.white,
                      child: Material(
                        color:Colors.white,
                        child: Image.network(cartItem.product!.image!,fit: BoxFit.cover,),
                      ),
                    ),
                  ),
                ),
                Expanded(flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(cartItem.product!.name!,overflow: TextOverflow.ellipsis,),
                      ),
                      Text("${AppLocalizations.of(context)!.price_per_each} ${cartItem.product!.price!.toString()}"),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("${AppLocalizations.of(context)!.total}  ${cartItem.product!.price! * cartItem.quantity!}",),
                          Row(
                            children: [
                              FloatingActionButton(
                                  heroTag: "remove quantity ${cartItem.id}",
                                  mini: true ,
                                  child: const Icon(Icons.remove, color: Colors.black87),
                                  backgroundColor: Colors.white,
                                  onPressed: () {
                                    if(ShopCubit.get(context).quantityMap[cartItem.id] != 0) {
                                      ShopCubit.get(context).updateCarts(id: cartItem.id, quantity: cartItem.quantity! - 1);
                                    }
                                  }),
                              Text("${ShopCubit.get(context).quantityMap[cartItem.id]}X"),
                              FloatingActionButton(
                                  heroTag: "add quantity ${cartItem.product!.id}",
                                  mini: true,
                                  child: const Icon(Icons.add, color: Colors.black87),
                                  backgroundColor: Colors.white,
                                  onPressed: () {
                                    ShopCubit.get(context).updateCarts(id: cartItem.id, quantity: cartItem.quantity! + 1);
                                  }),
                            ],
                          ),

                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
