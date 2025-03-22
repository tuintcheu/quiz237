import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
import 'quiz_screen.dart';

class LevelSelectionScreen extends StatefulWidget {
  final String playerName;
  final int playerAge;

  LevelSelectionScreen({required this.playerName, required this.playerAge});

  @override
  _LevelSelectionScreenState createState() => _LevelSelectionScreenState();
}

class _LevelSelectionScreenState extends State<LevelSelectionScreen> {
  // Niveau sélectionné actuellement
  String? selectedLevel;

  // Information sur les niveaux
  final Map<String, Map<String, dynamic>> levels = {
    'facile': {
      'icon': Icons.sentiment_satisfied_outlined,
      'color': Colors.green,
      'questions': 10,
      'timer': 20,
      'description': '10 questions, 20 secondes par question',
    },
    'normal': {
      'icon': Icons.sentiment_neutral_outlined,
      'color': Colors.amber,
      'questions': 20,
      'timer': 15,
      'description': '20 questions, 15 secondes par question',
    },
    'difficile': {
      'icon': Icons.sentiment_very_dissatisfied_outlined,
      'color': Colors.redAccent,
      'questions': 30,
      'timer': 10,
      'description': '30 questions, 10 secondes par question',
    },
  };

  void _selectLevel(String level) {
    setState(() {
      selectedLevel = level;
    });
  }

  void _startQuiz() {
    if (selectedLevel != null) {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => QuizScreen(
            playerName: widget.playerName,
            playerAge: widget.playerAge,
            level: selectedLevel!,
            questionCount: levels[selectedLevel]!['questions'],
            timerSeconds: levels[selectedLevel]!['timer'],
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = Offset(1.0, 0.0);
            var end = Offset.zero;
            var curve = Curves.easeInOutCubic;
            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
          transitionDuration: Duration(milliseconds: 500),
        ),
      );
    } else {
      _showSnackBar("Veuillez sélectionner un niveau de difficulté");
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.poppins(),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: EdgeInsets.all(20),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Obtenir la taille de l'écran
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Choisir un niveau',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        height: screenSize.height,
        width: screenSize.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF00796B), // Teal 700
              Color(0xFF004D40), // Teal 900
            ],
            stops: [0.0, 1.0],
          ),
        ),
        child: SafeArea(
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Cercles décoratifs
              Positioned(
                top: -80,
                right: -40,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
              ),
              Positioned(
                bottom: -60,
                left: -60,
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
              ),

              // Contenu principal
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Bienvenue au joueur
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            widget.playerName,
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 24),

                    // Titre de la page
                    Text(
                      'Choisissez votre niveau',
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    SizedBox(height: 8),

                    Text(
                      'La difficulté détermine le nombre de questions et le temps disponible',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.8),
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: 40),

                    // Cartes des niveaux
                    Expanded(
                      child: ListView(
                        children: levels.entries.map((entry) {
                          final levelKey = entry.key;
                          final level = entry.value;
                          final isSelected = selectedLevel == levelKey;

                          return GestureDetector(
                            onTap: () => _selectLevel(levelKey),
                            child: Container(
                              margin: EdgeInsets.only(bottom: 20),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? level['color'].withOpacity(0.3)
                                    : Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isSelected
                                      ? level['color']
                                      : Colors.transparent,
                                  width: 2,
                                ),
                                boxShadow: isSelected ? [
                                  BoxShadow(
                                    color: level['color'].withOpacity(0.3),
                                    blurRadius: 10,
                                    offset: Offset(0, 4),
                                  )
                                ] : null,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(18),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                  child: Padding(
                                    padding: EdgeInsets.all(20),
                                    child: Row(
                                      children: [
                                        // Icône du niveau
                                        Container(
                                          width: 60,
                                          height: 60,
                                          decoration: BoxDecoration(
                                            color: level['color'].withOpacity(0.2),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: Icon(
                                              level['icon'],
                                              color: level['color'],
                                              size: 30,
                                            ),
                                          ),
                                        ),

                                        SizedBox(width: 16),

                                        // Informations du niveau
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                levelKey.substring(0, 1).toUpperCase() + levelKey.substring(1),
                                                style: GoogleFonts.poppins(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              SizedBox(height: 5),
                                              Text(
                                                level['description'],
                                                style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  color: Colors.white.withOpacity(0.8),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        // Indicateur de sélection
                                        isSelected
                                            ? Icon(
                                          Icons.check_circle,
                                          color: level['color'],
                                          size: 28,
                                        )
                                            : Icon(
                                          Icons.circle_outlined,
                                          color: Colors.white.withOpacity(0.5),
                                          size: 28,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    SizedBox(height: 20),

                    // Bouton de démarrage
                    Container(
                      width: double.infinity,
                      height: 55,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        gradient: LinearGradient(
                          colors: selectedLevel != null
                              ? [Color(0xFFFF9800), Color(0xFFFF5722)]
                              : [Colors.grey.shade600, Colors.grey.shade700],
                        ),
                        boxShadow: selectedLevel != null
                            ? [BoxShadow(
                          color: Color(0xFFFF9800).withOpacity(0.4),
                          offset: Offset(0, 4),
                          blurRadius: 12,
                        )]
                            : null,
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(18),
                          onTap: _startQuiz,
                          child: Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Commencer le quiz',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(
                                  Icons.play_arrow,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}