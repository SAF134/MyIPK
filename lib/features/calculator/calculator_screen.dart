import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../shared/widgets/app_top_bar.dart';
import '../../core/database/static_database.dart';
import '../../shared/widgets/empty_state_widget.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
/// Kalkulator IPK screen — input courses and simulate GPA.
///
/// Contains a form to add courses (name, SKS, grade),
/// a simulation summary panel, and recent entry history.
class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final _nameController = TextEditingController();
  String _selectedSemester = '1';
  int _filterSemester = 1;
  String _selectedSks = '3';
  String _selectedGrade = 'A';

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveCourse() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nama Mata Kuliah tidak boleh kosong!'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final sksVal = int.parse(_selectedSks);
    final semVal = int.parse(_selectedSemester);

    setState(() {
      StaticDatabase().addCourse(
        CourseItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: name,
          sks: sksVal,
          grade: _selectedGrade,
          semester: semVal,
        ),
      );
      _filterSemester = semVal;
      _nameController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Berhasil menyimpan $name!'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _confirmDelete({
    required String title,
    required String content,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          backgroundColor: Colors.white,
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.errorContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.delete_outline,
                  color: AppColors.error,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: AppTypography.titleLarge.copyWith(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            content,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          actionsPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          actions: [
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.cardBorder),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      'Tidak',
                      style: AppTypography.labelMedium.copyWith(
                        color: AppColors.onSurfaceVariant,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      onConfirm();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      foregroundColor: AppColors.onError,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      'Ya',
                      style: AppTypography.labelMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      appBar: const AppTopBar(title: 'IPK'),
      body: CustomScrollView(
        slivers: [
          // ── Content ──────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // ── Add Course Form ────────────────────────────
                _buildAddCourseForm(),
                
                const SizedBox(height: 24),

                // ── Semester Selector ──────────────────────────
                _buildSemesterSelector(),
                
                // ── Semester Courses List ──────────────────────
                _buildSemesterCoursesList(),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddCourseForm() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryContainer.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──────────────────────────────────────
          Text(
            'Tambah Mata Kuliah',
            style: AppTypography.headlineMedium.copyWith(
              color: AppColors.onSurface,
            ),
          ),

          const SizedBox(height: 24),

          // ── Course Name ─────────────────────────────────
          const _FormLabel('NAMA MATA KULIAH'),
          const SizedBox(height: 4),
          TextField(
            controller: _nameController,
            style: AppTypography.bodyMedium.copyWith(color: AppColors.onSurface),
            decoration: InputDecoration(
              hintText: 'Contoh: Kalkulus 1',
              hintStyle: AppTypography.bodyMedium.copyWith(
                color: AppColors.onSurfaceVariant.withValues(alpha: 0.5),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // ── Semester, SKS & Index Row ───────────────────
          Row(
            children: [
              // Semester
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _FormLabel('SEMESTER'),
                    const SizedBox(height: 4),
                    _buildDropdown(
                      value: _selectedSemester,
                      items: ['1', '2', '3', '4', '5', '6', '7', '8'],
                      displayText: (v) => v,
                      onChanged: (v) => setState(() => _selectedSemester = v!),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // SKS
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _FormLabel('SKS'),
                    const SizedBox(height: 4),
                    _buildDropdown(
                      value: _selectedSks,
                      items: ['1', '2', '3', '4'],
                      displayText: (v) => v,
                      onChanged: (v) => setState(() => _selectedSks = v!),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Index (Grade)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _FormLabel('INDEX'),
                    const SizedBox(height: 4),
                    _buildDropdown(
                      value: _selectedGrade,
                      items: ['A', 'AB', 'B', 'BC', 'C', 'D', 'E'],
                      displayText: (v) => v,
                      onChanged: (v) => setState(() => _selectedGrade = v!),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // ── Submit Button ───────────────────────────────
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _saveCourse,
              icon: const Icon(Icons.save, size: 20),
              label: const Text('Hitung & Simpan'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryContainer,
                foregroundColor: AppColors.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 4,
                shadowColor: AppColors.primaryContainer.withValues(alpha: 0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSemesterCoursesList() {
    final semVal = _filterSemester;
    final courses = StaticDatabase().getCoursesBySemester(semVal);

    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryContainer.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Matkul Semester $semVal',
                style: AppTypography.titleLarge.copyWith(
                  color: AppColors.onSurface,
                  fontSize: 18,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'IPS: ${StaticDatabase().getIpsBySemester(semVal).toStringAsFixed(2)}',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (courses.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: EmptyStateWidget(
                message: 'Belum ada mata kuliah di semester ini.',
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: courses.length,
              separatorBuilder: (_, _) => const Divider(height: 16),
              itemBuilder: (context, index) {
                final course = courses[index];
                return Slidable(
                  key: ValueKey(course.id),
                  startActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) => _showEditCourseBottomSheet(course),
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.onPrimary,
                        icon: Icons.edit,
                        label: 'Edit',
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ],
                  ),
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) {
                          _confirmDelete(
                            title: 'Hapus Mata Kuliah',
                            content: 'Apakah Anda yakin ingin menghapus mata kuliah ${course.name}?',
                            onConfirm: () {
                              setState(() {
                                StaticDatabase().deleteCourse(course.id);
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${course.name} berhasil dihapus.'),
                                  backgroundColor: AppColors.error,
                                ),
                              );
                            },
                          );
                        },
                        backgroundColor: AppColors.error,
                        foregroundColor: AppColors.onError,
                        icon: Icons.delete,
                        label: 'Hapus',
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.getGradeColor(course.grade).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            course.grade,
                            style: AppTypography.bodyLarge.copyWith(
                              color: AppColors.getGradeColor(course.grade),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              course.name,
                              style: AppTypography.bodyLarge.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.onSurface,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${course.sks} SKS',
                              style: AppTypography.labelSmall.copyWith(
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  void _showEditCourseBottomSheet(CourseItem course) {
    final editNameController = TextEditingController(text: course.name);
    final editSksController = TextEditingController(text: course.sks.toString());
    String editGrade = course.grade;
    int editSemester = course.semester;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setBottomSheetState) {
            return Container(
              padding: EdgeInsets.fromLTRB(
                24,
                24,
                24,
                MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 48,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.outlineVariant,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Ubah Mata Kuliah',
                      style: AppTypography.titleLarge.copyWith(
                        color: AppColors.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'NAMA MATA KULIAH',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: editNameController,
                      style: AppTypography.bodyMedium.copyWith(color: AppColors.onSurface),
                      decoration: const InputDecoration(
                        hintText: 'Contoh: Kalkulus 1',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'SKS',
                                style: AppTypography.labelSmall.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextField(
                                controller: editSksController,
                                keyboardType: TextInputType.number,
                                style: AppTypography.bodyMedium.copyWith(color: AppColors.onSurface),
                                decoration: const InputDecoration(
                                  hintText: 'Jumlah SKS',
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'SEMESTER',
                                style: AppTypography.labelSmall.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              DropdownButtonFormField<int>(
                                initialValue: editSemester,
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                ),
                                style: AppTypography.bodyMedium.copyWith(color: AppColors.onSurface),
                                items: List.generate(8, (i) => i + 1)
                                    .map(
                                      (s) => DropdownMenuItem(
                                        value: s,
                                        child: Text('$s'),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (val) {
                                  if (val != null) {
                                    setBottomSheetState(() {
                                      editSemester = val;
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'INDEX NILAI (GRADE)',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      initialValue: editGrade,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      style: AppTypography.bodyMedium.copyWith(color: AppColors.onSurface),
                      items: const ['A', 'AB', 'B', 'BC', 'C', 'D', 'E']
                          .map(
                            (g) => DropdownMenuItem(
                              value: g,
                              child: Text('Nilai $g'),
                            ),
                          )
                          .toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setBottomSheetState(() {
                            editGrade = val;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          final name = editNameController.text.trim();
                          final sksText = editSksController.text.trim();
                          final sks = int.tryParse(sksText) ?? 0;

                          if (name.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Nama Mata Kuliah tidak boleh kosong!'),
                                backgroundColor: AppColors.error,
                              ),
                            );
                            return;
                          }

                          if (sks <= 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('SKS harus lebih besar dari 0!'),
                                backgroundColor: AppColors.error,
                              ),
                            );
                            return;
                          }

                          setState(() {
                            StaticDatabase().updateCourse(
                              CourseItem(
                                id: course.id,
                                name: name,
                                sks: sks,
                                grade: editGrade,
                                semester: editSemester,
                              ),
                            );
                            _filterSemester = editSemester;
                            _selectedSemester = editSemester.toString();
                          });

                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Mata kuliah berhasil diperbarui!'),
                              backgroundColor: AppColors.primary,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryContainer,
                          foregroundColor: AppColors.onPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text('Simpan Perubahan'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSemesterSelector() {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 8,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final semesterNum = index + 1;
          final isActive = semesterNum == _filterSemester;
          return GestureDetector(
            onTap: () {
              setState(() {
                _filterSemester = semesterNum;
                _selectedSemester = semesterNum.toString();
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.primaryContainer
                    : AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(100),
                border: isActive
                    ? null
                    : Border.all(color: AppColors.cardBorder),
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: AppColors.primaryContainer.withValues(alpha: 0.15),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Text(
                'Semester $semesterNum',
                style: AppTypography.labelMedium.copyWith(
                  color: isActive
                      ? AppColors.onPrimary
                      : AppColors.onSurfaceVariant,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required String Function(String) displayText,
    required ValueChanged<String?> onChanged,
    EdgeInsetsGeometry? contentPadding,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: InputDecoration(
        contentPadding: contentPadding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      ),
      icon: const Icon(
        Icons.expand_more,
        color: AppColors.onSurfaceVariant,
      ),
      style: AppTypography.bodyMedium.copyWith(
        color: AppColors.onSurface,
      ),
      items: items
          .map(
            (e) => DropdownMenuItem(
              value: e,
              child: Text(displayText(e)),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }
}

// ── Private widgets ──────────────────────────────────────────────────────

class _FormLabel extends StatelessWidget {
  const _FormLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        text,
        style: AppTypography.labelMedium.copyWith(
          color: AppColors.onSurface,
        ),
      ),
    );
  }
}
