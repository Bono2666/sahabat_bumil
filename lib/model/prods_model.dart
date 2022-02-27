class Prods {
  int prods_id, prods_fav;

  Prods({this.prods_id, this.prods_fav});

  Map<String, dynamic> updateFav() => {
    'prods_id': prods_id,
    'prods_fav': prods_fav,
  };
}