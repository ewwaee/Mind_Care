
// ignore_for_file: deprecated_member_use

import 'package:doctor_app_fixed/theme/colors.dart';
import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  const MyButton({ super.key, required this.onTap, this.title = "", this.width = double.infinity, this.height = 45, this.bgColor = primary, this.icon, this.disableButton = true, this.isLoading = false});
  final GestureTapCallback onTap;
  final String title;
  final double width;
  final double height;
  final Color bgColor;
  final IconData? icon;
  final bool disableButton;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return 
      AbsorbPointer(
        absorbing: disableButton,
        child: GestureDetector(
          onTap: onTap,
          child:
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(13),
                color: disableButton ? Theme.of(context).colorScheme.primary: bgColor,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).shadowColor.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 3,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              width: width,
              height: height,
              child:
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: isLoading ?
                  [const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3,))] : 
                  (icon == null) ?
                    [
                      Text(title, style: TextStyle(color: disableButton ? Colors.white.withOpacity(0.3) : Colors.white, fontWeight: FontWeight.w600),)
                    ]
                    :
                    [
                      Icon(icon, size: 23, color: disableButton ? Colors.white.withOpacity(0.3) : Colors.white,),
                      const SizedBox(width: 5,),
                      Text(title, style: TextStyle(color: disableButton ? Colors.white.withOpacity(0.3) : Colors.white, fontWeight: FontWeight.w600),)
                    ]
              )
            ),
        ),
      )
      ;
  }
}
