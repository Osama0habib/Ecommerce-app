import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';

import '../../layout/shop/cubit/shop_cubit.dart';
import '../../layout/shop/cubit/shop_states.dart';
import '../products/products_screen.dart';

class CategoryProductScreen extends StatelessWidget {
   const CategoryProductScreen({Key? key,this.name}) : super(key: key);
  final String? name;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
        listener: (BuildContext context, state) {},
        builder: (BuildContext context, Object? state) {
          var product = ShopCubit.get(context).categoryProductsModel?.data?.data;
          return Scaffold(
            appBar: AppBar(title: Text(name!),),
            body: Conditional.single(
                context: context,
                conditionBuilder: (BuildContext context) => state is! LoadingCategoryProductState ,
                fallbackBuilder: (BuildContext context) =>const Center(child: CircularProgressIndicator()),
                widgetBuilder: (BuildContext context) {return        GridView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: product!.length,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 5.0,
                      mainAxisSpacing: 5.0,
                      childAspectRatio: 3 / 2,
                      mainAxisExtent: 310),
                  itemBuilder: (BuildContext context, int index) =>
                      buildGridProduct(product[index], context),
                );  })
          );
        });
  }
}
