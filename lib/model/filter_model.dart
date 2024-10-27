
class FilterModel {
  String cityName;
  bool cityStatus = false;
  FilterModel(this.cityName, this.cityStatus){

  }


@override
  String toString() {
    return cityName;
  }
}