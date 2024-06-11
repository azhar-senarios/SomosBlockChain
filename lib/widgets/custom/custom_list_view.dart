import '../../all_utills.dart';

class SomosListViewBuilder extends StatelessWidget {
  const SomosListViewBuilder({
    super.key,
    this.shrinkWrap = false,
    this.scrollDirection = Axis.vertical,
    this.withExpanded = true,
    this.spacing = 10.0,
    this.lastWidgetSize = AppWidgets.fullScreenPaddingValue / 2,
    required this.items,
    required this.itemBuilder,
    this.emptyItemsWidget,
    this.separationWidget,
    this.padding,
    this.physics,
  });

  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final bool withExpanded;
  final EdgeInsets? padding;
  final Axis scrollDirection;
  final List<dynamic> items;
  final Function(dynamic) itemBuilder;

  // TODO enforce this widget once the app is stable enough
  final Widget? emptyItemsWidget;
  final Widget? separationWidget;
  final double spacing;
  final double lastWidgetSize;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      Widget widget;

      if (emptyItemsWidget == null) {
        widget = Center(
            child:
                Text('Empty List Items', style: context.textTheme.bodyLarge));
      } else {
        widget = Center(child: emptyItemsWidget!);
      }

      if (withExpanded) {
        widget = Expanded(child: widget);
      }

      return widget;
    }

    final sizedBox = separationWidget ??
        SizedBox(
          width: scrollDirection == Axis.horizontal ? spacing : 0,
          height: scrollDirection == Axis.vertical ? spacing : 0,
        );

    Widget widget = ListView.separated(
      shrinkWrap: shrinkWrap,
      primary: !shrinkWrap,
      physics: physics,
      scrollDirection: scrollDirection,
      padding: padding ?? EdgeInsets.zero,
      itemCount: items.length + 1,
      separatorBuilder: (_, __) => sizedBox,
      itemBuilder: (_, index) {
        if (index == items.length) {
          return SizedBox(height: lastWidgetSize);
        }

        return itemBuilder(items.elementAt(index));
      },
    );

    // only wrap if shrink wrap is false and with expanded is true
    if (withExpanded && !shrinkWrap) {
      widget = Expanded(child: widget);
    }

    return widget;
  }
}
