#!/usr/bin/env bash
set -e

command -v pandoc >/dev/null 2>&1 || { echo >&2 "Could not find pandoc. Please make sure it is installed and try again." ; exit 1; }

if [ ! -d resume ] || [ ! -d css ]
then
	echo >&2 "Could not find resume or could not find the css directory. Check your repository."
	exit 1
fi

if [ ! -f index.haml ] 
then
	echo >&2 "Could not find index.haml. This means something went very wrong with the repository at some point."
	exit 1
fi

command -v gem >/dev/null 2>&1 || apt-get install -y ruby
command -v haml >/dev/null 2>&1 || gem install haml
haml index.haml > index.html
cp -r css index.html /var/www/html

cd resume
if [ ! -f style.css ] || [ ! -f resume.md ] || [ ! -f header.md ] || [ ! -f index.html ]
then
	echo >&2 "Could not find index page, style sheet, header markdown, or resume markdown.
	Make sure they all exist and try again!"
	exit 1
fi

if [ ! -d /var/www/html/resume ]
then
	mkdir -p /var/www/html/resume
	chmod 755 /var/www/html/resume
fi

cp style.css resume.md header.md index.html /var/www/html/resume/
pandoc -S -o resume.html header.md resume.md
cp resume.html /var/www/html/resume/

command -v wkhtmltopdf >/dev/null 2>&1 || { echo >&2 "Could not find wkhtmltopdf. Please make sure it is installed and try again." ; exit 2; }

if [ ! -f resume.html ] 
then
	echo >&2 "Could not find resume.html.
	Make sure it was generated properly and try again!"
	exit 2
fi

xvfb-run -a -s "-screen 0 640x480x16" wkhtmltopdf index.html resume.pdf
mv resume.pdf /var/www/html/resume/
chmod -R o+r /var/www/html
