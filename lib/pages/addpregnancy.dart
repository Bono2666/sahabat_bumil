import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:fswitch/fswitch.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:format_indonesia/format_indonesia.dart';
import 'package:intl/intl.dart';
import 'package:sahabat_bumil_v2/main.dart';

class addPregnancy extends StatefulWidget {
  @override
  _addPregnancyState createState() => _addPregnancyState();
}

class _addPregnancyState extends State<addPregnancy> {
  String name = '';
  String basecount = '';
  String title = 'Bunda';
  String hplPrefs = '';
  String hphtPrefs = '';
  DateTime hpl, hpht;
  var hplText = TextEditingController();
  var hphtText = TextEditingController();
  var hplResult = TextEditingController();
  var aqiqahResult = TextEditingController();
  var f = NumberFormat('00');
  bool isBunda = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
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
                      SizedBox(height: 16.0.h,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Text(
                              'Profil',
                              style: TextStyle(
                                color: Theme.of(context).backgroundColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 24.0.sp,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 1.0.w),
                            child: Column(
                              children: [
                                Text(
                                  isBunda ? 'Bunda' : 'Ayah',
                                  style: TextStyle(
                                    fontSize: 12.0.sp,
                                  ),
                                ),
                                SizedBox(height: 1.0.h,),
                                FSwitch(
                                  open: isBunda,
                                  width: 12.0.w,
                                  height: 9.0.w,
                                  offset: 1.0,
                                  color: Theme.of(context).primaryColor,
                                  openColor: Theme.of(context).primaryColor,
                                  sliderChild: Image.asset(
                                    isBunda ? 'images/ic_woman.png' : 'images/ic_man.png',
                                    width: 3.3.w,
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      isBunda = value;
                                      if (isBunda) {
                                        title = 'Bunda';
                                      } else { title = 'Ayah'; }
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.0.h,),
                      Text(
                        'Nama Lengkap',
                        style: TextStyle(
                          fontSize: 13.0.sp,
                          color: Theme.of(context).backgroundColor,
                        ),
                      ),
                      TextField(
                        onChanged: (String str) {
                          setState(() {
                            name = str;
                          });
                        },
                        cursorColor: Colors.black,
                        style: TextStyle(
                          fontSize: 15.0.sp,
                        ),
                      ),
                      SizedBox(height: 3.0.h,),
                      Text(
                        'Sudah tahu kapan HPL Anda?',
                        style: TextStyle(
                          fontSize: 13.0.sp,
                          color: Theme.of(context).backgroundColor,
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
                                hplPrefs = f.format(hpl.day).toString() + f.format(hpl.month).toString() + hpl.year.toString();
                                hphtPrefs = f.format(hpht.day).toString() + f.format(hpht.month).toString() + hpht.year.toString();
                                basecount = 'hpl';
                                hplText.text = Waktu(hpl).yMMMMd();
                                hphtText.text = '';
                                hplResult.text = Waktu(hpl).yMMMMEEEEd();
                                aqiqahResult.text = Waktu(hpl.add(Duration(days: 6))).yMMMMEEEEd();
                              });
                            },
                            theme: DatePickerTheme(
                              itemStyle: TextStyle(
                                fontFamily: 'Ubuntu',
                                fontSize: 15.0.sp,
                                color: Theme.of(context).backgroundColor,
                              ),
                              doneStyle: TextStyle(
                                fontFamily: 'Ubuntu',
                                color: Theme.of(context).backgroundColor,
                              ),
                              cancelStyle: TextStyle(
                                fontFamily: 'Ubuntu',
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
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
                          color: Theme.of(context).backgroundColor,
                        ),
                      ),
                      SizedBox(height: 3.0.h,),
                      Text(
                        'Hitung HPL berdasarkan HPHT',
                        style: TextStyle(
                          fontSize: 13.0.sp,
                          color: Theme.of(context).backgroundColor,
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
                                  color: Theme.of(context).backgroundColor,
                                ),
                                doneStyle: TextStyle(
                                  fontFamily: 'Ubuntu',
                                  color: Theme.of(context).backgroundColor,
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
                                  hpl = date.add(Duration(days: 280));
                                  hplPrefs = f.format(hpl.day).toString() + f.format(hpl.month).toString() + hpl.year.toString();
                                  hphtPrefs = f.format(hpht.day).toString() + f.format(hpht.month).toString() + hpht.year.toString();
                                  basecount = 'hpht';
                                  hplText.text = '';
                                  hphtText.text = Waktu(hpht).yMMMMd();
                                  hplResult.text = Waktu(hpl).yMMMMEEEEd();
                                  aqiqahResult.text = Waktu(hpl.add(Duration(days: 6))).yMMMMEEEEd();
                                });
                              }
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
                (hplText.text == '') && (hphtText.text == '') ? Container()
                : Column(
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
                          color: Theme.of(context).backgroundColor,
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
                          color: Theme.of(context).backgroundColor,
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
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/');
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
                    onTap: saveProfile,
                    child: Container(
                      width: 74.0.w,
                      height: 12.0.h,
                      decoration: BoxDecoration(
                        color: Theme.of(context).backgroundColor,
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
      ),
    );
  }

  saveProfile() async {
    if ((hplText.text == '') && (hphtText.text == '')) {
      showDialog(
        context: context,
        builder: (_) => alert(),
        barrierDismissible: false,
      );
    } else {
      await prefs.setName(name);
      await prefs.setTitle(title);
      await prefs.setHPL(hplPrefs);
      await prefs.setHPHT(hphtPrefs);
      await prefs.setBasecount(basecount);
      await prefs.setFirstlaunch(false);
      Navigator.pushReplacementNamed(context, '/monitoring');
    }
  }
}

class alert extends StatefulWidget {
  @override
  _alertState createState() => _alertState();
}

class _alertState extends State<alert> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> scaleAnimation;

  @override
  void initState() {
    // TODO: implement initState
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
                padding: EdgeInsets.fromLTRB(7.8.w, 5.0.w, 7.8.w, 5.0.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'HPL atau HPHT harus diisi.',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Theme.of(context).backgroundColor,
                        fontFamily: 'Ubuntu',
                        fontWeight: FontWeight.w400,
                        fontSize: 13.0.sp,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 7.0.h,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Ink(
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: 8.8.h,
                              height: 8.8.h,
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
