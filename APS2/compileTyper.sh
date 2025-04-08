#!/bin/bash

# 🚀 Script pour compiler et exécuter automatiquement les fichiers avec typage Prolog
set -e  # Arrêt en cas d'erreur

echo "🚀 Compilation et génération des fichiers nécessaires..."

# Dossiers de sortie
output_dir="AST_RESULTAT"
typer_dir="TYPAGE_RESULTAT"
mkdir -p "$output_dir"
mkdir -p "$typer_dir"

# Génération lexer et parser
ocamllex lexer.mll
if ! ocamlyacc parser.mly; then
    echo "❌ Erreur lors de la génération de parser.ml et parser.mli"
    exit 1
fi

# Compilation
ocamlc -c ast.ml
ocamlc -c parser.mli
ocamlc -c parser.ml
ocamlc -c lexer.ml
ocamlc -c prologterm.ml
ocamlc -c mainTyper.ml

# Linking
ocamlc -o mainTyper ast.cmo parser.cmo lexer.cmo prologterm.cmo mainTyper.cmo

echo "✅ Compilation terminée avec succès !"

# Fonction pour traiter un fichier .aps
process_file() {
    local file="$1"
    local filename=$(basename -- "$file")
    local base="${filename%.*}"
    local output_file="$output_dir/ast_${base}.txt"
    local typer_output_file="$typer_dir/typer_${base}.txt"

    echo "📄 Traitement du fichier : $file"
    echo ""

    # Génération de l'AST (non affichée)
    ./mainTyper "$file" > "$output_file"

    echo "🔍 Passage du contenu à Prolog :"
    typage=$( (cat "$output_file"; echo ".") | swipl -s typer.pl -g main_stdin -t halt)

    # Générer le message de typage
    result_message=""
    if [[ "$typage" == *"void"* ]]; then
        result_message="Résultat: ✅ Bien typé"$'\n'"Typage terminée avec succès."
    elif [[ "$typage" == *"type_error"* ]]; then
        result_message="Résultat: ❌ Erreur de typage !!!"$'\n'"Typage terminée avec échec."
    else
        result_message="Résultat inattendu : $typage"
    fi

    # Affichage + enregistrement dans TYPAGE_RESULTAT/typer_<nom>.txt
    echo "$result_message"
    echo "$result_message" > "$typer_output_file"

    echo ""
}

# Si des fichiers sont passés en argument
if [ "$#" -gt 0 ]; then
    echo "🔍 Exécution des fichiers spécifiés en argument..."
    for file in "$@"; do
        if [ -f "$file" ]; then
            process_file "$file"
        else
            echo "⚠️ Le fichier '$file' n'existe pas."
        fi
    done
else
    # Sinon, exécuter tous les fichiers dans le dossier Samples/
    if [ ! -d "Samples" ]; then
        echo "⚠️ Le dossier 'Samples/' n'existe pas. Créez-le et ajoutez des fichiers .aps."
        exit 1
    fi

    echo "🔍 Recherche des fichiers .aps dans le dossier Samples/..."
    found=0
    for file in Samples/*/*.aps; do
        if [ -f "$file" ]; then
            process_file "$file"
            found=1
        fi
    done

    if [ "$found" -eq 0 ]; then
        echo "⚠️ Aucun fichier .aps trouvé dans Samples/"
    fi
fi
