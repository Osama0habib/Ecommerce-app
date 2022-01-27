import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shop_app_mansour/layout/cubit/app_cubit.dart';
import 'package:shop_app_mansour/layout/cubit/app_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


import '../../shared/components/constants.dart';

class AppSettingScreen extends StatelessWidget {
   AppSettingScreen({Key? key}) : super(key: key);
  // bool isDark = false;
  final language =  ['English','عربي'];
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (BuildContext context, state) {  },
      builder: (BuildContext context, Object? state) {
        return Scaffold(
          appBar: AppBar(),
          body: Column(children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Card(
                elevation: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children:  [
                     Text(AppLocalizations.of(context)!.share_with_friends,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 18.0),),
                    // SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(onPressed: (){}, icon: const FaIcon(FontAwesomeIcons.whatsapp,size: 40.0,color: Colors.green,)),
                          IconButton(onPressed: (){}, icon: const FaIcon(FontAwesomeIcons.facebook,size: 40.0,color: Colors.blue,)),
                          IconButton(onPressed: (){}, icon: const FaIcon(FontAwesomeIcons.instagram,size: 40.0,color: Colors.red,)),
                          IconButton(onPressed: (){}, icon: const FaIcon(FontAwesomeIcons.twitter,size: 40.0,color: Colors.blue,)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(children:  [
                 Text(AppLocalizations.of(context)!.app_language,style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                const Spacer(),
                DropdownButton(

                  borderRadius: BorderRadius.circular(20),
                  elevation: 10,
                  value: dropdownValue,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items:
                  language.map((String items) {
                    return DropdownMenuItem(
                        value: items,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(items,style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                        )
                    );
                  }
                  ).toList(),
                  onChanged: (String? newValue){
                    dropdownValue = newValue!;
                    AppCubit.get(context).toggleLanguage(fromShared: newValue , context: context);
                  },
                ),
              ],),
            ),
            const SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(children:  [
                 Text(AppLocalizations.of(context)!.dark_mode,style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                const Spacer(),
                Switch(
                    value: isDark, onChanged: (value) {

                  AppCubit.get(context).toggleDarkMode();

                })
              ],),
            ),

          ],),
        );
      },);
  }
}
