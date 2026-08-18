ENTRY(_start)
PHDRS { text PT_LOAD; data PT_LOAD; }

MEMORY {
  mrom : ORIGIN = 0x20000000, LENGTH = 4K
  sram : ORIGIN = 0x0f000000, LENGTH = 8K
}

SECTIONS {
  /* _pmem_start and _entry_offset are defined in LDFLAGS */
  . = _pmem_start + _entry_offset;
  . = ORIGIN(mrom);
  .text : {
    *(entry)
    *(.text*)
  } > mrom AT > mrom : text
  etext = .;
  _etext = .;
  .rodata : {
    *(.rodata*)
  } > mrom AT > mrom
  .data : {
	_data_start = .;
    *(.data*)
	_data_end = .;
  } > sram AT > mrom : data
  _data_load_start = LOADADDR(.data);
  _data_size = _data_end - _data_start;
  edata = .;
  _data = .;
  .bss : {
	_bss_start = .;
    *(.bss*)
    *(.sbss*)
    *(.scommon)
	_bss_end = .;
  } > sram
  . = _bss_end;
  end = .;
  _end = .;
  _heap_start = ALIGN(0x1000);
  . = _heap_start + 0x800;
  _heap_end = .;
  _stack_top = ALIGN(0x1000);
  . = 0x0f001fff;
  _stack_pointer = ALIGN(0x1000);
  /*
  end = .;
  _end = .;
  _heap_start = ALIGN(0x1000);
  */
}
