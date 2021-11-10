class Fav {
  String fav_id, fav_name, fav_sex, fav_desc, fav_cat, fav_filter;
  int fav_check;

  Fav({this.fav_id, this.fav_name, this.fav_sex, this.fav_desc, this.fav_cat, this.fav_filter, this.fav_check});

  factory Fav.get(Map<String, dynamic> data) => new Fav(
    fav_id: data['fav_id'],
    fav_name: data['fav_name'],
    fav_sex: data['fav_sex'],
    fav_desc: data['fav_desc'],
    fav_cat: data['fav_cat'],
    fav_filter: data['fav_filter'],
    fav_check: data['fav_check'],
  );

  Map<String, dynamic> set() => {
    'fav_id': fav_id,
    'fav_name': fav_name,
    'fav_sex': fav_sex,
    'fav_desc': fav_desc,
    'fav_cat': fav_cat,
    'fav_filter': fav_filter,
    'fav_check': fav_check,
  };

  Map<String, dynamic> update() => {
    'fav_id': fav_id,
    'fav_check': fav_check,
  };
}