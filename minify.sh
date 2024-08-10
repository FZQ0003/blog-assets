#!/bin/bash

if [ -z "$PUBLIC_DIR" ]; then
    PUBLIC_DIR="public"
fi

if [ -z "$UTILS_DIR" ]; then
    UTILS_DIR="utils"
fi

case $1 in
    "image")
        shift
        find "$@" -type d | while read dir; do
            echo "Converting PNGs in $dir..."
            mkdir -p "$PUBLIC_DIR/$dir"
            "$UTILS_DIR/magick" --appimage-extract-and-run \
                "$dir/"*.png -format jpg -quality 98 \
                -set filename:base %t -set filename:dir %d \
                "$PUBLIC_DIR/%[filename:dir]/%[filename:base].jpg"
        done
        find "$@" -type f -name "*.jpg" | while read file; do
            echo "Copying JPEG file: $file..."
            mkdir -p "$PUBLIC_DIR/$(dirname "$file")"
            cp "$file" "$PUBLIC_DIR/$file"
        done
        ;;
    "html")
        shift
        mkdir -p "$PUBLIC_DIR"
        echo "Copying dir: $@..."
        cp -r "$@" "$PUBLIC_DIR"
        find "$@" -type f -name "*.html" | while read file; do
            echo "Converting $file..."
            "$UTILS_DIR/minhtml" "$file" \
            --do-not-minify-doctype \
            --ensure-spec-compliant-unquoted-attribute-values \
            --keep-closing-tags --keep-spaces-between-attributes \
            --minify-css --minify-js \
            -o "$PUBLIC_DIR/$file"
        done
        ;;
    *)
        echo "Usage: $0 {image|html} DIR_NAME ..."
        exit 1
        ;;
esac

echo "Done!"
