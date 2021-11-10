class FavTmp {
  String fav_id;
  int fav_check;

  FavTmp({this.fav_id, this.fav_check});

  factory FavTmp.get(Map<String, dynamic> data) => new FavTmp(
    fav_id: data['fav_id'],
    fav_check: data['fav_check'],
  );

  Map<String, dynamic> set() => {
    'fav_id': fav_id,
    'fav_check': fav_check,
  };
}