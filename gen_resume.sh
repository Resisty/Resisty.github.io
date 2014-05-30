#!/usr/bin/env bash
set -e

command -v pandoc >/dev/null 2>&1 || { echo >&2 "Could not find pandoc. Please make sure it is installed and try again." ; exit 1; }

if [ ! -f style.css ] || [ ! -f resume.md ] || [ ! -f header.md ] || [ ! -f index.html ]
then
	echo >&2 "Could not find index page, style sheet, header markdown, or resume markdown.
	Make sure they both exist and try again!"
	exit 1
fi

cp style.css resume.md header.md index.html /var/www/html/resisty/
pandoc -S -o resume.html header.md resume.md
cp resume.html /var/www/html/resisty/

command -v wkhtmltopdf >/dev/null 2>&1 || { echo >&2 "Could not find wkhtmltopdf. Please make sure it is installed and try again." ; exit 2; }

if [ ! -f resume.html ] 
then
	echo >&2 "Could not find resume.html.
	Make sure it was generated properly and try again!"
	exit 2
fi

wkhtmltopdf index.html resume.pdf
cp resume.pdf /var/www/html/resisty/
chmod -R o+r /var/www/html/resisty
