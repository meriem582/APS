## 📁 Structure du projet partie APS2

- **ast.ml** : Structures abstraites du programme.
- **lexer.mll** : Analyse lexicale (OCamllex).
- **parser.mly** : Analyse syntaxique (Ocamlyacc).
- **prologTerm.ml** : Génération des termes Prolog.
- **eval.ml** : Évaluation des programmes.
- **mainTyper.ml** : Analyse du typage.
- **mainEval.ml** : Évaluation des programmes.
- **typer.pl** : Vérification du typage en Prolog.

## 🛠️ Prérequis

- OCaml (ocamlc, ocamllex, ocamlyacc)
- SWI-Prolog (swipl)

## ▶️ Compilation et Exécution

### 🔍Exécution d'interpréteur:

```bash
./compileAst.sh [fichier.aps]
```
### Où bien : (Pour lancer l'exécution d'interpréteur sur tout les fichiers aps dans le répertoire Samples)

```bash
./compileAst.sh
```
- Les AST sont enregistrés dans `AST_RESULTAT/`.

### 🔍 Analyse du typage :

```bash
./compileTyper.sh [fichier.aps]
```
### Où bien : (Pour lancer l'analyse du typage sur tout les fichiers aps dans le répertoire Samples)

```bash
./compileTyper.sh
```

- Le résultat de l'analyse de typage sont enregistrés dans `TYPAGE_RESULTAT/`.

### 📊 Évaluation des programmes :

```bash
./compileEval.sh [fichier.aps]
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
- **TYPAGE_RESULTAT/** : AST des programmes.
- **EVAL_RESULTAT/** : Résultat de l'évaluation.

## 📌 Exemple d'utilisation

### ▶️ Ast :

1. Placez vos fichiers APS2 dans le dossier `Samples/APS2`.
2. Lancez :

```bash
./compileAst.sh Samples/APS2/test1_2.aps
```

3. Consultez le résultat dans `AST_RESULTAT/`.

### ▶️ Typer :

1. Placez vos fichiers APS2 dans le dossier `Samples/APS2`.
2. Lancez :

```bash
./compileTyper.sh Samples/APS2/test1_2.aps
```

3. Consultez le résultat dans `TYPAGE_RESULTAT/`.

### ▶️ Evaluateur :

1. Placez vos fichiers APS2 dans le dossier `Samples/APS2`.
2. Lancez :

```bash
./compileEval.sh Samples/APS2/test1_2.aps
```

3. Consultez le résultat dans `EVAL_RESULTAT/`.

## 📣 Remarque

En cas de problèmes :

- Vérifiez la présence des fichiers APS2 dans `Samples/APS2`.
- Assurez-vous que OCaml et SWI-Prolog sont installés.
