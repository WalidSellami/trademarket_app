import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trade_market_app/data/models/userModel/UserModel.dart';
import 'package:trade_market_app/presentation/modules/homeModule/chat/UserChatScreen.dart';
import 'package:trade_market_app/shared/adaptive/circularLoading/CircularLoading.dart';
import 'package:trade_market_app/shared/components/Components.dart';
import 'package:trade_market_app/shared/components/Constants.dart';
import 'package:trade_market_app/shared/cubit/appCubit/AppCubit.dart';
import 'package:trade_market_app/shared/cubit/appCubit/AppStates.dart';
import 'package:trade_market_app/shared/cubit/checkCubit/CheckCubit.dart';
import 'package:trade_market_app/shared/cubit/checkCubit/CheckStates.dart';
import 'package:trade_market_app/shared/cubit/themeCubit/ThemeCubit.dart';
import 'package:trade_market_app/shared/styles/Styles.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        if(CheckCubit.get(context).hasInternet) {
          AppCubit.get(context).getChats();
        }
        return BlocConsumer<CheckCubit , CheckStates>(
          listener: (context , state) {},
          builder: (context , state) {

            var checkCubit = CheckCubit.get(context);

           return  BlocConsumer<AppCubit , AppStates>(
              listener: (context , state) {

                if(state is SuccessDeleteChatAppState) {
                  showFlutterToast(message: 'Done with success', state: ToastStates.success, context: context);
                  AppCubit.get(context).clearMessages();
                }

                if(state is ErrorDeleteChatAppState) {
                  showFlutterToast(message: state.error.toString(), state: ToastStates.error, context: context);
                  Navigator.pop(context);
                }

              },
              builder: (context , state) {

                var cubit = AppCubit.get(context);
                var chats = cubit.chats;
                var profile = cubit.userProfile;

                return Scaffold(
                  appBar: defaultAppBar(
                    onPress: () {
                      Navigator.pop(context);
                    },
                    title: 'Chats',
                  ),
                  body: (checkCubit.hasInternet) ? ConditionalBuilder(
                    condition: chats.isNotEmpty,
                    builder: (context) => ListView.separated(
                      physics: const BouncingScrollPhysics(),
                          itemBuilder: (context , index) => buildItemChat(chats[index], profile, context),
                          separatorBuilder: (context , index) => Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                            ),
                            child: Divider(
                              thickness: 0.7,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          itemCount: chats.length),
                    fallback: (context) => (state is LoadingGetChatsAppState) ? Center(child: CircularLoading(os: getOs())) :
                     const Center(
                       child: Text(
                         'There is no chats',
                         style: TextStyle(
                           fontSize: 17.0,
                           fontWeight: FontWeight.bold,
                         ),
                       ),
                     ),
                  ) :
                  const Center(
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
    );
  }



  Widget buildItemChat(model , UserModel? user, context) => InkWell(
    onTap: () {
       Navigator.of(context).push(createSecondRoute(screen: UserChatScreen(
         receiverId: model['uId'],
         fullName: model['full_name'],)));
    },
    onLongPress: () {
      if(CheckCubit.get(context).hasInternet) {
        AppCubit.get(context).getMessages(receiverId: model['uId']);
        showAlertRemove(context, model['uId'], model['uId']);
      } else {
        showFlutterToast(message: 'No Internet Connection', state: ToastStates.error, context: context);
      }
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 14.0,
        vertical: 8.0,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30.0,
            backgroundColor: ThemeCubit.get(context).isDark ? Colors.white : Colors.black,
            child: CircleAvatar(
              radius: 28.0,
              backgroundColor: Theme.of(context).colorScheme.primary,
              backgroundImage: NetworkImage('${model['image_profile']}'),
            ),
          ),
          const SizedBox(
            width: 20.0,
          ),
          Expanded(
            child: Text(
              '${model['full_name']}',
              maxLines: 1,
              style: const TextStyle(
                fontSize: 16.0,
                overflow: TextOverflow.ellipsis,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
          const SizedBox(
            width: 12.0,
          ),
          if(user?.senders?[model['uId']] == true)
          CircleAvatar(
            radius: 4.0,
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(
            width: 20.0,
          ),
          Icon(
            Icons.arrow_forward_ios_rounded,
            size: 20.0,
            color: ThemeCubit.get(context).isDark ? Colors.white : Colors.black,
          ),
        ],
      ),
    ),
  );


  dynamic showAlertRemove(BuildContext context, idChat, receiverId) {
    return showDialog(
      context: context,
      builder: (dialogContext) {
        HapticFeedback.vibrate();
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.0,),
          ),
          title: const Text(
            'Do you want to remove this chat ?',
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
                AppCubit.get(context).deleteChat(
                    idChat: idChat);
                if(AppCubit.get(context).numberNotice > 0) {
                  AppCubit.get(context).clearNotice(receiverId: receiverId);
                }
                Navigator.pop(dialogContext);
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
