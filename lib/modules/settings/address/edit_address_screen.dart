

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app_mansour/layout/shop/cubit/shop_cubit.dart';
import 'package:shop_app_mansour/layout/shop/cubit/shop_states.dart';
import 'package:shop_app_mansour/modules/settings/address/map_screen.dart';
import 'package:shop_app_mansour/shared/components/components.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


import '../../../layout/shop/full_screen_image_layout.dart';
import '../../../models/address_model.dart';

class EditAddress extends StatelessWidget {
  EditAddress({Key? key, this.address}) : super(key: key);


  final DataAddress? address;


  final GlobalKey<FormState> formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (BuildContext context, state) {},
      builder: (BuildContext context, Object? state) {
        var mapImageUrl = ShopCubit
            .get(context)
            .mapImageUrlEdit;
        var cubit = ShopCubit.get(context);

        cubit.adduserAddressData(address);

        return Scaffold(
          appBar: AppBar(),
          body: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    defaultTextFormField(
                        label: AppLocalizations.of(context)!.tag, controller: cubit.tagController),
                    defaultTextFormField(
                        label: AppLocalizations.of(context)!.city,
                        controller: cubit.cityController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return AppLocalizations.of(context)!.address_validator;
                          }
                        }),
                    defaultTextFormField(
                        label: AppLocalizations.of(context)!.district,
                        controller: cubit.districtController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return AppLocalizations.of(context)!.address_validator;
                          }
                        }),
                    defaultTextFormField(
                        label: AppLocalizations.of(context)!.street,
                        controller: cubit.streetController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return AppLocalizations.of(context)!.address_validator;
                          }
                        },
                        onEditingComplete: () =>
                            ShopCubit.get(context).changeAddressToLatlng(
                                address:
                                "${ cubit.streetController.text},${ cubit
                                    .districtController.text},${ cubit
                                    .cityController.text},Egypt")),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:  [
                        const Expanded(
                            child: SizedBox(
                                child: Divider(
                                  thickness: 1,
                                ))),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            AppLocalizations.of(context)!.or,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const Expanded(
                            child: SizedBox(
                                child: Divider(
                                  thickness: 1,
                                ))),
                      ],
                    ),
                    defaultButton(
                      onPressed: () {
                        navigateTo(context, const MapScreen());
                      },
                      text: AppLocalizations.of(context)!.get_location_on_map,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    ClipRRect(
                        borderRadius: BorderRadius.circular(30.0),
                        child: Hero(
                          tag: address?.id != null? address!.id! : "map image",
                          child: Material(
                            child: Ink.image(
                              child: InkWell(
                                onTap: () {
                                  navigateTo(
                                      context,
                                      PreviewImageFullScreen(
                                        id: address?.id != null? address!.id! : "map image",
                                        image: mapImageUrl == null
                                            ? const NetworkImage(
                                            'https://www.aou.edu/wp-content/uploads/2017/06/nasr-city-cairo-egypt-google-maps.jpg')
                                            : NetworkImage(mapImageUrl),
                                      ));
                                },
                              ),
                              image: mapImageUrl == null
                                  ? const NetworkImage(
                                  'https://www.aou.edu/wp-content/uploads/2017/06/nasr-city-cairo-egypt-google-maps.jpg')
                                  : NetworkImage(mapImageUrl),
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width - 30.0,
                              height: MediaQuery
                                  .of(context)
                                  .size
                                  .width / 1.5,
                              fit: BoxFit.cover,
                            ),
                          ),
                        )),
                    defaultButton(text: AppLocalizations.of(context)!.save_button_title, onPressed: () async {
                      var center = mapImageUrl?.split('center=').last.split("&markers").first;
                      if (formKey.currentState!.validate()) {
                        address == null ?
                        ShopCubit.get(context).addAddress(name: cubit
                            .tagController.text,
                            city: cubit.cityController.text,
                            district: cubit.districtController.text,
                            street: cubit.streetController.text,
                            image: mapImageUrl,
                            latitude: center?.split(",").first,
                            longitude: center?.split(",").last,
                        )


                            : ShopCubit.get(context).updateAddress(
                            id: address!.id.toString(),
                            name: cubit.tagController.text,
                            city: cubit.cityController.text,
                            district: cubit.districtController.text,
                            street: cubit.streetController.text,
                            image: mapImageUrl,
                            latitude: center?.split(",").first,
                            longitude: center?.split(",").last,


                        );
                      }
                    })
                  ],
                ),
              )),
        );
      },);
  }
}
