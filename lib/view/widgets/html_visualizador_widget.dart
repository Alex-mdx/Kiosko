import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:sizer/sizer.dart';

class HtmlVisualizadorWidget extends StatelessWidget {
  final String body;
  const HtmlVisualizadorWidget({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    return HtmlWidget('''
  $body
  ''',

        // specify custom styling for an element
        // see supported inline styling below
        customStylesBuilder: (element) {
      if (element.classes.contains('foo')) {
        return {'color': 'red'};
      }

      return null;
    },
        // select the render mode for HTML body
        // by default, a simple `Column` is rendered
        // consider using `ListView` or `SliverList` for better performance
        renderMode: RenderMode.column,
        // set the default styling for text
        textStyle: TextStyle(fontSize: 11.sp));
  }
}
