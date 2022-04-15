# Projet Dev

Bienvenue sur le github de notre projet de développement.

Notre projet est une application codé en flutter. Elle permet de générer des parcours fait en vélo ou à moto, puis de les partager sous différentes portés (public/protégé/privé). Il est possible de pouvoir ajouter et supprimer des amis. Vous pouvez consulter les details de vos parcours passé. A tout moment dans vos paramètres vous pouvez modifier votre pseudo/mot de passe/email/et objectif. En effet un objectif hebdomadaire est present pour chaque utilisateur et un classement est établie en fonction de l'utilisateur qui à parcouru le plus de km dans la semaine.

### IMPORTANT:

For projects with Firestore integration, you must first run the following commands to ensure the project compiles:

```
flutter pub get
flutter packages pub run build_runner build --delete-conflicting-outputs
```

This command creates the generated files that parse each Record from Firestore into a schema object.

### Getting started continued:

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
