//ignore: must_be_immutable
import 'package:baya3/layout/cubit/cubit.dart';
import 'package:baya3/layout/cubit/states.dart';
import 'package:baya3/modules/product_screen.dart';
import 'package:baya3/shared/components/components.dart';
import 'package:baya3/shared/styles/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchScreen extends StatelessWidget {
  GlobalKey formKey = GlobalKey<FormState>();
  var searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    double windowHeight = MediaQuery.of(context).size.height;
    var cubit = ShopCubit.get(context);
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'SEARCH',
              style: Theme.of(context)
                  .textTheme
                  .headline4
                  .copyWith(color: Colors.lightBlue),
            ),
          ),
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                colorFilter: new ColorFilter.mode(Colors.white.withOpacity(0.05), BlendMode.dstATop),
                image: AssetImage("assets/images/bg.png"),
              ),
            ),
            child: ListView(
              physics: NeverScrollableScrollPhysics(),
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextFormField(
                    controller: searchController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text('search'),
                      prefixIcon: Icon(Icons.search),
                    ),
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Search must n\'t be Empty';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      cubit.getSearch(text: searchController.text);
                    },
                  ),
                ),
                if (state is ShopLoadingSearchState)
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.only(start: 20.0, end: 20.0),
                    child: LinearProgressIndicator(),
                  ),
                SizedBox(
                  height: 10,
                ),
                ConditionalBuilder(
                  condition: cubit.searchModel != null,
                  builder: (context) => Container(
                    height: windowHeight * 0.725,
                    child: Container(
                      child: Scrollbar(
                        child: ListView.separated(
                          itemBuilder: (context, index) => MaterialButton(
                            onPressed: (){
                              navigateTo(context, ProductDetailsScreen(model: cubit
                                  .searchModel.data.data[index],));
                            },
                            child: Padding(
                              padding: EdgeInsets.only(
                                bottom: 5.0,
                                top: 5.0,
                              ),
                              child: Container(
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
                                height: 120.0,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Stack(
                                      alignment: AlignmentDirectional.bottomEnd,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(15),
                                          child: CachedNetworkImage(
                                            imageUrl: cubit
                                                .searchModel.data.data[index].image,
                                            placeholder: (context, url) => SizedBox(
                                              child: Center(
                                                  child: CircularProgressIndicator()),
                                              width: 30,
                                              height: 30,
                                            ),
                                            errorWidget: (context, url, error) =>
                                                Icon(Icons.error),
                                            width: 120,
                                            height: 120,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 20.0,
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
                                            cubit.searchModel.data.data[index].name,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Spacer(),
                                          Row(
                                            children: [
                                              Text(
                                                '${cubit.searchModel.data.data[index].price}',
                                                style: const TextStyle(
                                                  color: defaultColor,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10.0,
                                              ),
                                              const Spacer(),
                                              IconButton(
                                                onPressed: () {
                                                  ShopCubit.get(context)
                                                      .changeFavorites(cubit
                                                          .searchModel
                                                          .data
                                                          .data[index]
                                                          .id);
                                                  print(
                                                      'hi ${cubit.searchModel.data.data[index].id}');
                                                },
                                                icon: CircleAvatar(
                                                  radius: 15.0,
                                                  backgroundColor:
                                                      ShopCubit.get(context)
                                                                  .favorites[
                                                              cubit.searchModel.data
                                                                  .data[index].id]
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
                          ),
                          separatorBuilder: (context, index) => MyDivider(),
                          itemCount: cubit.searchModel.data.data.length,
                        ),
                      ),
                    ),
                  ),
                  fallback: (context) => ScreenHolder('Searches'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
