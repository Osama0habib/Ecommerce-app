import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app_mansour/layout/shop/cubit/shop_cubit.dart';
import 'package:shop_app_mansour/layout/shop/cubit/shop_states.dart';
import 'package:shop_app_mansour/models/categories_model.dart';
import 'package:shop_app_mansour/modules/categories/category_product_screen.dart';
import 'package:shop_app_mansour/shared/components/components.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (BuildContext context, state) {},
      builder: (BuildContext context, Object? state) {
        var categoriesModel = ShopCubit.get(context).categoriesModel;
        return ListView.separated(
          itemCount: categoriesModel!.data!.data!.length,
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(height: 30,),
          itemBuilder: (BuildContext context, int index) =>
              buildCategoryItem(categoriesModel.data!.data![index],context),
        );
      },
    );
  }
}

Widget buildCategoryItem(DataModel model,context) => InkWell(
  onTap: (){
    ShopCubit.get(context).getCategoriesProduct(id: model.id);
    navigateTo(context,  CategoryProductScreen(name : model.name));
  },
  child:   Padding(
    padding: const EdgeInsets.all(8.0),
    child:   Row(
          children: [
            Image(image: NetworkImage(model.image!),height: 100 ,width: 100,fit: BoxFit.cover,),
            const SizedBox(width: 20.0,),
            Text(model.name!,style: const TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios),
          ]




        ),
  ),
);
