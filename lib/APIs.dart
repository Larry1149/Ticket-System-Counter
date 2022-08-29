import 'package:http/http.dart' as http;

var uriDomain ="https://nquestions2.000webhostapp.com/Q2.php";

class Functions{
  static Future<String> counterOfCounter() async {
    var request = http.MultipartRequest('POST', Uri.parse(uriDomain));
    request.fields.addAll({
      "action":'count_of_counter',
    });
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      return await response.stream.bytesToString();
    }
    else {
      return "";
    }
  }

  static Future<String> counterStatus(cID) async {
    var request = http.MultipartRequest('POST', Uri.parse(uriDomain));
    request.fields.addAll({
      "action":'counter_status',
      "cID" : cID
    });
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      return await response.stream.bytesToString();
    }
    else {
      return "";
    }
  }

  static Future<String> updateCounterStatus(cID,OnOffline) async {
    var request = http.MultipartRequest('POST', Uri.parse(uriDomain));
    request.fields.addAll({
      "action":'update_counter_status',
      "cID" : cID,
      "status" : OnOffline,
    });
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      return await response.stream.bytesToString();
    }
    else {
      return "";
    }
  }

  static Future<String> completeCurrent(cID) async {
    var request = http.MultipartRequest('POST', Uri.parse(uriDomain));
    request.fields.addAll({
      "action":'complete_current',
      "cID" : cID
    });
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      return await response.stream.bytesToString();
    }
    else {
      return "";
    }
  }

  static Future<String> callNext(cID) async {
    var request = http.MultipartRequest('POST', Uri.parse(uriDomain));
    request.fields.addAll({
      "action":'call_next',
      "cID" : cID
    });
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      return await response.stream.bytesToString();
    }
    else {
      return "";
    }
  }

  static Future<String> counterOfWaiting() async {
    var request = http.MultipartRequest('POST', Uri.parse(uriDomain));
    request.fields.addAll({
      "action":'count_of_waiting',
    });
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      return await response.stream.bytesToString();
    }
    else {
      return "";
    }
  }

}
