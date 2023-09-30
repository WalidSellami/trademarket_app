import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trade_market_app/data/models/productModel/ProductModel.dart';
import 'package:trade_market_app/presentation/modules/homeModule/ProductDetailsScreen.dart';
import 'package:trade_market_app/shared/adaptive/anotherCircularLoading/AnotherCircularLoading.dart';
import 'package:trade_market_app/shared/components/Components.dart';
import 'package:trade_market_app/shared/components/Constants.dart';
import 'package:trade_market_app/shared/cubit/appCubit/AppCubit.dart';
import 'package:trade_market_app/shared/cubit/appCubit/AppStates.dart';
import 'package:trade_market_app/shared/cubit/checkCubit/CheckCubit.dart';
import 'package:trade_market_app/shared/cubit/checkCubit/CheckStates.dart';

class MyProductsScreen extends StatelessWidget {
  const MyProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CheckCubit, CheckStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var checkCubit = CheckCubit.get(context);

        return BlocConsumer<AppCubit, AppStates>(
          listener: (context, state) {},
          builder: (context, state) {
            var cubit = AppCubit.get(context);
            var myProducts = cubit.myProducts;
            var myIdProducts = cubit.myIdProducts;
            var numberFavorites = cubit.numberFavorites;

            return Scaffold(
              appBar: defaultAppBar(
                onPress: () {
                  Navigator.pop(context);
                },
                title: 'My Products',
              ),
              body: (checkCubit.hasInternet)
                  ? ConditionalBuilder(
                      condition: myProducts.isNotEmpty,
                      builder: (context) => ListView.separated(
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) => buildItemMyProduct(
                              myProducts[index],
                              myIdProducts[index],
                              numberFavorites,
                              context),
                          separatorBuilder: (context, index) => const SizedBox(
                                height: 20.0,
                              ),
                          itemCount: myProducts.length),
                      fallback: (context) => const Center(
                        child: Text(
                          'There are no your products added',
                          style: TextStyle(
                            fontSize: 17.0,
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  : const Center(
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
  }

  Widget buildItemMyProduct(
          ProductModel model, productId, numberFavorites, context) =>
      GestureDetector(
        onTap: () {
          Navigator.of(context).push(createRoute(
              screen: ProductDetailsScreen(
            productDetails: model,
            productId: productId,
            numberFavorites: numberFavorites[productId] ?? 0,
          )));
        },
        child: Card(
          elevation: 6.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              16.0,
            ),
          ),
          margin: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 12.0,
          ),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    10.0,
                  ),
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Image.network(
                  '${model.images?[0]}',
                  width: 130.0,
                  height: 130.0,
                  fit: BoxFit.cover,
                  frameBuilder:
                      (context, child, frame, wasSynchronouslyLoaded) {
                    if (frame == null) {
                      return SizedBox(
                        height: 120.0,
                        width: 120.0,
                        child:
                            Center(child: AnotherCircularLoading(os: getOs())),
                      );
                    }
                    return child;
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    } else {
                      return SizedBox(
                          width: 130.0,
                          height: 130.0,
                          child: Center(
                              child: AnotherCircularLoading(
                            os: getOs(),
                          )));
                    }
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                        width: 130.0,
                        height: 130.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Image.asset('assets/images/mark.jpg',
                        fit: BoxFit.cover,));
                  },
                ),
              ),
              const SizedBox(
                width: 20.0,
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${model.title}',
                      maxLines: 2,
                      style: const TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontSize: 17.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 12.0,
                      ),
                      child: Divider(
                        thickness: 0.8,
                        color: Colors.grey,
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        '${model.price} DA',
                        style: const TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 20.0,
              ),
            ],
          ),
        ),
      );
}
