
import 'package:doctor_app_fixed/data/json.dart';
import 'package:doctor_app_fixed/theme/colors.dart';
import 'package:doctor_app_fixed/widgets/avatar_image.dart';
import 'package:doctor_app_fixed/widgets/chat_item.dart';
import 'package:doctor_app_fixed/widgets/textbox.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as custom_badge;


class ChatPage extends StatefulWidget {
  const ChatPage({ super.key });

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Chat Room", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
        actions: const [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Icon(
              Icons.more_vert_outlined,
              color: Colors.black,
            ),
          )
        ],
      ),
      body: getBody(),
    );
  }

  getBody(){
    return
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomTextBox(),
                const SizedBox(height: 20,),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(chatsData.length, (index) => 
                     Padding(
                       padding: const EdgeInsets.only(right: 10),
                       child: custom_badge.Badge(
                        badgeStyle: const custom_badge.BadgeStyle(
                          badgeColor: Colors.green,
                          borderSide: BorderSide(color: Colors.white),
  ),
                      position: custom_badge.BadgePosition.topEnd(top: -3, end: 0),
  badgeContent: const Text(''),
  child: AvatarImage(chatsData[index]["image"].toString()),
)

                     ) 
                    )
                  ),
                ),
                const SizedBox(height: 20,),
                getChatList()
              ]
          )
        )
      );
  }

  getChatList(){
    return 
      Column(
        children: List.generate(
          chatsData.length,
         (index) => ChatItem(chatsData[index])
        )
      );
  }
}