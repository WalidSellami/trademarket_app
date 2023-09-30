import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:trade_market_app/data/models/productModel/ProductModel.dart';
import 'package:trade_market_app/presentation/modules/homeModule/EditProductDetailsScreen.dart';
import 'package:trade_market_app/presentation/modules/homeModule/SellerProfileScreen.dart';
import 'package:trade_market_app/presentation/modules/homeModule/chat/UserChatScreen.dart';
import 'package:trade_market_app/shared/adaptive/anotherCircularLoading/AnotherCircularLoading.dart';
import 'package:trade_market_app/shared/components/Components.dart';
import 'package:trade_market_app/shared/components/Constants.dart';
import 'package:trade_market_app/shared/cubit/appCubit/AppCubit.dart';
import 'package:trade_market_app/shared/cubit/appCubit/AppStates.dart';
import 'package:trade_market_app/shared/cubit/checkCubit/CheckCubit.dart';
import 'package:trade_market_app/shared/cubit/checkCubit/CheckStates.dart';
import 'package:trade_market_app/shared/cubit/themeCubit/ThemeCubit.dart';
import 'package:trade_market_app/shared/styles/Styles.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductModel productDetails;
  final int numberFavorites;
  final String productId;

  const ProductDetailsScreen({super.key, required this.productDetails , required this.productId , required this.numberFavorites});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final PageController controller = PageController();

  final GlobalKey globalKey = GlobalKey();


  @override
  void initState() {
    AppCubit.get(context).getSellerProfile(userId: widget.productDetails.uIdVendor.toString());
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CheckCubit , CheckStates>(
      listener: (context , state) {},
      builder: (context , state) {

        var checkCubit = CheckCubit.get(context);

        return BlocConsumer<AppCubit, AppStates>(
          listener: (context, state) {

            var cubit = AppCubit.get(context);


            if(state is SuccessDeleteProductAppState) {

              showFlutterToast(message: 'Done with success', state: ToastStates.success, context: context);
              Navigator.pop(context);
              Navigator.pop(context);
            }

            if(state is ErrorDeleteProductAppState) {

              showFlutterToast(message: state.error.toString(), state: ToastStates.error, context: context);
              Navigator.pop(context);

            }

            if(state is SuccessAddChatAppState) {

              Navigator.pop(context);
              showFlutterToast(message: 'New chat added in your chats', state: ToastStates.success, context: context);
              Navigator.of(context).push(createSecondRoute(screen: UserChatScreen(
                  receiverId: widget.productDetails.uIdVendor.toString(),
                  fullName: widget.productDetails.vendorName.toString())));
             cubit.sendNotification(
                  title: 'New Chat',
                  body: 'You have a new chat with ${cubit.userProfile?.fullName}',
                  deviceToken: cubit.sellerProfile!.deviceToken.toString());
            }

            if(state is ErrorAddChatAppState) {

              showFlutterToast(message: state.error.toString(), state: ToastStates.error, context: context);
              Navigator.pop(context);
            }

          },
          builder: (context, index) {

            return Scaffold(
              appBar: defaultAppBar(
                onPress: () {
                  Navigator.pop(context);
                },
                title: '${widget.productDetails.title}',
              ),
              body: (checkCubit.hasInternet) ? SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10.0,
                    ),
                    SizedBox(
                      height: 300.0,
                      child: PageView.builder(
                        controller: controller,
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) => Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            buildItemPageView(globalKey, widget.productDetails.images?[index], index),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Container(
                                padding: const EdgeInsets.all(6.0),
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade800.withOpacity(.7),
                                    borderRadius: BorderRadius.circular(
                                      8.0,
                                    )),
                                child: SmoothPageIndicator(
                                  controller: controller,
                                  effect: ExpandingDotsEffect(
                                    dotColor: Colors.grey.shade400,
                                    activeDotColor:
                                    Theme.of(context).colorScheme.primary,
                                    dotWidth: 10,
                                    spacing: 5.0,
                                    expansionFactor: 2.0,
                                    dotHeight: 10,
                                  ),
                                  count: widget.productDetails.images?.length ?? 0,
                                ),
                              ),
                            ),
                          ],
                        ),
                        itemCount: widget.productDetails.images?.length ?? 0,
                      ),
                    ),
                    buildProductDetails(),
                  ],
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
            );
          },
        );

      },
    );
  }

  Widget buildItemPageView(globalKey, image, index) => GestureDetector(
        onTap: () {
          showFullImageAndSave(globalKey, image, index.toString(), context , isMyPhotos: false);
        },
        child: Hero(
          tag: index.toString(),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              border: Border.all(
                strokeAlign: BorderSide.strokeAlignOutside,
                width: 0.0,
                color: ThemeCubit.get(context).isDark
                    ? Colors.white
                    : Colors.black,
              ),
            ),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Image.network(
              image,
              width: MediaQuery.of(context).size.width / 1.05,
              fit: BoxFit.fitWidth,
              frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                if(frame == null) {
                  return SizedBox(
                    width: MediaQuery.of(context).size.width / 1.05,
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
                      width: MediaQuery.of(context).size.width / 1.05,
                      child: Center(child: AnotherCircularLoading(os: getOs(),)));
                }
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                    width: MediaQuery.of(context).size.width / 1.05,
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
        ),
      );

  Widget buildProductDetails() => Padding(
    padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 14.0
    ),
    child: Column(
      children: [
        Text(
          '${widget.productDetails.title}',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 17.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 40.0,
            vertical: 12.0,
          ),
          child: Divider(
            thickness: 0.6,
            color: Colors.grey,
          ),
        ),
        Text(
          '${widget.productDetails.price} DA',
          style: const TextStyle(
            fontSize: 17.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 40.0,
            vertical: 12.0,
          ),
          child: Divider(
            thickness: 0.6,
            color: Colors.grey,
          ),
        ),
        const SizedBox(
          height: 16.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
          ),
          child: Row(
            children: [
              const Icon(
                Icons.category_outlined,
              ),
              const SizedBox(
                width: 6.0,
              ),
              Text(
                '${widget.productDetails.category}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 16.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
          ),
          child: Row(
            children: [
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 20.0,
              ),
              const SizedBox(
                width: 6.0,
              ),
              Text(
                '${widget.productDetails.condition}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 16.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
          ),
          child: Row(
            children: [
              const Icon(
                  EvaIcons.pinOutline
              ),
              const SizedBox(
                width: 6.0,
              ),
              Text(
                '${widget.productDetails.address}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Divider(
            thickness: 0.8,
            color: Colors.grey.shade500,
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        const Align(
          alignment: Alignment.topLeft,
          child: Text(
            'Description : ',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(
          height: 12.0,
        ),
        Text(
          '${widget.productDetails.description}',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16.0,
          ),
        ),
        const SizedBox(
          height: 25.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(
                  Icons.star_rounded,
                  color: Colors.amber.shade800,
                ),
                const SizedBox(
                  width: 3.0,
                ),
                Text(
                  '${widget.numberFavorites}',
                  style: const TextStyle(),
                ),
              ],
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 12.0,
          ),
          child: Divider(
            thickness: 0.8,
            color: Colors.grey.shade500,
          ),
        ),
        if(widget.productDetails.uIdVendor != uId)
        Row(
          children: [
            Expanded(
              child: InkWell(
                borderRadius: BorderRadius.circular(6.0),
                onTap: () {
                  // AppCubit.get(context).getSellerProfile(userId: widget.productDetails.uIdVendor.toString());
                  Navigator.of(context).push(createRoute(screen: const SellerProfileScreen()));
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 22.0,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        backgroundImage: NetworkImage('${widget.productDetails.imageProfileVendor}'),
                      ),
                      const SizedBox(
                        width: 12.0,
                      ),
                      Text(
                        '${widget.productDetails.vendorName}',
                        style: const TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 8.0,
            ),
            Tooltip(
              enableFeedback: true,
              message: 'Chat',
              child: Material(
                color: ThemeCubit.get(context).isDark ? Colors.grey.shade800.withOpacity(.7) : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(14.0),
                child: InkWell(
                  borderRadius: BorderRadius.circular(14.0),
                  onTap: () {
                     AppCubit.get(context).addChat(
                         fullName: widget.productDetails.vendorName.toString(),
                         imageProfile: widget.productDetails.imageProfileVendor.toString(),
                         id: widget.productDetails.uIdVendor.toString(),
                         context: context,
                     );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Icon(
                      EvaIcons.messageCircleOutline,
                      size: 28.0,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        if(widget.productDetails.uIdVendor == uId)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Tooltip(
                enableFeedback: true,
                message: 'Edit',
                child: Material(
                  color: Theme.of(context).colorScheme.primary,
                  elevation: 2.0,
                  borderRadius: BorderRadius.circular(14.0),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14.0),
                    onTap: () {
                       navigateTo(context: context, screen: EditProductDetailsScreen(productModel: widget.productDetails ,productId: widget.productId,));
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(14.0),
                      child: Icon(
                        EvaIcons.editOutline,
                        size: 28.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              Tooltip(
                enableFeedback: true,
                message: 'Remove',
                child: Material(
                  color: redColor,
                  elevation: 2.0,
                  borderRadius: BorderRadius.circular(14.0),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14.0),
                    onTap: () {
                      AppCubit.get(context).getUserFavorites(productId: widget.productId);
                      showAlertRemove(context, widget.productId, widget.productDetails.images);
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(14.0),
                      child: Icon(
                        Icons.close_rounded,
                        size: 28.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        const SizedBox(
          height: 10.0,
        ),
      ],
    ),
  );


  dynamic showAlertRemove(BuildContext context , productId , imagesUrl) {
    return showDialog(
      context: context,
      builder: (dialogContext) {
        HapticFeedback.vibrate();
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0,),
          ),
          title: const Text(
            'Do you want to remove this product ?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text(
                'No',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                showLoading(context);
                AppCubit.get(context).deleteProduct(
                    productId: productId,
                    imagesUrl: imagesUrl);
              },
              child: Text(
                'Yes',
                style: TextStyle(
                  color: redColor,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }



}
