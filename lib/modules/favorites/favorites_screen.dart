import 'package:baya3/layout/cubit/cubit.dart';
import 'package:baya3/layout/cubit/states.dart';
import 'package:baya3/shared/components/components.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = ShopCubit.get(context);
        return ConditionalBuilder(
          condition: cubit.favorites != null,
          builder: (context) => Container(
            height: MediaQuery.of(context).size.height,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  colorFilter: new ColorFilter.mode(Colors.white.withOpacity(0.05), BlendMode.dstATop),
                  image: AssetImage("assets/images/bg.png"),
                ),
              ),
              child: ListView.separated(
                itemBuilder: (context, index) => buildListItem(
                    cubit.favoritesModel.data.data[index], context,
                    isSearch: false),
                separatorBuilder: (context, index) => MyDivider(),
                itemCount: cubit.favoritesModel.data.data.length,
              ),
            ),
          ),
          fallback: (context) => ScreenHolder('Favorites'),
        );
      },
    );
  }
}
