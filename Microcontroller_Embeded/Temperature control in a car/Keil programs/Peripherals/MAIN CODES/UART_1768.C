#include <LPC17xx.h>
#include <RTL.h>
#include <stdio.h>
#include "UART.H"

void UART0_SendString(char *ptr)
{
	while(*ptr!='\0')
	{
		UART0_SendChar(*ptr);
		ptr++;
	}
}

void UART0_SendChar(char a)
{
	while(!(LPC_UART0->LSR&0x20));
	LPC_UART0->THR=a;
}

char UART0_RecieveChar()
{
	char x;
	while(!(LPC_UART0->LSR&0x01));
	x=LPC_UART0->RBR;
	os_dly_wait(1);
	return x;
}

void UART0_Init(void) 
{ 
		LPC_PINCON->PINSEL0 |= 0x00000050;
	
		LPC_UART0->LCR = 0x00000083;	// 8-bit data, 1 stop bit, no parity, DLAB=1
    LPC_UART0->DLL = 0x13;      	//select baud rate 9600 bps
    LPC_UART0->DLM = 0X00;
		LPC_UART0->LCR = 0X00000003;	// DLAB=0
}
