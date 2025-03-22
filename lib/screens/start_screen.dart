import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz237/screens/LevelSelectionScreen.dart';
import 'dart:ui';

import 'audio_service.dart';

class StartScreen extends StatefulWidget {
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _nameController = TextEditingController();
  int _age = 18;

  // Animation controller pour les effets
  late AnimationController _animationController;
  late Animation<double> _questionMarkAnimation;

  // Utiliser le service audio global
  bool get _isPlaying => !AudioService().isMuted;

  @override
  void initState() {
    super.initState();
    // Démarrer la musique de fond via le service global
    AudioService().playBackgroundMusic();

    // Initialisation des animations
    _animationController = AnimationController(
      duration: Duration(seconds: 10),
      vsync: this,
    )..repeat(reverse: true);

    _questionMarkAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  void _toggleAudio() {
    setState(() {
      AudioService().toggleMute();
    });
  }

  void _startQuiz() {
    if (_nameController.text.isEmpty) {
      _showErrorSnackBar('Veuillez entrer votre nom');
      return;
    }

    if (_age <= 0 || _age > 100) {
      _showErrorSnackBar('Veuillez entrer un âge valide (1-100)');
      return;
    }

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => LevelSelectionScreen(
          playerName: _nameController.text,
          playerAge: _age,
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
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: EdgeInsets.all(20),
      ),
    );
  }

  void _incrementAge() {
    setState(() {
      if (_age < 100) _age++;
    });
  }

  void _decrementAge() {
    setState(() {
      if (_age > 1) _age--;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Obtenir la taille de l'écran
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      // Suppression de la couleur de fond du Scaffold pour éviter les conflits
      backgroundColor: Colors.transparent,
      // Utilisation d'un Container pour couvrir tout l'écran
      body: Container(
        // Forcer la hauteur pour couvrir tout l'écran
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
            // S'assurer que le gradient couvre toute la hauteur
            stops: [0.0, 1.0],
          ),
        ),
        child: SafeArea(
          // Utiliser un Container à l'intérieur du SafeArea pour maintenir la couleur de fond
          child: Container(
            color: Colors.transparent, // Transparent pour laisser voir le gradient
            child: Stack(
              // Utiliser fit: StackFit.expand pour que le Stack prenne toute la place disponible
              fit: StackFit.expand,
              children: [
                // Image réelle de Lion en arrière-plan
                Positioned.fill(
                  child: Opacity(
                    opacity: 0.10, // Opacité faible pour ne pas gêner le contenu
                    child: Center(
                      child: Image.asset(
                        'assets/lion.jpeg', // Assurez-vous que cette image existe dans votre projet
                        width: screenSize.width * 0.85,
                        height: screenSize.width * 0.85,
                        fit: BoxFit.contain,
                        //color: Color(0xFFFCD116), // Teinte jaune pour rappeler les couleurs du Cameroun
                        colorBlendMode: BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),

                // Points d'interrogation flottants
                // Point d'interrogation 1
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Positioned(
                      top: 50 + (20 * _questionMarkAnimation.value),
                      left: 40,
                      child: Opacity(
                        opacity: 0.7 - (0.3 * _questionMarkAnimation.value),
                        child: Transform.rotate(
                          angle: 0.1 * _questionMarkAnimation.value,
                          child: Text(
                            '?',
                            style: GoogleFonts.poppins(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.amber,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),

                // Point d'interrogation 2
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Positioned(
                      top: 150,
                      right: 30 + (15 * _questionMarkAnimation.value),
                      child: Opacity(
                        opacity: 0.6 - (0.2 * _questionMarkAnimation.value),
                        child: Transform.rotate(
                          angle: -0.15 * _questionMarkAnimation.value,
                          child: Text(
                            '?',
                            style: GoogleFonts.poppins(
                              fontSize: 60,
                              fontWeight: FontWeight.bold,
                              color: Colors.orangeAccent,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),

                // Point d'interrogation 3
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Positioned(
                      bottom: 100 - (25 * _questionMarkAnimation.value),
                      left: 30,
                      child: Opacity(
                        opacity: 0.5 + (0.2 * _questionMarkAnimation.value),
                        child: Transform.rotate(
                          angle: 0.2 * _questionMarkAnimation.value,
                          child: Text(
                            '?',
                            style: GoogleFonts.poppins(
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),

                // Point d'interrogation 4
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Positioned(
                      bottom: 50,
                      right: 50 - (20 * _questionMarkAnimation.value),
                      child: Opacity(
                        opacity: 0.8 - (0.3 * _questionMarkAnimation.value),
                        child: Transform.rotate(
                          angle: -0.1 * _questionMarkAnimation.value,
                          child: Text(
                            '?',
                            style: GoogleFonts.poppins(
                              fontSize: 45,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFCD116).withOpacity(0.8),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),

                // Cercles décoratifs
                Positioned(
                  top: -50,
                  left: -50,
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
                  bottom: -100,
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

                // Contenu principal avec OverflowBox pour s'assurer qu'il n'y a pas d'espace blanc
                OverflowBox(
                  maxHeight: double.infinity,
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    // Ajouter un padding en bas pour s'assurer que le contenu s'étend suffisamment
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(24, 24, 24, 100),
                      child: Column(
                        children: [
                          // Bouton audio modernisé
                          Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: IconButton(
                                icon: AnimatedSwitcher(
                                  duration: Duration(milliseconds: 300),
                                  child: Icon(
                                    _isPlaying ? Icons.volume_up : Icons.volume_off,
                                    key: ValueKey<bool>(_isPlaying),
                                    color: _isPlaying ? Colors.amber : Colors.white70,
                                    size: 30,
                                  ),
                                  transitionBuilder: (Widget child, Animation<double> animation) {
                                    return ScaleTransition(scale: animation, child: child);
                                  },
                                ),
                                onPressed: _toggleAudio,
                                tooltip: _isPlaying ? 'Couper le son' : 'Activer le son',
                              ),
                            ),
                          ),

                          SizedBox(height: 30),

                          // Drapeau du Cameroun sans modification
                          Container(
                            width: 180,
                            height: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  offset: Offset(0, 4),
                                  blurRadius: 15,
                                ),
                              ],
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Stack(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Container(color: Color(0xFF007A5E)), // Vert
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(color: Color(0xFFCE1126)), // Rouge
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(color: Color(0xFFFCD116)), // Jaune
                                    ),
                                  ],
                                ),
                                Center(
                                  child: Icon(
                                    Icons.star,
                                    color: Color(0xFFFCD116),
                                    size: 40,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 40),

                          // Titre avec style amélioré
                          ShaderMask(
                            shaderCallback: (bounds) {
                              return LinearGradient(
                                colors: [Colors.white, Color(0xFFFFC107)],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ).createShader(bounds);
                            },
                            child: Text(
                              'Bienvenue sur Quiz237 !',
                              style: GoogleFonts.poppins(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),

                          SizedBox(height: 10),
                          Text(
                            'Testez vos connaissances sur le Cameroun',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          SizedBox(height: 40),

                          // Carte pour le formulaire
                          Container(
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
                                child: Padding(
                                  padding: const EdgeInsets.all(24.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Champ de texte pour le nom modernisé
                                      Text(
                                        'Votre nom',
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white.withOpacity(0.9),
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(15),
                                          border: Border.all(
                                            color: Colors.white.withOpacity(0.3),
                                            width: 1.5,
                                          ),
                                        ),
                                        child: TextField(
                                          controller: _nameController,
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                          decoration: InputDecoration(
                                            hintText: 'Entrez votre nom',
                                            hintStyle: GoogleFonts.poppins(
                                              color: Colors.white60,
                                            ),
                                            contentPadding: EdgeInsets.symmetric(
                                              horizontal: 20,
                                              vertical: 16,
                                            ),
                                            border: InputBorder.none,
                                            prefixIcon: Icon(
                                              Icons.person_outline,
                                              color: Colors.white70,
                                            ),
                                          ),
                                        ),
                                      ),

                                      SizedBox(height: 24),

                                      // Sélecteur d'âge modernisé
                                      Text(
                                        'Votre âge',
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white.withOpacity(0.9),
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Material(
                                              color: Colors.transparent,
                                              child: InkWell(
                                                borderRadius: BorderRadius.circular(15),
                                                onTap: _decrementAge,
                                                child: Container(
                                                  padding: EdgeInsets.all(12),
                                                  child: Icon(
                                                    Icons.remove,
                                                    color: Colors.white,
                                                    size: 24,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            AnimatedSwitcher(
                                              duration: Duration(milliseconds: 200),
                                              transitionBuilder: (Widget child, Animation<double> animation) {
                                                return ScaleTransition(scale: animation, child: child);
                                              },
                                              child: Text(
                                                '$_age',
                                                key: ValueKey<int>(_age),
                                                style: GoogleFonts.poppins(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            Material(
                                              color: Colors.transparent,
                                              child: InkWell(
                                                borderRadius: BorderRadius.circular(15),
                                                onTap: _incrementAge,
                                                child: Container(
                                                  padding: EdgeInsets.all(12),
                                                  child: Icon(
                                                    Icons.add,
                                                    color: Colors.white,
                                                    size: 24,
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
                            ),
                          ),

                          SizedBox(height: 40),

                          // Bouton pour commencer le quiz modernisé
                          Container(
                            width: double.infinity,
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
                                  color: Color(0xFFFF9800).withOpacity(0.5),
                                  offset: Offset(0, 4),
                                  blurRadius: 15,
                                ),
                              ],
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
                                        'COMMENCER',
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Icon(
                                        Icons.arrow_forward_rounded,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // Espace supplémentaire en bas pour éviter que le contenu soit coupé
                          SizedBox(height: 60),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      // Supprimer le resizeToAvoidBottomInset pour éviter les espaces blancs quand le clavier apparaît
      resizeToAvoidBottomInset: false,
    );
  }
}