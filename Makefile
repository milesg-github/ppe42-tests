TOOLS_PREFIX?=../tools/ppetools/prod/bin/powerpc-eabi-
BUILD_PATH?=./build/

all: $(BUILD_PATH)ppe42-test.out

$(BUILD_PATH)ppe42-test.s: ppe42-test.S
	$(TOOLS_PREFIX)gcc -E ppe42-test.S -o $(BUILD_PATH)ppe42-test.s

$(BUILD_PATH)ppe42-test.o: $(BUILD_PATH)ppe42-test.s
	$(TOOLS_PREFIX)as -mppe42x $(BUILD_PATH)ppe42-test.s -o $(BUILD_PATH)ppe42-test.o

$(BUILD_PATH)ppe42-test.out: $(BUILD_PATH)ppe42-test.o link.ld
	$(TOOLS_PREFIX)ld $(BUILD_PATH)ppe42-test.o -o $(BUILD_PATH)ppe42-test.out -T link.ld

clean:
	@rm -f $(BUILD_PATH)/*
