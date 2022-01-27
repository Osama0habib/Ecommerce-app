import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app_mansour/layout/shop/cubit/shop_cubit.dart';
import 'package:shop_app_mansour/layout/shop/cubit/shop_states.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


import '../../models/setting_model.dart';


class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit,ShopStates>(
      listener: (BuildContext context, state) {  },
      builder: (BuildContext context, Object? state) {
        var cubit = ShopCubit.get(context).settingModel!.data;
        return Scaffold(
          appBar: AppBar(),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: <Widget>[_buildInfo1(context), _buildInfo2(cubit!,context), _buildInfo3(context),_buildInfo4(context)],
            ),
          ),
        );
      },);
  }

  Widget _buildInfo1(context) {
    return Container(
        padding: const EdgeInsets.all(10),
        child: Card(
          child: Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.all(15),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.redAccent,
                        child: Image.asset(
                          'assets/icons/logo.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children:  <Widget>[
                          Text(AppLocalizations.of(context)!.app_title,style:
                          const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                   ListTile(
                    leading: const Icon(Icons.info),
                    title: Text(AppLocalizations.of(context)!.about_version),
                    subtitle: Text(AppLocalizations.of(context)!.about_version_number),
                  ),
                  const Divider(),
                   ListTile(
                    leading: const Icon(Icons.cached),
                    title: Text(AppLocalizations.of(context)!.about_changelog),
                  ),
                  const Divider(),
                   ListTile(
                      leading: const Icon(Icons.offline_pin), title: Text(AppLocalizations.of(context)!.about_license)),
                ],
              )),
        ));
  }

  Widget _buildInfo2(SettingData cubit,context) {
    return Container(
        padding: const EdgeInsets.all(10),
        child: Card(
          child: Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:  <Widget>[
                   Text(AppLocalizations.of(context)!.about_app,
                      style:
                          const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15.0,),
                  ListTile(
                    leading: const Icon(
                      Icons.text_snippet,
                    ),
                    title:  Text(
                      AppLocalizations.of(context)!.setting_about,

                    ),
                    subtitle: Text(cubit.about!),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.security),
                    title:  Text(AppLocalizations.of(context)!.about_terms),
                    subtitle: Text(cubit.terms!),

                  ),
                ],
              )),
        ));
  }

  Widget _buildInfo3(context) {
    return Container(
        padding: const EdgeInsets.all(10),
        child: Card(
          child: Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:  <Widget>[
                   Text(AppLocalizations.of(context)!.about_author,
                      style:
                          const TextStyle(fontSize: 20, fontWeight: FontWeight.w400)),
                   ListTile(onTap:() => ShopCubit.get(context).launchUniversalLinkIos('https://www.linkedin.com/in/osama-habib-00/'),
                    leading: const Icon(Icons.person),
                    title:  Text(AppLocalizations.of(context)!.about_author_name),
                    subtitle:  Text(AppLocalizations.of(context)!.about_author_name_title),
                  ),
                  const Divider(),
                  ListTile(onTap:() => ShopCubit.get(context).launchUniversalLinkIos('https://github.com/Osama0habib?tab=repositories'),
                    leading: const Icon(Icons.developer_board),
                    title: Text(AppLocalizations.of(context)!.about_other_apps_on_github),
                  ),
                  const Divider(),
                  ListTile(onTap:() => ShopCubit.get(context).launchUniversalLinkIos('https://maps.app.goo.gl/9SfvudVegNHo6cqk9'),
                    leading: const Icon(Icons.location_on),
                    title:  Text(AppLocalizations.of(context)!.about_author_region),
                  ),
                ],
              )),
        ));
  }

  Widget _buildInfo4(context) {
    return Container(
        padding: const EdgeInsets.all(10),
        child: Card(
          child: Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:  <Widget>[
                   Text(AppLocalizations.of(context)!.about_contact,
                      style:
                      const TextStyle(fontSize: 20, fontWeight: FontWeight.w400)),
                  ListTile(onTap:() => ShopCubit.get(context).makePhoneCall('+201271500460'),
                    leading: const Icon(Icons.smartphone),
                    title:  Text(AppLocalizations.of(context)!.about_mobile_number),
                    subtitle:  Text(AppLocalizations.of(context)!.about_call_me),
                  ),
                  const Divider(),
                  ListTile(onTap:() => ShopCubit.get(context).launchUniversalLinkIos('https://wa.me/+201271500460'),
                    leading:  const FaIcon(FontAwesomeIcons.whatsapp),
                    title:  Text(AppLocalizations.of(context)!.about_whatsapp),
                  ),
                ],
              )),
        ));
  }
}
