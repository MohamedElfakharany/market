import 'package:baya3/layout/cubit/cubit.dart';
import 'package:baya3/layout/cubit/states.dart';
import 'package:baya3/shared/components/components.dart';
import 'package:baya3/shared/styles/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var model = ShopCubit.get(context).userModel;
        nameController.text = model.data.name;
        emailController.text = model.data.email;
        phoneController.text = model.data.phone;
        return ConditionalBuilder(
          condition: ShopCubit.get(context).userModel != null,
          builder: (context) => Container(
            // height: MediaQuery.of(context).size.height * 0.8 ,
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: formKey,
              child: ListView(
                children: [
                  if (state is ShopLoadingUpdateUserDataState)
                    LinearProgressIndicator(),
                  const SizedBox(
                    height: 30.0,
                  ),
                  Center(
                    child: Stack(
                      alignment: AlignmentDirectional.bottomEnd,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100.0),
                          child: CachedNetworkImage(
                            imageUrl:
                                'https://avatars.githubusercontent.com/u/34916493?s=400&u=e7300b829193270fbcd03a813551a3702299cbb1&v=4',
                            placeholder: (context, url) => SizedBox(
                              child: Center(child: CircularProgressIndicator()),
                              width: 30,
                              height: 30,
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                            width: 200,
                            height: 200,
                          ),
                        ),
                        CircleAvatar(
                          radius: 25.0,
                          backgroundColor: defaultColor,
                          child: IconButton(
                              onPressed: () {
                                print('BTN pressed');
                              },
                              icon: Icon(
                                Icons.mode_edit,
                                color: Colors.white,
                              )),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  TextFormField(
                    controller: nameController,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      labelText: 'NAME',
                      border: OutlineInputBorder(),
                    ),
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Name must not be empty ';
                      }
                      return '';
                    },
                    onFieldSubmitted: (value){
                      ShopCubit.get(context).updateUserData(
                        name: value ??
                            ShopCubit.get(context).userModel.data.name,
                        email: emailController.text ??
                            ShopCubit.get(context).userModel.data.email,
                        phone: phoneController.text ??
                            ShopCubit.get(context).userModel.data.phone,
                      );
                    },
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email),
                      labelText: 'Email Address',
                      border: OutlineInputBorder(),
                    ),
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'email must not be empty ';
                      }
                      return '';
                    },
                    onFieldSubmitted: (value){
                      ShopCubit.get(context).updateUserData(
                        name: nameController.text ??
                            ShopCubit.get(context).userModel.data.name,
                        email: value ??
                            ShopCubit.get(context).userModel.data.email,
                        phone: phoneController.text ??
                            ShopCubit.get(context).userModel.data.phone,
                      );
                    },
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    controller: phoneController,
                    // keyboardType: TextInputType.number,
                    keyboardType: TextInputType.numberWithOptions(signed: true,decimal: true),
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.phone),
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(),
                    ),
                    validator: (String value) {
                      if (value.isEmpty) return 'Phone must not be empty ';
                      return '';
                    },
                    onFieldSubmitted: (value){
                      ShopCubit.get(context).updateUserData(
                        name: nameController.text ??
                            ShopCubit.get(context).userModel.data.name,
                        email: emailController.text ??
                            ShopCubit.get(context).userModel.data.email,
                        phone: value ??
                            ShopCubit.get(context).userModel.data.phone,
                      );
                    },
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  defaultButton(
                    function: () {
                      // if (formKey.currentState.validate()) {
                      //   ShopCubit.get(context).updateUserData(
                      //     name: nameController.text ??
                      //         ShopCubit.get(context).userModel.data.name,
                      //     email: emailController.text ??
                      //         ShopCubit.get(context).userModel.data.email,
                      //     phone: phoneController.text ??
                      //         ShopCubit.get(context).userModel.data.phone,
                      //   );
                      // }
                    },
                    text: 'Update Data',
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  defaultButton(
                    function: () {
                      ShopCubit.get(context).signOut(context);
                    },
                    text: 'LOg out',
                  ),
                ],
              ),
            ),
          ),
          fallback: (context) => Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
