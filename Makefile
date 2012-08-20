SELENIUM_JAR = $(wildcard ext/*.jar)

.PHONY: default
default: coffee lib/SeleniumWrapper.class

.PHONY: install
install:
	@mkdir -p ext
	$(if $(SELENIUM_JAR),,cd ext; wget $(npm_package_selenium_url))

.PHONY: coffee
coffee: 
	coffee -c -o lib src

lib/SeleniumWrapper.class: src/SeleniumWrapper.java
	javac -d lib/ -classpath $(SELENIUM_JAR) src/SeleniumWrapper.java

