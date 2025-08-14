OUTPUT_FORMAT(elf32-powerpc);

MEMORY
{
 sram : ORIGIN = 0xfff80000, LENGTH = 0x20000
}

SECTIONS
{
    . = 0xfff80000;

    . = ALIGN(512);

    _VECTOR_START = .;

    .vectors  _VECTOR_START  : { *(.vectors) } > sram

    .text       : { *(.text) } > sram

}
