import 'package:baya3/layout/cubit/cubit.dart';
import 'package:baya3/layout/cubit/states.dart';
import 'package:baya3/layout/home_layout.dart';
import 'package:baya3/modules/register/register_screen.dart';
import 'package:baya3/shared/components/components.dart';
import 'package:baya3/shared/network/local/cache_helper.dart';
import 'package:baya3/shared/network/local/const_shared.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    return BlocProvider(
      create: (BuildContext context) => ShopCubit(),
      child: BlocConsumer<ShopCubit, ShopStates>(
        listener: (context, state) {
          if (state is ShopLoginSuccessState) {
            if (state.loginModel.status) {
              // print(state.loginModel.message);
              // print(state.loginModel.data.token);

              CacheHelper.saveData(
                key: 'name',
                value: state.loginModel.data.name,
              );
              CacheHelper.saveData(
                key: 'phone',
                value: state.loginModel.data.phone,
              );
              CacheHelper.saveData(
                key: 'email',
                value: state.loginModel.data.email,
              );
              CacheHelper.saveData(
                key: 'token',
                value: state.loginModel.data.token,
              ).then((value) {
                token = state.loginModel.data.token;
                navigateAndFinish(
                  context,
                  HomeLayout(),
                );
              });
            } else {
              print(state.loginModel.message);
              // showToast(
              //   msg: state.loginModel.message,
              //   state: ToastState.ERROR,
              // );
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Error...!'),
                    content: Text('${state.loginModel.message}'),
                  );
                },
              );
            }
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'LOGIN',
                        style: Theme.of(context).textTheme.headline3.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        'Login now to browse our hot offers',
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                              color: Colors.grey,
                              fontWeight: FontWeight.normal,
                            ),
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email_outlined),
                          labelText: 'Email Address',
                          border: OutlineInputBorder(),
                        ),
                        validator: (String value) {
                          if (value.isEmpty || !value.contains('@')) {
                            return 'Please Enter Your Email Address';
                          }
                          return '';
                        },
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        controller: passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: ShopCubit.get(context).isPassword,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock_outlined),
                          suffixIcon: IconButton(
                            icon: Icon(
                              ShopCubit.get(context).suffix,
                            ),
                            onPressed: () {
                              ShopCubit.get(context).changePasswordVisibility();
                            },
                          ),
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                        ),
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Password is too short';
                          }
                          return '';
                        },
                        onSaved: (value){
                          ShopCubit.get(context).login(
                            email: emailController.text,
                            password: passwordController.text,
                          );
                        },
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      ConditionalBuilder(
                        condition: state is! ShopLoginLoadingState,
                        builder: (context) => defaultButton(
                          function: () {
                            try {
                              if (formKey.currentState.validate()) {
                                ShopCubit.get(context).login(
                                  email: emailController.text,
                                  password: passwordController.text,
                                );
                              }
                              else{
                                print('mohamed');
                              }
                            } catch (e) {
                              print(e.toString());
                              print('ali');
                            }
                          },
                          text: 'Login',
                          isUpperCase: true,
                        ),
                        fallback: (context) => Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Don\'t have an account..?!',
                          ),
                          defaultTextButton(
                            function: () {
                              navigateTo(context, RegisterScreen());
                            },
                            data: 'register',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
