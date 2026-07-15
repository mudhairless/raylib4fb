build:
	@cd src && make

build-debug:
	@cd src && make DEBUG=1

examples: build
	@cd examples && make

.PHONY : clean-all
clean-all: clean clean-examples

.PHONY : clean
clean:
	@cd src && make clean

.PHONY : clean-examples
clean-examples:
	@cd examples && make clean
