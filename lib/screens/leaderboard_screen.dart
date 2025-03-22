import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
import 'audio_service.dart';
import 'start_screen.dart';
import 'score_manager.dart';

class LeaderboardScreen extends StatefulWidget {
  final String playerName;
  final int score;
  final String level;

  LeaderboardScreen({
    required this.playerName,
    required this.score,
    required this.level,
  });

  @override
  _LeaderboardScreenState createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  // Onglet sélectionné
  late String currentLevel;

  // État de chargement
  bool _isLoading = false;

  // Utiliser le service audio global
  bool get _isPlaying => !AudioService().isMuted;

  @override
  void initState() {
    super.initState();
    currentLevel = widget.level; // Initialiser avec le niveau joué
    // Le score est déjà sauvegardé dans QuizScreen, pas besoin de le faire ici
  }

  void _toggleAudio() {
    setState(() {
      AudioService().toggleMute();
    });
  }

  void _changeLevel(String level) {
    setState(() {
      currentLevel = level;
    });
  }

  // Fonction pour ajouter des scores de test
  void _debugAddTestScores() async {
    setState(() {
      _isLoading = true;
    });

    await ScoreManager.addTestScores();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Obtenir la taille de l'écran
    final screenSize = MediaQuery.of(context).size;

    // Informations sur les niveaux
    final Map<String, Map<String, dynamic>> levels = {
      'facile': {
        'icon': Icons.sentiment_satisfied_outlined,
        'color': Colors.green,
      },
      'normal': {
        'icon': Icons.sentiment_neutral_outlined,
        'color': Colors.amber,
      },
      'difficile': {
        'icon': Icons.sentiment_very_dissatisfied_outlined,
        'color': Colors.redAccent,
      },
    };

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Classement',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: Icon(
                _isPlaying ? Icons.volume_up : Icons.volume_off,
                color: _isPlaying ? Colors.amber : Colors.white70,
              ),
              onPressed: _toggleAudio,
              tooltip: _isPlaying ? 'Couper le son' : 'Activer le son',
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _debugAddTestScores,
        backgroundColor: Colors.purple.withOpacity(0.7),
        mini: true,
        child: Icon(Icons.add_chart),
        tooltip: 'Ajouter des scores de test',
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
                top: -100,
                right: -70,
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
              ),
              Positioned(
                bottom: -80,
                left: -100,
                child: Container(
                  width: 250,
                  height: 250,
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
                  children: [
                    // Titre avec effet de dégradé
                    Text(
                      'Classement des joueurs',
                      style: GoogleFonts.poppins(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    // Message score actuel
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 16),
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: levels[widget.level]!['color'].withOpacity(0.5),
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            levels[widget.level]!['icon'],
                            color: levels[widget.level]!['color'],
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            '${widget.playerName}: ${widget.score} points',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Onglets de niveaux
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: EdgeInsets.all(4),
                      child: Row(
                        children: levels.entries.map((entry) {
                          final levelKey = entry.key;
                          final level = entry.value;
                          final isSelected = currentLevel == levelKey;

                          return Expanded(
                            child: GestureDetector(
                              onTap: () => _changeLevel(levelKey),
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? level['color'].withOpacity(0.3)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        level['icon'],
                                        color: isSelected
                                            ? level['color']
                                            : Colors.white.withOpacity(0.6),
                                        size: 18,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        levelKey.substring(0, 1).toUpperCase() + levelKey.substring(1),
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                          color: isSelected
                                              ? Colors.white
                                              : Colors.white.withOpacity(0.6),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    SizedBox(height: 16),

                    // Liste des scores avec indicateur de chargement
                    Expanded(
                      child: _isLoading
                          ? Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                          : FutureBuilder<List<Map<String, dynamic>>>(
                        future: ScoreManager.getScoresByLevel(currentLevel),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            );
                          } else if (snapshot.hasError) {
                            print("Erreur FutureBuilder: ${snapshot.error}");
                            return Center(
                              child: Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.error_outline,
                                      color: Colors.red[300],
                                      size: 48,
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      'Erreur de chargement des scores',
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      '${snapshot.error}',
                                      style: GoogleFonts.poppins(
                                        color: Colors.white70,
                                        fontSize: 12,
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    ElevatedButton(
                                      onPressed: () {
                                        setState(() {}); // Refresh
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white.withOpacity(0.3),
                                      ),
                                      child: Text('Réessayer'),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return Center(
                              child: Container(
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 10,
                                      offset: Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.emoji_events_outlined,
                                      size: 48,
                                      color: Colors.amber,
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      'Aucun score disponible\npour ce niveau',
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 16),
                                    TextButton.icon(
                                      onPressed: () async {
                                        // Ajouter un score pour le niveau courant
                                        await ScoreManager.addScore(
                                            "Joueur_${DateTime.now().second}",
                                            30 + DateTime.now().second,
                                            currentLevel
                                        );
                                        setState(() {}); // Refresh
                                      },
                                      icon: Icon(Icons.add, color: Colors.amber),
                                      label: Text(
                                        "Ajouter un score de test",
                                        style: GoogleFonts.poppins(
                                          color: Colors.amber,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            final scores = snapshot.data!;
                            scores.sort((a, b) => b['score'].compareTo(a['score']));

                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                  child: ListView.builder(
                                    padding: EdgeInsets.all(16),
                                    itemCount: scores.length,
                                    itemBuilder: (context, index) {
                                      final entry = scores[index];
                                      // Vérification améliorée pour le joueur actuel
                                      final isCurrentPlayer = entry['name'] == widget.playerName &&
                                          entry['score'] == widget.score &&
                                          // Vérifie le timestamp si disponible
                                          (entry['timestamp'] == null ||
                                              DateTime.now().millisecondsSinceEpoch - entry['timestamp'] < 60000);

                                      return Container(
                                        margin: EdgeInsets.only(bottom: 8),
                                        decoration: BoxDecoration(
                                          color: isCurrentPlayer
                                              ? levels[currentLevel]!['color'].withOpacity(0.2)
                                              : Colors.white.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(15),
                                          border: isCurrentPlayer
                                              ? Border.all(color: levels[currentLevel]!['color'].withOpacity(0.5), width: 1.5)
                                              : null,
                                        ),
                                        child: ListTile(
                                          leading: Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: index < 3
                                                  ? [Colors.amber, Colors.grey.shade300, Colors.brown.shade300][index].withOpacity(0.8)
                                                  : Colors.white.withOpacity(0.2),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Center(
                                              child: Text(
                                                '${index + 1}',
                                                style: GoogleFonts.poppins(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                          title: Text(
                                            entry['name'].toString(),
                                            style: GoogleFonts.poppins(
                                              fontSize: 16,
                                              fontWeight: isCurrentPlayer ? FontWeight.bold : FontWeight.normal,
                                              color: Colors.white,
                                            ),
                                          ),
                                          trailing: Container(
                                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                            decoration: BoxDecoration(
                                              color: Colors.white.withOpacity(0.2),
                                              borderRadius: BorderRadius.circular(15),
                                            ),
                                            child: Text(
                                              '${entry['score']} pts',
                                              style: GoogleFonts.poppins(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: isCurrentPlayer ? levels[currentLevel]!['color'] : Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),

                    SizedBox(height: 20),

                    // Boutons d'action
                    Row(
                      children: [
                        // Bouton Rejouer
                        Expanded(
                          child: Container(
                            height: 55,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFFFF9800), // Orange
                                  Color(0xFFFF5722), // Deep Orange
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFFFF9800).withOpacity(0.4),
                                  offset: Offset(0, 4),
                                  blurRadius: 12,
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(18),
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => StartScreen(),
                                    ),
                                  );
                                },
                                child: Center(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.replay,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'Rejouer',
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(width: 16),

                        // Bouton Effacer
                        Expanded(
                          child: Container(
                            height: 55,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              color: Colors.white.withOpacity(0.15),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 1.5,
                              ),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(18),
                                onTap: () async {
                                  // Afficher un dialogue de confirmation
                                  bool confirm = await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        backgroundColor: Color(0xFF00796B),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        title: Text(
                                          'Confirmation',
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        content: Text(
                                          'Voulez-vous effacer tous les scores de ce niveau ?',
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            child: Text(
                                              'Annuler',
                                              style: GoogleFonts.poppins(
                                                color: Colors.white70,
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop(false);
                                            },
                                          ),
                                          TextButton(
                                            child: Text(
                                              'Confirmer',
                                              style: GoogleFonts.poppins(
                                                color: Colors.redAccent,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop(true);
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  ) ?? false;

                                  // Si confirmé, effacer les scores du niveau actuel
                                  if (confirm) {
                                    setState(() {
                                      _isLoading = true;
                                    });

                                    await ScoreManager.clearScoresByLevel(currentLevel);

                                    setState(() {
                                      _isLoading = false;
                                    });
                                  }
                                },
                                child: Center(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.delete_outline,
                                        color: Colors.white70,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'Effacer',
                                        style: GoogleFonts.poppins(
                                          color: Colors.white70,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}