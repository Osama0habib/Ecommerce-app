import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shop_app_mansour/layout/shop/cubit/shop_cubit.dart';
import 'package:shop_app_mansour/layout/shop/cubit/shop_states.dart';
import 'package:shop_app_mansour/models/address_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:shop_app_mansour/shared/components/components.dart';

import '../settings/address/edit_address_screen.dart';

class CheckOutScreen extends StatelessWidget {
  const CheckOutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (BuildContext context, state) {},
      builder: (BuildContext context, Object? state) {
        List<DataAddress>? addressesModel =
            ShopCubit.get(context).addressModel?.data?.data;
        return Scaffold(
          appBar: AppBar(),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Conditional.single(
                    context: context,
                    conditionBuilder: (BuildContext context) =>
                        addressesModel!.isNotEmpty,
                    fallbackBuilder: (BuildContext context) => Container(),
                    widgetBuilder: (BuildContext context) {
                      return Container(
                        constraints: BoxConstraints(
                            minHeight: (MediaQuery.of(context).size.height -
                                    AppBar().preferredSize.height) /
                                3),
                        child: ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: addressesModel!.length,
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    const Divider(
                                      height: 30,
                                    ),
                            itemBuilder: (BuildContext context, int index) =>
                                buildAddressChoose(
                                    addressesModel[index], context)),
                      );
                    }),
                Column(
                  children: [
                    const SizedBox(
                      height: 20.0,
                    ),
                    defaultButton(
                        onPressed: () {
                          ShopCubit.get(context).clearAddressController();
                          navigateTo(context, EditAddress());
                        },
                        width: double.infinity,
                        text: AppLocalizations.of(context)!.add_address),
                    const SizedBox(
                      height: 20.0,
                    ),
                     Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        AppLocalizations.of(context)!.payment_method,
                        style: const TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    ToggleButtons(
                      borderColor: Colors.black,
                      fillColor: Colors.grey,
                      borderWidth: 2,
                      selectedBorderColor: Colors.black,
                      selectedColor: Colors.white,
                      borderRadius: BorderRadius.circular(0),
                      children:  [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            AppLocalizations.of(context)!.cash_on_delivery,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            AppLocalizations.of(context)!.online_payment,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                      isSelected: ShopCubit.get(context).isPaymentSelected,
                      onPressed: (int index) =>
                          ShopCubit.get(context).paymentMethodToggle(index),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                           Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              AppLocalizations.of(context)!.use_points,
                              style: const TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                          // const Spacer(),
                          Switch(
                              value: ShopCubit.get(context).usePoints,
                              onChanged: (value) => ShopCubit.get(context)
                                  .usePointSwitch(value: value)),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          bottomNavigationBar: defaultButton(
              onPressed: ()  {
                 ShopCubit.get(context)
                    .addOrder(
                        address: ShopCubit.get(context).groupValue,
                        paymentMethod: ShopCubit.get(context).paymentMethod,
                        usePoints: ShopCubit.get(context).usePoints,context: context);
                 ShopCubit.get(context).clearOrderVariables();
                 // navigateTo(
                 //     context, OrderDetailScreen(id: value.data["data"]["id"]));

              },
              text: AppLocalizations.of(context)!.order_now),
        );
      },
    );
  }
}

buildAddressChoose(DataAddress address, context) => Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          ShopCubit.get(context).clearAddressController();
          ShopCubit.get(context).isInitEditAddress = true;
          navigateTo(
              context,
              EditAddress(
                address: address,
              ));
        },
        child: Row(children: [
          Radio(
            value: address.id!,
            groupValue: ShopCubit.get(context).groupValue,
            onChanged: (value) {
              ShopCubit.get(context).changeToggleValue(value);
            },
            activeColor: Colors.green,
          ),
          const SizedBox(
            width: 20.0,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  address.name!,
                  style: const TextStyle(
                      fontSize: 20.0, fontWeight: FontWeight.bold),
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
    );
