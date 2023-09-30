import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trade_market_app/data/models/messageModel/MessageModel.dart';
import 'package:trade_market_app/data/models/productModel/ProductModel.dart';
import 'package:trade_market_app/data/models/userModel/UserModel.dart';
import 'package:trade_market_app/presentation/modules/categoriesModule/CategoriesScreen.dart';
import 'package:trade_market_app/presentation/modules/favoritesModule/FavoritesScreen.dart';
import 'package:trade_market_app/presentation/modules/homeModule/HomeScreen.dart';
import 'package:trade_market_app/presentation/modules/settingsModule/SettingsScreen.dart';
import 'package:trade_market_app/presentation/modules/startUpModule/loginScreen/LoginScreen.dart';
import 'package:trade_market_app/shared/components/Components.dart';
import 'package:trade_market_app/shared/components/Constants.dart';
import 'package:trade_market_app/shared/cubit/appCubit/AppStates.dart';
import 'package:trade_market_app/shared/network/local/CacheHelper.dart';

class AppCubit extends Cubit<AppStates> {

  AppCubit() : super(InitialAppState());

  static AppCubit get(context) => BlocProvider.of(context);


  int currentIndex = 0;

  void changeBottomNav(int index) {

    currentIndex = index;
    emit(ChangeBottomNavAppState());

  }
  

  List<Widget> screens = const [
    HomeScreen(),
    CategoriesScreen(),
    FavoritesScreen(),
    SettingsScreen(),
  ];


  List<String> titles = [
    'Home',
    'Categories',
    'Favorites',
    'Settings',
  ];

  void confirmQuickAlert(context) {

    Navigator.pop(context);
    AppCubit.get(context).currentIndex = 3;

    emit(ConfirmQuickAlertAppState());

  }


  UserModel? userProfile;

  int numberNotice = 0;

  void getUserProfile() {

    emit(LoadingGetUserProfileAppState());

    FirebaseFirestore.instance.collection('users').doc(uId).snapshots().listen((value) {

      numberNotice = 0;

      if((value.data() != null) && (value.data()?['uId'] == uId)) {

        userProfile = UserModel.fromJson(value.data()!);

        if(userProfile!.senders!.isNotEmpty) {

          for(var element in userProfile!.senders!.values) {

            if(element == true) {

              numberNotice++;

            }

          }

        }

      }

      emit(SuccessGetUserProfileAppState());

    });


  }


  var picker = ImagePicker();

  XFile? imageProfile;


  Future<void> getImageProfile(ImageSource source , context) async {

    final pickedFile = await picker.pickImage(source: source);

    if(pickedFile != null) {

      imageProfile = pickedFile;
      emit(SuccessGetImageProfileAppState());

    } else {

      showFlutterToast(message: 'No image selected', state: ToastStates.error, context: context);
      emit(ErrorGetImageProfileAppState());

    }


  }


  void clearImageProfile() {

    imageProfile = null;
    emit(SuccessClearDataAppState());

  }


  void uploadImageProfile({
    required String fullName,
    required String phone,
    required String address,
}) {

    emit(LoadingUploadImageProfileAppState());

    firebase_storage.FirebaseStorage.instance.ref().child('users/$uId/${Uri.file(imageProfile!.path).pathSegments.last}')
    .putFile(File(imageProfile!.path)).then((value) async {

      await value.ref.getDownloadURL().then((value) async {

        updateProfile(
            fullName: fullName,
            phone: phone,
            address: address,
            imageProfile: value,
        );


      }).catchError((error) {

        if(kDebugMode) {
          print('${error.toString()} --> in get download url image profile.');
        }

        emit(ErrorUploadImageProfileAppState(error));

      });

    }).catchError((error) {

      if(kDebugMode) {
        print('${error.toString()} --> in upload image profile.');
      }

      emit(ErrorUploadImageProfileAppState(error));

    });


  }




  void updateProfile({
    required String fullName,
    required String phone,
    required String address,
    String? imageProfile,
}) async {

    emit(LoadingUpdateProfileAppState());

    var deviceToken = await getDeviceToken();

    UserModel model = UserModel(
      fullName: fullName,
      email: userProfile?.email,
      uId: uId ?? userProfile?.uId,
      phone: phone,
      address: address,
      imageProfile: imageProfile ?? userProfile?.imageProfile,
      senders: userProfile?.senders ?? {},
      isInfoComplete: true,
      isEmailVerified: userProfile?.isEmailVerified ?? true,
      deviceToken: deviceToken,
    );

    FirebaseFirestore.instance.collection('users').doc(uId).update(model.toMap()).then((value) {

      getUserProfile();

      Future.delayed(const Duration(seconds: 2)).then((value) {

        FirebaseFirestore.instance.collection('products').where('uId_vendor' , isGreaterThanOrEqualTo: uId).get().then((value) {

          if(value.docs.isNotEmpty) {
            for(var element in value.docs) {
              FirebaseFirestore.instance.collection('products').doc(element.id).update({
                'vendor_name': fullName,
                'image_profile_vendor': imageProfile ?? userProfile?.imageProfile,
              });
            }
          }

          emit(SuccessUpdateAllProfileAppState());

        });

        FirebaseFirestore.instance.collection('users').get().then((value) {

          for(var element in value.docs) {
            if(element.id != uId) {
              element.reference.collection('chats').doc(uId).update({
                'full_name': fullName,
                'image_profile': imageProfile ?? userProfile?.imageProfile,
              });
            }
          }

          emit(SuccessUpdateAllProfileAppState());

        });
      });

    }).catchError((error) {

      if(kDebugMode) {
        print('${error.toString()} ---> in update profile.');
      }

      emit(ErrorUpdateProfileAppState(error));

    });


  }





  void changePassword({
    required String oldPassword,
    required String newPassword,
}) async {

    emit(LoadingChangePasswordAppState());

    AuthCredential credential = EmailAuthProvider.credential(
        email: FirebaseAuth.instance.currentUser!.email.toString(),
        password: oldPassword);

    await FirebaseAuth.instance.currentUser?.reauthenticateWithCredential(credential).then((value) async {

      await FirebaseAuth.instance.currentUser?.updatePassword(newPassword);

      emit(SuccessChangePasswordAppState());

    }).catchError((error) {

      if(kDebugMode) {

        print('${error.toString()} --> in change password.');

      }

      emit(ErrorChangePasswordAppState(error));

    });


  }



  void saveAccount({
    required String fullName,
    required String email,
    required String imageProfile,
}) async {

    emit(LoadingSaveAccountAppState());

    var deviceToken = await getDeviceToken();

    isGoogleSignIn = CacheHelper.getData(key: 'isGoogleSignIn');

    FirebaseFirestore.instance.collection('saved').doc(uId).set(
      {
        'full_name': fullName,
        'email': email,
        'image_profile': imageProfile,
        'device_token': deviceToken,
        'isGoogleSignIn': isGoogleSignIn,
      }

    ).then((value) {

      emit(SuccessSaveAccountAppState());

    }).catchError((error) {

      emit(ErrorSaveAccountAppState(error));

    });


  }


  List<dynamic> savedAccounts = [];
  List<dynamic> idSavedAccounts = [];

  void getSavedAccounts(context) async {

    emit(LoadingGetSavedAccountsAppState());

    var deviceToken = await getDeviceToken();

    FirebaseFirestore.instance.collection('saved').orderBy('full_name').snapshots().listen((value) {

      savedAccounts = [];
      idSavedAccounts = [];

      for(var element in value.docs) {

        if(element.data()['device_token'] == deviceToken) {

          idSavedAccounts.add(element.id);
          savedAccounts.add(element.data());

        }

      }

      if(savedAccounts.isEmpty) {
        CacheHelper.removeData(key: 'isSavedAccount');
        CacheHelper.removeData(key: 'isGoogleSignIn');
        navigateAndNotReturn(context: context, screen: const LoginScreen());
      }

      emit(SuccessGetSavedAccountsAppState());

    });


  }


  void deleteSavedAccount({
    required String userAccountId,
  }) async {

    emit(LoadingDeleteSavedAccountAppState());

    FirebaseFirestore.instance.collection('saved').doc(userAccountId).delete().then((value) {

      emit(SuccessDeleteSavedAccountAppState());
    }).catchError((error) {

      emit(ErrorDeleteSavedAccountAppState(error));
    });


  }


  String decodeImageUrl(String url) {

    String decodeUrl = Uri.decodeFull(url);
    List<String> path = Uri.parse(decodeUrl).pathSegments;

    String fileName = path.last;

    return fileName;

  }



  List<String> allImagesProfile = [];

  void getAllImagesProfile() {

    emit(LoadingGetAllImagesProfileAppState());

    firebase_storage.FirebaseStorage.instance.ref().child('users/$uId/').listAll().then((value) {

      allImagesProfile = [];

      if(value.items.isNotEmpty) {

        for(var element in value.items) {

          element.getDownloadURL().then((value) {

            allImagesProfile.add(value);

            emit(SuccessGetAllImagesProfileAppState());

          });
        }

      } else {

        emit(SuccessGetAllImagesProfileAppState());

      }

    }).catchError((error) {

      if(kDebugMode) {

        print('${error.toString()} ---> in get all images profile.');

      }

      emit(ErrorGetAllImagesProfileAppState(error));

    });

  }


  void clearAllImagesProfile() {

    allImagesProfile.clear();
    emit(SuccessClearDataAppState());
  }


  void removeImageProfileUploaded({
    required String image,
    required BuildContext context,
}) {

    emit(LoadingDeleteImageProfileUploadedAppState());

    String fileName = decodeImageUrl(image);

    firebase_storage.FirebaseStorage.instance.ref().child('users/$uId/$fileName').delete().then((value) {

      if(userProfile?.imageProfile == image) {
        FirebaseFirestore.instance.collection('users').doc(uId).update({
          'image_profile': profile,
        });
      }

     emit(SuccessDeleteImageProfileUploadedAppState());

    }).catchError((error) {

      if(kDebugMode) {
        print('${error.toString()} --> in delete image profile uploaded.');
      }

      emit(ErrorDeleteImageProfileUploadedAppState(error));
    });

  }



  //////////////////////////////////////////////////////////////////////


  String? firstCategoryItem;

  String? firstConditionItem;

  List<String> categories = [
    'Assorted Goods',
    'Clothing & Accessories',
    'Electronics',
    'Entertainments',
    'Homes & Gardens',
    'Vehicles',
  ];

  List<String> conditions = [
    'New',
    'Used - (new)',
    'Used - (good)',
    'Used - (fair)',
  ];


  void changeCategoryItem(value) {

    firstCategoryItem = value;
    emit(SuccessChangeCategoryItemAppState());

  }

  void changeConditionItem(value) {

    firstConditionItem = value;
    emit(SuccessChangeConditionItemAppState());

  }



  List<XFile> images = [];

  Future<void> getImages(source , context) async {

    final pickedFile = await picker.pickImage(source: source);

    if(pickedFile != null) {

      images.add(pickedFile);

      emit(SuccessGetImagesAppState());

    } else {

      emit(ErrorGetImagesAppState());

    }


  }

  void clearImage(index) {
    images.removeAt(index);
    emit(SuccessClearDataAppState());
  }


  void clear() {
    if(images.isNotEmpty) {
      images.clear();
    }
    firstCategoryItem = null;
    firstConditionItem = null;
    emit(SuccessClearDataAppState());
  }




  Future<List<String>> uploadProductImages(context) async {

    List<String> uploadPrdImages = [];

    List<Future<void>> uploadTasks = [];

    showLoading(context);

    for(var element in images) {

      var upload = firebase_storage.FirebaseStorage.instance.ref().child('products/$uId/${Uri.file(element.path).pathSegments.last}').
      putFile(File(element.path));

      uploadTasks.add(upload.then((v) async {

        await v.ref.getDownloadURL().then((value) {

          uploadPrdImages.add(value);

          emit(SuccessUploadProductImagesAppState());

        });

      }).catchError((error) {

        if(kDebugMode) {
          print('${error.toString()} --> in upload product images.');
        }

        emit(ErrorUploadProductImagesAppState(error));

      }));

    }

    await Future.wait(uploadTasks);


   return uploadPrdImages;

  }




  void addProduct({
    required String title,
    required String price,
    required String category,
    required String condition,
    required String address,
    required String description,
    required BuildContext context,
}) async {

    emit(LoadingAddProductAppState());

    List<String> imagesUrl = await uploadProductImages(context);

    ProductModel model = ProductModel(
      title: title,
      titleLowercase: title.toLowerCase(),
      price: price,
      category: category,
      condition: condition,
      description: description,
      address: address,
      images: imagesUrl,
      vendorName: userProfile?.fullName,
      uIdVendor: uId ?? userProfile?.uId,
      imageProfileVendor: userProfile?.imageProfile,
      favorites: {},
      timesTamp: Timestamp.now(),
    );

    FirebaseFirestore.instance.collection('products').add(model.toMap()).then((value) {

      emit(SuccessAddProductAppState());

    }).catchError((error) {

      if(kDebugMode) {

        print('${error.toString()} ---> in add product.');
      }

      emit(ErrorAddProductAppState(error));

    });


  }




  List<ProductModel> allProducts = [];

  List<String> idProducts = [];


  List<ProductModel> myProducts = [];

  List<String> myIdProducts = [];


  List<ProductModel> myFavoriteProducts = [];

  List<String> myIdFavoriteProducts = [];



  Map<String , dynamic> numberFavorites = {};

  List<String> idUserFavorites = [];



  // Categories

  List<ProductModel> firstCategory = [];
  List<String> idFirstCategory = [];

  List<ProductModel> secondCategory = [];
  List<String> idSecondCategory = [];

  List<ProductModel> thirdCategory = [];
  List<String> idThirdCategory = [];

  List<ProductModel> fourthCategory = [];
  List<String> idFourthCategory = [];

  List<ProductModel> fifthCategory = [];
  List<String> idFifthCategory = [];

  List<ProductModel> sixCategory = [];
  List<String> idSixCategory = [];


  void getAllProducts() {

    emit(LoadingGetAllProductsAppState());

    FirebaseFirestore.instance.collection('products').orderBy('times_tamp' , descending: true).snapshots().listen((value) {

      idProducts = [];
      allProducts = [];

      myIdProducts = [];
      myProducts = [];

      myFavoriteProducts = [];
      myIdFavoriteProducts = [];


      firstCategory = [];
      idFirstCategory = [];

      secondCategory = [];
      idSecondCategory = [];

      thirdCategory = [];
      idThirdCategory = [];

      fourthCategory = [];
      idFourthCategory = [];

      fifthCategory = [];
      idFifthCategory = [];

      sixCategory = [];
      idSixCategory = [];

      for(var element in value.docs) {

        idProducts.add(element.id);
        allProducts.add(ProductModel.fromJson(element.data()));

        if(element.data()['uId_vendor'] == uId) {

          myIdProducts.add(element.id);
          myProducts.add(ProductModel.fromJson(element.data()));

        }

        if(element.data()['favorites'][uId] == true) {

          myIdFavoriteProducts.add(element.id);
          myFavoriteProducts.add(ProductModel.fromJson(element.data()));


        }


        if(element.data()['category'] == 'Assorted Goods') {

          idFirstCategory.add(element.id);
          firstCategory.add(ProductModel.fromJson(element.data()));

        } else if(element.data()['category'] == 'Clothing & Accessories') {

          idSecondCategory.add(element.id);
          secondCategory.add(ProductModel.fromJson(element.data()));

        } else if(element.data()['category'] == 'Electronics') {

          idThirdCategory.add(element.id);
          thirdCategory.add(ProductModel.fromJson(element.data()));

        } else if(element.data()['category'] == 'Entertainments') {

          idFourthCategory.add(element.id);
          fourthCategory.add(ProductModel.fromJson(element.data()));

        } else if(element.data()['category'] == 'Homes & Gardens') {

          idFifthCategory.add(element.id);
          fifthCategory.add(ProductModel.fromJson(element.data()));

        } else if(element.data()['category'] == 'Vehicles') {

          idSixCategory.add(element.id);
          sixCategory.add(ProductModel.fromJson(element.data()));

        }


        element.reference.collection('favorites').snapshots().listen((event) {

          if(event.docs.isNotEmpty) {

            numberFavorites.addAll({
              element.id : event.docs.length,
            });

          } else {

            numberFavorites.addAll({
              element.id : 0,
            });

          }

          emit(SuccessGetAllProductsAppState());

        });

      }

      emit(SuccessGetAllProductsAppState());

    });

  }




  void updateProductDetails({
    required String title,
    required String price,
    required String category,
    required String condition,
    required String address,
    required String description,
    required String productId,
    required BuildContext context,
    List<dynamic>? imagesUrl,
}) async {


    emit(LoadingUpdateProductDetailsAppState());

      List<dynamic> imagesProduct = [];

      Map<String , dynamic> favorites = {};

      List<Future<void>> tasks = [];

    if(images.isEmpty) {
       tasks.add(FirebaseFirestore.instance.collection('products').doc(productId).get().then((value) {
        imagesProduct = [];
        imagesProduct = value.data()?['images'];
      }));
    }

    tasks.add(FirebaseFirestore.instance.collection('products').doc(productId).get().then((value) {
      favorites = {};
      favorites = value.data()?['favorites'];
    }));

    await Future.wait(tasks);


    ProductModel model = ProductModel(
      title: title,
      titleLowercase: title.toLowerCase(),
      price: price,
      condition: condition,
      category: category,
      imageProfileVendor: userProfile?.imageProfile,
      uIdVendor: userProfile?.uId ?? uId,
      vendorName: userProfile?.fullName,
      description: description,
      address: address,
      images: imagesUrl ?? imagesProduct,
      favorites: favorites,
      timesTamp: Timestamp.now(),
    );


    FirebaseFirestore.instance.collection('products').doc(productId).update(model.toMap()).then((value) {

      emit(SuccessUpdateProductDetailsAppState());

    }).catchError((error) {

      if(kDebugMode) {
        print('${error.toString()}  ---> in update product details.');
      }

      emit(ErrorUpdateProductDetailsAppState(error));

    });


  }




  Future<List<dynamic>> updateProductImages({
    required String productId,
    required BuildContext context,
}) async {

    List<String> imagesUpload = await uploadProductImages(context);

    List<dynamic> imagesPrd = [];

    List<Future<void>> tasks = [];

    tasks.add(FirebaseFirestore.instance.collection('products').doc(productId).get().then((value) {
      imagesPrd = [];
      imagesPrd = value.data()?['images'];
    }));

    await Future.wait(tasks);


    if(imagesUpload.length == 1) {

      imagesPrd.removeAt(0);

      imagesPrd.insert(0, imagesUpload[0]);


    } else if(imagesUpload.length == 2) {

      imagesPrd.removeRange(0, 2);

      imagesPrd.insert(0, imagesUpload[0]);

      imagesPrd.insert(1, imagesUpload[1]);


    } else {

      imagesPrd.removeRange(0, 3);

      imagesPrd.insert(0, imagesUpload[0]);

      imagesPrd.insert(1, imagesUpload[1]);

      imagesPrd.insert(2, imagesUpload[2]);

    }


    return imagesPrd;


  }




  void deleteProduct({
    required String productId,
    required List<dynamic> imagesUrl,
}) {

    emit(LoadingDeleteProductAppState());

    if(idUserFavorites.isNotEmpty || numberFavorites[productId] > 0) {
      deleteAllFavoritesForProduct(productId: productId);
    }

    FirebaseFirestore.instance.collection('products').doc(productId).delete().then((value) {

      for(var element in imagesUrl) {

        String fileName = decodeImageUrl(element);

        firebase_storage.FirebaseStorage.instance.ref().child('products/$fileName').delete();

      }

      emit(SuccessDeleteProductAppState());

    }).catchError((error) {


      if(kDebugMode) {
        print('${error.toString()} ---> in delete product.');
      }

      emit(ErrorDeleteProductAppState(error));

    });

  }


  void deleteAllFavoritesForProduct({
    required String productId,

  }) {

    emit(LoadingDeleteAllFavoritesForProductAppState());

    for(var element in idUserFavorites) {

      FirebaseFirestore.instance.collection('products').doc(productId).collection('favorites').doc(element).delete().then((value) {

        emit(SuccessDeleteAllFavoritesForProductAppState());

      }).catchError((error) {

        emit(ErrorDeleteAllFavoritesForProductAppState(error));

      });

    }

  }


  void addProductFavorite({
    required String productId,
}) {

    emit(LoadingAddProductFavoriteAppState());

    FirebaseFirestore.instance.collection('products').doc(productId).update({
      'favorites.$uId': true,

    }).then((value) {

      FirebaseFirestore.instance.collection('products').doc(productId).collection('favorites').doc(uId).set({
        'full_name': userProfile?.fullName,
        'image_profile': userProfile?.imageProfile,
        'like': true,
      });

     getAllProducts();

    }).catchError((error) {

      if(kDebugMode) {
        print('${error.toString()} --> in add product favorite.');
      }

      emit(ErrorAddProductFavoriteAppState(error));

    });


  }


  void getUserFavorites({
    required String productId,
}) {

    emit(LoadingGetUserFavoritesProductAppState());

    FirebaseFirestore.instance.collection('products').doc(productId).collection('favorites').snapshots().listen((event) {

      for(var element in event.docs) {

        idUserFavorites.add(element.id);

      }

      emit(SuccessGetUserFavoritesProductAppState());

    });

  }


  void removeProductFavorite({
    required String productId,
  }) {

    emit(LoadingRemoveProductFavoriteAppState());

    FirebaseFirestore.instance.collection('products').doc(productId).update({
      'favorites.$uId': false,
    }).then((value) {

      FirebaseFirestore.instance.collection('products').doc(productId).collection('favorites').doc(uId).delete();

      getAllProducts();

    }).catchError((error) {

      if(kDebugMode) {
        print('${error.toString()} --> in remove product favorite.');
      }

      emit(ErrorRemoveProductFavoriteAppState(error));

    });


  }




  List<ProductModel> searchProducts = [];
  List<String> searchIdProducts = [];


  void searchProduct({
    required String name,
}) {

    FirebaseFirestore.instance.collection('products')
        .where('title_lowercase' , isGreaterThanOrEqualTo: name.toLowerCase()).get().then((value) {

      searchIdProducts = [];
      searchProducts = [];

      for(var element in value.docs) {

        searchIdProducts.add(element.id);
        searchProducts.add(ProductModel.fromJson(element.data()));
      }

      emit(SuccessSearchProductsAppState());


    }).catchError((error) {

      emit(ErrorSearchProductsAppState(error));


    });


  }


  void clearSearchAllProducts() {
    searchProducts.clear();
    searchIdProducts.clear();
    emit(SuccessClearDataAppState());

  }




  UserModel? sellerProfile;

  void getSellerProfile({
    required String userId,
}) {

    emit(LoadingGetSellerProfileAppState());

    FirebaseFirestore.instance.collection('users').doc(userId).get().then((value) {

      sellerProfile = UserModel.fromJson(value.data()!);

      emit(SuccessGetSellerProfileAppState());

    }).catchError((error) {


      if(kDebugMode) {

        print('${error.toString()} ---> in get seller profile.');

      }

      emit(ErrorGetSellerProfileAppState(error));

    });

  }



  List<dynamic> chats = [];

  List<MessageModel> messages = [];
  List<String> idMessages = [];
  List<MessageModel> receiverMessages = [];
  List<String> receiverIdMessages = [];


  void getChats() {

    emit(LoadingGetChatsAppState());

    FirebaseFirestore.instance.collection('users').doc(uId).collection('chats').snapshots().listen((value) {

      chats = [];

      for(var element in value.docs) {

        chats.add(element.data());

      }

      emit(SuccessGetChatsAppState());

    });

  }



  void addChat({
    required String fullName,
    required String imageProfile,
    required String id,
    required BuildContext context,
}) {

    showLoading(context);

    FirebaseFirestore.instance.collection('users').doc(uId).collection('chats').doc(id).set({
      'full_name': fullName,
      'image_profile': imageProfile,
      'uId': id,

    }).then((value) {

      FirebaseFirestore.instance.collection('users').doc(id).collection('chats').doc(uId).set({
        'full_name': userProfile?.fullName,
        'image_profile': userProfile?.imageProfile,
        'uId': uId,
      });

      emit(SuccessAddChatAppState());

    }).catchError((error) {

      if(kDebugMode) {
        print('${error.toString()} --> in add chat.');
      }

      emit(ErrorAddChatAppState(error));
    });

  }



  void deleteChat({
    required String idChat,
}) {

    emit(LoadingDeleteChatAppState());

    if(idMessages.isNotEmpty) {
      deleteChatMessages(idChat: idChat);
    }

    FirebaseFirestore.instance.collection('users').doc(uId).collection('chats').doc(idChat).delete().then((value) {

      emit(SuccessDeleteChatAppState());

    }).catchError((error) {

      emit(ErrorDeleteChatAppState(error));

    });


  }


  void deleteChatMessages({
    required String idChat,

}) {

    emit(LoadingDeleteChatMessagesAppState());

    for(var element in idMessages) {

      FirebaseFirestore.instance.collection('users').doc(uId).collection('chats').doc(idChat).collection('messages')
          .doc(element).delete().then((value) {

            emit(SuccessDeleteChatMessagesAppState());

          }).catchError((error) {

          emit(ErrorDeleteChatMessagesAppState(error));

          });

    }

  }


  XFile? messageImage;

  Future<void> getMessageImage(ImageSource source) async {

    final pickedFile = await picker.pickImage(source: source);

    if(pickedFile != null) {

      messageImage = pickedFile;
      emit(SuccessGetMessageImageAppState());

    } else {

      emit(ErrorGetMessageImageAppState());

    }

  }


  void clearMessageImage() {
    messageImage = null;
    emit(SuccessClearDataAppState());
  }



  void uploadImageMessage({
    required String receiverId,
    String? messageText,
    required BuildContext context,
}) {

    showLoading(context);

    firebase_storage.FirebaseStorage.instance.ref().child('messages/$uId/${Uri.file(messageImage!.path).pathSegments.last}').
    putFile(File(messageImage!.path)).then((v) {

      v.ref.getDownloadURL().then((value) {

        sendMessage(
          receiverId: receiverId,
          messageText: messageText ?? '',
          messageImage: value,
        );

      }).catchError((error) {

        if(kDebugMode) {
          print('${error.toString()} --> in get message image url');
        }

        emit(ErrorSendMessageImageAppState(error));

      });

    }).catchError((error) {

      if(kDebugMode) {
        print('${error.toString()} --> in upload message image');
      }

      emit(ErrorSendMessageImageAppState(error));

    });



  }





  void sendMessage({
    required String receiverId,
    String? messageText,
    String? messageImage,
}) {

    emit(LoadingSendMessageAppState());

    MessageModel model = MessageModel(
      messageText: messageText ?? '',
      receiverId: receiverId,
      senderId: uId,
      timesTamp: Timestamp.now(),
      messageImage: messageImage ?? '',
    );


    FirebaseFirestore.instance.collection('users').doc(uId).collection('chats').doc(receiverId).
    collection('messages').add(model.toMap()).then((value) {

      FirebaseFirestore.instance.collection('users').doc(receiverId).update({
        'senders.$uId': true,
      });

      emit(SuccessSendMessageAppState());

    }).catchError((error) {

      emit(ErrorSendMessageAppState(error));

    });

    FirebaseFirestore.instance.collection('users').doc(receiverId).collection('chats').doc(uId).
    collection('messages').add(model.toMap()).then((value) {

      FirebaseFirestore.instance.collection('users').doc(uId).update({
        'senders.$receiverId': false,

      });

      emit(SuccessSendMessageAppState());

    }).catchError((error) {

       emit(ErrorSendMessageAppState(error));

    });


  }





  void getMessages({
    required String receiverId,
}) {

    emit(LoadingGetMessagesAppState());

    FirebaseFirestore.instance.collection('users').doc(uId).collection('chats').doc(receiverId)
        .collection('messages').orderBy('times_tamp').snapshots().listen((value) {

          messages = [];
          idMessages = [];

          for(var element in value.docs) {

            idMessages.add(element.id);
            messages.add(MessageModel.fromJson(element.data()));

          }

        emit(SuccessGetMessagesAppState());

    });

    FirebaseFirestore.instance.collection('users').doc(receiverId).collection('chats').doc(uId)
        .collection('messages').orderBy('times_tamp').snapshots().listen((value) {

      receiverIdMessages = [];

      for(var element in value.docs) {

        receiverIdMessages.add(element.id);
        receiverMessages.add(MessageModel.fromJson(element.data()));

      }

      emit(SuccessGetReceiverMessagesAppState());

    });


  }


  void clearNotice({
    required String receiverId,
}) {

    FirebaseFirestore.instance.collection('users').doc(uId).update({
      'senders.$receiverId': false,
    });

    numberNotice--;
    emit(SuccessClearDataAppState());

  }



  void deleteMessage({
    required String receiverId,
    required String idMessage,
    required String receiverIdMessage,
    String? messageImage,
    bool isUnSend = false,
}) {

    emit(LoadingDeleteMessageAppState());

    FirebaseFirestore.instance.collection('users').doc(uId).collection('chats').doc(receiverId).
    collection('messages').doc(idMessage).delete().then((value) {

      if(isUnSend) {
        FirebaseFirestore.instance.collection('users').doc(receiverId).collection('chats').doc(uId).
        collection('messages').doc(receiverIdMessage).delete();
      }

      if(messageImage != '') {
        String fileName = decodeImageUrl(messageImage!);
        firebase_storage.FirebaseStorage.instance.ref().child('messages/$uId/$fileName').delete();
      }

      emit(SuccessDeleteMessageAppState());

    }).catchError((error) {

      if(kDebugMode) {
        print('${error.toString()} ---> in delete message.');
      }

      emit(ErrorDeleteMessageAppState(error));

    });


  }



  void clearMessages() {

    messages.clear();
    emit(SuccessClearDataAppState());

  }



// Notification
  Future<void> sendNotification({
    required String title,
    required String body,
    required String deviceToken,
  }) async {

    const url = 'https://fcm.googleapis.com/fcm/send';

    final data = {
      "data": {
        "title": title,
        "message": body,
        "sound": "default",
        "type": "order",
        "click_action": "FLUTTER_NOTIFICATION_CLICK"
      },
      "to": deviceToken,
    };

    Dio dio = Dio();

    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers['Authorization'] = 'key=AAAANddYRGs:APA91bF6GpmLxVrfC7HFU6HHrHnNGNodmnXDhDsjKHLHRMFSWge6PYOMJD4S0LweS5n8whrhssfNnDu33FhvWbenuBjmwN38jJr6t0utIXJ4mcbXx153I0cqkdtmZtiTxfRTWyEktHqE';

    await dio.post(url , data: data);

    emit(SuccessSendNotificationAppState());

  }


}