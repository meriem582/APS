#!/bin/bash

#fichier egalement travailler avec chatGPT pour que je puisse automatiser 
#la compilation des mes fichiers egalement de lancer directement l'executable qui est Eval

#!/bin/bash

# 🚀 Fichier amélioré pour compiler et exécuter un ou plusieurs fichiers
set -e  # Arrêter le script en cas d'erreur

echo "🚀 Compilation et génération des fichiers nécessaires..."

 # Création du dossier de sortie si nécessaire
output_dir="EVAL_RESULTAT"
mkdir -p "$output_dir"

# Génération des fichiers lexer et parser
ocamllex lexer.mll
if ! ocamlyacc parser.mly; then
    echo "Erreur lors de la génération de parser.ml et parser.mli"
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

# Vérifier si un fichier a été donné en argument
if [ "$#" -gt 0 ]; then
    echo "🔍 Exécution des fichiers spécifiés en argument..."
    for file in "$@"; do
        if [ -f "$file" ]; then
            filename=$(basename -- "$file")
            output_file="$output_dir/eval_${filename%.*}.txt"  # Stocker dans EVAL_RESULTAT/
            
            echo "📄 Traitement du fichier : $file"
            echo " "
            ./mainEval "$file" | tee "$output_file"
            echo " "
            echo " "
            echo "✅ Résultat de l'évaluation de $file est affiché et sauvegardé dans $output_file"
            echo ""
        else
            echo "⚠️  Le fichier '$file' n'existe pas."
        fi
    done
else
    # Si aucun fichier n'est donné, exécuter tous les fichiers dans Samples/
    if [ ! -d "Samples" ]; then
        echo "⚠️  Le dossier 'Samples/' n'existe pas. Créez-le et ajoutez des fichiers .aps."
        exit 1
    fi

    echo "🔍 Recherche des fichiers .aps dans le dossier Samples/..."
    found=0
    for file in Samples/*/*.aps; do
        if [ -f "$file" ]; then
            found=1
            filename=$(basename -- "$file")
            output_file="$output_dir/eval_${filename%.*}.txt"  # Stocker dans EVAL_RESULTAT/            
            echo "📄 Traitement du fichier : $file"
            echo " "
            ./mainEval "$file" | tee "$output_file"
            echo " "
            echo " "
            echo "✅ Résultat de l'évaluation de $file est affiché et sauvegardé dans $output_file"
            echo ""
        fi
    done

    if [ "$found" -eq 0 ]; then
        echo "⚠️  Aucun fichier .aps trouvé dans Samples/"
    fi
fi


