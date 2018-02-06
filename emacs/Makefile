usage:
	@echo "usage: $(MAKE) update-modes"

GITHUB := https://raw.githubusercontent.com
dired-single.el_URL := $(GITHUB)/crocket/dired-single/master/dired-single.el
js2-mode.el_URL := $(GITHUB)/mooz/js2-mode/master/js2-mode.el
swbuff.el_URL := $(GITHUB)/emacsorphanage/swbuff/master/swbuff.el
xquery-mode.el_URL := $(GITHUB)/xquery-mode/xquery-mode/master/xquery-mode.el
yaml-mode.el_URL := $(GITHUB)/yoshiki/yaml-mode/master/yaml-mode.el

*.el::
	@[ -n "$($@_URL)" ] && \
	    curl -sS -o "$@" "$($@_URL)"

update-modes: dired-single.el js2-mode.el swbuff.el xquery-mode.el yaml-mode.el
