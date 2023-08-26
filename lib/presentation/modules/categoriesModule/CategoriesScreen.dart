import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trade_market_app/data/models/categoriesModel/CategoriesModel.dart';
import 'package:trade_market_app/presentation/modules/categoriesModule/FifthCategoryScreen.dart';
import 'package:trade_market_app/presentation/modules/categoriesModule/FirstCategoryScreen.dart';
import 'package:trade_market_app/presentation/modules/categoriesModule/FourthCategoryScreen.dart';
import 'package:trade_market_app/presentation/modules/categoriesModule/SecondCategoryScreen.dart';
import 'package:trade_market_app/presentation/modules/categoriesModule/ThirdCategoryScreen.dart';
import 'package:trade_market_app/shared/adaptive/anotherCircularLoading/AnotherCircularLoading.dart';
import 'package:trade_market_app/shared/components/Components.dart';
import 'package:trade_market_app/shared/components/Constants.dart';
import 'package:trade_market_app/shared/cubit/appCubit/AppCubit.dart';
import 'package:trade_market_app/shared/cubit/appCubit/AppStates.dart';
import 'package:trade_market_app/shared/cubit/checkCubit/CheckCubit.dart';
import 'package:trade_market_app/shared/cubit/checkCubit/CheckStates.dart';
import 'package:trade_market_app/shared/cubit/themeCubit/ThemeCubit.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {

  List<CategoriesModel> items = [
    CategoriesModel(
    name: 'Home & Garden',
    image: 'https://media.istockphoto.com/id/1145840259/vector/home-flat-icon-pixel-perfect-for-mobile-and-web.jpg?s=612x612&w=0&k=20&c=2DWK30S50TbctWwccYw5b-uR6EAksv1n4L_aoatjM9Q=',
   ),
    CategoriesModel(
      name: 'Entertainment',
      image: 'https://img.freepik.com/premium-photo/two-video-game-controllers-joysticks-game-console-isolated-black-background-gamer-controlling-devices-closeup_154092-17958.jpg',
    ),
    CategoriesModel(
      name: 'Clothing & Accessories',
      image: 'https://thumbs.dreamstime.com/b/travel-clothing-accessories-apparel-along-women-tri-trip-90669520.jpg',
    ),
    CategoriesModel(
      name: 'Electronics',
      image: 'https://img.freepik.com/premium-photo/electronic-gadgets-black-concrete-background-concept-accessories-successful-business-flat-lay_76255-466.jpg',
    ),
    CategoriesModel(
      name: 'Vehicles',
      image: 'https://img.freepik.com/premium-vector/vehicles-set-bicycle-bike-car-bus_665045-404.jpg?w=2000',
    ),

  ];


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CheckCubit , CheckStates>(
      listener: (context , state) {},
      builder: (context , state) {

        var checkCubit = CheckCubit.get(context);

        return BlocConsumer<AppCubit , AppStates>(
          listener: (context , state) {},
          builder: (context , state) {

            return Scaffold(
              body: (checkCubit.hasInternet) ? ListView.separated(
                physics: const BouncingScrollPhysics(),
                  itemBuilder: (context , index) => buildItemCategory(items[index], index , context),
                  separatorBuilder: (context , index) => Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30.0,
                    ),
                    child: Divider(
                      thickness: 0.7,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  itemCount: items.length) :
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
  }

  Widget buildItemCategory(CategoriesModel model , index , context) => InkWell(
    onTap: () {
      if(CheckCubit.get(context).hasInternet) {
        if(index == 0) {
          Navigator.of(context).push(createSecondRoute(screen: const FirstCategoryScreen()));
        } else if(index == 1) {
          Navigator.of(context).push(createSecondRoute(screen: const SecondCategoryScreen()));
        } else if(index == 2) {
          Navigator.of(context).push(createSecondRoute(screen: const ThirdCategoryScreen()));
        } else if(index == 3) {
          Navigator.of(context).push(createSecondRoute(screen: const FourthCategoryScreen()));
        } else  {
          Navigator.of(context).push(createSecondRoute(screen: const FifthCategoryScreen()));
        }
      } else {
        showFlutterToast(message: 'No Internet Connection', state: ToastStates.error, context: context);
      }
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: 8.0,
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(
                width: 0.0,
                color: ThemeCubit.get(context).isDark ? Colors.white : Colors.black,
              ),
            ),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Image.network('${model.image}',
             width: 120.0,
             height: 120.0,
             fit: BoxFit.cover,
              frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                if(frame == null) {
                  return SizedBox(
                    height: 120.0,
                    width: 120.0,
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
                      width: 120.0,
                      height: 120.0,
                      child: Center(child: AnotherCircularLoading(os: getOs(),)));
                }
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                    width: 120.0,
                    height: 120.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Image.asset('assets/images/mark.jpg'));
              },
            ),
          ),
          const SizedBox(
            width: 14.0,
          ),
          Expanded(
            child: Text(
              '${model.name}',
              style: const TextStyle(
                fontSize: 16.0,
                letterSpacing: 0.5,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Icon(
            Icons.arrow_forward_ios_rounded,
            color: ThemeCubit.get(context).isDark ? Colors.white : Colors.black,
            size: 20.0,
          ),
        ],
      ),
    ),
  );
}
