import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:sahabat_bumil_v2/db/prods_db.dart';
import 'package:sizer/sizer.dart';
import 'package:sahabat_bumil_v2/main.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

int prodId = 1;
String waNumber;

class Package extends StatefulWidget {
  @override
  _PackageState createState() => _PackageState();
}

class _PackageState extends State<Package> {
  List dbPackage, dbSetup;
  bool isFav = false;
  String favIcon;
  var prodsDb = ProdsDb();

  Future getSetup() async {
    var url = Uri.parse('https://sahabataqiqah.co.id/sahabat_bumil/api/get_setup.php');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  Future getProdsPackage(int id) async {
    var url;
    if (prefs.getIsSignIn)
      url = Uri.parse('https://sahabataqiqah.co.id/sahabat_bumil/api/get_prods_package.php?id=$id&phone=${prefs.getPhone}');
    else
      url = Uri.parse('https://sahabataqiqah.co.id/sahabat_bumil/api/get_prods_package.php?id=$id');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  Future addFav(String id) async {
    var url = 'https://sahabataqiqah.co.id/sahabat_bumil/api/add_fav.php';
    await http.post(Uri.parse(url), body: {
      'phone' : prefs.getPhone,
      'fav_prod' : id,
    });
  }

  Future delFav(int id) async {
    var url = 'https://sahabataqiqah.co.id/sahabat_bumil/api/del_fav.php';
    await http.post(Uri.parse(url), body: {
      'id' : id.toString(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pushNamedAndRemoveUntil(context, '/aqiqah', (route) => false);
          return false;
        },
        child: FutureBuilder(
          future: getProdsPackage(int.parse(prefs.getIdPackage)),
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
              dbPackage = snapshot.data;
            }
            return FutureBuilder(
              future: getSetup(),
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
                  dbSetup = snapshot.data;
                }
                return Stack(
                  children: [
                    SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 7.0.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 19.0.h,),
                                Text(
                                  dbPackage[0]['prods_package'],
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.background,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 24.0.sp,
                                  ),
                                ),
                                SizedBox(height: 0.6.h,),
                                Text(
                                  dbPackage[0]['sub_title'],
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 10.0.sp,
                                  ),
                                ),
                                SizedBox(height: 4.4.h,),
                              ],
                            ),
                          ),
                          GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 4.4.h,
                              crossAxisSpacing: 3.8.w,
                              mainAxisExtent: dbPackage[0]['description'] == ''
                                  ? 58.0.w : 62.0.w,
                            ),
                            itemCount: dbPackage.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.only(left: 3.9.w, right: 4.9.w),
                            itemBuilder: (context, index) {
                              return InkWell(
                                child: Stack(
                                  alignment: AlignmentDirectional.topStart,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: 2.8.w,),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 40.0.w,
                                            height: 41.1.w,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(12),
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Theme.of(context).shadowColor,
                                                    blurRadius: 6.0,
                                                    offset: Offset(0,3),
                                                  ),
                                                ]
                                            ),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.all(Radius.circular(12),),
                                              child: Container(
                                                height: 41.1.w,
                                                color: Theme.of(context).primaryColor,
                                                child: Image.network(
                                                  dbPackage[index]['image'],
                                                  width: 100.0.w,
                                                  fit: BoxFit.cover,
                                                  loadingBuilder: (context, child, loadingProgress) {
                                                    if (loadingProgress == null) return child;
                                                    return SizedBox(
                                                      height: 41.1.w,
                                                      child: Center(
                                                        child: SpinKitPulse(
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(height: 2.2.w,),
                                              Text(
                                                dbPackage[index]['name'],
                                                style: TextStyle(
                                                  color: Theme.of(context).colorScheme.background,
                                                  fontSize: 11.0.sp,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                                maxLines: dbPackage[index]['description'] == ''
                                                    ? 2 : 1,
                                                overflow: dbPackage[index]['description'] == ''
                                                    ? TextOverflow.visible : TextOverflow.ellipsis,
                                              ),
                                              dbPackage[index]['description'] == ''
                                                  ? Container() : SizedBox(height: 1.6.w,),
                                              dbPackage[index]['description'] == ''
                                                  ? Container() : Html(
                                                data: dbPackage[index]['description'],
                                                style: {
                                                  'body': Style(
                                                    color: Colors.black,
                                                    fontSize: FontSize(8.0.sp),
                                                    maxLines: 2,
                                                    textOverflow: TextOverflow.ellipsis,
                                                    margin: EdgeInsets.all(0),
                                                  )
                                                },
                                              ),
                                              SizedBox(height: 1.2.w,),
                                              Text(
                                                NumberFormat.currency(
                                                  locale: 'id',
                                                  symbol: 'Rp ',
                                                  decimalDigits: 0,
                                                ).format(int.parse(dbPackage[index]['price'])),
                                                style: TextStyle(
                                                  color: Theme.of(context).colorScheme.background,
                                                  fontSize: 10.0.sp,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    dbPackage[index]['promo'] == '' ? Container() : Padding(
                                      padding: EdgeInsets.only(top: 3.9.w,),
                                      child: Image.asset(
                                        'images/bg_label_light.png',
                                        height: 7.9.w,
                                      ),
                                    ),
                                    dbPackage[index]['promo'] == '' ? Container() : Padding(
                                      padding: EdgeInsets.fromLTRB(3.6.w, 5.3.w, 0, 0),
                                      child: Text(
                                        dbPackage[index]['promo'],
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 9.0.sp,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 33.2.w, top: 4.4.w),
                                      child: InkWell(
                                        child: Image.asset(
                                          dbPackage[index]['fav'] == null ? 'images/ic_unfav.png' : 'images/ic_fav.png',
                                          width: 5.6.w,
                                        ),
                                        onTap: () {
                                          setState(() {
                                            prefs.setRoute('/aqiqah');
                                            prefs.setGoRoute('/aqiqah');
                                            if (!prefs.getIsSignIn) {
                                              Navigator.pushNamed(context, '/register');
                                            } else {
                                              if (dbPackage[0]['fav'] == null) {
                                                addFav(dbPackage[0]['id']);
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: const Text(
                                                      'Produk telah berhasil disimpan sebagai Favorit.',
                                                      style: TextStyle(
                                                        fontFamily: 'Ubuntu',
                                                      ),
                                                    ),
                                                    backgroundColor: Theme.of(context).primaryColor,
                                                  ),
                                                );
                                              } else {
                                                delFav(int.parse(dbPackage[0]['fav']));
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: const Text(
                                                      'Produk telah berhasil dihapus dari Favorit.',
                                                      style: TextStyle(
                                                        fontFamily: 'Ubuntu',
                                                      ),
                                                    ),
                                                    backgroundColor: Theme.of(context).primaryColor,
                                                  ),
                                                );
                                              }
                                            }
                                          });
                                        },
                                      ),
                                    )
                                  ],
                                ),
                                onTap: () {
                                  prodId = int.parse(dbPackage[index]['id']);
                                  waNumber = dbSetup[0]['wa_number'];
                                  showModalBottomSheet(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(40),
                                        topRight: Radius.circular(40),
                                      ),
                                    ),
                                    backgroundColor: Colors.white,
                                    constraints: BoxConstraints(
                                      minHeight: 165.0.w,
                                      maxHeight: 165.0.w,
                                    ),
                                    isScrollControlled: true,
                                    context: context,
                                    isDismissible: false,
                                    builder: (context) => ViewProduct(),
                                  );
                                },
                              );
                            },
                          ),
                          SizedBox(height: 7.5.h,),
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
                              onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/aqiqah', (route) => false),
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
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class ViewProduct extends StatefulWidget {
  @override
  _ViewProductState createState() => _ViewProductState();
}

class _ViewProductState extends State<ViewProduct> {
  List dbSingle;
  var prodsDb = ProdsDb();

  Future getProdSingle(int id) async {
    var url;
    if (prefs.getIsSignIn)
      url = Uri.parse('https://sahabataqiqah.co.id/sahabat_bumil/api/get_prod_single.php?id=$id&phone=${prefs.getPhone}');
    else
      url = Uri.parse('https://sahabataqiqah.co.id/sahabat_bumil/api/get_prod_single.php?id=$id');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  Future addFav(String id) async {
    var url = 'https://sahabataqiqah.co.id/sahabat_bumil/api/add_fav.php';
    await http.post(Uri.parse(url), body: {
      'phone' : prefs.getPhone,
      'fav_prod' : id,
    });
  }

  Future delFav(int id) async {
    var url = 'https://sahabataqiqah.co.id/sahabat_bumil/api/del_fav.php';
    await http.post(Uri.parse(url), body: {
      'id' : id.toString(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pushReplacementNamed(context, '/closetopackage');
          return false;
        },
        child: FutureBuilder(
          future: getProdSingle(prodId),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data == null || snapshot.hasError) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SpinKitPulse(
                    color: Colors.white,
                  ),
                ],
              );
            }
            if (snapshot.connectionState == ConnectionState.done) {
              dbSingle = snapshot.data;
            }
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                      child: Container(
                        color: Theme.of(context).primaryColor,
                        height: 66.7.w,
                        child: Image.network(
                          dbSingle[0]['image'],
                          width: 100.0.w,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return SizedBox(
                              height: 66.7.w,
                              child: Center(
                                child: SpinKitPulse(
                                  color: Colors.white,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pushReplacementNamed(context, '/closetopackage');
                          },
                          child: Container(
                            width: 19.0.w,
                            height: 14.6.h,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(40),
                                topLeft: Radius.circular(40),
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
                        Expanded(child: SizedBox(),),
                        InkWell(
                          child: Image.asset(
                            dbSingle[0]['fav'] == null ? 'images/ic_unfav.png' : 'images/ic_fav.png',
                            width: 6.7.w,
                          ),
                          onTap: () {
                            setState(() {
                              prefs.setRoute('/package');
                              prefs.setGoRoute('/package');
                              if (!prefs.getIsSignIn) {
                                Navigator.pushNamed(context, '/register');
                              } else {
                                if (dbSingle[0]['fav'] == null) {
                                  addFav(dbSingle[0]['id']);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text(
                                        'Produk telah berhasil disimpan sebagai Favorit.',
                                        style: TextStyle(
                                          fontFamily: 'Ubuntu',
                                        ),
                                      ),
                                      backgroundColor: Theme.of(context).primaryColor,
                                    ),
                                  );
                                } else {
                                  delFav(int.parse(dbSingle[0]['fav']));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text(
                                        'Produk telah berhasil dihapus dari Favorit.',
                                        style: TextStyle(
                                          fontFamily: 'Ubuntu',
                                        ),
                                      ),
                                      backgroundColor: Theme.of(context).primaryColor,
                                    ),
                                  );
                                }
                              }
                            });
                          },
                        ),
                        SizedBox(width: 7.8.w,),
                      ],
                    ),
                  ],
                ),
                Stack(
                  children: [
                    SizedBox(
                      height: 98.0.w,
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6.9.w,),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 11.0.w,),
                              Text(
                                dbSingle[0]['prods_package'],
                                style: TextStyle(
                                  fontSize: 10.0.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              Text(
                                dbSingle[0]['name'],
                                style: TextStyle(
                                  fontSize: 23.0.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Theme.of(context).colorScheme.background,
                                ),
                              ),
                              SizedBox(height: 5.7.w,),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    NumberFormat.currency(
                                      locale: 'id',
                                      symbol: 'Rp ',
                                      decimalDigits: 0,
                                    ).format(int.parse(dbSingle[0]['price'])),
                                    style: TextStyle(
                                      fontSize: 16.0.sp,
                                      fontWeight: FontWeight.w700,
                                      color: Theme.of(context).colorScheme.background,
                                    ),
                                  ),
                                  Expanded(child: SizedBox(),),
                                  dbSingle[0]['promo'] == ''
                                      ? Container() : Container(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 4.4.w, vertical: 1.4.w,),
                                      child: Text(
                                        dbSingle[0]['promo'],
                                        style: TextStyle(
                                          fontSize: 8.0.sp,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5.2.w,),
                              Html(
                                data: dbSingle[0]['description'],
                                style: {
                                  'body': Style(
                                    color: Colors.black,
                                    fontSize: FontSize(11.0.sp),
                                    margin: EdgeInsets.all(0),
                                  )
                                },
                              ),
                              SizedBox(height: 35.5.w,),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                          height: 16.4.w,
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
                        SizedBox(height: 47.5.w,),
                        Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            Container(
                              height: 34.4.w,
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
                            InkWell(
                              onTap: () {
                                prefs.setIdProduct(prodId.toString());
                                Navigator.pushNamed(context, '/checkout');
                              },
                              child: Stack(
                                alignment: AlignmentDirectional.centerEnd,
                                children: [
                                  Container(
                                    width: 53.6.w,
                                    height: 20.8.w,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  SizedBox(
                                    width: 42.8.w,
                                    child: Center(
                                      child: Text(
                                        'Pesan',
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
                              padding: EdgeInsets.only(right: 42.8.w),
                              child: InkWell(
                                onTap: () {
                                  // ignore: deprecated_member_use
                                  launch('https://api.whatsapp.com/send?phone=' + waNumber +
                                      '&text=Assalamualaikum%2C+saya+dapat+info+dari+aplikasi+'
                                          '*Sahabat+Bumil*%2C+dan+ingin+bertanya+tentang+Aqiqah+anak+saya');
                                },
                                child: Container(
                                  width: 40.5.w,
                                  height: 20.8.w,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.background,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(40),
                                      bottomRight: Radius.circular(40),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Chat',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13.0.sp,
                                      ),
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
              ],
            );
          },
        ),
      ),
    );
  }
}
