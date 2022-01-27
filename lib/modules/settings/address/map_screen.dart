import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shop_app_mansour/layout/shop/cubit/shop_cubit.dart';
import 'package:shop_app_mansour/layout/shop/cubit/shop_states.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';



class MapScreen extends StatelessWidget {
   const MapScreen({Key? key}) : super(key: key);



   @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit,ShopStates>(
      listener: (BuildContext context, state) {  },
      builder: (BuildContext context, Object? state) {



        return Scaffold(
          appBar: AppBar(
            title:  Text(AppLocalizations.of(context)!.map),
          ),
          body: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child:
            GoogleMap(
              zoomControlsEnabled: false,
              myLocationEnabled: false,
              myLocationButtonEnabled: true,
              initialCameraPosition:const CameraPosition(
                target: LatLng(30.6089317, 32.2784662),
                zoom: 15,
              ),

              onMapCreated: (GoogleMapController controller){
                ShopCubit.get(context).googleMapController = controller;
              },
              markers: ShopCubit.get(context).markers,
              onLongPress: (center){ShopCubit.get(context).markerChangeLocation(center); },
            ) ,
          ),
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.location_searching,color: Colors.white,),
            onPressed: (){
              ShopCubit.get(context).getCurrentLocation();
            },
          ),
        );
      },);
  }
}
