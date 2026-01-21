class AppUtilities{

  static double convertToDouble({required  item}){
    if(item == null){
      return 0;
    }
    String temp = item.toString();
    return double.tryParse(temp)??0;
  }

  static int? convertToInt({required  item}){
    return int.tryParse("${item}");
  }


  static DateTime convertToDateTime({required String? dateTime}){
    return (DateTime.tryParse(dateTime??"")??DateTime.now()).toLocal();
  }

}