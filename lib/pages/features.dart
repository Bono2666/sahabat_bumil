import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:sahabat_bumil_v2/main.dart';

class Features extends StatefulWidget {
  @override
  _FeaturesState createState() => _FeaturesState();
}

class _FeaturesState extends State<Features> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 7.0.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 19.0.h,),
                    Text(
                      'SEMUA FITUR',
                      style: TextStyle(
                        color: Theme.of(context).unselectedWidgetColor,
                        fontSize: 12.0.sp,
                      ),
                    ),
                    SizedBox(height: 3.1.h,),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.2.w),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 16.7.w,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {
                                    prefs.setRoute('/home');
                                    Navigator.pushNamed(context, '/monitoring');
                                  },
                                  child: Stack(
                                    alignment: AlignmentDirectional.center,
                                    children: [
                                      Container(
                                        width: 11.1.w,
                                        height: 11.1.w,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(30),
                                          ),
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                      Container(
                                        width: 5.6.w,
                                        height: 5.6.w,
                                        child: FittedBox(
                                          child: Image.asset(
                                            'images/ic_bumil.png',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 2.5.w,),
                                Text(
                                    'Pemantau',
                                  style: TextStyle(
                                    color: Theme.of(context).backgroundColor,
                                    fontSize: 10.0.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Spacer(),
                          SizedBox(
                            width: 16.7.w,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {
                                    prefs.setRoute('/home');
                                    Navigator.pushNamed(context, '/babysname');
                                  },
                                  child: Stack(
                                    alignment: AlignmentDirectional.center,
                                    children: [
                                      Container(
                                        width: 11.1.w,
                                        height: 11.1.w,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(30),
                                          ),
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                      Container(
                                        width: 5.6.w,
                                        height: 5.6.w,
                                        child: FittedBox(
                                          child: Image.asset(
                                            'images/ic_baby_white.png',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 2.5.w,),
                                Text(
                                  'Nama Bayi',
                                  style: TextStyle(
                                    color: Theme.of(context).backgroundColor,
                                    fontSize: 10.0.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Spacer(),
                          SizedBox(
                            width: 16.7.w,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {
                                    prefs.setRoute('/home');
                                    prefs.setGoRoute('/home');
                                    if (prefs.getBasecount == '')
                                      Navigator.pushNamed(context, '/addpregnancy');
                                    else
                                      Navigator.pushNamed(context, '/updpregnancy');
                                  },
                                  child: Stack(
                                    alignment: AlignmentDirectional.center,
                                    children: [
                                      Container(
                                        width: 11.1.w,
                                        height: 11.1.w,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(30),
                                          ),
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                      Container(
                                        width: 5.6.w,
                                        height: 5.6.w,
                                        child: FittedBox(
                                          child: Image.asset(
                                            'images/ic_profil.png',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 2.5.w,),
                                Text(
                                  'Profil',
                                  style: TextStyle(
                                    color: Theme.of(context).backgroundColor,
                                    fontSize: 10.0.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Spacer(),
                          SizedBox(
                            width: 16.7.w,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {
                                    prefs.setRoute('/home');
                                    Navigator.pushNamed(context, '/aqiqah');
                                  },
                                  child: Stack(
                                    alignment: AlignmentDirectional.center,
                                    children: [
                                      Container(
                                        width: 11.1.w,
                                        height: 11.1.w,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(30),
                                          ),
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                      Container(
                                        width: 5.6.w,
                                        height: 5.6.w,
                                        child: FittedBox(
                                          child: Image.asset(
                                            'images/ic_aqiqah.png',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 2.5.w,),
                                Text(
                                  'Aqiqah',
                                  style: TextStyle(
                                    color: Theme.of(context).backgroundColor,
                                    fontSize: 10.0.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        height: 4.0.h,
                        color: Colors.white,
                      ),
                      Container(
                        height: 11.0.h,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.white, Colors.white.withOpacity(0.0),
                            ],
                          )
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () async {
                      return Navigator.pop(context);
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
                              Icons.arrow_back_ios_new_rounded,
                              color: Colors.white,
                              size: 5.2.w,
                            ),
                          ),
                        ],
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