/*
 * "Hello World" example.
 *
 * This example prints 'Hello from Nios II' to the STDOUT stream. It runs on
 * the Nios II 'standard', 'full_featured', 'fast', and 'low_cost' example
 * designs. It runs with or without the MicroC/OS-II RTOS and requires a STDOUT
 * device in your system's hardware.
 * The memory footprint of this hosted application is ~69 kbytes by default
 * using the standard reference design.
 *
 * For a reduced footprint version of this template, and an explanation of how
 * to reduce the memory footprint for a given application, see the
 * "small_hello_world" template.
 *
 */

#include <stdio.h>
#include "system.h"

int main()
{
  //printf("Hello from Nios II!\n");
	volatile uint32_t * ocm_base = (uint32_t *) ON_CHIP_MEM_BASE;
	volatile uint32_t value = 0xDEAD;

	//writing to ocm to see if it works:
	*(ocm_base) = value;
	*(ocm_base+2) = value;
	*(ocm_base+4) = value;
	*(ocm_base+6) = value;
  return 0;
}
