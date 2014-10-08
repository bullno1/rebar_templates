.PHONY: web-compile web-get-deps web-clean js-compile

DEFAULT+=web-compile
COMPILE+=web-compile
GET_DEPS+=web-get-deps
CLEAN+=web-clean

web-compile: web-get-deps
	gulp

web-get-deps: .build/npm_deps

.build/npm_deps: package.json
	npm install
	@mkdir -p .build
	@touch .build/npm_deps

web-clean: web-get-deps
	gulp clean
