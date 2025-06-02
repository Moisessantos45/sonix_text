import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonix_text/presentation/riverpod/riverpod.dart';
import 'package:sonix_text/domains/entity_grade.dart';
import 'package:sonix_text/presentation/widgets/widgets.dart';

class ScreenSearchNoteLink extends ConsumerStatefulWidget {
  final String fromId;
  const ScreenSearchNoteLink({super.key, required this.fromId});

  @override
  ConsumerState<ScreenSearchNoteLink> createState() =>
      _ScreenSearchNoteLinkState();
}

class _ScreenSearchNoteLinkState extends ConsumerState<ScreenSearchNoteLink> {
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  String _searchQuery = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUnrelatedNotes();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadUnrelatedNotes() async {
    try {
      ref.read(unrelatedGradesProvider.notifier).setNoteId(widget.fromId);
      ref.read(relatedGradesProvider.notifier).setNoteId(widget.fromId);
    } catch (e) {
      debugPrint('Error loading unrelated notes: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    final unrelatedNotes = ref.watch(unrelatedGradesProvider);
    final relatedNotes = ref.watch(relatedGradesProvider);

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color(0xFFD6EAF8).withAlpha(50),
      appBar: AppBar(
        backgroundColor: const Color(0xFFD6EAF8).withAlpha(50),
        surfaceTintColor: const Color(0xFFD6EAF8).withAlpha(50),
        elevation: 0,
        title: Text(
          'Buscar Notas',
          style: TextStyle(
            color: const Color(0xFF2C3E50),
            fontSize: screenWidth * 0.055,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF2C3E50)),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              children: [
                // Primera sección: Notas no relacionadas
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(screenWidth * 0.04),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Buscar nota para vincular',
                            style: TextStyle(
                              fontSize: screenWidth * 0.045,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF2C3E50),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.015),
                          _buildSearchBar(screenWidth, screenHeight),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(25)),
                        ),
                        child: isLoading
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xFF3498DB),
                                ),
                              )
                            : _buildResultsList(
                                unrelatedNotes, screenWidth, screenHeight),
                      ),
                    ),
                  ],
                ),

                // Segunda sección: Notas relacionadas
                _buildRelatedNotes(relatedNotes, screenWidth, screenHeight),
              ],
            ),
          ),
          // Barra indicadora
          Container(
            padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: screenWidth * 0.1,
                  height: screenHeight * 0.005,
                  decoration: BoxDecoration(
                    color: const Color(0xFF3498DB),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(double screenWidth, double screenHeight) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(screenWidth * 0.04),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: _onSearchChanged,
        style: TextStyle(
          fontSize: screenWidth * 0.04,
          color: const Color(0xFF2C3E50),
        ),
        decoration: InputDecoration(
          hintText: 'Buscar por título, contenido o categoría...',
          hintStyle: TextStyle(
            color: const Color(0xFF7F8C8D),
            fontSize: screenWidth * 0.035,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: const Color(0xFF3498DB),
            size: screenWidth * 0.06,
          ),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: const Color(0xFF7F8C8D),
                    size: screenWidth * 0.05,
                  ),
                  onPressed: _clearSearch,
                )
              : null,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04,
            vertical: screenHeight * 0.02,
          ),
        ),
      ),
    );
  }

  Widget _buildResultsList(
      List<EntityGrade> notes, double screenWidth, double screenHeight) {
    if (notes.isEmpty) {
      return _buildEmptyState(screenWidth, screenHeight);
    }

    return ResultsListWidget(
      notes: notes,
      screenWidth: screenWidth,
      screenHeight: screenHeight,
      fromId: widget.fromId,
      searchQuery: _searchQuery,
      clearSearchAction: _clearSearch,
    );
  }

  Widget _buildEmptyState(double screenWidth, double screenHeight) {
    return EmptyStateIndicator(
      screenWidth: screenWidth,
      screenHeight: screenHeight,
      searchQuery: _searchQuery,
    );
  }

  Widget _buildRelatedNotes(
      List<EntityGrade> notes, double screenWidth, double screenHeight) {
    return RelatedNotesWidget(
      notes: notes,
      screenWidth: screenWidth,
      screenHeight: screenHeight,
    );
  }
}
