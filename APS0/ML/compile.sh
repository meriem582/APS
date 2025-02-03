#!/bin/bash

set -e  # Stoppe le script si une commande échoue

echo "Génération des fichiers lexer.ml et parser.ml..."
ocamllex lexer.mll

if ! ocamlyacc parser.mly; then
    echo "Erreur lors de la génération de parser.ml et parser.mli"
    exit 1
fi

echo "Compilation des fichiers..."
ocamlc -c ast.ml
ocamlc -c parser.mli
ocamlc -c parser.ml
ocamlc -c lexer.ml
ocamlc -c eval.ml
ocamlc -c main.ml
ocamlc -o aps0_interpreter lexer.cmo parser.cmo ast.cmo eval.cmo main.cmo

echo "Compilation terminée avec succès !"

for file in Samples/*.aps
do
    echo "$file :"
    
    # Exécute l'interpréteur et récupère la sortie
    res=$(./aps0_interpreter "$file")
    
    # Récupère toutes les valeurs après chaque ECHO dans le fichier de test
    expected_values=($(grep -oP '(?<=ECHO )[-0-9]+' "$file"))
    
    # Récupère toutes les valeurs numériques affichées par l'interpréteur
    result_values=($(echo "$res" | grep -oE '[-0-9]+'))

    # Vérifie si les deux listes de valeurs correspondent
    if [[ "${expected_values[*]}" == "${result_values[*]}" ]]; then
        echo -e "\033[32m Evaluation OK. \033[0m"
    else
        echo -e "\033[31m Evaluation error! \033[0m"
        echo "Expected: ${expected_values[*]}"
        echo "Got: ${result_values[*]}"
    fi
done
