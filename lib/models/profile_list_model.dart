class ProfileListModel {
  String? name;
  String? photo;
  bool? visible;
  Function onTap;

  ProfileListModel({
     this.name,
     this.photo,
     this.visible,
    required this.onTap
  });
}