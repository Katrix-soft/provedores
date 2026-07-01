import 'package:flutter/material.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final bool isThinking;
  final Widget? customContent;
  
  ChatMessage({
    required this.text,
    required this.isUser,
    this.isThinking = false,
    this.customContent,
  });
}

class AsistenteIAScreen extends StatefulWidget {
  final String? username;
  const AsistenteIAScreen({super.key, this.username});

  @override
  State<AsistenteIAScreen> createState() => _AsistenteIAScreenState();
}

class _AsistenteIAScreenState extends State<AsistenteIAScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    final name = widget.username ?? 'Carlos';
    _messages.add(ChatMessage(
      text: 'Hola, **$name**. ¡Es un gusto saludarte hoy!\n\n¿En qué puedo asistirte con tu cartera de clientes? Puedo ayudarte a cotizar, consultar siniestros o revisar pólizas vigentes.',
      isUser: false,
    ));
    _messages.add(ChatMessage(
      text: 'Necesito cotizar un auto para un cliente nuevo.',
      isUser: true,
    ));
    _messages.add(ChatMessage(
      text: '¡Excelente! Empecemos con la cotización de inmediato para tu nuevo cliente.\n\nPara darte el mejor precio, ¿qué **marca y modelo** es el vehículo?',
      isUser: false,
      customContent: _buildQuickActions(),
    ));
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;
    
    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true));
      _textController.clear();
      _isTyping = true;
    });
    _scrollToBottom();

    // Simulate AI thinking
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      setState(() {
        _messages.add(ChatMessage(text: 'Procesando datos...', isUser: false, isThinking: true));
      });
      _scrollToBottom();

      // Simulate AI response
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (!mounted) return;
        setState(() {
          _messages.removeLast(); // Remove thinking message
          _messages.add(ChatMessage(
            text: 'Entendido. Estoy buscando las mejores opciones de coberturas para ese modelo en nuestro sistema Nexus. ¿Es para uso particular o comercial?',
            isUser: false,
          ));
          _isTyping = false;
        });
        _scrollToBottom();
      });
    });
  }

  void _onSearchPlate() {
    setState(() {
      _messages.add(ChatMessage(text: 'Buscando patente...', isUser: true));
      _isTyping = true;
    });
    _scrollToBottom();

    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      setState(() {
        _messages.add(ChatMessage(text: 'Consultando registro automotor...', isUser: false, isThinking: true));
      });
      _scrollToBottom();

      Future.delayed(const Duration(milliseconds: 1500), () {
        if (!mounted) return;
        setState(() {
          _messages.removeLast();
          _messages.add(ChatMessage(
            text: '**Patente encontrada:** Ford Focus 2022. ¿Deseas proceder con la cotización para este vehículo?',
            isUser: false,
          ));
          _isTyping = false;
        });
        _scrollToBottom();
      });
    });
  }

  Widget _buildQuickActions() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          OutlinedButton.icon(
            onPressed: _onSearchPlate,
            icon: const Icon(Icons.search, size: 16),
            label: const Text('Buscar por Patente/Placa'),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF0058BE), // primary
              side: const BorderSide(color: Color(0xFF0058BE)),
              backgroundColor: Colors.white,
            ),
          ),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.directions_car, size: 16),
            label: const Text('Cargar Marca Manualmente'),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF424754), // on-surface-variant
              side: const BorderSide(color: Color(0xFFC2C6D6)), // outline-variant
              backgroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF), // background
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Row(
          children: [
            const Icon(Icons.shield, color: Color(0xFF0058BE)),
            const SizedBox(width: 8),
            Text(
              'Seguros Pro',
              style: theme.textTheme.titleLarge?.copyWith(
                color: const Color(0xFF0058BE),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              children: [
                if (MediaQuery.of(context).size.width >= 600)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Carlos PAS',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: const Color(0xFF0058BE),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'Productor Senior',
                        style: TextStyle(fontSize: 10, color: Color(0xFF727785)),
                      ),
                    ],
                  ),
                const SizedBox(width: 8),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF0058BE), width: 2),
                    image: const DecorationImage(
                      image: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuBjJtZByzg34-YNOeQS3z8mISEtZGadGoYtnICyqLjvoeL0MSjhixW5U5xpm1XnomuElE6MGj3kIGl9Hy9b1IzcFQUnRIgzEVS41dWRTKNup_u769dt_W6XNjWnJxPQnqUuAoo_qnH2DPUhbMVgjB4JZ-CUPlHZPTswQDjV4mZbgiKWJFfiuR8AMwX3vK7F4vbYmto7dY7QPaqc_MwMBcG2Ir6dva_MDCoCjS2fTI4-fOket3NX0bhUJL-tms_iL3gp2ApdebMsnVlo'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 100),
                  itemCount: _messages.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return _buildWelcomeCard();
                    }
                    final msg = _messages[index - 1];
                    return _buildMessageBubble(msg);
                  },
                ),
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildInputArea(),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF4FF), // surface-container-low
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFC2C6D6)), // outline-variant
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: Color(0xFF0058BE), // primary
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.smart_toy, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ASISTENTE IA SEGUROS PRO',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: const Color(0xFF727785),
                  letterSpacing: 1.5,
                ),
              ),
              const Text(
                'Panel de Operaciones',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0B1C30),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        mainAxisAlignment: message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            Container(
              width: 32,
              height: 32,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFDCE9FF), // surface-container-high
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFC2C6D6)),
              ),
              child: const Icon(Icons.smart_toy, color: Color(0xFF0058BE), size: 18),
            ),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: message.isUser ? const Color(0xFF0058BE) : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(12),
                  topRight: const Radius.circular(12),
                  bottomLeft: message.isUser ? const Radius.circular(12) : const Radius.circular(4),
                  bottomRight: message.isUser ? const Radius.circular(4) : const Radius.circular(12),
                ),
                border: message.isUser ? null : Border.all(color: const Color(0xFFC2C6D6)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0A000000),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFormattedText(message.text, message.isUser),
                  if (message.customContent != null) message.customContent!,
                ],
              ),
            ),
          ),
          if (message.isUser) ...[
            Container(
              width: 32,
              height: 32,
              margin: const EdgeInsets.only(left: 8),
              decoration: const BoxDecoration(
                color: Color(0xFF2170E4), // primary-container
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person, color: Colors.white, size: 18),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFormattedText(String text, bool isUser) {
    // Simple bold text parser for **text**
    final parts = text.split('**');
    final textSpans = <TextSpan>[];
    
    for (int i = 0; i < parts.length; i++) {
      textSpans.add(TextSpan(
        text: parts[i],
        style: TextStyle(
          color: isUser ? Colors.white : const Color(0xFF0B1C30),
          fontWeight: (i % 2 == 1) ? FontWeight.bold : FontWeight.normal,
        ),
      ));
    }
    
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 16,
          height: 1.5,
          fontFamily: 'Inter',
        ),
        children: textSpans,
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        border: const Border(top: BorderSide(color: Color(0xFFC2C6D6))),
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              color: const Color(0xFF727785),
              onPressed: () {},
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFC2C6D6)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        decoration: const InputDecoration(
                          hintText: 'Escribe tu mensaje aquí...',
                          hintStyle: TextStyle(color: Color(0xFF727785)),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                        onSubmitted: _sendMessage,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 4),
                      decoration: const BoxDecoration(
                        color: Color(0xFF0058BE),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.send, color: Colors.white, size: 20),
                        onPressed: () => _sendMessage(_textController.text),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.mic_none),
              color: const Color(0xFF727785),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
