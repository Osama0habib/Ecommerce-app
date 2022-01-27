import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart' as location;
import 'package:shop_app_mansour/layout/shop/cubit/shop_states.dart';
import 'package:shop_app_mansour/models/cart_model.dart';
import 'package:shop_app_mansour/models/categories_model.dart';
import 'package:shop_app_mansour/models/faqs_model.dart';
import 'package:shop_app_mansour/models/login_model.dart';
import 'package:shop_app_mansour/models/order_details_model.dart';
import 'package:shop_app_mansour/models/orders_model.dart';
import 'package:shop_app_mansour/models/setting_model.dart';
import 'package:shop_app_mansour/models/toggle_favorite_model.dart';
import 'package:shop_app_mansour/modules/categories/categories_screen.dart';
import 'package:shop_app_mansour/modules/favorite/favorite_screen.dart';
import 'package:shop_app_mansour/modules/orders/order_detail_screen.dart';
import 'package:shop_app_mansour/modules/orders/order_screen.dart';
import 'package:shop_app_mansour/modules/settings/settings_screen.dart';
import 'package:shop_app_mansour/shared/components/components.dart';
import 'package:shop_app_mansour/shared/network/remote/dio_helper.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../models/address_model.dart';
import '../../../models/category_product_model.dart';
import '../../../models/favorite_model.dart';
import '../../../models/home_model.dart';
import '../../../modules/products/products_screen.dart';
import '../../../shared/components/constants.dart';
import '../../../shared/network/end_points.dart';
import 'shop_states.dart';

class ShopCubit extends Cubit<ShopStates> {
  ShopCubit() : super(ShopInitialState());

  static ShopCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> bottomScreens = [
    const ProductsScreen(),
    const CategoriesScreen(),
    const FavoriteScreen(),
    const SettingsScreen()
  ];

  void changeBottomNav(int index) {
    currentIndex = index;
    emit(ChangeBottomNav());
  }

  HomeModel? homeModel;
  Map<int, bool> favorite = {};
  Map<int, bool> inCart = {};
  Map<int, int> quantityMap = {};
  Map<int, bool> expand = {};

  void getHomeData() {
    emit(LoadingHomeDataState());
    DioHelper.getData(
      url: home,
      token: token,
    ).then((value) {
      homeModel = HomeModel.fromJson(value.data);
      // printFullText(homeModel!.data!.banners.toString());
      for (var element in homeModel!.data!.products) {
        favorite.addAll({element.id!: element.inFavorites!});
        inCart.addAll({element.id!: element.inCart!});

        // print(favorite.toString());
      }
      emit(SuccessHomeDataState());
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorHomeDataState());
    });
  }

  double percentage({oldPrice, price}) {
    return (oldPrice - price) / oldPrice * 100;
  }

  CategoriesModel? categoriesModel;

  void getCategories() {
    DioHelper.getData(
      url: categories,
    ).then((value) {
      categoriesModel = CategoriesModel.fromJson(value.data);
      // printFullText(categoriesModel!.data!.data!.length.toString());

      emit(SuccessCategoriesState());
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorCategoriesState());
    });
  }

  ToggleFavoriteModel? toggleFavoriteModel;

  void toggleFavorite(productId) {
    favorite[productId] = !favorite[productId]!;

    emit(FavoriteToggleState());

    DioHelper.postData(
            url: favorites, data: {'product_id': productId}, token: token)
        .then((value) {
      toggleFavoriteModel = ToggleFavoriteModel.fromJson(value.data);
      if (!toggleFavoriteModel!.status!) {
        favorite[productId] = !favorite[productId]!;
        toast(message: toggleFavoriteModel!.message, state: ToastStates.error);
        emit(FavoriteToggleErrorState());
      } else {
        getFavorites();
      }

      emit(FavoriteToggleSuccessState());
    }).catchError((error) {
      favorite[productId] = !favorite[productId]!;
      getFavorites();
      toast(message: toggleFavoriteModel!.message, state: ToastStates.error);
      emit(FavoriteToggleErrorState());
    });
  }

  FavoriteModel? favoriteModel;

  void getFavorites() {
    emit(LoadingFavoriteState());
    DioHelper.getData(
      url: favorites,
      token: token,
    ).then((value) {
      favoriteModel = FavoriteModel.fromJson(value.data);

      // printFullText(favoriteModel!.data!.favoriteData!.length.toString());

      emit(SuccessFavoriteState());
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorFavoriteState());
    });
  }

  LoginModel? userModel;

  void getUserData() {
    DioHelper.getData(
      url: profile,
      token: token,
    ).then((value) {
      userModel = LoginModel.fromJson(value.data);
      if (kDebugMode) {
        print("user name : ${userModel!.data!.name}");
      }
      // printFullText(favoriteModel!.data!.favoriteData!.length.toString());

      emit(SuccessGetUserDataState());
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorGetUserDataState());
    });
  }

  UserData? userData;

  Future<void> updateUserProfile(
      {required String username,
      required String phone,
      required String email,
      String? image}) async {
    emit(LoadingUpdateUserDataState());
    DioHelper.updateUserData(url: updateProfile, token: token, data: {
      "name": username,
      "phone": phone,
      "email": email,
      "image": image,
    }).then((value) {
      userData = UserData.fromJson(value.data);

      emit(SuccessUpdateUserDataState());
      getUserData();
    }).catchError((error) {
      if (kDebugMode) {
        print(error);
      }
      emit(ErrorUpdateUserDataState());
    });
  }

  FAQsModel? faQsModel;

  void getFAQs() {
    DioHelper.getData(
      url: faqs,
      token: token,
    ).then((value) {
      faQsModel = FAQsModel.fromJson(value.data);

      // printFullText(favoriteModel!.data!.favoriteData!.length.toString());

      emit(SuccessGetFAQsState());
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorGetFAQsState());
    });
  }

  SettingModel? settingModel;

  void getSettings() {
    DioHelper.getData(
      url: termsAndAboutApp1,
      token: token,
    ).then((value) {
      settingModel = SettingModel.fromJson(value.data);

      // printFullText(favoriteModel!.data!.favoriteData!.length.toString());

      emit(SuccessGetFAQsState());
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorGetFAQsState());
    });
  }

  void toggleVisibility(id) {
    DataFAQs? dataFAQS =
        faQsModel!.data!.data?.singleWhere((element) => element.id == id);
    dataFAQS!.answerVisibility = !dataFAQS.answerVisibility!;

    emit(ToggleVisableFAQsAnswer());
  }

  Future<void> launchUniversalLinkIos(String url) async {
    final bool nativeAppLaunchSucceeded = await launch(
      url,
      forceSafariVC: false,
      forceWebView: false,
      universalLinksOnly: true,
    );
    if (!nativeAppLaunchSucceeded) {
      await launch(
        url,
        forceSafariVC: true,
        forceWebView: true,
      )
          .then((value) => emit(SuccessLaunchLinkState()))
          .catchError((error) => emit(ErrorLaunchLinkState()));
    }
    emit(SuccessLaunchLinkState());
  }

  Future<void> makePhoneCall(String phoneNumber) async {
    // Use `Uri` to ensure that `phoneNumber` is properly URL-encoded.
    // Just using 'tel:$phoneNumber' would create invalid URLs in some cases,
    // such as spaces in the input, which would cause `launch` to fail on some
    // platforms.
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launch(launchUri.toString())
        .then((value) => emit(SuccessLaunchLinkState()))
        .catchError((error) => emit(ErrorLaunchLinkState()));
  }

  ImagePicker picker = ImagePicker();
  XFile? pickedImage;

  void getImage(ImageSource imageSource) async {
     await picker.pickImage(source: imageSource).then((value) {
      //if user doesn't take any image, just return.
      if (value == null) return;

//Rebuild UI with the selected image.
      pickedImage = value;
      emit(SuccessImagePickerState());
    }).catchError((error) {
      emit(ErrorImagePickerState());
    });
  }

  void onClickMenu(item) {
    if (item.menuTitle == "Camera") {
      getImage(ImageSource.camera);
    } else {
      getImage(ImageSource.gallery);
    }
  }

  // Map<String, dynamic> mapImageUrl = {};
  GoogleMapController? googleMapController;
  location.Location currentLocation = location.Location();
  Set<Marker> markers = {};

  void getCurrentLocation() async {
    emit(MapLocationInitialState());

    await currentLocation.getLocation().then((value) {
      markers.add(Marker(
        markerId: const MarkerId('home'),
        position: LatLng(value.latitude ?? 0.0, value.longitude ?? 0.0),
      ));
      googleMapController
          ?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(value.latitude ?? 0.0, value.longitude ?? 0.0),
        zoom: 15,
      )));
      changeLatlngToAddress(
          latitude: value.latitude, longitude: value.longitude);
      emit(MapLocationCurrentState());
    });
  }

  void markerChangeLocation(LatLng center) {
    markers.clear();
    emit(MapLocationInitialState());
    markers.add(Marker(
      markerId: const MarkerId('home 2'),
      position: center,
    ));
    googleMapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: center,
          zoom: 15,
        ),
      ),
    );
    if (kDebugMode) {
      print(center);
    }
    changeLatlngToAddress(
        latitude: center.latitude, longitude: center.longitude);
    emit(MapLocationChangeState());
    googleMapController?.dispose();
  }

  AddressModel? addressModel;
  bool isInit = true;

  void getAddresses() {
    if (isInit) {
      DioHelper.getData(url: addresses, token: token).then((value) {
        addressModel = AddressModel.fromJson(value.data);
        // print(value.data);
        // print(addressModel?.data?.data?[0].name);
        isInit = false;
        emit(SuccessAddressesState());
      }).catchError((error) {
        if (kDebugMode) {
          print(error.toString());
        }
        emit(ErrorAddressesState());
      });
    }
  }

  void addAddress(
      {name,
      String? city,
      String? district,
      String? street,
      latitude,
      longitude,
      String? image}) {
    DioHelper.postData(token: token, url: addresses, data: {
      'name': name,
      'city': city,
      'region': district,
      'details': street,
      'latitude': latitude,
      'longitude': longitude,
      'notes': image,
    }).then((value) {
      isInit = true;
      getAddresses();
      printFullText(image.toString());
      emit(SuccessAddAddressesState());
    }).catchError((error) {
      if (kDebugMode) {
        print("error : $error");
      }
      emit(ErrorAddAddressesState());
    });
  }

  void updateAddress(
      {required String id,
      String? name,
      String? city,
      String? district,
      String? street,
      latitude,
      longitude,
      String? image}) {
    DioHelper.updateData(token: token, url: 'addresses/$id', data: {
      'name': name,
      'city': city,
      'region': district,
      'details': street,
      'latitude': latitude,
      'longitude': longitude,
      'notes': image,
    }).then((value) {
      //  printFullText(image.toString());
      if (kDebugMode) {
        print(value.data['message']);
      }
      if (kDebugMode) {
        print(token);
      }
      if (kDebugMode) {
        print(id);
      }
      if (kDebugMode) {
        print(name);
      }
      isInit = true;
      getAddresses();
      emit(SuccessUpdateAddressesState());
    }).catchError((error) {
      if (kDebugMode) {
        print("error : $error");
      }
      emit(ErrorUpdateAddressesState());
    });
  }

  void deleteAddress({required String id, context}) {
    DioHelper.deleteData(token: token, url: 'addresses/$id', data: {})
        .then((value) {
      // printFullText(image.toString());
      getAddresses();
      emit(SuccessUpdateAddressesState());
    }).catchError((error) {
      if (kDebugMode) {
        print("error : $error");
      }
      emit(ErrorUpdateAddressesState());
    });
  }

  CartModel? cartModel;

  bool isCartInit = true;

  void getCart() {
    if (isCartInit) {
      DioHelper.getData(url: cart, token: token).then((value) {
        cartModel = CartModel.fromJson(value.data);
        for (var element in cartModel!.data!.cartItems!) {
          quantityMap.addAll({element.id! :element.quantity!});
        }
        if (kDebugMode) {
          print(cartModel?.message);
        }
        emit(SuccessGetCartState());
      }).catchError((error) {
        if (kDebugMode) {
          print(error.toString());
        }
        emit(ErrorGetCartState());
      });
    }
    isCartInit = false;
  }

  void addToCart({required int id}) {
    inCart[id] = !inCart[id]!;
    DioHelper.postCartData(token: token, url: cart, data: {"product_id": id})
        .then((value) {
      // printFullText(image.toString());
      getCart();
      emit(SuccessAddToCartState());
    }).catchError((error) {
      inCart[id] = !inCart[id]!;
      if (kDebugMode) {
        print("error : $error");
      }
      emit(ErrorAddToCartState());
    });
  }

  void updateCarts(
      {required   id,required   quantity}) {
    quantityMap[id] = quantity;


    DioHelper.updateUserData(url: "$cart/$id",token: token, data: {
      "quantity": quantity
    }).then((value) {
      // printFullText(image.toString());
      if (kDebugMode) {
        print(value.data['message']);
      }
      isCartInit = true;
      getCart();
      emit(SuccessUpdateCartState());
    }).catchError((error) {
      quantityMap[id] = quantity -1 ;

      if (kDebugMode) {
        print("error : $error");
      }
      emit(ErrorUpdateCartState());
    });
  }

  void deleteCarts({id}) {
    DioHelper.deleteData(url: "$cart/$id", data: {}).then((value) {
      // printFullText(image.toString());
      emit(SuccessUpdateAddressesState());
    }).catchError((error) {
      if (kDebugMode) {
        print("error : $error");
      }
      emit(ErrorUpdateAddressesState());
    });
  }

  List<Placemark>? placeMarks;

  changeLatlngToAddress({latitude, longitude}) async {
    placeMarks =
        await placemarkFromCoordinates(latitude, longitude).then((value) {
      printFullText("Address : $value");
      addressFromMap(
          address: value[0], latitude: latitude, longitude: longitude);
      emit(SuccessConvertLatLngToAddressState());
    }).catchError((error) {
      emit(ErrorConvertLatLngToAddressState());
    });
  }

  List<Location>? locations;

  changeAddressToLatlng({address}) async {
    locations = await locationFromAddress(address).then((value) {
      if (kDebugMode) {
        print(value);
      }
      changeMapImage(value[0]);
      emit(SuccessConvertLatLngToAddressState());
    }).catchError((error) {
      emit(ErrorConvertLatLngToAddressState());
    });
  }

  String? mapImageUrlEdit;

  void changeMapImage(value) {
    if (value != null) {
      mapImageUrlEdit =
          "https://maps.googleapis.com/maps/api/staticmap?center=${value.latitude},${value.longitude}&markers=color:red%7Clabel:A%7C${value.latitude},${value.longitude}&zoom=16&size=400x400&key=$googleApiKey";
      if (kDebugMode) {
        print(mapImageUrlEdit?.split('=').last.split("&markers").first);
      }
      emit(SuccessUserAddressDataState());
    }
  }

  TextEditingController tagController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  TextEditingController districtController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  bool isInitEditAddress = true;

  void adduserAddressData(address) {
    if (isInitEditAddress) {
      if (address != null) {
        tagController.text = address.name!;
        streetController.text = address.details!;
        districtController.text = address.region!;
        cityController.text = address.city!;
        mapImageUrlEdit = address.image!;

        if (kDebugMode) {
          print(tagController.text);
        }
        if (kDebugMode) {
          print(streetController.text);
        }
        if (kDebugMode) {
          print(districtController.text);
        }
        if (kDebugMode) {
          print(cityController.text);
        }
        isInitEditAddress = false;
      }
    }
  }

  void clearAddressController() {
    tagController.clear();
    streetController.clear();
    districtController.clear();
    cityController.clear();
    mapImageUrlEdit = null;
  }

  addressFromMap({required Placemark? address, latitude, longitude}) {
    if (address != null) {
      streetController.text = address.street!;
      districtController.text = address.locality!;
      cityController.text =
          "${address.administrativeArea!},${address.isoCountryCode}";
      mapImageUrlEdit =
          "https://maps.googleapis.com/maps/api/staticmap?center=$latitude,$longitude&markers=color:red%7Clabel:A%7C$latitude,$longitude&zoom=16&size=400x400&key=$googleApiKey";
    } else {
      const AlertDialog(
        title: Text('Don you want to override your address'),
      );
    }
  }

  void clearUserData() {
    currentIndex = 0;
    mapImageUrlEdit = null;
    isInitEditAddress = true;
    locations = null;
    addressModel = null;
    isInit = true;
    placeMarks = null;
    googleMapController;
    currentLocation = location.Location();
    markers = {};
    picker = ImagePicker();
    pickedImage = null;
    faQsModel = null;
    homeModel = null;
    favorite = {};
    categoriesModel = null;
    toggleFavoriteModel = null;
    favoriteModel = null;
    userModel = null;
    userData = null;
    cartModel = null;
    settingModel = null;
    addressModel = null;
    categoryProductsModel = null;
  }

  CategoryProductsModel? categoryProductsModel;

  void getCategoriesProduct({required id}) {
    emit(LoadingCategoryProductState());
    DioHelper.getData(
      url: '$categories/$id',
    ).then((value) {
      if (kDebugMode) {
        print(value.data['data']);
      }
      categoryProductsModel = CategoryProductsModel.fromJson(value.data);
      // printFullText(categoriesModel!.data!.data!.length.toString());

      emit(SuccessCategoryProductState());
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorCategoryProductState());
    });
  }

OrdersModel? ordersModel ;
  void getOrders() {

    emit(GetOrdersLoadingState());
      DioHelper.getData(url: orders, token: token).then((value) {
        ordersModel = OrdersModel.fromJson(value.data);
        for (var element in ordersModel!.data!.data!) {expand.addAll(
            {element.id!: false});}
        if (kDebugMode) {
          print("Orders : ${value.data}");
        }
        emit(SuccessGetOrdersState());
      }).catchError((error) {
        if (kDebugMode) {
          print(error.toString());
        }
        emit(ErrorGetOrdersState());
      });

  }

  int groupValue = -1 ;


  void changeToggleValue(value) {
    groupValue = value ;
    if (kDebugMode) {
      print(groupValue);
    }
    emit(SuccessChangeValueState());
  }

  List<bool> isPaymentSelected = [true, false];
  int? paymentMethod  = 1 ;


  paymentMethodToggle(index) {
    for (int i = 0; i < isPaymentSelected.length; i++) {
     isPaymentSelected[i] = i == index;
     paymentMethod = index + 1 ;
     // print(paymentMethod);
    }
    emit(SuccessPaymentMethodChangeState());
  }

  bool usePoints = false ;

  usePointSwitch({value}) {
    if (kDebugMode) {
      print(value);
    }
     usePoints = value;
    emit(SuccessUsePointsState());
  }

   addOrder({address , paymentMethod ,usePoints,context}) {
    // inCart[id] = !inCart[id]!;
    DioHelper.postData(token: token, url: orders, data: {
      "address_id" : address,
      "payment_method" : paymentMethod,
      "use_points" : usePoints
    })
        .then((value) {
      printFullText(value.data["message"]);
      getOrders();
      navigateTo(
          context, OrderDetailScreen(id: value.data["data"]["id"]));
      // getOrderDetails(id: value.data["data"]["id"]);
      getCart();
      emit(SuccessAddOrderState());
    }).catchError((error) {
      // inCart[id] = !inCart[id]!;
      if (kDebugMode) {
        print("error : $error");
      }
      emit(ErrorAddOrderState());
    });
  }

  clearOrderVariables() {
    usePoints = false ;
    paymentMethod  = 1;
    groupValue = -1 ;
  }

  OrdersDetailsModel? ordersDetailsModel;
  getOrderDetails({id}){

    emit(LoadingOrdersDetailState());
    DioHelper.getData(url: "$orders/$id", token: token).then((value) {
      ordersDetailsModel = OrdersDetailsModel.fromJson(value.data);

      if (kDebugMode) {
        print("Orders : ${value.data}");
      }
       // navigateTo(context,  OrderDetailScreen(data : ordersDetailsModel?.data));


      emit(SuccessGetOrdersDetailState());
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorGetOrdersDetailState());
    });

  }

  cancelOrder({id,context}){
    DioHelper.getData(url: "$orders/$id/cancel", token: token).then((value) {
      // ordersDetailsModel = OrdersDetailsModel.fromJson(value.data);

      if (kDebugMode) {
        print("cancel : ${value.data['message']}");
      }
      // navigateTo(context,  OrderDetailScreen(data : ordersDetailsModel?.data));
      getOrders();
      navigateAndFinish(context,const OrderScreen());
      emit(SuccessCancelOrderState());
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(ErrorCancelOrderState());
    });

  }

  orderExpand(id){
    expand[id] = !expand[id]!;
      emit(OrderExpandState());
  }
}
