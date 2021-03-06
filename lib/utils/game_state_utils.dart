import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:superagile_app/ui/views/congratulations_page.dart';
import 'package:superagile_app/ui/views/final_page.dart';
import 'package:superagile_app/ui/views/game_question_page.dart';
import 'package:superagile_app/ui/views/question_results_page.dart';
import 'package:superagile_app/ui/views/waiting_room_page.dart';

class GameState {
  static const String WAITING_ROOM = 'waitingRoom';
  static const String QUESTION = 'question';
  static const String QUESTION_RESULTS = 'results';
  static const String CONGRATULATIONS = 'congratulations';
  static const String FINAL = 'final';
}

const String STATE_NUMBER_DELIMITER = '_';

int parseSequenceNumberFromGameState(String gameState) => int.parse(gameState.split(STATE_NUMBER_DELIMITER).last);

Future<MaterialPageRoute<dynamic>> joinCreatedGameAsExistingUser(
    String gameState, DocumentReference playerRef, DocumentReference gameRef, BuildContext context) {
  return Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) {
      if (gameState == GameState.WAITING_ROOM) {
        return WaitingRoomPage(gameRef, playerRef);
      }
      if (gameState.contains(GameState.QUESTION)) {
        return GameQuestionPage(parseSequenceNumberFromGameState(gameState), playerRef, gameRef);
      }
      if (gameState.contains(GameState.QUESTION_RESULTS)) {
        return QuestionResultsPage(
            questionNr: parseSequenceNumberFromGameState(gameState), gameRef: gameRef, playerRef: playerRef);
      }
      if (gameState.contains(GameState.CONGRATULATIONS)) {
        return CongratulationsPage(parseSequenceNumberFromGameState(gameState), playerRef, gameRef);
      }
      if (gameState == GameState.FINAL) {
        return FinalPage(playerRef, gameRef);
      }
      throw ('Game state and route page does not match.');
    }),
  );
}
