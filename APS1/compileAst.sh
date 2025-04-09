#!/bin/bash

# 🚀 Fichier amélioré pour compiler et exécuter un ou plusieurs fichiers
set -e  # Arrêter le script en cas d'erreur

echo "🚀 Compilation et génération des fichiers nécessaires..."

 # Création du dossier de sortie si nécessaire
output_dir="AST_RESULTAT"
mkdir -p "$output_dir"

# Génération des fichiers lexer et parser
ocamllex lexer.mll
if ! ocamlyacc parser.mly; then
    echo "Erreur lors de la génération de parser.ml et parser.mli"
    exit 1
fi

ocamlc -c ast.ml
ocamlc -c parser.mli
ocamlc -c parser.ml
ocamlc -c lexer.ml
ocamlc -c prologterm.ml
ocamlc -c mainTyper.ml  # Assure-toi que ce fichier est bien compilé

# Linking pour créer l'exécutable mainTyper
ocamlc -o mainTyper ast.cmo parser.cmo lexer.cmo prologterm.cmo mainTyper.cmo


echo "✅ Compilation terminée avec succès !"

# Vérifier si des fichiers sont passés en argument
if [ "$#" -gt 0 ]; then
    echo "🔍 Traitement des fichiers spécifiés en argument..."
    for file in "$@"; do
        if [ -f "$file" ]; then
            filename=$(basename -- "$file")
            base="${filename%.*}"
            output_file="$output_dir/ast_${base}.txt"
            echo "----------------------------------------------------------------------------------------------------------------------------------------------------------------"

            echo "📄 Traitement du fichier : $file"
            echo ""

            # Générer l'AST avec mainTyper et l'afficher
            ./mainTyper "$file" > "$output_file"

             # Afficher l'AST dans la console
            echo "🔍 Affichage de l'AST pour le fichier : $file "
            echo ""
            cat "$output_file"
            echo ""
            echo "----------------------------------------------------------------------------------------------------------------------------------------------------------------"
            echo ""
            echo ""

        else
            echo "⚠️ Le fichier '$file' n'existe pas."
        fi
    done
else
    # Si aucun fichier n'est donné, exécuter tous les fichiers .aps dans Samples/
    if [ ! -d "Samples" ]; then
        echo "⚠️ Le dossier 'Samples/' n'existe pas. Créez-le et ajoutez des fichiers .aps."
        exit 1
    fi

    echo "🔍 Recherche des fichiers .aps dans le dossier Samples/..."
    found=0
    for file in Samples/*/*.aps; do
        if [ -f "$file" ]; then
            filename=$(basename -- "$file")
            base="${filename%.*}"
            output_file="$output_dir/ast_${base}.txt"
            echo "----------------------------------------------------------------------------------------------------------------------------------------------------------------"
            
            echo "📄 Traitement du fichier : $file"
            echo ""

            # Générer l'AST avec mainTyper et l'afficher
            ./mainTyper "$file" > "$output_file"

            # Afficher l'AST dans la console
            echo "🔍 Affichage de l'AST pour le fichier : $file "
            echo ""
            cat "$output_file"
            echo ""
            echo "----------------------------------------------------------------------------------------------------------------------------------------------------------------"
            echo ""
            echo ""

            found=1
        fi
    done

    if [ "$found" -eq 0 ]; then
        echo "⚠️ Aucun fichier .aps trouvé dans Samples/"
    fi
fi
