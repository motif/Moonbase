NODE_MODULES = ./node_modules
NODE_BIN = $(NODE_MODULES)/.bin

.DEFAULT_GOAL := watch


### Moonbase

npm:
	npm install

build: npm
	$(NODE_BIN)/moonbase build

watch: npm
	$(NODE_BIN)/moonbase watch


### Optional

upload: build
	make git-check
	# rsync ...


### Utilities

BREW_DEPENDENCIES = node rsync

# Global check to see if all dependencies are there
K := $(foreach exec,$(EXECUTABLES), \
	$(if $(shell which $(exec)),some string,$(error "No $(exec) in PATH, run 'make bootstrap')))

bootstrap:
	brew install $(BREW_DEPENDENCIES)
	make npm

git-check:
	@status=$$(git status --porcelain); \
	if test "x$${status}" = x; then \
		git push; \
	else \
		echo "\n\n!!! Working directory is dirty, commit/push first !!!\n\n" >&2; exit 1 ; \
	fi


.PHONY: bootstrap npm build watch upload git-check