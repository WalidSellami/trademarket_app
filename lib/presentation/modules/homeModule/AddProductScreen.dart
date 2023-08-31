import 'dart:io';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trade_market_app/shared/adaptive/anotherCircularLoading/AnotherCircularLoading.dart';
import 'package:trade_market_app/shared/components/Components.dart';
import 'package:trade_market_app/shared/components/Constants.dart';
import 'package:trade_market_app/shared/cubit/appCubit/AppCubit.dart';
import 'package:trade_market_app/shared/cubit/appCubit/AppStates.dart';
import 'package:trade_market_app/shared/cubit/checkCubit/CheckCubit.dart';
import 'package:trade_market_app/shared/cubit/checkCubit/CheckStates.dart';
import 'package:trade_market_app/shared/cubit/themeCubit/ThemeCubit.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {

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


  void scrollToBottom() {
    if(scrollController.hasClients) {
      scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeIn);
    }
  }


  @override
  void dispose() {
   titleController.dispose();
   priceController.dispose();
   addressController.dispose();
   descriptionController.dispose();
   scrollController.dispose();
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

            if(state is SuccessGetImagesAppState) {

              WidgetsBinding.instance.addPostFrameCallback((_) {
                 scrollToBottom();
              });

            }


            if(state is ErrorUploadProductImagesAppState) {

              showFlutterToast(message: state.error.toString(), state: ToastStates.error, context: context);
              Navigator.pop(context);

            }


            if(state is SuccessAddProductAppState) {
              showFlutterToast(message: 'Done with success', state: ToastStates.success, context: context);
              Navigator.pop(context);
              Navigator.pop(context);
              AppCubit.get(context).clear();
            }

            if(state is ErrorAddProductAppState) {

              showFlutterToast(message: state.error.toString(), state: ToastStates.error, context: context);
              Navigator.pop(context);

            }



          },
          builder: (context , state) {

            var cubit = AppCubit.get(context);

            return Scaffold(
              appBar: defaultAppBar(
                onPress: () {
                   Navigator.pop(context);
                },
                title: 'Add Product For Sell',
              ),
              body: SingleChildScrollView(
                controller: scrollController,
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
                                    if(value.contains('.,-')) {
                                      return 'Price must an integer number (Only numbers)';
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
                        if(cubit.images.isNotEmpty)
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
                                    scrollDirection: Axis.horizontal,
                                      itemBuilder: (context , index) => buildItemImage(cubit.images[index], index, context),
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
                          width: 180.0,
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
                                focusNode4.unfocus();
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
                                    'Add Image',
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
                        if(cubit.images.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 10.0
                          ),
                          child: defaultButton(
                              text: 'Add'.toUpperCase(),
                              onPress: () {
                                focusNode1.unfocus();
                                focusNode2.unfocus();
                                focusNode3.unfocus();
                                focusNode4.unfocus();
                                if(checkCubit.hasInternet) {
                                  if(formKey.currentState!.validate()) {
                                      cubit.addProduct(
                                        title: titleController.text,
                                        price: priceController.text,
                                        category: cubit.firstCategoryItem.toString(),
                                        condition: cubit.firstConditionItem.toString(),
                                        address: addressController.text,
                                        description: descriptionController.text,
                                        context: context,
                                      );
                                  }
                                } else {

                                  showFlutterToast(message: 'No Internet Connection', state: ToastStates.error, context: context);

                                }
                              },
                              context: context,
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


  Widget buildItemImage(XFile image , index , context) => Stack(
    alignment: Alignment.bottomCenter,
    children: [
      GestureDetector(
        onTap: () {
          showFullImage('', index.toString(), context , imageFile: image);
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
            child: Image.file(File(image.path),
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
            onTap: () {
              AppCubit.get(context).clearImage(index);
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
