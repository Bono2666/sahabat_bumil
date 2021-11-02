import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:sahabat_bumil_v2/db/criteria_db.dart';
import 'package:sahabat_bumil_v2/pages/babysname/babysname.dart';
import 'package:sahabat_bumil_v2/pages/babysname/nameresult.dart';
import 'package:sahabat_bumil_v2/pages/onboarding.dart';
import 'package:sahabat_bumil_v2/pages/addpregnancy.dart';
import 'package:sahabat_bumil_v2/pages/monitoring.dart';
import 'package:sahabat_bumil_v2/pages/updpregnancy.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sahabat_bumil_v2/pages/viewarticle.dart';
import 'package:sizer/sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model/criteria_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await prefs.init();
  runApp(MyTheme());
}

class MyTheme extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appName = 'Sahabat Bumil';
    List<QueryDocumentSnapshot>
        boysname1, boysname2, boysname3,
        girlsname1, girlsname2, girlsname3;
    var critDb = CriteriaDb();
    var f = NumberFormat('00');

    return FutureBuilder(
      future: FirebaseFirestore.instance.collection('babysname')
          .where('sex', isEqualTo: 'Laki-laki')
          .where('prefix', isEqualTo: true)
          .get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == null || snapshot.hasError) {
          return Container(
            color: Color(0xffFF8C42),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SpinKitPulse(
                  color: Colors.white,
                ),
              ],
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          boysname1 = snapshot.data.docs;
          critDb.delete();
          for (int i=0; i < boysname1.length; i++) {
            var criteria = new CriteriaName(
              crit_id: '11' + f.format(boysname1[i].get('no_cat')),
              crit_cat: boysname1[i].get('category'),
            );
            critDb.insert(criteria);
          }
        }
        return FutureBuilder(
          future: FirebaseFirestore.instance.collection('babysname')
              .where('sex', isEqualTo: 'Laki-laki')
              .where('middle', isEqualTo: true)
              .get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data == null || snapshot.hasError) {
              return Container(
                color: Color(0xffFF8C42),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SpinKitPulse(
                      color: Colors.white,
                    ),
                  ],
                ),
              );
            }
            if (snapshot.connectionState == ConnectionState.done) {
              boysname2 = snapshot.data.docs;
              for (int i=0; i < boysname2.length; i++) {
                var criteria = new CriteriaName(
                  crit_id: '12' + f.format(boysname2[i].get('no_cat')),
                  crit_cat: boysname2[i].get('category'),
                );
                critDb.insert(criteria);
              }
            }
            return FutureBuilder(
              future: FirebaseFirestore.instance.collection('babysname')
                  .where('sex', isEqualTo: 'Laki-laki')
                  .where('sufix', isEqualTo: true)
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data == null || snapshot.hasError) {
                  return Container(
                    color: Color(0xffFF8C42),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SpinKitPulse(
                          color: Colors.white,
                        ),
                      ],
                    ),
                  );
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  boysname3 = snapshot.data.docs;
                  for (int i=0; i < boysname3.length; i++) {
                    var criteria = new CriteriaName(
                      crit_id: '13' + f.format(boysname3[i].get('no_cat')),
                      crit_cat: boysname3[i].get('category'),
                    );
                    critDb.insert(criteria);
                  }
                }
                return FutureBuilder(
                  future: FirebaseFirestore.instance.collection('babysname')
                      .where('sex', isEqualTo: 'Perempuan')
                      .where('prefix', isEqualTo: true)
                      .get(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data == null || snapshot.hasError) {
                      return Container(
                        color: Color(0xffFF8C42),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SpinKitPulse(
                              color: Colors.white,
                            ),
                          ],
                        ),
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.done) {
                      girlsname1 = snapshot.data.docs;
                      for (int i=0; i < girlsname1.length; i++) {
                        var criteria = new CriteriaName(
                          crit_id: '21' + f.format(girlsname1[i].get('no_cat')),
                          crit_cat: girlsname1[i].get('category'),
                        );
                        critDb.insert(criteria);
                      }
                    }
                    return FutureBuilder(
                      future: FirebaseFirestore.instance.collection('babysname')
                          .where('sex', isEqualTo: 'Perempuan')
                          .where('middle', isEqualTo: true)
                          .get(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData || snapshot.data == null || snapshot.hasError) {
                          return Container(
                            color: Color(0xffFF8C42),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SpinKitPulse(
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          );
                        }
                        if (snapshot.connectionState == ConnectionState.done) {
                          girlsname2 = snapshot.data.docs;
                          for (int i=0; i < girlsname2.length; i++) {
                            var criteria = new CriteriaName(
                              crit_id: '22' + f.format(girlsname2[i].get('no_cat')),
                              crit_cat: girlsname2[i].get('category'),
                            );
                            critDb.insert(criteria);
                          }
                        }
                        return FutureBuilder(
                          future: FirebaseFirestore.instance.collection('babysname')
                              .where('sex', isEqualTo: 'Perempuan')
                              .where('sufix', isEqualTo: true)
                              .get(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData || snapshot.data == null || snapshot.hasError) {
                              return Container(
                                color: Color(0xffFF8C42),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SpinKitPulse(
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              );
                            }
                            if (snapshot.connectionState == ConnectionState.done) {
                              girlsname3 = snapshot.data.docs;
                              for (int i=0; i < girlsname3.length; i++) {
                                var criteria = new CriteriaName(
                                  crit_id: '23' + f.format(girlsname3[i].get('no_cat')),
                                  crit_cat: girlsname3[i].get('category'),
                                );
                                critDb.insert(criteria);
                              }
                            }
                            return Sizer(
                              builder: (context, orientation, deviceType) {
                                return MaterialApp(
                                  title: appName,
                                  theme: ThemeData(
                                    fontFamily: 'Ubuntu',

                                    highlightColor: Color(0xfFFDDCC7),
                                    secondaryHeaderColor: Color(0xffFFC5A0),
                                    primaryColorLight: Color(0xffFFA971),
                                    primaryColor: Color(0xffFF8C42),
                                    backgroundColor: Color(0xff410B13),
                                    dividerColor: Color(0xffD1D3D4),
                                    hintColor: Color(0xffCDCDCD),
                                    disabledColor: Color(0xffA7A7A7),
                                    shadowColor: Color(0x32000000),
                                    dialogBackgroundColor: Color(0x30000000),

                                    textSelectionTheme: TextSelectionThemeData(
                                      cursorColor: Colors.black,
                                      selectionColor: Color(0xffFFC5A0),
                                      selectionHandleColor: Color(0xff410B13),
                                    ),

                                    inputDecorationTheme: InputDecorationTheme(
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Theme.of(context).dividerColor,
                                        ),
                                      ),
                                      border: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Theme.of(context).dividerColor,
                                        ),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xff410B13),
                                        ),
                                      ),
                                    ),
                                  ),

                                  initialRoute: prefs.getFirstlaunch == false ? '/monitoring' : '/',
                                  // ignore: missing_return
                                  onGenerateRoute: (RouteSettings settings) {
                                    switch (settings.name) {
                                      case '/':
                                        return SlideLeftRoute(page: Onboarding());
                                      case '/addpregnancy':
                                        return SlideUpRoute(page: addPregnancy());
                                      case '/updpregnancy':
                                        return SlideUpRoute(page: updPregnancy());
                                      case '/monitoring':
                                        return SlideUpRoute(page: Monitoring());
                                      case '/viewarticle':
                                        return SlideLeftRoute(page: ViewArticle());
                                      case '/babysname':
                                        return SlideUpRoute(page: BabysName());
                                      case '/nameresult':
                                        return SlideLeftRoute(page: NameResult());
                                    }
                                  },
                                );
                              },
                            );
                          },
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}

final prefs = SharedPrefs();

class SharedPrefs {
  static SharedPreferences _prefs;

  init() async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
  }

  bool get getFirstlaunch => _prefs.getBool('firstlaunch') ?? true;
  String get getName => _prefs.getString('name') ?? '';
  String get getTitle => _prefs.getString('title') ?? '';
  String get getHPL => _prefs.getString('hpl') ?? '';
  String get getHPHT => _prefs.getString('hpht') ?? '';
  String get getBasecount => _prefs.getString('basecount') ?? '';
  String get getBabyName => _prefs.getString('babyname') ?? '';
  String get getSextype => _prefs.getString('sextype') ?? '';
  String get getArticleId => _prefs.getString('articleid') ?? '';
  String get getRoute => _prefs.getString('route') ?? '';
  String get getPrefix => _prefs.getString('prefix') ?? '';
  String get getMiddle => _prefs.getString('middle') ?? '';
  String get getSufix => _prefs.getString('sufix') ?? '';
  String get getSexTypeName => _prefs.getString('sextypename') ?? '';

  setFirstlaunch(bool value) => _prefs.setBool('firstlaunch', value);
  setName(String value) => _prefs.setString('name', value);
  setTitle(String value) => _prefs.setString('title', value);
  setHPL(String value) => _prefs.setString('hpl', value);
  setHPHT(String value) => _prefs.setString('hpht', value);
  setBasecount(String value) => _prefs.setString('basecount', value);
  setBabyName(String value) => _prefs.setString('babyname', value);
  setSextype(String value) => _prefs.setString('sextype', value);
  setArticleId(String value) => _prefs.setString('articleid', value);
  setRoute(String value) => _prefs.setString('route', value);
  setPrefix(String value) => _prefs.setString('prefix', value);
  setMiddle(String value) => _prefs.setString('middle', value);
  setSufix(String value) => _prefs.setString('sufix', value);
  setSexTypeName(String value) => _prefs.setString('sextypename', value);
}

class SlideUpRoute extends PageRouteBuilder {
  final Widget page;

  SlideUpRoute({this.page}) :super(
        transitionDuration: Duration(seconds: 1),
        transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secAnimation, Widget child) {
          animation = CurvedAnimation(parent: animation, curve: Curves.elasticInOut);
          return SlideTransition(
            position: Tween(
              begin: const Offset(0,1.2),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
        pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secAnimation) {
          return page;
        }
  );
}

class SlideLeftRoute extends PageRouteBuilder {
  final Widget page;

  SlideLeftRoute({this.page}) :super(
      transitionDuration: Duration(seconds: 1),
      transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secAnimation, Widget child) {
        animation = CurvedAnimation(parent: animation, curve: Curves.elasticInOut);
        return SlideTransition(
          position: Tween(
            begin: const Offset(1.2,0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
      pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secAnimation) {
        return page;
      }
  );
}