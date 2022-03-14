import 'package:baya3/layout/cubit/cubit.dart';
import 'package:baya3/layout/cubit/states.dart';
import 'package:baya3/models/category_model.dart';
import 'package:baya3/models/home_model.dart';
import 'package:baya3/modules/product_screen.dart';
import 'package:baya3/shared/components/components.dart';
import 'package:baya3/shared/styles/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        if (state is ShopChangeFavoritesSuccessState) {
          if (!state.model.status) {
            showToast(msg: state.model.message, state: ToastState.ERROR);
          }
        }
      },
      builder: (context, state) {
        return ConditionalBuilder(
          condition: ShopCubit.get(context).homeModel != null &&
              ShopCubit.get(context).categoryModel != null,
          builder: (context) => homeBannerBuilder(
            ShopCubit.get(context).homeModel,
            ShopCubit.get(context).categoryModel,
            context,
          ),
          fallback: (context) =>
              const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  var selectedProduct;

  Widget homeBannerBuilder(
    HomeModel model,
    CategoriesModel categoryModel,
    context,
  ) {
    return Container(
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
            SizedBox(height: 10.0,),
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset:
                    Offset(0, 3), // changes position of shadow
                  ),
                ],
                border: Border.all(color: Colors.grey[300]),
                color: Colors.white,
                // borderRadius: BorderRadius.circular(15),
              ),
              child: CarouselSlider(
                items: model.data.banners
                    .map(
                      (e) => CachedNetworkImage(
                        imageUrl: e.image,
                        placeholder: (context, url) => SizedBox(
                          child: Center(child: CircularProgressIndicator()),
                          width: 60,
                          height: 60,
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    )
                    .toList(),
                options: CarouselOptions(
                  height: 250.0,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 3),
                  autoPlayAnimationDuration: const Duration(seconds: 1),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  scrollDirection: Axis.horizontal,
                  viewportFraction: 1.0,
                  onPageChanged: (int index, reason) {
                    ShopCubit.get(context).changeCarouselState(index);
                  },
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: model.data.banners
                  .map(
                    (e) => CachedNetworkImage(
                      imageUrl: e.image,
                      placeholder: (context, url) => SizedBox(
                        child: CircularProgressIndicator(),
                        width: 30,
                        height: 30,
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  )
                  .toList()
                  .asMap()
                  .entries
                  .map((e) => Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          height: 10.0,
                          width: 10.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: ShopCubit.get(context).currentCarouselIndex ==
                                    e.key
                                ? defaultColor
                                : Colors.grey[300],
                          ),
                        ),
                      ))
                  .toList(),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CATEGORIES',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    height: 120.0,
                    child: ListView.separated(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) =>
                          CategoryBuilder(categoryModel.data.data[index]),
                      separatorBuilder: (context, index) => SizedBox(
                        width: 10.0,
                      ),
                      itemCount: categoryModel.data.data.length,
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    'NEW PRODUCTS',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Container(
              // padding: EdgeInsets.only(top: 10.0),
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  colorFilter: new ColorFilter.mode(Colors.white.withOpacity(0.05), BlendMode.dstATop),
                  image: AssetImage("assets/images/bg.png"),
                ),
              ),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 20.0,
                crossAxisSpacing: 2.0,
                childAspectRatio: 1 / 1.5,
                children: List.generate(
                  model.data.products.length,
                  (index) => homeGridProductsBuilder(
                    model.data.products[index],
                    context,
                  ),
                ),
              ),
            ),
            Container(
              color: Colors.grey[300],
              width: double.infinity,
              height: 2.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget categoryBuilder(Datum model) => Container(
        width: 100.0,
        height: 100.0,
        alignment: AlignmentDirectional.centerStart,
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            Image(
              image: NetworkImage(model.image),
              height: 100.0,
              width: 100.0,
            ),
            Container(
              width: 100.0,
              color: Colors.black.withOpacity(0.5),
              child: Text(
                model.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      );

  Widget homeGridProductsBuilder(ProductsModel model, context) {
    return MaterialButton(
      onPressed: (){
        navigateTo(context, ProductDetailsScreen(model: model,));
      },
      child: Container(
        // color: Colors.white,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 5,
              offset:
              Offset(0, 3), // changes position of shadow
            ),
          ],
          border: Border.all(color: Colors.grey[300]),
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: [
                CachedNetworkImage(
                  imageUrl: model.image,
                  placeholder: (context, url) => SizedBox(
                    child: Center(child: CircularProgressIndicator()),
                    width: 30,
                    height: 30,
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  width: double.infinity ,
                  height: 180,
                  fit: BoxFit.scaleDown,
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
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      Text(
                        '${model.price}',
                        style: const TextStyle(
                          color: defaultColor,
                        ),
                      ),
                      const SizedBox(
                        width: 4.0,
                      ),
                      if (model.discount != 0)
                        Text(
                          '${model.oldPrice}',
                          style: const TextStyle(
                            decoration: TextDecoration.lineThrough,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryBuilder extends StatefulWidget {
  Datum model;

  CategoryBuilder(
    this.model, {
    Key key,
  }) : super(key: key);

  @override
  _CategoryBuilderState createState() => _CategoryBuilderState(this.model);
}

class _CategoryBuilderState extends State<CategoryBuilder> {
  Datum model;

  _CategoryBuilderState(this.model);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        width: 100.0,
        height: 100.0,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 5,
              offset:
              Offset(0, 3), // changes position of shadow
            ),
          ],
          border: Border.all(color: Colors.grey[300]),
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        alignment: AlignmentDirectional.centerStart,
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            CachedNetworkImage(
              imageUrl: model.image,
              placeholder: (context, url) => SizedBox(
                child: Center(child: CircularProgressIndicator()),
                width: 30,
                height: 30,
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
              height: 95.0,
              width: 100.0,
            ),
            Container(
              width: 100.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.black.withOpacity(0.5),
              ),
              child: Text(
                model.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
