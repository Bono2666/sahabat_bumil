// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sahabat_bumil_v2/db/fav_db.dart';
import 'package:sahabat_bumil_v2/model/fav_model.dart';
import 'package:sizer/sizer.dart';
import 'package:sahabat_bumil_v2/main.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_html/flutter_html.dart';

String parID, currCat, popTitle, oldSexType, pilih, col;
String prefix = 'Acak';
String middle = 'Acak';
String sufix = 'Acak';
String sextype = prefs.getSextype.isNotEmpty ? prefs.getSextype : '';

class BabysName extends StatefulWidget {
  @override
  _BabysNameState createState() => _BabysNameState();
}

class _BabysNameState extends State<BabysName> {
  @override
  void initState() {
    super.initState();

    if (oldSexType != null) if (prefs.getSextype != oldSexType) {
      sextype = prefs.getSextype;
      prefix = 'Acak';
      middle = 'Acak';
      sufix = 'Acak';
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        prefix = 'Acak';
        middle = 'Acak';
        sufix = 'Acak';
        sextype = prefs.getSextype.isNotEmpty ? prefs.getSextype : '';
        Navigator.pushReplacementNamed(context, prefs.getRoute);
        return;
      },
      child: Scaffold(
        body: Stack(
          children: [
            Column(
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
                        crossAxisAlignment: CrossAxisAlignment.center,
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
                              color: Theme.of(context).backgroundColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 4.4.h,
                      ),
                      Text(
                        'Jenis Kelamin',
                        style: TextStyle(
                          fontSize: 13.0.sp,
                          color: Theme.of(context).backgroundColor,
                        ),
                      ),
                      SizedBox(
                        height: 1.0.h,
                      ),
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
                                      padding: EdgeInsets.fromLTRB(
                                          8.8.w, 4.4.w, 8.8.w, 5.2.w),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'images/ic_gender.png',
                                            width: 4.2.w,
                                          ),
                                          SizedBox(
                                            width: 6.0.w,
                                          ),
                                          Text(
                                            'Jenis Kelamin',
                                            style: TextStyle(
                                              fontSize: 17.0.sp,
                                              color: Theme.of(context)
                                                  .backgroundColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 3.0.h,
                                  ),
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
                                          contentPadding: EdgeInsets.fromLTRB(
                                              8.8.w, 3.4.w, 8.8.w, 3.2.w),
                                          onTap: () {
                                            setState(() {
                                              sextype = 'Laki-laki';
                                              prefix = 'Acak';
                                              middle = 'Acak';
                                              sufix = 'Acak';
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
                                          contentPadding: EdgeInsets.fromLTRB(
                                              8.8.w, 3.4.w, 8.8.w, 3.2.w),
                                          onTap: () {
                                            setState(() {
                                              sextype = 'Perempuan';
                                              prefix = 'Acak';
                                              middle = 'Acak';
                                              sufix = 'Acak';
                                              Navigator.pop(context);
                                            });
                                          },
                                        ),
                                        decoration: BoxDecoration(
                                          border: Border(
                                            top: BorderSide(
                                              color:
                                                  Theme.of(context).dividerColor,
                                            ),
                                            bottom: BorderSide(
                                              color:
                                                  Theme.of(context).dividerColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 4.4.h,
                                  )
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
                                color: Theme.of(context).secondaryHeaderColor,
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Text(
                                  sextype,
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
                              SizedBox(
                                width: 2.2.w,
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 3.3.h,
                      ),
                      Text(
                        'Kriteria Nama Depan',
                        style: TextStyle(
                          fontSize: 13.0.sp,
                          color: Theme.of(context).backgroundColor,
                        ),
                      ),
                      SizedBox(
                        height: 1.0.h,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          if (sextype == '') {
                            showDialog(
                              context: context,
                              builder: (_) => Alert(),
                              barrierDismissible: false,
                            );
                          } else {
                            parID = sextype == 'Laki-laki' ? '11' : '21';
                            currCat = prefix;
                            col = 'fav_prefix';
                            popTitle = 'Kriteria Nama Depan';
                            showDialog(
                              context: context,
                              builder: (_) => Criteria(),
                              barrierDismissible: false,
                            );
                          }
                        },
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Html(
                                    data: prefix,
                                    style: {
                                      'body': Style(
                                        fontSize: FontSize(15.0.sp),
                                        padding: EdgeInsets.all(0),
                                      ),
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 2.2.w,
                                  child: Image.asset(
                                    'images/ic_down_arrow.png',
                                  ),
                                ),
                                SizedBox(
                                  width: 4.0.w,
                                )
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 1.4.w),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color:
                                          Theme.of(context).secondaryHeaderColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 3.3.h,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 1.4.w),
                        child: Text(
                          'Kriteria Nama Tengah',
                          style: TextStyle(
                            fontSize: 13.0.sp,
                            color: Theme.of(context).backgroundColor,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 1.0.h,
                      ),
                      InkWell(
                        onTap: () {
                          if (sextype == '') {
                            showDialog(
                              context: context,
                              builder: (_) => Alert(),
                              barrierDismissible: false,
                            );
                          } else {
                            parID = sextype == 'Laki-laki' ? '12' : '22';
                            currCat = middle;
                            col = 'fav_middle';
                            popTitle = 'Kriteria Nama Tengah';
                            showDialog(
                              context: context,
                              builder: (_) => Criteria(),
                              barrierDismissible: false,
                            );
                          }
                        },
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Html(
                                    data: middle,
                                    style: {
                                      'body': Style(
                                        fontSize: FontSize(15.0.sp),
                                        padding: EdgeInsets.all(0),
                                      ),
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 2.2.w,
                                  child: Image.asset(
                                    'images/ic_down_arrow.png',
                                  ),
                                ),
                                SizedBox(
                                  width: 4.0.w,
                                )
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 1.4.w),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color:
                                          Theme.of(context).secondaryHeaderColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 3.3.h,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 1.4.w),
                        child: Text(
                          'Kriteria Nama Belakang',
                          style: TextStyle(
                            fontSize: 13.0.sp,
                            color: Theme.of(context).backgroundColor,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 1.0.h,
                      ),
                      InkWell(
                        onTap: () {
                          if (sextype == '') {
                            showDialog(
                              context: context,
                              builder: (_) => Alert(),
                              barrierDismissible: false,
                            );
                          } else {
                            parID = sextype == 'Laki-laki' ? '13' : '23';
                            currCat = sufix;
                            col = 'fav_sufix';
                            popTitle = 'Kriteria Nama Belakang';
                            showDialog(
                              context: context,
                              builder: (_) => Criteria(),
                              barrierDismissible: false,
                            );
                          }
                        },
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Html(
                                    data: sufix,
                                    style: {
                                      'body': Style(
                                        fontSize: FontSize(15.0.sp),
                                        padding: EdgeInsets.all(0),
                                      ),
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 2.2.w,
                                  child: Image.asset(
                                    'images/ic_down_arrow.png',
                                  ),
                                ),
                                SizedBox(
                                  width: 4.0.w,
                                )
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 1.4.w),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color:
                                          Theme.of(context).secondaryHeaderColor,
                                    ),
                                  ),
                                ),
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
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        prefix = 'Acak';
                        middle = 'Acak';
                        sufix = 'Acak';
                        sextype =
                            prefs.getSextype.isNotEmpty ? prefs.getSextype : '';
                        Navigator.pushReplacementNamed(context, prefs.getRoute);
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
                          oldSexType = prefs.getSextype;
                          Navigator.pushReplacementNamed(
                              context, '/updpregnancy');
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
                      onTap: () {
                        if (sextype == '') {
                          showDialog(
                            context: context,
                            builder: (_) => Alert(),
                            barrierDismissible: false,
                          );
                        } else {
                          prefs.setSexTypeName(sextype);
                          prefs.setPrefix(prefix);
                          prefs.setMiddle(middle);
                          prefs.setSufix(sufix);
                          Navigator.pushNamed(context, '/nameresult');
                        }
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
                                  fontSize: 13.0.sp,
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
                        onTap: () {
                          Navigator.pushNamed(context, '/namecollection');
                        },
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
                                    fontSize: 13.0.sp,
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
      ),
    );
  }
}

class Criteria extends StatefulWidget {
  @override
  _CriteriaState createState() => _CriteriaState();
}

class _CriteriaState extends State<Criteria>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> scaleAnimation;
  List<QueryDocumentSnapshot> babysname;
  String selected;
  var dbCat = FavDb();

  @override
  void initState() {
    super.initState();

    selected = null;

    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    scaleAnimation = CurvedAnimation(
      parent: controller,
      curve: Curves.elasticInOut,
    );

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // future: db.list(parID),
      future: dbCat.listCatDrop(sextype, col),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == null || snapshot.hasError) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SpinKitPulse(
                color: Theme.of(context).primaryColor,
              ),
            ],
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          print('Criteria: ' + snapshot.data.length.toString() + ' records');
        }
        return ScaleTransition(
          scale: scaleAnimation,
          child: Material(
            color: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 91.0.w,
                  height: 88.0.h,
                  constraints: BoxConstraints(
                    minHeight: 24.0.w,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(40),
                    ),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).dialogBackgroundColor,
                        blurRadius: 24,
                        offset: Offset(0, 24),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 6.7.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 11.0.h,
                                  child: Stack(
                                    alignment:
                                        AlignmentDirectional.bottomCenter,
                                    children: [
                                      SizedBox(
                                        height: 19.0.w,
                                        child: Padding(
                                          padding:
                                              EdgeInsets.only(left: 19.0.w),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                popTitle,
                                                style: TextStyle(
                                                  fontSize: 13.0.sp,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 3.1.h,),
                                Text(
                                  'Pilih Kriteria',
                                  style: TextStyle(
                                    color: Theme.of(context).backgroundColor,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 24.0.sp,
                                  ),
                                ),
                                SizedBox(height: 0.6.h,),
                                Text(
                                  'Gulirkan ke bawah untuk melihat kriteria',
                                  style: TextStyle(
                                    fontSize: 10.0.sp,
                                    fontWeight: FontWeight.w700,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                SizedBox(height: 4.4.h,),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5.2.w, right: 6.7.w),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 68.0.w,
                                      child: Html(
                                        data: currCat,
                                        style: {
                                          'body': Style(
                                            fontSize: FontSize(17.0.sp),
                                            color:
                                                Theme.of(context).disabledColor,
                                            padding: EdgeInsets.all(0),
                                          ),
                                        },
                                      ),
                                    ),
                                    Expanded(child: SizedBox(),),
                                    Image.asset(
                                      'images/ic_discheck.png',
                                      height: 8.9.w,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4.4.w,),
                                Padding(
                                  padding: EdgeInsets.only(left: 1.6.w),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Theme.of(context)
                                              .secondaryHeaderColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: SizedBox(
                              child: ListView.builder(
                                itemCount: snapshot.data.length,
                                physics: BouncingScrollPhysics(),
                                padding: EdgeInsets.only(left: 5.2.w, right: 5.2.w, bottom: 14.0.h),
                                itemBuilder: (context, index) {
                                  Fav criteriaItem = Fav.get(snapshot.data[index]);
                                  return criteriaItem.favCat == currCat
                                      ? Container()
                                      : InkWell(
                                          onTap: () => setState(() =>
                                              selected = criteriaItem.favCat),
                                          child: Column(
                                            children: [
                                              SizedBox(height: 4.4.w,),
                                              Padding(padding: EdgeInsets.only(right: 1.6.w),
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Expanded(
                                                      child: SizedBox(
                                                        child: Html(
                                                          data: criteriaItem.favCat,
                                                          style: {
                                                            'body': Style(
                                                              fontSize: FontSize(17.0.sp),
                                                              color: Theme.of(context).backgroundColor,
                                                              padding: EdgeInsets.all(0),
                                                            ),
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                    // Expanded(child: SizedBox(),),
                                                    Image.asset(
                                                      criteriaItem.favCat == selected
                                                          ? 'images/ic_checked.png'
                                                          : 'images/ic_radio.png',
                                                      height: 8.9.w,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 4.4.w,),
                                              Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 1.6.w),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    border: Border(
                                                      bottom: BorderSide(
                                                        color: Theme.of(context)
                                                            .secondaryHeaderColor,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                },
                              ),
                            ),
                          ),
                        ],
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
                                  height: 11.0.h,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(40),
                                      topLeft: Radius.circular(40),
                                    ),
                                  ),
                                  child: Stack(
                                    alignment:
                                        AlignmentDirectional.bottomCenter,
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
                            ],
                          ),
                          Expanded(child: SizedBox()),
                          Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              Column(
                                children: [
                                  Container(
                                    height: 12.0.h,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.vertical(
                                          bottom: Radius.circular(40),
                                        ),
                                        gradient: LinearGradient(
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                          colors: [
                                            Colors.white,
                                            Colors.white.withOpacity(0.0),
                                          ],
                                        )),
                                  ),
                                ],
                              ),
                              InkWell(
                                onTap: () {
                                  if (selected != null) {
                                    switch (parID.substring(1, 2)) {
                                      case '1':
                                        prefix = selected;
                                        break;
                                      case '2':
                                        middle = selected;
                                        break;
                                      case '3':
                                        sufix = selected;
                                        break;
                                    }
                                    Navigator.pushReplacement(
                                        context,
                                        new PageRouteBuilder(
                                          pageBuilder: (context, animation,
                                                  secondaryAnimation) =>
                                              BabysName(),
                                          transitionDuration: Duration.zero,
                                        ));
                                  }
                                },
                                child: Container(
                                  width: 37.0.w,
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
                                      'Pilih',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13.0.sp,
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
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class Alert extends StatefulWidget {
  @override
  _AlertState createState() => _AlertState();
}

class _AlertState extends State<Alert> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    scaleAnimation = CurvedAnimation(
      parent: controller,
      curve: Curves.elasticInOut,
    );

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scaleAnimation,
      child: Material(
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80.0.w,
              constraints: BoxConstraints(
                minHeight: 24.0.w,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(24),
                ),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).dialogBackgroundColor,
                    blurRadius: 24,
                    offset: Offset(0, 24),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(7.8.w, 5.0.h, 7.8.w, 3.0.h),
                child: Column(
                  children: [
                    Text(
                      'Ayah/Bunda belum memilih Jenis Kelamin, silahkan pilih Jenis Kelaminnya dulu ya',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Theme.of(context).backgroundColor,
                        fontFamily: 'Ubuntu',
                        fontWeight: FontWeight.w400,
                        fontSize: 13.0.sp,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 7.0.w,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Ink(
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: 14.8.w,
                              height: 14.8.w,
                              child: Image.asset(
                                'images/ic_ok.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
