import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shop_app_mansour/layout/shop/cubit/shop_cubit.dart';
import 'package:shop_app_mansour/layout/shop/cubit/shop_states.dart';
import 'package:shop_app_mansour/layout/shop/full_screen_image_layout.dart';
import 'package:shop_app_mansour/models/address_model.dart';
import 'package:shop_app_mansour/modules/settings/address/edit_address_screen.dart';
import 'package:shop_app_mansour/shared/components/components.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class AddressListScreen extends StatelessWidget {
  const AddressListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (BuildContext context, state) {},
      builder: (BuildContext context, Object? state) {
          // ShopCubit.get(context).getAddresses();
        var addressesModel = ShopCubit.get(context).addressModel?.data?.data;
        return Scaffold(
          appBar: AppBar(),
          body: Column(
            children: [
              Expanded(
                child: Conditional.single(
                    context: context,
                    conditionBuilder: (BuildContext context) =>
                        addressesModel != null,
                    fallbackBuilder: (BuildContext context) =>
                        const Center(child: CircularProgressIndicator()),
                    widgetBuilder: (BuildContext context) {
                      return ListView.separated(
                        itemCount: addressesModel!.length,
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(
                          height: 30,
                        ),
                        itemBuilder: (BuildContext context, int index) =>
                            buildAddressItem(addressesModel[index],context),
                      );
                    }),
              ),
              defaultButton(
                  onPressed: () {
                    ShopCubit.get(context).clearAddressController();
                    navigateTo(context, EditAddress());

                  },
                  width: double.infinity,
                  text: AppLocalizations.of(context)!.add_address),
            ],
          ),
        );
      },
    );
  }
}

Widget buildAddressItem(DataAddress address,context) {
  // print('image  :${address.image.toString()}');
  return Dismissible(
    key: Key(address.id.toString()),
    direction: DismissDirection.endToStart,
    onDismissed: (direction) {
      ShopCubit.get(context).addressModel?.data?.data?.removeWhere((element) => element.id == address.id);
      ShopCubit.get(context).deleteAddress(id: address.id!.toString());

    },
    confirmDismiss: (direction) async {
      return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Confirm"),
            content: const Text("Are you sure you wish to delete this address?"),
            actions: <Widget>[
              defaultTextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  text: "DELETE"
              ),
              defaultTextButton(
                onPressed: () => Navigator.of(context).pop(false),
                text: "CANCEL"
              ),
            ],
          );
        },
      );
    },
    child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () {
            ShopCubit.get(context).clearAddressController();
            ShopCubit.get(context).isInitEditAddress = true;
            navigateTo(context , EditAddress(address: address,));
          },
          child: Row(children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(30.0),
                child: Hero(
                  tag: address.id!,
                  child: Material(
                      child: Ink.image(
                    child: InkWell(
                      onTap: () {
                        navigateTo(context,PreviewImageFullScreen(id: address.id!, image: NetworkImage(address.image!.toString()),));
                      },
                    ),
                    image: NetworkImage(address.image!.toString()),
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  )),
                )),
            const SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    address.name!,
                    style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${address.details}, ${address.region} , ${address.city}",
                    style: const TextStyle(fontSize: 16.0, color: Colors.grey),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    softWrap: true,
                  ),
                ],
              ),
            ),
            // Spacer(),
            const FaIcon(FontAwesomeIcons.edit),
          ]),
        ),
      ),
  );
}
