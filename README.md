<div align="center">

# 🎲 Festival du Jeu – Application Mobile Bénévole

Une application **iOS** développée pour les bénévoles du Festival du Jeu de Montpellier.

<a rel="license" href="http://creativecommons.org/licenses/by-nc-nd/4.0/">
  <img alt="Creative Commons License" style="border-width:0" 
       src="https://i.creativecommons.org/l/by-nc-nd/4.0/88x31.png" />
</a><br />
Ce projet est sous licence 
<a rel="license" href="http://creativecommons.org/licenses/by-nc-nd/4.0/">
  Creative Commons Attribution - NonCommercial - NoDerivatives 4.0 International
</a>.

---

</div>

## 📋 Sommaire

- [Description](#description)
- [Fonctionnalités](#fonctionnalités)
- [Architecture MVVM](#architecture-mvvm)
- [Technologies Utilisées](#technologies-utilisées)
- [Lancement de l’Application](#lancement-de-lapplication)
- [Contributeurs](#contributeurs)

---

## 🧭 Description

Cette application mobile est dédiée aux **bénévoles** du Festival du Jeu de Montpellier. Elle fait suite à une application web existante, dont elle réutilise le backend, disponible ici :  
🔗 [BenevoleAPP-Back (GitHub)](https://github.com/JiayiHE95/BenevoleAPP-Back)

L'objectif : Offrir une **expérience simple, rapide et informative**, même pour des utilisateurs peu familiers avec la technologie. Cette version mobile **n'inclut pas les fonctionnalités d'administration**, afin de se concentrer exclusivement sur l'expérience des bénévoles.

---

## ✅ Fonctionnalités

### 🔐 Compte bénévole

- Création de compte
- Connexion / Déconnexion
- Consultation et modification du profil

### 📅 Festivals

- Liste des festivals disponibles
- Détails et informations générales
- Réseaux sociaux du festival
- Avis des bénévoles (consulter, créer, modifier, supprimer)

### 📌 Inscriptions & Planning

- Voir les postes disponibles
- Voir les référents par poste
- Consulter les zones de jeux et les notices
- Voir le planning général
- S’inscrire à un poste ou à un créneau "flexible"
- Consulter ses inscriptions
- Valider ou refuser des propositions d’inscription (mode flexible)

### 🔔 Notifications

- Recevoir, consulter, et supprimer ses notifications

### 🏠 Hébergement

- Voir les hébergements proposés
- Proposer un hébergement
- Gérer ses publications

---

## 🧱 Architecture MVVM

L'application suit l’architecture **MVVM (Model – View – ViewModel)**, offrant :

- Séparation claire des responsabilités
- Meilleure maintenabilité
- Extensibilité facilitée

### Exemple MVVM : Liste des inscriptions
> Le ViewModel récupère les données du backend et les formate pour affichage. La View affiche la liste stylisée à l’aide de composants UI réutilisables.

---

## 🧰 Technologies Utilisées

- **Swift** – Langage principal
- **Xcode** – Environnement de développement
- **Node.js** – Backend (réutilisé)
- **PostgreSQL** – Base de données

---

## 🚀 Lancement de l’Application

1. Cloner le projet depuis le dépôt.
2. Ouvrir le projet dans **Xcode**.
3. S’assurer que le backend Node.js est bien en ligne.
4. Lancer l’application sur un simulateur ou un iPhone physique.

> 💡 N’oubliez pas de configurer l’URL du backend dans les ViewModel si nécessaire.

---

## 🤝 Contributeurs

- [**Margot Goudard**](https://github.com/margotgoudard)
- [**Charlène Morchipont**](https://github.com/charleneMrcp)
- [**Jiayi He**](https://github.com/JiayiHE95)
