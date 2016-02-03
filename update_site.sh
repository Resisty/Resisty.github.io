#!/usr/bin/env bash
set -e

cd $(dirname $0)

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

cd ../measurements
if [ ! -f style.css ] || [ ! -f index.html ] || [ ! -f measurements.html ]
then
	echo >&2 "Could not find index page, measurements page, or style sheet.
	Make sure they all exist and try again!"
	exit 1
fi

if [ ! -d /var/www/html/measurements ]
then
	mkdir -p /var/www/html/measurements
	chmod 755 /var/www/html/measurements
fi
cp style.css index.html measurements.html /var/www/html/measurements/

cd ../CanBobiSpendThisMoney
if [ ! -f style.css ] || [ ! -f index.html ] || [ ! -f CanBobiSpendThisMoney.html ]
then
	echo >&2 "Could not find index page, CanBobiSpendThisMoney page, or style sheet.
	Make sure they all exist and try again!"
	exit 1
fi

if [ ! -d /var/www/html/CanBobiSpendThisMoney ]
then
	mkdir -p /var/www/html/CanBobiSpendThisMoney
	chmod 755 /var/www/html/CanBobiSpendThisMoney
fi
cp style.css index.html CanBobiSpendThisMoney.html /var/www/html/CanBobiSpendThisMoney/

cd ../jeff-existential-crisis-level
if [ ! -f style.css ] || [ ! -f index.html ] || [ ! -f jeff-existential-crisis-level.html ]
then
	echo >&2 "Could not find index page, jeff-existential-crisis-level page, or style sheet.
	Make sure they all exist and try again!"
	exit 1
fi

if [ ! -d /var/www/html/jeff-existential-crisis-level ]
then
	mkdir -p /var/www/html/jeff-existential-crisis-level
	chmod 755 /var/www/html/jeff-existential-crisis-level
fi
cp style.css index.html jeff-existential-crisis-level.html /var/www/html/jeff-existential-crisis-level/

cd ../characters
if [ ! -f style.css ] || [ ! -f index.html ]
then
	echo >&2 "Could not find index page or style sheet.
	Make sure they all exist and try again!"
	exit 1
fi

if [ ! -d /var/www/html/characters ]
then
	mkdir -p /var/www/html/characters
	chmod 755 /var/www/html/characters
fi
cp style.css index.html /var/www/html/characters/

chmod -R o+r /var/www/html
