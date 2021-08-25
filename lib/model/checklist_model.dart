class Checklist {
  int cl_week, cl_index, cl_checked;
  String cl_title, cl_image, cl_id;

  Checklist({this.cl_id, this.cl_week, this.cl_title, this.cl_image, this.cl_checked});

  int get checklist_id => checklist_id;
  int get checklist_week => checklist_week;
  int get checklist_title => checklist_title;
  int get checklist_image => checklist_image;
  int get checklist_checked => checklist_checked;

  factory Checklist.get(Map<String, dynamic> data) => new Checklist(
    cl_id: data['cl_id'],
    cl_week: data['cl_week'],
    cl_title: data['cl_title'],
    cl_image: data['cl_image'],
    cl_checked: data['cl_checked'],
  );

  Map<String, dynamic> set() => {
    'cl_id': cl_id,
    'cl_week': cl_week,
    'cl_title': cl_title,
    'cl_image': cl_image,
    'cl_checked': cl_checked,
  };
}