#!/usr/bin/env bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $DIR

command -v gem >/dev/null 2>&1 || sudo apt-get install -y ruby
command -v haml >/dev/null 2>&1 || sudo gem install haml
command -v pandoc >/dev/null 2>&1 || sudo apt-get install -y pandoc
command -v wkhtmltopdf  >/dev/null 2>&1 || sudo apt-get install -y wkhtmltopdf
command -v xvfb-run  >/dev/null 2>&1 || sudo apt-get install -y xvfb

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

haml index.haml > index.html

cd resume
if [ ! -f style.css ] || [ ! -f resume.md ] || [ ! -f header.md ] || [ ! -f index.html ]
then
	echo >&2 "Could not find index page, style sheet, header markdown, or resume markdown.
	Make sure they all exist and try again!"
	exit 1
fi

pandoc -S -o resume.html header.md resume.md


if [ ! -f resume.html ] 
then
	echo >&2 "Could not find resume.html.
	Make sure it was generated properly and try again!"
	exit 2
fi

xvfb-run -a -s "-screen 0 640x480x16" wkhtmltopdf index.html resume.pdf
aws s3 cp --recursive $DIR s3://brianauron.info
