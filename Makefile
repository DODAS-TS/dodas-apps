VERSION?=`git describe --tags`
DOCBIN?=mkdocs

.PHONY: init build push publish-doc

all: init build

help:
	@echo "Available commands:\n"
	@echo "- publish-doc			: "

publish-doc:
	cp README.md docs/README.md
	$(DOCBIN) gh-deploy