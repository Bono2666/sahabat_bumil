class Branch {
  int branch_id;
  double branch_distance;

  Branch({this.branch_id, this.branch_distance});

  Map<String, dynamic> updateDistance() => {
    'branch_id': branch_id,
    'branch_distance': branch_distance,
  };
}