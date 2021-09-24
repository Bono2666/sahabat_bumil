import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:sahabat_bumil_v2/main.dart';

class BabysName extends StatefulWidget {
  @override
  _BabysNameState createState() => _BabysNameState();
}

class _BabysNameState extends State<BabysName> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(6.7.w, 19.0.h, 6.7.w, 0),
            child: Column(
              children: [
                Text(
                  'Generator Nama',
                  style: TextStyle(
                    color: Theme.of(context).backgroundColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 24.0.sp,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/monitoring');
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
                              Icons.close,
                              color: Colors.white,
                              size: 7.0.w,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(child: SizedBox()),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 5.6.h, 6.6.w, 0),
                    child: InkWell(
                      onTap: () {
                        prefs.setRoute('/babysname');
                        Navigator.pushReplacementNamed(context, '/updpregnancy');
                      },
                      child: Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          Opacity(
                            opacity: .8,
                            child: Container(
                              width: 12.5.w,
                              height: 12.5.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(30),
                                ),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 6.0,
                                    color: Theme.of(context).shadowColor,
                                    offset: Offset(0, 3),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: 5.6.w,
                            height: 5.6.w,
                            child: FittedBox(
                              child: Image.asset(
                                'images/ic_menu.png',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(child: SizedBox()),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    child: Container(
                      width: 74.0.w,
                      height: 12.0.h,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Cari Nama',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 15.0.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
