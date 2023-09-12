import 'dart:io';
import 'dart:ui' as ui;
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:trade_market_app/data/models/productModel/ProductModel.dart';
import 'package:trade_market_app/presentation/modules/homeModule/ProductDetailsScreen.dart';
import 'package:trade_market_app/presentation/modules/startUpModule/loginScreen/LoginScreen.dart';
import 'package:trade_market_app/shared/adaptive/anotherCircularLoading/AnotherCircularLoading.dart';
import 'package:trade_market_app/shared/adaptive/circularLoading/CircularLoading.dart';
import 'package:trade_market_app/shared/components/Constants.dart';
import 'package:trade_market_app/shared/cubit/appCubit/AppCubit.dart';
import 'package:trade_market_app/shared/cubit/checkCubit/CheckCubit.dart';
import 'package:trade_market_app/shared/cubit/registerCubit/RegisterCubit.dart';
import 'package:trade_market_app/shared/cubit/themeCubit/ThemeCubit.dart';
import 'package:trade_market_app/shared/network/local/CacheHelper.dart';
import 'package:trade_market_app/shared/styles/Styles.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';


Widget logo(context) => Stack(
  alignment: Alignment.bottomCenter,
  children: [
    Text(
      'TradeMarket',
      style: TextStyle(
        fontSize: 35.0,
        letterSpacing: 0.8,
        color: Theme.of(context).colorScheme.primary,
        fontFamily: 'Kufi',
      ),
    ),
    Container(
      width: 80.0,
      height: 3.5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.0),
        color: Theme.of(context).colorScheme.primary,
      ),
    ),
  ],
);



dynamic quickAlert({
  required BuildContext context,
  required String title,
  required QuickAlertType type,
  required String text,
  required String btnText,
  required Function onTap,
}) => QuickAlert.show(
  context: context,
  type: type,
  title: title,
  text: text,
  titleColor: ThemeCubit.get(context).isDark ? Colors.white : Colors.black,
  textColor: ThemeCubit.get(context).isDark ? Colors.white : Colors.black,
  confirmBtnText: btnText,
  onConfirmBtnTap: () => onTap(),
  confirmBtnColor: Theme.of(context).colorScheme.primary,
  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
  barrierDismissible: false,
);


navigateTo({required BuildContext context , required Widget screen}) =>
  Navigator.push(context, MaterialPageRoute(builder: (context) => screen));



navigateAndNotReturn({required BuildContext context, required Widget screen}) =>
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => screen), (route) => false);



Route createRoute({required screen}) {
  return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeIn;

        var tween =
        Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      });
}



Route createSecondRoute({required screen}) {
  return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeIn;

        var tween =
        Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      });
}



Widget defaultFormField({
  required String label,
  required TextEditingController controller,
  required TextInputType type,
  required FocusNode focusNode,
  required String? Function(String?) ? validate,
  bool isPassword = false,
  IconData? prefixIcon,
  IconData? suffixIcon,
  Function? onPress,
  String? Function(String?) ? onSubmit,
  bool? isAuth,
  required BuildContext context,

}) => TextFormField(
  controller: controller,
  keyboardType: type,
  focusNode: focusNode,
  obscureText: isPassword,
  style: const TextStyle(
    fontWeight: FontWeight.bold,
  ),
  decoration: InputDecoration(
    labelText: label,
    errorMaxLines: 3,
    fillColor: ThemeCubit.get(context).isDark ? firstDarkColor : Colors.blueGrey.shade100.withOpacity(.1),
    filled: (isAuth == true) ? true : null,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: const BorderSide(
        width: 2.0,
      ),
    ),
    prefixIcon: (prefixIcon != null) ? Icon(prefixIcon) : null,
    suffixIcon: (suffixIcon != null) ? ((controller.text.isNotEmpty) ? IconButton(
        onPressed: () => onPress!(),
        icon: Icon(suffixIcon),
    ) : null ): null,
  ),
  validator: validate,
  onFieldSubmitted: (value) {
    if(value.isNotEmpty) {
      onSubmit!(value);
    }
  },
);



Widget defaultSearchFormField({
  required String label,
  required TextEditingController controller,
  required TextInputType type,
  required FocusNode focusNode,
  required String? Function(String) ? onChange,
  Function? onPress,
  String? Function(String?) ? onSubmit,

}) => TextFormField(
  controller: controller,
  keyboardType: TextInputType.text,
  style: const TextStyle(
    fontWeight: FontWeight.bold,
  ),
  decoration: InputDecoration(
    label: const Text(
      'Type ...',
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: const BorderSide(
        width: 2.0,
      ),
    ),
    prefixIcon: const Icon(
      EvaIcons.searchOutline,
    ),
    suffixIcon: (controller.text.isNotEmpty) ? IconButton(
      onPressed: () {
        onPress!();
      },
      icon: const Icon(
        Icons.close_rounded,
      ),
    ) : null,
  ),
  onChanged: onChange,
  onFieldSubmitted: (value) {
    if(value.isNotEmpty) {
      onSubmit!(value);
    }
  },
);



Widget defaultDropDownFormField({
  required String? firstItem,
  required String label,
  required List<String> items,
  // required IconData icon,
  required String ? Function(String ?) validator,
  required String ? Function(String ?) onChange,
}) => DropdownButtonFormField(
    value: firstItem,
    validator: validator,
    decoration: InputDecoration(
      label: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(
          width: 2.0,
        ),
      ),
      // prefixIcon: Icon(icon,),
    ),
    items: items.map((value) {
      return DropdownMenuItem(
        value: value,
        child: Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }).toList(),
    onChanged: onChange,
    );


Widget defaultButton({
  double width = double.infinity,
  double height = 48.0,
  required String text,
  required Function onPress,
  required BuildContext context,
}) => SizedBox(
  width: width,
  child: MaterialButton(
    height: height,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    color: Theme.of(context).colorScheme.primary,
    onPressed: () {
      onPress();
    },
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 18.0,
        color: Colors.white,
        letterSpacing: 0.5,
        fontWeight: FontWeight.bold,
      ),
    ),

  ),
);


Widget defaultSecondButton({
  double height = 48.0,
  required String text,
  required Function onPress,
  required BuildContext context,
}) => SizedBox(
  width: 200.0,
  child: MaterialButton(
    height: height,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    color: Theme.of(context).colorScheme.primary,
    onPressed: () {
      onPress();
    },
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 18.0,
        color: Colors.white,
        letterSpacing: 0.5,
        fontWeight: FontWeight.bold,
      ),
    ),

  ),
);

Widget defaultTextButton({
  required String text,
  required Function onPress,
}) => TextButton(
  onPressed: () {
    onPress();
  },
  child: Text(
    text,
    style: const TextStyle(
      fontSize: 16.5,
      fontWeight: FontWeight.bold,
    ),
  ),
);



Widget defaultIcon({
  double radius = 8.0,
  double padding = 8.0,
  required double size,
  required IconData icon,
  required Function onPress,
  required BuildContext context,
}) =>  Material(
  color: ThemeCubit.get(context).isDark ? Colors.grey.shade800.withOpacity(.6) :Colors.blueGrey.shade100.withOpacity(.4),
  borderRadius: BorderRadius.circular(radius),
  child: InkWell(
    onTap: () => onPress(),
    borderRadius: BorderRadius.circular(radius),
    child: Padding(
      padding: EdgeInsets.all(padding),
      child: Icon(icon,
       size: size,
       color: ThemeCubit.get(context).isDark ? Colors.white : Colors.black,
      ),
    ),
  ),
);


defaultAppBar({
  required Function onPress,
  String? title,
  List<Widget>? actions,
}) => AppBar(
 leading: IconButton(
    onPressed: () {
      onPress();
    },
     icon: const Icon(
       Icons.arrow_back_ios_new_rounded,
     ),
   tooltip: 'Back',
 ),
  titleSpacing: 5.0,
  title: Text(
     title ?? '',
  ),
  actions: actions,
);



enum ToastStates {success , warning , error}

void showFlutterToast({
  required String message,
  required ToastStates state,
  required BuildContext context,
}) =>
    showToast(
      message,
      context: context,
      backgroundColor: chooseToastColor(s: state),
      animation: StyledToastAnimation.scale,
      reverseAnimation: StyledToastAnimation.fade,
      position: StyledToastPosition.bottom,
      animDuration: const Duration(milliseconds: 1500),
      duration: const Duration(seconds: 3),
      curve: Curves.elasticInOut,
      reverseCurve: Curves.linear,
    );


Color chooseToastColor({
  required ToastStates s,
}) {

  return switch(s) {

    ToastStates.success => greenColor,
    ToastStates.warning => Colors.amber.shade900,
    ToastStates.error => Colors.red,

  };

}



dynamic showLoading(context) => showDialog(
  barrierDismissible: false,
  context: context,
  builder: (BuildContext context) {

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Center(
        child: Container(
            padding: const EdgeInsets.all(26.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18.0),
              color: ThemeCubit.get(context).isDark ? HexColor('202020') : Colors.white,
            ),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: CircularLoading(os: getOs())),
      ),
    );
  },
);


void removeAccount(context) {
  CacheHelper.removeData(key: 'uId').then((value) {
    if(value == true) {
      RegisterCubit.get(context).deleteAccount();
    }
  });
}

dynamic showAlertVerification(BuildContext context) {
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              14.0,
            ),
          ),
          title: Text(
            'Time is up!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: redColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Your email is not verified.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 17.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                navigateAndNotReturn(
                    context: context, screen: const LoginScreen());
              },
              child: const Text(
                'Ok',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}


dynamic showAlertExit(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.0,),
        ),
        title: const Text(
          'Do you want to exit ?',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
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
              SystemNavigator.pop();
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


dynamic showAlertCheckConnection(BuildContext context , {bool isSplashScreen = false}) {
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.0,),
          ),
          title: const Text(
            'No Internet Connection',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          content:  const Text(
            'You are currently offline!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 17.0,
              // fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            if(!isSplashScreen)
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Wait',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                SystemNavigator.pop();
              },
              child: Text(
                'Exit',
                style: TextStyle(
                  color: redColor,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}


dynamic showFullImage(image , String tag , context , {XFile? imageFile}) {

  return navigateTo(context: context, screen: Scaffold(
    appBar: defaultAppBar(
        onPress: () {
          Navigator.pop(context);
        },),
    body: Center(
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Hero(
          tag: tag,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(),
            child: (imageFile != null) ? Image.file(
                File(imageFile.path),
                fit: BoxFit.fitWidth,
              frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                if(frame == null) {
                  return SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Center(child: CircularLoading(os: getOs(),)),
                  );
                }
                return child;
              },
            ) : Image.network('$image',
              fit: BoxFit.fitWidth,
              frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                if(frame == null) {
                  return SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
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
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: Center(child: CircularLoading(os: getOs(),)));
                }
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    decoration: const BoxDecoration(),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Image.asset('assets/images/mark.jpg'));
              },
            ),
  ),
        ),
      ),
    ),),
  );

}



Future<void> saveImage(GlobalKey globalKey , context) async {

  double devicePixelRatio = MediaQuery.of(context).devicePixelRatio;

  await Future.delayed(const Duration(milliseconds: 300)).then((value) async {

    RenderRepaintBoundary boundary = globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary;

    ui.Image? image = await boundary.toImage(pixelRatio: devicePixelRatio);

    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    Uint8List? imageBytes = byteData?.buffer.asUint8List();

    ImageGallerySaver.saveImage(imageBytes!);


  });



}


dynamic showFullImageAndSave(globalKey , image , String tag , context , {File? imageFile , bool? isMyPhotos}) {

  return navigateTo(context: context, screen: Scaffold(
    appBar: defaultAppBar(
        onPress: () {
          Navigator.pop(context);
        },
      actions: [
        (isMyPhotos == false) ? IconButton(
            onPressed: () async {
              await saveImage(globalKey, context).then((value) {
                showFlutterToast(message: 'The image has been saved to your gallery', state: ToastStates.success, context: context);
                Navigator.pop(context);
              }).catchError((error) {
                showFlutterToast(message: error.toString(),state: ToastStates.error, context: context);
                });
            },
            icon: Icon(
              EvaIcons.downloadOutline,
              color: Theme.of(context).colorScheme.primary,
            ),
        ) :
         PopupMenuButton(
             itemBuilder: (context) {
                return [
                 PopupMenuItem(
                   value: 'save',
                     child: Row(
                       children: [
                         Icon(
                           EvaIcons.downloadOutline,
                           color: Theme.of(context).colorScheme.primary,
                         ),
                         const SizedBox(
                           width: 6.0,
                         ),
                         const Text(
                           'Save',
                         ),
                       ],
                     ),
                 ),
                 PopupMenuItem(
                   value: 'remove',
                     child: Row(
                       children: [
                         Icon(
                           Icons.close_rounded,
                           color: redColor,
                         ),
                         const SizedBox(
                           width: 6.0,
                         ),
                         const Text(
                           'Remove',
                         ),
                       ],
                     ),
                 ),
                ];
             },
           onSelected: (value) async {
             if(value == 'save') {
               await saveImage(globalKey , context).then((value) {
                 Navigator.pop(context);
                 showFlutterToast(message: 'The image has been saved to your gallery', state: ToastStates.success, context: context);
               }).catchError((error) {
                 showFlutterToast(message: '$error', state: ToastStates.error, context: context);
               });
             } else if( value == 'remove') {
               AppCubit.get(context).removeImageProfileUploaded(image: image, context: context);
               Navigator.pop(context);
             }
           },
         ),

      ],
    ),
    body: Center(
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: RepaintBoundary(
          key: globalKey,
          child: Hero(
            tag: tag,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(),
              child: (imageFile != null) ?  Image.file(
                  File(imageFile.path),
                  fit: BoxFit.fitWidth,
                frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                  if(frame == null) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: Center(child: CircularLoading(os: getOs(),)),
                    );
                  }
                  return child;
                },
              ) : Image.network('$image',
                fit: BoxFit.fitWidth,
                frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                  if(frame == null) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
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
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: Center(child: CircularLoading(os: getOs(),)));
                  }
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      decoration: const BoxDecoration(),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Image.asset('assets/images/mark.jpg'));
                },
            ),
  ),
          ),
        ),
      ),
    ),),
  );

}



Widget buildItemCategoryProduct(ProductModel? model , productId , numberFavorites , context) => GestureDetector(
  onTap: () {
    if(CheckCubit.get(context).hasInternet) {
      Navigator.of(context).push(createRoute(screen: ProductDetailsScreen(
        productDetails: model! ,
        productId: productId,
        numberFavorites: numberFavorites[productId] ?? 0,)));
    } else {
      showFlutterToast(message: 'No Internet Connection', state: ToastStates.error, context: context);
    }
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
            fit: BoxFit.cover,
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
                    fit: BoxFit.cover,
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
                        '${numberFavorites[productId]}',
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











