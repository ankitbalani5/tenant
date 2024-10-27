
class GenderModel {
  String genderName;
  bool genderStatus = false;
  GenderModel(this.genderName, this.genderStatus){

  }


  @override
  String toString() {
    return genderName;
  }
}