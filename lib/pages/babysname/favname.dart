import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sahabat_bumil_v2/db/fav_db.dart';
import 'package:sahabat_bumil_v2/model/fav_model.dart';
import 'package:sizer/sizer.dart';

class FavName extends StatefulWidget {
  @override
  _FavNameState createState() => _FavNameState();
}

class _FavNameState extends State<FavName> {
  AsyncSnapshot<dynamic> dbFav;
  var favDb = FavDb();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Navigator.pushReplacementNamed(context, '/namecollection');
      },
      child: Scaffold(
        body: FutureBuilder(
          future: favDb.listfav(),
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
              dbFav = snapshot;
            }
            return Stack(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/namecollection');
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
                Padding(
                  padding: EdgeInsets.only(left: 6.6.w, top: 19.0.h, right: 6.6.w),
                  child: Text(
                    'Nama Favorit',
                    style: TextStyle(
                      color: Theme.of(context).backgroundColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 24.0.sp,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 6.6.w, top: 27.5.h, right: 6.6.w),
                  child: dbFav.data.length > 0
                      ? Row(
                    children: [
                      SizedBox(
                        child: Text(
                          'Nama',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 10.0.sp,
                          ),
                        ),
                        width: 27.8.w,
                      ),
                      Text(
                        'Arti',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 10.0.sp,
                        ),
                      ),
                    ],
                  )
                      : Column(
                    children: [
                      SizedBox(height: 2.5.h,),
                      Image.asset(
                        'images/no_fav_name.png',
                        height: 62.0.w,
                      ),
                      SizedBox(height: 3.4.h,),
                      Text(
                        'Buat daftar nama favorit pertama Anda',
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
                          'Saat Ayah/Bunda mencari nama dede bayi, ketuk ikon hati '
                              'untuk menyimpan nama favorit Ayah/Bunda ke daftar favorit.',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 10.0.sp,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 6.6.w, top: 30.9.h, right: 6.6.w),
                  child: SizedBox(
                    child: dbFav.data.length > 0 ? ListView.builder(
                      itemCount: dbFav.data.length,
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 4.0.h),
                      itemBuilder: (context, index) {
                        Fav favItem = Fav.get(dbFav.data[index]);
                        return
                        Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Theme.of(context).secondaryHeaderColor,
                              ),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 1.0.h),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 1.8.h,),
                                  child: SizedBox(
                                    child: Text(
                                      favItem.fav_name,
                                      style: TextStyle(
                                        fontSize: 12.0.sp,
                                        color: Theme.of(context).backgroundColor,
                                      ),
                                    ),
                                    width: 26.0.w,
                                  ),
                                ),
                                Flexible(
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 0.5.h),
                                    child: Html(
                                      data: favItem.fav_desc,
                                      style: {
                                        'body': Style(
                                          fontSize: FontSize(12.0.sp),
                                          color: Theme.of(context).backgroundColor,
                                          lineHeight: LineHeight(1.0.sp),
                                        ),
                                      },
                                    ),
                                  ),
                                ),
                                InkWell(
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 1.8.h),
                                    child: Image.asset(
                                      'images/ic_fav.png',
                                      width: 5.6.w,
                                    ),
                                  ),
                                  onTap: () {
                                    var check = Fav(
                                      fav_id: favItem.fav_id,
                                      fav_check: 0,
                                    );
                                    favDb.updateFav(check);
                                    setState(() {});
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ) : Container(),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}