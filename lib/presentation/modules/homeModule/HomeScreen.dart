import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trade_market_app/data/models/productModel/ProductModel.dart';
import 'package:trade_market_app/presentation/modules/homeModule/AddProductScreen.dart';
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
import 'package:trade_market_app/shared/cubit/themeCubit/ThemeStates.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  bool isVisible = true;

  @override
  void initState() {
    super.initState();
  }

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
                    var allProducts = cubit.allProducts;
                    var idProducts = cubit.idProducts;
                    var numberFavorites = cubit.numberFavorites;

                    return Scaffold(
                      body: (checkCubit.hasInternet) ? ConditionalBuilder(
                        condition: allProducts.isNotEmpty,
                        builder: (context) => NotificationListener<UserScrollNotification>(
                          onNotification: (notification) {
                            if (notification.direction == ScrollDirection.forward) {
                              setState(() {
                                isVisible = true;
                              });
                            } else if (notification.direction == ScrollDirection.reverse) {
                              setState(() {
                                isVisible = false;
                              });
                            }
                            return true;
                          },
                          child: GridView.builder(
                            physics: const BouncingScrollPhysics(),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 15.0,
                                crossAxisSpacing: 15.0,
                                childAspectRatio: 1.24 / 2,
                              ),
                              itemBuilder: (context , index) => buildItemProduct(allProducts[index] , idProducts[index] , numberFavorites),
                              itemCount: allProducts.length,
                            ),
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
                      ) : const Center(
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
                      floatingActionButton: (checkCubit.hasInternet) ? Visibility(
                        visible: isVisible,
                        child: FloatingActionButton.extended(
                          onPressed: () {
                            Navigator.of(context)
                                .push(createRoute(screen: const AddProductScreen()));
                          },
                          label: const Text(
                            'Add product',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          icon: const Icon(
                            EvaIcons.editOutline,
                            color: Colors.white,
                          ),
                        ),
                      ) : null,
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


  Widget buildItemProduct(ProductModel? model , productId , numberFavorites) => GestureDetector(
    onTap: () {
      Navigator.of(context).push(createRoute(screen: ProductDetailsScreen(
        productDetails: model! ,
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
      child: Column(
        children: [
          Container(
            height: 140.0,
            width: double.infinity,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(10.0),
                topLeft: Radius.circular(10.0),
              ),
            ),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Image.network('${model?.images?[0]}',
             fit: BoxFit.fitWidth,
              frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                if(frame == null) {
                  return SizedBox(
                    height: 140.0,
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
                      height: 140.0,
                      width: double.infinity,
                      child: Center(child: AnotherCircularLoading(os: getOs(),)));
                }
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                    height: 140.0,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                      ),
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Image.asset('assets/images/mark.jpg',
                     fit: BoxFit.fitWidth,
                    ));
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  '${model?.title}',
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  style: const TextStyle(
                    fontSize: 17.0,
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 14.0,
                ),
                Text(
                  '${model?.price} DA',
                  style: const TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 12.0,
                ),
                Row(
                  mainAxisAlignment: (model?.uIdVendor == uId) ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.star_rounded,
                          size: 22.0,
                          color: Colors.amber.shade800,
                        ),
                        const SizedBox(
                          width: 3.0,
                        ),
                        Text(
                          '${numberFavorites[productId] ?? 0}',
                        ),
                      ],
                    ),
                    if(model?.uIdVendor != uId)
                    Material(
                      color: ThemeCubit.get(context).isDark ? Colors.grey.shade800.withOpacity(.7) : Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(16.0),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16.0),
                        onTap: () {
                          if(model?.favorites?[uId] == false || model?.favorites?[uId] == null) {

                            AppCubit.get(context).addProductFavorite(productId: productId);

                          } else {

                            AppCubit.get(context).removeProductFavorite(productId: productId);
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            (model?.favorites?[uId] == true) ? Icons.star_rounded : Icons.star_border_rounded,
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
        ],
      ),
    ),
  );

}
