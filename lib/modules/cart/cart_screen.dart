import 'package:baya3/layout/cubit/cubit.dart';
import 'package:baya3/layout/cubit/states.dart';
import 'package:baya3/shared/components/components.dart';
import 'package:baya3/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var discountCouponController = TextEditingController();
    var formKey = GlobalKey<FormState>();
    var cubit = ShopCubit.get(context);
    return BlocConsumer<ShopCubit, ShopStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Form(
            key: formKey,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  colorFilter: new ColorFilter.mode(
                      Colors.white.withOpacity(0.05), BlendMode.dstATop),
                  image: AssetImage("assets/images/bg.png"),
                ),
              ),
              child: ListView(
                children: [
                  ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) => buildListItem(
                      cubit.favoritesModel.data.data[index],
                      context,
                    ),
                    separatorBuilder: (context, index) => MyDivider(),
                    itemCount: cubit.favoritesModel.data.data.length,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20, top: 10, bottom: 20, right: 20),
                    child: Column(
                      children: [
                        // const MySeparator(color: Colors.grey),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Payment Details',
                          style: Theme.of(context).textTheme.headline4.copyWith(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Text('SubTotal'),
                            Spacer(),
                            Text(
                              '40 AED',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Text('Delivery'),
                            Spacer(),
                            Text(
                              '10 AED',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Text('Discount Coupon'),
                            Spacer(),
                            Text(
                              '50 %',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          color: Colors.grey[300],
                          height: 1.0,
                          width: double.infinity,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Text(
                              'Total',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Spacer(),
                            Text(
                              '50 AED',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Container(
                              height: 60.0,
                              width: 90.0,
                              decoration: BoxDecoration(
                                color: defaultColor,
                                borderRadius: BorderRadiusDirectional.only(
                                  bottomStart: Radius.circular(15),
                                  topStart: Radius.circular(15),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'Add',
                                  style: TextStyle(
                                    fontSize: 30.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Expanded(
                              child: TextFormField(
                                controller: discountCouponController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'Discount Coupon',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(15),
                                      topRight: Radius.circular(15),
                                    ),
                                  ),
                                ),
                                validator: (String value) {
                                  if (value.isEmpty) {
                                    return 'Please Enter Discount Coupon';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        defaultButton(
                          function: () {},
                          text: 'pay',
                          height: 60.0,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
