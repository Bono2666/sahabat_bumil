import 'package:flutter/material.dart';
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
          Padding(
            padding: EdgeInsets.only(left: 6.7.w, top: 19.0.h, right: 6.7.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Rekomendasi Nama',
                  style: TextStyle(
                    color: Theme.of(context).backgroundColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 24.0.sp,
                  ),
                ),
                SizedBox(height: 1.9.h,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment:
                  CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'images/ic_baby.png',
                      height: 3.2.w,
                    ),
                    SizedBox(
                      width: 1.4.w,
                    ),
                    Text(
                      'Rekomendasi nama bayi Anda',
                      style: TextStyle(
                        fontSize: 10.0.sp,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).backgroundColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.4.h,),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
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
              Expanded(child: SizedBox()),
              Stack(
                alignment: AlignmentDirectional.bottomEnd,
                children: [
                  InkWell(
                    onTap: () {

                    },
                    child: Stack(
                      alignment: AlignmentDirectional.centerEnd,
                      children: [
                        Container(
                          width: 52.0.w,
                          height: 12.0.h,
                          color: Theme.of(context).primaryColor,
                        ),
                        SizedBox(
                          width: 40.0.w,
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
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 40.0.w),
                    child: InkWell(
                      child: Stack(
                        alignment: AlignmentDirectional.centerEnd,
                        children: [
                          Container(
                            width: 43.0.w,
                            height: 12.0.h,
                            decoration: BoxDecoration(
                              color: Theme.of(context).backgroundColor,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(40),
                                bottomRight: Radius.circular(40),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Pilih Sendiri',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15.0.sp,
                                ),
                              ),
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
