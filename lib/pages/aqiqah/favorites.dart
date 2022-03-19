// @dart=2.9
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';
import 'package:sahabat_bumil_v2/main.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import '../../db/prods_db.dart';
import '../../model/prods_model.dart';

int prodId = 1;
String waNumber;

class Favorites extends StatefulWidget {
  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  List dbFav, dbSetup;
  var prodsDb = ProdsDb();

  Future getSetup() async {
    var url = Uri.parse('https://sahabataqiqah.co.id/sahabat_bumil/api/get_setup.php');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pushReplacementNamed(context, '/closetofavorites');
          return false;
        },
        child: FutureBuilder(
          future: prodsDb.favList(),
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
              dbFav = snapshot.data;
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
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 7.0.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 19.0.h,),
                                Text(
                                  'Aqiqah Favorit',
                                  style: TextStyle(
                                    color: Theme.of(context).backgroundColor,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 24.0.sp,
                                  ),
                                ),
                                SizedBox(height: 3.4.h,),
                                dbFav.length > 0
                                    ? SizedBox(
                                  child: ListView.builder(
                                    itemCount: dbFav.length,
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    padding: EdgeInsets.only(top: 0),
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: EdgeInsets.only(bottom: 6.7.w,),
                                        child: InkWell(
                                          child: Stack(
                                            alignment: AlignmentDirectional.topEnd,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  Expanded(
                                                    child: SizedBox(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.end,
                                                        children: [
                                                          Text(
                                                            dbFav[index]['prods_package'] + ' - ' +
                                                                dbFav[index]['prods_name'],
                                                            textAlign: TextAlign.right,
                                                            style: TextStyle(
                                                              fontSize: 13.0.sp,
                                                              fontWeight: FontWeight.w700,
                                                              color: Theme.of(context).backgroundColor,
                                                            ),
                                                          ),
                                                          SizedBox(height: 1.1.w,),
                                                          Html(
                                                            data: dbFav[index]['prods_desc'],
                                                            style: {
                                                              'body': Style(
                                                                color: Colors.black,
                                                                fontSize: FontSize(8.0.sp),
                                                                maxLines: 2,
                                                                textAlign: TextAlign.right,
                                                                textOverflow: TextOverflow.ellipsis,
                                                                margin: EdgeInsets.all(0),
                                                              )
                                                            },
                                                          ),
                                                          SizedBox(height: 6.7.w,),
                                                          Row(
                                                            children: [
                                                              dbFav[index]['prods_promo'] == ''
                                                                  ? Container() : Container(
                                                                child: Padding(
                                                                  padding: EdgeInsets.symmetric(
                                                                    horizontal: 4.4.w, vertical: 1.4.w,),
                                                                  child: Text(
                                                                    dbFav[index]['prods_promo'],
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
                                                              Expanded(child: SizedBox(),),
                                                              Text(
                                                                NumberFormat.currency(
                                                                  locale: 'id',
                                                                  symbol: 'Rp ',
                                                                  decimalDigits: 0,
                                                                ).format(dbFav[index]['prods_price']),
                                                                textAlign: TextAlign.right,
                                                                style: TextStyle(
                                                                  fontSize: 10.0.sp,
                                                                  color: Theme.of(context).backgroundColor,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(height: 1.1.w,),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 4.4.w,),
                                                  ClipRRect(
                                                    borderRadius: BorderRadius.all(
                                                      Radius.circular(12),
                                                    ),
                                                    child: Container(
                                                      width: 31.1.w,
                                                      height: 32.0.w,
                                                      child: Image.network(
                                                        dbFav[index]['prods_image'],
                                                        fit: BoxFit.cover,
                                                        loadingBuilder: (context, child, loadingProgress) {
                                                          if (loadingProgress == null) return child;
                                                          return SizedBox(
                                                            height: 32.0.w,
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
                                                ],
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(right: 3.3.w, top: 3.3.w),
                                                child: InkWell(
                                                  child: Image.asset(
                                                    dbFav[index]['prods_fav'] == 0 ? 'images/ic_unfav.png' : 'images/ic_fav.png',
                                                    width: 4.4.w,
                                                  ),
                                                  onTap: () {
                                                    setState(() {
                                                      if (dbFav[index]['prods_fav'] == 1) {
                                                        var fav = Prods(
                                                          prodsId: dbFav[index]['prods_id'],
                                                          prodsFav: 0,
                                                        );
                                                        prodsDb.updateFav(fav);
                                                      } else {
                                                        var fav = Prods(
                                                          prodsId: dbFav[index]['prods_id'],
                                                          prodsFav: 1,
                                                        );
                                                        prodsDb.updateFav(fav);
                                                      }
                                                    });
                                                  },
                                                ),
                                              )
                                            ],
                                          ),
                                          onTap: () {
                                            prodId = dbFav[index]['prods_id'];
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
                                        ),
                                      );
                                    },
                                  ),
                                )
                                    : Column(
                                      children: [
                                        SizedBox(height: 2.5.h,),
                                        Image.asset(
                                          'images/no_favs.png',
                                          height: 62.0.w,
                                        ),
                                        SizedBox(height: 3.4.h,),
                                        Text(
                                          'Buat daftar aqiqah favorit pertama Anda',
                                          style: TextStyle(
                                            color: Theme.of(context).backgroundColor,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 12.0.sp,
                                          ),
                                        ),
                                        SizedBox(height: 0.6.h,),
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 2.2.w),
                                          child: Text(
                                            'Saat Ayah/Bunda mencari paket aqiqah, ketuk ikon hati '
                                                'untuk menyimpan aqiqah favorit Ayah/Bunda ke daftar favorit.',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 10.0.sp,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 7.5.h,),
                        ],
                      ),
                    ),
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Navigator.pushReplacementNamed(context, '/closetofavorites'),
      child: FutureBuilder(
        future: prodsDb.single(prodId),
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
                        dbSingle[0]['prods_image'],
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
                          Navigator.pushReplacementNamed(context, '/closetofavorites');
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
                      Expanded(child: SizedBox(),),
                      InkWell(
                        child: Image.asset(
                          dbSingle[0]['prods_fav'] == 0 ? 'images/ic_unfav.png' : 'images/ic_fav.png',
                          width: 6.7.w,
                        ),
                        onTap: () {
                          setState(() {
                            if (dbSingle[0]['prods_fav'] == 1) {
                              var fav = Prods(
                                prodsId: dbSingle[0]['prods_id'],
                                prodsFav: 0,
                              );
                              prodsDb.updateFav(fav);
                            } else {
                              var fav = Prods(
                                prodsId: dbSingle[0]['prods_id'],
                                prodsFav: 1,
                              );
                              prodsDb.updateFav(fav);
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
                              dbSingle[0]['prods_name'],
                              style: TextStyle(
                                fontSize: 23.0.sp,
                                fontWeight: FontWeight.w700,
                                color: Theme.of(context).backgroundColor,
                              ),
                            ),
                            SizedBox(height: 6.7.w,),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  NumberFormat.currency(
                                    locale: 'id',
                                    symbol: 'Rp ',
                                    decimalDigits: 0,
                                  ).format(dbSingle[0]['prods_price']),
                                  style: TextStyle(
                                    fontSize: 16.0.sp,
                                    fontWeight: FontWeight.w700,
                                    color: Theme.of(context).backgroundColor,
                                  ),
                                ),
                                Expanded(child: SizedBox(),),
                                dbSingle[0]['prods_promo'] == ''
                                    ? Container() : Container(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 4.4.w, vertical: 1.4.w,),
                                    child: Text(
                                      dbSingle[0]['prods_promo'],
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
                              data: dbSingle[0]['prods_desc'],
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
                                launch('https://api.whatsapp.com/send?phone=' + waNumber +
                                    '&text=Assalamualaikum%2C+saya+dapat+info+dari+aplikasi+'
                                        '*Sahabat+Bumil*%2C+dan+ingin+bertanya+tentang+Aqiqah+anak+saya');
                              },
                              child: Container(
                                width: 40.5.w,
                                height: 20.8.w,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).backgroundColor,
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
    );
  }
}
