import 'package:baya3/layout/cubit/cubit.dart';
import 'package:baya3/layout/home_layout.dart';
import 'package:baya3/modules/login/login_screen.dart';
import 'package:baya3/modules/onboarding/onboarding_screen.dart';
import 'package:baya3/shared/bloc_observer.dart';
import 'package:baya3/shared/network/local/cache_helper.dart';
import 'package:baya3/shared/network/local/const_shared.dart';
import 'package:baya3/shared/network/remote/dio_helper.dart';
import 'package:baya3/shared/styles/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await CacheHelper.init();
  DioHelper.init();

  Widget widget;
  bool onBoarding = CacheHelper.getData(key: 'onBoarding');
  // token = CacheHelper.getData(key: 'token');
  token = 'n57ENeIkVTnBakIk8njqoUA0x5KDPaaKfyudm8pWmm5Hpxf6tKwGyg4HQXZ3f0GXJKuuEi';
  print('from main the token is ${token}');

  if (onBoarding != null) {
    if (token != null) {
      widget = const HomeLayout();
    } else {
      widget = LoginScreen();
    }
  } else {
    widget = OnBoardingScreen();
  }

  BlocOverrides.runZoned(
    () {
      runApp(MyApp(
        startWidget: widget,
      ));
    },
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  final Widget startWidget;

  const MyApp({
    this.startWidget,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => ShopCubit()
            ..getHomeData()
            ..getCategoryData()
            ..getFavoritesData()
            ..getUserData(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.light,
        home: startWidget,
      ),
    );
  }
}
