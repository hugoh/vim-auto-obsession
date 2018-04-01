.PHONY: default lint doc

default: lint doc

lint:
	vint plugin/auto-obsession.vim

doc: doc/auto-obsession.txt

doc/auto-obsession.txt: plugin/auto-obsession.vim addon-info.json
	vimdoc .
