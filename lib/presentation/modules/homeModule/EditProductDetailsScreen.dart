import 'dart:io';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trade_market_app/data/models/productModel/ProductModel.dart';
import 'package:trade_market_app/shared/adaptive/anotherCircularLoading/AnotherCircularLoading.dart';
import 'package:trade_market_app/shared/adaptive/circularLoading/CircularLoading.dart';
import 'package:trade_market_app/shared/components/Components.dart';
import 'package:trade_market_app/shared/components/Constants.dart';
import 'package:trade_market_app/shared/cubit/appCubit/AppCubit.dart';
import 'package:trade_market_app/shared/cubit/appCubit/AppStates.dart';
import 'package:trade_market_app/shared/cubit/checkCubit/CheckCubit.dart';
import 'package:trade_market_app/shared/cubit/checkCubit/CheckStates.dart';
import 'package:trade_market_app/shared/cubit/themeCubit/ThemeCubit.dart';

class EditProductDetailsScreen extends StatefulWidget {

  final ProductModel productModel;
  final String productId;

  const EditProductDetailsScreen({super.key , required this.productModel , required this.productId});

  @override
  State<EditProductDetailsScreen> createState() => _EditProductDetailsScreenState();
}

class _EditProductDetailsScreenState extends State<EditProductDetailsScreen> {

  var titleController = TextEditingController();
  var priceController = TextEditingController();
  var addressController = TextEditingController();
  var descriptionController = TextEditingController();


  final FocusNode focusNode1 = FocusNode();
  final FocusNode focusNode2 = FocusNode();
  final FocusNode focusNode3 = FocusNode();
  final FocusNode focusNode4 = FocusNode();


  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final ScrollController scrollController = ScrollController();


  final ScrollController controller = ScrollController();

  void scrollToBottom() {
    if(scrollController.hasClients) {
      scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeIn);
    }
  }

  @override
  void initState() {
    super.initState();
    titleController.text = widget.productModel.title.toString();
    priceController.text = widget.productModel.price.toString();
    addressController.text = widget.productModel.address.toString();
    descriptionController.text = widget.productModel.description.toString();
    AppCubit.get(context).firstCategoryItem = widget.productModel.category;
    AppCubit.get(context).firstConditionItem = widget.productModel.condition;
  }


  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CheckCubit , CheckStates>(
      listener: (context , state) {},
      builder: (context , state) {

        var checkCubit = CheckCubit.get(context);

        return BlocConsumer<AppCubit , AppStates>(
          listener: (context , state) {


            if(state is SuccessUpdateProductDetailsAppState) {

              showFlutterToast(message: 'Done with success', state: ToastStates.success, context: context);
              Navigator.pop(context);
              Navigator.pop(context);
              AppCubit.get(context).clear();
              if(AppCubit.get(context).images.isNotEmpty) {
                Navigator.pop(context);
              }

            }

            if(state is SuccessGetImagesAppState) {
              WidgetsBinding.instance.addPostFrameCallback((_) => scrollToBottom());
            }

          },
          builder: (context , state) {

            var cubit = AppCubit.get(context);

            return Scaffold(
                appBar: defaultAppBar(
                  onPress: () {
                    Navigator.pop(context);
                  },
                  title: 'Edit ${widget.productModel.title}',
                ),
                body: SingleChildScrollView(
                  controller: scrollController,
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10.0,
                              vertical: 8.0,
                            ),
                            child: Column(
                              children: [
                                defaultFormField(
                                    label: 'Title',
                                    controller: titleController,
                                    type: TextInputType.text,
                                    focusNode: focusNode1,
                                    validate: (value) {
                                      if(value == null || value.isEmpty) {
                                        return 'Title must not be empty';
                                      }
                                      return null;
                                    }),
                                const SizedBox(
                                  height: 25.0,
                                ),
                                defaultFormField(
                                    label: 'Price',
                                    controller: priceController,
                                    type: TextInputType.number,
                                    focusNode: focusNode2,
                                    validate: (value) {
                                      if(value == null || value.isEmpty) {
                                        return 'Price must not be empty';
                                      }
                                      if(value.contains(',.-_')) {
                                        return 'Enter a positive integer number';
                                      }
                                      return null;
                                    }),
                                const SizedBox(
                                  height: 25.0,
                                ),
                                defaultDropDownFormField(
                                    firstItem: cubit.firstCategoryItem,
                                    label: 'Category',
                                    items: cubit.categories,
                                    validator: (value) {
                                      if(value == null || value.isEmpty) {
                                        return 'You must select category';
                                      }
                                      return null;
                                    },
                                    onChange: (value) {
                                      cubit.changeCategoryItem(value);
                                      return null;
                                    }),
                                const SizedBox(
                                  height: 25.0,
                                ),
                                defaultDropDownFormField(
                                    firstItem: cubit.firstConditionItem,
                                    label: 'Condition',
                                    items: cubit.conditions,
                                    validator: (value) {
                                      if(value == null || value.isEmpty) {
                                        return 'You must select condition';
                                      }
                                      return null;
                                    },
                                    onChange: (value) {
                                      cubit.changeConditionItem(value);
                                      return null;
                                    }),
                                const SizedBox(
                                  height: 25.0,
                                ),
                                defaultFormField(
                                    label: 'Address',
                                    controller: addressController,
                                    type: TextInputType.streetAddress,
                                    focusNode: focusNode3,
                                    validate: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Address must not be empty';
                                      }
                                      bool validAddress =
                                      RegExp(r'^(?=.*[a-zA-Z])[a-zA-Z0-9\s_.]+$')
                                          .hasMatch(value);
                                      if (!validAddress) {
                                        return 'Enter a valid address --> (without (,-) and without only numbers).';
                                      }
                                      return null;
                                    }),
                                const SizedBox(
                                  height: 25.0,
                                ),
                                TextFormField(
                                  controller: descriptionController,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  focusNode: focusNode4,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  decoration: InputDecoration(
                                    label: const Text(
                                        'Description'
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: const BorderSide(
                                        width: 2.0,
                                      ),
                                    ),
                                  ),
                                  validator: (value) {
                                    if(value == null || value.isEmpty) {
                                      return 'Description must not be empty';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          SizedBox(
                            height: 300.0,
                            child: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: SizedBox(
                                    height: 250.0,
                                    child: ListView.separated(
                                      controller: controller,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context , index) => buildItemImageProduct(widget.productModel.images?[index], index, context),
                                      separatorBuilder: (context , index) => const SizedBox(
                                        width: 12.0,
                                      ),
                                      itemCount: widget.productModel.images?.length ?? 0,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    right: 6.0,
                                  ),
                                  child: Text(
                                    '${widget.productModel.images?.length}/3',
                                    style: const TextStyle(
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          if(cubit.images.isNotEmpty)
                            Column(
                            children: [
                              SizedBox(
                                height: 20.0,
                                child: VerticalDivider(
                                  thickness: 1.0,
                                  color: ThemeCubit.get(context).isDark ? Colors.white : Colors.black,
                                ),
                              ),
                              Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: ThemeCubit.get(context).isDark ? Colors.white : Colors.black,
                              ),
                            ],
                          ),
                          if(cubit.images.isNotEmpty)
                            SizedBox(
                              height: 250.0,
                              child: Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: SizedBox(
                                      height: 200.0,
                                      child: ListView.separated(
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context , index) => buildItemImageUpload(cubit.images[index], index, context),
                                        separatorBuilder: (context , index) => const SizedBox(
                                          width: 12.0,
                                        ),
                                        itemCount: cubit.images.length,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      right: 6.0,
                                    ),
                                    child: Text(
                                      '${cubit.images.length}/3',
                                      style: const TextStyle(
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if(cubit.images.isNotEmpty)
                            const SizedBox(
                              height: 35.0,
                            ),
                          if(cubit.images.length < 3)
                            SizedBox(
                              width: 200.0,
                              child: OutlinedButton(
                                style: ButtonStyle(
                                  side: MaterialStatePropertyAll(
                                    BorderSide(
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                  shape: MaterialStatePropertyAll(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0,),
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  focusNode1.unfocus();
                                  focusNode2.unfocus();
                                  focusNode3.unfocus();
                                  showModalBottomSheet(context: context,
                                    builder: (context) {
                                      return SafeArea(
                                        child: Material(
                                          color: ThemeCubit.get(context).isDark
                                              ? HexColor('161616')
                                              : Colors.white,
                                          child: Wrap(
                                            children: <Widget>[
                                              ListTile(
                                                leading: const Icon(
                                                    Icons.camera_alt_rounded),
                                                title: const Text(
                                                    'Take a new photo'),
                                                onTap: () async {
                                                  cubit.getImages(ImageSource.camera, context);
                                                  Navigator.pop(
                                                      context);
                                                },
                                              ),
                                              ListTile(
                                                leading: const Icon(
                                                    Icons.photo_library_rounded),
                                                title: const Text(
                                                    'Choose from gallery'),
                                                onTap: () async {
                                                  cubit.getImages(ImageSource.gallery, context);
                                                  Navigator.pop(
                                                      context);
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      EvaIcons.imageOutline,
                                    ),
                                    SizedBox(
                                      width: 6.0,
                                    ),
                                    Text(
                                      'Update Image',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          const SizedBox(
                            height: 30.0,
                          ),
                          // if(cubit.images.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0,
                                  vertical: 10.0
                              ),
                              child: ConditionalBuilder(
                                condition: state is! LoadingUpdateProductDetailsAppState,
                                builder: (context) => defaultButton(
                                  text: 'Update'.toUpperCase(),
                                  onPress: () async {
                                    focusNode1.unfocus();
                                    focusNode2.unfocus();
                                    focusNode3.unfocus();
                                    if(checkCubit.hasInternet) {
                                      if(formKey.currentState!.validate()) {

                                        if(cubit.images.isEmpty) {

                                          cubit.updateProductDetails(
                                              title: titleController.text,
                                              price: priceController.text,
                                              category: cubit.firstCategoryItem.toString(),
                                              condition: cubit.firstConditionItem.toString(),
                                              address: addressController.text,
                                              description: descriptionController.text,
                                              productId: widget.productId,
                                              context: context,
                                          );

                                        } else {

                                          await cubit.updateProductImages(
                                              productId: widget.productId,
                                              context: context).then((value) {
                                            cubit.updateProductDetails(
                                              title: titleController.text,
                                              price: priceController.text,
                                              category: cubit.firstCategoryItem
                                                  .toString(),
                                              condition: cubit
                                                  .firstConditionItem
                                                  .toString(),
                                              address: addressController.text,
                                              description: descriptionController
                                                  .text,
                                              productId: widget.productId,
                                              context: context,
                                              imagesUrl: value,
                                            );
                                          });
                                        }
                                      }
                                    } else {
                                      showFlutterToast(message: 'No Internet Connection', state: ToastStates.error, context: context);
                                    }
                                  },
                                  context: context,
                                ),
                                fallback: (context) => Center(child: CircularLoading(os: getOs())),
                              ),
                            ),
                        ],
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

  Widget buildItemImageProduct(image , index , context) => Stack(
    alignment: Alignment.topLeft,
    children: [
      GestureDetector(
        onTap: () {
          showFullImage(image, index.toString(), context);
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
            child: Image.network(image,
              width: MediaQuery.of(context).size.width / 1.05,
              fit: BoxFit.fitWidth,
              frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                if(frame == null) {
                  return SizedBox(
                    height: 250.0,
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
                      height: 250.0,
                      width: MediaQuery.of(context).size.width / 1.05,
                      child: Center(child: AnotherCircularLoading(os: getOs(),)));
                }
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                    height: 250.0,
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
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          radius: 12.0,
          backgroundColor: ThemeCubit.get(context).isDark ? Colors.grey.shade800.withOpacity(.7) : Colors.grey.shade200,
          child: Text(
            '${++index}',
            style: TextStyle(
              color: ThemeCubit.get(context).isDark ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    ],
  );


  Widget buildItemImageUpload(XFile image , index , context) => Stack(
    alignment: Alignment.bottomCenter,
    children: [
      GestureDetector(
        onTap: () {
          showFullImage('', '${index.toString()} image', context , imageFile: image);
        },
        child: Hero(
          tag: '${index.toString()} image',
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(
                width: 0.0,
                color: ThemeCubit.get(context).isDark ? Colors.white : Colors.black,
              ),
            ),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Image.file(File(image.path),
              width: MediaQuery.of(context).size.width / 1.05,
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
      ),
      Positioned(
        top: 0, // Adjust the top position as needed
        left: 0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            radius: 12.0,
            backgroundColor: ThemeCubit.get(context).isDark ? Colors.grey.shade800.withOpacity(.7) : Colors.grey.shade200,
            child: Text(
              '${++index}',
              style: TextStyle(
                color: ThemeCubit.get(context).isDark ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ),
      Tooltip(
        message: 'Remove',
        child: Material(
          color: Colors.grey.shade800.withOpacity(.7),
          borderRadius: BorderRadius.circular(8.0,),
          child: InkWell(
            borderRadius: BorderRadius.circular(8.0,),
            onTap: () {
              AppCubit.get(context).clearImage(--index);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 10.0,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0,),
              ),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: const Icon(
                Icons.close_rounded,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    ],
  );


}
