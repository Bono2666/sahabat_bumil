// @dart=2.9
class Prods {
  int prodsId, prodsFav;

  Prods({this.prodsId, this.prodsFav});

  Map<String, dynamic> updateFav() => {
    'prods_id': prodsId,
    'prods_fav': prodsFav,
  };
}