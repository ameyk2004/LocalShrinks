import 'package:flutter/material.dart';

class QuizModel extends ChangeNotifier {
  int _totalPoints = 0;
  int _gad_points = 0;
  int _phq_points = 0;

  int get totalPoints => _totalPoints;
  int get gad_points => gad_points;
  int get phq_points => phq_points;

  void addPoints(int points, String type) {
    print(type);
    type == "PHQ" ? _phq_points+=points : _gad_points+=points;
    notifyListeners();
  }
  void setZero()
  {
    if(_totalPoints != 0) {
      _totalPoints = 0;
      notifyListeners();
    }
    if(_gad_points != 0) {
      _gad_points = 0;
      notifyListeners();
    }
    if(_phq_points != 0) {
      _phq_points = 0;
      notifyListeners();
    }
  }


  int showPoints()
  {
    return _totalPoints;
  }
  int showGADPoints()
  {
    return _gad_points;
  }
  int showPHQPoints()
  {
    return _phq_points;
  }
}