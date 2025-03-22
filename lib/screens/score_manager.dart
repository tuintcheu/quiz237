import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ScoreManager {
  // Clés spécifiques pour chaque niveau
  static const String KEY_FACILE = 'scores_facile';
  static const String KEY_NORMAL = 'scores_normal';
  static const String KEY_DIFFICILE = 'scores_difficile';

  // Obtenir la clé appropriée en fonction du niveau
  static String _getKeyForLevel(String level) {
    switch (level.toLowerCase()) {
      case 'facile':
        return KEY_FACILE;
      case 'normal':
        return KEY_NORMAL;
      case 'difficile':
        return KEY_DIFFICILE;
      default:
      // Par défaut, si un niveau inconnu est fourni
        return 'scores_${level.toLowerCase()}';
    }
  }

  // Ajouter un score (méthode standard)
  static Future<void> addScore(String name, int score, String level) async {
    try {
      // Normaliser le niveau pour éviter les problèmes de casse
      final levelKey = _getKeyForLevel(level);

      final prefs = await SharedPreferences.getInstance();

      // Récupérer les scores existants pour ce niveau
      List<String> scoresList = prefs.getStringList(levelKey) ?? [];

      // Créer l'objet score
      Map<String, dynamic> scoreData = {
        'name': name,
        'score': score,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };

      // Ajouter à la liste
      scoresList.add(jsonEncode(scoreData));

      // Sauvegarder
      await prefs.setStringList(levelKey, scoresList);

      print('Score ajouté avec succès: $scoreData pour le niveau $level');
    } catch (e) {
      print('Erreur lors de l\'ajout du score: $e');
    }
  }

  // Ajouter un score en évitant les doublons
  static Future<void> addScoreNoDuplicates(String name, int score, String level) async {
    try {
      // Normaliser le niveau pour éviter les problèmes de casse
      final levelKey = _getKeyForLevel(level);

      final prefs = await SharedPreferences.getInstance();

      // Récupérer les scores existants pour ce niveau
      List<String> scoresList = prefs.getStringList(levelKey) ?? [];

      // Vérifier si un score identique existe déjà
      bool isDuplicate = false;

      for (String scoreStr in scoresList) {
        try {
          Map<String, dynamic> existingScore = jsonDecode(scoreStr);
          // Si le même joueur a le même score, c'est un doublon
          if (existingScore['name'] == name && existingScore['score'] == score) {
            isDuplicate = true;
            print('Score doublon détecté pour $name avec $score points - non ajouté');
            break;
          }
        } catch (e) {
          print('Erreur lors du décodage d\'un score: $e');
        }
      }

      // Si ce n'est pas un doublon, ajouter le score
      if (!isDuplicate) {
        // Créer l'objet score
        Map<String, dynamic> scoreData = {
          'name': name,
          'score': score,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        };

        // Ajouter à la liste
        scoresList.add(jsonEncode(scoreData));

        // Sauvegarder
        await prefs.setStringList(levelKey, scoresList);

        print('Score ajouté avec succès: $scoreData pour le niveau $level');
      }
    } catch (e) {
      print('Erreur lors de l\'ajout du score: $e');
    }
  }

  // Récupérer tous les scores pour un niveau
  static Future<List<Map<String, dynamic>>> getScoresByLevel(String level) async {
    try {
      // Normaliser le niveau
      final levelKey = _getKeyForLevel(level);

      final prefs = await SharedPreferences.getInstance();
      List<String> scoresList = prefs.getStringList(levelKey) ?? [];

      // Convertir la liste de chaînes en liste d'objets
      List<Map<String, dynamic>> scores = [];

      for (String scoreStr in scoresList) {
        try {
          Map<String, dynamic> scoreMap = jsonDecode(scoreStr);
          scores.add(scoreMap);
        } catch (e) {
          print('Erreur lors du décodage d\'un score: $e');
          // Ignorer les entrées invalides
        }
      }

      print('${scores.length} scores récupérés pour le niveau $level');
      return scores;
    } catch (e) {
      print('Erreur lors de la récupération des scores: $e');
      return []; // Retourner une liste vide en cas d'erreur
    }
  }

  // Récupérer tous les scores (tous niveaux confondus)
  static Future<List<Map<String, dynamic>>> getAllScores() async {
    List<Map<String, dynamic>> allScores = [];

    try {
      final prefs = await SharedPreferences.getInstance();

      // Récupérer les scores pour chaque niveau
      final facileScores = prefs.getStringList(KEY_FACILE) ?? [];
      final normalScores = prefs.getStringList(KEY_NORMAL) ?? [];
      final difficileScores = prefs.getStringList(KEY_DIFFICILE) ?? [];

      // Fonction pour traiter chaque niveau
      void processScores(List<String> scores, String level) {
        for (String scoreStr in scores) {
          try {
            Map<String, dynamic> scoreMap = jsonDecode(scoreStr);
            scoreMap['level'] = level; // Ajouter le niveau pour référence
            allScores.add(scoreMap);
          } catch (e) {
            print('Erreur lors du décodage d\'un score: $e');
          }
        }
      }

      // Traiter chaque niveau
      processScores(facileScores, 'facile');
      processScores(normalScores, 'normal');
      processScores(difficileScores, 'difficile');

      print('${allScores.length} scores récupérés au total');
      return allScores;
    } catch (e) {
      print('Erreur lors de la récupération des scores: $e');
      return [];
    }
  }

  // Effacer les scores d'un niveau spécifique
  static Future<void> clearScoresByLevel(String level) async {
    try {
      final levelKey = _getKeyForLevel(level);

      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(levelKey);

      print('Scores effacés pour le niveau $level');
    } catch (e) {
      print('Erreur lors de la suppression des scores: $e');
    }
  }

  // Effacer tous les scores
  static Future<void> clearScores() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.remove(KEY_FACILE);
      await prefs.remove(KEY_NORMAL);
      await prefs.remove(KEY_DIFFICILE);

      print('Tous les scores ont été effacés');
    } catch (e) {
      print('Erreur lors de la suppression des scores: $e');
    }
  }

  // Méthode pour tester l'enregistrement de scores
  static Future<void> addTestScores() async {
    await addScore("Test1", 25, "facile");
    await addScore("Test2", 40, "facile");
    await addScore("Test3", 15, "normal");
    await addScore("Test4", 35, "normal");
    await addScore("Test5", 50, "difficile");
    print("Scores de test ajoutés avec succès");
  }
}