import 'package:flutter/material.dart';
import 'package:flutter_crawl/drawer/drawer.dart';

class CustomScaffold extends Scaffold {
  const CustomScaffold({
    super.key,
    super.appBar,
    super.backgroundColor,
    super.body,
    super.bottomNavigationBar,
    super.bottomSheet,
    super.drawer = const RootDrawer(),
    super.drawerDragStartBehavior,
    super.drawerEdgeDragWidth,
    super.drawerEnableOpenDragGesture = true,
    super.drawerScrimColor,
    super.endDrawer,
    super.endDrawerEnableOpenDragGesture,
    super.extendBody,
    super.extendBodyBehindAppBar,
    super.floatingActionButton,
    super.floatingActionButtonAnimator,
    super.floatingActionButtonLocation,
    super.onDrawerChanged,
    super.onEndDrawerChanged,
    super.persistentFooterAlignment,
    super.persistentFooterButtons,
    super.primary,
    super.resizeToAvoidBottomInset,
    super.restorationId,
  });
}
