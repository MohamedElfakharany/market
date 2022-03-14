import 'package:baya3/models/auth/login_model.dart';
import 'package:baya3/models/change_favorite_model.dart';
import 'package:baya3/models/search_model.dart';

abstract class ShopStates{}

class ShopInitialState extends ShopStates{}

class ShopLoginLoadingState extends ShopStates{}

class ShopLoginSuccessState extends ShopStates{
  final LoginModel loginModel;
  ShopLoginSuccessState(this.loginModel);
}

class ShopRegisterLoadingState extends ShopStates{}

class ShopRegisterErrorState extends ShopStates{
  final String error;
  ShopRegisterErrorState(this.error);
}

class ShopRegisterSuccessState extends ShopStates{
  final LoginModel loginModel;
  ShopRegisterSuccessState(this.loginModel);
}

class ShopLoginErrorState extends ShopStates{
  final String error;
  ShopLoginErrorState(this.error);
}

class ShopChangePasswordVisibilityState extends ShopStates{}

class ShopChangeBottomNavState extends ShopStates{}

class ShopLoadingState extends ShopStates{}

class ShopHomeSuccessState extends ShopStates{}

class ShopLogoutSuccessState extends ShopStates{}

class ShopHomeErrorState extends ShopStates{
  final error;
  ShopHomeErrorState(this.error);
}

class ShopCategoriesSuccessState extends ShopStates{}

class ShopCategoriesErrorState extends ShopStates{
  final error;
  ShopCategoriesErrorState(this.error);
}

class ShopLoadingGetFavoritesState extends ShopStates{}

class ShopGetFavoritesSuccessState extends ShopStates{}

class ShopGetFavoritesErrorState extends ShopStates{
  final error;
  ShopGetFavoritesErrorState(this.error);
}

class ShopChangeFavoritesState extends ShopStates{}

class ShopChangeFavoritesSuccessState extends ShopStates{
  final ChangeFavoritesModel model;
  ShopChangeFavoritesSuccessState(this.model);
}

class ShopChangeFavoritesErrorState extends ShopStates{
  final error;
  ShopChangeFavoritesErrorState(this.error);
}

class ShopLoadingGetUserDataState extends ShopStates{}

class ShopGetUserDataSuccessState extends ShopStates{
  final LoginModel model;

  ShopGetUserDataSuccessState(this.model);
}

class ShopGetUserDataErrorState extends ShopStates{
  final error;
  ShopGetUserDataErrorState(this.error);
}

class ShopLoadingUpdateUserDataState extends ShopStates{}

class ShopUpdateUserDataSuccessState extends ShopStates{
  final LoginModel model;

  ShopUpdateUserDataSuccessState(this.model);
}

class ShopUpdateUserDataErrorState extends ShopStates{
  final error;
  ShopUpdateUserDataErrorState(this.error);
}

class ShopChangeCarouselState extends ShopStates{}

class ShopLoadingSearchState extends ShopStates{}

class ShopSearchSuccessState extends ShopStates{
  final SearchModel model;
  ShopSearchSuccessState(this.model);
}

class ShopSearchErrorState extends ShopStates{
  final error;
  ShopSearchErrorState(this.error);
}
