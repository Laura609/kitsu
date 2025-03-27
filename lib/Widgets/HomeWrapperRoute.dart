// import 'package:auto_route/auto_route.dart';
// import 'package:flutter/material.dart';
// import 'package:test1/Widgets/bottom_bar_widget.dart';
// import 'package:test1/router/router.gr.dart';

// @RoutePage()
// class HomeWrapperRoute extends StatelessWidget {
//   const HomeWrapperRoute({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return AutoTabsRouter(
//       routes: [
//         const HomeRoute(),
//         FriendsRoute(),
//         const ChatsRoute(),
//         const MentorProfileRoute(), // Добавляем MentorProfileRoute
//       ],
//       builder: (context, child) {
//         final tabsRouter = context.tabsRouter;

//         return Scaffold(
//           body: child,
//           bottomNavigationBar: BottomNavBar(
//             tabsRouter: tabsRouter,
//           ),
//         );
//       },
//     );
//   }
// }
