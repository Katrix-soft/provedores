import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/providers/firma_provider.dart';

class FirmaScreen extends StatefulWidget {
  const FirmaScreen({super.key});

  @override
  State<FirmaScreen> createState() => _FirmaScreenState();
}

class _FirmaScreenState extends State<FirmaScreen> {
  late TextEditingController _titleController;
  List<List<Offset>> _tempStrokes = [];
  bool _isSaving = false;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final provider = context.read<FirmaProvider>();
      _titleController = TextEditingController(text: provider.titulo);
      _initialized = true;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _clearCanvas() {
    setState(() {
      _tempStrokes.clear();
    });
  }

  void _handlePanStart(DragDownDetails details, BuildContext context) {
    RenderBox box = context.findRenderObject() as RenderBox;
    Offset point = box.globalToLocal(details.globalPosition);
    setState(() {
      _tempStrokes.add([point]);
    });
  }

  void _handlePanUpdate(DragUpdateDetails details, BuildContext context) {
    RenderBox box = context.findRenderObject() as RenderBox;
    Offset point = box.globalToLocal(details.globalPosition);
    setState(() {
      if (_tempStrokes.isNotEmpty) {
        _tempStrokes.last.add(point);
      }
    });
  }

  void _guardarFirma() async {
    if (_tempStrokes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, dibuja una firma antes de guardar.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    
    setState(() => _isSaving = true);
    
    final provider = context.read<FirmaProvider>();
    provider.updateStrokes(_tempStrokes);
    await provider.saveSettings();
    
    if (!mounted) return;
    setState(() {
      _isSaving = false;
      _tempStrokes.clear();
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        content: const Row(
          children: [
            Icon(Icons.check_circle_outline, color: Colors.white),
            SizedBox(width: 8),
            Text('Firma guardada correctamente', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  void _subirImagen() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Módulo de carga de archivos abierto. Selecciona una imagen PNG o JPG con fondo transparente.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = context.watch<FirmaProvider>();

    if (!provider.isLoaded) {
      return Scaffold(
        backgroundColor: theme.colorScheme.surface,
        appBar: AppBar(title: const Text('Configuración de Firma')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Configuración de Firma', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.colorScheme.primary),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: theme.colorScheme.outlineVariant.withOpacity(0.5), height: 1),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help),
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Tu firma digital', style: theme.textTheme.headlineSmall?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('Personaliza cómo aparecerá tu validación en los documentos legales y pólizas.', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                const SizedBox(height: 24),

                // Vista Previa
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: theme.colorScheme.outlineVariant.withOpacity(0.5)),
                  ),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD3E4FE), // surface-container-highest
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text('VISTA PREVIA', style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurfaceVariant)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        height: 160,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF4FF), // surface-container-low
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: theme.colorScheme.outlineVariant.withOpacity(0.5)),
                        ),
                        child: provider.strokes.isEmpty 
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.draw, size: 48, color: theme.colorScheme.onSurfaceVariant.withOpacity(0.6)),
                                  const SizedBox(height: 8),
                                  Text('Aún no has configurado una firma', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                                ],
                              )
                            : ClipRect(
                                child: CustomPaint(
                                  painter: _SignaturePainter(provider.strokes, theme.colorScheme.primary),
                                ),
                              ),
                      ),
                      const SizedBox(height: 16),
                      const Divider(height: 1),
                      const SizedBox(height: 16),
                      Text(
                        provider.titulo.isEmpty ? "Tu Firma" : provider.titulo,
                        style: theme.textTheme.titleMedium?.copyWith(fontStyle: FontStyle.italic, color: theme.colorScheme.primary, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text('Nexus ID: 8829 | Senior Producer', style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant), textAlign: TextAlign.center),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Botones de interacción
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {}, // Ya estamos en la sección de dibujo
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.white,
                          side: BorderSide(color: theme.colorScheme.primary.withOpacity(0.5), width: 2),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Column(
                          children: [
                            Icon(Icons.draw, color: theme.colorScheme.primary),
                            const SizedBox(height: 8),
                            Text('Dibujar Firma', style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onSurface)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _subirImagen,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.white,
                          side: BorderSide(color: theme.colorScheme.outlineVariant.withOpacity(0.5)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Column(
                          children: [
                            Icon(Icons.upload_file, color: theme.colorScheme.primary),
                            const SizedBox(height: 8),
                            Text('Subir Imagen', style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onSurface)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Área de dibujo
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('ÁREA DE DIBUJO', style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant, letterSpacing: 1.2)),
                    TextButton.icon(
                      onPressed: _clearCanvas,
                      icon: const Icon(Icons.refresh, size: 16),
                      label: const Text('Limpiar'),
                    ),
                  ],
                ),
                Container(
                  height: 256,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: theme.colorScheme.primary.withOpacity(0.2), width: 2),
                  ),
                  child: Builder(
                    builder: (context) {
                      return GestureDetector(
                        onPanDown: (details) => _handlePanStart(details, context),
                        onPanUpdate: (details) => _handlePanUpdate(details, context),
                        child: CustomPaint(
                          painter: _SignaturePainter(_tempStrokes, theme.colorScheme.primary),
                          size: Size.infinite,
                        ),
                      );
                    }
                  ),
                ),
                const SizedBox(height: 24),

                // Texto de Firma
                Text('TEXTO DE FIRMA (CARGO O NOMBRE)', style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant, letterSpacing: 1.2)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _titleController,
                  onChanged: (val) => provider.updateTitulo(val),
                  decoration: InputDecoration(
                    hintText: 'Escribe tu cargo profesional...',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: theme.colorScheme.outlineVariant),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: theme.colorScheme.outlineVariant),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text('Este texto aparecerá debajo de tu firma manuscrita.', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                const SizedBox(height: 32),

                ElevatedButton.icon(
                  onPressed: _isSaving ? null : _guardarFirma,
                  icon: _isSaving ? const SizedBox.shrink() : const Icon(Icons.save),
                  label: _isSaving
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text('Guardar Firma', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SignaturePainter extends CustomPainter {
  final List<List<Offset>> strokes;
  final Color color;

  _SignaturePainter(this.strokes, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    for (var stroke in strokes) {
      if (stroke.isEmpty) continue;
      
      final path = Path();
      path.moveTo(stroke.first.dx, stroke.first.dy);
      
      for (int i = 1; i < stroke.length; i++) {
        path.lineTo(stroke[i].dx, stroke[i].dy);
      }
      
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SignaturePainter oldDelegate) {
    return true; // We want to repaint when strokes change
  }
}
