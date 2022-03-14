import 'package:baya3/layout/cubit/cubit.dart';
import 'package:baya3/layout/cubit/states.dart';
import 'package:baya3/models/category_model.dart';
import 'package:baya3/shared/components/components.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              colorFilter: new ColorFilter.mode(Colors.white.withOpacity(0.05), BlendMode.dstATop),
              image: AssetImage("assets/images/bg.png"),
            ),
          ),
          child: ListView.separated(
            itemBuilder: (context, index) => buildCatItem(
                ShopCubit.get(context).categoryModel.data.data[index]),
            separatorBuilder: (context, index) => MyDivider(),
            itemCount: ShopCubit.get(context).categoryModel.data.data.length,
          ),
        );
      },
    );
  }

  Widget buildCatItem(Datum model) => Padding(
    padding: const EdgeInsets.all(10.0),
    child: Container(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
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
          child: Row(
            children: [
              CachedNetworkImage(
                imageUrl: model.image,
                placeholder: (context, url) => SizedBox(
                  child: Center(child: CircularProgressIndicator()),
                  width: 30,
                  height: 30,
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
                width: 120,
                height: 120,
              ),
              SizedBox(
                width: 20.0,
              ),
              Text(
                model.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Spacer(),
              Icon(Icons.arrow_forward_ios),
            ],
          ),
        ),
  );
}
