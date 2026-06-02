import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:nepal_rent_app/services/gemini_services.dart';
//import '../../services/gemini_service.dart';
import '../../utils/app_theme.dart';

class AIAssistantScreen extends StatefulWidget {
  const AIAssistantScreen({super.key});

  @override
  State<AIAssistantScreen> createState() => _AIAssistantScreenState();
}

class _AIAssistantScreenState extends State<AIAssistantScreen> {
  final TextEditingController _ctrl = TextEditingController();
  final ScrollController _scroll = ScrollController();
  final List<_AiMessage> _messages = [];
  bool _isTyping = false;

  final List<String> _suggestions = [
    '२BHK flat near Koteshwor Rs. 10,000 भित्र',
    'थमेलमा furnished कोठा',
    'ललितपुरमा सस्तो hostel',
    'पार्किङ भएको घर काठमाडौँमा',
  ];

  @override
  void initState() {
    super.initState();
    _messages.add(_AiMessage(
      text:
          'नमस्ते! 🏠 म घर ढुन्डो AI assistant हुँ।\n\nNepal मा कोठा खोज्न मलाई सोध्नुहोस् — Nepali वा English मा।\n\nउदाहरण: "Koteshwor मा 2BHK Rs. 15,000 भित्र"',
      isUser: false,
      time: DateTime.now(),
    ));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _send(String text) async {
    if (text.trim().isEmpty) return;
    _ctrl.clear();

    setState(() {
      _messages.add(_AiMessage(text: text, isUser: true, time: DateTime.now()));
      _isTyping = true;
    });
    _scrollDown();

    final reply = await GeminiService.searchRooms(text);

    setState(() {
      _isTyping = false;
      _messages
          .add(_AiMessage(text: reply, isUser: false, time: DateTime.now()));
    });
    _scrollDown();
  }

  void _scrollDown() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppTheme.primaryRed.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.auto_awesome,
                  size: 18, color: AppTheme.primaryRed),
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('AI Assistant',
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                Text('Powered by Gemini',
                    style: TextStyle(
                        fontSize: 10,
                        color: AppTheme.textGrey,
                        fontWeight: FontWeight.w400)),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Suggestions
          if (_messages.length <= 1)
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('सुझाव प्रयास गर्नुहोस्:',
                      style: TextStyle(
                          fontSize: 12, color: AppTheme.textGrey)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: _suggestions
                        .map((s) => GestureDetector(
                              onTap: () => _send(s),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryRed.withOpacity(0.07),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      color: AppTheme.primaryRed
                                          .withOpacity(0.2)),
                                ),
                                child: Text(s,
                                    style: const TextStyle(
                                        fontSize: 11,
                                        color: AppTheme.primaryRed)),
                              ),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),

          // Messages
          Expanded(
            child: ListView.builder(
              controller: _scroll,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (_, i) {
                if (_isTyping && i == _messages.length) {
                  return _buildTyping();
                }
                return _buildMessage(_messages[i]);
              },
            ),
          ),

          // Input
          Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 12,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _ctrl,
                    onSubmitted: _send,
                    decoration: InputDecoration(
                      hintText: 'कोठा खोज्नुहोस्...',
                      hintStyle:
                          const TextStyle(fontSize: 13, color: AppTheme.textGrey),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF3F4F6),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => _send(_ctrl.text),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryRed,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.send_rounded,
                        color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(_AiMessage msg) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            msg.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!msg.isUser) ...[
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppTheme.primaryRed.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.auto_awesome,
                  size: 14, color: AppTheme.primaryRed),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color:
                    msg.isUser ? AppTheme.primaryRed : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(msg.isUser ? 16 : 4),
                  bottomRight: Radius.circular(msg.isUser ? 4 : 16),
                ),
                border: msg.isUser
                    ? null
                    : Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Text(
                msg.text,
                style: TextStyle(
                  fontSize: 13,
                  color: msg.isUser ? Colors.white : AppTheme.textDark,
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTyping() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: AppTheme.primaryRed.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.auto_awesome,
                size: 14, color: AppTheme.primaryRed),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                3,
                (i) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: _TypingDot(delay: i * 200),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AiMessage {
  final String text;
  final bool isUser;
  final DateTime time;
  const _AiMessage(
      {required this.text, required this.isUser, required this.time});
}

class _TypingDot extends StatefulWidget {
  final int delay;
  const _TypingDot({required this.delay});

  @override
  State<_TypingDot> createState() => _TypingDotState();
}

class _TypingDotState extends State<_TypingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _anim = Tween<double>(begin: 0, end: -6).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _ctrl.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Transform.translate(
        offset: Offset(0, _anim.value),
        child: Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
              color: AppTheme.textGrey, shape: BoxShape.circle),
        ),
      ),
    );
  }
}