import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:trade_market_app/shared/adaptive/circularLoading/CircularLoading.dart';
import 'package:trade_market_app/shared/components/Components.dart';
import 'package:trade_market_app/shared/components/Constants.dart';
import 'package:trade_market_app/shared/cubit/appCubit/AppCubit.dart';
import 'package:trade_market_app/shared/cubit/appCubit/AppStates.dart';
import 'package:trade_market_app/shared/cubit/checkCubit/CheckCubit.dart';
import 'package:trade_market_app/shared/cubit/checkCubit/CheckStates.dart';
import 'package:trade_market_app/shared/cubit/themeCubit/ThemeCubit.dart';

class MyPhotosScreen extends StatefulWidget {
  const MyPhotosScreen({super.key});

  @override
  State<MyPhotosScreen> createState() => _MyPhotosScreenState();
}

class _MyPhotosScreenState extends State<MyPhotosScreen> {

  GlobalKey globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        if(CheckCubit.get(context).hasInternet) {
          AppCubit.get(context).getAllImagesProfile();
        }
        return BlocConsumer<CheckCubit , CheckStates>(
          listener: (context , state) {},
          builder: (context , state) {

            var checkCubit = CheckCubit.get(context);

            return BlocConsumer<AppCubit , AppStates>(
              listener: (context , state) {

                if(state is SuccessDeleteImageProfileUploadedAppState) {

                  showFlutterToast(message: 'Deleted Successfully', state: ToastStates.success, context: context);
                  AppCubit.get(context).getAllImagesProfile();

                }

                if(state is ErrorDeleteImageProfileUploadedAppState) {

                  showFlutterToast(message: '${state.error}', state: ToastStates.error, context: context);

                }

              },
              builder: (context , state) {

                var cubit = AppCubit.get(context);
                var allImagesProfile = cubit.allImagesProfile;

                return WillPopScope(
                  onWillPop: () async {
                    cubit.clearAllImagesProfile();
                    return true;
                  },
                  child: Scaffold(
                    appBar: defaultAppBar(
                      onPress: () {
                        Navigator.pop(context);
                        cubit.clearAllImagesProfile();
                      },
                      title: 'My Photos',
                    ),
                    body: (checkCubit.hasInternet) ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ConditionalBuilder(
                        condition: allImagesProfile.isNotEmpty,
                        builder: (context) => MasonryGridView.count(
                          physics: const BouncingScrollPhysics(),
                          crossAxisCount: 3,
                          mainAxisSpacing: 10.0,
                          crossAxisSpacing: 10.0,
                          itemBuilder: (context , index) => buildItemMyPhoto(allImagesProfile[index] , index , context),
                          itemCount: allImagesProfile.length,
                        ),
                        fallback: (context) => (state is LoadingGetAllImagesProfileAppState) ? Center(child: CircularLoading(os: getOs())) :
                         const Center(
                           child: Text(
                             'There is no images uploaded \nin your profile',
                             textAlign: TextAlign.center,
                             style: TextStyle(
                               fontSize: 17.0,
                               fontWeight: FontWeight.bold,
                             ),
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
                );
              },
            );
          },
        );
      }
    );
  }

  Widget buildItemMyPhoto(image , index , context) => GestureDetector(
    onTap: () {
      showFullImageAndSave(globalKey , image, index.toString(), context , isMyPhotos: true);
    },
    child: Hero(
      tag: index.toString(),
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(
              width: 0.0,
              color: ThemeCubit.get(context).isDark ? Colors.white : Colors.black,
            ),
          ),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Image.network('$image',
           width: 120.0,
            height: 120.0,
            fit: BoxFit.cover,
            frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
              if(frame == null) {
                return SizedBox(
                  width: 120.0,
                  height: 120.0,
                  child: Center(child: CircularLoading(os: getOs(),)),
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
                    child: Center(child: CircularLoading(os: getOs(),)));
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
                  child: Image.asset('assets/images/mark.jpg',
                  fit: BoxFit.cover,
                  ));
            },
          )),
    ),
  );
}
