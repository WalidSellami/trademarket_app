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

class SellerProfileScreen extends StatelessWidget {
  const SellerProfileScreen({super.key});

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
            var sellerProfile = cubit.sellerProfile;

            return Scaffold(
              appBar: defaultAppBar(
                onPress: () {
                  Navigator.pop(context);
                },
                title: sellerProfile?.fullName ?? '',
              ),
              body: (checkCubit.hasInternet) ? ConditionalBuilder(
                condition: state is! LoadingGetSellerProfileAppState,
                builder: (context) => SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              showFullImage('${sellerProfile?.imageProfile}', 'image', context);
                            },
                            child: Hero(
                              tag: 'image',
                              child: Container(
                                decoration: const BoxDecoration(),
                                child: CircleAvatar(
                                  radius: 52.0,
                                  backgroundColor: ThemeCubit.get(context).isDark ? Colors.white : Colors.black,
                                  child: CircleAvatar(
                                    radius: 50.0,
                                    backgroundColor: Theme.of(context).colorScheme.primary,
                                    backgroundImage: NetworkImage('${sellerProfile?.imageProfile}'),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          Text(
                            '${sellerProfile?.fullName}',
                            style: const TextStyle(
                              fontSize: 17.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                              vertical: 16.0,
                            ),
                            child: Divider(
                              thickness: 0.8,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          const SizedBox(
                            height: 12.0,
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.email_outlined,
                              ),
                              const SizedBox(
                                width: 10.0,
                              ),
                              Expanded(
                                child: Text(
                                  '${sellerProfile?.email}',
                                  style: TextStyle(
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.bold,
                                    color: ThemeCubit.get(context).isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 25.0,
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.phone,
                              ),
                              const SizedBox(
                                width: 10.0,
                              ),
                              Text(
                                '${sellerProfile?.phone}',
                                style: TextStyle(
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.bold,
                                  color: ThemeCubit.get(context).isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 25.0,
                          ),
                          Row(
                            children: [
                              const Icon(
                                EvaIcons.pinOutline,
                              ),
                              const SizedBox(
                                width: 12.0,
                              ),
                              Expanded(
                                child: Text(
                                  '${sellerProfile?.address}',
                                  style: TextStyle(
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.bold,
                                    color: ThemeCubit.get(context).isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                fallback: (context) => Center(child: CircularLoading(os: getOs())),

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
            );
          },
        );

      },
    );
  }
}
