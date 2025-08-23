import 'package:flutter/material.dart';
import 'package:glassmorphic_ui_kit/glassmorphic_ui_kit.dart';
import 'package:intl/intl.dart';

class CalendarWidget extends StatelessWidget {
  const CalendarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dayName = DateFormat('EEEE').format(now).toUpperCase();
    final dayNumber = DateFormat('d').format(now);
    final monthName = DateFormat('MMMM').format(now).toUpperCase();

    // Get first day of the month and calculate grid
    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
    final firstWeekday = firstDayOfMonth.weekday % 7; // Make Sunday = 0
    final daysInMonth = lastDayOfMonth.day;

    return GlassContainer(
      borderRadius: BorderRadius.circular(12),
      gradient: LinearGradient(
        colors: [Colors.black87, Colors.black],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                dayName, //wednesday
                style: const TextStyle(
                  color: Color.fromARGB(255, 186, 186, 188),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                dayNumber, //20th wala 20
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.w300,
                  height: 1.0,
                ),
              ),
              Text(
                monthName, //wednesday
                style: const TextStyle(
                  color: Color.fromARGB(255, 255, 100, 100),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              children: [
                // Week day headers
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: ['S', 'M', 'T', 'W', 'T', 'F', 'S']
                      .map(
                        (day) => Expanded(
                          child: Text(
                            day,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color.fromARGB(255, 255, 100, 100),
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),

                const SizedBox(height: 4),

                // Calendar dates grid
                Expanded(
                  child: SingleChildScrollView(
                    child: _buildCalendarGrid(
                      firstWeekday,
                      daysInMonth,
                      now.day,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid(int firstWeekday, int daysInMonth, int currentDay) {
    List<Widget> calendarRows = [];
    List<Widget> currentWeek = [];

    // Add empty cells for days before the first day of month
    for (int i = 0; i < firstWeekday; i++) {
      currentWeek.add(const Expanded(child: SizedBox()));
    }

    // Add days of the month
    for (int day = 1; day <= daysInMonth; day++) {
      bool isToday = day == currentDay;

      currentWeek.add(
        Expanded(
          child: Container(
            height: 20,
            alignment: Alignment.center,
            decoration: isToday
                ? const BoxDecoration(
                    color: Color(0xFFFF453A),
                    shape: BoxShape.circle,
                  )
                : null,
            child: Text(
              '$day',
              style: TextStyle(
                color: isToday
                    ? Colors.white
                    : const Color.fromARGB(255, 186, 186, 188),
                fontSize: 12,
                fontWeight: isToday ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        ),
      );

      // If we've filled a week (7 days), add it to rows and start a new week
      if (currentWeek.length == 7) {
        calendarRows.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(children: currentWeek),
          ),
        );
        currentWeek = [];
      }
    }

    // Fill remaining cells in the last week if needed
    while (currentWeek.isNotEmpty && currentWeek.length < 7) {
      currentWeek.add(const Expanded(child: SizedBox()));
    }

    // Add the last week if it has content
    if (currentWeek.isNotEmpty) {
      calendarRows.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(children: currentWeek),
        ),
      );
    }

    return Column(children: calendarRows);
  }
}
