import 'package:flutter/material.dart';
import 'package:foto_ta/core/extension/spacing_extension.dart';
import 'package:foto_ta/core/theme/app_colors.dart';
import 'package:foto_ta/core/theme/app_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class DriveSearchItemWidget extends StatelessWidget {
  final int id;
  final String driveName;
  final String driveUrl;
  final String status;
  final String createdAt;
  final VoidCallback? onTap;

  const DriveSearchItemWidget({
    super.key,
    required this.id,
    required this.driveName,
    required this.driveUrl,
    required this.status,
    required this.createdAt,
    this.onTap,
  });

  String formatDate(String dateStr) {
    try {
      final DateTime date = DateTime.parse(dateStr);
      return 'Dibuat pada ${DateFormat('d MMMM yyyy').format(date)}';
    } catch (e) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    Color statusColor = Colors.grey;
    IconData statusIcon = Icons.help_outline;
    bool isClickable = false;

    if (status == 'completed') {
      statusColor = Colors.green;
      statusIcon = Icons.check_circle_outline;
      isClickable = true; 
    } else if (status == 'processing') {
      statusColor = Colors.blue;
      statusIcon = Icons.hourglass_empty;
    } else if (status == 'failed') {
      statusColor = Colors.red;
      statusIcon = Icons.error_outline;
    }

    return InkWell(
      onTap: isClickable ? onTap : null,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 1.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Container(
                width: 15.w,
                height: 15.w,
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
                child: Center(
                  child: Icon(statusIcon, color: statusColor, size: 8.w),
                ),
              ),
              4.wBox,
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 1.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        driveName,
                        style: AppFonts.subtitle.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      0.5.hBox,
                      Text(
                        formatDate(createdAt),
                        style: AppFonts.body.copyWith(
                          color: AppColors.textPrimary,
                          fontSize: 12,
                        ),
                      ),
                      0.5.hBox,
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 2.w,
                          vertical: 0.3.h,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          status.toUpperCase(),
                          style: AppFonts.body.copyWith(
                            color: statusColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Icon(Icons.chevron_right, color: AppColors.textSecondary),
              2.wBox,
            ],
          ),
        ),
      ),
    );
  }
}
