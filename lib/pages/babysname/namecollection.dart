// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sahabat_bumil_v2/db/fav_db.dart';
import 'package:sahabat_bumil_v2/main.dart';
import 'package:sahabat_bumil_v2/model/fav_model.dart';
import 'package:sizer/sizer.dart';
import 'package:fswitch/fswitch.dart';

class NameCollection extends StatefulWidget {
  @override
  _NameCollectionState createState() => _NameCollectionState();
}

class _NameCollectionState extends State<NameCollection> {
  bool isPerempuan = false;
  String title = 'Nama Laki-laki';
  AsyncSnapshot<dynamic> dbCat, dbCap, dbName, dbFirstCap;
  var favDb = FavDb();
  String id = '1';
  int selectedIndex = 0;
  int selectedCap = 0;
  String category, cap, sex;
  bool openFavName = false;

  @override
  void initState() {
    super.initState();

    if (prefs.getOpenFavName) {
      category = prefs.getCatName;
      selectedIndex = prefs.getSelectedIndexName;
      id = prefs.getIdName;
      cap = prefs.getCapName;
      selectedCap = prefs.getSelectedCapName;
      sex = prefs.getSexName;
      isPerempuan = prefs.getIsPerempuanName;
      prefs.setOpenFavName(false);
    } else {
      category = 'Semua';
      cap = 'A';
      sex = 'Laki-laki';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: favDb.listwcat1cap(sex, category),
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
            dbFirstCap = snapshot;
            if (category != 'Semua' && selectedCap == 0)
              cap = Fav.get(dbFirstCap.data[0]).favName.substring(0, 1);
          }
          return FutureBuilder(
            future: favDb.listCat(sex),
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
                dbCat = snapshot;
              }
              return FutureBuilder(
                future: category == 'Semua' ? favDb.listCapsAll(sex) : favDb.listCapsWCat(sex, category),
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
                    dbCap = snapshot;
                  }
                  return FutureBuilder(
                    future: category == 'Semua'
                        ? favDb.list(sex, cap)
                        : favDb.listwcat(sex, category, cap),
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
                        dbName = snapshot;
                      }
                      return Stack(
                        alignment: AlignmentDirectional.topEnd,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  width: 19.0.w,
                                  height: 15.0.h,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).backgroundColor,
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
                                padding: EdgeInsets.only(left: 4.4.w, bottom: 5.2.w),
                                child: Row(
                                  children: [
                                    FSwitch(
                                      open: isPerempuan,
                                      width: 12.0.w,
                                      height: 9.0.w,
                                      offset: 1.0,
                                      color: Theme.of(context).primaryColor,
                                      openColor: Theme.of(context).primaryColor,
                                      sliderChild: Image.asset(
                                        isPerempuan ? 'images/ic_woman.png' : 'images/ic_man.png',
                                        width: 3.3.w,
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          isPerempuan = value;
                                          if (isPerempuan) {
                                            title = 'Nama Perempuan';
                                            id = '2';
                                            sex = 'Perempuan';
                                          } else {
                                            title = 'Nama Laki-laki';
                                            id = '1';
                                            sex = 'Laki-laki';
                                          }
                                          selectedIndex = 0;
                                          category = 'Semua';
                                          cap = 'A';
                                          selectedCap = 0;
                                        });
                                      },
                                    ),
                                    SizedBox(width: 2.2.w,),
                                    Text(
                                      isPerempuan ? 'Nama Perempuan' : 'Nama Laki-laki',
                                      style: TextStyle(
                                        fontSize: 12.0.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(child: SizedBox()),
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 6.6.w, 4.0.w),
                                child: InkWell(
                                  onTap: () {
                                    prefs.setIsPerempuanName(isPerempuan);
                                    prefs.setSexName(sex);
                                    prefs.setSelectedIndexName(selectedIndex);
                                    prefs.setIdName(id);
                                    prefs.setCatName(category);
                                    prefs.setSelectedCapName(selectedCap);
                                    prefs.setCapName(cap);
                                    prefs.setOpenFavName(true);
                                    Navigator.pushReplacementNamed(context, '/favname');
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
                                            'images/ic_fav.png',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 19.1.h),
                            child: SizedBox(
                              height: 11.6.w,
                              child: ListView.builder(
                                itemCount: dbCat.data.length,
                                physics: BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                padding: EdgeInsets.only(left: 6.6.w, right: 4.4.w),
                                itemBuilder: (context, index) {
                                  Fav filterItem = Fav.get(dbCat.data[index]);
                                  var cat;
                                  switch (filterItem.favFilter.substring(filterItem.favFilter.length - 5)) {
                                    case 'Allah':
                                      cat = Runes(filterItem.favFilter + ' \ufdfb');
                                      break;
                                    case 'Nabi ':
                                      cat = Runes(filterItem.favFilter + '\ufdfa');
                                      break;
                                    default:
                                      cat = Runes(filterItem.favFilter);
                                      break;
                                  }
                                  return Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      InkWell(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(16)),
                                              border: Border.all(
                                                  color: selectedIndex == index
                                                      ? Colors.transparent : Theme.of(context).primaryColor
                                              ),
                                              color: selectedIndex == index
                                                  ? Theme.of(context).primaryColor : Colors.transparent
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.fromLTRB(4.4.w, 3.0.w, 4.4.w, 3.6.w),
                                            child: Text(
                                              String.fromCharCodes(cat),
                                              style: TextStyle(
                                                fontSize: 12.0.sp,
                                                color: selectedIndex == index
                                                    ? Colors.white : Theme.of(context).backgroundColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            selectedIndex = index;
                                            if (selectedIndex == 0) {
                                              category = 'Semua';
                                              cap = 'A';
                                            } else {
                                              category = filterItem.favCat;
                                            }
                                            selectedCap = 0;
                                          });
                                        },
                                      ),
                                      SizedBox(width: 2.2.w,),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 29.4.h),
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                              ),
                              child: Container(
                                width: 9.2.w,
                                color: Theme.of(context).backgroundColor,
                                constraints: BoxConstraints(minHeight: 70.6.h,),
                                child: ListView.builder(
                                  itemCount: dbCap.data.length,
                                  physics: BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  padding: EdgeInsets.fromLTRB(0,0,0,6.4.w),
                                  itemBuilder: (context, index) {
                                    Fav capsCatItem = Fav.get(dbCap.data[index]);
                                    return InkWell(
                                      onTap: () {
                                        setState(() {
                                          selectedCap = index;
                                          cap = capsCatItem.favName.substring(0,1);
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            bottomRight: Radius.circular(20),
                                          ),
                                          color: selectedCap == index
                                              ? Theme.of(context).primaryColor : Colors.transparent,
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(3.3.w),
                                          child: Center(
                                            child: Text(
                                              capsCatItem.favName.substring(0,1),
                                              style: TextStyle(
                                                fontSize: 10.0.sp,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 6.6.w, top: 29.4.h, right: 12.5.w),
                            child: Row(
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
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 6.6.w, top: 32.8.h, right: 12.5.w),
                            child: SizedBox(
                              child: ListView.builder(
                                itemCount: dbName.data.length,
                                physics: BouncingScrollPhysics(),
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 4.0.h),
                                itemBuilder: (context, index) {
                                  Fav nameItem = Fav.get(dbName.data[index]);
                                  return Container(
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
                                                nameItem.favName,
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
                                                data: nameItem.favDesc,
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
                                                nameItem.favCheck == 0 ? 'images/ic_unfav.png' : 'images/ic_fav.png',
                                                width: 5.6.w,
                                              ),
                                            ),
                                            onTap: () {
                                              setState(() {
                                                if (nameItem.favCheck == 1) {
                                                  var check = Fav(
                                                    favId: nameItem.favId,
                                                    favCheck: 0,
                                                  );
                                                  favDb.updateFav(check);
                                                } else {
                                                  var check = Fav(
                                                    favId: nameItem.favId,
                                                    favCheck: 1,
                                                  );
                                                  favDb.updateFav(check);
                                                }
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      );
                    },
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