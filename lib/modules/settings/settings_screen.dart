import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shop_app_mansour/layout/shop/cubit/shop_cubit.dart';
import 'package:shop_app_mansour/layout/shop/cubit/shop_states.dart';
import 'package:shop_app_mansour/models/login_model.dart';
import 'package:shop_app_mansour/modules/login/login_screen.dart';
import 'package:shop_app_mansour/modules/settings/address/edit_address_screen.dart';
import 'package:shop_app_mansour/modules/settings/app_setting_screen.dart';
import 'package:shop_app_mansour/modules/settings/edit_profile_screen.dart';
import 'package:shop_app_mansour/modules/settings/faqs_screen.dart';
import 'package:shop_app_mansour/shared/components/components.dart';
import 'package:shop_app_mansour/shared/components/constants.dart';
import 'package:shop_app_mansour/shared/styles/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


import '../../layout/shop/full_screen_image_layout.dart';
import '../orders/order_screen.dart';
import 'about_screen.dart';
import 'address/address_list_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (BuildContext context, state) {},
      builder: (BuildContext context, Object? state) {
        List<Map<String, dynamic>> settingListITem = [
          {
            'title': AppLocalizations.of(context)!.setting_addresses,
            'icon': Icons.map_outlined,
            'onTap': () => navigateTo(context,ShopCubit.get(context).addressModel == null ? EditAddress():  const AddressListScreen())
          },
          {
            'title': AppLocalizations.of(context)!.setting_orders,
            'icon': Icons.delivery_dining,
            'onTap': () => navigateTo(context, const OrderScreen())
          },
          {
            'title': AppLocalizations.of(context)!.setting_app_setting,
            'icon': Icons.settings,
            'onTap': () => navigateTo(context, AppSettingScreen())
          },
          {
            'title': AppLocalizations.of(context)!.setting_faqs,
            'icon': Icons.question_answer,
            'onTap': () => navigateTo(context, const FAQsScreen())
          },
          {
            'title': AppLocalizations.of(context)!.setting_about,
            'icon': Icons.developer_board,
            'onTap': () => navigateTo(context, const AboutScreen())
          },
          {
            'title': AppLocalizations.of(context)!.setting_logout,
            'icon': Icons.logout,
            'onTap': () {
              signOut(context);
              Navigator.pop(context);
              navigateAndFinish(context, LoginScreen());
            }
          },
        ];

        var cubit = ShopCubit.get(context).userModel;
        if(cubit?.data ==null) ShopCubit.get(context).getUserData();
        return Scaffold(
          body:Conditional.single(
              context: context,
              conditionBuilder:(context) => cubit?.data !=  null,
              widgetBuilder: (context) =>   Container(child: MediaQuery.of(context).orientation == Orientation.portrait
                  ? SingleChildScrollView(
                child: Column(
                    children: screenContent(
                        context: context,
                        cubit: cubit,
                        settingListITem: settingListITem)),
              )
                  : Row(
                  children: screenContent(
                      context: context,
                      cubit: cubit,
                      settingListITem: settingListITem)),),
              fallbackBuilder:(context) => const Center(child: CircularProgressIndicator()))
          ,
        );
      },
    );
  }
}

Widget buildCard(UserData? user,context) => Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 10.0,
      child: Stack(
        alignment: AlignmentDirectional.topEnd,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: IconButton(
              onPressed: () => navigateTo(context, EditProfile()),
              icon:
              // ImageIcon(const AssetImage('assets/icons/edit.svg'),size: 20,color: Colors.blue[400],),
              const FaIcon(
                FontAwesomeIcons.edit,
                color: defaultColor,
                size: 20,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Center(
              child: Column(
                children: [
                  const SizedBox(
                    height: 30.0,
                  ),
                  Hero(
                    tag: user!.id.toString(),
                    child: ClipOval(
                      child: Material(
                        child: Ink.image(
                          image: NetworkImage(user.image!),
                          width: 80,
                          height: 80,
                          child: InkWell(onTap: (){
                            navigateTo(context, PreviewImageFullScreen(image: NetworkImage(user.image!), id: user.id!.toString(),));
                          },),
                        ),
                        shape: const CircleBorder(),
                        color: Colors.transparent,

                      ),),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      user.name!,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 22.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      user.email!,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          color: Colors.grey),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      Row(children:  [
                        const Icon(Icons.star),
                        const SizedBox(width: 10,),
                        Text(user.points!.toString()),
                      ],),
                      const SizedBox(width: 50.0,),
                      Row(children:  [
                        const Icon(Icons.monetization_on),
                        const SizedBox(width: 10,),
                        Text(user.credit!.toString()),
                      ],),
                    ],),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );

Widget buildSettingList(
        {required List<Map<String, dynamic>> settingListITem, context}) =>
    ListView.separated(
      physics: MediaQuery.of(context).orientation == Orientation.portrait
          ? const NeverScrollableScrollPhysics()
          : const BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: settingListITem.length,
      separatorBuilder: (BuildContext context, int index) => const Divider(
        height: 20,
      ),
      itemBuilder: (BuildContext context, int index) =>
          buildSettingListItem(settingListITem[index],context),
    );

Widget buildSettingListItem(settingListITem,context) => ListTile(
      onTap: settingListITem['onTap'],
      horizontalTitleGap: 35.0,
      leading: CircleAvatar(
        radius: 30.0,
        backgroundColor: blueToBlack(context),
        child: Icon(
          settingListITem['icon'],
          size: 40.0,
          color: Colors.white,
        ),
      ),
      title: Text(
        settingListITem['title'],
        style: const TextStyle(
            fontWeight: FontWeight.bold, fontSize: 20.0, letterSpacing: 2),
      ),
  trailing: const Icon(Icons.arrow_forward_ios_outlined),
    );

List<Widget> screenContent({context, cubit, settingListITem}) {
  return [
    Container(
        height: MediaQuery.of(context).orientation == Orientation.portrait
            ? MediaQuery.of(context).size.height / 4
            : MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).orientation == Orientation.portrait
            ? double.infinity
            : MediaQuery.of(context).size.width / 3,
        color: MediaQuery.of(context).orientation == Orientation.portrait
            ? blueToBlack(context)
            : Colors.white,
        child: MediaQuery.of(context).orientation == Orientation.portrait
            ? Stack(
                alignment: Alignment.center,
                fit: StackFit.loose,
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                      width: MediaQuery.of(context).size.width - 50.0,
                      top: 65,
                      child: buildCard(cubit!.data,context))
                ],
              )
            : Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
                child: buildCard(cubit!.data,context),
              )),
    Column(children: [
      MediaQuery.of(context).orientation == Orientation.portrait
          ? Column(
              children: [
                const SizedBox(
                  height:120.0,
                ),
                SizedBox(
                    height: MediaQuery.of(context).size.height * 0.55,
                    child: buildSettingList(
                        settingListITem: settingListITem, context: context)),
              ],
            )
          : SizedBox(
              width: MediaQuery.of(context).size.width * 0.50,
              height: MediaQuery.of(context).size.height -
                  (AppBar().preferredSize.height + 80),
              child: buildSettingList(
                  settingListITem: settingListITem, context: context))
    ]),
  ];
}
