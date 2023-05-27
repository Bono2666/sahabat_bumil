class Fav {
  String favId, favName, favSex, favDesc, favCat, favFilter, favStatus;
  int favNoCat, favPrefix, favMiddle, favSuffix, favCheck;

  Fav({this.favId, this.favName, this.favSex, this.favDesc, this.favNoCat, this.favCat,
    this.favFilter, this.favPrefix, this.favMiddle, this.favSuffix, this.favCheck, this.favStatus});

  factory Fav.get(Map<String, dynamic> data) => new Fav(
    favId: data['fav_id'],
    favName: data['fav_name'],
    favSex: data['fav_sex'],
    favDesc: data['fav_desc'],
    favNoCat: data['fav_no_cat'],
    favCat: data['fav_cat'],
    favFilter: data['fav_filter'],
    favPrefix: data['fav_prefix'],
    favMiddle: data['fav_middle'],
    favSuffix: data['fav_sufix'],
    favCheck: data['fav_check'],
    favStatus: data['fav_status'],
  );

  Map<String, dynamic> set() => {
    'fav_id': favId,
    'fav_name': favName,
    'fav_sex': favSex,
    'fav_desc': favDesc,
    'fav_no_cat': favNoCat,
    'fav_cat': favCat,
    'fav_filter': favFilter,
    'fav_prefix': favPrefix,
    'fav_middle': favMiddle,
    'fav_sufix': favSuffix,
    'fav_check': favCheck,
    'fav_status': favStatus,
  };

  Map<String, dynamic> update() => {
    'fav_id': favId,
    'fav_name': favName,
    'fav_sex': favSex,
    'fav_desc': favDesc,
    'fav_no_cat': favNoCat,
    'fav_cat': favCat,
    'fav_filter': favFilter,
    'fav_prefix': favPrefix,
    'fav_middle': favMiddle,
    'fav_sufix': favSuffix,
    'fav_status': favStatus,
  };

  Map<String, dynamic> updateFav() => {
    'fav_id': favId,
    'fav_check': favCheck,
  };
}