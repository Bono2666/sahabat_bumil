import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:sahabat_bumil_v2/main.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:http/http.dart' as http;

class UpdPregnancy extends StatefulWidget {
  @override
  _UpdPregnancyState createState() => _UpdPregnancyState();
}

class _UpdPregnancyState extends State<UpdPregnancy> {
  String babyname = prefs.getBabyName;
  String sextype = '';
  String hplPrefs = prefs.getHPL;
  String hphtPrefs = prefs.getHPHT;
  String basecount = prefs.getBasecount;
  DateTime hpl, hpht;
  String hplStr, hphtStr;
  var hplText = TextEditingController();
  var hphtText = TextEditingController();
  var hplResult = TextEditingController();
  var aqiqahResult = TextEditingController();
  var babyNameText = TextEditingController();
  var f = NumberFormat('00');
  List dbProfile;
  bool firstLoad = true;

  Future getProfile() async {
    var url = Uri.parse('https://sahabataqiqah.co.id/sahabat_bumil/api/get_profile.php?phone=${prefs.getPhone}');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  Future updPregnancy() async {
    var url = Uri.parse('https://sahabataqiqah.co.id/sahabat_bumil/api/upd_pregnancy.php?phone=${prefs.getPhone}'
        '&babys_name=${babyNameText.text}&sex=$sextype&hpl=$hplStr&hpht=$hphtStr&basecount=$basecount');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) => KeyboardDismisser(
    gestures: [
      GestureType.onTap,
      GestureType.onVerticalDragDown,
    ],
    child: Scaffold(
      body: FutureBuilder(
        future: getProfile(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null || snapshot.hasError) {
            return
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SpinKitPulse(
                    color: Theme.of(context).primaryColor,
                  ),
                ],
              );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            dbProfile = snapshot.data as List;

            if (firstLoad) {

              babyNameText.text = dbProfile[0]['babys_name'] != '' ? dbProfile[0]['babys_name'] : prefs.getBabyName != '' ? prefs.getBabyName : '';
              sextype = dbProfile[0]['sex'] != '' ? dbProfile[0]['sex'] : prefs.getSextype != '' ? prefs.getSextype : '';
              basecount = dbProfile[0]['basecount'] != '' ? dbProfile[0]['basecount'] : prefs.getBasecount != '' ? prefs.getBasecount : '';

              if (basecount != '') {
                if (dbProfile[0]['hpl'] != '') {
                  hpl = DateTime(
                      int.parse(dbProfile[0]['hpl'].substring(0, 4)),
                      int.parse(dbProfile[0]['hpl'].substring(5, 7)),
                      int.parse(dbProfile[0]['hpl'].substring(8, 10))
                  );
                } else {
                  if (prefs.getHPL != '') {
                    hpl = DateTime(
                        int.parse(hplPrefs.substring(4, 8)),
                        int.parse(hplPrefs.substring(2, 4)),
                        int.parse(hplPrefs.substring(0, 2))
                    );
                  }
                }

                if (basecount == 'hpl') {
                  hpht = hpl.subtract(Duration(days: 280));
                  hplStr = DateFormat('yyyy-MM-dd', 'id_ID').format(hpl);
                  hphtStr = DateFormat('yyyy-MM-dd', 'id_ID').format(hpht);
                  hplText.text = DateFormat('d MMMM yyyy', 'id_ID').format(hpl);
                  hplResult.text = DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(hpl);
                  aqiqahResult.text = DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(hpl.add(Duration(days: 6)));
                } else {
                  if (dbProfile[0]['hpht'] != '') {
                    hpht = DateTime(
                        int.parse(dbProfile[0]['hpht'].substring(0, 4)),
                        int.parse(dbProfile[0]['hpht'].substring(5, 7)),
                        int.parse(dbProfile[0]['hpht'].substring(8, 10))
                    );
                  } else {
                    if (prefs.getHPHT != '') {
                      hpht = DateTime(
                          int.parse(hphtPrefs.substring(4, 8)),
                          int.parse(hphtPrefs.substring(2, 4)),
                          int.parse(hphtPrefs.substring(0, 2))
                      );
                    }
                  }

                  hpl = hpht.add(const Duration(days: 280));
                  hplStr = DateFormat('yyyy-MM-dd', 'id_ID').format(hpl);
                  hphtStr = DateFormat('yyyy-MM-dd', 'id_ID').format(hpht);
                  hphtText.text = DateFormat('d MMMM yyyy', 'id_ID').format(hpht);
                  hplResult.text = DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(hpl);
                  aqiqahResult.text = DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(hpl.add(Duration(days: 6)));
                }
              }

              firstLoad = false;
            }
          }
          return Stack(
            children: [
              SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 7.0.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 19.0.h,),
                          Text(
                            'Profil Kehamilan',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.background,
                              fontWeight: FontWeight.w700,
                              fontSize: 24.0.sp,
                            ),
                          ),
                          SizedBox(height: 4.0.h,),
                          Text(
                            'Nama Calon Bayi (Insya Allah)',
                            style: TextStyle(
                              fontSize: 13.0.sp,
                              color: Theme.of(context).colorScheme.background,
                            ),
                          ),
                          TextField(
                            controller: babyNameText,
                            onChanged: (String str) {
                              setState(() {
                                babyname = str;
                              });
                            },
                            cursorColor: Colors.black,
                            style: TextStyle(
                              fontSize: 15.0.sp,
                            ),
                          ),
                          SizedBox(height: 3.0.h,),
                          Text(
                            'Jenis Kelamin (Insya Allah)',
                            style: TextStyle(
                              fontSize: 13.0.sp,
                              color: Theme.of(context).colorScheme.background,
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
                                                  color: Theme.of(context).colorScheme.background,
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
                                    color: Theme.of(context).dividerColor,
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
                                  SizedBox(width: 2.2.w,)
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 3.0.h,),
                          Text(
                            'Sudah tahu kapan HPL Anda?',
                            style: TextStyle(
                              fontSize: 13.0.sp,
                              color: Theme.of(context).colorScheme.background,
                            ),
                          ),
                          TextField(
                            controller: hplText,
                            cursorColor: Colors.black,
                            readOnly: true,
                            onTap: () {
                              DatePicker.showDatePicker(
                                context,
                                minTime: DateTime.now(),
                                maxTime: DateTime.now().add(Duration(days: 280)),
                                onConfirm: (date) {
                                  setState(() {
                                    hpl = date;
                                    hpht = date.subtract(Duration(days: 280));
                                    hplStr = DateFormat('yyyy-MM-dd', 'id_ID').format(hpl);
                                    hphtStr = DateFormat('yyyy-MM-dd', 'id_ID').format(hpht);
                                    basecount = 'hpl';
                                    hplText.text = DateFormat('d MMMM yyyy', 'id_ID').format(hpl);
                                    hphtText.text = '';
                                    hplResult.text = DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(hpl);
                                    aqiqahResult.text = DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(hpl.add(Duration(days: 6)));
                                  });
                                },
                                theme: DatePickerTheme(
                                  itemStyle: TextStyle(
                                    fontFamily: 'Ubuntu',
                                    fontSize: 15.0.sp,
                                    color: Theme.of(context).colorScheme.background,
                                  ),
                                  doneStyle: TextStyle(
                                    fontFamily: 'Ubuntu',
                                    color: Theme.of(context).colorScheme.background,
                                  ),
                                  cancelStyle: TextStyle(
                                    fontFamily: 'Ubuntu',
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                locale: LocaleType.id,
                              );
                            },
                            decoration: InputDecoration(
                              suffixIcon: Container(
                                margin: EdgeInsets.fromLTRB(4.4.w, 2.2.w, 2.2.w, 4.4.w),
                                height: 3.0.h,
                                child: Image.asset(
                                  'images/ic_cal.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                              hintText: 'Masukkan HPL menurut dokter',
                              hintStyle: TextStyle(
                                color: Theme.of(context).hintColor,
                                fontSize: 15.0.sp,
                              ),
                            ),
                            style: TextStyle(
                              fontSize: 15.0.sp,
                            ),
                          ),
                          SizedBox(height: 1.0.h,),
                          Row(
                            children: [
                              Container(
                                width: 4.0.w,
                                height: 4.0.w,
                                child: new Image.asset(
                                  'images/ic_info.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(width: 1.0.w,),
                              Text(
                                'HPL : Hari Perkiraan Lahir',
                                style: TextStyle(
                                  fontSize: 10.0.sp,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 3.0.h,),
                          Text(
                            'atau',
                            style: TextStyle(
                              fontSize: 12.0.sp,
                              color: Theme.of(context).colorScheme.background,
                            ),
                          ),
                          SizedBox(height: 3.0.h,),
                          Text(
                            'Hitung HPL berdasarkan HPHT',
                            style: TextStyle(
                              fontSize: 13.0.sp,
                              color: Theme.of(context).colorScheme.background,
                            ),
                          ),
                          TextField(
                            controller: hphtText,
                            readOnly: true,
                            onTap: () {
                              DatePicker.showDatePicker(
                                context,
                                theme: DatePickerTheme(
                                  itemStyle: TextStyle(
                                    fontFamily: 'Ubuntu',
                                    fontSize: 15.0.sp,
                                    color: Theme.of(context).colorScheme.background,
                                  ),
                                  doneStyle: TextStyle(
                                    fontFamily: 'Ubuntu',
                                    color: Theme.of(context).colorScheme.background,
                                  ),
                                  cancelStyle: TextStyle(
                                    fontFamily: 'Ubuntu',
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                minTime: DateTime.now().subtract(Duration(days: 280)),
                                maxTime: DateTime.now(),
                                onConfirm: (date) {
                                  setState(() {
                                    hpht = date;
                                    hpl = date.add(const Duration(days: 280));
                                    hplStr = DateFormat('yyyy-MM-dd', 'id_ID').format(hpl);
                                    hphtStr = DateFormat('yyyy-MM-dd', 'id_ID').format(hpht);
                                    basecount = 'hpht';
                                    hplText.text = '';
                                    hphtText.text = DateFormat('d MMMM yyyy', 'id_ID').format(hpht);
                                    hplResult.text = DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(hpl);
                                    aqiqahResult.text = DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(hpl.add(Duration(days: 6)));
                                  });
                                },
                                locale: LocaleType.id,
                              );
                            },
                            decoration: InputDecoration(
                              suffixIcon: Container(
                                margin: EdgeInsets.fromLTRB(4.4.w, 2.2.w, 2.2.w, 4.4.w),
                                height: 3.0.h,
                                child: Image.asset(
                                  'images/ic_cal.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                              hintText: 'Masukkan HPHT Anda',
                              hintStyle: TextStyle(
                                color: Theme.of(context).hintColor,
                                fontSize: 15.0.sp,
                              ),
                            ),
                            cursorColor: Colors.black,
                            style: TextStyle(
                              fontSize: 15.0.sp,
                            ),
                          ),
                          SizedBox(height: 1.0.h,),
                          Row(
                            children: [
                              Container(
                                width: 4.0.w,
                                height: 4.0.w,
                                child: new Image.asset(
                                  'images/ic_info.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(width: 1.0.w,),
                              Text(
                                'HPHT : Hari Pertama Haid Terakhir',
                                style: TextStyle(
                                  fontSize: 10.0.sp,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 3.0.h,),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 7.0.w),
                          child: Text(
                            'Insya Allah hari perkiraan lahir bayi Anda adalah',
                            style: TextStyle(
                              fontSize: 13.0.sp,
                              fontWeight: FontWeight.w500,
                              height: 1.5,
                              color: Theme.of(context).colorScheme.background,
                            ),
                          ),
                        ),
                        SizedBox(height: 3.0.h,),
                        Container(
                          height: 10.0.h,
                          color: Theme.of(context).primaryColor,
                          padding: EdgeInsets.symmetric(horizontal: 7.0.w),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextField(
                                enabled: false,
                                controller: hplResult,
                                style: TextStyle(
                                    fontSize: 15.0.sp,
                                    color: Colors.white
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 4.0.h,),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 7.0.w),
                          child: Text(
                            'Insya Allah hari aqiqah bayi Anda adalah',
                            style: TextStyle(
                              fontSize: 13.0.sp,
                              fontWeight: FontWeight.w500,
                              height: 1.5,
                              color: Theme.of(context).colorScheme.background,
                            ),
                          ),
                        ),
                        SizedBox(height: 3.0.h,),
                        Container(
                          height: 10.0.h,
                          color: Theme.of(context).primaryColor,
                          padding: EdgeInsets.symmetric(horizontal: 7.0.w),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextField(
                                enabled: false,
                                controller: aqiqahResult,
                                style: TextStyle(
                                    fontSize: 15.0.sp,
                                    color: Colors.white
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20.0.h,),
                      ],
                    ),
                  ],
                ),
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
                        onTap: () => Navigator.pushNamed(context, '/home'),
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
                          updPregnancy();
                          // prefs.setBasecount(basecount);
                          Navigator.pushReplacementNamed(context, prefs.getGoRoute);
                        },
                        child: Container(
                          width: 74.0.w,
                          height: 12.0.h,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.background,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Simpan',
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
          );
        },
      ),
    ),
  );

  saveProfile() async {
    if ((hplText.text == '') && (hphtText.text == '')) {
      showDialog(
        context: context,
        builder: (_) => SaveAlert(),
        barrierDismissible: false,
      );
    } else {
      await prefs.setBabyName(babyname);
      if (sextype == null) sextype = '';
      await prefs.setSextype(sextype);
      await prefs.setHPL(hplPrefs);
      await prefs.setHPHT(hphtPrefs);
      await prefs.setBasecount(basecount);
      Navigator.pushReplacementNamed(context, prefs.getRoute);
    }
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
                      'Ingin membatalkan perubahan?',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.background,
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
                                'images/ic_cancel.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 5.6.w,),
                        Ink(
                          child: InkWell(
                            onTap: () {
                              Navigator.pushReplacementNamed(context, '/home');
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

class SaveAlert extends StatefulWidget {
  @override
  _SaveAlertState createState() => _SaveAlertState();
}

class _SaveAlertState extends State<Alert> with SingleTickerProviderStateMixin {
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
                      'HPL atau HPHT harus diisi.',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.background,
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