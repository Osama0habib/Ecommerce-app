import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:shop_app_mansour/layout/shop/cubit/shop_cubit.dart';
import 'package:shop_app_mansour/layout/shop/cubit/shop_states.dart';
import 'package:shop_app_mansour/models/categories_model.dart';
import 'package:shop_app_mansour/models/home_model.dart';
import 'package:shop_app_mansour/modules/products/product_details_screen.dart';
import 'package:shop_app_mansour/shared/components/components.dart';
import 'package:shop_app_mansour/shared/components/constants.dart';
import 'package:shop_app_mansour/shared/styles/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


import '../categories/category_product_screen.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (BuildContext context, state) {},
      builder: (BuildContext context, Object? state) {
        var homeModel = ShopCubit.get(context).homeModel;
        var categoriesModel = ShopCubit.get(context).categoriesModel;

        return Conditional.single(
            context: context,
            conditionBuilder: (context) =>
                homeModel != null && categoriesModel != null,
            widgetBuilder: (context) =>
                productBuilder(homeModel!, categoriesModel!,context),
            fallbackBuilder: (context) =>
                const Center(child: CircularProgressIndicator()));
      },
    );
  }
}

Widget productBuilder(HomeModel model, CategoriesModel categoriesModel,context) =>
    SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CarouselSlider(
            items: model.data?.banners
                .map((e) => Image(
                      image: NetworkImage('${e.image}'),
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ))
                .toList(),
            options: CarouselOptions(
              height: 200.0,
              initialPage: 0,
              viewportFraction: 1.0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 3),
              autoPlayAnimationDuration: const Duration(seconds: 1),
              autoPlayCurve: Curves.fastOutSlowIn,
              scrollDirection: Axis.horizontal,
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
           Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              AppLocalizations.of(context)!.bottom_nav_2_and_title,
              style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          SizedBox(
              height: 100.0,
              child: Center(
                child: ListView.separated(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => buildCategoryItem(
                        categoriesModel.data!.data![index], context),
                    separatorBuilder: (context, index) => const SizedBox(
                          width: 8,
                        ),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    physics: const BouncingScrollPhysics(),
                    itemCount: categoriesModel.data!.data!.length),
              )),
          const SizedBox(
            height: 10.0,
          ),
           Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              AppLocalizations.of(context)!.products,
              style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.w800),
            ),
          ),
          GridView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: model.data?.products.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 5.0,
                mainAxisSpacing: 5.0,
                childAspectRatio: 3 / 2,
                mainAxisExtent: 310),
            itemBuilder: (BuildContext context, int index) =>
                buildGridProduct(model.data!.products[index], context),
          )
        ],
      ),
    );

Widget buildGridProduct(model, context) => InkWell(
      onTap: () {
        navigateTo(context, ProductDetailsScreen(product: model));
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, style: BorderStyle.solid)),
          child: Column(
            children: [
              Stack(
                alignment: AlignmentDirectional.bottomStart,
                children: [
                  Material(color: Colors.white,
                    child: Image(
                      image: NetworkImage(model.image!,),
                      width: double.infinity,
                      height: 200.0,
                    ),
                  ),
                  if (model.discount != null)
                    if (model.discount != 0)
                      Container(
                        color: Colors.red,
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Text(
                          '${AppLocalizations.of(context)!.discount} ${ShopCubit.get(context).percentage(oldPrice: model.oldPrice, price: model.price).round().toString()}%',
                          style: const TextStyle(
                              fontSize: 10.0, color: Colors.white),
                        ),
                      )
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 36,
                      child: Text(
                        model.name!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,


                        style:  TextStyle(height: 1.3,fontSize:appLanguage == 'en' ? 15 : 12),
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (model.discount != null)
                              if (model.discount != 0)
                                Text(
                                  "${AppLocalizations.of(context)!.currency_egp} ${model.oldPrice!.round().toString()}",
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 12.0,
                                    height: 1.3,
                                    color: Colors.grey,
                                    decoration: TextDecoration.lineThrough,
                                    decorationThickness: 2.0,
                                    decorationColor: Colors.red,
                                  ),
                                ),
                            Text(
                              "${AppLocalizations.of(context)!.currency_egp} ${model.price!.round().toString()}",
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 14.0,
                                  height: 1.3,
                                  color: defaultColor),
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 5.0,
                        ),
                        const Spacer(),
                        IconButton(
                            onPressed: () {
                              ShopCubit.get(context).toggleFavorite(model.id);
                            },
                            icon: Icon(
                              ShopCubit.get(context).favorite[model.id]!
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: Colors.red,
                            ))
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

Widget buildCategoryItem(DataModel model, context) => InkWell(
      onTap: () {
        ShopCubit.get(context).getCategoriesProduct(id: model.id);
        navigateTo(context, CategoryProductScreen(name: model.name));
      },
      child: SizedBox(
        width: 100.0,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: GridTile(
            child: Image(
              image: NetworkImage(model.image!),
              fit: BoxFit.cover,
            ),
            footer: SizedBox(
              height: 25.0,
              child: GridTileBar(
                title: Text(model.name!),
                backgroundColor: Colors.black54,
              ),
            ),
          ),
        ),
      ),
    );
