import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:sahabat_bumil_v2/main.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class NameResult extends StatefulWidget {
  @override
  _NameResultState createState() => _NameResultState();
}

class _NameResultState extends State<NameResult> {
  List<QueryDocumentSnapshot> prefixResult, middleResult, sufixResult;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: prefs.getPrefix == 'Acak' || prefs.getPrefix.substring(0, 4) == 'Diaw'
            ? FirebaseFirestore.instance
            .collection('babysname')
            .where('sex', isEqualTo: prefs.getSexTypeName)
            .where('prefix', isEqualTo: true)
            .get()
            : FirebaseFirestore.instance
            .collection('babysname')
            .where('sex', isEqualTo: prefs.getSexTypeName)
            .where('prefix', isEqualTo: true)
            .where('category', isEqualTo: prefs.getPrefix)
            .get(),
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
            prefixResult = snapshot.data.docs;
            prefixResult.shuffle();

            String prefixName = prefixResult[0].get('name').toString();

            if (prefs.getPrefix.substring(0, 4) == 'Diaw') {
              while (prefixResult[0].get('category') == 'Acak'
                  || prefixResult[0].get('category') == 'Tidak pakai'
                  || prefixResult[0].get('status') == 'delete'
                  || prefixName.substring(0, 1)
                      != prefs.getPrefix.substring(prefs.getPrefix.length - 1)) {
                prefixResult.shuffle();
                prefixName = prefixResult[0].get('name').toString();
              }
            } else if (prefs.getPrefix == 'Acak') {
              while (prefixResult[0].get('category') == 'Acak'
                  || prefixResult[0].get('category') == 'Tidak pakai'
                  || prefixResult[0].get('status') == 'delete'
                  || prefixResult[0].get('category') == prefs.getMiddle
                  || prefixResult[0].get('category') == prefs.getSufix)
                prefixResult.shuffle();
            } else if (prefs.getPrefix != 'Tidak pakai') {
              while (prefixResult[0].get('category') == 'Acak'
                  || prefixResult[0].get('status') == 'delete'
                  || prefixResult[0].get('category') == 'Tidak pakai')
                prefixResult.shuffle();
            }
          }
          return FutureBuilder(
            future: prefs.getMiddle == 'Acak' || prefs.getMiddle.substring(0, 4) == 'Diaw'
                ? FirebaseFirestore.instance
                .collection('babysname')
                .where('sex', isEqualTo: prefs.getSexTypeName)
                .where('middle', isEqualTo: true)
                .get()
                : FirebaseFirestore.instance
                .collection('babysname')
                .where('sex', isEqualTo: prefs.getSexTypeName)
                .where('middle', isEqualTo: true)
                .where('category', isEqualTo: prefs.getMiddle)
                .get(),
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
                middleResult = snapshot.data.docs;
                middleResult.shuffle();

                String middleName = middleResult[0].get('name').toString();

                if (prefs.getMiddle.substring(0, 4) == 'Diaw') {
                  while (middleResult[0].get('category') == 'Acak'
                      || middleResult[0].get('category') == 'Tidak pakai'
                      || middleResult[0].get('status') == 'delete'
                      || middleResult[0].get('category') == prefixResult[0].get('category')
                      || middleName.substring(0, 1)
                          != prefs.getMiddle.substring(prefs.getMiddle.length - 1)) {
                    middleResult.shuffle();
                    middleName = middleResult[0].get('name').toString();
                  }
                } else if (prefs.getMiddle == 'Acak') {
                  while (middleResult[0].get('category') == 'Acak'
                      || middleResult[0].get('category') == 'Tidak pakai'
                      || middleResult[0].get('status') == 'delete'
                      || middleResult[0].get('category') ==
                          prefixResult[0].get('category')
                      || middleResult[0].get('category') == prefs.getSufix)
                    middleResult.shuffle();
                } else if (prefs.getMiddle != 'Tidak pakai') {
                  while (middleResult[0].get('category') == 'Acak'
                      || middleResult[0].get('status') == 'delete'
                      || middleResult[0].get('category') == 'Tidak pakai')
                    middleResult.shuffle();
                }
              }
              return FutureBuilder(
                future: prefs.getSufix == 'Acak' || prefs.getSufix.substring(0, 4) == 'Diaw'
                    ? FirebaseFirestore.instance
                    .collection('babysname')
                    .where('sex', isEqualTo: prefs.getSexTypeName)
                    .where('sufix', isEqualTo: true)
                    .get()
                    : FirebaseFirestore.instance
                    .collection('babysname')
                    .where('sex', isEqualTo: prefs.getSexTypeName)
                    .where('sufix', isEqualTo: true)
                    .where('category', isEqualTo: prefs.getSufix)
                    .get(),
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
                    sufixResult = snapshot.data.docs;
                    sufixResult.shuffle();

                    String sufixName = sufixResult[0].get('name').toString();

                    if (prefs.getSufix.substring(0, 4) == 'Diaw') {
                      while (sufixResult[0].get('category') == 'Acak'
                          || sufixResult[0].get('category') == 'Tidak pakai'
                          || sufixResult[0].get('status') == 'delete'
                          || sufixResult[0].get('category') == prefixResult[0].get('category')
                          || sufixResult[0].get('category') == middleResult[0].get('category')
                          || sufixName.substring(0, 1)
                              != prefs.getSufix.substring(prefs.getSufix.length - 1)) {
                        sufixResult.shuffle();
                        sufixName = sufixResult[0].get('name').toString();
                      }
                    } else if (prefs.getSufix == 'Acak') {
                      while (sufixResult[0].get('category') == 'Acak'
                          || sufixResult[0].get('category') == 'Tidak pakai'
                          || sufixResult[0].get('status') == 'delete'
                          || sufixResult[0].get('category') ==
                              prefixResult[0].get('category')
                          || sufixResult[0].get('category') ==
                              middleResult[0].get('category'))
                        sufixResult.shuffle();
                    } else if (prefs.getSufix != 'Tidak pakai') {
                      while (sufixResult[0].get('category') == 'Acak'
                          || sufixResult[0].get('status') == 'delete'
                          || sufixResult[0].get('category') == 'Tidak pakai')
                        sufixResult.shuffle();
                    }
                  }
                  return Stack(
                    children: [
                      SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 6.7.w, top: 19.0.h, right: 6.7.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Rekomendasi Nama',
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.background,
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
                                          color: Theme.of(context).colorScheme.background,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 4.4.h,),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 6.7.w,),
                              child: Text(
                                (prefs.getPrefix == 'Tidak pakai'
                                    ? '' : prefixResult[0].get('name') + ' ') +
                                    (prefs.getMiddle == 'Tidak pakai'
                                        ? '' : middleResult[0].get('name') + ' ') +
                                    (prefs.getSufix == 'Tidak pakai'
                                        ? '' : sufixResult[0].get('name')),
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20.0.sp,
                                ),
                              ),
                            ),
                            SizedBox(height: 3.4.h,),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4.8.w),
                              child: prefs.getPrefix == 'Tidak pakai'
                                  ? Container()
                                  : Html(
                                    data: '<span>' + prefixResult[0].get('name')
                                        + '</span> artinya ' + prefixResult[0].get('desc'),
                                    style: {
                                      'body': Style(
                                        fontSize: FontSize(13.0.sp),
                                        color: Theme.of(context).colorScheme.background,
                                        lineHeight: LineHeight.em(1.1),
                                      ),
                                      'span': Style(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    },
                                  ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4.8.w,),
                              child: prefs.getMiddle == 'Tidak pakai'
                                  ? Container()
                                  : Html(
                                    data: '<span>' + middleResult[0].get('name')
                                        + '</span> artinya ' + middleResult[0].get('desc'),
                                    style: {
                                      'body': Style(
                                        fontSize: FontSize(13.0.sp),
                                        color: Theme.of(context).colorScheme.background,
                                        lineHeight: LineHeight.em(1.1),
                                      ),
                                      'span': Style(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    },
                                  ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4.8.w,),
                              child: prefs.getSufix == 'Tidak pakai'
                                  ? Container()
                                  : Html(
                                    data: '<span>' + sufixResult[0].get('name') +
                                        '</span> artinya ' + sufixResult[0].get('desc'),
                                    style: {
                                      'body': Style(
                                        fontSize: FontSize(13.0.sp),
                                        color: Theme.of(context).colorScheme.background,
                                        lineHeight: LineHeight.em(1.1),
                                      ),
                                      'span': Style(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    },
                                  ),
                            ),
                            SizedBox(height: 3.4.h,),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4.8.w),
                              child: Html(
                                data: 'Pilih <span>Ganti Nama</span> untuk rekomendasi nama '
                                    'lainnya atau <span>Pilih Sendiri</span> rekomendasi nama '
                                    'yang ada',
                                style: {
                                  'body': Style(
                                    fontSize: FontSize(10.0.sp),
                                    color: Theme.of(context).colorScheme.background,
                                    lineHeight: LineHeight.em(1.1),
                                  ),
                                  'span': Style(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                },
                              ),
                            ),
                            SizedBox(height: 20.0.h,)
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
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
                          Expanded(child: SizedBox()),
                          Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              Column(
                                children: [
                                  Container(
                                    height: 6.4.h,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                          colors: [
                                            Colors.white, Colors.white.withOpacity(0.0),
                                          ],
                                        )
                                    ),
                                  ),
                                  Container(
                                    height: 5.0.h,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {});
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
                                          'Ganti Nama',
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
                                          color: Theme.of(context).colorScheme.background,
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
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
