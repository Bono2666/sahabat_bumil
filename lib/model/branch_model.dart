// @dart=2.9
class Branch {
  int branchId;
  double branchDistance;

  Branch({this.branchId, this.branchDistance});

  Map<String, dynamic> updateDistance() => {
    'branch_id': branchId,
    'branch_distance': branchDistance,
  };
}