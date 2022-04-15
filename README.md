# THEO'FILE TRACKER

Bienvenue sur le github de notre projet de développement.

Notre projet est une application codé en Flutter. Elle permet de générer des parcours fait en vélo ou à moto, puis de les partager sous différentes portées (public/protégé/privé). Il est possible de pouvoir ajouter et supprimer des amis. Vous pouvez consulter les details de vos parcours passés. A tout moment dans vos paramètres vous pouvez modifier votre pseudo/mot de passe/email/et objectif. En effet un objectif hebdomadaire est présent pour chaque utilisateur et un classement est établi en fonction de l'utilisateur qui à parcouru le plus de km dans la semaine.

Projet réalisé par Quentin Juvet | Thomas Gaule | Célian Frasca

## INSTALLATION SUR TELEPHONE ANDROID

1- Se rendre sur le lien envoyé par mail à partir de votre téléphone
![image](https://user-images.githubusercontent.com/74650298/163629889-92bb6d94-f2c2-4e0e-a1dd-fe4f4e4adb3e.png)

2- Connectez vous avec l'adresse mail sur laquelle vous avez recu le mail

3- Télecharger l'application

4- Accepter, si l'on vous le demande les sources inconnues

5- Lancer l'application

## IMPORTANT

Pour les projets avec une intégration Firestore, vous devez d'abord lancer ces commandes afin de s'assurer que le projet compile:

```
flutter pub get
flutter packages pub run build_runner build --delete-conflicting-outputs
```

Cette commande crée les fichiers générés qui analysent chaque enregistrement de Firestore dans un objet de schéma.

## INSTALLATION SUR EMULATEUR

1- Installer les extensions Dart | Flutter | Code Runner sur Visual Studio Code

2- Installer Android Studio et Ajouter un émulateur Android (Tuto: https://devstory.net/10413/configurer-android-emulator-en-android-studio)

3- Ouvrez un émulateur Android

4- Ecrivez 
```
flutter run 
```
Dans le terminal de votre projet

## DROIT

Aucune modification et réappropriation de l'application n'est autorisé sans l'accord des créateurs
