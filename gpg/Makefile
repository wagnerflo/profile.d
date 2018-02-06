GPG := gpg2 --with-colons --fixed-list-mode

usage:
	@echo "usage: $(MAKE) x"

export-public:
	@rm -f pub.*
	@$(GPG) --list-public-keys | grep -E "^pub" | cut -d: -f5 | while read kid; do \
		$(GPG) --armor --export --output pub.$$kid $$kid; \
	done

export-trust:
	@$(GPG) --export-ownertrust | grep -vE "^#" | sort > trustdb.txt

import-trust:
	@rm -f ~/.gnupg/trustdb.gpg
	@$(GPG) --import-ownertrust < trustdb.txt
