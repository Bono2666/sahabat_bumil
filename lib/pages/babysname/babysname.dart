import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:sahabat_bumil_v2/main.dart';

class BabysName extends StatefulWidget {
  @override
  _BabysNameState createState() => _BabysNameState();
}

class _BabysNameState extends State<BabysName> {
  String sextype;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(6.7.w, 19.0.h, 6.7.w, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Generator Nama',
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
                      'Inspirasi nama bayi Islami',
                      style: TextStyle(
                        fontSize: 10.0.sp,
                        fontWeight: FontWeight.w700,
                        color:
                        Theme.of(context).backgroundColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.4.h,),
                Text(
                  'Jenis Kelamin',
                  style: TextStyle(
                    fontSize: 13.0.sp,
                    color: Theme.of(context).backgroundColor,
                  ),
                ),
                SizedBox(height: 1.0.h,),
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Theme.of(context).shadowColor,
                                    blurRadius: 8,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(8.8.w, 4.4.w, 8.8.w, 5.2.w),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'images/ic_gender.png',
                                      width: 4.2.w,
                                    ),
                                    SizedBox(width: 6.0.w,),
                                    Text(
                                      'Jenis Kelamin',
                                      style: TextStyle(
                                        fontSize: 17.0.sp,
                                        color: Theme.of(context).backgroundColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 3.0.h,),
                            Column(
                              children: [
                                Container(
                                  child: ListTile(
                                    title: Text(
                                      'Laki-laki',
                                      style: TextStyle(
                                        fontSize: 13.0.sp,
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.fromLTRB(8.8.w,3.4.w,8.8.w,3.2.w),
                                    onTap: () {
                                      setState(() {
                                        sextype = 'Laki-laki';
                                        Navigator.pop(context);
                                      });
                                    },
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      top: BorderSide(
                                        color: Theme.of(context).dividerColor,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  child: ListTile(
                                    title: Text(
                                      'Perempuan',
                                      style: TextStyle(
                                        fontSize: 13.0.sp,
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.fromLTRB(8.8.w,3.4.w,8.8.w,3.2.w),
                                    onTap: () {
                                      setState(() {
                                        sextype = 'Perempuan';
                                        Navigator.pop(context);
                                      });
                                    },
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      top: BorderSide(
                                        color: Theme.of(context).dividerColor,
                                      ),
                                      bottom: BorderSide(
                                        color: Theme.of(context).dividerColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 4.4.h,)
                          ],
                        );
                      },
                    );
                  },
                  child: Container(
                    height: 4.8.h,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Text(
                            sextype == null ? '' : sextype,
                            style: TextStyle(
                              fontSize: 15.0.sp,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 2.2.w,
                          child: Image.asset(
                            'images/ic_down_arrow.png',
                          ),
                        ),
                        SizedBox(width: 2.2.w,)
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 3.3.h,),
                Text(
                  'Kriteria Nama Depan',
                  style: TextStyle(
                    fontSize: 13.0.sp,
                    color: Theme.of(context).backgroundColor,
                  ),
                ),
                SizedBox(height: 1.0.h,),
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Theme.of(context).shadowColor,
                                    blurRadius: 8,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(8.8.w, 4.4.w, 8.8.w, 5.2.w),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'images/ic_gender.png',
                                      width: 4.2.w,
                                    ),
                                    SizedBox(width: 6.0.w,),
                                    Text(
                                      'Jenis Kelamin',
                                      style: TextStyle(
                                        fontSize: 17.0.sp,
                                        color: Theme.of(context).backgroundColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 3.0.h,),
                            Column(
                              children: [
                                Container(
                                  child: ListTile(
                                    title: Text(
                                      'Laki-laki',
                                      style: TextStyle(
                                        fontSize: 13.0.sp,
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.fromLTRB(8.8.w,3.4.w,8.8.w,3.2.w),
                                    onTap: () {
                                      setState(() {
                                        sextype = 'Laki-laki';
                                        Navigator.pop(context);
                                      });
                                    },
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      top: BorderSide(
                                        color: Theme.of(context).dividerColor,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  child: ListTile(
                                    title: Text(
                                      'Perempuan',
                                      style: TextStyle(
                                        fontSize: 13.0.sp,
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.fromLTRB(8.8.w,3.4.w,8.8.w,3.2.w),
                                    onTap: () {
                                      setState(() {
                                        sextype = 'Perempuan';
                                        Navigator.pop(context);
                                      });
                                    },
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      top: BorderSide(
                                        color: Theme.of(context).dividerColor,
                                      ),
                                      bottom: BorderSide(
                                        color: Theme.of(context).dividerColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 4.4.h,)
                          ],
                        );
                      },
                    );
                  },
                  child: Container(
                    height: 4.8.h,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Text(
                            sextype == null ? '' : sextype,
                            style: TextStyle(
                              fontSize: 15.0.sp,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 2.2.w,
                          child: Image.asset(
                            'images/ic_down_arrow.png',
                          ),
                        ),
                        SizedBox(width: 2.2.w,)
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 3.3.h,),
                Text(
                  'Kriteria Nama Tengah',
                  style: TextStyle(
                    fontSize: 13.0.sp,
                    color: Theme.of(context).backgroundColor,
                  ),
                ),
                SizedBox(height: 1.0.h,),
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Theme.of(context).shadowColor,
                                    blurRadius: 8,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(8.8.w, 4.4.w, 8.8.w, 5.2.w),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'images/ic_gender.png',
                                      width: 4.2.w,
                                    ),
                                    SizedBox(width: 6.0.w,),
                                    Text(
                                      'Jenis Kelamin',
                                      style: TextStyle(
                                        fontSize: 17.0.sp,
                                        color: Theme.of(context).backgroundColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 3.0.h,),
                            Column(
                              children: [
                                Container(
                                  child: ListTile(
                                    title: Text(
                                      'Laki-laki',
                                      style: TextStyle(
                                        fontSize: 13.0.sp,
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.fromLTRB(8.8.w,3.4.w,8.8.w,3.2.w),
                                    onTap: () {
                                      setState(() {
                                        sextype = 'Laki-laki';
                                        Navigator.pop(context);
                                      });
                                    },
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      top: BorderSide(
                                        color: Theme.of(context).dividerColor,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  child: ListTile(
                                    title: Text(
                                      'Perempuan',
                                      style: TextStyle(
                                        fontSize: 13.0.sp,
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.fromLTRB(8.8.w,3.4.w,8.8.w,3.2.w),
                                    onTap: () {
                                      setState(() {
                                        sextype = 'Perempuan';
                                        Navigator.pop(context);
                                      });
                                    },
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      top: BorderSide(
                                        color: Theme.of(context).dividerColor,
                                      ),
                                      bottom: BorderSide(
                                        color: Theme.of(context).dividerColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 4.4.h,)
                          ],
                        );
                      },
                    );
                  },
                  child: Container(
                    height: 4.8.h,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Text(
                            sextype == null ? '' : sextype,
                            style: TextStyle(
                              fontSize: 15.0.sp,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 2.2.w,
                          child: Image.asset(
                            'images/ic_down_arrow.png',
                          ),
                        ),
                        SizedBox(width: 2.2.w,)
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 3.3.h,),
                Text(
                  'Kriteria Nama Belakang',
                  style: TextStyle(
                    fontSize: 13.0.sp,
                    color: Theme.of(context).backgroundColor,
                  ),
                ),
                SizedBox(height: 1.0.h,),
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Theme.of(context).shadowColor,
                                    blurRadius: 8,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(8.8.w, 4.4.w, 8.8.w, 5.2.w),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'images/ic_gender.png',
                                      width: 4.2.w,
                                    ),
                                    SizedBox(width: 6.0.w,),
                                    Text(
                                      'Jenis Kelamin',
                                      style: TextStyle(
                                        fontSize: 17.0.sp,
                                        color: Theme.of(context).backgroundColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 3.0.h,),
                            Column(
                              children: [
                                Container(
                                  child: ListTile(
                                    title: Text(
                                      'Laki-laki',
                                      style: TextStyle(
                                        fontSize: 13.0.sp,
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.fromLTRB(8.8.w,3.4.w,8.8.w,3.2.w),
                                    onTap: () {
                                      setState(() {
                                        sextype = 'Laki-laki';
                                        Navigator.pop(context);
                                      });
                                    },
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      top: BorderSide(
                                        color: Theme.of(context).dividerColor,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  child: ListTile(
                                    title: Text(
                                      'Perempuan',
                                      style: TextStyle(
                                        fontSize: 13.0.sp,
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.fromLTRB(8.8.w,3.4.w,8.8.w,3.2.w),
                                    onTap: () {
                                      setState(() {
                                        sextype = 'Perempuan';
                                        Navigator.pop(context);
                                      });
                                    },
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      top: BorderSide(
                                        color: Theme.of(context).dividerColor,
                                      ),
                                      bottom: BorderSide(
                                        color: Theme.of(context).dividerColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 4.4.h,)
                          ],
                        );
                      },
                    );
                  },
                  child: Container(
                    height: 4.8.h,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Text(
                            sextype == null ? '' : sextype,
                            style: TextStyle(
                              fontSize: 15.0.sp,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 2.2.w,
                          child: Image.asset(
                            'images/ic_down_arrow.png',
                          ),
                        ),
                        SizedBox(width: 2.2.w,)
                      ],
                    ),
                  ),
                ),
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
              Stack(
                alignment: AlignmentDirectional.bottomEnd,
                children: [
                  InkWell(
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
