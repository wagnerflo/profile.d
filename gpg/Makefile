GPG := gpg2 --with-colons --fixed-list-mode

usage:
	@echo "usage: $(MAKE) export-public | export-trust | import-public | import-trust"

export-public:
	@$(GPG) --list-public-keys | awk -F: '/^pub/{ getline; print $$10 }' | \
	   while read fpr; do \
	     $(GPG) --yes --armor --export --output pub.$$fpr $$fpr; \
	   done

import-public:
	@$(GPG) --import pub.*

export-trust:
	@$(GPG) --export-ownertrust | grep -vE "^#" | sort > trustdb.txt

import-trust:
	@rm -f ~/.gnupg/trustdb.gpg
	@$(GPG) --import-ownertrust < trustdb.txt
