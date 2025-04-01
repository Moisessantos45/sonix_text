import 'package:flutter/material.dart';

class GradeOptionsDisplay extends StatelessWidget {
  final String category;
  final String status;
  final String priority;
  final String dueDate;

  const GradeOptionsDisplay({
    super.key,
    required this.category,
    required this.status,
    required this.priority,
    required this.dueDate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              if (category.isNotEmpty)
                Expanded(
                  child: _buildStaticField(
                      icon: Icons.category_outlined,
                      label: 'Categoría',
                      value: category),
                ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStaticDateDisplay(),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: _buildStaticField(
                  icon: Icons.flag_outlined,
                  label: 'Estado',
                  value: status,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStaticField(
                  icon: Icons.priority_high_outlined,
                  label: 'Prioridad',
                  value: priority,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildStaticField({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey[300]!,
          width: 1.0,
        ),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.black54),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStaticDateDisplay() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey[300]!,
          width: 1.0,
        ),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.calendar_today_outlined,
              size: 20, color: Colors.black54),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Fecha',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  dueDate.toString(),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
