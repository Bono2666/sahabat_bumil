class CriteriaName {
  String crit_id, crit_cat;

  CriteriaName({this.crit_id, this.crit_cat});

  factory CriteriaName.get(Map<String, dynamic> data) => new CriteriaName(
    crit_id: data['crit_id'],
    crit_cat: data['crit_cat'],
  );

  Map<String, dynamic> set() => {
    'crit_id': crit_id,
    'crit_cat': crit_cat,
  };
}