import 'package:flutter/material.dart';
import 'package:sahabat_bumil_v2/main.dart';
import 'package:sizer/sizer.dart';

class NameResult extends StatefulWidget {
  @override
  _NameResultState createState() => _NameResultState();
}

class _NameResultState extends State<NameResult> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      prefs.getSexTypeName
                  ),
                  Text(
                    prefs.getPrefix
                  ),
                  Text(
                      prefs.getMiddle
                  ),
                  Text(
                      prefs.getSufix
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              width: 19.0.w,
              height: 15.0.h,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: [
                  SizedBox(
                    width: 19.0.w,
                    height: 19.0.w,
                    child: Icon(
                      Icons.arrow_back_ios_rounded,
                      color: Colors.white,
                      size: 7.0.w,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
