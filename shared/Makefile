# Sub-Makefiles
include make/*.mk

# Customizations

# Aggregate all targets
.PHONY: all compile test get-deps release
.DEFAULT_GOAL:=all

all: $(DEFAULT)

compile: $(COMPILE)

test: compile $(TEST)

clean: $(CLEAN)

get-deps: $(GET_DEPS)

release: compile $(RELEASE)
