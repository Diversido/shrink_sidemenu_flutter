part of 'base.dart';

class ShrinkSlideSideMenuState extends SideMenuState {
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final size = widget.maxSize ?? mq.size;
    final statusBarHeight = mq.padding.top;

    return Material(
      color: widget.background ?? const Color(0xFF112473),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: statusBarHeight + (widget.closeIcon?.size ?? 25.0) * 2,
            bottom: 0.0,
            width: min(size.width * 0.70, widget.maxMenuWidth),
            right: widget._inverse == 1 ? null : 0,
            child: widget.menu,
          ),
          _getCloseButton(statusBarHeight),
          AnimatedContainer(
            duration: const Duration(milliseconds: 350),
            curve: widget.curve,
            alignment: Alignment.topLeft,
            transform: _getMatrix4(size),
            decoration: BoxDecoration(
              borderRadius: _getBorderRadius(),
            ),
            child: _getChild(),
          ),
        ],
      ),
    );
  }

  Widget _getChild() => Stack(
    children: [
      ClipRRect(
        borderRadius: _getBorderRadius(),
        clipBehavior: Clip.antiAlias,
        child: widget.child,
      ),
      if (_opened && widget.isDismissible)
        GestureDetector(
          onPanUpdate: (details) {
            // Swiping in right direction.
            if (details.delta.dx > 0) {
              if(widget.isDismissibleChildOnClick != null) {
                widget.isDismissibleChildOnClick!();
              } else {
                closeSideMenu();
              }
            }
            // Swiping in left direction.
            if (details.delta.dx < 0) {}
          },
          onTap: widget.isDismissibleChildOnClick ?? closeSideMenu,
          child: Container(color: widget.barrierColor ?? Colors.transparent),
        ),
    ],
  );

  BorderRadius _getBorderRadius() => _opened
      ? (widget.radius ?? BorderRadius.circular(34.0))
      : BorderRadius.zero;

  Matrix4 _getMatrix4(Size size) {
    if (_opened) {
      return Matrix4.identity()
        ..translate(
            min(size.width, widget.maxMenuWidth) *
                widget._inverse *
                (widget.inverse ? 0.6 : 0.9),
            (size.height * 0.1))
        ..scale(widget.maxMenuWidth / size.width, 0.8);
    }
    return Matrix4.identity();
  }
}
