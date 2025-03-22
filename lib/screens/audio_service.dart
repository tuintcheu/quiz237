

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class AudioService {
  // Singleton pattern
  static final AudioService _instance = AudioService._internal();

  factory AudioService() => _instance;

  AudioService._internal();

  // Audio players
  final AudioPlayer backgroundMusic = AudioPlayer();
  final AudioPlayer correctSound = AudioPlayer();
  final AudioPlayer incorrectSound = AudioPlayer();
  final AudioPlayer tickSound = AudioPlayer();
  final AudioPlayer timeUpSound = AudioPlayer();
  final AudioPlayer nextSound = AudioPlayer();

  // État du volume
  bool _isMuted = false;
  bool get isMuted => _isMuted;

  // Initialisation
  Future<void> initialize() async {
    try {
      // Configuration de la musique de fond
      await backgroundMusic.setSource(AssetSource('sounds/background.mp3'));
      backgroundMusic.setReleaseMode(ReleaseMode.loop);

      // Précharger les autres sons
      await correctSound.setSource(AssetSource('sounds/correct.wav'));
      await incorrectSound.setSource(AssetSource('sounds/incorrect.wav'));
      await tickSound.setSource(AssetSource('sounds/tick.wav'));
      await timeUpSound.setSource(AssetSource('sounds/timeup.wav'));
      await nextSound.setSource(AssetSource('sounds/next.mp3'));

      print('AudioService initialized successfully');
    } catch (e) {
      print('Error initializing AudioService: $e');
    }
  }

  // Démarrer la musique de fond
  Future<void> playBackgroundMusic() async {
    try {
      if (!_isMuted && backgroundMusic.state != PlayerState.playing) {
        await backgroundMusic.resume();
      }
    } catch (e) {
      print('Error playing background music: $e');
    }
  }

  // Jouer les sons d'effet
  Future<void> playSound(AudioPlayer player) async {
    try {
      await backgroundMusic.setSource(AssetSource('sounds/background.mp3'));
      backgroundMusic.setReleaseMode(ReleaseMode.loop);
      if (!_isMuted) {
        if (player == correctSound) {
          await correctSound.play(AssetSource('sounds/correct.wav'));
        } else if (player == incorrectSound) {
          await incorrectSound.play(AssetSource('sounds/incorrect.wav'));
        } else if (player == tickSound) {
          await tickSound.play(AssetSource('sounds/tick.wav'));
        } else if (player == timeUpSound) {
          await timeUpSound.play(AssetSource('sounds/timeup.wav'));
        } else if (player == nextSound) {
          await nextSound.play(AssetSource('sounds/next.mp3'));
        }
      }
    } catch (e) {
      print('Error playing sound effect: $e');
    }
  }

  // Activer/désactiver le son
  void toggleMute() {
    _isMuted = !_isMuted;

    if (_isMuted) {
      // Couper tous les sons
      backgroundMusic.pause();
      correctSound.pause();
      incorrectSound.pause();
      tickSound.pause();
      timeUpSound.pause();
      nextSound.pause();
    } else {
      // Reprendre la musique de fond
      playBackgroundMusic();
    }
  }

  // Arrêter tous les sons
  void stopAllSounds() {
    correctSound.stop();
    incorrectSound.stop();
    tickSound.stop();
    timeUpSound.stop();
    nextSound.stop();
  }

  // Libérer les ressources
  void dispose() {
    backgroundMusic.dispose();
    correctSound.dispose();
    incorrectSound.dispose();
    tickSound.dispose();
    timeUpSound.dispose();
    nextSound.dispose();
  }
}