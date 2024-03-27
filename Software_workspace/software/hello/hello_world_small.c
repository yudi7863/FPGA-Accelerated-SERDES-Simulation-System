/* 
 * "Small Hello World" example. 
 * 
 * This example prints 'Hello from Nios II' to the STDOUT stream. It runs on
 * the Nios II 'standard', 'full_featured', 'fast', and 'low_cost' example 
 * designs. It requires a STDOUT  device in your system's hardware. 
 *
 * The purpose of this example is to demonstrate the smallest possible Hello 
 * World application, using the Nios II HAL library.  The memory footprint
 * of this hosted application is ~332 bytes by default using the standard 
 * reference design.  For a more fully featured Hello World application
 * example, see the example titled "Hello World".
 *
 * The memory footprint of this example has been reduced by making the
 * following changes to the normal "Hello World" example.
 * Check in the Nios II Software Developers Manual for a more complete 
 * description.
 * 
 * In the SW Application project (small_hello_world):
 *
 *  - In the C/C++ Build page
 * 
 *    - Set the Optimization Level to -Os
 * 
 * In System Library project (small_hello_world_syslib):
 *  - In the C/C++ Build page
 * 
 *    - Set the Optimization Level to -Os
 * 
 *    - Define the preprocessor option ALT_NO_INSTRUCTION_EMULATION 
 *      This removes software exception handling, which means that you cannot 
 *      run code compiled for Nios II cpu with a hardware multiplier on a core 
 *      without a the multiply unit. Check the Nios II Software Developers 
 *      Manual for more details.
 *
 *  - In the System Library page:
 *    - Set Periodic system timer and Timestamp timer to none
 *      This prevents the automatic inclusion of the timer driver.
 *
 *    - Set Max file descriptors to 4
 *      This reduces the size of the file handle pool.
 *
 *    - Check Main function does not exit
 *    - Uncheck Clean exit (flush buffers)
 *      This removes the unneeded call to exit when main returns, since it
 *      won't.
 *
 *    - Check Don't use C++
 *      This builds without the C++ support code.
 *
 *    - Check Small C library
 *      This uses a reduced functionality C library, which lacks  
 *      support for buffering, file IO, floating point and getch(), etc. 
 *      Check the Nios II Software Developers Manual for a complete list.
 *
 *    - Check Reduced device drivers
 *      This uses reduced functionality drivers if they're available. For the
 *      standard design this means you get polled UART and JTAG UART drivers,
 *      no support for the LCD driver and you lose the ability to program 
 *      CFI compliant flash devices.
 *
 *    - Check Access device drivers directly
 *      This bypasses the device file system to access device drivers directly.
 *      This eliminates the space required for the device file system services.
 *      It also provides a HAL version of libc services that access the drivers
 *      directly, further reducing space. Only a limited number of libc
 *      functions are available in this configuration.
 *
 *    - Use ALT versions of stdio routines:
 *
 *           Function                  Description
 *        ===============  =====================================
 *        alt_printf       Only supports %s, %x, and %c ( < 1 Kbyte)
 *        alt_putstr       Smaller overhead than puts with direct drivers
 *                         Note this function doesn't add a newline.
 *        alt_putchar      Smaller overhead than putchar with direct drivers
 *        alt_getchar      Smaller overhead than getchar with direct drivers
 *
 */


#include "sys/alt_stdio.h"
#include "HAL/inc/io.h"
#include "system.h"
#include <stdint.h>
volatile uint64_t SIGMA6 [128] = {

		0x000000006991a1e1,
		0x000000012ecc2924,
		0x000000029b9a4cbb,
		0x0000000537a732b6,
		0x00000009f2d9610a,
		0x0000001270ef60fd,
		0x000000218891cead,
		0x0000003c166ec4c5,
		0x0000006a57e8b9cd,
		0x000000ba1dd18b91,
		0x00000142532c03ac,
		0x0000022894610095,
		0x000003a9f158c936,
		0x000006287be2dd4f,
		0x00000a400274c783,
		0x000010e55fe5b7f4,
		0x00001b9531951b17,
		0x00002c98a80f0071,
		0x000047699efa9551,
		0x0000714254b32173,
		0x0000b1e91263aec0,
		0x000114cced3a15d5,
		0x0001aa8e84399816,
		0x00028b162929a120,
		0x0003d860093c007c,
		0x0005c22e4931cab3,
		0x00088ad805ddd56c,
		0x000c8d71e696a1b2,
		0x0012459043a502ec,
		0x001a58e25e03d920,
		0x0025a2e017d41c90,
		0x003542b62dbe7548,
		0x004aab86478ea358,
		0x0067b6eeadb42dcc,
		0x008eb99fe2bac320,
		0x00c2998c74301f98,
		0x0106e4f9e04368e0,
		0x015fe96abd7abb30,
		0x01d2c9067a433090,
		0x02658cd00009e360,
		0x031f31b211c5cb80,
		0x0407ae2fae471840,
		0x0527ee6a4f774280,
		0x0689c439db13cd40,
		0x0837c94bb6271580,
		0x0a3d31ae80cfc300,
		0x0ca58dd9a88f8e00,
		0x0f7c7c2165d42e80,
		0x12cd4a992973e300,
		0x16a28b99fbd89200,
		0x1b05a063d3100500,
		0x1ffe3e875fa96c00,
		0x2591f5d4f205b600,
		0x2bc3bd57c90a5c00,
		0x32938e5069607800,
		0x39fe1416ea59ae00,
		0x41fc774219e7ac00,
		0x4a84495f43f65c00,
		0x538794f9b75f7000,
		0x5cf513be95fe3c00,
		0x66b88a5209162400,
		0x70bb47183b5f8000,
		0x7ae4bef52e004000,
		0x851b4109e9493000,
		0x8f44b8e6dbe9f000,
		0x994775ad0e335000,
		0xa30aec40814b3800,
		0xac786b055fea0000,
		0xb57bb69fd3531000,
		0xbe0388bcfd61c000,
		0xc601ebe82cefc000,
		0xcd6c71aeade8f800,
		0xd43c42a74e3f1800,
		0xda6e0a2a2543c000,
		0xe001c177b7a00800,
		0xe4fa5f9b44397000,
		0xe95d74651b70e000,
		0xed32b565edd59000,
		0xf08383ddb1754800,
		0xf35a72256eb9e800,
		0xf5c2ce509679b000,
		0xf7c836b361226000,
		0xf9763bc53c35a800,
		0xfad81194c7d23000,
		0xfbf851cf69025800,
		0xfce0ce4d0583a800,
		0xfd9a732f173f9000,
		0xfe2d36f89d064000,
		0xfea0169459ceb800,
		0xfef91b0537060800,
		0xff3d6672a3195000,
		0xff71465f348eb000,
		0xff98491069954800,
		0xffb55478cfbad000,
		0xffcabd48e98b0000,
		0xffda5d1eff755800,
		0xffe5a71cb9459800,
		0xffedba6ed3a47000,
		0xfff3728d30b2d000,
		0xfff77527116ba000,
		0xfffa3dd0ce17a800,
		0xfffc279f0e0d7000,
		0xfffd74e8ee1fd000,
		0xfffe5570930fd800,
		0xfffeeb322a0f5800,
		0xffff4e1604e5c000,
		0xffff8ebcc2965000,
		0xffffb895784ee000,
		0xffffd3666f3a7800,
		0xffffe469e5b46000,
		0xffffef19b763c000,
		0xfffff5bf14d4b000,
		0xfffff9d69b669800,
		0xfffffc5525f0b000,
		0xfffffdd682e87800,
		0xfffffebcc41d7800,
		0xffffff44f977f000,
		0xffffff94bf60c000,
		0xffffffc300dab800,
		0xffffffdd8eb7b000,
		0xffffffeca65a2000,
		0xfffffff524702000,
		0xfffffff9dfa25000,
		0xfffffffc7baf3800,
		0xfffffffde87d5800,
		0xfffffffeadb7e000,
		0xffffffff17498000,
		0xffffffff4f3b5800,


};

int main()
{
  //printf("Hello from Nios II!\n");
	//assigning values to SIGMA6:


	volatile uint32_t * ocm_base = (uint32_t *) ON_CHIP_MEM_BASE;
	volatile uint32_t total_bits = 0;// = 0x1234DEAD;

	//writing to ocm to see if it works:
	//*(ocm_base) = value;
	//*(ocm_base+1) = value;
	//*(ocm_base+2) = value;
	//*(ocm_base+3) = value;

	//writing sigma_6 values into ocm:
	/*for(int i = 0; i < 128; i = i + 2){ //this starts at 1C0;
		*(ocm_base+i+865) = 0x11111111;//(uint32_t)(SIGMA6[i] >> 32); //upper
		*(ocm_base+i+1+865) = 0x22222222;//(uint32_t)SIGMA6[i]; //lower //1c0
	}*/
	//*(ocm_base+10) = 0x12345678;
	//*(ocm_base+1) = 0x22222222;
	//*(ocm_base+2) = 0x11111111;
	//*(ocm_base+3) = 0x22222222;
	//*(ocm_base+4) = 0x11111111;
	//*(ocm_base+5) = 0x22222222;
	//*(ocm_base+200) = 0x33333333;
	//*(ocm_base+250) = 0x33333333;
	//*(ocm_base+300) = 0x33333333; //this is 4B0
	//*(ocm_base+350) = 0x33333333; //this is 578, I want CF0 = 828
	//found the location of the actual hex file!!
	// the noise channel location starts at D80, D84
	//conversion: D80 =
	//D84 =
	//1600 =
	//2c0 maps to 1600
	volatile uint32_t total_bit_errors = 0;
	volatile double BER = 0.0;
	//printing a range of values to see where the total_bits are located
	volatile int count = 0; //should be at 144
	//while(count < 146){
		//total_bits = *(ocm_base+130+count);
		//total_bit_errors = *(ocm_base+404);
		total_bit_errors = *(ocm_base+864);
		total_bit_errors = *(ocm_base+865); //this is 8 //this is 6991a1e1
		total_bits = *(ocm_base+1408); //this is 12 //this is 2C0 in quartus total bits:
		total_bit_errors = *(ocm_base+1412); // this is 14 1610
//count = count + 2;
		//BER = ((double) total_bit_errors) / ((double) total_bits);
		//alt_printf("total bits: %x\n", total_bits);
		//alt_printf("total bit errors: %x\n", total_bit_errors);
	//}
	alt_printf("total bit errors: %x\n", total_bit_errors);
  return 0;
}

