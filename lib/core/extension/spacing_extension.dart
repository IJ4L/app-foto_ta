import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

extension Spacing on num {
  SizedBox get hBox => SizedBox(height: toDouble().h);
  SizedBox get wBox => SizedBox(width: toDouble().w);
  EdgeInsets get pAll => EdgeInsets.all(toDouble().sp);
}
