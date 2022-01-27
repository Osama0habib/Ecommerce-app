import 'package:flutter/material.dart';

import '../components/constants.dart';

const defaultColor  =  Colors.blue ;

Color blueToBlack(context) => !isDark?  defaultColor  : Colors.blueGrey ;

// Color blueToBlue(context) => AppCubit.get(context).isDark? defaultColor : defaultColor  ;