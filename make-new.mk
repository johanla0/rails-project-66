init-eslint:
	npm init @eslint/config
init-stylelint:
	npm init stylelint
new:
	rails new $(ARGS) --css=bootstrap --javascript=esbuild
	new-bootstrap
	new-esbuild
	new-hotwire
new-annotate:
	bin/rails generate annotate:install
new-bootstrap:
	bin/rails css:install:bootstrap
new-bullet:
	bin/rails generate bullet:install
new-esbuild:
	bin/rails javascript:install:esbuild
new-hotwire:
	bin/rails turbo:install stimulus:install
new-pundit:
	bin/rails generate pundit:install
new-simpleform:
	bin/rails generate simple_form:install --bootstrap
