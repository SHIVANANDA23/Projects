#include <RTL.h>                        // RTX kernel functions & defines      
#include <LPC17xx.h>                    // LPC17xx definitions                 
#include <stdio.h>
#include "UART.H"
#include "DC.H"
#include "BUZ.H"
#include "TIMER.H"
#include "ADC.H"
#include "LCD.H"

#define led_init() LPC_GPIO2->FIODIR |= 0x00000001;		 //p2.0 is output
#define LED_ON() LPC_GPIO2->FIOSET = 0x01	//Set P2.0 bit
#define LED_OFF() LPC_GPIO2->FIOCLR =  0x01	//clear P2.0 bit
	

int i;
char x[33],x1[33];
OS_TID t1,t2,t3;
OS_RESULT RE2,RE3;
OS_SEM sem1;

void System_Init(void);
__task void task1(void);
__task void task2(void);
__task void task3(void);

// UART FUNCTION PROTOTYPES

extern void UART0_Init(void);
extern void UART0_SendString(char *ptr);
extern void UART0_SendChar(char a);
extern char UART0_RecieveChar(void);

//DC MOTOR FUNCTION PROTYPES

extern void DC_Init(void);
extern void ANTICLOCK_WISE(void);
extern void CLOCK_WISE(void);

//BUZZER FUNCTION PROTOTYPE

extern void BUZZER_init(void);
extern void BUZZER_On(int duration);
extern void BUZZER_Off(int duration);

//LCD FUNCTION PROTOTYPES

extern void lcd_init(void);
extern void wr_cn(void);
extern void clr_disp(void);
extern void delay_lcd(int);
extern void lcd_com(void);						   
extern void wr_dn(void);
extern void lcd_data(void);
extern void clear_ports(void);
extern void lcd_puts(char *);
extern void Lcd_new_line(void);
//TIMER0 

extern void Timer0_Init(void);
extern void delayms(unsigned int milliseconds);

//ADC

extern void Adc_Init(void);
extern int Adc_Read(void);

void Ext_Int_init(void)
{
	LPC_PINCON->PINSEL4 = 0x04000000;
	LPC_SC->EXTINT = 0x00000008;		//writing 1 cleares the interrupt, get set if there is interrupt
	LPC_SC->EXTMODE = 0x00000008;		//EINT3 is initiated as edge senitive, 0 for level sensitive
	LPC_SC->EXTPOLAR = 0x00000000;		//EINT3 is falling edge sensitive, 1 for rising edge
	NVIC_EnableIRQ(EINT3_IRQn);
}

 void EINT3_IRQHandler(void)
 {
	 //Do some work
	UART0_SendString("\nTurning off the ac To save the charge\n");
	//ANTICLOCK_WISE(); 
	 sprintf(x,"Turning off ac");
	 Lcd_new_line();
	 lcd_puts(x);
	LPC_SC->EXTINT = 0x00000008;	//cleares the interrupt
 }

void System_Init(void)
{
	Timer0_Init();
	Ext_Int_init();
	UART0_Init();
	DC_Init();
	BUZZER_init();
	Adc_Init();
	lcd_init();
	led_init();
}

__task void task1(void)
{
	t1=os_tsk_self();
	t2=os_tsk_create(task2,0);
	t3=os_tsk_create(task3,0);
	while(1)
	{
		os_sem_wait(sem1,0x5);
		clr_disp();
		i=Adc_Read();
		i=i/100;
		sprintf(x1,"TEMP : %d\n",i);
		lcd_puts(x1);
		os_dly_wait(1);
		UART0_SendString(x1);
		if(i<25)
		{
			os_evt_set(0x002,t2);
			os_sem_send(sem1);
		}
		else if(i>25 && i<35)
		{
			os_evt_set(0x001,t3);
			os_sem_send(sem1);
		}
		else if (i>35)
		{
			CLOCK_WISE();
			LED_OFF();
			UART0_SendString("oooh! closing windows Turning on the ac\n");
			sprintf(x,"Closing windows");
			Lcd_new_line();
			lcd_puts(x);
			sprintf(x,"Turning on ac");
	    Lcd_new_line();
	    lcd_puts(x);
		}
		os_dly_wait(1);
	}

}

__task void task2(void)
{
	
	RE2 = os_evt_wait_and(0x002,0xffff);
	while(1)
 {
	if(RE2==OS_R_EVT)
	{
			 if(i<25)
		  {
		    LED_ON();
		    UART0_SendString("Closing windows there is very cold\n");
				sprintf(x,"Closing windows");
			  Lcd_new_line();
			  lcd_puts(x);
		   // os_dly_wait(1);	
		    UART0_SendString(x1);
		   //os_evt_clr(0x002,t2);
		  }
	}
	os_sem_send(sem1);
	}
}

__task void task3(void)
{
	RE3 = os_evt_wait_and(0x001,0xffff);
	while(1)
 {
	if(RE3==OS_R_EVT)
	{
		
		 if(i>25 && i<35)
			{
		   LED_OFF();
	     UART0_SendString("Opening windows\n");
				sprintf(x,"Opening windows");
				Lcd_new_line();
				lcd_puts(x);
		   //os_dly_wait(1);
		   UART0_SendString(x1);
		   //os_evt_clr(0x001,t3);
			}
		}
	os_sem_send(sem1);
	}
}

int main()
{
  System_Init();
	os_sem_init(sem1,3);
	os_sys_init(task1);
}
