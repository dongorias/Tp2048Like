import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tp2048/res/app_theme.dart';

import '../../../controller/game_controller.dart';

Future<void> showBottomMenu(BuildContext context) async {
  await showModalBottomSheet<void>(
    isDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        height: 300,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24).copyWith(top: 24),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TopBar(),
            SizedBox(height: 16),
            Expanded(
              child: BottomMenuOptions(),
            ),
          ],
        ),
      );
    },
  );
}

class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InkWell(
          focusColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.close),
        ),
        Align(
          alignment: Alignment.center,
          child: Text(
            "But à atteindre",
            style: context.textBody,
          ),
        ),
      ],
    );
  }
}

class BottomMenuOptions extends StatelessWidget {
  const BottomMenuOptions({super.key});

  @override
  Widget build(BuildContext context) {
    final options = [
      const OptionButton(title: "2048", value: 2048),
      const OptionButton(title: "1024", value: 1024),
      const OptionButton(title: "512", value: 512),
      const OptionButton(title: "256", value: 256),
    ];

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 250,
        childAspectRatio: 2,
        crossAxisSpacing: 16,
      ),
      itemCount: options.length,
      itemBuilder: (context, index) => options[index],
    );
  }
}

class OptionButton extends StatelessWidget {
  const OptionButton({
    super.key,
    required this.title,
    required this.value,
  });

  final String title;
  final int value;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      focusColor: Colors.transparent,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      onTap: () => _handleOptionTap(value, context),
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter:
                ColorFilter.mode(context.colorAccent, BlendMode.srcIn),
            image: const AssetImage("assets/images/btn_img.png"),
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: context.textCaption,
          ),
        ),
      ),
    );
  }

  void _handleOptionTap(int value, context) {
    Provider.of<GameController>(context, listen: false).setGoal(value);
    Navigator.pop(context);
  }
}
