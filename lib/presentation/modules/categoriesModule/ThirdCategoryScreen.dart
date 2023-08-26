import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trade_market_app/shared/adaptive/circularLoading/CircularLoading.dart';
import 'package:trade_market_app/shared/components/Components.dart';
import 'package:trade_market_app/shared/components/Constants.dart';
import 'package:trade_market_app/shared/cubit/appCubit/AppCubit.dart';
import 'package:trade_market_app/shared/cubit/appCubit/AppStates.dart';
import 'package:trade_market_app/shared/cubit/checkCubit/CheckCubit.dart';
import 'package:trade_market_app/shared/cubit/checkCubit/CheckStates.dart';
import 'package:trade_market_app/shared/cubit/themeCubit/ThemeCubit.dart';
import 'package:trade_market_app/shared/cubit/themeCubit/ThemeStates.dart';

class ThirdCategoryScreen extends StatelessWidget {
  const ThirdCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
        builder: (context) {
          if(CheckCubit.get(context).hasInternet) {
            AppCubit.get(context).getAllProducts();
          }
          return BlocConsumer<CheckCubit, CheckStates>(
            listener: (context, state) {},
            builder: (context, state) {

              var checkCubit = CheckCubit.get(context);

              return BlocConsumer<ThemeCubit, ThemeStates>(
                listener: (context, state) {},
                builder: (context, state) {

                  return BlocConsumer<AppCubit, AppStates>(
                    listener: (context, state) {},
                    builder: (context, state) {

                      var cubit = AppCubit.get(context);
                      var products = cubit.thirdCategory;
                      var idProducts = cubit.idThirdCategory;
                      var numberFavorites = cubit.numberFavorites;

                      return Scaffold(
                        appBar: defaultAppBar(
                          onPress: () {
                            Navigator.pop(context);
                          },
                          title: 'Clothing & Accessories',
                        ),
                        body: (checkCubit.hasInternet) ? ConditionalBuilder(
                          condition: products.isNotEmpty,
                          builder: (context) => GridView.builder(
                            physics: const BouncingScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 15.0,
                              crossAxisSpacing: 15.0,
                              childAspectRatio: 1.24 / 2,
                            ),
                            itemBuilder: (context , index) => buildItemCategoryProduct(products[index] , idProducts[index] , numberFavorites , context),
                            itemCount: products.length,
                          ),
                          fallback: (context) => (state is LoadingGetAllProductsAppState) ? Center(child: CircularLoading(os: getOs())) :
                          const Center(
                            child: Text(
                              'There is no products yet.',
                              style: TextStyle(
                                fontSize: 17.0,
                                letterSpacing: 0.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ) :
                        const Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'No Internet',
                                style: TextStyle(
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Icon(
                                EvaIcons.wifiOffOutline,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        }
    );
  }

}
