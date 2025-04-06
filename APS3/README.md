## 📁 Structure du projet partie APS3

- **ast.ml** : Structures abstraites du programme.
- **lexer.mll** : Analyse lexicale (OCamllex).
- **parser.mly** : Analyse syntaxique (Ocamlyacc).
- **prologterm.ml** : Génération des termes Prolog.
- **eval.ml** : Évaluation des programmes.
- **mainTyper.ml** : Analyse du typage.
- **mainEval.ml** : Évaluation des programmes.
- **typer.pl** : Vérification du typage en Prolog.

## 🛠️ Prérequis

- OCaml (ocamlc, ocamllex, ocamlyacc)
- SWI-Prolog (swipl)

## ▶️ Compilation et Exécution

### 🔍 Analyse du typage :

```bash
./compileTyper.sh [Samples/APS3/fichier.aps]
```
### Où bien : (Pour lancer l'analyse du typage sur tout les fichiers aps dans le répertoire Samples)

```bash
./compileTyper.sh
```

- Les AST sont enregistrés dans `AST_RESULTAT/`.

### 📊 Évaluation des programmes :

```bash
./compileEval.sh [Samples/APS3/fichier.aps]
```
### Où bien : (Pour lancer l'évaluation des programmes sur tout les fichiers aps dans le répertoire Samples)

```bash
./compileEval.sh
```

- Les résultats sont enregistrés dans `EVAL_RESULTAT/`.

### 🧹 Nettoyer les fichiers générés :

```bash
./clean.sh
```

## 📂 Organisation des résultats

- **AST_RESULTAT/** : AST des programmes.
- **EVAL_RESULTAT/** : Résultat de l'évaluation.

## 📌 Exemple d'utilisation

1. Placez vos fichiers APS3 dans le dossier `Samples/APS3`.
2. Lancez :

```bash
./compileTyper.sh Samples/APS3/test1_3.aps
```

3. Consultez le résultat dans `AST_RESULTAT/`.

## 📣 Remarque

En cas de problèmes :

- Vérifiez la présence des fichiers APS3 dans `Samples/APS3`.
- Assurez-vous que OCaml et SWI-Prolog sont installés.
