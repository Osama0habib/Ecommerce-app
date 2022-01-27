import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:shop_app_mansour/modules/register/cubit/register_cubit.dart';
import 'package:shop_app_mansour/modules/register/cubit/register_states.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../layout/shop/cubit/shop_cubit.dart';
import '../../layout/shop/shop_layout.dart';
import '../../shared/components/components.dart';
import '../../shared/components/constants.dart';
import '../../shared/network/local/cache_helper.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key? key}) : super(key: key);
 final GlobalKey<FormState> formKey = GlobalKey<FormState>();
 final TextEditingController nameController = TextEditingController();
 final TextEditingController emailController = TextEditingController();
 final TextEditingController phoneController = TextEditingController();
 final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterStates>(
        listener: (BuildContext context, state) {
          if (state is RegisterSuccessState) {
            if (state.loginModel.status!) {
              if (kDebugMode) {
                print(state.loginModel.message);
                print(state.loginModel.data?.token);

              }
              CacheHelper.saveData(
                      key: 'token', value: state.loginModel.data?.token)
                  .then((value) {
                token = state.loginModel.data!.token;
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
                navigateAndFinish(context, const ShopLayout());
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
        builder: (BuildContext context, Object? state) {
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
                              AppLocalizations.of(context)!.register,
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
                              AppLocalizations.of(context)!.cheering_register,
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
                              controller: nameController,
                              type: TextInputType.name,
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return AppLocalizations.of(context)!
                                      .text_field_validator_name;
                                }
                              },
                              label: AppLocalizations.of(context)!
                                  .text_field_label_name,
                              prefixIcon: const Icon(Icons.person)),
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
                              prefixIcon: const Icon(Icons.alternate_email)),
                          defaultTextFormField(
                              controller: phoneController,
                              type: TextInputType.phone,
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return AppLocalizations.of(context)!
                                      .text_field_validator_phone;
                                }
                              },
                              label: AppLocalizations.of(context)!
                                  .text_field_label_phone,
                              prefixIcon: const Icon(Icons.phone_android)),
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
                            obscure: RegisterCubit.get(context).obscure,
                            onSubmit: (value) {
                              if (formKey.currentState!.validate()) {
                                RegisterCubit.get(context).userRegister(
                                    email: emailController.text,
                                    password: passwordController.text,
                                    name: nameController.text,
                                    phone: phoneController.text);
                              }
                            },
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              onPressed: () {
                                RegisterCubit.get(context).changeObscure();
                              },
                              icon: Icon(RegisterCubit.get(context).suffix),
                            ),
                          ),
                          Conditional.single(
                              conditionBuilder: (BuildContext context) {
                                return state is! RegisterLoadingState;
                              },
                              widgetBuilder: (BuildContext context) {
                                return defaultButton(
                                    text:
                                        AppLocalizations.of(context)!.register,
                                    onPressed: () {
                                      if (formKey.currentState!.validate()) {
                                        RegisterCubit.get(context).userRegister(
                                            email: emailController.text,
                                            password: passwordController.text,
                                            phone: phoneController.text,
                                            name: nameController.text);
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
                                    .login_toggle_line),
                                defaultTextButton(
                                    text: AppLocalizations.of(context)!.login,
                                    onPressed: () =>
                                        Navigator.of(context).pop())
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
