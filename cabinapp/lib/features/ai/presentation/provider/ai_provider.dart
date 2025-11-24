import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../domain/chat_message.dart';
import '../../data/ai_repository.dart';

class AiProvider with ChangeNotifier {
  final AiRepository _repository;
  final List<ChatMessage> _messages = [];
  final Uuid _uuid = const Uuid();

  bool _isLoading = false;
  String? _errorMessage;

  List<ChatMessage> get messages => _messages;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  AiProvider(this._repository) {
    // Obtener el idioma del sistema
    final lang = WidgetsBinding.instance.platformDispatcher.locale.languageCode;

    // Mensaje inicial dependiendo del idioma
    String greeting;

    if (lang == "en") {
      greeting = "Hello 👋 I'm CabinAI, how can I help you today?";
    } else if (lang == "es") {
      greeting = "Hola 👋 Soy CabinAI, ¿en qué puedo ayudarte?";
    } else {
      greeting = "Hola 👋 Soy CabinAI, ¿en qué puedo ayudarte?";
    }
    // Mensaje inicial
    _messages.add(ChatMessage(
      id: _uuid.v4(),
      content: greeting,
      isUser: false,
      createdAt: DateTime.now(),
    ));
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// 📩 Enviar mensaje del usuario y obtener respuesta real del backend
  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // Agregar mensaje del usuario
    _messages.add(ChatMessage(
      id: _uuid.v4(),
      content: text.trim(),
      isUser: true,
      createdAt: DateTime.now(),
    ));
    notifyListeners();

    _setLoading(true);

    try {
      final responseText = await _repository.sendMessage(text);

      _messages.add(ChatMessage(
        id: _uuid.v4(),
        content: responseText,
        isUser: false,
        createdAt: DateTime.now(),
      ));
    } catch (e) {
      _messages.add(ChatMessage(
        id: _uuid.v4(),
        content: "⚠️ Error: ${e.toString()}",
        isUser: false,
        createdAt: DateTime.now(),
      ));
    } finally {
      _setLoading(false);
    }
  }
}