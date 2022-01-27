import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:shop_app_mansour/layout/shop/cubit/shop_cubit.dart';
import 'package:shop_app_mansour/layout/shop/cubit/shop_states.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


import '../../models/orders_model.dart';
import '../../shared/components/components.dart';
import 'order_detail_screen.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (BuildContext context, state) {},
      builder: (BuildContext context, Object? state) {
        List<OrderItem>? orders = ShopCubit.get(context).ordersModel?.data?.data;
        return Scaffold(
          appBar: AppBar(),
          body: Conditional.single(
    context: context,
    conditionBuilder: (BuildContext context) => ShopCubit.get(context).ordersModel != null && state is! GetOrdersLoadingState ,
    fallbackBuilder: (BuildContext context) {


      return const Center(child: CircularProgressIndicator());
    },
    widgetBuilder: (BuildContext context) {

      return ListView.separated(
        itemCount: orders!.length,
        separatorBuilder: (BuildContext context, int index) => const Divider(height: 30,),
        itemBuilder: (BuildContext context, int index) {

          return buildOrderItem(orders[index],context);
            //OrderItemWidget(order :orders[index]);
        },
      );
    }),

        );
      },
    );
  }
}

buildOrderItem(OrderItem? order,context)
{
 Map<int,bool> expand = ShopCubit.get(context).expand;


  return AnimatedContainer(
    duration: const Duration(
      milliseconds: 300,
    ),
    height: expand[order?.id]! ? min(4 * 25.0 + 110, 200) : 80,
    child: Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text("${order?.date}"),
            trailing: IconButton(
                icon: Icon(expand[order?.id]! ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                    ShopCubit.get(context).orderExpand(order?.id);

                }),
          ),
          // if (_expand)
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
            height: expand[order?.id]! ? min(4 * 20.0 + 32, 180) : 0,
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(AppLocalizations.of(context)!.total),
                      const Spacer(),
                      Text("${order?.total?.toStringAsFixed(2)}")
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(AppLocalizations.of(context)!.status),
                      const Spacer(),
                      Text("${order?.status}")
                    ],
                  ),
                ),
                defaultTextButton(onPressed: (){
                  navigateTo(context, OrderDetailScreen( id: order!.id!,));
                },text: AppLocalizations.of(context)!.more_details),
              ],
            ),
          )
        ],
      ),
    ),
  );
}
