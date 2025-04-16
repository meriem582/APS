# Rapport de Projet APS

## Avancement
Nous avons réalisé les APS suivants :  
- APS0  
- APS1  
- APS1a  
- APS2  
- APS3 (partiellement)  

Pour l'APS3, nous avons commencé l'implémentation du typer, mais mais vu qu'on a pas fait de cours dessus, nous n'avons pas pu approfondir. Seuls quelques tests ont permis de vérifier que certains cas ne sont pas typables.

## État des lieux des fonctionnalités
- **Fonctionnel** :  
  - APS0, APS1, APS1a et APS2 sont entièrement opérationnels.  
- **Non fonctionnel** :  
  - APS3 (typer) : incomplet, avec des limitations identifiées.  

## Choix d’implémentation — APS0 (évaluateur)

Pour APS0, nous avons suivie la sémantique fonctionnelle qu'on a vu en cours.
L’environnement est un Map immuable de noms vers des valeurs (int, fonctions, ou fermetures récursives).
Il n’y a pas de mémoire séparée comme dans aps1 et 2 donc les variables constantes sont directement évaluées, et les fonctions sont fermées sur leur environnement de définition.
Les primitives (add, sub, etc.) sont traitées à part via une fonction eval_primitive.
Le flux de sortie est une liste de valeurs, qui est alimentée à chaque ECHO. Cependant, en raison de la syntaxe d'APS0, qui interdit la succession de plusieurs ECHO, le programme s'arrêtera après le premier ECHO.

## Choix d’implémentation — APS1 (évaluateur)

Dans APS1a, on introduit une mémoire séparée pour pouvoir modifier les variables.
Chaque variable déclarée avec VAR est associée à une adresse mémoire, et les affectations (SET) modifient la valeur à cette adresse.
La mémoire est représentée comme un Hashtbl d’adresses vers des entiers (int option).
L’environnement (toujours un Hashtbl) contient donc des adresses (InA) au lieu de valeurs directes.
Cette séparation permet de représenter des variables modifiables, contrairement à APS0.
Le flux de sortie reste une liste de valeurs (sortie), comme en APS0.

## Choix d’implémentation — APS1a (évaluateur)

En plus de la mémoire introduite en APS1, APS1a apporte le passage par adresse dans les appels de procédures.
On distingue deux types de paramètres de procédure :

- **ArgProc** pour un passage par valeur (évaluation de l'expression, comme en APS1),

- **ArgProcVar** pour un passage par référence, où on passe l’adresse d’une variable existante.

Cela nous a poussés à adapter ASTCall que lors d’un appel, si un paramètre est par adresse, on récupère directement l’adresse de la variable (InA) au lieu de sa valeur.
Les affectations faites à l’intérieur de la procédure sont alors visibles à l’extérieur, sans copier l’environnement.
La mémoire reste inchangée (même structure que APS1 et 0
) et le flux de sortie reste une liste de valeur.


## Choix d’implémentation — APS2 (évaluateur)

**Gestion de la mémoire**
Dans APS2, on conserve l'allocation dynamique de mémoire comme dans APS1a, utilisant une table de hachage (Hashtbl) pour associer des adresses mémoire à des valeurs. Et dans APS2 l'un des ajouts majeurs est la fonction **allocn**, qui permet d'allouer un bloc contigu de mémoire pour gérer efficacement des tableaux.

**Fonction allocn**
La fonction allocn alloue un bloc de mémoire de taille size, en vérifiant d'abord si l'espace est disponible à partir d'une adresse donnée. Si l'espace est libre, elle réserve les adresses et les initialise à None. Cette fonction est essentielle pour la gestion des tableaux, où des adresses contiguës sont nécessaires pour stocker les éléments.
Ce choix d'implementation permet d'allouer dynamiquement un bloc contigu de mémoire pour les tableaux, permet aussi de gérer efficacement des structures comme des tableaux ou des matrices sans avoir à allouer chaque élément individuellement.

 **Complexité** : La recherche d'un espace libre pour allouer un bloc nécessite de vérifier si les adresses sont déjà utilisées, ce qui peut rendre l'allocation plus coûteuse en cas de fragmentation.

Dans APS2, le type InB a été introduit pour représenter les blocs mémoire, tandis que InA continue de représenter les adresses. Cela permet de gérer plus efficacement les structures de données comme les tableaux, où chaque élément peut être situé à une adresse contiguë.

Le flux de sortie reste une liste de valeurs, mais avec la gestion des tableaux et des blocs mémoire, les résultats peuvent désormais inclure des structures complexes allouées dynamiquement, comme des tableaux, ce qui permet de mieux suivre l'évolution des programmes dans des structures plus complexes.

## Extensions par rapport à la spécification
Nous avons strictement suivi :  
- La syntaxe décrite dans le formulaire fourni par l'enseignant.  
- Les conventions de test vues en cours. 

# Évolution de la syntaxe dans les différentes versions d’APS

## APS0

Pour APS0, nous avons commencé notre projet à partir du squelette fourni par le chargé de cours ou de TME. Nous avons ensuite suivi la grammaire présentée en cours, en nous basant également sur le formulaire fourni. Cette version posait les bases de la syntaxe, avec les éléments fondamentaux du langage.

---

## APS1

En plus de la syntaxe d’APS0, la version APS1 introduit de nouveaux éléments.

Tout d’abord, un nouveau type `block` est défini, qui encapsule une suite de commandes et s’écrit sous la forme `ASTBlock of cmds`.

Le type `cmds` est étendu pour permettre l’enchaînement de commandes à l’aide du constructeur `ASTStatCMDS of stat * cmds`.

Un nouveau type de base, `TVoid`, est également introduit dans le type `base_type`, permettant de représenter l’absence de type de retour, notamment pour les procédures.

Le type `def` est enrichi pour prendre en charge les définitions de variables (`ASTVar of string * typ`), de procédures (`ASTProc of string * arg list * block`) et de procédures récursives (`ASTProcRec of string * arg list * block`).

Enfin, le type `stat`, qui décrit les instructions, s’enrichit des instructions suivantes :
- `ASTSet of string * expr`, pour affecter une valeur à une variable ;
- `ASTIfStat of expr * block * block`, pour les structures conditionnelles pour les blocks;
- `ASTWhile of expr * block`, pour les boucles ;
- `ASTCall of string * expr list`, pour les appels de procédures.

---

## APS1a

La version APS1a vient compléter et corrigé les problème rencontré dans APS1 tel que le passage de teste de typage des variable qui stockent/ déclare des fonctions.

Un nouveau type `exprProc` est défini, permettant de distinguer une expression classique (`ASTExpr of expr`) d’un appel à une procédure (`ASTExprProc of string`).

Le type `def` est également adapté pour prendre en compte ce nouveau type d’argument. Les définitions de procédures (`ASTProc`) et de procédures récursives (`ASTProcRec`) acceptent désormais une liste d’arguments de type `argProc`.

---

## APS2

Avec APS2, la syntaxe devient plus riche et permet notamment la gestion des tableaux.

Le type `stat` est modifié : l’instruction `ASTSet` ne prend plus une simple chaîne de caractères, mais un `lval`, qui peut être une variable ou une case dans un tableau.

Le type `lval` permet donc de représenter soit une variable (`ASTLvalIdent of string`), soit un accès à un élément d’un tableau (`ASTLvalNth of lval * expr`).

Le type `expr` est étendu avec de nouvelles expressions spécifiques aux tableaux :
- `ASTAlloc of expr`, pour allouer un tableau de taille donnée ;
- `ASTLen of expr`, pour obtenir la longueur d’un tableau ;
- `ASTNth of expr * expr`, pour accéder à un élément d’un tableau ;
- `ASTVset of expr * expr * expr`, pour modifier une case d’un tableau.

Enfin, un nouveau type `ASTVec of typ` est ajouté au type `typ`, afin de représenter les types vecteurs (ou tableaux typés).

---

## APS3

La version APS3 introduit la notion de fonction avec retour de valeur.

Un nouveau type `ret` est défini, permettant d’exprimer une instruction de retour avec une valeur (`ASTRet of expr`).

Le type `cmds` est enrichi avec un nouveau constructeur `ASTRetCMDS of ret`, afin de permettre le retour d’une valeur dans une séquence de commandes.

Le type `def` s’étoffe également avec deux nouvelles formes de définitions :
- `ASTFunDec of string * typ * argProc list * block`, pour les fonctions simples ;
- `ASTFunRecDec of string * typ * argProc list * block`, pour les fonctions récursives.

Ces ajouts marquent la transition du langage vers un paradigme plus fonctionnel, en plus de l’impératif introduit précédemment.

---

Cette progression illustre l’enrichissement progressif de la grammaire APS à chaque étape du projet, en partant d’un noyau impératif simple jusqu’à un langage complet avec fonctions, tableaux, et valeurs de retour.


## Typer
Tout ce qui concerne le typage et ses règles est déjà expliqué dans le fichier Typer.pl, où chaque règle est commentée. Cela permet d’alléger le rapport et d’éviter les redondances

## Répartition du travail (binôme)
- **APS0 & APS1** :  
  Travail collaboratif en pair programming, avec soumission commune à chaque séance.  
- **APS1a, APS2 & APS3** :  
  - *Meriem Benaissa* :  
    AST, Parser, Lexer, PrologTerm, et typer.pl (partie typer).  
  - *Youra Ahmed* :  
    Implémentation de l'évaluateur.  

## Sources d'inspiration
1. **IA** :  
   - ChatGPT pour résoudre des problèmes ponctuels et générer des idées de scripts de test automatisés.  
2. **Projets externes** :  
   - Dépôt GitHub consulté (à titre informatif) : [Sorbonne_APS](https://github.com/valeeraZ/Sorbonne_APS).  
3. **Collaborateurs** :  
   Aucune collaboration directe avec d'autres groupes.  
