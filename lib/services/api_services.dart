import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quiz/model/quiz_model.dart';

class ApiServices {
  Future<Map<String, dynamic>?> Question(int noOfQuestions) async {
    try {
      var res = await http.get(
          Uri.parse("https://opentdb.com/api.php?amount=${noOfQuestions}"));
      if (res.statusCode == 200) {
        return json.decode(res.body);
      } else {
        print('question response failed');
      }
    } catch (e) {
      print(e.toString());
    }
    return null;
  }
}
