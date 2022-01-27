import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:shop_app_mansour/layout/shop/cubit/shop_cubit.dart';
import 'package:shop_app_mansour/layout/shop/cubit/shop_states.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


import '../../shared/components/constants.dart';
import '../../shared/styles/colors.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<ShopCubit,ShopStates>(listener: (BuildContext context, state) {},
      builder: (BuildContext context, Object? state) {
      return Conditional.single(
        context: context,
        fallbackBuilder: (BuildContext context) => const Center(child: CircularProgressIndicator()),
        conditionBuilder: (BuildContext context) => state is! LoadingFavoriteState  ,
        widgetBuilder: (BuildContext context) {
          var model = ShopCubit
              .get(context)
              .favoriteModel?.data?.favoriteData ;

          return ListView.separated(
            itemCount: model!.length,
            separatorBuilder: (BuildContext context, int index) => const Divider(height: 30,),
            itemBuilder: (BuildContext context, int index) => Container(height: 120.0,padding: const EdgeInsets.all(10.0),
              child: buildListItem(model[index].product,context),
            ),
          );},
      );
      },);
  }
}

Widget buildListItem(model,context) => Row(
  children: [
    Stack(
      alignment: AlignmentDirectional.bottomStart,
      children: [
        Image(
          image: NetworkImage(model.image!),
          width: 120.0,
          height: 120.0,

        ),
        if (model.discount! != 0)
          Container(
            color: Colors.red,
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Text(
              '${AppLocalizations.of(context)!.discount} ${ShopCubit.get(context).percentage(oldPrice:model.oldPrice!, price: model.price!).round().toString()}%',
              style:
              const TextStyle(fontSize: 10.0, color: Colors.white),
            ),
          )
      ],
    ),
    const SizedBox(width: 20.0,),
    Expanded(
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
                  if (model.discount! != 0)
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
                    model.removeWhere((element) => element.product
                    !.id ==  model.id);
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
);
