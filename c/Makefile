SHELL := /bin/bash

check:
	cue fmt
	cue eval -c >/dev/null

gen:
	$(MAKE) check
	find ../e/ -name '*.yaml' | xargs rm -f
	rm -f ../k/*/kustomization.yaml
	rm -f ../k/*/resource-*.yaml
	rm -f ../k/*/patch-*.yaml
	rm -f ../tf/*/*.tf.json
	c gen
	git add ../e ../k ../tf
	pc || true
	git add ../e ../k ../tf

regen:
	$(MAKE) gen
	cd ../k && for a in */; do echo $$a; done | runmany 1 'cd ../k/$$1 && rm -rf charts && mkdir -p out && kustomize build --enable-helm > out/main.yaml'
	git reset ../k/datadog
	git checkout ../k/datadog
	pc
	git add ../k/
	git add -u ../k/

ping-egg:
	kubectl patch terraform egg --type json -p '[ { "op": "replace", "path": "/spec/outputsToOmit/0", "value": "'$$RANDOM'" } ]'

ping-chicken:
	kubectl patch terraform chicken --type json -p '[ { "op": "replace", "path": "/spec/outputsToOmit/0", "value": "'$$RANDOM'" } ]'
