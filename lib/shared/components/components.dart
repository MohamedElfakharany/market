import 'dart:ui';
import 'package:baya3/layout/cubit/cubit.dart';
import 'package:baya3/modules/product_screen.dart';
import 'package:baya3/shared/styles/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void navigateTo(context, Widget) => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Widget,
      ),
    );

void navigateAndFinish(context, Widget) => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => Widget,
      ),
      (Route<dynamic> route) => false,
    );

Widget defaultButton({
  double width = double.infinity,
  Color background = Colors.blue,
  bool isUpperCase = true,
  double radius = 15.0,
  double height = 45.0,
  FontWeight BtnfontBold = FontWeight.bold,
  @required Function() function,
  @required String text,
}) {
  return Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      color: background,
    ),
    child: MaterialButton(
      child: Text(
        isUpperCase ? text.toUpperCase() : text,
        style: TextStyle(
          fontSize: 20,
          fontWeight: BtnfontBold,
          color: Colors.white,
        ),
      ),
      onPressed: function,
    ),
  );
}

Widget defaultTextButton({
  @required Function function,
  @required String data,
}) {
  return TextButton(
    onPressed: function,
    child: Text(
      data.toUpperCase(),
    ),
  );
}

void showToast({
  @required String msg,
  @required ToastState state,
}) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 2,
      backgroundColor: chooseToastColor(state),
      textColor: Colors.white,
      fontSize: 16.0);
}

enum ToastState { SUCCESS, ERROR, WARNING }

Color chooseToastColor(ToastState state) {
  Color color;
  switch (state) {
    case ToastState.SUCCESS:
      color = Colors.green;
      break;
    case ToastState.WARNING:
      color = Colors.amber;
      break;
    case ToastState.ERROR:
      color = Colors.red;
      break;
  }
  return color;
}

Widget MyDivider() => Padding(
  padding: const EdgeInsets.only(left: 20,top: 8,bottom: 8,right: 20),
  child:   Container(
    width: double.infinity,
    height: 1.0,
    color: Colors.grey,
  ),
);

Widget buildListItem(model, context, {bool isSearch = false}) {
  return Padding(
    padding: EdgeInsets.only(
      bottom: 10.0,
      top: 10.0,
      left: 20.0,
      right: 20.0,
    ),
    child: Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
        border: Border.all(color: Colors.grey[300]),
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      height: 120.0,
      child: MaterialButton(
        onPressed: (){
          print('${model.product.id} pressed');
          navigateTo(context, ProductDetailsScreen(model: model.product,));
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child:
                  // Image(
                  //   image: NetworkImage(
                  //     model.product.image,
                  //   ),
                  //   width: 120.0,
                  //   height: 120.0,
                  // ),
                  CachedNetworkImage(
                    imageUrl: model.product.image,
                    placeholder: (context, url) => SizedBox(
                      child: Center(child: CircularProgressIndicator()),
                      width: 30,
                      height: 30,
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    width: 120,
                    height: 120,
                  ),
                ),
                if (model.product.discount != 0 && isSearch) //model.discount
                  Container(
                    color: Colors.red,
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: const Text(
                      'DISCOUNT',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(
              width: 5.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    model.product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Spacer(),
                  Row(
                    children: [
                      Text(
                        '${model.product.price}',
                        style: const TextStyle(
                          color: defaultColor,
                        ),
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      if (model.product.discount != 0 && isSearch)
                        Text(
                          '${model.product.oldPrice}',
                          style: const TextStyle(
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey,
                          ),
                        ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          ShopCubit.get(context)
                              .changeFavorites(model.product.id);
                          print('hi ${model.product.id}');
                        },
                        icon: CircleAvatar(
                          radius: 15.0,
                          backgroundColor:
                              ShopCubit.get(context).favorites[model.product.id]
                                  ? defaultColor
                                  : Colors.grey,
                          child: const Icon(
                            Icons.favorite_border,
                            size: 14.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class ScreenHolder extends StatelessWidget {
  final String msg;
  ScreenHolder(this.msg);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'No $msg Yet',
        style: Theme.of(context).textTheme.headline3,
      ),
    );
  }
}

class MySeparator extends StatelessWidget {
  final double height;
  final Color color;

  const MySeparator({this.height = 1, this.color = Colors.black});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final boxWidth = constraints.constrainWidth();
          final dashWidth = 10.0;
          final dashHeight = height;
          final dashCount = (boxWidth / (2 * dashWidth)).floor();
          return Flex(
            children: List.generate(dashCount, (_) {
              return SizedBox(
                width: dashWidth,
                height: dashHeight,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: color),
                ),
              );
            }),
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            direction: Axis.horizontal,
          );
        },
      ),
    );
  }
}
