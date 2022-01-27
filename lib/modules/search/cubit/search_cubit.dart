import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app_mansour/models/search_model.dart';
import 'package:shop_app_mansour/modules/search/cubit/search_states.dart';
import 'package:shop_app_mansour/shared/network/end_points.dart';
import 'package:shop_app_mansour/shared/network/remote/dio_helper.dart';

import '../../../shared/components/constants.dart';

class SearchCubit extends Cubit<SearchStates> {
  SearchCubit() : super(SearchInitialState());

  static SearchCubit get(context) =>  BlocProvider.of(context);

  SearchModel? searchModel ;

  void searchProduct(String text)
  {
    emit(SearchLoadingState());
    DioHelper.postData(url: search, data: {'text' : text},token: token).then((value) {
      searchModel = SearchModel.fromJson(value.data);
      emit(SearchSuccessState());
    }).catchError((error) {

      emit(SearchErrorState());
    });
  }
}