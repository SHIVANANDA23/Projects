#include <lpc17xx.h>
#include <RTL.h>
#include "ADC.h"

int adc_temp,h;
void Adc_Init(void)
{
    LPC_PINCON->PINSEL1 &= ~(0x11<<14);
    LPC_PINCON->PINSEL1 |= 0x01<<14;	//P0.23 as AD0.0
		LPC_SC->PCONP |= (1<<12);			//enable the peripheral ADC
}

int Adc_Read(void)
{
	LPC_ADC->ADCR = (1<<0)|(1<<21)|(1<<24);//0x01200001;	//ADC0.0, start conversion and operational	
  for(h=0;h<2000;h++);			//delay for conversion
  while((adc_temp = LPC_ADC->ADGDR) == 0x80000000);	//wait till 'done' bit is 1, indicates conversion complete
  adc_temp = LPC_ADC->ADGDR;
  adc_temp >>= 4;
  adc_temp &= 0x00000FFF;			//12 bit ADC
	return adc_temp;
}
