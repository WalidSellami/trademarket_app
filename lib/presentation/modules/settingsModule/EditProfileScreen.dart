import 'dart:io';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trade_market_app/shared/adaptive/circularLoading/CircularLoading.dart';
import 'package:trade_market_app/shared/components/Components.dart';
import 'package:trade_market_app/shared/components/Constants.dart';
import 'package:trade_market_app/shared/cubit/appCubit/AppCubit.dart';
import 'package:trade_market_app/shared/cubit/appCubit/AppStates.dart';
import 'package:trade_market_app/shared/cubit/checkCubit/CheckCubit.dart';
import 'package:trade_market_app/shared/cubit/checkCubit/CheckStates.dart';
import 'package:trade_market_app/shared/cubit/themeCubit/ThemeCubit.dart';
import 'package:trade_market_app/shared/cubit/themeCubit/ThemeStates.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {

  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var addressController = TextEditingController();


  final FocusNode focusNode1 = FocusNode();
  final FocusNode focusNode2 = FocusNode();
  final FocusNode focusNode3 = FocusNode();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();



  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CheckCubit , CheckStates>(
      listener: (context , state) {},
      builder: (context , state) {

        var checkCubit = CheckCubit.get(context);

        return BlocConsumer<ThemeCubit , ThemeStates>(
          listener: (context , state) {},
          builder: (context , state) {

            var themeCubit = ThemeCubit.get(context);

            return BlocConsumer<AppCubit , AppStates>(
              listener: (context , state) {


                if(state is LoadingUploadImageProfileAppState) {
                  showLoading(context);
                }


                if(state is SuccessGetUserProfileAppState) {

                  showFlutterToast(message: 'Done with success', state: ToastStates.success, context: context);

                  if(AppCubit.get(context).imageProfile != null) {

                    Navigator.pop(context);
                    AppCubit.get(context).clearImageProfile();

                  }


                }

              },
              builder: (context , state) {

                var cubit = AppCubit.get(context);
                var userProfile = cubit.userProfile;

                nameController.text = userProfile?.fullName ?? '';
                phoneController.text = userProfile?.phone ?? '';
                addressController.text = userProfile?.address ?? '';


                return Scaffold(
                  appBar: defaultAppBar(
                      onPress: () {
                        Navigator.pop(context);
                      },
                      title: 'Edit Profile',
                      actions: [
                        if(cubit.imageProfile != null)
                          defaultTextButton(
                            text: 'Upload & Update',
                            onPress: () {
                              if(checkCubit.hasInternet) {
                                if(formKey.currentState!.validate()) {

                                  cubit.uploadImageProfile(
                                      fullName: nameController.text,
                                      phone: phoneController.text,
                                      address: addressController.text);

                                }
                              } else {

                                showFlutterToast(message: 'No Internet Connection', state: ToastStates.error, context: context);

                              }
                            },
                          ),
                      ]
                  ),
                  body: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: [
                            Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                CircleAvatar(
                                  radius: 63.0,
                                  backgroundColor: themeCubit.isDark ? Colors.white : Colors.black,
                                  child: CircleAvatar(
                                    radius: 60.0,
                                    backgroundColor: Theme.of(context).colorScheme.primary,
                                    backgroundImage: (cubit.imageProfile == null) ? NetworkImage('${userProfile?.imageProfile}')
                                        : Image.file(File(cubit.imageProfile!.path)).image,
                                  ),
                                ),
                                CircleAvatar(
                                  radius: 22.0,
                                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                ),
                                CircleAvatar(
                                  radius: 20.0,
                                  backgroundColor: themeCubit.isDark ? Colors.grey.shade800.withOpacity(.7) : Colors.grey.shade200,
                                  child: IconButton(
                                    onPressed: () {
                                      focusNode1.unfocus();
                                      focusNode2.unfocus();
                                      focusNode3.unfocus();
                                      if(checkCubit.hasInternet) {
                                        if(cubit.imageProfile == null) {
                                          showModalBottomSheet(context: context,
                                            builder: (context) {
                                              return SafeArea(
                                                child: Material(
                                                  color: themeCubit.isDark
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
                                                          cubit.getImageProfile(ImageSource.camera, context);
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
                                                          cubit.getImageProfile(ImageSource.gallery, context);
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
                                        } else {
                                          cubit.clearImageProfile();
                                        }
                                      } else {
                                        showFlutterToast(message: 'No Internet Connection', state: ToastStates.error, context: context);
                                      }
                                    },
                                    icon: Icon(
                                      (cubit.imageProfile == null) ? Icons.camera_alt_outlined : Icons.close_rounded,
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                    tooltip: (cubit.imageProfile == null) ? 'Change Image' : 'Remove Image',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 40.0,
                            ),
                            defaultFormField(
                                controller: nameController,
                                type: TextInputType.name,
                                label: 'Full Name',
                                focusNode: focusNode1,
                                prefixIcon: Icons.person,
                                validate: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Full Name must not be empty.';
                                  }
                                  if (value.length < 4) {
                                    return 'Full Name must be at least 4 characters.';
                                  }
                                  bool validName =
                                  RegExp(r'^(?=.*[a-zA-Z])[a-zA-Z0-9\s_.]+$')
                                      .hasMatch(value);
                                  if (!validName) {
                                    return 'Enter a valid name --> (without (,-) and without only numbers).';
                                  }
                                  return null;
                                },
                                context: context),
                            const SizedBox(
                              height: 30.0,
                            ),
                            defaultFormField(
                                label: 'Phone',
                                controller: phoneController,
                                type: TextInputType.phone,
                                focusNode: focusNode2,
                                prefixIcon: Icons.phone,
                                validate: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Phone must not be empty';
                                  }

                                  if(value.contains('Enter')) {
                                    return 'Enter your phone number!';
                                  }

                                  if (value.length < 9 || value.length > 10) {
                                    return 'Phone must be 9 or 10 numbers with 0 in the beginning.';
                                  }

                                  String firstLetter =
                                  value.substring(0, 1).toUpperCase();
                                  if (firstLetter != '0') {
                                    return 'Phone must be starting with 0';
                                  }
                                  return null;
                                },
                                context: context),
                            const SizedBox(
                              height: 30.0,
                            ),
                            defaultFormField(
                                label: 'Address',
                                controller: addressController,
                                type: TextInputType.streetAddress,
                                focusNode: focusNode3,
                                prefixIcon: EvaIcons.pinOutline,
                                validate: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Address must not be empty';
                                  }

                                  if(value.contains('Enter')) {
                                    return 'Enter your valid address!';
                                  }

                                  bool validAddress =
                                  RegExp(r'^(?=.*[a-zA-Z])[a-zA-Z0-9\s_.]+$')
                                      .hasMatch(value);
                                  if (!validAddress) {
                                    return 'Enter a valid address --> (without (,-) and without only numbers).';
                                  }
                                  return null;
                                },
                                context: context),
                            const SizedBox(
                              height: 40.0,
                            ),
                            if(cubit.imageProfile == null)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0,
                                ),
                                child: ConditionalBuilder(
                                  condition: state is! LoadingUpdateProfileAppState,
                                  builder: (context) => defaultButton(
                                      text: 'Update'.toUpperCase(),
                                      onPress: () {
                                        focusNode1.unfocus();
                                        focusNode2.unfocus();
                                        focusNode3.unfocus();
                                        if(checkCubit.hasInternet) {
                                          if(formKey.currentState!.validate()) {

                                            cubit.updateProfile(
                                                fullName: nameController.text,
                                                phone: phoneController.text,
                                                address: addressController.text);

                                          }

                                        } else {

                                          showFlutterToast(message: 'No Internet Connection', state: ToastStates.error, context: context);

                                        }

                                      },
                                      context: context),
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
      },
    );
  }
}
