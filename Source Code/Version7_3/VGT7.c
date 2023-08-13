/*******************************************************
This program was created by the
CodeWizardAVR V3.12 Advanced
Automatic Program Generator
� Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project :
Version :
Date    : 15-Apr-2017
Author  :
Company :
Comments:


Chip type               : ATmega64A
Program type            : Application
AVR Core Clock frequency: 14.745600 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 1024
*******************************************************/

#include  <mega64a.h>
#include  <stdlib.h>
#include  <delay.h>
#include  <string.h>


#define   Re1     PORTA.0            ///////////////// Relay FLASHER  ///////////////////
#define   Re2     PORTA.1            ////////////////  UP   /////////////////////////////
#define   Re3     PORTA.2            //////////////// COM   /////////////////////////////
#define   Re4     PORTA.3            //////////////// Down //////////////////////////////
#define   free1   PORTA.4            ////////////////////////////////////////////////////
#define   free2   PORTA.5            ////////////////////////////////////////////////////
#define   WRST    PORTA.6            ////////////////// Wifi Reset //////////////////////
#define   LEDS1   PORTA.7            ////////////////   YELLOW LED //////////////////////

#define   photo   PINF.7             /////////////////// PHOTO SESNRO ///////////////////
#define   Mstop   PINF.2             /////////////////// Motor Stop  ////////////////////

#define   DS1     PINC.0             /////////////// Dip Switch /////////////////////////
#define   DS2     PINC.1
#define   DS3     PINC.2
#define   DS4     PINC.3
#define   DS5     PINC.4
#define   DS6     PINC.5             ////////////// Dip 6 = ETH /////////////////////////
#define   LEDS2   PORTC.6            /////////////  RED LED /////////////////////////////
#define   BUZZ    PORTC.7            ////////////////////////////////////////////////////

#define   RF1     PINB.2             /////////////// Rf = Radio Frequntly ///////////////
#define   RF2     PINB.3             //////////////// ALARM Button///////////////////////
#define   RF3     PINB.4             //////////////// Silent Button//////////////////////
#define   RF4     PINB.5             //////////////// Open Button////////////////////////
#define   RF5     PINB.6             /////////////// Close Button////////////////////////
#define   RF6     PINB.7             ////////////////////////////////////////////////////

#define   SW1     PIND.0             /////////////// Switch1 ////////////////////////////
#define   SW2     PIND.1             ////////////// Switch2 /////////////////////////////
#define   SPB1    PIND.6             ///////////// Push Button 1 ////////////////////////
#define   SPB2    PIND.7             ////////////  Push Button 2 ////////////////////////
#define   SUP     PIND.4             //////////// Switch Up /////////////////////////////
#define   SDW     PIND.5             //////////// Switch Down ///////////////////////////

char E;

#define DATA_REGISTER_EMPTY (1<<UDRE0)
#define RX_COMPLETE (1<<RXC0)
#define FRAMING_ERROR (1<<FE0)
#define PARITY_ERROR (1<<UPE0)
#define DATA_OVERRUN (1<<DOR0)

// USART0 Receiver buffer
#define RX_BUFFER_SIZE0 64
char rx_buffer0[RX_BUFFER_SIZE0];

#if RX_BUFFER_SIZE0 <= 256
unsigned char rx_wr_index0=0,rx_rd_index0=0;
#else
unsigned int rx_wr_index0=0,rx_rd_index0=0;
#endif

#if RX_BUFFER_SIZE0 < 256
unsigned char rx_counter0=0;
#else
unsigned int rx_counter0=0;
#endif

// This flag is set on USART0 Receiver buffer overflow
bit rx_buffer_overflow0;

// USART0 Receiver interrupt service routine
interrupt [USART0_RXC] void usart0_rx_isr(void)
{
char status,data;
status=UCSR0A;
data=UDR0;
if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
   {
   rx_buffer0[rx_wr_index0++]=data;
#if RX_BUFFER_SIZE0 == 256
   // special case for receiver buffer size=256
   if (++rx_counter0 == 0) rx_buffer_overflow0=1;
#else
   if (rx_wr_index0 == RX_BUFFER_SIZE0) rx_wr_index0=0;
   if (++rx_counter0 == RX_BUFFER_SIZE0)
      {
      rx_counter0=0;
      rx_buffer_overflow0=1;
      }
#endif
   }
}

#ifndef _DEBUG_TERMINAL_IO_
// Get a character from the USART0 Receiver buffer
#define _ALTERNATE_GETCHAR_
#pragma used+
char getchar(void)
{
char data;
while (rx_counter0==0);
data=rx_buffer0[rx_rd_index0++];
#if RX_BUFFER_SIZE0 != 256
if (rx_rd_index0 == RX_BUFFER_SIZE0) rx_rd_index0=0;
#endif
#asm("cli")
--rx_counter0;
#asm("sei")
return data;
}
#pragma used-
#endif

// USART0 Transmitter buffer
#define TX_BUFFER_SIZE0 64
char tx_buffer0[TX_BUFFER_SIZE0];

#if TX_BUFFER_SIZE0 <= 256
unsigned char tx_wr_index0=0,tx_rd_index0=0;
#else
unsigned int tx_wr_index0=0,tx_rd_index0=0;
#endif

#if TX_BUFFER_SIZE0 < 256
unsigned char tx_counter0=0;
#else
unsigned int tx_counter0=0;
#endif

// USART0 Transmitter interrupt service routine
interrupt [USART0_TXC] void usart0_tx_isr(void)
{
if (tx_counter0)
   {
   --tx_counter0;
   UDR0=tx_buffer0[tx_rd_index0++];
#if TX_BUFFER_SIZE0 != 256
   if (tx_rd_index0 == TX_BUFFER_SIZE0) tx_rd_index0=0;
#endif
   }
}

#ifndef _DEBUG_TERMINAL_IO_
// Write a character to the USART0 Transmitter buffer
#define _ALTERNATE_PUTCHAR_
#pragma used+
void putchar(char c)
{
while (tx_counter0 == TX_BUFFER_SIZE0);
#asm("cli")
if (tx_counter0 || ((UCSR0A & DATA_REGISTER_EMPTY)==0))
   {
   tx_buffer0[tx_wr_index0++]=c;
#if TX_BUFFER_SIZE0 != 256
   if (tx_wr_index0 == TX_BUFFER_SIZE0) tx_wr_index0=0;
#endif
   ++tx_counter0;
   }
else
   UDR0=c;
#asm("sei")
}
#pragma used-
#endif

// USART1 Receiver buffer
#define RX_BUFFER_SIZE1 64
char rx_buffer1[RX_BUFFER_SIZE1];

#if RX_BUFFER_SIZE1 <= 256
unsigned char rx_wr_index1=0,rx_rd_index1=0;
#else
unsigned int rx_wr_index1=0,rx_rd_index1=0;
#endif

#if RX_BUFFER_SIZE1 < 256
unsigned char rx_counter1=0;
#else
unsigned int rx_counter1=0;
#endif

// This flag is set on USART1 Receiver buffer overflow
bit rx_buffer_overflow1;

// USART1 Receiver interrupt service routine
interrupt [USART1_RXC] void usart1_rx_isr(void)
{
char status,data;
status=UCSR1A;
data=UDR1;
if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
   {
   rx_buffer1[rx_wr_index1++]=data;
#if RX_BUFFER_SIZE1 == 256
   // special case for receiver buffer size=256
   if (++rx_counter1 == 0) rx_buffer_overflow1=1;
#else
   if (rx_wr_index1 == RX_BUFFER_SIZE1) rx_wr_index1=0;
   if (++rx_counter1 == RX_BUFFER_SIZE1)
      {
      rx_counter1=0;
      rx_buffer_overflow1=1;
      }
#endif
   }
}

// Get a character from the USART1 Receiver buffer
#pragma used+
char getchar1(void)
{
char data;
while (rx_counter1==0);
data=rx_buffer1[rx_rd_index1++];
#if RX_BUFFER_SIZE1 != 256
if (rx_rd_index1 == RX_BUFFER_SIZE1) rx_rd_index1=0;
#endif
#asm("cli")
--rx_counter1;
#asm("sei")
return data;
}
#pragma used-
// USART1 Transmitter buffer
#define TX_BUFFER_SIZE1 64
char tx_buffer1[TX_BUFFER_SIZE1];

#if TX_BUFFER_SIZE1 <= 256
unsigned char tx_wr_index1=0,tx_rd_index1=0;
#else
unsigned int tx_wr_index1=0,tx_rd_index1=0;
#endif

#if TX_BUFFER_SIZE1 < 256
unsigned char tx_counter1=0;
#else
unsigned int tx_counter1=0;
#endif

// USART1 Transmitter interrupt service routine
interrupt [USART1_TXC] void usart1_tx_isr(void)
{
if (tx_counter1)
   {
   --tx_counter1;
   UDR1=tx_buffer1[tx_rd_index1++];
#if TX_BUFFER_SIZE1 != 256
   if (tx_rd_index1 == TX_BUFFER_SIZE1) tx_rd_index1=0;
#endif
   }
}

// Write a character to the USART1 Transmitter buffer
#pragma used+
void putchar1(char c)
{
while (tx_counter1 == TX_BUFFER_SIZE1);
#asm("cli")
if (tx_counter1 || ((UCSR1A & DATA_REGISTER_EMPTY)==0))
   {
   tx_buffer1[tx_wr_index1++]=c;
#if TX_BUFFER_SIZE1 != 256
   if (tx_wr_index1 == TX_BUFFER_SIZE1) tx_wr_index1=0;
#endif
   ++tx_counter1;
   }
else
   UDR1=c;
#asm("sei")
}
#pragma used-

// Standard Input/Output functions
#include <stdio.h>

unsigned int adc_data;
// Voltage Reference: AVCC pin
#define ADC_VREF_TYPE ((0<<REFS1) | (1<<REFS0) | (0<<ADLAR))

// ADC interrupt service routine
interrupt [ADC_INT] void adc_isr(void)
{
// Read the AD conversion result
adc_data=ADCW;
}

// Read the AD conversion result
// with noise canceling
unsigned int read_adc(unsigned char adc_input)
{
ADMUX=adc_input | ADC_VREF_TYPE;
// Delay needed for the stabilization of the ADC input voltage
delay_us(10);
#asm
    in   r30,mcucr
    cbr  r30,__sm_mask
    sbr  r30,__se_bit | __sm_adc_noise_red
    out  mcucr,r30
    sleep
    cbr  r30,__se_bit
    out  mcucr,r30
#endasm
return adc_data;
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void motorright() // Close
{
    if (RF3==1 || SPB1==1)
    {
            while(1)
            {
            Re2=1;
            Re1=1;
                        if (Mstop == 1 || RF2 == 1)
                        {
                        Re2=0;
                        Re3=0;
                        Re4=0;
                        Re1=0;
                        delay_ms(10);
                        break;
                        }
                        if (SUP==1)
                        {
                        Re2=0;
                        Re1=0;
                        delay_ms(10);
                        break;
                        }
                        if (photo==1)
                        {
                            Re1=0;
                            Re2=0;
                            delay_ms(2000);
                            if (DS1==1)
                            {
                                while(1)
                                {
                                Re4=1;
                                delay_ms(10);
                                Re1=1;
                                delay_ms(10);
                                    if (Mstop == 1 || RF2 == 1)
                                    {
                                    Re2=0;
                                    Re3=0;
                                    Re4=0;
                                    Re1=0;
                                    delay_ms(10);
                                    break;
                                    }
                                    if (SDW==1)
                                    {
                                    Re4=0;
                                    delay_ms(10);
                                    Re1=0;
                                    delay_ms(10);
                                    Re2=0;
                                    BUZZ=1;
                                    delay_ms(3000);
                                    break;
                                    }
                                }
                            }
                            else if (DS1==0)
                            {
                              while(1)
                              {
                                Re4=1;
                                delay_ms(10);
                                Re1=1;
                                delay_ms(10);
                                if (Mstop == 1 || RF2 == 1)
                                {
                                Re2=0;
                                Re3=0;
                                Re4=0;
                                Re1=0;
                                delay_ms(10);
                                break;
                                }
                                if (SDW==1)
                                {
                                Re4=0;
                                delay_ms(10);
                                Re1=0;
                                delay_ms(10);
                                Re2=0;
                                BUZZ=1;
                                delay_ms(9500);
                                    while(1)
                                    {
                                        Re2=1;
                                        Re1=1;
                                        if (Mstop == 1 || RF2 == 1)
                                        {
                                        Re2=0;
                                        Re3=0;
                                        Re4=0;
                                        Re1=0;
                                        delay_ms(10);
                                        break;
                                        }
                                        if (SUP==1)
                                        {
                                        Re2=0;
                                        Re1=0;
                                        delay_ms(10);
                                        break;
                                        }

                                    }
                                break;
                                }
                              }

                            break;

                            }
                        }
            }
    }
}

void motorleft() // Open
    {
        if (RF4==1 || SPB2==1)
        {
                while(1)
                {
                Re4=1;
                Re1=1;
                        if (Mstop == 1)
                        {
                        Re2=0;
                        Re3=0;
                        Re4=0;
                        Re1=0;
                        delay_ms(10);
                        break;
                        }
                        if (SDW==1 || RF2==1)
                        {
                        Re4=0;
                        Re1=0;
                        delay_ms(10);
                        break;
                        }
                        else
                        {
                        continue;
                        }
                }
        }
        else
        {
        //Re4=0;
        //Re1=0;
        }
    }

void motor()
    {
    motorright();
    motorleft();
    }

void TCP()
    {
      E=getchar();
      if(E == 'X')
      {
       printf(
       "$%1d%1d%1d%1d%1d%1d,%1d%1d%1d%1d%1d%1d,%1d%1d,%1d%1d%1d%1d%1d%1d%1d%1d\n\r",
       PINC.0,PINC.1,PINC.2,PINC.3,PINC.4,PINC.5,PINB.1,
       PINB.2,PINB.3,PINB.4,PINB.5,PINB.6,PIND.0,PIND.1,PIND.6,PIND.7,PIND.4,PIND.5,PINF.7,PINF.2,PINF.5,PINF.6);
      }
      if( E == 'C' )
      {
                while(1)
            {
            Re2=1;
            Re1=1;
                        if (Mstop == 1 || RF2 == 1)
                        {
                        Re2=0;
                        Re3=0;
                        Re4=0;
                        Re1=0;
                        delay_ms(10);
                        break;
                        }
                        if (SUP==1)
                        {
                        Re2=0;
                        Re1=0;
                        delay_ms(10);
                        break;
                        }
                        if (photo==1)
                        {
                            Re1=0;
                            Re2=0;
                            delay_ms(2000);
                            if (DS1==1)
                            {
                                while(1)
                                {
                                Re4=1;
                                delay_ms(10);
                                Re1=1;
                                delay_ms(10);
                                    if (Mstop == 1 || RF2 == 1)
                                    {
                                    Re2=0;
                                    Re3=0;
                                    Re4=0;
                                    Re1=0;
                                    delay_ms(10);
                                    break;
                                    }
                                    if (SDW==1)
                                    {
                                    Re4=0;
                                    delay_ms(10);
                                    Re1=0;
                                    delay_ms(10);
                                    Re2=0;
                                    BUZZ=1;
                                    delay_ms(3000);
                                    break;
                                    }
                                }
                            }
                            else if (DS1==0)
                            {
                              while(1)
                              {
                                Re4=1;
                                delay_ms(10);
                                Re1=1;
                                delay_ms(10);
                                if (Mstop == 1 || RF2 == 1)
                                {
                                Re2=0;
                                Re3=0;
                                Re4=0;
                                Re1=0;
                                delay_ms(10);
                                break;
                                }
                                if (SDW==1)
                                {
                                Re4=0;
                                delay_ms(10);
                                Re1=0;
                                delay_ms(10);
                                Re2=0;
                                BUZZ=1;
                                delay_ms(9500);
                                    while(1)
                                    {
                                        Re2=1;
                                        Re1=1;
                                        if (Mstop == 1 || RF2 == 1)
                                        {
                                        Re2=0;
                                        Re3=0;
                                        Re4=0;
                                        Re1=0;
                                        delay_ms(10);
                                        break;
                                        }
                                        if (SUP==1)
                                        {
                                        Re2=0;
                                        Re1=0;
                                        delay_ms(10);
                                        break;
                                        }

                                    }
                                break;
                                }
                              }

                            break;

                            }
                        }
            }
      }
      else if( E == 'O' )
      {
                while(1)
                {
                Re4=1;
                Re1=1;
                        if (Mstop == 1)
                        {
                        Re2=0;
                        Re3=0;
                        Re4=0;
                        Re1=0;
                        delay_ms(10);
                        break;
                        }
                        if (SDW==1 || RF2==1)
                        {
                        Re4=0;
                        Re1=0;
                        delay_ms(10);
                        break;
                        }
                        else
                        {
                        continue;
                        }
                }
        }

      else if(E == 'S' )
      {
                Re4=0;
                Re1=0;
                Re2=0;
      }
      else if( E == 'A' )
      {
      Re1 = (Re1 == 1)?0:1;
      }
      else if( E == 'B' )
      {
      Re2 = (Re2 == 1)?0:1;
      }
      else if( E == 'D' )
      {
      Re3 = (Re3 == 1)?0:1;
      }
      else if( E == 'E' )
      {
      Re4 = (Re4 == 1)?0:1;
      }
      else if( E == 'F' )
      {
      BUZZ = (BUZZ == 1)?0:1;
      }
      else if( E == 'G' )
      {
      LEDS2 = (LEDS2 == 1)?0:1;
      }
      else if( E == 'H' )
      {
      LEDS1 = (LEDS1 == 1)?0:1;
      }
    }
void Run()
    {
        LEDS1=!LEDS1; delay_ms(100);
        LEDS2=!LEDS2; delay_ms(100);
        LEDS1=!LEDS1; delay_ms(100);
        LEDS2=!LEDS2; delay_ms(100);
        LEDS1=!LEDS1; delay_ms(100);
        LEDS2=!LEDS2; delay_ms(100);
        LEDS1=!LEDS1; delay_ms(100);
        LEDS2=!LEDS2; delay_ms(100);
        LEDS1=!LEDS1; delay_ms(100);
        LEDS2=!LEDS2; delay_ms(100);
        LEDS1=!LEDS1; delay_ms(100);
        LEDS2=!LEDS2; delay_ms(100);
        LEDS1=!LEDS1; delay_ms(100);
        LEDS2=!LEDS2; delay_ms(100);
        LEDS1=1;
        LEDS2=0;
        BUZZ=0;
        delay_ms(60);
        BUZZ=1;
        delay_ms(15);
    }

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void main(void)
{
// Declare your local variables here

// Input/Output Ports initialization
// Port A initialization
// Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
DDRA=(1<<DDA7) | (1<<DDA6) | (1<<DDA5) | (1<<DDA4) | (1<<DDA3) | (1<<DDA2) | (1<<DDA1) | (1<<DDA0);
// State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);

// Port B initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

// Port C initialization
// Function: Bit7=Out Bit6=Out Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
DDRC=(1<<DDC7) | (1<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
// State: Bit7=1 Bit6=0 Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
PORTC=(1<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

// Port D initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);

// Port E initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
DDRE=(0<<DDE7) | (0<<DDE6) | (0<<DDE5) | (0<<DDE4) | (0<<DDE3) | (0<<DDE2) | (0<<DDE1) | (0<<DDE0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
PORTE=(0<<PORTE7) | (0<<PORTE6) | (0<<PORTE5) | (0<<PORTE4) | (0<<PORTE3) | (0<<PORTE2) | (0<<PORTE1) | (0<<PORTE0);

// Port F initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
DDRF=(0<<DDF7) | (0<<DDF6) | (0<<DDF5) | (0<<DDF4) | (0<<DDF3) | (0<<DDF2) | (0<<DDF1) | (0<<DDF0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
PORTF=(0<<PORTF7) | (0<<PORTF6) | (0<<PORTF5) | (0<<PORTF4) | (0<<PORTF3) | (0<<PORTF2) | (0<<PORTF1) | (0<<PORTF0);

// Port G initialization
// Function: Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
DDRG=(0<<DDG4) | (0<<DDG3) | (0<<DDG2) | (0<<DDG1) | (0<<DDG0);
// State: Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
PORTG=(0<<PORTG4) | (0<<PORTG3) | (0<<PORTG2) | (0<<PORTG1) | (0<<PORTG0);

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
// Mode: Normal top=0xFF
// OC0 output: Disconnected
ASSR=0<<AS0;
TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
TCNT0=0x00;
OCR0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer1 Stopped
// Mode: Normal top=0xFFFF
// OC1A output: Disconnected
// OC1B output: Disconnected
// OC1C output: Disconnected
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
// Compare C Match Interrupt: Off
TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<COM1C1) | (0<<COM1C0) | (0<<WGM11) | (0<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;
OCR1CH=0x00;
OCR1CL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=0xFF
// OC2 output: Disconnected
TCCR2=(0<<WGM20) | (0<<COM21) | (0<<COM20) | (0<<WGM21) | (0<<CS22) | (0<<CS21) | (0<<CS20);
TCNT2=0x00;
OCR2=0x00;

// Timer/Counter 3 initialization
// Clock source: System Clock
// Clock value: Timer3 Stopped
// Mode: Normal top=0xFFFF
// OC3A output: Disconnected
// OC3B output: Disconnected
// OC3C output: Disconnected
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer3 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
// Compare C Match Interrupt: Off
TCCR3A=(0<<COM3A1) | (0<<COM3A0) | (0<<COM3B1) | (0<<COM3B0) | (0<<COM3C1) | (0<<COM3C0) | (0<<WGM31) | (0<<WGM30);
TCCR3B=(0<<ICNC3) | (0<<ICES3) | (0<<WGM33) | (0<<WGM32) | (0<<CS32) | (0<<CS31) | (0<<CS30);
TCNT3H=0x00;
TCNT3L=0x00;
ICR3H=0x00;
ICR3L=0x00;
OCR3AH=0x00;
OCR3AL=0x00;
OCR3BH=0x00;
OCR3BL=0x00;
OCR3CH=0x00;
OCR3CL=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
ETIMSK=(0<<TICIE3) | (0<<OCIE3A) | (0<<OCIE3B) | (0<<TOIE3) | (0<<OCIE3C) | (0<<OCIE1C);

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// INT2: Off
// INT3: Off
// INT4: Off
// INT5: Off
// INT6: Off
// INT7: Off
EICRA=(0<<ISC31) | (0<<ISC30) | (0<<ISC21) | (0<<ISC20) | (0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
EICRB=(0<<ISC71) | (0<<ISC70) | (0<<ISC61) | (0<<ISC60) | (0<<ISC51) | (0<<ISC50) | (0<<ISC41) | (0<<ISC40);
EIMSK=(0<<INT7) | (0<<INT6) | (0<<INT5) | (0<<INT4) | (0<<INT3) | (0<<INT2) | (0<<INT1) | (0<<INT0);

// USART0 initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART0 Receiver: On
// USART0 Transmitter: On
// USART0 Mode: Asynchronous
// USART0 Baud Rate: 115200
UCSR0A=(0<<RXC0) | (0<<TXC0) | (0<<UDRE0) | (0<<FE0) | (0<<DOR0) | (0<<UPE0) | (0<<U2X0) | (0<<MPCM0);
UCSR0B=(1<<RXCIE0) | (1<<TXCIE0) | (0<<UDRIE0) | (1<<RXEN0) | (1<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
UCSR0C=(0<<UMSEL0) | (0<<UPM01) | (0<<UPM00) | (0<<USBS0) | (1<<UCSZ01) | (1<<UCSZ00) | (0<<UCPOL0);
UBRR0H=0x00;
UBRR0L=0x07;

// USART1 initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART1 Receiver: On
// USART1 Transmitter: On
// USART1 Mode: Asynchronous
// USART1 Baud Rate: 115200
UCSR1A=(0<<RXC1) | (0<<TXC1) | (0<<UDRE1) | (0<<FE1) | (0<<DOR1) | (0<<UPE1) | (0<<U2X1) | (0<<MPCM1);
UCSR1B=(1<<RXCIE1) | (1<<TXCIE1) | (0<<UDRIE1) | (1<<RXEN1) | (1<<TXEN1) | (0<<UCSZ12) | (0<<RXB81) | (0<<TXB81);
UCSR1C=(0<<UMSEL1) | (0<<UPM11) | (0<<UPM10) | (0<<USBS1) | (1<<UCSZ11) | (1<<UCSZ10) | (0<<UCPOL1);
UBRR1H=0x00;
UBRR1L=0x07;

// Analog Comparator initialization
// Analog Comparator: Off
// The Analog Comparator's positive input is
// connected to the AIN0 pin
// The Analog Comparator's negative input is
// connected to the AIN1 pin
ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);

// ADC initialization
// ADC Clock frequency: 921.600 kHz
// ADC Voltage Reference: AVCC pin
ADMUX=ADC_VREF_TYPE;
ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (1<<ADIE) | (1<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
SFIOR=(0<<ACME);

// SPI initialization
// SPI disabled
SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);

// TWI initialization
// TWI disabled
TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);

// Global enable interrupts
#asm("sei")
Run();
while (1)
      {
        if ( DS6 == 0 )
        {
            if(rx_counter0 > 0)
            {
                TCP();
                motor();
            }
            else if (rx_counter0==0)
            {
                motor();
            }
        }
        else if ( DS6 == 1 )
        {
        motor();
        }

        if ( DS3 == 0 )
        {
            if ( SW2==0)
            {
            LEDS2=1;
            delay_ms(100);
            LEDS2=0;
            delay_ms(100);
            }
        }
        if ( DS2 == 0 )
        {
            if ( SW1==0)
            {
            BUZZ=0;
            delay_ms(100);
            BUZZ=1;
            delay_ms(100);
            }
        }

      }
}
