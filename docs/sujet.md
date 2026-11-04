# La Pioche : Projet solo 2

## Contexte

La Pioche est une ludothèque associative qui prête des jeux de société à ses adhérent·es. Un premier développeur a écrit l'API qui gère les jeux, les adhérent·es et les emprunts, ainsi qu'un début d'application web qui l'utilise, puis a quitté l'équipe. C'est à vous de reprendre son travail.

Le projet est individuel et dure une semaine.

## Objectifs

- reprendre un projet existant, composé d'un back end Vapor et d'un front end web JS Vanilla, et le comprendre avant de le modifier ;
- corriger les anomalies signalées par l'équipe ;
- ajouter de nouvelles routes sur le back end sans casser l'existant, en vous appuyant sur les tests unitaires ;
- intégrer ces routes dans le front end existant, avec ses propres tests ;
- en bonus, sécuriser l'application avec une authentification et habiller le front avec une bibliothèque de design.

## Déroulé

Le `README` explique comment lancer chaque partie du projet et comment vérifier son travail. Le backlog (`backlog.md`) détaille chaque anomalie et chaque fonctionnalité, côté back end comme côté front end. Ce sujet précise l'ordre du travail et les règles à respecter.

### Phase 1 : prise en main

1. Lisez le `README` en entier avant de lancer quoi que ce soit : c'est lui qui explique comment lancer l'API, le front et les tests.
2. Suivez ses instructions pour lancer les tests du back end. Quatre tests échouent dès le départ : ils révèlent les anomalies à corriger.
3. Suivez-les pour lancer l'API, puis le front : les deux doivent tourner en même temps. Ouvrez le front dans votre navigateur et utilisez-le : créez quelques jeux et adhérent·es, empruntez un jeu.
4. Parcourez le code : côté back end les dossiers `Models/`, `Migrations/`, `DTOs/` et `Controllers/`, côté front end `index.html`, `config.js`, `api.js` et `app.js`.
5. Ouvrez la documentation Swagger de l'API (l'adresse est dans le `README`). Elle décrit chaque route, y compris celles que vous ajouterez en phase 3, avec des exemples et les codes de réponse attendus.
6. Essayez chaque route existante avec le bouton « Try it out » de Swagger, ou avec `curl`, et comparez le comportement observé à celui décrit dans la documentation et à celui du front. Notez ce qui vous paraît étrange.

### Phase 2 : corrections

Le fichier `backlog.md` liste les anomalies signalées. Quatre tests de la suite échouent au départ : chacun met en évidence l'une d'elles. Pour chaque anomalie :

1. repérez le test qui échoue et comprenez ce qu'il attend ;
2. cherchez la cause dans le code, puis corrigez-la ;
3. vérifiez que le test passe et que les autres restent au vert ;
4. commitez la correction (voir « Historique git » dans les conventions).

### Phase 3 : nouvelles routes

Le même fichier décrit les fonctionnalités à ajouter, à traiter dans l'ordre. Les tests de ces fonctionnalités n'existent pas : c'est à vous de les écrire. Chaque route doit être livrée avec ses tests, en couvrant le cas nominal et les cas d'erreur.

### Phase 3 : nouvelles routes sur le back end

Le backlog décrit, dans l'ordre, les fonctionnalités à ajouter : pour chacune, la partie « Back end » indique la route à créer. Les tests de ces routes n'existent pas : c'est à vous de les écrire. Chaque route est livrée avec ses tests, qui couvrent le cas nominal et les cas d'erreur. La documentation Swagger décrit déjà ces routes : servez-vous-en comme référence du comportement attendu.

### Phase 4 : intégration dans le front end

Le front end existe déjà : il sait lister et créer des jeux et des adhérent·es, et emprunter un jeu. Il ne contient aucune indication sur ce qu'il reste à faire. Lisez son code pour comprendre comment il est organisé, puis intégrez les fonctionnalités du backlog : pour chacune, la partie « Front end » indique ce que l'utilisateur·rice doit pouvoir faire. Chaque fonctionnalité du front est livrée avec ses tests.

### Phase 5 : bonus (facultatif)

Si le reste du backlog est terminé, le backlog propose deux bonus indépendants : `BONUS-01`, une authentification sur le back end et le front end, et `BONUS-02`, l'intégration d'une bibliothèque de design dans le front end. Ils suivent les mêmes règles que les fonctionnalités : code et tests dans le même commit.

## Règles métier à respecter

- un jeu est disponible s'il n'a aucun emprunt sans date de retour effective ; la disponibilité est calculée, jamais stockée ;
- la durée d'un emprunt est de 14 jours, calculés avec `Calendar` (grégorien, UTC) en ajoutant 14 jours, et non un nombre de secondes ;
- un jeu déjà emprunté ne peut pas être emprunté une seconde fois (`409 Conflict`).

## Conventions du projet

### Back end

- noms en anglais, conformes aux Swift API Design Guidelines ;
- `async`/`await` uniquement ;
- les corps de requête et de réponse passent par des DTOs, jamais par les modèles ;
- si `BONUS-01` est traité : aucun mot de passe en clair, ni stocké ni renvoyé, et aucun secret écrit en dur dans le code hors valeur de développement ;
- validation des entrées avec `Validatable` ;
- erreurs levées avec `Abort` et un code HTTP explicite ;
- dates au format ISO 8601.

### Front end

- HTML, CSS et JavaScript uniquement : pas de framework, pas de bibliothèque, pas d'outil de build. Seule exception, `BONUS-02` : une bibliothèque CSS chargée par CDN ;
- chaque route de l'API utilisée a sa fonction dans `api.js` ; les écrans n'appellent jamais `fetch` directement ;
- l'adresse de l'API se lit dans `config.js` et nulle part ailleurs ;
- les données reçues de l'API (titres, noms, e-mails) s'insèrent dans la page comme du texte, jamais comme du HTML ;
- tout ce qui s'affiche est en français et compréhensible par une personne qui ne connaît pas l'API, erreurs comprises : l'API répond en anglais, l'interface non ;
- une liste vide se signale par une phrase qui dit quoi faire ensuite, pas par un écran blanc ;
- l'écran se met à jour après chaque action, sans rechargement manuel ;
- une action qui échoue affiche pourquoi, sans fermer le formulaire.

### Tests

- chaque route du back end et chaque fonctionnalité du front end est livrée avec ses tests, qui couvrent le cas nominal et les cas d'erreur ;
- chaque nouvelle fonction de `api.js` est couverte par un test ;
- le nom d'un test est en anglais et décrit le comportement attendu, comme `testBorrowUnknownGameReturnsNotFound` côté back end ;
- tous les tests, les vôtres comme ceux fournis, passent avant chaque `git push` (voir les étapes de vérification du `README`).

### Historique git

- un commit par modification cohérente : une anomalie, une route, une fonctionnalité du front end ;
- le code et ses tests sont dans le même commit, avec un message explicite.

## Évaluation

Vous serez évalué·es sur :

- la correction effective des anomalies : la suite de tests fournie doit passer entièrement ;
- la qualité et l'exhaustivité des tests des routes ajoutées ;
- l'absence de régression sur l'existant ;
- l'intégration dans le front end : fonctionnement de chaque fonctionnalité, clarté des messages et des états vides ;
- la qualité et l'exhaustivité des tests du front end (cas nominal et cas d'erreur) ;
- le respect des conventions du projet ;
- en bonus, la qualité de l'authentification (routes protégées, tests des refus) et de l'intégration de la bibliothèque de design ;
- la lisibilité de l'historique git.
