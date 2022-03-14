import 'package:baya3/layout/cubit/cubit.dart';
import 'package:baya3/layout/cubit/states.dart';
import 'package:baya3/shared/components/components.dart';
import 'package:baya3/shared/styles/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readmore/readmore.dart';

/*
  int id;
  dynamic price;
  dynamic oldPrice;
  dynamic discount;
  String image;
  String name;
  String description;
  bool inFavorites;
  bool inCart;
*/
class ProductDetailsScreen extends StatelessWidget {
  @required
  final model;

  const ProductDetailsScreen({
    Key key,
    this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'PRODUCT DETAILS',
                style: Theme.of(context).textTheme.headline6,
              ),
              elevation: 0.5,
            ),
            body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  colorFilter: new ColorFilter.mode(Colors.white.withOpacity(0.05), BlendMode.dstATop),
                  image: AssetImage("assets/images/bg.png"),
                ),
              ),
              child: Scrollbar(
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Stack(
                        alignment: AlignmentDirectional.bottomStart,
                        children: [
                           CachedNetworkImage(
                              imageUrl: model.image,
                              placeholder: (context, url) => SizedBox(
                                child: Center(child: CircularProgressIndicator()),
                                width: 60,
                                height: 60,
                              ),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                            ),
                          if (model.discount != 0)
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
                    ),
                    MyDivider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        model.name,
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    ),
                    MyDivider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Row(
                        children: [
                          Text(
                            '${model.price} \$',
                            style: const TextStyle(
                              fontSize: 30,
                              color: defaultColor,
                            ),
                          ),
                          const SizedBox(
                            width: 25.0,
                          ),
                          if (model.discount != 0)
                            Text(
                              '${model.oldPrice}',
                              style: const TextStyle(
                                decoration: TextDecoration.lineThrough,
                                fontSize: 25,
                                color: Colors.grey,
                              ),
                            ),
                          const Spacer(),
                          IconButton(
                            onPressed: () {
                              ShopCubit.get(context).changeFavorites(model.id);
                              print('hi ${model.id}');
                            },
                            icon: CircleAvatar(
                              radius: 15.0,
                              backgroundColor:
                                  ShopCubit.get(context).favorites[model.id]
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
                    ),
                    MyDivider(),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        model.description,
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      //   ReadMoreText(
                      //     model.description,
                      //     trimLines: 2,
                      //     colorClickableText: Colors.pink,
                      //     trimMode: TrimMode.Line,
                      //     trimCollapsedText: 'Show more',
                      //     trimExpandedText: 'Show less',
                      //     moreStyle: Theme.of(context).textTheme.bodyText2,
                      //     // moreStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      //   ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
