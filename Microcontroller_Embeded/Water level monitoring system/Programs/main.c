/*ARM COURSE PROJECT TEAM 13

SHIVANANDA BIRADARA   528
RACHANNA ULLAGADDI    529
SONAL                 530
ADITYA WALI           557

*/
#include <lpc214x.h>
#include <stdio.h>
#include "lib_funcs.h"

#define LOWER_THRESHOLD 10
#define sw1 0x00800000

#define delay() for(m=0;m<65000;m++);
#define bitset(x) (1<<x)
#define bitclr(x) (0<<x)

#define on 0x00000400
#define off 0x00000c00

#define TRIG (1<<5) //P0.5
#define ECHO (1<<4) //P0.4

void recieve();
int keypad();
void intTimer (void);
    unsigned long int var1,var2;
    unsigned int i,j,k,l,m=0;
//int distance=0;
    void intTimer(void)
    {
        T0PR=11999;
        T0MR0=50000;
        T0MCR=3;
        T0TCR=2;
    }

    void recieve()
    {
			  printf("MEASURE THE Height of WATER\r\n");
        //Output 10us HIGH on TRIG pin
        int I,distance;
				int echoTime=0;

        IO0SET |= TRIG;
        delayUS(10);
        IO0CLR |= TRIG;

        while(!(IO0PIN & ECHO)); //Wait for a HIGH on ECHO pin
        startTimer0(); //Start counting
        while(IO0PIN & ECHO); //Wait for a LOW on ECHO pin
        echoTime = stopTimer0(); //Stop counting and save value(us) in echoTime
        distance = (.0343 * echoTime)/2; //Find the distance

        printf("Height of WATER = %d cm\r\n",distance);

        delayMS(1000); //wait 1 second for next update
                if((IOPIN1&sw1)!=sw1)
                    {
                        printf("WATER SUPPLAY IS THERE\r\n");
                        I=keypad();
                        if(I==1)
                            {
                                IOSET0|=on;
                                delay();
                            }
                        else if(I==0)
                            IOCLR0=off;
												else
												;
                    }
								else 
								{
									printf("Water supply unavialable\r\n");
									if((IOPIN0&off)!=off)
									{
										printf("PLEASE TURN OFF MOTOR TO SAVE MOTOR DURABILITY\r\n");
                        I=keypad();
                        if(I==1)
                            {
                                printf("Instruction Override: Motor is turning off\r\n ");
                                IOCLR0=off;
                            }
                        else
                            {
                                IOCLR0=off;
                            }
								  }
									else
									{
										printf("Motor is off\r\n");
									}
            }
       /* else
            {
                if((IOPIN0&on)==on)
                    {
                        printf("Water supply unavialable\r\n Please turn off The Motor\r\n");
                        I=keypad();
                        if(I==1)
                            {
                                printf("Instruction Override: Motor is turning off\r\n ");
                                IOCLR0=off;
                            }
                        else
                            {
                                IOCLR0=off;
                            }
                    }
                else
                    {
                        printf ("Water supply unavialable\r\n");
                    }
            }
    }*/
	}

 int keypad()
    {
        int value,i;
        unsigned int row0[4]= {0x006e0000,0x006d0000,0x006b0000,0x00670000};
        while(1)
            {
                IO1PIN=0x006F0000;  //01101111
                value=IO1PIN;
                delay();
                delay();
                value=value&0x007F0000;
                for(i=0; i<4; i++)
                    {
                        if(value==row0[i])
                            {
                                return (i);

                            }
                    }
            }

    }

    int main(void)
    {
        PINSEL0 = 0x000FFFFF;		//P0.12 to P0.15 GPIo
			  PINSEL1=0X00;
			  PINSEL2=0X0;
        IO0DIR |= 0x0000FC00;		//P0.12 to P0.15 
			  IODIR1=  0x00700000;
			  IOSET1|=0X00800000;
        IO0SET =0X00000100; 	//P0.8 should always high.
        initClocks(); //Set PCLK = CCLK = 60Mhz - used by: UART, Timer and ADC
        initUART0();  //Initialize UART0 for retargeted printf()
        initTimer0(); //Init Timer for delay functions

        IO0DIR |= TRIG;    //Set P0.2(TRIG) as output
        IO0DIR &= ~(ECHO); //Set P0.3(ECHO) as input (explicitly)
        IO0SET |= TRIG;    //Set P0.2 LOW initially

        printf("WATER LEVEL CHECKER \r\n");
        delayMS(1000);//Wait for GPIO to be stable
        while(1)
            {
                recieve();
            }
    }

		