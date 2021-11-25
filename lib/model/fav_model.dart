class Fav {
  String fav_id, fav_name, fav_sex, fav_desc, fav_cat, fav_filter, fav_status;
  int fav_no_cat, fav_prefix, fav_middle, fav_sufix, fav_check;

  Fav({this.fav_id, this.fav_name, this.fav_sex, this.fav_desc, this.fav_no_cat, this.fav_cat,
    this.fav_filter, this.fav_prefix, this.fav_middle, this.fav_sufix, this.fav_check, this.fav_status});

  factory Fav.get(Map<String, dynamic> data) => new Fav(
    fav_id: data['fav_id'],
    fav_name: data['fav_name'],
    fav_sex: data['fav_sex'],
    fav_desc: data['fav_desc'],
    fav_no_cat: data['fav_no_cat'],
    fav_cat: data['fav_cat'],
    fav_filter: data['fav_filter'],
    fav_prefix: data['fav_prefix'],
    fav_middle: data['fav_middle'],
    fav_sufix: data['fav_sufix'],
    fav_check: data['fav_check'],
    fav_status: data['fav_status'],
  );

  Map<String, dynamic> set() => {
    'fav_id': fav_id,
    'fav_name': fav_name,
    'fav_sex': fav_sex,
    'fav_desc': fav_desc,
    'fav_no_cat': fav_no_cat,
    'fav_cat': fav_cat,
    'fav_filter': fav_filter,
    'fav_prefix': fav_prefix,
    'fav_middle': fav_middle,
    'fav_sufix': fav_sufix,
    'fav_check': fav_check,
    'fav_status': fav_status,
  };

  Map<String, dynamic> update() => {
    'fav_id': fav_id,
    'fav_name': fav_name,
    'fav_sex': fav_sex,
    'fav_desc': fav_desc,
    'fav_no_cat': fav_no_cat,
    'fav_cat': fav_cat,
    'fav_filter': fav_filter,
    'fav_prefix': fav_prefix,
    'fav_middle': fav_middle,
    'fav_sufix': fav_sufix,
    'fav_status': fav_status,
  };

  Map<String, dynamic> updateFav() => {
    'fav_id': fav_id,
    'fav_check': fav_check,
  };
}