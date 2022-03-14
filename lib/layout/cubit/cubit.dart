import 'dart:convert';
import 'package:baya3/layout/cubit/states.dart';
import 'package:baya3/models/auth/login_model.dart';
import 'package:baya3/models/category_model.dart';
import 'package:baya3/models/change_favorite_model.dart';
import 'package:baya3/models/favorites_model.dart';
import 'package:baya3/models/home_model.dart';
import 'package:baya3/models/search_model.dart';
import 'package:baya3/modules/cart/cart_screen.dart';
import 'package:baya3/modules/categories/category_screen.dart';
import 'package:baya3/modules/favorites/favorites_screen.dart';
import 'package:baya3/modules/onboarding/onboarding_screen.dart';
import 'package:baya3/modules/products/home_screen.dart';
import 'package:baya3/shared/components/components.dart';
import 'package:baya3/shared/network/end_points.dart';
import 'package:baya3/shared/network/local/cache_helper.dart';
import 'package:baya3/shared/network/local/const_shared.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShopCubit extends Cubit<ShopStates> {
  ShopCubit() : super(ShopInitialState());

  static String homeURL = '$HOME_URL';
  static String categoryURL = '$CATEGORIES_URL';
  static String favoritesURL = '$FAVORITES_URL';
  static String profileURL = '$PROFILE_URL';
  static String updateProfileURL = '$UPDATE_PROFILE_URL';
  static String registerURL = '$REGISTER_URL';
  static String searchURL = '$PRODUCTS_SEARCH_URL';

  static ShopCubit get(context) => BlocProvider.of(context);

  SearchModel searchModel;
  LoginModel userModel;
  HomeModel homeModel;
  CategoriesModel categoryModel;
  FavoritesModel favoritesModel;
  ChangeFavoritesModel changeFavoritesModel;

  Future login({
    @required String email,
    @required String password,
    String lang = 'en',
    String token,
  }) async {
    var headers = {
      'Content-Type': 'application/json',
      'lang': lang,
    };
    var formData = FormData.fromMap({
      'email': email,
      'password': password,
    });
    try {
      emit(ShopLoginLoadingState());
      Dio dio = Dio();
      var response = await dio.post(
        LOGIN_URL,
        data: formData,
        options: Options(
          followRedirects: false,
          responseType: ResponseType.bytes,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      var responseJsonn = response.data;
      var convertedResponse = utf8.decode(responseJsonn);
      var responseJson = json.decode(convertedResponse);
      // print(responseJson);
      userModel = LoginModel.fromJSON(responseJson);
      emit(ShopLoginSuccessState(userModel));
    } catch (e) {
      print(e.toString());
      emit(ShopLoginErrorState(e.toString()));
    }
  }

  Future register({
    @required String name,
    @required String phone,
    @required String email,
    @required String password,
    String lang = 'en',
  }) async {
    var headers = {
      'Content-Type': 'application/json',
      'lang': lang,
    };
    var formData = FormData.fromMap({
      'name': name,
      'phone': phone,
      'email': email,
      'password': password,
    });

    try {
      emit(ShopRegisterLoadingState());
      Dio dio = Dio();
      var response = await dio.post(
        registerURL,
        data: formData,
        options: Options(
          followRedirects: false,
          responseType: ResponseType.bytes,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      var responseJsonn = response.data;
      var convertedResponse = utf8.decode(responseJsonn);
      var responseJson = json.decode(convertedResponse);
      userModel = LoginModel.fromJSON(responseJson);
      print(userModel.data.toString());
      emit(ShopRegisterSuccessState(userModel));
    } catch (e) {
      emit(ShopRegisterErrorState(e.toString()));
      print(e.toString());
    }
  }

  IconData suffix = Icons.visibility_off_outlined;
  bool isPassword = true;

  bool onBoarding = false;

  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(ShopChangePasswordVisibilityState());
  }

  int currentCarouselIndex = 0;

  void changeCarouselState(int newIndex) {
    currentCarouselIndex = newIndex;
    emit(ShopChangeCarouselState());
  }

  int currentIndex = 0;

  List<Widget> bottomScreens = [
    HomeScreen(),
    CategoryScreen(),
    FavoritesScreen(),
    CartScreen(),
  ];

  Future<void> changeBottomScreen(int index) async {
    currentIndex = index;
    emit(ShopChangeBottomNavState());
  }

  Map<int, bool> favorites = {};

  Future getSearch({
    @required String text,
  }) async {
    var headers = {
      'Content-Type': 'application/json',
      'lang': 'en',
      'Authorization': token ?? '',
    };
    var formData = json.encode({
      "text": text,
    });
    try
    {
      emit(ShopLoadingSearchState());
      Dio dio = Dio();
      var response = await dio.post(
        searchURL,
        data: formData,
        options: Options(
          headers: headers,
          responseType: ResponseType.bytes,
          followRedirects: false,
          validateStatus: (status)=> true,
        ),
      );
      var responseJsonn = response.data;
      var convertedResponse = utf8.decode(responseJsonn);
      // print('convertedResponse  $convertedResponse');
      searchModel = searchModelFromJson(convertedResponse);
      // print(searchModel.data.data[0].name);
      emit(ShopSearchSuccessState(searchModel));
    }catch(e)
    {
      print(e.toString());
      emit(ShopSearchErrorState((error){
        print(error.toString());
      }));
    }
  }

  Future getHomeData() async {
    var headers = {
      'Content-Type': 'application/json',
      'lang': 'en',
      // 'Authorization': token ?? 'b676yF4HQTAGtP9bYNM2kjAw3VZ6vd63Ar7dr7jQvhISokVKIK5K3Emr4tiPctOBgBlZhV',
    };
    try {
      emit(ShopLoadingState());
      Dio dio = Dio();
      var response = await dio.get(
        homeURL,
        options: Options(
          followRedirects: false,
          responseType: ResponseType.bytes,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );

      var responseJsonn = response.data;
      var convertedResponse = utf8.decode(responseJsonn);
      // print('response after decoding ${responseJson['data']['banners'][0]['image']}');

      homeModel = homeModelFromJson(convertedResponse);
      // print('from new model the homeModel is $homeModel');
      // print('from new model ${homeModel.data.banners[0].image}');

      homeModel.data.products.forEach((element) {
        favorites.addAll({
          element.id: element.inFavorites,
        });
      });
      // print(favorites.toString());

      emit(ShopHomeSuccessState());
    } catch (e) {
      // print('in catch ${e.toString()}');
      emit(ShopHomeErrorState((error) {
        // print('after emit ${error.toString()}');
      }));
    }
  }

  Future getCategoryData() async {
    var headers = {
      'lang': 'en',
    };
    try {
      Dio dio = Dio();
      var response = await dio.get(
        categoryURL,
        options: Options(
          followRedirects: false,
          responseType: ResponseType.bytes,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );

      var responseJson = response.data;
      var convertedResponsetoUTF = utf8.decode(responseJson);
      categoryModel = categoriesModelFromJson(convertedResponsetoUTF);
      emit(ShopCategoriesSuccessState());
    } catch (error) {
      // print(error.toString());
      emit(ShopCategoriesErrorState(error));
    }
  }

  Future changeFavorites(int productId) async {
    favorites[productId] = !favorites[productId];
    emit(ShopChangeFavoritesState());
    var headers = {
      'Content-Type': 'application/json',
      'lang': 'en',
      'Authorization': token ?? '',
    };
    var data = {
      'product_id': productId,
    };
    try {
      Dio dio = Dio();
      var response = await dio.post(
        favoritesURL,
        options: Options(
          followRedirects: false,
          responseType: ResponseType.bytes,
          validateStatus: (status) => true,
          headers: headers,
        ),
        data: data,
      );
      var responseJson = response.data;
      var convertedResponsetoUTF = utf8.decode(responseJson);
      changeFavoritesModel =
          changeFavoritesModelFromJson(convertedResponsetoUTF);
      print(changeFavoritesModel.message);
      if (!changeFavoritesModel.status) {
        showToast(
          msg: changeFavoritesModel.message.toString(),
          state: ToastState.ERROR,
        );
        favorites[productId] = !favorites[productId];
      } else {
        showToast(
          msg: changeFavoritesModel.message.toString(),
          state: ToastState.SUCCESS,
        );
        getFavoritesData();
      }
      emit(ShopChangeFavoritesSuccessState(changeFavoritesModel));
    } catch (error) {
      showToast(
        msg: changeFavoritesModel.message.toString(),
        state: ToastState.ERROR,
      );
      favorites[productId] = !favorites[productId];
      emit(ShopChangeFavoritesErrorState((error) {}));
    }
  }

  Future getFavoritesData() async {
    emit(ShopLoadingGetFavoritesState());
    var headers = {
      'Content-Type': 'application/json',
      'lang': 'en',
      'Authorization': token ?? '',
    };
    try {
      Dio dio = Dio();
      var response = await dio.get(
        favoritesURL,
        options: Options(
          followRedirects: false,
          responseType: ResponseType.bytes,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );

      var responseJson = response.data;
      var convertedResponsetoUTF = utf8.decode(responseJson);
      favoritesModel = favoritesModelFromJson(convertedResponsetoUTF);
      // print('favoritesModel is ${favoritesModel.data.data[0].toString()}');
      emit(ShopGetFavoritesSuccessState());
    } catch (error) {
      // print(error.toString());
      emit(ShopGetFavoritesErrorState(error));
    }
  }

  Future getUserData() async {
    emit(ShopLoadingGetUserDataState());
    var headers = {
      'Content-Type': 'application/json',
      'lang': 'en',
      'Authorization': token ?? '',
    };
    try {
      Dio dio = Dio();
      var response = await dio.get(
        profileURL,
        options: Options(
          followRedirects: false,
          responseType: ResponseType.bytes,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );

      var responseJsonn = response.data;
      var convertedResponse = utf8.decode(responseJsonn);
      var responseJson = json.decode(convertedResponse);
      userModel = LoginModel.fromJSON(responseJson);
      print('From get User Data is ${userModel.data.name}');
      await emit(ShopGetUserDataSuccessState(userModel));
    } catch (error) {
      print(error.toString());
      emit(ShopGetUserDataErrorState(error));
    }
  }

  Future updateUserData({
    @required String name,
    @required String phone,
    @required String email,
    String lang = 'en',
  }) async {
    var headers = {
      'Content-Type': 'application/json',
      'lang': lang,
      'Authorization': token ?? '',
    };
    ///////////////// HINT //////////////////
    /* this form sadly didn't work here
    var formData = FormData.fromMap({
      'email': email,
      'password': password,
      "email": email,
      "image": "",
    });
    */
    var formData = json.encode({
      "name": name,
      "phone": phone,
      "email": email,
      "image": "",
    });
    try {
      print(updateProfileURL);
      emit(ShopLoadingUpdateUserDataState());
      Dio dio = Dio();
      var response = await dio.put(
        updateProfileURL,
        data: formData,
        options: Options(
          followRedirects: false,
          responseType: ResponseType.bytes,
          validateStatus: (status) => true,
          headers: headers,
        ),
      );
      // print('a7la megz $response');
      var responseJsonn = response.data;
      var convertedResponse = utf8.decode(responseJsonn);
      var responseJson = json.decode(convertedResponse);
      userModel = LoginModel.fromJSON(responseJson);
      // print(token);
      // print(userModel.message.toString());
      // print(userModel.status.toString());
      // print(userModel.data.toString());
      // print('From update User Data is ${userModel.data.name}');
      if (!userModel.status){
        showToast(
          msg: userModel.message.toString(),
          state: ToastState.ERROR,
        );
      }else {
        showToast(
          msg: userModel.message.toString(),
          state: ToastState.SUCCESS,
        );
      }
      emit(ShopUpdateUserDataSuccessState(userModel));
    } catch (e) {
      showToast(
        msg: userModel.message.toString(),
        state: ToastState.ERROR,
      );
      emit(ShopUpdateUserDataErrorState((e) {
        print(e.toString());
      }));
    }
  }

  // Future updateUserData({
  //   @required String name,
  //   @required String phone,
  //   @required String email,
  //   String lang = 'en',
  // }) async {
  //   var headers = {
  //     'lang': 'en',
  //     'Content-Type': 'application/json',
  //     'Authorization': token ?? '',
  //   };
  //   var request = http.Request(
  //     'PUT',
  //     Uri.parse(updateProfileURL),
  //   );
  //   request.body = json.encode({
  //     "name": name,
  //     "phone": phone,
  //     "email": email,
  //     "image": "",
  //   });
  //   emit(ShopLoadingUpdateUserDataState());
  //   request.headers.addAll(headers);
  //   http.StreamedResponse response = await request.send();
  //   try {
  //     var responseString = await response.stream.bytesToString();
  //     dynamic responseMap = json.decode(responseString);
  //     print('responseMap $responseMap');
  //     userModel = LoginModel.fromJSON(responseMap);
  //     print(userModel.data.name);
  //     emit(ShopUpdateUserDataSuccessState(userModel));
  //   } catch (e) {
  //     print(
  //       e.toString(),
  //     );
  //     emit(ShopUpdateUserDataErrorState((error) {}));
  //   }
  // }

  void signOut(context) {
    CacheHelper.removeData(key: 'token').then((value) {
      if (value) {
        currentIndex = 0;
        navigateAndFinish(
          context,
          OnBoardingScreen(),
        );
      }
      emit(ShopLogoutSuccessState());
    });
  }
}
