import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:shop_app_mansour/layout/shop/cubit/shop_cubit.dart';
import 'package:shop_app_mansour/layout/shop/shop_layout.dart';
import 'package:shop_app_mansour/modules/login/cubit/cubit.dart';
import 'package:shop_app_mansour/modules/login/cubit/states.dart';
import 'package:shop_app_mansour/shared/components/components.dart';
import 'package:shop_app_mansour/shared/network/local/cache_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../shared/components/constants.dart';
import '../register/register_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {
          if (state is LoginSuccessState) {
            if (state.loginModel.status!) {
              if (kDebugMode) {
                print(state.loginModel.message);
                print(state.loginModel.data?.token);

              }
              CacheHelper.saveData(
                      key: 'token', value: state.loginModel.data?.token)
                  .then((value) {
                token = CacheHelper.getData(key: 'token');
                navigateAndFinish(context, const ShopLayout());
                ShopCubit.get(context)
                  ..getUserData()
                  ..getFavorites()
                  ..getCategories()
                  ..getHomeData()
                  ..getAddresses()
                  ..getFAQs()
                  ..getSettings()
                  ..getCart()
                  ..getOrders();
              });
            } else {
              if (kDebugMode) {
                print(state.loginModel.message);
              }
              toast(
                  message: state.loginModel.message!, state: ToastStates.error);
            }
          }
        },
        builder: (context, state) {
          return Scaffold(
              appBar: AppBar(),
              body: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              AppLocalizations.of(context)!.login,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              AppLocalizations.of(context)!.cheering_login,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  ?.copyWith(color: Colors.grey),
                            ),
                          ),
                          const SizedBox(
                            height: 30.0,
                          ),
                          defaultTextFormField(
                              controller: emailController,
                              type: TextInputType.emailAddress,
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return AppLocalizations.of(context)!
                                      .text_field_validator_email;
                                }
                              },
                              label: AppLocalizations.of(context)!
                                  .text_field_label_email,
                              prefixIcon: const Icon(Icons.email_outlined)),
                          defaultTextFormField(
                            controller: passwordController,
                            type: TextInputType.visiblePassword,
                            validator: (String? value) {
                              if (value!.isEmpty) {
                                return AppLocalizations.of(context)!
                                    .text_field_validator_password;
                              }
                            },
                            label: AppLocalizations.of(context)!
                                .text_field_label_password,
                            obscure: LoginCubit.get(context).obscure,
                            onSubmit: (value) {
                              if (formKey.currentState!.validate()) {
                                LoginCubit.get(context).userLogin(
                                    email: emailController.text,
                                    password: passwordController.text);
                              }
                            },
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              onPressed: () {
                                LoginCubit.get(context).changeObscure();
                              },
                              icon: Icon(LoginCubit.get(context).suffix),
                            ),
                          ),
                          Conditional.single(
                              conditionBuilder: (BuildContext context) {
                                return state is! LoginLoadingState;
                              },
                              widgetBuilder: (BuildContext context) {
                                return defaultButton(
                                    text: AppLocalizations.of(context)!.login,
                                    onPressed: () {
                                      if (formKey.currentState!.validate()) {
                                        LoginCubit.get(context).userLogin(
                                            email: emailController.text,
                                            password: passwordController.text);
                                      }
                                    });
                              },
                              context: context,
                              fallbackBuilder: (BuildContext context) {
                                return const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                );
                              }),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(AppLocalizations.of(context)!
                                    .register_toggle_line),
                                defaultTextButton(
                                    text:
                                        AppLocalizations.of(context)!.register,
                                    onPressed: () =>
                                        navigateTo(context, RegisterScreen()))
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ));
        },
      ),
    );
  }
}
