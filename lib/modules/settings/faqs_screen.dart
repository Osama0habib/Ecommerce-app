import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app_mansour/layout/shop/cubit/shop_cubit.dart';
import 'package:shop_app_mansour/layout/shop/cubit/shop_states.dart';
import 'package:shop_app_mansour/models/faqs_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class FAQsScreen extends StatelessWidget {
   const FAQsScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (BuildContext context, state) {},
      builder: (BuildContext context, Object? state) {
        var faqsModel = ShopCubit.get(context).faQsModel!.data!.data;
        return Scaffold(
          appBar: AppBar(),
          body: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Padding(
                padding: const EdgeInsets.symmetric(vertical: 25.0,horizontal: 15.0),
                child: Text(AppLocalizations.of(context)!.faqs_title,style: const TextStyle(fontSize: 25.0,fontWeight: FontWeight.bold,letterSpacing: 1),),
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: faqsModel!.length,
                  separatorBuilder: (BuildContext context, int index) =>
                  const Divider(height: 30,),
                  itemBuilder: (BuildContext context, int index) =>
                      buildCategoryItem(faqsModel[index],context),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

Widget buildCategoryItem(DataFAQs model,context) => Padding(
  padding: const EdgeInsets.all(15.0),
  child:   Column(crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      InkWell(
        child: Row(mainAxisAlignment: MainAxisAlignment.start,

            children: [
               CircleAvatar(child: Text(AppLocalizations.of(context)!.faqs_question,style: const TextStyle(color: Colors.white),),),
              const SizedBox(width: 20.0,),
              Text(model.question!,maxLines: 3,style: const TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold,),),
              const Spacer(),
               Icon(model.answerVisibility! ?Icons.arrow_forward_ios : Icons.keyboard_arrow_down),
            ]
        ),
        onTap:()=> ShopCubit.get(context).toggleVisibility(model.id)
      ),
      Visibility(maintainState: true,
        maintainAnimation: true,
        visible: model.answerVisibility!,
        child: Column(
          children: [
            const SizedBox(height: 20.0,),
            Row(children: [
               CircleAvatar(child: Text(AppLocalizations.of(context)!.faqs_answer,style: const TextStyle(color: Colors.white),),),
              const SizedBox(width: 20.0,),
              Flexible(fit: FlexFit.loose,child: Text(model.answer!,maxLines: 5,overflow: TextOverflow.ellipsis,style: const TextStyle(fontSize: 14.0,),)),
            ],),
          ],
        ),
      )
    ],
  ),
);
