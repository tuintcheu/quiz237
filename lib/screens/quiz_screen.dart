import 'dart:ui';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'audio_service.dart';
import 'leaderboard_screen.dart';
import 'score_manager.dart';

class QuizScreen extends StatefulWidget {
  final String playerName;
  final int playerAge;
  final String level;
  final int questionCount;
  final int timerSeconds;

  QuizScreen({
    required this.playerName,
    required this.playerAge,
    required this.level,
    required this.questionCount,
    required this.timerSeconds,
  });

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<Map<String, dynamic>> allQuestions = [];
  int score = 0;
  int currentQuestionIndex = 0;
  List<Map<String, dynamic>> selectedQuestions = [];
  int? selectedAnswer;
  bool isAnswered = false;

  // Variables pour le timer
  Timer? _timer;
  int _timeLeft = 10;

  // Contrôle si le son de tick est en cours de lecture
  bool _isTickPlaying = false;

  // Utiliser le service audio global
  bool get _isPlaying => !AudioService().isMuted;

  @override
  void initState() {
    super.initState();
    _initializeQuiz();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _initializeQuiz() {
    // Toutes vos questions existantes restent inchangées
    allQuestions =[
      {
        "question": "Quelle est la capitale du Cameroun ?",
        "options": ["Douala", "Yaoundé", "Bafoussam", "Garoua"],
        "correctAnswer": 1
      },
      {
        "question": "Quelle est la langue officielle du Cameroun ?",
        "options": ["Français", "Anglais", "Les deux", "Espagnol"],
        "correctAnswer": 2
      },
      {
        "question": "En quelle année le Cameroun a-t-il obtenu son indépendance ?",
        "options": ["1960", "1958", "1961", "1965"],
        "correctAnswer": 0
      },
      {
        "question": "Quel est le plus grand fleuve du Cameroun ?",
        "options": ["Sanaga", "Logone", "Bénoué", "Nyong"],
        "correctAnswer": 0
      },
      {
        "question": "Combien de régions compte le Cameroun ?",
        "options": ["8", "10", "12", "14"],
        "correctAnswer": 1
      },
      {
        "question": "Quelle ville est considérée comme le centre économique du Cameroun ?",
        "options": ["Douala", "Yaoundé", "Kribi", "Bamenda"],
        "correctAnswer": 0
      },
      {
        "question": "Quel est l'emblème animalier du Cameroun ?",
        "options": ["Lion", "Éléphant", "Panthère", "Girafe"],
        "correctAnswer": 0
      },
      {
        "question": "Quel est l’un des plats traditionnels les plus célèbres au Cameroun ?",
        "options": ["Ndolé", "Fufu", "Tchep", "Poulet Yassa"],
        "correctAnswer": 0
      },
      {
        "question": "Quelle région est connue pour ses paysages montagneux et le Mont Cameroun ?",
        "options": ["Nord", "Sud-Ouest", "Adamaoua", "Est"],
        "correctAnswer": 1
      },
      {
        "question": "Quel est le nom du lac volcanique situé près de Foumbot ?",
        "options": ["Lac Nyos", "Lac Barombi", "Lac Tchad", "Lac Baleng"],
        "correctAnswer": 3
      },
      {
        "question": "Quelle est la monnaie utilisée au Cameroun ?",
        "options": ["Franc CFA", "Dollar", "Euro", "Livre Sterling"],
        "correctAnswer": 0
      },
      {
        "question": "Quel est le surnom du Cameroun en raison de sa diversité culturelle et géographique ?",
        "options": ["Afrique en miniature", "Le pays des lions", "Le grenier de l'Afrique", "Le cœur de l'Afrique"],
        "correctAnswer": 0
      },
      {
        "question": "Quel est le sport le plus populaire au Cameroun ?",
        "options": ["Basketball", "Football", "Athlétisme", "Tennis"],
        "correctAnswer": 1
      },
      {
        "question": "Quel est le nom de l’équipe nationale de football du Cameroun ?",
        "options": ["Les Lions Indomptables", "Les Éléphants", "Les Panthères", "Les Aigles"],
        "correctAnswer": 0
      },
      {
        "question": "Quelle région est connue pour ses savanes et ses parcs nationaux comme Waza ?",
        "options": ["Extrême-Nord", "Centre", "Ouest", "Sud"],
        "correctAnswer": 0
      },
      {
        "question": "Quel est le principal port du Cameroun ?",
        "options": ["Kribi", "Douala", "Limbe", "Garoua"],
        "correctAnswer": 1
      },
      {
        "question": "Qui était le premier président du Cameroun ?",
        "options": ["Ahmadou Ahidjo", "Paul Biya", "Ruben Um Nyobé", "André-Marie Mbida"],
        "correctAnswer": 0
      },
      {
        "question": "Quel est le nom de la chaîne de montagnes située dans l’Ouest du Cameroun ?",
        "options": ["Mont Cameroun", "Mont Mandara", "Chaine des Bamboutos", "Mont Oku"],
        "correctAnswer": 2
      },
      {
        "question": "Quelle est la danse traditionnelle populaire dans la région de l'Ouest ?",
        "options": ["Bikutsi", "Makossa", "Assiko", "Benskin"],
        "correctAnswer": 3
      },
      {
        "question": "Quelle région est célèbre pour ses plages comme Kribi et Limbé ?",
        "options": ["Centre", "Sud", "Littoral", "Sud-Ouest"],
        "correctAnswer": 2
      },
      {
        "question": "Quelle est la principale ressource naturelle exportée par le Cameroun ?",
        "options": ["Or", "Pétrole", "Diamants", "Cacao"],
        "correctAnswer": 1
      },
      {
        "question": "Quel est le nom du parc national célèbre pour ses éléphants dans le Nord du Cameroun ?",
        "options": ["Parc de Waza", "Parc de Bouba Ndjida", "Parc de Campo Ma’an", "Parc de Korup"],
        "correctAnswer": 0
      },
      {
        "question": "Quel est le nom du plat camerounais à base de feuilles d’arachide ?",
        "options": ["Ekwang", "Koki", "Mbongo Tchobi", "Sanga"],
        "correctAnswer": 3
      },
      {
        "question": "Quelle est la principale religion pratiquée au Cameroun ?",
        "options": ["Christianisme", "Islam", "Animisme", "Hindouisme"],
        "correctAnswer": 0
      },
      {
        "question": "Quel événement tragique s’est produit au Lac Nyos en 1986 ?",
        "options": ["Éruption volcanique", "Déversement de gaz toxique", "Sécheresse", "Tsunami"],
        "correctAnswer": 1
      },
      {
        "question": "Quel est le nom de l’instrument traditionnel utilisé dans la musique camerounaise ?",
        "options": ["Balafon", "Djembe", "Kora", "Ngoma"],
        "correctAnswer": 0
      },
      {
        "question": "Le Cameroun est bordé par combien de pays ?",
        "options": ["5", "6", "7", "8"],
        "correctAnswer": 2
      },
      {
        "question": "Quelle région est connue pour ses chefferies traditionnelles ?",
        "options": ["Nord", "Ouest", "Sud", "Est"],
        "correctAnswer": 1
      },
      {
        "question": "Quelle est la ville hôte du Festival Ngondo ?",
        "options": ["Douala", "Yaoundé", "Kribi", "Bafoussam"],
        "correctAnswer": 0
      },
      {
        "question": "Quel écrivain camerounais a écrit « Une vie de boy » ?",
        "options": ["Mongo Beti", "Ferdinand Oyono", "Calixthe Beyala", "Jean Ikelle Matiba"],
        "correctAnswer": 1
      },
      {
        "question": "Quel est le nom de la forêt tropicale protégée située dans le Sud du Cameroun ?",
        "options": ["Réserve de Dja", "Parc de Korup", "Parc de Campo Ma’an", "Forêt de Lobéké"],
        "correctAnswer": 0
      },
      {
        "question": "Quelle est la date officielle de la fête nationale du Cameroun ?",
        "options": ["20 mai", "1er janvier", "11 février", "5 octobre"],
        "correctAnswer": 0
      },
      {
        "question": "Quel célèbre roi a résisté à la colonisation allemande dans la région de l'Ouest ?",
        "options": ["Roi Njoya", "Roi Manga Bell", "Roi Sokoudjou", "Roi Mbouombouo"],
        "correctAnswer": 0
      },
      {
        "question": "Quelle fête traditionnelle célèbre les peuples Sawa à Douala ?",
        "options": ["Ngondo", "Fête des récoltes", "Njang", "Mbaya"],
        "correctAnswer": 0
      },
      {
        "question": "Quelle région du Cameroun est réputée pour la cérémonie du « Ngoun » ?",
        "options": ["Nord-Ouest", "Ouest", "Sud", "Extrême-Nord"],
        "correctAnswer": 1
      },
      {
        "question": "Quel héros national a été exécuté en 1958 pour avoir lutté contre la colonisation française ?",
        "options": ["Ruben Um Nyobé", "Félix Moumié", "André-Marie Mbida", "Ernest Ouandié"],
        "correctAnswer": 0
      },
      {
        "question": "Quelle est la plus ancienne université publique du Cameroun ?",
        "options": ["Université de Douala", "Université de Yaoundé I", "Université de Buea", "Université de Dschang"],
        "correctAnswer": 1
      },
      {
        "question": "Quelle région est connue pour ses danses traditionnelles comme le « Njang » ?",
        "options": ["Nord-Ouest", "Centre", "Sud", "Adamaoua"],
        "correctAnswer": 0
      },
      {
        "question": "Quelle colonie a administré le Cameroun après la Première Guerre mondiale ?",
        "options": ["France", "Belgique", "Royaume-Uni", "Portugal"],
        "correctAnswer": 0
      },
      {
        "question": "Quelle cérémonie célèbre la fin de l'initiation des jeunes chez les Bamilékés ?",
        "options": ["Lom", "Ngoun", "Nkoung", "Kougang"],
        "correctAnswer": 2
      },
      {
        "question": "Quel est le nom de l'œuvre d'art traditionnelle sculptée par les Grassfields ?",
        "options": ["Masques", "Totems", "Trônes", "Statues"],
        "correctAnswer": 3
      },
      {
        "question": "Quel pays est séparé du Cameroun par le fleuve Logone ?",
        "options": ["Nigeria", "Tchad", "RCA", "Gabon"],
        "correctAnswer": 1
      },
      {
        "question": "Quelle région est célèbre pour la fabrication de poteries à Foumban ?",
        "options": ["Ouest", "Nord", "Centre", "Sud-Ouest"],
        "correctAnswer": 0
      },
      {
        "question": "Quel est le nom de la communauté qui célèbre la fête des récoltes dans le Nord-Ouest ?",
        "options": ["Bamenda", "Nso", "Bafut", "Kom"],
        "correctAnswer": 1
      },
      {
        "question": "Quel est le nom du célèbre porteur de lance dans l’histoire du Cameroun ?",
        "options": ["Martin Paul Samba", "Ruben Um Nyobé", "Douala Manga Bell", "Félix Moumié"],
        "correctAnswer": 0
      },
      {
        "question": "Quelle danse typique est pratiquée par les communautés Fang-Beti ?",
        "options": ["Bikutsi", "Makossa", "Assiko", "Ndombolo"],
        "correctAnswer": 0
      },
      {
        "question": "Quel est le principal produit agricole exporté par le Cameroun ?",
        "options": ["Cacao", "Café", "Coton", "Banane"],
        "correctAnswer": 0
      },
      {
        "question": "Quel est le rôle principal des chefferies traditionnelles au Cameroun ?",
        "options": ["Administration locale", "Préservation de la culture", "Rituel religieux", "Commerce"],
        "correctAnswer": 1
      },
      {
        "question": "Quelle région est connue pour le festival de la course des chevaux « Fantasia » ?",
        "options": ["Adamaoua", "Ouest", "Nord", "Littoral"],
        "correctAnswer": 2
      },
      {
        "question": "Quelle ville abrite le Mont Fébé, une attraction touristique populaire ?",
        "options": ["Douala", "Yaoundé", "Kribi", "Bamenda"],
        "correctAnswer": 1
      },
      {
        "question": "Quel est l’arbre emblématique souvent utilisé dans les cérémonies traditionnelles ?",
        "options": ["Baobab", "Palmier", "Fromager", "Eucalyptus"],
        "correctAnswer": 2
      },
      {
        "question": "Quel est le nom de la cérémonie funéraire pratiquée par les Bamilékés ?",
        "options": ["Kougang", "Lom", "Kou’gang", "Ngoun"],
        "correctAnswer": 1
      },
      {
        "question": "Quel événement marquant a eu lieu au Cameroun le 11 février 1961 ?",
        "options": ["Réunification", "Indépendance", "Fête de la Jeunesse", "Création de l'armée"],
        "correctAnswer": 2
      },
      {
        "question": "Quelle région est connue pour ses plaines et sa faune abondante ?",
        "options": ["Adamaoua", "Nord", "Extrême-Nord", "Sud"],
        "correctAnswer": 1
      },
      {
        "question": "Quelle est la signification du festival Ngondo chez les Sawa ?",
        "options": ["Hommage aux ancêtres", "Célébration des récoltes", "Fête de la mer", "Rite initiatique"],
        "correctAnswer": 0
      },
      {
        "question": "Quel est le nom du célèbre marché artisanal de Yaoundé ?",
        "options": ["Marché Mokolo", "Marché Central", "Marché de Nlongkak", "Marché de la Briqueterie"],
        "correctAnswer": 0
      },
      {
        "question": "Quelle est la plus grande ville du Cameroun par sa population ?",
        "options": ["Yaoundé", "Douala", "Garoua", "Bamenda"],
        "correctAnswer": 1
      },
      {
        "question": "Quel est le nom de la fête nationale célébrée le 20 mai ?",
        "options": ["Fête de la Réunification", "Fête de l'Unité", "Fête de l'Indépendance", "Fête de l'Armée"],
        "correctAnswer": 1
      },
      {
        "question": "Quelle région est connue pour ses danses guerrières ?",
        "options": ["Nord", "Ouest", "Sud-Ouest", "Littoral"],
        "correctAnswer": 0
      },
      {
        "question": "Quel est le type de masque traditionnel utilisé dans les cérémonies Bamiléké ?",
        "options": ["Masque éléphant", "Masque lion", "Masque crocodile", "Masque léopard"],
        "correctAnswer": 0
      },
      {
        "question": "Quel est le nom de la région où se trouve le parc national de Korup ?",
        "options": ["Centre", "Sud-Ouest", "Ouest", "Est"],
        "correctAnswer": 1
      },
      {
        "question": "Quel est l’un des principaux symboles de la royauté chez les Bamoun ?",
        "options": ["Le trône", "Le sabre", "Le sceptre", "Le collier"],
        "correctAnswer": 2
      },
      {
        "question": "Quelle danse traditionnelle célèbre les rituels funéraires chez les Beti ?",
        "options": ["Ekang", "Bikutsi", "Ewondo", "Mpango"],
        "correctAnswer": 0
      },
      {
        "question": "Quelle ville est surnommée « la ville aux sept collines » au Cameroun ?",
        "options": ["Bamenda", "Yaoundé", "Kribi", "Douala"],
        "correctAnswer": 1
      },
      {
        "question": "Quelle région est célèbre pour ses sculptures et ses masques en bois ?",
        "options": ["Ouest", "Sud", "Nord-Ouest", "Littoral"],
        "correctAnswer": 0
      },
      {
        "question": "Quel est le nom du célèbre musée situé à Foumban ?",
        "options": ["Musée des Civilisations", "Musée des Chefferies", "Musée Bamoun", "Musée des Arts Africains"],
        "correctAnswer": 2
      },
      {
        "question": "Quel est le nom de la cérémonie de couronnement chez les Bamoun ?",
        "options": ["Nja", "Ngoun", "Toko", "Fon"],
        "correctAnswer": 1
      },

      {
        "question": "Quelle est la devise nationale du Cameroun ?",
        "options": ["Paix – Travail – Patrie", "Unité – Progrès – Liberté", "Force – Honneur – Solidarité", "Justice – Liberté – Progrès"],
        "correctAnswer": 0
      },
      {
        "question": "Quelle est la superficie du Cameroun ?",
        "options": ["475 442 km²", "500 000 km²", "450 000 km²", "465 000 km²"],
        "correctAnswer": 0
      },
      {
        "question": "Quel fleuve marque la frontière entre le Cameroun et le Nigeria ?",
        "options": ["Logone", "Sanaga", "Cross River", "Benoué"],
        "correctAnswer": 2
      },
      {
        "question": "Quel est le principal dialecte parlé dans la région du Nord-Ouest ?",
        "options": ["Pidgin", "Nso", "Bafut", "Ngemba"],
        "correctAnswer": 0
      },
      {
        "question": "Quel est le principal port en eaux profondes du Cameroun ?",
        "options": ["Kribi", "Douala", "Limbé", "Garoua"],
        "correctAnswer": 0
      },
      {
        "question": "Quelle chaîne de montagnes se trouve dans l’Extrême-Nord du Cameroun ?",
        "options": ["Mont Mandara", "Mont Bamboutos", "Mont Cameroun", "Mont Oku"],
        "correctAnswer": 0
      },
      {
        "question": "Quel est le nom du célèbre marché artisanal de Foumban ?",
        "options": ["Marché des Arts", "Marché Royal", "Marché des Sculptures", "Marché des Tissus"],
        "correctAnswer": 0
      },
      {
        "question": "Quelle est l’altitude du Mont Cameroun, le point culminant du pays ?",
        "options": ["4 095 m", "4 070 m", "4 040 m", "4 100 m"],
        "correctAnswer": 0
      },
      {
        "question": "Quel est le nom de la réserve qui protège les gorilles au Cameroun ?",
        "options": ["Réserve de Dja", "Réserve de Campo Ma’an", "Réserve de Boumba Bek", "Réserve de Lobéké"],
        "correctAnswer": 3
      },
      {
        "question": "Quel est le nom de l’aéroport principal de Douala ?",
        "options": ["Aéroport International de Douala", "Aéroport de Bonanjo", "Aéroport de Kribi", "Aéroport de Limbé"],
        "correctAnswer": 0
      },
      {
        "question": "Dans quelle région se trouve la ville de Maroua ?",
        "options": ["Extrême-Nord", "Nord", "Adamaoua", "Centre"],
        "correctAnswer": 0
      },
      {
        "question": "Quel est le nom du grand pont reliant Douala à la région du Littoral ?",
        "options": ["Pont Bonabéri", "Pont Wouri", "Pont Dibamba", "Pont Kribi"],
        "correctAnswer": 1
      },
      {
        "question": "Quelle est la population approximative du Cameroun en 2023 ?",
        "options": ["25 millions", "27 millions", "30 millions", "32 millions"],
        "correctAnswer": 1
      },
      {
        "question": "Quel est le nom de l’aéroport international de Yaoundé ?",
        "options": ["Nsimalen", "Bonabéri", "Efoulan", "Siméon"],
        "correctAnswer": 0
      },
      {
        "question": "Quelle est la deuxième langue la plus parlée au Cameroun après le français et l’anglais ?",
        "options": ["Fulfulde", "Pidgin", "Douala", "Ewondo"],
        "correctAnswer": 1
      },
      {
        "question": "Quel est le nom du roi célèbre pour avoir inventé l’écriture Bamoun ?",
        "options": ["Roi Njoya", "Roi Manga Bell", "Roi Bafut", "Roi Ndoumbe"],
        "correctAnswer": 0
      },
      {
        "question": "Quel est le nom du stade principal de Yaoundé ?",
        "options": ["Stade Ahmadou Ahidjo", "Stade Paul Biya", "Stade Nlongkak", "Stade de Mfandena"],
        "correctAnswer": 0
      },
      {
        "question": "Quel est le nom de la réserve qui abrite des éléphants dans le Nord-Cameroun ?",
        "options": ["Parc de Waza", "Réserve de Bouba Ndjida", "Réserve de Faro", "Réserve de Lobéké"],
        "correctAnswer": 1
      },
      {
        "question": "Quel est le principal fleuve qui traverse la ville de Garoua ?",
        "options": ["Sanaga", "Benoué", "Logone", "Chari"],
        "correctAnswer": 1
      },
      {
        "question": "Quelle région est connue pour ses forêts tropicales denses ?",
        "options": ["Sud", "Est", "Sud-Ouest", "Littoral"],
        "correctAnswer": 1
      },
      {
        "question": "Quelle ville du Cameroun est célèbre pour ses plantations de thé ?",
        "options": ["Buea", "Nkongsamba", "Dschang", "Kribi"],
        "correctAnswer": 0
      },
      {
        "question": "Quel est le nom du grand barrage hydroélectrique situé sur la Sanaga ?",
        "options": ["Barrage d’Edea", "Barrage de Nachtigal", "Barrage de Lom Pangar", "Barrage de Songloulou"],
        "correctAnswer": 3
      },
      {
        "question": "Quelle région est célèbre pour ses plantations de bananes ?",
        "options": ["Littoral", "Sud", "Sud-Ouest", "Est"],
        "correctAnswer": 2
      },
      {
        "question": "Quel est le nom du célèbre chanteur camerounais surnommé « le Roi du Makossa » ?",
        "options": ["Petit Pays", "Ben Decca", "Eboa Lotin", "Manu Dibango"],
        "correctAnswer": 1
      },
      {
        "question": "Quelle est la principale exportation agricole du Cameroun ?",
        "options": ["Cacao", "Café", "Coton", "Huile de palme"],
        "correctAnswer": 0
      },
      {
        "question": "Dans quelle région se trouve la ville de Bertoua ?",
        "options": ["Est", "Centre", "Littoral", "Nord"],
        "correctAnswer": 0
      },
      {
        "question": "Quel est le nom du lac connu pour sa couleur verte dans le Sud-Ouest ?",
        "options": ["Lac Barombi", "Lac Nyos", "Lac Tissongo", "Lac Oku"],
        "correctAnswer": 0
      },
      {
        "question": "Quelle est la région d’origine du peuple Bassa ?",
        "options": ["Littoral", "Centre", "Sud", "Est"],
        "correctAnswer": 0
      },
      {
        "question": "Quel est le nom du célèbre chanteur de jazz camerounais, auteur de « Soul Makossa » ?",
        "options": ["Manu Dibango", "Richard Bona", "Francis Bebey", "Sam Fan Thomas"],
        "correctAnswer": 0
      },
      {
        "question": "Quelle est la capitale de la région de l’Adamaoua ?",
        "options": ["Ngaoundéré", "Garoua", "Maroua", "Banyo"],
        "correctAnswer": 0
      },
      {
        "question": "Quelle est la principale activité économique de l’Est du Cameroun ?",
        "options": ["Exploitation forestière", "Pêche", "Industrie textile", "Extraction minière"],
        "correctAnswer": 0
      },
      {
        "question": "Quel est le nom du célèbre marché de Douala ?",
        "options": ["Marché Sandaga", "Marché Mokolo", "Marché Bonamoussadi", "Marché Congo"],
        "correctAnswer": 3
      },
      {
        "question": "Quelle est la principale forêt protégée située dans le Littoral ?",
        "options": ["Forêt d’Ebo", "Réserve de Campo Ma’an", "Réserve de Dja", "Forêt de Lobéké"],
        "correctAnswer": 0
      }
    ];

    setState(() {
      allQuestions.shuffle();
      // Sélectionner le nombre de questions en fonction du niveau
      selectedQuestions = allQuestions.take(widget.questionCount).toList();
      currentQuestionIndex = 0;
      score = 0;
      selectedAnswer = null;
      isAnswered = false;
    });

    // Initialiser le timer avec la durée correspondant au niveau
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _isTickPlaying = false;

    setState(() {
      _timeLeft = widget.timerSeconds;
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;

          // Jouer le son de tick pour les 5 dernières secondes
          if (_timeLeft <= 5 && !_isTickPlaying && !isAnswered) {
            _playTickSound();
          }
        } else {
          _timer?.cancel();
          _timeExpired();
        }
      });
    });
  }

  void _playTickSound() {
    if (_timeLeft <= 5 && !isAnswered) {
      _isTickPlaying = true;
      AudioService().playSound(AudioService().tickSound);
    }
  }

  void _timeExpired() {
    if (!isAnswered) {
      AudioService().playSound(AudioService().timeUpSound);

      setState(() {
        isAnswered = true;
      });

      _showSnackBar("Temps écoulé !");

      Future.delayed(Duration(seconds: 2), () {
        _nextQuestion();
      });
    }
  }

  void _nextQuestion() {
    AudioService().stopAllSounds();
    AudioService().playSound(AudioService().nextSound);

    if (currentQuestionIndex < selectedQuestions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedAnswer = null;
        isAnswered = false;
      });

      _startTimer();
    } else {
      _endQuiz();
    }
  }

  void _checkAnswer(int answer) {
    _timer?.cancel();

    final isCorrect = answer == selectedQuestions[currentQuestionIndex]['correctAnswer'];

    if (isCorrect) {
      AudioService().playSound(AudioService().correctSound);
    } else {
      AudioService().playSound(AudioService().incorrectSound);
    }

    setState(() {
      selectedAnswer = answer;
      isAnswered = true;
      if (isCorrect) {
        score += 5;
      }
    });
  }

  void _endQuiz() {
    _timer?.cancel();

    // Passage correct du niveau avec vérification de doublons
    ScoreManager.addScoreNoDuplicates(widget.playerName, score, widget.level).then((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LeaderboardScreen(
            playerName: widget.playerName,
            score: score,
            level: widget.level,
          ),
        ),
      );
    }).catchError((error) {
      print("Erreur lors de l'enregistrement du score: $error");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LeaderboardScreen(
            playerName: widget.playerName,
            score: score,
            level: widget.level,
          ),
        ),
      );
    });
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

  void _toggleBackgroundMusic() {
    setState(() {
      AudioService().toggleMute();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Obtenir la taille de l'écran
    final screenSize = MediaQuery.of(context).size;

    if (selectedQuestions.isEmpty) {
      return Center(
        child: Text(
          "Aucune question disponible. Veuillez réessayer.",
          style: GoogleFonts.poppins(fontSize: 18, color: Colors.white),
        ),
      );
    }

    final question = selectedQuestions[currentQuestionIndex];
    final isLastQuestion = currentQuestionIndex == selectedQuestions.length - 1;

    // Correction du calcul de progression pour qu'il soit basé sur le temps du niveau
    final progressValue = _timeLeft / widget.timerSeconds;

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Quiz237',
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
              onPressed: _toggleBackgroundMusic,
              tooltip: _isPlaying ? 'Couper le son' : 'Activer le son',
            ),
          ),
        ],
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
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Informations du joueur
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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

                    SizedBox(height: 16),

                    // Progression et timer
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Timer
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: _timeLeft <= 3
                                ? Colors.red.withOpacity(0.3)
                                : Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.timer,
                                color: _timeLeft <= 3 ? Colors.red : Colors.white,
                                size: 20,
                              ),
                              SizedBox(width: 5),
                              Text(
                                '$_timeLeft s',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: _timeLeft <= 3 ? Colors.red : Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Progression
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            '${currentQuestionIndex + 1}/${selectedQuestions.length}',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 10),

                    // Barre de progression
                    Container(
                      height: 8,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: LayoutBuilder(
                          builder: (context, constraints) {
                            // Utiliser LayoutBuilder pour obtenir la largeur disponible
                            return Row(
                              children: [
                                Container(
                                  height: 8,
                                  // Calcul correct de la largeur basé sur le temps du niveau
                                  width: constraints.maxWidth * progressValue,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: _timeLeft <= 3
                                          ? [Colors.red.shade300, Colors.red]
                                          : [Colors.orange.shade300, Colors.orange],
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ],
                            );
                          }
                      ),
                    ),

                    SizedBox(height: 20),

                    // Carte de question
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20),
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
                          child: Column(
                            children: [
                              Text(
                                'Question ${currentQuestionIndex + 1}',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white70,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                question['question'],
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    // Options de réponse
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        children: List.generate(question['options'].length, (index) {
                          final option = question['options'][index];
                          final isCorrect = index == question['correctAnswer'];
                          final isSelected = selectedAnswer == index;

                          Color backgroundColor;
                          Color borderColor;
                          Color textColor;

                          if (isAnswered) {
                            if (isSelected) {
                              backgroundColor = isCorrect
                                  ? Colors.green.withOpacity(0.3)
                                  : Colors.red.withOpacity(0.3);
                              borderColor = isCorrect
                                  ? Colors.green.withOpacity(0.8)
                                  : Colors.red.withOpacity(0.8);
                              textColor = Colors.white;
                            } else if (isCorrect) {
                              backgroundColor = Colors.green.withOpacity(0.3);
                              borderColor = Colors.green.withOpacity(0.8);
                              textColor = Colors.white;
                            } else {
                              backgroundColor = Colors.white.withOpacity(0.1);
                              borderColor = Colors.transparent;
                              textColor = Colors.white70;
                            }
                          } else {
                            backgroundColor = Colors.white.withOpacity(0.1);
                            borderColor = Colors.transparent;
                            textColor = Colors.white;
                          }

                          return Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                if (!isAnswered) {
                                  _checkAnswer(index);
                                }
                              },
                              borderRadius: BorderRadius.circular(15),
                              splashColor: Colors.white.withOpacity(0.1),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: backgroundColor,
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: borderColor,
                                    width: 2,
                                  ),
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(
                                      option,
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: textColor,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),

                    SizedBox(height: 20),

                    // Affichage du score et bouton suivant
                    Row(
                      children: [
                        // Score
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 24,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  '$score',
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(width: 16),

                        // Bouton Suivant/Terminer
                        Expanded(
                          flex: 2,
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              gradient: LinearGradient(
                                colors: isAnswered
                                    ? [Color(0xFFFF9800), Color(0xFFFF5722)]
                                    : [Colors.grey.shade600, Colors.grey.shade700],
                              ),
                              boxShadow: isAnswered
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
                                borderRadius: BorderRadius.circular(15),
                                onTap: () {
                                  if (isAnswered) {
                                    _nextQuestion();
                                  } else {
                                    _showSnackBar("Réponds d'abord, bro !");
                                  }
                                },
                                child: Center(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        isLastQuestion ? 'Terminer' : 'Suivant',
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Icon(
                                        isLastQuestion
                                            ? Icons.check_circle_outline
                                            : Icons.arrow_forward,
                                        color: Colors.white,
                                        size: 20,
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
    );
  }
}