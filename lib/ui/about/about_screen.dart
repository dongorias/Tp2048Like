import 'package:flutter/material.dart';
import 'package:tp2048/res/app_theme.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: kBottomNavigationBarHeight),
            child: Center(
              child: Text(
                  "Version 1.0.0\n© 2024",
                  textAlign: TextAlign.center,
                style: context.textCaption.copyWith(
                  color: Colors.black
                ),

              ),
            ),
          ),
        ],
      ),
      appBar: AppBar(
        title: Text("À propos du projet",
          style: context.textTitle.copyWith(
              color: Colors.black
          ),
        ),
      ),
      body:  Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Titre principal
            Center(
              child: Text(
                "Projet d'application mobile\nDans le cadre d'un TP d'école",
                textAlign: TextAlign.center,
                style: context.textCaption.copyWith(
                    color: Colors.black
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Description du projet
            Text(
              "Ce projet a été réalisé dans le cadre d'un travail pratique visant à "
                  "apprendre les bases du développement mobile avec Flutter. "
                  "Voici les membres de l'équipe ayant contribué au projet :",
              style: context.textCaption.copyWith(
                  color: Colors.black
              ),
            ),
            const SizedBox(height: 20),
            // Liste des membres de l'équipe
            const Column(
              children: [
                TeamMemberCard(
                  name: "AGOKOLI Don Arias",
                ),
                SizedBox(height: 10),
                TeamMemberCard(
                  name: "MALBET Corentin",
                ),
                SizedBox(height: 10),
                TeamMemberCard(
                  name: "THERET Tom",
                ),
                SizedBox(height: 10),
              ],
            ),
            const SizedBox(height: 20),

          ],
        ),
      ),
    );
  }
}


class TeamMemberCard extends StatelessWidget {
  final String name;

  const TeamMemberCard({
    super.key,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Text(
              name,
              style: context.textCaption.copyWith(
                  color: Colors.black
              ),
            ),
          ],
        ),
      ),
    );
  }
}