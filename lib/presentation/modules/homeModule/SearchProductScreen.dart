import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trade_market_app/data/models/productModel/ProductModel.dart';
import 'package:trade_market_app/presentation/modules/homeModule/ProductDetailsScreen.dart';
import 'package:trade_market_app/shared/components/Components.dart';
import 'package:trade_market_app/shared/cubit/appCubit/AppCubit.dart';
import 'package:trade_market_app/shared/cubit/appCubit/AppStates.dart';
import 'package:trade_market_app/shared/cubit/checkCubit/CheckCubit.dart';
import 'package:trade_market_app/shared/cubit/checkCubit/CheckStates.dart';
import 'package:trade_market_app/shared/cubit/themeCubit/ThemeCubit.dart';

class SearchProductScreen extends StatefulWidget {
  const SearchProductScreen({super.key});

  @override
  State<SearchProductScreen> createState() => _SearchProductScreenState();
}

class _SearchProductScreenState extends State<SearchProductScreen> {


  var searchController = TextEditingController();

  final FocusNode focusNode = FocusNode();


  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CheckCubit , CheckStates>(
      listener: (context , state) {},
      builder: (context , state) {

        var checkCubit = CheckCubit.get(context);

        return BlocConsumer<AppCubit , AppStates>(
          listener: (context , state) {},
          builder: (context , state) {

            var cubit = AppCubit.get(context);
            var searchProducts = cubit.searchProducts;

            var searchIdProducts = cubit.searchIdProducts;
            var numberFavorites = cubit.numberFavorites;


            return Scaffold(
              appBar: defaultAppBar(
                onPress: () {
                  if(searchProducts.isNotEmpty) {
                    searchController.text = '';
                    cubit.clearSearchAllProducts();
                  }
                  Navigator.pop(context);
                },
                title: 'Search Product',
              ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    defaultSearchFormField(
                        label: 'Type ...',
                        controller: searchController,
                        type: TextInputType.text,
                        focusNode: focusNode,
                        onPress: () {
                          searchController.text = '';
                          cubit.clearSearchAllProducts();
                        },
                        onChange: (value) {
                          if(checkCubit.hasInternet) {
                            cubit.searchProduct(name: value);
                          } else {
                            showFlutterToast(message: 'No Internet Connection ', state: ToastStates.error, context: context);
                          }
                          return null;
                        },
                        onSubmit: (value) {
                          if(checkCubit.hasInternet) {
                            cubit.searchProduct(name: value!);
                          } else {
                            showFlutterToast(message: 'No Internet Connection ', state: ToastStates.error, context: context);
                          }
                          return null;
                        }
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Expanded(
                      child: (checkCubit.hasInternet) ? ConditionalBuilder(
                        condition: searchProducts.isNotEmpty,
                        builder: (context) =>  ListView.separated(
                          physics: const BouncingScrollPhysics(),
                            itemBuilder: (context , index) => buildItemSearchProduct(searchProducts[index] , searchIdProducts[index] , numberFavorites),
                            separatorBuilder: (context , index) => Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20.0,
                                vertical: 8.0,
                              ),
                              child: Divider(
                                thickness: 0.8,
                                color: Colors.grey.shade500,
                              ),
                            ),
                            itemCount: searchProducts.length),
                        fallback: (context) => const Center(
                          child: Text(
                            'There is no products you \nare looking for',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 17.0,
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

  Widget buildItemSearchProduct(ProductModel model , productId , numberFavorites) => InkWell(
    borderRadius: BorderRadius.circular(4.0),
    onTap: () {
      if(CheckCubit.get(context).hasInternet) {

        Navigator.of(context).push(createRoute(screen: ProductDetailsScreen(
            productDetails: model,
            productId: productId,
            numberFavorites: numberFavorites[productId] ?? 0)));

      } else {

        showFlutterToast(message: 'No Internet Connection', state: ToastStates.error, context: context);

      }
    },
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26.0,
            backgroundColor: ThemeCubit.get(context).isDark ? Colors.white : Colors.black,
            child: CircleAvatar(
              radius: 25.0,
              backgroundColor: Theme.of(context).colorScheme.primary,
              backgroundImage: NetworkImage('${model.images?[0]}'),
            ),
          ),
          const SizedBox(
            width: 12.0,
          ),
          Expanded(
            child: Text(
              '${model.title}',
              maxLines: 1,
              style: const TextStyle(
                fontSize: 16.0,
                overflow: TextOverflow.ellipsis,
                letterSpacing: 0.5,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(
            width: 12.0,
          ),
          const Icon(
            EvaIcons.diagonalArrowRightUp,
            size: 20.0,
          ),
        ],
      ),
    ),
  );

}
