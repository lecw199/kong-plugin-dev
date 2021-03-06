OS := $(shell uname | awk '{print tolower($$0)}')
MACHINE := $(shell uname -m)

DEV_ROCKS = "busted 2.0.0" "busted-htest 1.0.0" "luacheck 0.23.0" "lua-llthreads2 0.1.5" "http 0.3" "kong"
WIN_SCRIPTS = "bin/busted" "bin/kong"
BUSTED_ARGS ?= -v -o TAP
TEST_CMD ?= bin/busted $(BUSTED_ARGS)
SHELL_BASH ?= /bin/bash -c

## -o TAP

ifeq ($(OS), darwin)
OPENSSL_DIR ?= /usr/local/opt/openssl
GRPCURL_OS ?= osx
else
OPENSSL_DIR ?= /usr
GRPCURL_OS ?= $(OS)
endif

.PHONY: install dependencies dev remove grpcurl \
	setup-ci setup-kong-build-tools \
	lint test test-integration test-plugins test-all \
	pdk-phase-check functional-tests \
	fix-windows \
	nightly-release release

ROOT_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
KONG_SOURCE_LOCATION ?= $(ROOT_DIR)
KONG_BUILD_TOOLS_LOCATION ?= $(KONG_SOURCE_LOCATION)/../kong-build-tools
RESTY_VERSION ?= `grep RESTY_VERSION $(KONG_SOURCE_LOCATION)/.requirements | awk -F"=" '{print $$2}'`
RESTY_LUAROCKS_VERSION ?= `grep RESTY_LUAROCKS_VERSION $(KONG_SOURCE_LOCATION)/.requirements | awk -F"=" '{print $$2}'`
RESTY_OPENSSL_VERSION ?= `grep RESTY_OPENSSL_VERSION $(KONG_SOURCE_LOCATION)/.requirements | awk -F"=" '{print $$2}'`
RESTY_PCRE_VERSION ?= `grep RESTY_PCRE_VERSION $(KONG_SOURCE_LOCATION)/.requirements | awk -F"=" '{print $$2}'`
KONG_BUILD_TOOLS ?= '4.3.2'
KONG_VERSION ?= `cat $(KONG_SOURCE_LOCATION)/kong-*.rockspec | grep tag | awk '{print $$3}' | sed 's/"//g'`
OPENRESTY_PATCHES_BRANCH ?= master
KONG_NGINX_MODULE_BRANCH ?= master

#setup-ci:
#	OPENRESTY=$(RESTY_VERSION) \
#	LUAROCKS=$(RESTY_LUAROCKS_VERSION) \
#	OPENSSL=$(RESTY_OPENSSL_VERSION) \
#	OPENRESTY_PATCHES_BRANCH=$(OPENRESTY_PATCHES_BRANCH) \
#	KONG_NGINX_MODULE_BRANCH=$(KONG_NGINX_MODULE_BRANCH) \
#	.ci/setup_env.sh

#setup-kong-build-tools:
#	-rm -rf $(KONG_BUILD_TOOLS_LOCATION)
#	-git clone https://github.com/Kong/kong-build-tools.git $(KONG_BUILD_TOOLS_LOCATION)
#	cd $(KONG_BUILD_TOOLS_LOCATION); \
#	git reset --hard $(KONG_BUILD_TOOLS); \
#
#functional-tests: setup-kong-build-tools
#	cd $(KONG_BUILD_TOOLS_LOCATION); \
#	$(MAKE) setup-build && \
#	$(MAKE) build-kong && \
#	$(MAKE) test

#nightly-release:
#	sed -i -e '/return string\.format/,/\"\")/c\return "$(KONG_VERSION)\"' kong/meta.lua
#	$(MAKE) release
#
#release:
#	cd $(KONG_BUILD_TOOLS_LOCATION); \
#	$(MAKE) package-kong && \
#	$(MAKE) release-kong

install:
	@luarocks make OPENSSL_DIR=$(OPENSSL_DIR) CRYPTO_DIR=$(OPENSSL_DIR)

remove:
	-@luarocks remove kong

dependencies:
	@for rock in $(DEV_ROCKS) ; do \
	  if luarocks list --porcelain $$rock | grep -q "installed" ; then \
	    echo $$rock already installed, skipping ; \
	  else \
	    echo $$rock not found, installing via luarocks... ; \
	    luarocks install $$rock OPENSSL_DIR=$(OPENSSL_DIR) CRYPTO_DIR=$(OPENSSL_DIR); \
	  fi \
	done;

#grpcurl:
#	@curl -s -S -L \
#		https://github.com/fullstorydev/grpcurl/releases/download/v1.3.0/grpcurl_1.3.0_$(GRPCURL_OS)_$(MACHINE).tar.gz | tar xz -C bin;
#	@rm bin/LICENSE

dev: remove install dependencies

lint:
	@luacheck -q .
	@!(grep -R -E -n -w '#only|#o' spec && echo "#only or #o tag detected") >&2
	@!(grep -R -E -n -- '---\s+ONLY' t && echo "--- ONLY block detected") >&2

test:
	@$(TEST_CMD) spec/01-unit

test-integration:
	@$(TEST_CMD) spec/02-integration

test-plugins:
	@$(TEST_CMD) spec/03-plugins

test-all:
	@$(TEST_CMD) spec/

test-custom:
	@$(TEST_CMD) spec/04-custom

test-self:
	@$(TEST_CMD) $(file)

test-transform:
	@$(TEST_CMD) spec/02-plugins/28-klook_request_transformer/02-access_spec.lua

install-openresty:
	chmod +x script/openresty_deploy.sh
	sh script/openresty_deploy.sh

clear:
	@$(SHELL_BASH) 'echo -e "\033[32m -- clear logs complete. -- \033[0m"'
	@$(SHELL_BASH) 'echo "" > logs/error.log && echo "" > logs/access.log'
