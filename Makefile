help:
	echo "make help           - Print this help"
	echo "make fontopen       - Customize font with fontello.com"
	echo "make fontsave       - Save font from fontello.com"

FONTELLO_HOST ?= http://fontello.com
FONT_DIR  ?= src

fontopen:
	@if test ! `which curl` ; then \
		echo 'Install curl first.' >&2 ; \
		exit 128 ; \
		fi
	curl --silent --show-error --fail --output .fontello \
		--form "config=@${FONT_DIR}/config.json" \
		${FONTELLO_HOST}
	@echo "Open ${FONTELLO_HOST}/`cat .fontello` using your browser"

fontsave:
	@if test ! `which unzip` ; then \
		echo 'Install unzip first.' >&2 ; \
		exit 128 ; \
		fi
	@if test ! -e .fontello ; then \
		echo 'Run `make fontopen` first.' >&2 ; \
		exit 128 ; \
		fi
	rm -rf .fontello.src .fontello.zip
	curl --silent --show-error --fail --output .fontello.zip \
		${FONTELLO_HOST}/`cat .fontello`/get
	unzip .fontello.zip -d .fontello.src
	rm -rf ${FONT_DIR}
	mv `find ./.fontello.src -maxdepth 1 -name 'fontello-*'` ${FONT_DIR}
	rm -rf .fontello.src .fontello.zip

deploy:
	git branch -D gh-pages
	git checkout --orphan gh-pages
	git rm -rf --cached .
	cp -r src/README.txt src/css src/font ./
	git add README.txt css font
	git commit -m "Update font assets `date`"
	git push -f origin gh-pages

.PHONY: help fontopen fontsave deploy
.SILENT: help
