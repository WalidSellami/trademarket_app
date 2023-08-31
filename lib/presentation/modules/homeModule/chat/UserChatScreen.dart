import 'dart:io';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trade_market_app/data/models/messageModel/MessageModel.dart';
import 'package:trade_market_app/shared/adaptive/anotherCircularLoading/AnotherCircularLoading.dart';
import 'package:trade_market_app/shared/adaptive/circularLoading/CircularLoading.dart';
import 'package:trade_market_app/shared/components/Components.dart';
import 'package:trade_market_app/shared/components/Constants.dart';
import 'package:trade_market_app/shared/cubit/appCubit/AppCubit.dart';
import 'package:trade_market_app/shared/cubit/appCubit/AppStates.dart';
import 'package:trade_market_app/shared/cubit/checkCubit/CheckCubit.dart';
import 'package:trade_market_app/shared/cubit/checkCubit/CheckStates.dart';
import 'package:trade_market_app/shared/cubit/themeCubit/ThemeCubit.dart';
import 'package:trade_market_app/shared/styles/Styles.dart';

class UserChatScreen extends StatefulWidget {
  final String receiverId;
  final String fullName;

  const UserChatScreen({super.key , required this.receiverId , required this.fullName});

  @override
  State<UserChatScreen> createState() => _UserChatScreenState();
}

class _UserChatScreenState extends State<UserChatScreen> {


  var msgController = TextEditingController();

  final FocusNode focusNode = FocusNode();

  bool isVisible = false;

  final GlobalKey globalKey = GlobalKey();

  final ScrollController scrollController = ScrollController();


  void scrollToBottom() {
    if(scrollController.hasClients) {
      scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeIn);
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    msgController.dispose();
    super.dispose();
  }


  @override
  void initState() {
    super.initState();
    if(CheckCubit.get(context).hasInternet) {
      AppCubit.get(context).getSellerProfile(userId: widget.receiverId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        if(CheckCubit.get(context).hasInternet) {
          AppCubit.get(context).getMessages(receiverId: widget.receiverId);
        }
        return BlocConsumer<CheckCubit , CheckStates>(
          listener: (context , state) {},
          builder: (context , state) {

            var checkCubit = CheckCubit.get(context);

            return BlocConsumer<AppCubit , AppStates>(
              listener: (context , state) {


                if(state is SuccessGetMessagesAppState) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    scrollToBottom();
                  });
                  AppCubit.get(context).clearNotice(receiverId: widget.receiverId);
                }


                if(state is SuccessDeleteMessageAppState) {
                  Navigator.pop(context);
                  focusNode.unfocus();
                }


                if(state is SuccessSendMessageAppState) {
                  msgController.text = '';
                  setState(() {
                    isVisible = false;
                  });
                  if(AppCubit.get(context).messageImage != null) {
                    Navigator.pop(context);
                    AppCubit.get(context).clearMessageImage();
                  }
                }


                if(state is SuccessGetMessageImageAppState) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    scrollToBottom();
                  });
                  setState(() {
                    isVisible = true;
                  });
                }

              },
              builder: (context , state) {

                var cubit = AppCubit.get(context);

                var messages = cubit.messages;
                var idMessages = cubit.idMessages;

                return WillPopScope(
                  onWillPop: () async {
                    focusNode.unfocus();
                    Navigator.pop(context);
                    cubit.clearMessages();
                    return true;
                  },
                  child: Scaffold(
                    appBar: defaultAppBar(
                      onPress: () {
                        focusNode.unfocus();
                        Navigator.pop(context);
                        cubit.clearMessages();
                      },
                      title: widget.fullName,
                    ),
                    body: Column(
                      children: [
                        Expanded(
                          child: ConditionalBuilder(
                            condition: messages.isNotEmpty,
                            builder: (context) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListView.separated(
                                controller: scrollController,
                                  itemBuilder: (context , index) {

                                     if(messages[index].senderId == uId) {

                                       if(messages[index].messageImage != '') {

                                         return buildItemSenderMessageWithImage(messages[index] , idMessages[index] , index);

                                       } else {

                                         return buildItemSenderMessage(messages[index] , idMessages[index]);

                                       }

                                     } else {

                                       if(messages[index].messageImage != '') {

                                         return buildItemReceiverMessageWithImage(messages[index] , idMessages[index] , index);

                                       } else {

                                         return buildItemReceiverMessage(messages[index] , idMessages[index]);

                                       }


                                     }

                                  },
                                  separatorBuilder: (context , index) => const SizedBox(
                                    height: 20.0,
                                  ),
                                  itemCount: messages.length),
                            ),
                            fallback: (context) => (state is LoadingGetMessagesAppState) ?
                               Center(child: CircularLoading(os: getOs())) :
                               const Center(
                                 child: Text(
                                   'There is no messages',
                                   style: TextStyle(
                                     fontSize: 17.0,
                                     fontWeight: FontWeight.bold,
                                   ),
                                 ),
                               ),
                          ),
                        ),
                        if(cubit.messageImage != null)
                        const SizedBox(
                          height: 20.0,
                        ),
                        if(cubit.messageImage != null)
                          SizedBox(
                            height: 175.0,
                            width: 175.0,
                            child: Stack(
                              alignment: Alignment.topRight,
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: GestureDetector(
                                    onTap: () {
                                      showFullImage('', 'img', context , imageFile: cubit.messageImage);
                                    },
                                    child: Hero(
                                      tag: 'img',
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8.0),
                                          border: Border.all(
                                            width: 0.0,
                                            color: ThemeCubit.get(context).isDark ? Colors.white : Colors.black,
                                          ),
                                        ),
                                        clipBehavior: Clip.antiAliasWithSaveLayer,
                                        child: Image.file(File(cubit.messageImage!.path),
                                         width: 150.0,
                                         height: 150.0,
                                          fit: BoxFit.fitWidth,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                CircleAvatar(
                                  radius: 20.0,
                                  backgroundColor: ThemeCubit.get(context).isDark ? Colors.grey.shade800.withOpacity(.7) : Colors.grey.shade300,
                                  child: IconButton(
                                      onPressed: () {
                                        cubit.clearMessageImage();
                                        if(msgController.text.isEmpty) {
                                          setState(() {
                                            isVisible = false;
                                          });
                                        }
                                      },
                                      icon: Icon(
                                        Icons.close_rounded,
                                        color: ThemeCubit.get(context).isDark ? Colors.white : Colors.black,
                                      ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        Material(
                          elevation: 16.0,
                          color:Theme.of(context).scaffoldBackgroundColor,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12.0,
                              horizontal: 4.0,
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      focusNode.unfocus();
                                      if(checkCubit.hasInternet) {
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
                                                        cubit.getMessageImage(ImageSource.camera);
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
                                                        cubit.getMessageImage(ImageSource.gallery);
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
                                        showFlutterToast(message: 'No Internet Connection', state: ToastStates.error, context: context);
                                      }
                                    },
                                    icon: Icon(
                                      Icons.camera_alt_rounded,
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                  tooltip: 'Image',
                                  enableFeedback: true,
                                ),
                                const SizedBox(
                                  width: 8.0,
                                ),
                                Expanded(
                                  child: TextFormField(
                                    focusNode: focusNode,
                                    controller: msgController,
                                    keyboardType: TextInputType.multiline,
                                    maxLines: null,
                                    decoration: InputDecoration(
                                      constraints: const BoxConstraints(
                                        maxHeight: 120.0,
                                      ),
                                      hintText: 'Write something ...',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30.0),
                                        borderSide: const BorderSide(
                                          width: 2.0,
                                        ),
                                      ),
                                    ),
                                    onChanged: (value) {
                                       if(value.isNotEmpty) {
                                         setState(() {
                                           isVisible = true;
                                         });
                                       } else {
                                         setState(() {
                                           isVisible = false;
                                         });
                                       }
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  width: 8.0,
                                ),
                                Visibility(
                                  visible: isVisible,
                                  child: ConditionalBuilder(
                                    condition: state is! LoadingSendMessageAppState,
                                    builder: (context) => IconButton(
                                        onPressed: () async {

                                          if(checkCubit.hasInternet) {

                                            if(cubit.messageImage == null) {

                                              cubit.sendMessage(
                                                  receiverId: widget.receiverId,
                                                  messageText: msgController.text,
                                              );

                                              await cubit.sendNotification(
                                                  title: cubit.userProfile!.fullName.toString(),
                                                  body: 'Sent Message',
                                                  deviceToken: cubit.sellerProfile!.deviceToken.toString());

                                            } else {

                                              cubit.uploadImageMessage(
                                                  receiverId: widget.receiverId,
                                                  messageText: msgController.text,
                                                  context: context);

                                              await Future.delayed(const Duration(milliseconds: 800)).then((value) async {
                                                await cubit.sendNotification(
                                                    title: cubit.userProfile!.fullName.toString(),
                                                    body: 'Sent Image',
                                                    deviceToken: cubit.sellerProfile!.deviceToken.toString());
                                              });
                                            }

                                          } else {

                                            showFlutterToast(message: 'No Internet Connection', state: ToastStates.error, context: context);

                                          }

                                        },
                                        icon: Icon(
                                          Icons.send_rounded,
                                          color: Theme.of(context).colorScheme.primary,
                                        ),
                                      tooltip: 'Send',
                                      enableFeedback: true,
                                    ),
                                    fallback: (context) => CircularLoading(os: getOs()),
                                  ),
                                ),
                              ],
                            ),
                          ),
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
    );
  }


  Widget buildItemSenderMessage(MessageModel model , idMessage) => GestureDetector(
    onLongPress: () {
     showAlertRemoveMessage(context, idMessage);
    },
    child: Align(
      alignment: Alignment.centerRight,
      child: Container(
          padding: const EdgeInsets.all(10.0),
          constraints: const BoxConstraints(
            maxWidth: 150.0,
          ),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(14.0),
              topRight: Radius.circular(14.0),
              bottomLeft: Radius.circular(14.0),
            ),
            color: Theme.of(context).colorScheme.primary,
          ),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Text(
            '${model.messageText}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          )),
    ),
  );


  Widget buildItemReceiverMessage(MessageModel model , idMessage) => GestureDetector(
    onLongPress: () {
      showAlertRemoveMessage(context, idMessage);
    },
    child: Align(
      alignment: Alignment.centerLeft,
      child: Container(
          padding: const EdgeInsets.all(10.0),
          constraints: const BoxConstraints(
            maxWidth: 150.0,
          ),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(14.0),
              topRight: Radius.circular(14.0),
              bottomRight: Radius.circular(14.0),
            ),
            color: Colors.grey.shade700,
          ),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Text(
            '${model.messageText}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          )),
    ),
  );



  Widget buildItemSenderMessageWithImage(MessageModel model , idMessage , index) => GestureDetector(
    onLongPress: () {
      showAlertRemoveMessage(context, idMessage);
    },
    child: Align(
      alignment: Alignment.centerRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () {
              showFullImageAndSave(globalKey, model.messageImage, index.toString(), context , isMyPhotos: false);
            },
            child: Hero(
              tag: index.toString(),
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(14.0),
                      topRight: Radius.circular(14.0),
                      bottomLeft: Radius.circular(14.0),
                    ),
                    border: Border.all(
                      width: 0.0,
                      color: ThemeCubit.get(context).isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Image.network('${model.messageImage}',
                   width: 150.0,
                   height: 150.0,
                   fit: BoxFit.fitWidth,
                    frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                      if(frame == null) {
                        return SizedBox(
                          width: 150.0,
                          height: 150.0,
                          child: Center(child: AnotherCircularLoading(os: getOs(),)),
                        );
                      }
                      return child;
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if(loadingProgress == null) {
                        return child;
                      } else {
                        return SizedBox(
                          width: 150.0,
                          height: 150.0,
                          child: Center(child: AnotherCircularLoading(os: getOs(),)),
                        );
                      }
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                          width: 150.0,
                          height: 150.0,
                          decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(14.0),
                          topRight: Radius.circular(14.0),
                          bottomRight: Radius.circular(14.0),
                          ),),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: Image.asset('assets/images/mark.jpg'));
                    },
                  ),
              ),
            ),
          ),
          if(model.messageText != '')
          const SizedBox(
            height: 4.0,
          ),
          if(model.messageText != '')
          Container(
              padding: const EdgeInsets.all(10.0),
              constraints: const BoxConstraints(
                maxWidth: 150.0,
              ),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(14.0),
                  topRight: Radius.circular(14.0),
                  bottomLeft: Radius.circular(14.0),
                ),
                color: Theme.of(context).colorScheme.primary,
              ),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Text(
                '${model.messageText}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              )),
        ],
      ),
    ),
  );


  Widget buildItemReceiverMessageWithImage(MessageModel model , idMessage , index) => GestureDetector(
    onLongPress: () {
      showAlertRemoveMessage(context, idMessage);
    },
    child: Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              showFullImageAndSave(globalKey, model.messageImage, '${index.toString()} img', context , isMyPhotos: false);
            },
            child: Hero(
              tag: '${index.toString()} img',
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(14.0),
                    topRight: Radius.circular(14.0),
                    bottomRight: Radius.circular(14.0),
                  ),
                  border: Border.all(
                    width: 0.0,
                    color: ThemeCubit.get(context).isDark ? Colors.white : Colors.black,
                  ),
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Image.network('${model.messageImage}',
                  width: 150.0,
                  height: 150.0,
                  fit: BoxFit.fitWidth,
                  frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                    if(frame == null) {
                      return SizedBox(
                        width: 150.0,
                        height: 150.0,
                        child: Center(child: AnotherCircularLoading(os: getOs(),)),
                      );
                    }
                    return child;
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if(loadingProgress == null) {
                      return child;
                    } else {
                      return SizedBox(
                        width: 150.0,
                        height: 150.0,
                        child: Center(child: AnotherCircularLoading(os: getOs(),)),
                      );
                    }
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                        width: 150.0,
                        height: 150.0,
                        decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(14.0),
                        topRight: Radius.circular(14.0),
                        bottomRight: Radius.circular(14.0),
                         ),
                        ),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Image.asset('assets/images/mark.jpg'));
                  },
                ),
              ),
            ),
          ),
          if(model.messageText != '')
            const SizedBox(
              height: 4.0,
            ),
          if(model.messageText != '')
            Container(
                padding: const EdgeInsets.all(10.0),
                constraints: const BoxConstraints(
                  maxWidth: 150.0,
                ),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(14.0),
                    topRight: Radius.circular(14.0),
                    bottomRight: Radius.circular(14.0),
                  ),
                  color: Colors.grey.shade700,
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Text(
                  '${model.messageText}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                )),
        ],
      ),
    ),
  );


  dynamic showAlertRemoveMessage(BuildContext context , idMessage) {
    return showDialog(
      context: context,
      builder: (dialogContext) {
        HapticFeedback.vibrate();
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.0,),
          ),
          title: const Text(
            'Do you want to remove this message ?',
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
                AppCubit.get(context).deleteMessage(
                    receiverId: widget.receiverId,
                    idMessage: idMessage);
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
