// import 'dart:async' show Future;
import 'dart:convert';

class HandleSnapshot {
  static dynamic load(String jsonString) async {
    final jsonResponse = await json.decode(jsonString);
    return jsonResponse;
  }

  static List<T> castList<T>(List<dynamic> fromJson, T type) {
    List<T> x = fromJson.cast<T>();
    return x;
  }

  // static List rawListToList(Map<String, dynamic> parsedJson){
  //   List newList = parsedJson.map((i)=>ClassName.fromJson(i)).toList();
  // }
}
