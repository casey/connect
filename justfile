default: watch

version := `sed -En 's/version[[:space:]]*=[[:space:]]*"([^"]+)"/v\1/p' Cargo.toml | head -1`

bt := '0'

export RUST_BACKTRACE := bt

log := 'warn'

export RUST_LOG := log

# watch filesystem for changes and rerun tests
watch +ARGS='':
	cargo watch --clear --exec 'test {{ARGS}}'

push:
	! git branch | grep '* master'
	git push github

# clean up feature branch BRANCH
done BRANCH=`git rev-parse --abbrev-ref HEAD`:
	git push github {{BRANCH}}:master
	git rebase github/master master
	git branch -d {{BRANCH}}

test:
	cargo test --all

clippy:
	cargo clippy --all

fmt:
	cargo +nightly fmt --all

lint:
	./bin/lint

dev-deps:
	cargo install just
	cargo install cargo-watch

check: test clippy lint
	git diff --no-ext-diff --quiet --exit-code
	cargo +nightly fmt --all -- --check

draft: push
	hub pull-request -o --draft

pr: check push
	hub pull-request -o

merge BRANCH=`git rev-parse --abbrev-ref HEAD`:
	#!/usr/bin/env bash
	set -euxo pipefail
	while ! hub ci-status --verbose {{BRANCH}}; do
		sleep 5
	done
	just done {{BRANCH}}
