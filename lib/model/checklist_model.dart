// @dart=2.9
class Checklist {
  int clWeek, clIndex, clChecked;
  String clTitle, clImage, clId;

  Checklist({this.clId, this.clWeek, this.clTitle, this.clImage, this.clChecked});

  factory Checklist.get(Map<String, dynamic> data) => new Checklist(
    clId: data['cl_id'],
    clWeek: data['cl_week'],
    clTitle: data['cl_title'],
    clImage: data['cl_image'],
    clChecked: data['cl_checked'],
  );

  Map<String, dynamic> set() => {
    'cl_id': clId,
    'cl_week': clWeek,
    'cl_title': clTitle,
    'cl_image': clImage,
    'cl_checked': clChecked,
  };
}