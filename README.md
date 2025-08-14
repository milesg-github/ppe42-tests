# ppe42-tests
A simple test to validate instructions specific to the IBM PPE42 processor

# How to build
To build the code, you will first need to install the PPE42 GCC compiler and binutils.  It appears that this was never upstreamed, but it is available in a public Github repo here:
https://github.com/open-power/ppe42-gcc

The ppe42-tests Makefile expects gcc and the binutils to be installed in the same directory that contains the ppe42-tests repo.  So, if your ppe42-tests repo is in `/home/foo/repos` then it expects that gcc and the binutils exist at `/home/foo/repos/tools/ppetools/prod/bin/`.  However, this can be overridden with the `TOOLS_PREFIX` environment variable.

Once you have GCC and binutils installed, you should be able to `cd` into the `ppe42-tests` repo and run `make`.  This will create a `ppe42-test.out` file in the `./build` directory.

NOTE: A prebuilt image is provided in the `./images` directory.

# How to run in QEMU
Assuming you have a version of QEMU that supports running the `ppe42_machine`, you should be able to load the code and run it using the following QEMU command line:
```
qemu-system-ppc -nographic -machine ppe42_machine -device loader,file=./ppe42-test.out -device loader,addr=0xfff80040,cpu-num=0
```

Currently, `ppe42_machine` does not support any kind of console output.  If the test code detects a failure, it will execute a `trap` instruction, which will cause QEMU to "checkstop" and dump all register contents.  Currently, this is the only indication that the test failed.  If the test succeeds, you will not see any failure output.

