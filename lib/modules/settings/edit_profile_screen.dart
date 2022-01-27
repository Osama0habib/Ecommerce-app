import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:shop_app_mansour/layout/shop/cubit/shop_cubit.dart';
import 'package:shop_app_mansour/shared/components/components.dart';
import 'package:shop_app_mansour/shared/styles/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


import '../../layout/shop/cubit/shop_states.dart';
import '../../layout/shop/full_screen_image_layout.dart';
import '../../shared/components/constants.dart';
import '../popup_menu/popup_menu.dart';

class EditProfile extends StatelessWidget {
  EditProfile({Key? key}) : super(key: key);
 final TextEditingController userName = TextEditingController();
 final TextEditingController email = TextEditingController();
 final TextEditingController phone = TextEditingController();
 final GlobalKey<FormState> formKey = GlobalKey<FormState>();
 final GlobalKey btnKey = GlobalKey();


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (BuildContext context, state) {

      },
      builder: (BuildContext context, Object? state) {
        var userModel = ShopCubit.get(context).userModel?.data;
         if (kDebugMode) {
           print(token);
         }
        userName.text = userModel!.name!;
        email.text = userModel.email!;
        phone.text = userModel.phone!;
        ImageProvider<Object> imageProvider = (ShopCubit.get(context).pickedImage == null ? NetworkImage(userModel.image!) : FileImage(File(ShopCubit.get(context).pickedImage!.path))) as ImageProvider<Object>;
        return Scaffold(
          appBar: AppBar(),
          body: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Center(
                      child: Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            Hero(
                              tag: userModel.id.toString(),
                              child: ClipOval(
                                  child: Material(
                                child: Ink.image(
                                  image:  imageProvider,
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                  child: InkWell(onTap: (){
                                    navigateTo(context, PreviewImageFullScreen(image: imageProvider, id: userModel.id!.toString(),));
                                  },),
                                ),
                                shape: const CircleBorder(),
                                color: Colors.transparent,

                              ),),
                            ),
                            Material(
                              shape: const CircleBorder(),
                              color: Colors.blue,
                              child: InkWell(
                                key: btnKey,

                                onTap: () {
                                  PopupMenu menu = PopupMenu(context: context,
                                        backgroundColor: defaultColor,
                                      onClickMenu: ShopCubit.get(context).onClickMenu,
                                      items: [
                                        MenuItem(
                                            title: AppLocalizations.of(context)!.camera,
                                            image: const Icon(Icons.camera,color: Colors.white,),
                                            textStyle: const TextStyle(color: Colors.white, fontSize: 10.0),
                                            textAlign: TextAlign.center),
                                        MenuItem(
                                            title: AppLocalizations.of(context)!.gallery,
                                            image: const Icon(Icons.photo,color: Colors.white,),
                                            textAlign: TextAlign.center,
                                            textStyle: const TextStyle(color: Colors.white, fontSize: 10.0))
                                      ]);

                                  menu.show(widgetKey: btnKey);
                                },
                                radius: 20.0,
                                borderRadius: BorderRadius.circular(100),
                                child: const SizedBox(
                                  height: 40,
                                  width: 40,
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )
                          ]),
                    ),
                  ),
                  defaultTextFormField(
                      label: AppLocalizations.of(context)!.text_field_label_name,
                      prefixIcon: const Icon(Icons.person),
                      controller: userName,
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return AppLocalizations.of(context)!.text_field_validator_name;
                        }
                      }),
                  defaultTextFormField(
                      label: AppLocalizations.of(context)!.text_field_label_email,
                      prefixIcon: const Icon(Icons.alternate_email),
                      controller: email,
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return AppLocalizations.of(context)!.text_field_validator_email;
                        }
                        if (value.contains('@') == false) {
                          return AppLocalizations.of(context)!.text_field_validator_email_2;
                        }
                      }),
                  defaultTextFormField(
                      label: AppLocalizations.of(context)!.text_field_label_phone,
                      prefixIcon: const Icon(Icons.phone_android),
                      controller: phone,
                      validator: (String? value) {
                        if (value!.length > 11) {
                          return AppLocalizations.of(context)!.text_field_validator_phone;
                        }
                      }),
                  Conditional.single(
                      conditionBuilder: (BuildContext context) {
                        return state is! LoadingUpdateUserDataState;
                      },
                      widgetBuilder: (BuildContext context) {
                        return defaultButton(
                            onPressed: () {

                              if (formKey.currentState!.validate()) {
                                // userModel.name = userName.text;
                                // userModel.phone = phone.text;
                                // userModel.email = email.text;

                                ShopCubit.get(context).pickedImage != null ?
                                ShopCubit.get(context).updateUserProfile(
                                    username: userName.text.toString(),
                                    phone: phone.text.toString(),
                                    email: email.text.toString(),
                                    image: base64Encode(File(ShopCubit.get(context).pickedImage!.path).readAsBytesSync()) ,)

                                    :ShopCubit.get(context).updateUserProfile(
                                  username: userName.text.toString(),
                                  phone: phone.text.toString(),
                                  email: email.text.toString(),
                                );

                              }
                            },
                            text: AppLocalizations.of(context)!.save_button_title,
                            width: double.infinity);
                      },
                      context: context,
                      fallbackBuilder: (BuildContext context) {
                        return const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
