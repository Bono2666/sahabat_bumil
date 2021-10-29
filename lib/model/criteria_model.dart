class Criteria {
  String crit_sex, crit_pos, crit_cat;

  Criteria({this.crit_sex, this.crit_pos, this.crit_cat});

  factory Criteria.get(Map<String, dynamic> data) => new Criteria(
    crit_sex: data['crit_sex'],
    crit_pos: data['crit_pos'],
    crit_cat: data['crit_cat'],
  );

  Map<String, dynamic> set() => {
    'crit_sex': crit_sex,
    'crit_pos': crit_pos,
    'crit_cat': crit_cat,
  };
}