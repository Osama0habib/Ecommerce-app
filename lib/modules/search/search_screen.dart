import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app_mansour/modules/search/cubit/search_cubit.dart';
import 'package:shop_app_mansour/modules/search/cubit/search_states.dart';
import 'package:shop_app_mansour/shared/components/components.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


import '../products/products_screen.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    TextEditingController searchController = TextEditingController();
    return BlocProvider(
      create: (BuildContext context) => SearchCubit(),
      child: BlocConsumer<SearchCubit,SearchStates>(
        listener: (BuildContext context, state) {  },
        builder: (BuildContext context, Object? state) {

          var cubit = SearchCubit.get(context);
          return Scaffold(
              appBar: AppBar(),
              body: Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(children: [
                    defaultTextFormField(label: AppLocalizations.of(context)!.search,controller: searchController,type: TextInputType.text,validator: (value) {
                      if(value!.isEmpty)
                        {
                          return null;
                        }
                      return null;
                    },suffixIcon:  IconButton(icon:const Icon(Icons.search),onPressed: (){
                      cubit.searchProduct(searchController.text);


                    },),onSubmit: (String text){
                      cubit.searchProduct(text);
                    }),
                    const SizedBox(height: 10.0,),
                    if(state is SearchLoadingState)
                    const LinearProgressIndicator(),
                    const SizedBox(height: 10.0,),
                    if(state is SearchSuccessState)
                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.all(8.0),
                        itemCount: cubit.searchModel!.data!.searchData!.length,
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
                            buildGridProduct(cubit.searchModel?.data?.searchData?[index], context),
                      ),
                    )
                  ],),
                ),
              )
          );
        },),
    );
  }
}
