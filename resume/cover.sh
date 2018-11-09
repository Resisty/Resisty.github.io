pandoc -S -o cover.html coverheader.md cover.md
xvfb-run -a -s "-screen 0 640x480x16" wkhtmltopdf cover.html cover.pdf
