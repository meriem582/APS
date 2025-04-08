#!/bin/bash

# 🚀 Script pour compiler et exécuter automatiquement les tests APS0 et APS1

set -e  # Arrêter le script en cas d'erreur

echo "🚀 Compilation et génération des fichiers nécessaires..."

# Création du dossier de sortie si nécessaire
output_dir="EVAL_RESULTAT"
mkdir -p "$output_dir"

# Génération des fichiers lexer et parser
ocamllex lexer.mll
if ! ocamlyacc parser.mly; then
    echo "❌ Erreur lors de la génération de parser.ml et parser.mli"
    exit 1
fi

# Compilation des fichiers sources
ocamlc -c ast.ml
ocamlc -c parser.mli
ocamlc -c parser.ml
ocamlc -c lexer.ml
ocamlc -c eval.ml
ocamlc -c mainEval.ml

# Linkage et création de l'exécutable
ocamlc -o mainEval ast.cmo parser.cmo lexer.cmo eval.cmo mainEval.cmo

echo "✅ Compilation terminée avec succès !"

# Fonction pour exécuter et enregistrer le résultat
execute_file() {
    local file="$1"
    if [ -f "$file" ]; then
        filename=$(basename -- "$file")
        output_file="$output_dir/eval_${filename%.*}.txt"  # Stocker dans EVAL_RESULTAT/
        
        echo "📄 Traitement du fichier : $file"
        echo " "
        ./mainEval "$file" | tee "$output_file"
        echo " "
        echo "✅ Résultat de l'évaluation de $file est affiché et sauvegardé dans $output_file"
        echo ""
    else
        echo "⚠️  Le fichier '$file' n'existe pas."
    fi
}

# Vérifier si des fichiers sont donnés en argument
if [ "$#" -gt 0 ]; then
    echo "🔍 Exécution des fichiers spécifiés en argument..."
    for file in "$@"; do
        execute_file "$file"
    done
else
    # Si aucun fichier n'est donné, exécuter tous les fichiers dans Samples/APS0 et Samples/APS1
    if [ ! -d "Samples/APS0" ] || [ ! -d "Samples/APS1" ]; then
        echo "⚠️  Les dossiers 'Samples/APS0' ou 'Samples/APS1' n'existent pas. Ajoutez des fichiers .aps."
        exit 1
    fi

    echo "🔍 Recherche des fichiers .aps dans Samples/APS0 et Samples/APS1..."
    found=0
    for folder in Samples/APS0 Samples/APS1; do
        for file in "$folder"/*.aps; do
            if [ -f "$file" ]; then
                found=1
                execute_file "$file"
            fi
        done
    done

    if [ "$found" -eq 0 ]; then
        echo "⚠️  Aucun fichier .aps trouvé dans Samples/APS0 ou Samples/APS1."
    fi
fi
