import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../shared/widgets/app_top_bar.dart';
import '../../core/database/static_database.dart';
import '../../shared/widgets/empty_state_widget.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
/// Jadwal Kuliah (Class Schedule) screen.
///
/// Features a horizontal day selector, add-schedule form,
/// and a list of today's schedule cards with colored side bars.
class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  int _selectedDay = 0;
  String? _selectedFormDay;

  static const _days = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];

  // ── Form Controllers ──────────────────────────────────────────────
  final _courseController = TextEditingController();
  final _startController = TextEditingController();
  final _endController = TextEditingController();
  final _roomController = TextEditingController();

  @override
  void dispose() {
    _courseController.dispose();
    _startController.dispose();
    _endController.dispose();
    _roomController.dispose();
    super.dispose();
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

  Future<void> _pickTimeForController(BuildContext ctx, TextEditingController controller) async {
    TimeOfDay initial = const TimeOfDay(hour: 8, minute: 0);
    if (controller.text.isNotEmpty) {
      final parts = controller.text.split(':');
      if (parts.length == 2) {
        final h = int.tryParse(parts[0]);
        final m = int.tryParse(parts[1]);
        if (h != null && m != null) {
          initial = TimeOfDay(hour: h, minute: m);
        }
      }
    }
    final picked = await showTimePicker(
      context: ctx,
      initialTime: initial,
    );
    if (picked != null) {
      final formatted = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      controller.text = formatted;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.creamBackground,
      appBar: const AppTopBar(title: 'Jadwal'),
      body: CustomScrollView(
        slivers: [
          // ── Top Content ────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAddScheduleForm(),
                  const SizedBox(height: 32),
                  _buildDaySelector(),
                  const SizedBox(height: 24),
                  _buildTodayScheduleHeader(),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),

          // ── Schedule List (Lazy Loaded) ─────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
            sliver: _buildTodayScheduleSliverList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDaySelector() {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _days.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final isActive = index == _selectedDay;
          return GestureDetector(
            onTap: () => setState(() => _selectedDay = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.primaryContainer
                    : AppColors.surface,
                borderRadius: BorderRadius.circular(100),
                border: isActive
                    ? null
                    : Border.all(color: AppColors.outlineVariant),
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
                _days[index],
                style: AppTypography.labelMedium.copyWith(
                  color: isActive
                      ? AppColors.onPrimary
                      : AppColors.onSurfaceVariant,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAddScheduleForm() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
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
          Text(
            'Tambah Jadwal Baru',
            style: AppTypography.titleLarge.copyWith(
              color: AppColors.onBackground,
            ),
          ),

          const SizedBox(height: 16),

          // Mata Kuliah
          _SmallFormLabel('NAMA MATA KULIAH'),
          const SizedBox(height: 4),
          TextField(
            controller: _courseController,
            decoration: InputDecoration(
              hintText: 'Contoh: Kalkulus 1',
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.cardBorder),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.cardBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 1.5,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Hari, Mulai & Selesai Row
          Row(
            children: [
              // Hari
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SmallFormLabel('HARI'),
                    const SizedBox(height: 4),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedFormDay,
                      decoration: InputDecoration(
                        hintText: 'Pilih',
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 8,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: AppColors.cardBorder),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: AppColors.cardBorder),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                            width: 1.5,
                          ),
                        ),
                      ),
                      style: AppTypography.bodyMedium.copyWith(color: AppColors.onSurface),
                      items: ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu']
                          .map((day) => DropdownMenuItem(
                                value: day,
                                child: Text(
                                  day,
                                  style: AppTypography.labelMedium,
                                ),
                              ))
                          .toList(),
                      onChanged: (val) {
                        setState(() {
                          _selectedFormDay = val;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Mulai
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SmallFormLabel('MULAI'),
                    const SizedBox(height: 4),
                    TextField(
                      controller: _startController,
                      readOnly: true,
                      onTap: () => _pickTimeForController(context, _startController),
                      style: AppTypography.bodyMedium.copyWith(color: AppColors.onSurface),
                      decoration: InputDecoration(
                        hintText: 'Pilih jam',
                        suffixIcon: const Icon(Icons.access_time_rounded, size: 16, color: AppColors.onSurfaceVariant),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 8,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: AppColors.cardBorder),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: AppColors.cardBorder),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Selesai
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SmallFormLabel('SELESAI'),
                    const SizedBox(height: 4),
                    TextField(
                      controller: _endController,
                      readOnly: true,
                      onTap: () => _pickTimeForController(context, _endController),
                      style: AppTypography.bodyMedium.copyWith(color: AppColors.onSurface),
                      decoration: InputDecoration(
                        hintText: 'Pilih jam',
                        suffixIcon: const Icon(Icons.access_time_rounded, size: 16, color: AppColors.onSurfaceVariant),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 8,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: AppColors.cardBorder),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: AppColors.cardBorder),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Room
          _SmallFormLabel('RUANGAN'),
          const SizedBox(height: 4),
          TextField(
            controller: _roomController,
            decoration: InputDecoration(
              hintText: 'Contoh: TULT 14.14',
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.cardBorder),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.cardBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 1.5,
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Submit button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _addSchedule,
              icon: const Icon(Icons.add, size: 20),
              label: const Text('Simpan Jadwal'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryContainer,
                foregroundColor: AppColors.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 3,
                shadowColor: AppColors.primaryContainer.withValues(alpha: 0.15),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addSchedule() {
    final course = _courseController.text.trim();
    final start = _startController.text.trim();
    final end = _endController.text.trim();
    final room = _roomController.text.trim();
    final day = _selectedFormDay;

    if (course.isEmpty || start.isEmpty || end.isEmpty || room.isEmpty || day == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Harap isi semua kolom formulir!'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() {
      StaticDatabase().addSchedule(
        ScheduleItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          courseName: course,
          day: day,
          startTime: start,
          endTime: end,
          room: room,
        ),
      );
      // Reset form
      _courseController.clear();
      _startController.clear();
      _endController.clear();
      _roomController.clear();
      _selectedFormDay = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Jadwal berhasil disimpan!'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  Widget _buildTodayScheduleHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        'Jadwal Hari ${_days[_selectedDay]}',
        style: AppTypography.titleLarge.copyWith(
          color: AppColors.onSurface,
        ),
      ),
    );
  }

  Widget _buildTodayScheduleSliverList() {
    final selectedDayName = _days[_selectedDay];
    final daySchedules = StaticDatabase().getSchedulesByDay(selectedDayName);

    if (daySchedules.isEmpty) {
      return SliverToBoxAdapter(
        child: EmptyStateWidget(
          message: 'Tidak ada jadwal hari $selectedDayName',
        ),
      );
    }

    return SliverList.separated(
      itemCount: daySchedules.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = daySchedules[index];
        return _buildScheduleCard(item);
      },
    );
  }

  Widget _buildScheduleCard(ScheduleItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Slidable(
        key: ValueKey(item.id),
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (context) => _showEditScheduleBottomSheet(item),
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
              icon: Icons.edit,
              label: 'Edit',
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
            ),
          ],
        ),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (context) {
                _confirmDelete(
                  title: 'Hapus Jadwal',
                  content: 'Apakah Anda yakin ingin menghapus jadwal kuliah ${item.courseName}?',
                  onConfirm: () {
                    setState(() {
                      StaticDatabase().deleteSchedule(item.id);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Jadwal ${item.courseName} berhasil dihapus.'),
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
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.cardBorder),
          ),
          clipBehavior: Clip.antiAlias,
          child: IntrinsicHeight(
            child: Row(
              children: [
                Container(
                  width: 6,
                  color: AppColors.primaryContainer,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.courseName,
                                style: AppTypography.titleLarge.copyWith(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.onSurface,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.access_time,
                                    size: 16,
                                    color: AppColors.onSurfaceVariant,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    '${item.startTime} - ${item.endTime}',
                                    style: AppTypography.bodyMedium.copyWith(
                                      color: AppColors.onSurfaceVariant,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  const Icon(
                                    Icons.room_outlined,
                                    size: 16,
                                    color: AppColors.onSurfaceVariant,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    item.room,
                                    style: AppTypography.bodyMedium.copyWith(
                                      color: AppColors.onSurfaceVariant,
                                      fontSize: 14,
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showEditScheduleBottomSheet(ScheduleItem item) {
    final editCourseController = TextEditingController(text: item.courseName);
    final editStartController = TextEditingController(text: item.startTime);
    final editEndController = TextEditingController(text: item.endTime);
    final editRoomController = TextEditingController(text: item.room);
    String? editSelectedDay = item.day;

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
                      'Ubah Jadwal',
                      style: AppTypography.titleLarge.copyWith(
                        color: AppColors.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const _SmallFormLabel('NAMA MATA KULIAH'),
                    const SizedBox(height: 4),
                    TextField(
                      controller: editCourseController,
                      style: AppTypography.bodyMedium.copyWith(color: AppColors.onSurface),
                      decoration: const InputDecoration(
                        hintText: 'Contoh: Pemrograman Mobile',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const _SmallFormLabel('HARI'),
                              const SizedBox(height: 4),
                              DropdownButtonFormField<String>(
                                initialValue: editSelectedDay,
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                ),
                                style: AppTypography.bodyMedium.copyWith(color: AppColors.onSurface),
                                items: _days
                                    .map(
                                      (d) => DropdownMenuItem(
                                        value: d,
                                        child: Text(d),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (val) {
                                  setBottomSheetState(() {
                                    editSelectedDay = val;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const _SmallFormLabel('RUANGAN'),
                              const SizedBox(height: 4),
                              TextField(
                                controller: editRoomController,
                                style: AppTypography.bodyMedium.copyWith(color: AppColors.onSurface),
                                decoration: const InputDecoration(
                                  hintText: 'LAB C-2',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const _SmallFormLabel('JAM MULAI'),
                              const SizedBox(height: 4),
                              TextField(
                                controller: editStartController,
                                readOnly: true,
                                onTap: () => _pickTimeForController(context, editStartController),
                                style: AppTypography.bodyMedium.copyWith(color: AppColors.onSurface),
                                decoration: const InputDecoration(
                                  hintText: 'Pilih jam',
                                  suffixIcon: Icon(Icons.access_time_rounded, size: 16, color: AppColors.onSurfaceVariant),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
                              const _SmallFormLabel('JAM SELESAI'),
                              const SizedBox(height: 4),
                              TextField(
                                controller: editEndController,
                                readOnly: true,
                                onTap: () => _pickTimeForController(context, editEndController),
                                style: AppTypography.bodyMedium.copyWith(color: AppColors.onSurface),
                                decoration: const InputDecoration(
                                  hintText: 'Pilih jam',
                                  suffixIcon: Icon(Icons.access_time_rounded, size: 16, color: AppColors.onSurfaceVariant),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          final course = editCourseController.text.trim();
                          final start = editStartController.text.trim();
                          final end = editEndController.text.trim();
                          final room = editRoomController.text.trim();
                          final day = editSelectedDay;

                          if (course.isEmpty || start.isEmpty || end.isEmpty || room.isEmpty || day == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Harap isi semua kolom!'),
                                backgroundColor: AppColors.error,
                              ),
                            );
                            return;
                          }

                          setState(() {
                            StaticDatabase().updateSchedule(
                              ScheduleItem(
                                id: item.id,
                                courseName: course,
                                day: day,
                                startTime: start,
                                endTime: end,
                                room: room,
                              ),
                            );
                          });

                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Jadwal berhasil diperbarui!'),
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
}

// ── Private widgets ──────────────────────────────────────────────────────

class _SmallFormLabel extends StatelessWidget {
  const _SmallFormLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTypography.labelSmall.copyWith(
        color: AppColors.onSurfaceVariant,
        letterSpacing: 1.5,
      ),
    );
  }
}

