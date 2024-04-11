import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:quiz_app/models/state.dart';
import 'package:test/test.dart';
import 'state_test.mocks.dart';
import 'questions.dart';

@GenerateMocks([http.Client])
void main() {
  //sets up mock client
  final client = MockClient();

    when(client.get(Uri.parse('https://stevecassidy.github.io/harry-potter-quiz-app/lib/data/questions.json')))
      .thenAnswer((_) async => http.Response(jsonEncode(questionsJson), 200));

    var testState = StateModel(client);

  test('State model returns quiz questions', () {
    testState.addListener(() {
      expect(testState.questions.length, 6);
      expect(testState.getCurrentQuestion().questionText, startsWith("What"));
    });
  });

  test('advanceQuestion returns the next question', () {
    testState.addListener(() {
      int temp = testState.currentQuestionNumber;
      testState.advanceQuestion;
      expect(testState.currentQuestionNumber, temp+1);
    });
  });

  test('addAnswer adds an answer', () {
    testState.addListener(() {
      testState.addAnswer('wagga');
      expect(testState.answers[testState.currentQuestion], 'wagga');
    });
  });

}