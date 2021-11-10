class CriteriaName {
  String crit_id, crit_cat, crit_filter;

  CriteriaName({this.crit_id, this.crit_cat, this.crit_filter});

  factory CriteriaName.get(Map<String, dynamic> data) => new CriteriaName(
    crit_id: data['crit_id'],
    crit_cat: data['crit_cat'],
    crit_filter: data['crit_filter'],
  );

  Map<String, dynamic> set() => {
    'crit_id': crit_id,
    'crit_cat': crit_cat,
    'crit_filter': crit_filter,
  };
}