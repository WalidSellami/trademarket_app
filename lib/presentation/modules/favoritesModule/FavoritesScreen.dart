import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trade_market_app/data/models/productModel/ProductModel.dart';
import 'package:trade_market_app/presentation/modules/homeModule/ProductDetailsScreen.dart';
import 'package:trade_market_app/shared/adaptive/anotherCircularLoading/AnotherCircularLoading.dart';
import 'package:trade_market_app/shared/adaptive/circularLoading/CircularLoading.dart';
import 'package:trade_market_app/shared/components/Components.dart';
import 'package:trade_market_app/shared/components/Constants.dart';
import 'package:trade_market_app/shared/cubit/appCubit/AppCubit.dart';
import 'package:trade_market_app/shared/cubit/appCubit/AppStates.dart';
import 'package:trade_market_app/shared/cubit/checkCubit/CheckCubit.dart';
import 'package:trade_market_app/shared/cubit/checkCubit/CheckStates.dart';
import 'package:trade_market_app/shared/cubit/themeCubit/ThemeCubit.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CheckCubit , CheckStates>(
      listener: (context , state) {},
      builder: (context , state) {

        return BlocConsumer<AppCubit , AppStates>(
          listener: (context , state) {},
          builder: (context , state) {

            var cubit = AppCubit.get(context);
            var myFavoriteProducts = cubit.myFavoriteProducts;
            var myIdFavoriteProducts = cubit.myIdFavoriteProducts;
            var numberFavorites = cubit.numberFavorites;


            return Scaffold(
              body: ConditionalBuilder(
                condition: myFavoriteProducts.isNotEmpty,
                builder: (context) => ListView.separated(
                  physics: const BouncingScrollPhysics(),
                      itemBuilder: (context , index) => buildItemMyFavoriteProduct(myFavoriteProducts[index], myIdFavoriteProducts[index], numberFavorites, context),
                      separatorBuilder: (context , index) => const SizedBox(
                        height: 20.0,
                      ), itemCount: myFavoriteProducts.length),
                fallback: (context) => (state is LoadingGetAllProductsAppState) ? Center(child: CircularLoading(os: getOs())) :
                 const Center(
                   child: Text(
                     'There is no favorite products',
                     style: TextStyle(
                       fontSize: 17.0,
                       fontWeight: FontWeight.bold,
                     ),
                   ),
                 ),
              ),
            );

          },
        );
      },
    );
  }

  Widget buildItemMyFavoriteProduct(ProductModel model , productId , numberFavorites  , context) => GestureDetector(
    onTap: () {
      Navigator.of(context).push(createRoute(screen: ProductDetailsScreen(
        productDetails: model,
        productId: productId,
        numberFavorites: numberFavorites[productId] ?? 0,)));
    },
    child: Card(
      elevation: 6.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0,),
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
              borderRadius: BorderRadius.circular(10.0,),
            ),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Image.network('${model.images?[0]}',
              width: 130.0,
              height: 130.0,
              fit: BoxFit.fitWidth,
              frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                if(frame == null) {
                  return SizedBox(
                    height: 130.0,
                    width: 130.0,
                    child: Center(child: AnotherCircularLoading(os: getOs())),
                  );
                }
                return child;
              },
              loadingBuilder: (context, child, loadingProgress) {
                if(loadingProgress == null) {
                  return child;
                } else {
                  return SizedBox(
                      width: 130.0,
                      height: 130.0,
                      child: Center(child: AnotherCircularLoading(os: getOs(),)));
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
                    child: Image.asset('assets/images/mark.jpg'));
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
                    vertical: 8.0,
                  ),
                  child: Divider(
                    thickness: 0.8,
                    color: Colors.grey,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${model.price} DA',
                      style: const TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if(model.uIdVendor != uId)
                      Material(
                        color: ThemeCubit.get(context).isDark ? Colors.grey.shade800.withOpacity(.7) : Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(16.0),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16.0),
                          onTap: () {
                            if(model.favorites?[uId] == false || model.favorites?[uId] == null) {

                              AppCubit.get(context).addProductFavorite(productId: productId);

                            } else {

                              AppCubit.get(context).removeProductFavorite(productId: productId);
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              (model.favorites?[uId] == true) ? Icons.star_rounded : Icons.star_border_rounded,
                              size: 30.0,
                              color: Colors.amber.shade800,
                            ),
                          ),
                        ),
                      ),
                  ],
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
