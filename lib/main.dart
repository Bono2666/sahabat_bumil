import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/date_symbol_data_local.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sahabat_bumil_v2/db/fav_db.dart';
import 'package:sahabat_bumil_v2/db/branch_db.dart';
import 'package:sahabat_bumil_v2/model/fav_model.dart';
import 'package:sahabat_bumil_v2/pages/aqiqah/aqiqah.dart';
import 'package:sahabat_bumil_v2/pages/aqiqah/branch.dart';
import 'package:sahabat_bumil_v2/pages/aqiqah/branchlist.dart';
import 'package:sahabat_bumil_v2/pages/aqiqah/checkout.dart';
import 'package:sahabat_bumil_v2/pages/aqiqah/favorites.dart';
import 'package:sahabat_bumil_v2/pages/aqiqah/history.dart';
import 'package:sahabat_bumil_v2/pages/aqiqah/package.dart';
import 'package:sahabat_bumil_v2/pages/aqiqah/testimoni.dart';
import 'package:sahabat_bumil_v2/pages/articles.dart';
import 'package:sahabat_bumil_v2/pages/babysname/babysname.dart';
import 'package:sahabat_bumil_v2/pages/babysname/favname.dart';
import 'package:sahabat_bumil_v2/pages/babysname/namecollection.dart';
import 'package:sahabat_bumil_v2/pages/babysname/nameresult.dart';
import 'package:sahabat_bumil_v2/pages/features.dart';
import 'package:sahabat_bumil_v2/pages/forum/newquestion.dart';
import 'package:sahabat_bumil_v2/pages/forum/notifications.dart';
import 'package:sahabat_bumil_v2/pages/home.dart';
import 'package:sahabat_bumil_v2/pages/monitoring.dart';
import 'package:sahabat_bumil_v2/pages/onboarding.dart';
import 'package:sahabat_bumil_v2/pages/profile/about.dart';
import 'package:sahabat_bumil_v2/pages/profile/privacy.dart';
import 'package:sahabat_bumil_v2/pages/profile/profile.dart';
import 'package:sahabat_bumil_v2/pages/profile/rules.dart';
import 'package:sahabat_bumil_v2/pages/profile/schedule.dart';
import 'package:sahabat_bumil_v2/pages/profile/todo.dart';
import 'package:sahabat_bumil_v2/pages/profile/upd_profile.dart';
import 'package:sahabat_bumil_v2/pages/profile/upd_sched.dart';
import 'package:sahabat_bumil_v2/pages/profile/upd_todo.dart';
import 'package:sahabat_bumil_v2/pages/register.dart';
import 'package:sahabat_bumil_v2/pages/search.dart';
import 'package:sahabat_bumil_v2/pages/updpregnancy.dart';
import 'package:sahabat_bumil_v2/pages/verify.dart';
import 'package:sahabat_bumil_v2/pages/viewarticle.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'pages/forum/listquestions.dart';
import 'pages/forum/questionview.dart';

class PostHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

Future<void> main() async {
  HttpOverrides.global = new PostHttpOverrides();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await prefs.init();
  await initializeDateFormatting('id_ID', null).then((_) => runApp(MyTheme()));
}

class MyTheme extends StatefulWidget {
  const MyTheme({Key key}) : super(key: key);

  @override
  State<MyTheme> createState() => _MyThemeState();
}

class _MyThemeState extends State<MyTheme> {
  var lat, long;

  Future<void> checkPermission() async {
    final status = await Permission.locationWhenInUse.request();
    if (status == PermissionStatus.granted) {
      print('Permission granted');
    } else if (status == PermissionStatus.denied) {
      print('Permission denied. Show a dialog and again ask for the permission');
    } else if (status == PermissionStatus.permanentlyDenied) {
      print('Take the user to the settings page.');
      // await openAppSettings();
    }

    if (status.isGranted) {
      var position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      lat = position.latitude;
      long = position.longitude;
      prefs.setCurrLat(lat);
      prefs.setCurrLong(long);
      print(prefs.getCurrLat.toString() + ', ' + prefs.getCurrLong.toString());
    }
  }

  Future getProducts() async {
    var url = Uri.parse('https://sahabataqiqah.co.id/sahabat_bumil/api/get_products.php');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  Future getPackages() async {
    var url = Uri.parse('https://sahabataqiqah.co.id/sahabat_bumil/api/get_packages.php');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  Future getPromo() async {
    var url = Uri.parse('https://sahabataqiqah.co.id/sahabat_bumil/api/get_promo.php');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  Future getBranches() async {
    var url = Uri.parse('https://sahabataqiqah.co.id/sahabat_bumil/api/get_branches.php');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    final appName = 'Sahabat Bumil';
    List<QueryDocumentSnapshot> nameupdate;
    AsyncSnapshot<dynamic> dbListAll;
    List dbBranch;
    bool dbListEmpty = true;
    var favDb = FavDb();
    var branchDb = BranchDb();

    return FutureBuilder(
      future: favDb.listAll(),
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
          dbListAll = snapshot;
          if (dbListAll.data.length == 0) dbListEmpty = true;
          else dbListEmpty = false;
        }
        return FutureBuilder(
          future: dbListEmpty
              ? FirebaseFirestore.instance.collection('babysname').get()
              : FirebaseFirestore.instance.collection('babysname')
              .where('stamp', isGreaterThan: DateTime.parse(prefs.getLastNameUpd))
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
              nameupdate = snapshot.data.docs;
              for (int i=0; i < nameupdate.length; i++) {
                var name = new Fav(
                  favId: nameupdate[i].id,
                  favName: nameupdate[i].get('name'),
                  favSex: nameupdate[i].get('sex'),
                  favDesc: nameupdate[i].get('desc'),
                  favNoCat: nameupdate[i].get('no_cat'),
                  favCat: nameupdate[i].get('category'),
                  favFilter: nameupdate[i].get('filter'),
                  favPrefix: nameupdate[i].get('prefix') == true ? 1 : 0,
                  favMiddle: nameupdate[i].get('middle') == true ? 1 : 0,
                  favSuffix: nameupdate[i].get('sufix') == true ? 1 : 0,
                  favStatus: nameupdate[i].get('status'),
                );
                favDb.insert(nameupdate[i].id, nameupdate[i].get('name'),
                    nameupdate[i].get('desc'), nameupdate[i].get('sex'),
                    nameupdate[i].get('no_cat'),
                    nameupdate[i].get('category'),
                    nameupdate[i].get('filter'),
                    nameupdate[i].get('prefix') == true ? 1 : 0,
                    nameupdate[i].get('middle') == true ? 1 : 0,
                    nameupdate[i].get('sufix') == true ? 1 : 0,
                    nameupdate[i].get('status'));
                if (!dbListEmpty) favDb.update(name);
              }
              prefs.setLastNameUpd(DateTime.now().toIso8601String());
            }
            return FutureBuilder(
              future: getBranches(),
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
                  dbBranch = snapshot.data;
                  branchDb.delete();
                  for (int i=0; i < dbBranch.length; i++) {
                    branchDb.insert(
                        int.parse(dbBranch[i]['id']),
                        dbBranch[i]['name'],
                        dbBranch[i]['description'],
                        dbBranch[i]['address_1'],
                        dbBranch[i]['address_2'],
                        dbBranch[i]['phone_1'],
                        dbBranch[i]['phone_2'],
                        dbBranch[i]['email_1'],
                        dbBranch[i]['email_2'],
                        dbBranch[i]['image'],
                        dbBranch[i]['latitude'],
                        dbBranch[i]['longitude'],
                        dbBranch[i]['direction']);
                  }
                  checkPermission();
                }
                return Sizer(
                  builder: (context, orientation, deviceType) {
                    return MaterialApp(
                      title: appName,
                      theme: ThemeData(
                        fontFamily: 'Ubuntu',

                        highlightColor: Color(0xffFDDCC7),
                        secondaryHeaderColor: Color(0xffFFC5A0),
                        primaryColorLight: Color(0xffFFA971),
                        primaryColor: Color(0xffFF8C42),
                        dividerColor: Color(0xffD1D3D4),
                        hintColor: Color(0xffCDCDCD),
                        disabledColor: Color(0xffA7A7A7),
                        shadowColor: Color(0x32000000),
                        dialogBackgroundColor: Color(0x30000000),
                        unselectedWidgetColor: Color(0xff757575),
                        primaryColorDark: Color(0xff484848),

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
                              color: Color(0xffFF8C42),
                              width: 3,
                            ),
                          ),
                        ),

                        colorScheme: ColorScheme.fromSwatch().copyWith(
                          background: Color(0xff410B13),
                          error: const Color(0xffE4572E),
                        ),
                      ),

                      initialRoute: prefs.getFirstlaunch == false ? '/home' : '/',
                      // ignore: missing_return
                      onGenerateRoute: (RouteSettings settings) {
                        switch (settings.name) {
                          case '/':
                            return SlideLeftRoute(page: Onboarding());
                          case '/updpregnancy':
                            return SlideUpRoute(page: UpdPregnancy());
                          case '/monitoring':
                            return SlideUpRoute(page: Monitoring());
                          case '/viewarticle':
                            return SlideLeftRoute(page: ViewArticle());
                          case '/babysname':
                            return SlideUpRoute(page: BabysName());
                          case '/nameresult':
                            return SlideLeftRoute(page: NameResult());
                          case '/namecollection':
                            return SlideLeftRoute(page: NameCollection());
                          case '/favname':
                            return SlideLeftRoute(page: FavName());
                          case '/home':
                            return SlideUpRoute(page: Home());
                          case '/features':
                            return SlideDownRoute(page: Features());
                          case '/search':
                            return NoSlideRoute(page: Search());
                          case '/aqiqah':
                            return SlideUpRoute(page: Aqiqah());
                          case '/checkout':
                            return SlideLeftRoute(page: Checkout());
                          case '/package':
                            return SlideLeftRoute(page: Package());
                          case '/closetopackage':
                            return SlideDownRoute(page: Package());
                          case '/favorites':
                            return SlideLeftRoute(page: Favorites());
                          case '/closetofavorites':
                            return SlideDownRoute(page: Favorites());
                          case '/history':
                            return SlideLeftRoute(page: History());
                          case '/testimoni':
                            return SlideLeftRoute(page: Testimoni());
                          case '/branch':
                            return SlideLeftRoute(page: Branch());
                          case '/branchlist':
                            return SlideLeftRoute(page: BranchList());
                          case '/articles':
                            return SlideUpRoute(page: Articles());
                          case '/register':
                            return SlideUpRoute(page: const Register());
                          case '/verification':
                            return SlideLeftRoute(page: Verify());
                          case '/profile':
                            return SlideUpRoute(page: const Profile());
                          case '/schedule':
                            return SlideLeftRoute(page: const Schedule());
                          case '/updSchedule':
                            return SlideLeftRoute(page: const UpdSched());
                          case '/todo':
                            return SlideLeftRoute(page: const ToDo());
                          case '/updTodo':
                            return SlideLeftRoute(page: const UpdTodo());
                          case '/updProfile':
                            return SlideLeftRoute(page: const UpdProfile());
                          case '/privacy':
                            return SlideLeftRoute(page: const Privacy());
                          case '/rules':
                            return SlideLeftRoute(page: const Rules());
                          case '/about':
                            return SlideLeftRoute(page: const About());
                          case '/newquestion':
                            return SlideUpRoute(page: NewQuestion());
                          case '/questionsList':
                            return SlideUpRoute(page: QuestionsList());
                          case '/questionView':
                            return SlideLeftRoute(page: QuestionView());
                          case '/notifications':
                            return SlideDownRoute(page: const Notifications());
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
  String get getLastNameUpd => _prefs.getString('lastnameupd') ?? '';
  String get getSexName => _prefs.getString('sexname') ?? '';
  String get getCatName => _prefs.getString('catname') ?? '';
  String get getCapName => _prefs.getString('capname') ?? '';
  bool get getOpenFavName => _prefs.getBool('openfavname') ?? false;
  bool get getIsPerempuanName => _prefs.getBool('isperempuanname') ?? false;
  int get getSelectedIndexName => _prefs.getInt('selectedindexname') ?? 0;
  int get getSelectedCapName => _prefs.getInt('selectedcapname') ?? 0;
  String get getIdName => _prefs.getString('idname') ?? '';
  String get getGoRoute => _prefs.getString('goroute') ?? '';
  String get getIdProduct => _prefs.getString('idproduct') ?? '';
  String get getIdPackage => _prefs.getString('idpackage') ?? '';
  String get getBranchId => _prefs.getString('branchid') ?? '';
  double get getCurrLat => _prefs.getDouble('currlat') ?? 0;
  double get getCurrLong => _prefs.getDouble('currlong') ?? 0;
  double get getBranchLat => _prefs.getDouble('branchlat') ?? 0;
  double get getBranchLong => _prefs.getDouble('branchlong') ?? 0;
  String get getIsoCode => _prefs.getString('isoCode') ?? '';
  String get getDialCode => _prefs.getString('dialCode') ?? '';
  String get getPhone => _prefs.getString('phone') ?? '';
  bool get getIsSignIn => _prefs.getBool('isSignIn') ?? false;
  String get getFmtPhone => _prefs.getString('fmtPhone') ?? '';
  bool get getIsUpdSched => _prefs.getBool('isUpdSched') ?? true;
  String get getSchedTitle => _prefs.getString('schedTitle') ?? '';
  String get getSchedDate => _prefs.getString('schedDate') ?? '';
  String get getSchedTime => _prefs.getString('schedTime') ?? '';
  String get getSchedNotes => _prefs.getString('schedNotes') ?? '';
  bool get getIsUpdTodo => _prefs.getBool('isUpdTodo') ?? true;
  String get getTodoId => _prefs.getString('todoId') ?? '';
  String get getTodoTitle => _prefs.getString('todoTitle') ?? '';
  String get getEmail => _prefs.getString('email') ?? '';
  String get getPathAndName => _prefs.getString('pathAndName') ?? '';
  String get getMsg => _prefs.getString('msg') ?? '';
  int get getTotOrder => _prefs.getInt('totOrder') ?? 0;
  int get getQty => _prefs.getInt('qty') ?? 0;
  String get getBackRoute => _prefs.getString('backRoute') ?? '';
  String get getQuestionId => _prefs.getString('questionid') ?? '';

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
  setLastNameUpd(String value) => _prefs.setString('lastnameupd', value);
  setSexName(String value) => _prefs.setString('sexname', value);
  setCatName(String value) => _prefs.setString('catname', value);
  setCapName(String value) => _prefs.setString('capname', value);
  setOpenFavName(bool value) => _prefs.setBool('openfavname', value);
  setIsPerempuanName(bool value) => _prefs.setBool('isperempuanname', value);
  setSelectedIndexName(int value) => _prefs.setInt('selectedindexname', value);
  setSelectedCapName(int value) => _prefs.setInt('selectedcapname', value);
  setIdName(String value) => _prefs.setString('idname', value);
  setGoRoute(String value) => _prefs.setString('goroute', value);
  setIdProduct(String value) => _prefs.setString('idproduct', value);
  setIdPackage(String value) => _prefs.setString('idpackage', value);
  setBranchId(String value) => _prefs.setString('branchid', value);
  setCurrLat(double value) => _prefs.setDouble('currlat', value);
  setCurrLong(double value) => _prefs.setDouble('currlong', value);
  setBranchLat(double value) => _prefs.setDouble('branchlat', value);
  setBranchLong(double value) => _prefs.setDouble('branchlong', value);
  setIsoCode(String value) => _prefs.setString('isoCode', value);
  setDialCode(String value) => _prefs.setString('dialCode', value);
  setPhone(String value) => _prefs.setString('phone', value);
  setIsSignIn(bool value) => _prefs.setBool('isSignIn', value);
  setFmtPhone(String value) => _prefs.setString('fmtPhone', value);
  setIsUpdSched(bool value) => _prefs.setBool('isUpdSched', value);
  setSchedTitle(String value) => _prefs.setString('schedTitle', value);
  setSchedDate(String value) => _prefs.setString('schedDate', value);
  setSchedTime(String value) => _prefs.setString('schedTime', value);
  setSchedNotes(String value) => _prefs.setString('schedNotes', value);
  setIsUpdTodo(bool value) => _prefs.setBool('isUpdTodo', value);
  setTodoId(String value) => _prefs.setString('todoId', value);
  setTodoTitle(String value) => _prefs.setString('todoTitle', value);
  setEmail(String value) => _prefs.setString('email', value);
  setPathAndName(String value) => _prefs.setString('pathAndName', value);
  setMsg(String value) => _prefs.setString('msg', value);
  setTotOrder(int value) => _prefs.setInt('totOrder', value);
  setQty(int value) => _prefs.setInt('qty', value);
  setBackRoute(String value) => _prefs.setString('backRoute', value);
  setQuestionId(String value) => _prefs.setString('questionid', value);
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

class SlideDownRoute extends PageRouteBuilder {
  final Widget page;

  SlideDownRoute({this.page}) :super(
      transitionDuration: Duration(seconds: 1),
      transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secAnimation, Widget child) {
        animation = CurvedAnimation(parent: animation, curve: Curves.elasticInOut);
        return SlideTransition(
          position: Tween(
            begin: const Offset(0,-1.2),
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

class NoSlideRoute extends PageRouteBuilder {
  final Widget page;

  NoSlideRoute({this.page}) :super(
      transitionDuration: Duration(seconds: 0),
      transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secAnimation, Widget child) {
        animation = CurvedAnimation(parent: animation, curve: Curves.elasticInOut);
        return SlideTransition(
          position: Tween(
            begin: Offset.zero,
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