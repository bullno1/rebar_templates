PLT_APPS ?= erts kernel stdlib
DIALYZER_OPTS ?= -Werror_handling -Wrace_conditions -Wunmatched_returns

REBAR ?= $(CURDIR)/rebar
REBAR_URL ?= https://github.com/rebar/rebar/releases/download/2.5.1/rebar

RELX ?= $(CURDIR)/relx
RELX_URL ?= https://github.com/erlware/relx/releases/download/v1.0.4/relx

ifdef ERL_LIBS
RELX_OPTS?=--lib-dir $(ERL_LIBS)
else
RELX_OPTS?=
endif

PROJECT_PLT=$(CURDIR)/.project_plt

ERL = $(shell which erl)
ifeq ($(ERL),)
$(error "Erlang not available on this system")
endif

export REBAR
export RELX

.PHONY: all compile clean test dialyzer typer distclean \
        get-deps clean-common-test-data release

all: compile

get-deps: $(REBAR)
	$(REBAR) get-deps
	$(REBAR) compile

compile: $(REBAR)
	$(REBAR) skip_deps=true compile

release: compile $(RELX)
	$(RELX) $(RELX_OPTS)
	rm -rf ./_rel/*/erts-*/include
	rm -rf ./_rel/*/erts-*/lib
	rm -rf ./_rel/*/erts-*/src
	rm -rf ./_rel/*/erts-*/doc
	rm -rf ./_rel/*/erts-*/man

eunit: compile clean-common-test-data
	$(REBAR) skip_deps=true eunit

ct: compile clean-common-test-data
	$(REBAR) skip_deps=true ct

test: compile eunit ct

define download
	wget -O $(1) $(2) || rm $(1)
	chmod +x $(1)
endef

$(REBAR):
	@$(call download,$(REBAR),$(REBAR_URL))

$(RELX):
	@$(call download,$(RELX),$(RELX_URL))

$(PROJECT_PLT):
	@echo Building local plt at $(PROJECT_PLT)
	@echo
	dialyzer --output_plt $(PROJECT_PLT) --build_plt \
	         --apps $(PLT_OTP_APPS) -r deps

dialyzer: compile $(PROJECT_PLT)
	dialyzer --plt $(PROJECT_PLT) \
	         --fullpath \
	         $(DIALYZER_FLAGS) \
	         -I $(CURDIR)/deps -pa $(CURDIR)/ebin --src src

typer: compile
	typer --plt $(PROJECT_PLT) -r ./src

clean-common-test-data:
# We have to do this because of the unique way we generate test
# data. Without this rebar eunit gets very confused
	- rm -rf $(CURDIR)/test/*_SUITE_data

clean: clean-common-test-data
	- rm -rf $(CURDIR)/test/*.beam
	- rm -rf $(CURDIR)/logs
	$(REBAR) skip_deps=true clean

distclean: clean
	- rm -rf $(PROJECT_PLT)
	- rm -rvf $(CURDIR)/deps/*
