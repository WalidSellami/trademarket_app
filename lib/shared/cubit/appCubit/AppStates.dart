abstract class AppStates {}

class InitialAppState extends AppStates {}

class ChangeBottomNavAppState extends AppStates {}

class ConfirmQuickAlertAppState extends AppStates {}



// Get Data Profile
class LoadingGetUserProfileAppState extends AppStates {}

class SuccessGetUserProfileAppState extends AppStates {}

class ErrorGetUserProfileAppState extends AppStates {

  dynamic error;
  ErrorGetUserProfileAppState(this.error);

}



// Update Profile
class LoadingUpdateProfileAppState extends AppStates {}

class SuccessUpdateProfileAppState extends AppStates {}

class ErrorUpdateProfileAppState extends AppStates {

  dynamic error;
  ErrorUpdateProfileAppState(this.error);

}

class SuccessUpdateAllProfileAppState extends AppStates {}



// Get Image Profile
class SuccessGetImageProfileAppState extends AppStates {}

class ErrorGetImageProfileAppState extends AppStates {}



class SuccessClearDataAppState extends AppStates {}



// Upload Image Profile
class LoadingUploadImageProfileAppState extends AppStates {}

class SuccessUploadImageProfileAppState extends AppStates {}

class ErrorUploadImageProfileAppState extends AppStates {

  dynamic error;
  ErrorUploadImageProfileAppState(this.error);

}




// Change Password
class LoadingChangePasswordAppState extends AppStates {}

class SuccessChangePasswordAppState extends AppStates {}

class ErrorChangePasswordAppState extends AppStates {

  dynamic error;
  ErrorChangePasswordAppState(this.error);

}



// Save Account on device
class LoadingSaveAccountAppState extends AppStates {}

class SuccessSaveAccountAppState extends AppStates {}

class ErrorSaveAccountAppState extends AppStates {

  dynamic error;
  ErrorSaveAccountAppState(this.error);

}



// Get Saved Accounts
class LoadingGetSavedAccountsAppState extends AppStates {}

class SuccessGetSavedAccountsAppState extends AppStates {}

class ErrorGetSavedAccountsAppState extends AppStates {

  dynamic error;
  ErrorGetSavedAccountsAppState(this.error);

}




// Delete Saved Account
class LoadingDeleteSavedAccountAppState extends AppStates {}

class SuccessDeleteSavedAccountAppState extends AppStates {}

class ErrorDeleteSavedAccountAppState extends AppStates {

  dynamic error;
  ErrorDeleteSavedAccountAppState(this.error);

}




// Get All Images Profile
class LoadingGetAllImagesProfileAppState extends AppStates {}

class SuccessGetAllImagesProfileAppState extends AppStates {}

class ErrorGetAllImagesProfileAppState extends AppStates {

  dynamic error;
  ErrorGetAllImagesProfileAppState(this.error);

}




// Delete Image Profile Uploaded
class LoadingDeleteImageProfileUploadedAppState extends AppStates {}

class SuccessDeleteImageProfileUploadedAppState extends AppStates {}

class ErrorDeleteImageProfileUploadedAppState extends AppStates {

  dynamic error;
  ErrorDeleteImageProfileUploadedAppState(this.error);

}


// ---------------------------------------------------------------------- //


class SuccessChangeCategoryItemAppState extends AppStates {}

class SuccessChangeConditionItemAppState extends AppStates {}




// Get All Images
class SuccessGetImagesAppState extends AppStates {}

class ErrorGetImagesAppState extends AppStates {}




// Upload Product Images
class LoadingUploadProductImagesAppState extends AppStates {}

class SuccessUploadProductImagesAppState extends AppStates {}

class ErrorUploadProductImagesAppState extends AppStates {
  dynamic error;
  ErrorUploadProductImagesAppState(this.error);
}




// Add Product
class LoadingAddProductAppState extends AppStates {}

class SuccessAddProductAppState extends AppStates {}

class ErrorAddProductAppState extends AppStates {
  dynamic error;
  ErrorAddProductAppState(this.error);
}



// Get All Products
class LoadingGetAllProductsAppState extends AppStates {}

class SuccessGetAllProductsAppState extends AppStates {}


class SuccessGetAllImagesProductAppState extends AppStates {}

class SuccessGetAllFavoritesProductAppState extends AppStates {}



// Update Product Details
class LoadingUpdateProductDetailsAppState extends AppStates {}

class SuccessUpdateProductDetailsAppState extends AppStates {}

class ErrorUpdateProductDetailsAppState extends AppStates {

  dynamic error;
  ErrorUpdateProductDetailsAppState(this.error);

}


class SuccessUpdateImagesProductAppState extends AppStates {}



// Delete Product
class LoadingDeleteProductAppState extends AppStates {}

class SuccessDeleteProductAppState extends AppStates {}

class ErrorDeleteProductAppState extends AppStates {

  dynamic error;
  ErrorDeleteProductAppState(this.error);

}



// Delete All Favorites For Product
class LoadingDeleteAllFavoritesForProductAppState extends AppStates {}

class SuccessDeleteAllFavoritesForProductAppState extends AppStates {}

class ErrorDeleteAllFavoritesForProductAppState extends AppStates {

  dynamic error;
  ErrorDeleteAllFavoritesForProductAppState(this.error);

}



// Add Product Favorite
class LoadingAddProductFavoriteAppState extends AppStates {}

class ErrorAddProductFavoriteAppState extends AppStates {

  dynamic error;
  ErrorAddProductFavoriteAppState(this.error);

}

class LoadingGetUserFavoritesProductAppState extends AppStates {}

class SuccessGetUserFavoritesProductAppState extends AppStates {}



// Remove Product Favorite
class LoadingRemoveProductFavoriteAppState extends AppStates {}

class ErrorRemoveProductFavoriteAppState extends AppStates {

  dynamic error;
  ErrorRemoveProductFavoriteAppState(this.error);

}


// Search Products
class SuccessSearchProductsAppState extends AppStates {}

class ErrorSearchProductsAppState extends AppStates {

  dynamic error;
  ErrorSearchProductsAppState(this.error);

}


// Get Seller Profile
class LoadingGetSellerProfileAppState extends AppStates {}

class SuccessGetSellerProfileAppState extends AppStates {}

class ErrorGetSellerProfileAppState extends AppStates {

  dynamic error;
  ErrorGetSellerProfileAppState(this.error);

}



// Add Chat
class LoadingAddChatAppState extends AppStates {}

class SuccessAddChatAppState extends AppStates {}

class ErrorAddChatAppState extends AppStates {

  dynamic error;
  ErrorAddChatAppState(this.error);

}



// Get Chats
class LoadingGetChatsAppState extends AppStates {}

class SuccessGetChatsAppState extends AppStates {}

class ErrorGetChatsAppState extends AppStates {

  dynamic error;
  ErrorGetChatsAppState(this.error);

}


// Delete Chat
class LoadingDeleteChatAppState extends AppStates {}

class SuccessDeleteChatAppState extends AppStates {}

class ErrorDeleteChatAppState extends AppStates {

  dynamic error;
  ErrorDeleteChatAppState(this.error);

}


// Delete Chat Messages
class LoadingDeleteChatMessagesAppState extends AppStates {}

class SuccessDeleteChatMessagesAppState extends AppStates {}

class ErrorDeleteChatMessagesAppState extends AppStates {

  dynamic error;
  ErrorDeleteChatMessagesAppState(this.error);

}


// Get Message Image
class SuccessGetMessageImageAppState extends AppStates {}

class ErrorGetMessageImageAppState extends AppStates {}


// Send Message
class LoadingSendMessageAppState extends AppStates {}

class SuccessSendMessageAppState extends AppStates {}

class ErrorSendMessageAppState extends AppStates {

  dynamic error;
  ErrorSendMessageAppState(this.error);

}


// Send Message Image
class ErrorSendMessageImageAppState extends AppStates {

  dynamic error;
  ErrorSendMessageImageAppState(this.error);

}


// Get Messages
class LoadingGetMessagesAppState extends AppStates {}

class SuccessGetMessagesAppState extends AppStates {}

class SuccessGetReceiverMessagesAppState extends AppStates {}

class ErrorGetMessagesAppState extends AppStates {

  dynamic error;
  ErrorGetMessagesAppState(this.error);

}


// Delete Message
class LoadingDeleteMessageAppState extends AppStates {}

class SuccessDeleteMessageAppState extends AppStates {}

class ErrorDeleteMessageAppState extends AppStates {

  dynamic error;
  ErrorDeleteMessageAppState(this.error);

}


class SuccessActiveSearchAppState extends AppStates {}

// Send Notification
class SuccessSendNotificationAppState extends AppStates {}