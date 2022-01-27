import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:shop_app_mansour/layout/shop/cubit/shop_states.dart';
import 'package:shop_app_mansour/models/order_details_model.dart';

import '../../layout/shop/cubit/shop_cubit.dart';
import '../../shared/components/components.dart';
import '../products/product_details_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OrderDetailScreen extends StatelessWidget {
  const OrderDetailScreen({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (BuildContext context, state) {},
      builder: (BuildContext context, Object? state) {
        Data? data = ShopCubit.get(context).ordersDetailsModel?.data;
        if(data?.id == null || data?.id != id){
          ShopCubit.get(context).getOrderDetails(id: id);

        }

        return Scaffold(
          appBar: AppBar(),
          body: Conditional.single(
              context: context,
              conditionBuilder: (BuildContext context) => data?.id == id ,
              fallbackBuilder: (BuildContext context) => const Center(child: CircularProgressIndicator()),
              widgetBuilder: (BuildContext context) {

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            elevation: 20,
                            child: ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: data!.products!.length,
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
                                                    data.products?[index].id)));
                                      },
                                      child: buildProductItem(
                                          data.products?[index], context));
                                }),
                          )),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: double.infinity,
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                AppLocalizations.of(context)!.ordered_in,
                                        style: const TextStyle(fontSize: 18.0),
                                      ),
                                      const Spacer(),
                                      Text(
                                        "${data.date}",
                                        style: const TextStyle(fontSize: 18.0),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                      AppLocalizations.of(context)!.payment_method,
                                        style: const TextStyle(fontSize: 18.0),
                                      ),
                                      const Spacer(),
                                      Text(
                                        "${data.paymentMethod}",
                                        style: const TextStyle(fontSize: 18.0),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                   Text(
                AppLocalizations.of(context)!.deliver_to,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold, fontSize: 18.0),
                                  ),
                                  const SizedBox(
                                    height: 10,),
                                  Text(
                                    data.address!.city!,
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(height: 5.0,),
                                  Text(
                                    "${data.address!.details!} , ${data.address!.region!}",
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                  children:  [
                                     Text(
                            AppLocalizations.of(context)!.cost,
                                      style: const TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),
                                    ),
                                    const Spacer(),
                                    Text(
                                      "${AppLocalizations.of(context)!.currency_egp} ${data.cost?.toStringAsFixed(2)}",
                                      style: const TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children:  [
                                     Text(
                AppLocalizations.of(context)!.vat,
                                      style: const TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),
                                    ),
                                    const Spacer(),
                                    Text(
                                      "${AppLocalizations.of(context)!.currency_egp} +${data.vat?.toStringAsFixed(2)}",
                                      style: const TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children:  [
                                     Text(
                                       AppLocalizations.of(context)!.discount,
                                      style: const TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),
                                    ),
                                    const Spacer(),
                                    Text(
                                      "${AppLocalizations.of(context)!.currency_egp} -${data.discount?.toStringAsFixed(2)}",
                                      style: const TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children:  [
                                     Text(
                AppLocalizations.of(context)!.points,
                                      style: const TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),
                                    ),
                                    const Spacer(),
                                    Text(
                                      "-${data.points?.toStringAsFixed(2)}",
                                      style: const TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),

                              ],
                            ),
                          ),
                        ),
                      ),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children:  [
                           Text(
                            AppLocalizations.of(context)!.total,
                            style: const TextStyle(fontSize: 30.0,fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${AppLocalizations.of(context)!.currency_egp} ${data.total?.toStringAsFixed(2)}",
                            style: const TextStyle(fontSize: 30.0,fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      if(data.status == AppLocalizations.of(context)!.status_new)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextButton(child: Text(AppLocalizations.of(context)!.cancel_order,style: const TextStyle(color: Colors.red,fontSize: 20.0),) , onPressed: () {ShopCubit.get(context).cancelOrder(id: data.id,context: context);}),
                      )
                    ],
                  ),
                );
              }),
        );
      },
    );
  }
}

buildProductItem(Products? product, context) => Card(
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 120,
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Container(
                    color: Colors.white,
                    child: Material(
                      color: Colors.white,
                      child: Image.network(
                        product!.image!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        product.name!,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                        "${AppLocalizations.of(context)!.price_per_each} ${product.price!.toString()}"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${AppLocalizations.of(context)!.total}  ${product.price! * product.quantity!}",
                        ),
                        Text("${product.quantity}X"),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
