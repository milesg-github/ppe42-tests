
.macro  _liw    rd, imm
lis     \rd, \imm@h
ori     \rd, \rd, \imm@l
.endm

.macro  _liwa   rd, imm
.if     (\imm & 0xffff0000)
lis     \rd, \imm@h
        .if     (\imm & 0xffff)
        ori     \rd, \rd, \imm@l
        .endif
.else
li      \rd, \imm@l
.endif
.endm

.macro _twneq
    beq 11223344f
    trap
11223344:
.endm

.section .vectors, "ax", @progbits

__vectors:
    b .

.org __vectors + 0x40
sys_reset:
    b test_main





.org __vectors + 0x200
test_LSKU:
    _liwa %r28, 0x28282828
    _liwa %r29, 0x29292929
    _liwa %r30, 0x30303030
    _liwa %r31, 0x31313131

    # save off stack pointer and LR
    ori %r2, %r1, 0
    mflr %r3

    # push to the stack
    stsku %r1, -32(%r1)

    # zero out LR and GPRS 28, 29, 30 and 31
    addi %r28, %r0, 0
    addi %r29, %r0, 0
    addi %r30, %r0, 0
    addi %r31, %r0, 0
    mtlr %r31

    # pop from stack
    lsku %r1, 32(%r1)

    # check that stack pointer and LR were restored
    cmpw %r1, %r2
    _twneq
    mflr %r4
    cmpw %r3, %r4
    _twneq

    # Check that r28 - r31 were restored
    _liwa %r3, 0x28282828
    cmpw %r3, %r28
    _twneq
    _liwa %r3, 0x29292929
    cmpw %r3, %r29
    _twneq
    _liwa %r3, 0x30303030
    cmpw %r3, %r30
    _twneq
    _liwa %r3, 0x31313131
    cmpw %r3, %r31
    _twneq

    # test passed
    blr

test_LCXU:
    _liwa %r0, 0x01010101
    _liwa %r3, 0x03030303
    _liwa %r4, 0x04040404
    _liwa %r5, 0x05050505
    _liwa %r6, 0x06060606
    _liwa %r7, 0x07070707
    _liwa %r8, 0x08080808
    _liwa %r9, 0x09090909
    _liwa %r10, 0x10101010
    _liwa %r28, 0x28282828
    _liwa %r29, 0x29292929
    _liwa %r30, 0x30303030
    _liwa %r31, 0x31313131
    mtsrr0 %r5
    mtsrr1 %r6
    _liwa %r13, 0x80000000
    mtxer %r13
    mtctr %r8
    mtsprg0 %r9
    mtcr0 %r30

    # copy stack pointer and LR to R2 and R13
    addi %r2, %r1, 0
    mflr %r13

    # push context to stack
    stcxu %r1, -96(%r1)

    # clobber register values
    addi %r3, %r0, 0
    addi %r4, %r0, 0
    addi %r5, %r0, 0
    addi %r6, %r0, 0
    addi %r7, %r0, 0
    addi %r8, %r0, 0
    addi %r9, %r0, 0
    addi %r10, %r0, 0
    addi %r28, %r0, 0
    addi %r29, %r0, 0
    addi %r30, %r0, 0
    addi %r31, %r0, 0
    mtsrr0  %r3
    mtsrr1  %r3
    mtxer   %r3
    mtctr   %r3
    mtsprg0 %r3
    mtcr0   %r3
    mtlr    %r3

    # pop context from stack
    lcxu %r1, 96(%r1)

    # check that stack pointer was restored
    cmpw %r1, %r2
    _twneq

    # check that LR was restored
    mflr %r2
    cmpw %r2, %r13
    _twneq

    # check that GPRs 0, 1, 3, 4, 5, 6, 7, 8, 9, 10, 28, 29, 30 and 31 were restored
    _liwa %r2, 0x01010101
    cmpw %r2, %r0
    _twneq
    _liwa %r2, 0x03030303
    cmpw %r2, %r3
    _twneq
    _liwa %r2, 0x04040404
    cmpw %r2, %r4
    _twneq
    _liwa %r2, 0x05050505
    cmpw %r2, %r5
    _twneq
    _liwa %r2, 0x06060606
    cmpw %r2, %r6
    _twneq
    _liwa %r2, 0x07070707
    cmpw %r2, %r7
    _twneq
    _liwa %r2, 0x08080808
    cmpw %r2, %r8
    _twneq
    _liwa %r2, 0x09090909
    cmpw %r2, %r9
    _twneq
    _liwa %r2, 0x10101010
    cmpw %r2, %r10
    _twneq
    _liwa %r2, 0x28282828
    cmpw %r2, %r28
    _twneq
    _liwa %r2, 0x29292929
    cmpw %r2, %r29
    _twneq
    _liwa %r2, 0x30303030
    cmpw %r2, %r30
    _twneq
    _liwa %r2, 0x31313131
    cmpw %r2, %r31
    _twneq

    # Check that SPR's were restored
    _liwa   %r4, 0x05050505
    mfsrr0  %r3
    cmpw %r3, %r4
    _twneq
    _liwa   %r4, 0x06060606
    mfsrr1  %r3
    cmpw %r3, %r4
    _twneq
    _liwa   %r4, 0x80000000
    mfxer   %r3
    cmpw %r3, %r4
    _twneq
    _liwa   %r4, 0x08080808
    mfctr   %r3
    cmpw %r3, %r4
    _twneq
    _liwa   %r4, 0x09090909
    mfsprg0 %r3
    cmpw %r3, %r4
    _twneq
    _liwa   %r4, 0x30000000
    mfcr    %r3
    cmpw %r3, %r4
    _twneq

    # test passed
    blr

test_STSKU:
    _liwa %r28, 0x28282828
    _liwa %r29, 0x29292929
    _liwa %r30, 0x30303030
    _liwa %r31, 0x31313131

    # copy off stack pointer
    ori %r2, %r1, 0

    # issue the instruction
    stsku %r1, -32(%r1)

    # check new stack pointer address
    addi %r3, %r2, -32
    cmpw %r1, %r3
    _twneq

    # new stack pointer should point to previous stack pointer value
    lwz %r3, 0(%r1)
    cmpw %r2, %r3
    _twneq

    # LR should be saved to old SP + 4
    mflr %r3
    lwz %r4, 4(%r2)
    cmpw %r3, %r4
    _twneq

    # old SP - 4 should hold r31
    lwz %r3, -4(%r2)
    cmpw %r3, %r31
    _twneq

    # old SP - 8 should hold r30
    lwz %r3, -8(%r2)
    cmpw %r3, %r30
    _twneq

    # old SP - 12 should hold r29
    lwz %r3, -12(%r2)
    cmpw %r3, %r29
    _twneq

    # old SP - 16 should hold r28
    lwz %r3, -16(%r2)
    cmpw %r3, %r28
    _twneq

    # restore stack pointer
    ori %r1, %r2, 0

    # test passed
    blr

test_STCXU:
    # copy off LR and stack pointer to r0 and r2
    addi %r2, %r1, 0
    mflr %r0

    # load the rest of the context with known values
    _liwa %r3, 0x03030303
    _liwa %r4, 0x04040404
    _liwa %r5, 0x05050505
    _liwa %r6, 0x06060606
    _liwa %r7, 0x07070707
    _liwa %r8, 0x08080808
    _liwa %r9, 0x09090909
    _liwa %r10, 0x10101010
    _liwa %r28, 0x28282828
    _liwa %r29, 0x29292929
    _liwa %r30, 0x30303030
    _liwa %r31, 0x31313131
    mtsrr0 %r5
    mtsrr1 %r6
    mtxer %r30
    mtctr %r8
    mtsprg0 %r9
    mtcr0 %r30

    # push the current context
    stcxu %r1, -112(%r1)

    # check that stack pointer was updated correctly
    addi %r3, %r2, -112
    cmpw %r3, %r1
    _twneq

    # check that new stack pointer points to old stack pointer value
    lwz %r3, 0(%r1)
    cmpw %r2, %r3
    _twneq

    # check that LR was saved at old stack pointer + 4
    lwz %r3, 4(%r2)
    cmpw %r0, %r3
    _twneq

    # check GPR 0, 1, 3, 4, 5, 6, 7, 8, 9, 10, 28, 29, 30 and 31 values
    lwz %r3, -4(%r2)
    cmpw %r3, %r31
    _twneq
    lwz %r3, -8(%r2)
    cmpw %r3, %r30
    _twneq
    lwz %r3, -12(%r2)
    cmpw %r3, %r29
    _twneq
    lwz %r3, -16(%r2)
    cmpw %r3, %r28
    _twneq
    lwz %r3, -36(%r2)
    cmpw %r3, %r10
    _twneq
    lwz %r3, -40(%r2)
    cmpw %r3, %r9
    _twneq
    lwz %r3, -44(%r2)
    cmpw %r3, %r8
    _twneq
    lwz %r3, -48(%r2)
    cmpw %r3, %r7
    _twneq
    lwz %r3, -52(%r2)
    cmpw %r3, %r6
    _twneq
    lwz %r3, -56(%r2)
    cmpw %r3, %r5
    _twneq
    lwz %r3, -60(%r2)
    cmpw %r3, %r4
    _twneq
    _liwa %r4, 0x03030303
    lwz %r3, -64(%r2)
    cmpw %r3, %r4
    _twneq
    lwz %r3, -68(%r2)
    cmpw %r3, %r2
    _twneq
    lwz %r3, -72(%r2)
    cmpw %r3, %r0
    _twneq

    #check srr0
    lwz %r3, -24(%r2)
    cmpw %r3, %r5
    _twneq

    #check srr1
    lwz %r3, -20(%r2)
    cmpw %r3, %r6
    _twneq

    #check xer
    lwz %r3, -32(%r2)
    cmpw %r3, %r30
    _twneq

    #check ctr
    lwz %r3, -28(%r2)
    cmpw %r3, %r8
    _twneq

    #check cr0
    _liwa %r4, 0x30000000
    lwz %r3, -80(%r2)
    cmpw %r3, %r4
    _twneq

    #check sprg0
    lwz %r3, -76(%r2)
    cmpw %r3, %r9
    _twneq

    #restore stack
    addi %r1, %r2, 0

    # test passed
    blr

test_LVD:
    #save off r1, lr, d28, d30
    stsku %r1, -32(%r1)

    # store 0x01010101 to stack
    _liwa %r28, 0x01010101
    stw %r28, 24(%r1)
    # store 0x02020202 to next word in stack
    _liwa %r28, 0x02020202
    stw %r28, 28(%r1)
    # load 8-byte word into d28 from stack
    lvd %r28, 24(%r1)
    # r28 should hold 0x01010101
    _liwa %r30, 0x01010101
    cmpw %r28, %r30
    _twneq
    # r29 should hold 0x02020202
    _liwa %r30, 0x02020202
    cmpw %r29, %r30
    _twneq
    
    # test passed
    lsku %r1, 32(%r1)
    blr

test_LVDU:
    #save off r1, lr, d28, d30
    stsku %r1, -32(%r1)

    addi %r2, %r1, 0
    lvdu %r3, 24(%r2)

    # check that address increased by 24 bytes
    subf %r2, %r1, %r2
    cmpwi %r2, 24
    _twneq

    # test passed
    lsku %r1, 32(%r1)
    blr

test_LVDX:
    #save off r1, lr, d28, d30
    stsku %r1, -32(%r1)

    # store 0x01010101 to stack
    _liwa %r28, 0x01010101
    stw %r28, 24(%r1)
    # store 0x02020202 to next word in stack
    _liwa %r28, 0x02020202
    stw %r28, 28(%r1)

    # load index register
    addi %r2, %r0, 24

    # load value from stack using index register
    lvdx %r28, %r2, %r1

    # r28 should hold 0x01010101
    _liwa %r30, 0x01010101
    cmpw %r28, %r30
    _twneq
    # r29 should hold 0x02020202
    _liwa %r30, 0x02020202
    cmpw %r29, %r30
    _twneq

    # test passed
    lsku %r1, 32(%r1)
    blr

test_STVD:
    #save off r1, lr, d28, d30
    stsku %r1, -32(%r1)

    # load d30 with 0x03030303_04040404
    _liwa %r30, 0x03030303
    _liwa %r31, 0x04040404

    # store the word to the stack
    stvd %r30, 24(%r1)

    # verify that the data was stored correctly
    lwz %r28, 24(%r1)
    lwz %r29, 28(%r1)
    cmpw %r28, %r30
    _twneq
    cmpw %r29, %r31
    _twneq

    # test passed
    lsku %r1, 32(%r1)
    blr

test_STVDU:
    #save off r1, lr, d28, d30
    stsku %r1, -32(%r1)

    # load d30 with 0x05050505_06060606
    _liwa %r30, 0x05050505
    _liwa %r31, 0x06060606

    # store the word to the stack
    addi %r2, %r1, 0
    stvdu %r30, 24(%r2)

    # check that address increased by 24 bytes
    subf %r2, %r1, %r2
    cmpwi %r2, 24
    _twneq

    # verify that the data was stored correctly
    lwz %r28, 24(%r1)
    lwz %r29, 28(%r1)
    cmpw %r28, %r30
    _twneq
    cmpw %r29, %r31
    _twneq

    # test passed
    lsku %r1, 32(%r1)
    blr

test_STVDX:
    #save off r1, lr, d28, d30
    stsku %r1, -32(%r1)

    # load d30 with 0x07070707_08080808
    _liwa %r30, 0x07070707
    _liwa %r31, 0x08080808

    # load index register
    addi %r2, %r0, 24

    # load value from stack using index register
    lvdx %r28, %r2, %r1

    # store the word to the stack
    stvdx %r30, %r2, %r1

    # verify that the data was stored correctly
    lwz %r28, 24(%r1)
    lwz %r29, 28(%r1)
    cmpw %r28, %r30
    _twneq
    cmpw %r29, %r31
    _twneq

    # test passed
    lsku %r1, 32(%r1)
    blr

test_SLVD:
    #save off r1, lr, d28, d30
    stsku %r1, -32(%r1)

    # load d30 with 0x09090909_10101010
    _liwa %r30, 0x09090909
    _liwa %r31, 0x10101010

    # shift d30 left by 4 bits
    addi %r2, %r0, 4
    slvd %r30, %r30, %r2

    # verify bits shifted 4 to the left
    _liwa %r28, 0x90909091
    cmpw %r28, %r30
    _twneq
    _liwa %r28, 0x01010100
    cmpw %r28, %r31
    _twneq

    # test passed
    lsku %r1, 32(%r1)
    blr

test_SRVD:
    #save off r1, lr, d28, d30
    stsku %r1, -32(%r1)

    # load d30 with 0x09090909_10101010
    _liwa %r30, 0x09090909
    _liwa %r31, 0x10101010

    # shift d30 right by 4 bits
    addi %r2, %r0, 4
    srvd %r30, %r30, %r2

    # verify bits shifted 4 to the left
    _liwa %r28, 0x00909090
    cmpw %r28, %r30
    _twneq
    _liwa %r28, 0x91010101
    cmpw %r28, %r31
    _twneq

    # test passed
    lsku %r1, 32(%r1)
    blr

test_CMPWBC:
    #save off r1, lr, d28, d30
    stsku %r1, -32(%r1)

    #load registers with test values
    addi %r2, %r0, -4
    addi %r3, %r0, -3
    addi %r4, %r0, 4
    addi %r5, %r0, 4

    # tests that should take the branch
    cmpwbeq %r4, %r5, 1f
    trap
1:
    cmpwbne %r3, %r4, 2f
    trap
2:
    cmpwblt %r2, %r3, 3f
    trap
3:
    cmpwbgt %r3, %r2, 4f
    trap
4:
    # tests that should not take the branch
    cmpwbeq %r2, %r3, 5f
    b 6f
5:
    trap
6:
    cmpwbne %r4, %r5, 7f
    b 8f
7:
    trap
8:
    cmpwblt %r3, %r2, 9f
    b 10f
9:
    trap
10:
    cmpwbgt %r2, %r3, 11f
    b 12f
11:
    trap
12:
    # test passed
    lsku %r1, 32(%r1)
    blr

test_CMPLWBC:
    #save off r1, lr, d28, d30
    stsku %r1, -32(%r1)

    #load registers with test values
    addi %r2, %r0, 2
    addi %r3, %r0, 3
    addi %r4, %r0, -4
    addi %r5, %r0, -4

    # tests that should take the branch
    cmplwbeq %r4, %r5, 1f
    trap
1:
    cmplwbne %r3, %r4, 2f
    trap
2:
    cmplwblt %r2, %r3, 3f
    trap
3:
    cmplwbgt %r3, %r2, 4f
    trap
4:
    # tests that should not take the branch
    cmplwbeq %r2, %r3, 5f
    b 6f
5:
    trap
6:
    cmplwbne %r4, %r5, 7f
    b 8f
7:
    trap
8:
    cmplwblt %r3, %r2, 9f
    b 10f
9:
    trap
10:
    cmplwbgt %r2, %r3, 11f
    b 12f
11:
    trap
12:
    # test passed
    lsku %r1, 32(%r1)
    blr


test_CMPWIBC:
    #save off r1, lr, d28, d30
    stsku %r1, -32(%r1)

    #load registers with test values
    addi %r2, %r0, -4
    addi %r3, %r0, -3
    addi %r4, %r0, 4
    addi %r5, %r0, 4

    # tests that should take the branch
    cmpwibeq %r4, 4, 1f
    trap
1:
    cmpwibne %r3, 4, 2f
    trap
2:
    cmpwiblt %r2, 0, 3f
    trap
3:
    cmpwibgt %r4, 2, 4f
    trap
4:
    # tests that should not take the branch
    cmpwibeq %r2, 3, 5f
    b 6f
5:
    trap
6:
    cmpwibne %r4, 4, 7f
    b 8f
7:
    trap
8:
    cmpwiblt %r5, 1, 9f
    b 10f
9:
    trap
10:
    cmpwibgt %r2, 0, 11f
    b 12f
11:
    trap
12:
    # test passed
    lsku %r1, 32(%r1)
    blr

test_BNBWI:
    #save off r1, lr, d28, d30
    stsku %r1, -32(%r1)

    # load test value
    _liwa %r3, 0xf0f0f0f0

    # branch if bit 3 is 1
    bb1wi %r3, 3, 1f
    trap
1:
    # branch if bit 7 is 0
    bb0wi %r3, 7, 2f
    trap
2:
    # branch if bit 8 is 0
    bb0wi %r3, 8, 3f
    b 4f
3:
    trap
4:
    # branch if bit 13 is 1
    bb1wi %r3, 13, 5f
    b 6f
5:
    trap
6:
    # test passed
    lsku %r1, 32(%r1)
    blr

test_BNBW:
    #save off r1, lr, d28, d30
    stsku %r1, -32(%r1)

    # load test value
    _liwa %r3, 0xf0f0f0f0

    # branch if bit 3 is 1
    _liwa %r4, 3
    bb1w %r3, %r4, 1f
    trap
1:
    # branch if bit 7 is 0
    _liwa %r4, 7
    bb0w %r3, %r4, 2f
    trap
2:
    # branch if bit 8 is 0
    _liwa %r4, 8
    bb0w %r3, %r4, 3f
    b 4f
3:
    trap
4:
    # branch if bit 13 is 1
    _liwa %r4, 13
    bb1w %r3, %r4, 5f
    b 6f
5:
    trap
6:
    # test passed
    lsku %r1, 32(%r1)
    blr

test_CLRBWIBC:
    #save off r1, lr, d28, d30
    stsku %r1, -32(%r1)

    # clear bit 12 and branch if result is not 0
    _liwa %r3, 0x00180000
    clrbwibnz %r3, 12, 1f
    trap
1:
    # clear bit 11 and branch if result is 0
    clrbwibz %r3, 11, 2f
    trap
2:
    # clear bit 7 and branch if result is 0
    _liwa %r3, 0x01800000
    clrbwibz %r3, 7, 3f
    b 4f
3:
    trap
4:
    # clear bit 8 and branch if result is not zero
    clrbwibnz %r3, 8, 5f
    b 6f
5:
    trap
6:
    # test passed
    lsku %r1, 32(%r1)
    blr

test_CLRWBC:
    #save off r1, lr, d28, d30
    stsku %r1, -32(%r1)

    # clear bit 12 and branch if result is not 0
    _liwa %r3, 0x00180000
    _liwa %r4, 12
    clrbwbnz %r3, %r4, 1f
    trap
1:
    # clear bit 11 and branch if result is 0
    _liwa %r4, 11
    clrbwbz %r3, %r4, 2f
    trap
2:
    # clear bit 7 and branch if result is 0
    _liwa %r3, 0x01800000
    _liwa %r4, 7
    clrbwbz %r3, %r4, 3f
    b 4f
3:
    trap
4:
    # clear bit 8 and branch if result is not zero
    _liwa %r4, 8
    clrbwbnz %r3, %r4, 5f
    b 6f
5:
    trap
6:
    # test passed
    lsku %r1, 32(%r1)
    blr

test_DCBQ:
    #save off r1, lr, d28, d30
    stsku %r1, -32(%r1)

    _liwa %r3, 0xffffffff

    dcbq %r3, %r4, %r5

    # verify that %r3 is set to 0
    _liwa %r4, 0
    cmpw %r3, %r4
    _twneq

    # test passed
    lsku %r1, 32(%r1)
    blr

test_RLDICL:
    #save off r1, lr, d28, d30
    stsku %r1, -32(%r1)

    # load a test value into d28
    _liwa %r28, 0x01234567
    _liwa %r29, 0x89abcdef

    # clear the left 8 bits
    clrldi %r30, %r28, 8
    _liwa %r2, 0x00234567
    cmpw %r2, %r30
    _twneq
    cmpw %r29, %r31
    _twneq

    # extract bits 20-51 and right justify
    extrdi %r30, %r28, 32, 20
    _liwa %r2, 0x56789abc
    cmpw %r2, %r31
    _twneq

    # shift right 32 bits
    srdi %r30, %r28, 32
    cmpw %r31, %r28
    _twneq

    # test passed
    lsku %r1, 32(%r1)
    blr

test_RLDICR:
    #save off r1, lr, d28, d30
    stsku %r1, -32(%r1)

    # load a test value into d28
    _liwa %r28, 0x01234567
    _liwa %r29, 0x89abcdef

    # clear the right 8 bits
    clrrdi %r30, %r28, 8
    _liwa %r2, 0x89abcd00
    cmpw %r2, %r31
    _twneq
    cmpw %r28, %r30
    _twneq

    # extract bits 20-51 and left justify
    extldi %r30, %r28, 32, 20
    _liwa %r2, 0x56789abc
    cmpw %r2, %r30
    _twneq

    # shift left 32 bits
    sldi %r30, %r28, 32
    cmpw %r30, %r29
    _twneq

    # test passed
    lsku %r1, 32(%r1)
    blr

test_RLDIMI:
    #save off r1, lr, d28, d30
    stsku %r1, -32(%r1)

    # load d28 and d30 with test data
    _liwa %r28, 0x01234567
    _liwa %r29, 0x89abcdef
    _liwa %r30, 0xffffffff
    _liwa %r31, 0xffffffff

    # insert bits 32-63 from d28 into bits 16-47 of d30
    rldimi %r30, %r28, 16, 16
    _liwa %r2, 0xffff89ab
    cmpw %r2, %r30
    _twneq
    _liwa %r2, 0xcdefffff
    cmpw %r2, %r31
    _twneq

    # test passed
    lsku %r1, 32(%r1)
    blr

test_main:
    # Set up stack pointer
    _liwa %r1, 0xfff9fff8

    # begin tests
    bl test_STSKU
    bl test_LSKU
    bl test_STCXU
    bl test_LCXU
    bl test_LVD
    bl test_LVDU
    bl test_LVDX
    bl test_STVD
    bl test_STVDU
    bl test_STVDX
    bl test_SLVD
    bl test_SRVD
    bl test_CMPWBC
    bl test_CMPLWBC
    bl test_CMPWIBC
    bl test_BNBWI
    bl test_BNBW
    bl test_CLRBWIBC
    bl test_CLRWBC
    bl test_DCBQ
    bl test_RLDICL
    bl test_RLDICR
    bl test_RLDIMI
    b .

.end
