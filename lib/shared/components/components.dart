import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shop_app_mansour/models/boarding_model.dart';
import 'package:shop_app_mansour/shared/styles/colors.dart';

Widget buildBoardingItem(BoardingModel boardingModel) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Image(
            image: AssetImage(
              boardingModel.image,
            ),
          ),
        ),
        // const SizedBox(height: 30.0,),
        Text(
          boardingModel.title,
          style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 20.0,
        ),
        Text(
          boardingModel.body,
          style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
        ),
// PageView.builder(itemBuilder: (ctx,index) => )
      ],
    );

Widget defaultTextFormField({
  prefixIcon,
  label,
  suffixIcon,
  controller,
  bool obscure = false,
  String? Function(String?)? validator,
  type,
  onSubmit,
  onEditingComplete,
}) =>
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(

        decoration: InputDecoration(
          prefixIcon: prefixIcon,
          label: Text(label),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          suffixIcon: suffixIcon,
        ),
        controller: controller,
        onFieldSubmitted: onSubmit,
        obscureText: obscure,
        validator: validator,
        onEditingComplete: onEditingComplete,
        keyboardType: type,
      ),
    );

Widget defaultButton({text, width = double.infinity, color = defaultColor,required onPressed}) =>
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: width,
        child: MaterialButton(
          onPressed: onPressed,
          child: Text(
            text,style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.white),
          ),
          elevation: 10.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          color: color,
          height: 50,

        ),
      ),
    );

Future<bool?> toast({required message ,required state}) => Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.CENTER,
    timeInSecForIosWeb: 5,
    backgroundColor: chooseToastColor(state),
    textColor: Colors.white,
    fontSize: 16.0
);

enum ToastStates {success, error , warning}

Color chooseToastColor(ToastStates state)
{
  Color color;

  switch(state)
  {
    case ToastStates.success :
      color = Colors.green;
      break;
    case ToastStates.error :
      color = Colors.red;
      break;
    case ToastStates.warning :
      color = Colors.amber;
      break;
  }
  return color;
}

Widget defaultTextButton({required text,required VoidCallback onPressed}) => TextButton(onPressed: onPressed, child: Text(text.toUpperCase(),),);

void navigateTo(context, widget) =>
    Navigator.push(context, MaterialPageRoute(builder: (ctx) => widget));

void navigateAndFinish(context, widget) => Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (ctx) => widget),
    (Route<dynamic> route) => false);
