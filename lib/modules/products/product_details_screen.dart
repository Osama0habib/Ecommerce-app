import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app_mansour/layout/shop/cubit/shop_cubit.dart';
import 'package:shop_app_mansour/layout/shop/cubit/shop_states.dart';
import 'package:shop_app_mansour/layout/shop/full_screen_image_layout.dart';
import 'package:shop_app_mansour/models/home_model.dart';
import 'package:shop_app_mansour/shared/components/components.dart';
import 'package:shop_app_mansour/shared/styles/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({Key? key, required this.product}) : super(key: key);

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (BuildContext context, state) {
        if(State is SuccessAddToCartState) {
          ShopCubit.get(context).getHomeData();
        }
      },
      builder: (BuildContext context, Object? state) {
        return Scaffold(
          appBar: AppBar(),
          body: SingleChildScrollView(
            child: Column(
              children: [
                CarouselSlider(

                  items: [
                    ...product.images!.map((e) {
                      return SizedBox(
                          height: 300.0,
                          child: Hero(
                              tag: e,
                              child: Material(color: Colors.white,
                                  child: Ink.image(
                                image: NetworkImage(
                                  e,
                                ),
                                child: InkWell(
                                  onTap: () {
                                    navigateTo(
                                        context,
                                        PreviewImageFullScreen(
                                            id: e, image: NetworkImage(e)));
                                  },
                                ),
                              ))));
                    }),
                  ],
                  options: CarouselOptions(
                    height: 300.0,
                    initialPage: 0,
                    viewportFraction: 1.0,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: false,
                    autoPlayInterval: const Duration(seconds: 3),
                    autoPlayAnimationDuration: const Duration(seconds: 1),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    scrollDirection: Axis.horizontal,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Card(
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all( 8.0),
                            child: Text(
                              product.name!,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              style: const TextStyle(height: 1.3,fontSize: 16),
                            ),
                          ),
                          if (product.discount != null)
                            if (product.discount != 0)
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  "${AppLocalizations.of(context)!.currency_egp} ${product.oldPrice!.toString()}",
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    height: 1.3,
                                    color: Colors.grey,
                                    decoration: TextDecoration.lineThrough,
                                    decorationThickness: 2.0,
                                    decorationColor: Colors.red,
                                  ),
                                ),
                              ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0,),
                            child: Text(
                              "${AppLocalizations.of(context)!.currency_egp} ${product.price.toString()}",
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 18.0,
                                height: 1.3,
                                color: defaultColor,
                                decorationThickness: 2.0,
                              ),
                            ),
                          ),
                          if (product.discount != null)
                            if (product.discount != 0)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "${ AppLocalizations.of(context)!.save_cost} ${ AppLocalizations.of(context)!.currency_egp} ${product.oldPrice - product.price}",
                                  style: const TextStyle(color: Colors.green),
                                ),
                              ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(child: Text( AppLocalizations.of(context)!.description,style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            product.description!,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1000,
                            style: const TextStyle(
                              height: 1.3,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar:
              defaultButton(onPressed: () {
                ShopCubit.get(context).addToCart(id :product.id!);
              }, text: ShopCubit.get(context).inCart[product.id]! ?  AppLocalizations.of(context)!.remove_from_cart :  AppLocalizations.of(context)!.add_to_cart,color:ShopCubit.get(context).inCart[product.id]! ? Colors.grey : defaultColor ),
        );
      },
    );
  }
}
