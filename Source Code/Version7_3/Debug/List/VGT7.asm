
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega64A
;Program type           : Application
;Clock frequency        : 14.745600 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 1024 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega64A
	#pragma AVRPART MEMORY PROG_FLASH 65536
	#pragma AVRPART MEMORY EEPROM 2048
	#pragma AVRPART MEMORY INT_SRAM SIZE 4096
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU XMCRA=0x6D
	.EQU XMCRB=0x6C

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x10FF
	.EQU __DSTACK_SIZE=0x0400
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _E=R5
	.DEF _rx_wr_index0=R4
	.DEF _rx_rd_index0=R7
	.DEF _rx_counter0=R6
	.DEF _tx_wr_index0=R9
	.DEF _tx_rd_index0=R8
	.DEF _tx_counter0=R11
	.DEF _rx_wr_index1=R10
	.DEF _rx_rd_index1=R13
	.DEF _rx_counter1=R12

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _usart0_rx_isr
	JMP  0x00
	JMP  _usart0_tx_isr
	JMP  _adc_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _usart1_rx_isr
	JMP  0x00
	JMP  _usart1_tx_isr
	JMP  0x00
	JMP  0x00

_tbl10_G102:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G102:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0

_0x0:
	.DB  0x24,0x25,0x31,0x64,0x25,0x31,0x64,0x25
	.DB  0x31,0x64,0x25,0x31,0x64,0x25,0x31,0x64
	.DB  0x25,0x31,0x64,0x2C,0x25,0x31,0x64,0x25
	.DB  0x31,0x64,0x25,0x31,0x64,0x25,0x31,0x64
	.DB  0x25,0x31,0x64,0x25,0x31,0x64,0x2C,0x25
	.DB  0x31,0x64,0x25,0x31,0x64,0x2C,0x25,0x31
	.DB  0x64,0x25,0x31,0x64,0x25,0x31,0x64,0x25
	.DB  0x31,0x64,0x25,0x31,0x64,0x25,0x31,0x64
	.DB  0x25,0x31,0x64,0x25,0x31,0x64,0xA,0xD
	.DB  0x0
_0x2000060:
	.DB  0x1
_0x2000000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x0A
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x01
	.DW  __seed_G100
	.DW  _0x2000060*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30
	STS  XMCRB,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x500

	.CSEG
;/*******************************************************
;This program was created by the
;CodeWizardAVR V3.12 Advanced
;Automatic Program Generator
;© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 15-Apr-2017
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega64A
;Program type            : Application
;AVR Core Clock frequency: 14.745600 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 1024
;*******************************************************/
;
;#include  <mega64a.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
;#include  <stdlib.h>
;#include  <delay.h>
;#include  <string.h>
;
;
;#define   Re1     PORTA.0            ///////////////// Relay FLASHER  ///////////////////
;#define   Re2     PORTA.1            ////////////////  UP   /////////////////////////////
;#define   Re3     PORTA.2            //////////////// COM   /////////////////////////////
;#define   Re4     PORTA.3            //////////////// Down //////////////////////////////
;#define   free1   PORTA.4            ////////////////////////////////////////////////////
;#define   free2   PORTA.5            ////////////////////////////////////////////////////
;#define   WRST    PORTA.6            ////////////////// Wifi Reset //////////////////////
;#define   LEDS1   PORTA.7            ////////////////   YELLOW LED //////////////////////
;
;#define   photo   PINF.7             /////////////////// PHOTO SESNRO ///////////////////
;#define   Mstop   PINF.2             /////////////////// Motor Stop  ////////////////////
;
;#define   DS1     PINC.0             /////////////// Dip Switch /////////////////////////
;#define   DS2     PINC.1
;#define   DS3     PINC.2
;#define   DS4     PINC.3
;#define   DS5     PINC.4
;#define   DS6     PINC.5             ////////////// Dip 6 = ETH /////////////////////////
;#define   LEDS2   PORTC.6            /////////////  RED LED /////////////////////////////
;#define   BUZZ    PORTC.7            ////////////////////////////////////////////////////
;
;#define   RF1     PINB.2             /////////////// Rf = Radio Frequntly ///////////////
;#define   RF2     PINB.3             //////////////// ALARM Button///////////////////////
;#define   RF3     PINB.4             //////////////// Silent Button//////////////////////
;#define   RF4     PINB.5             //////////////// Open Button////////////////////////
;#define   RF5     PINB.6             /////////////// Close Button////////////////////////
;#define   RF6     PINB.7             ////////////////////////////////////////////////////
;
;#define   SW1     PIND.0             /////////////// Switch1 ////////////////////////////
;#define   SW2     PIND.1             ////////////// Switch2 /////////////////////////////
;#define   SPB1    PIND.6             ///////////// Push Button 1 ////////////////////////
;#define   SPB2    PIND.7             ////////////  Push Button 2 ////////////////////////
;#define   SUP     PIND.4             //////////// Switch Up /////////////////////////////
;#define   SDW     PIND.5             //////////// Switch Down ///////////////////////////
;
;char E;
;
;#define DATA_REGISTER_EMPTY (1<<UDRE0)
;#define RX_COMPLETE (1<<RXC0)
;#define FRAMING_ERROR (1<<FE0)
;#define PARITY_ERROR (1<<UPE0)
;#define DATA_OVERRUN (1<<DOR0)
;
;// USART0 Receiver buffer
;#define RX_BUFFER_SIZE0 64
;char rx_buffer0[RX_BUFFER_SIZE0];
;
;#if RX_BUFFER_SIZE0 <= 256
;unsigned char rx_wr_index0=0,rx_rd_index0=0;
;#else
;unsigned int rx_wr_index0=0,rx_rd_index0=0;
;#endif
;
;#if RX_BUFFER_SIZE0 < 256
;unsigned char rx_counter0=0;
;#else
;unsigned int rx_counter0=0;
;#endif
;
;// This flag is set on USART0 Receiver buffer overflow
;bit rx_buffer_overflow0;
;
;// USART0 Receiver interrupt service routine
;interrupt [USART0_RXC] void usart0_rx_isr(void)
; 0000 005E {

	.CSEG
_usart0_rx_isr:
; .FSTART _usart0_rx_isr
	CALL SUBOPT_0x0
; 0000 005F char status,data;
; 0000 0060 status=UCSR0A;
	ST   -Y,R17
	ST   -Y,R16
;	status -> R17
;	data -> R16
	IN   R17,11
; 0000 0061 data=UDR0;
	IN   R16,12
; 0000 0062 if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x3
; 0000 0063    {
; 0000 0064    rx_buffer0[rx_wr_index0++]=data;
	MOV  R30,R4
	INC  R4
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer0)
	SBCI R31,HIGH(-_rx_buffer0)
	ST   Z,R16
; 0000 0065 #if RX_BUFFER_SIZE0 == 256
; 0000 0066    // special case for receiver buffer size=256
; 0000 0067    if (++rx_counter0 == 0) rx_buffer_overflow0=1;
; 0000 0068 #else
; 0000 0069    if (rx_wr_index0 == RX_BUFFER_SIZE0) rx_wr_index0=0;
	LDI  R30,LOW(64)
	CP   R30,R4
	BRNE _0x4
	CLR  R4
; 0000 006A    if (++rx_counter0 == RX_BUFFER_SIZE0)
_0x4:
	INC  R6
	LDI  R30,LOW(64)
	CP   R30,R6
	BRNE _0x5
; 0000 006B       {
; 0000 006C       rx_counter0=0;
	CLR  R6
; 0000 006D       rx_buffer_overflow0=1;
	SET
	BLD  R2,0
; 0000 006E       }
; 0000 006F #endif
; 0000 0070    }
_0x5:
; 0000 0071 }
_0x3:
	RJMP _0x1AD
; .FEND
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Get a character from the USART0 Receiver buffer
;#define _ALTERNATE_GETCHAR_
;#pragma used+
;char getchar(void)
; 0000 0078 {
_getchar:
; .FSTART _getchar
; 0000 0079 char data;
; 0000 007A while (rx_counter0==0);
	ST   -Y,R17
;	data -> R17
_0x6:
	TST  R6
	BREQ _0x6
; 0000 007B data=rx_buffer0[rx_rd_index0++];
	MOV  R30,R7
	INC  R7
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer0)
	SBCI R31,HIGH(-_rx_buffer0)
	LD   R17,Z
; 0000 007C #if RX_BUFFER_SIZE0 != 256
; 0000 007D if (rx_rd_index0 == RX_BUFFER_SIZE0) rx_rd_index0=0;
	LDI  R30,LOW(64)
	CP   R30,R7
	BRNE _0x9
	CLR  R7
; 0000 007E #endif
; 0000 007F #asm("cli")
_0x9:
	cli
; 0000 0080 --rx_counter0;
	DEC  R6
; 0000 0081 #asm("sei")
	sei
; 0000 0082 return data;
	MOV  R30,R17
	LD   R17,Y+
	RET
; 0000 0083 }
; .FEND
;#pragma used-
;#endif
;
;// USART0 Transmitter buffer
;#define TX_BUFFER_SIZE0 64
;char tx_buffer0[TX_BUFFER_SIZE0];
;
;#if TX_BUFFER_SIZE0 <= 256
;unsigned char tx_wr_index0=0,tx_rd_index0=0;
;#else
;unsigned int tx_wr_index0=0,tx_rd_index0=0;
;#endif
;
;#if TX_BUFFER_SIZE0 < 256
;unsigned char tx_counter0=0;
;#else
;unsigned int tx_counter0=0;
;#endif
;
;// USART0 Transmitter interrupt service routine
;interrupt [USART0_TXC] void usart0_tx_isr(void)
; 0000 0099 {
_usart0_tx_isr:
; .FSTART _usart0_tx_isr
	CALL SUBOPT_0x0
; 0000 009A if (tx_counter0)
	TST  R11
	BREQ _0xA
; 0000 009B    {
; 0000 009C    --tx_counter0;
	DEC  R11
; 0000 009D    UDR0=tx_buffer0[tx_rd_index0++];
	MOV  R30,R8
	INC  R8
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer0)
	SBCI R31,HIGH(-_tx_buffer0)
	LD   R30,Z
	OUT  0xC,R30
; 0000 009E #if TX_BUFFER_SIZE0 != 256
; 0000 009F    if (tx_rd_index0 == TX_BUFFER_SIZE0) tx_rd_index0=0;
	LDI  R30,LOW(64)
	CP   R30,R8
	BRNE _0xB
	CLR  R8
; 0000 00A0 #endif
; 0000 00A1    }
_0xB:
; 0000 00A2 }
_0xA:
	RJMP _0x1AC
; .FEND
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Write a character to the USART0 Transmitter buffer
;#define _ALTERNATE_PUTCHAR_
;#pragma used+
;void putchar(char c)
; 0000 00A9 {
_putchar:
; .FSTART _putchar
; 0000 00AA while (tx_counter0 == TX_BUFFER_SIZE0);
	ST   -Y,R26
;	c -> Y+0
_0xC:
	LDI  R30,LOW(64)
	CP   R30,R11
	BREQ _0xC
; 0000 00AB #asm("cli")
	cli
; 0000 00AC if (tx_counter0 || ((UCSR0A & DATA_REGISTER_EMPTY)==0))
	TST  R11
	BRNE _0x10
	SBIC 0xB,5
	RJMP _0xF
_0x10:
; 0000 00AD    {
; 0000 00AE    tx_buffer0[tx_wr_index0++]=c;
	MOV  R30,R9
	INC  R9
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer0)
	SBCI R31,HIGH(-_tx_buffer0)
	LD   R26,Y
	STD  Z+0,R26
; 0000 00AF #if TX_BUFFER_SIZE0 != 256
; 0000 00B0    if (tx_wr_index0 == TX_BUFFER_SIZE0) tx_wr_index0=0;
	LDI  R30,LOW(64)
	CP   R30,R9
	BRNE _0x12
	CLR  R9
; 0000 00B1 #endif
; 0000 00B2    ++tx_counter0;
_0x12:
	INC  R11
; 0000 00B3    }
; 0000 00B4 else
	RJMP _0x13
_0xF:
; 0000 00B5    UDR0=c;
	LD   R30,Y
	OUT  0xC,R30
; 0000 00B6 #asm("sei")
_0x13:
	sei
; 0000 00B7 }
	ADIW R28,1
	RET
; .FEND
;#pragma used-
;#endif
;
;// USART1 Receiver buffer
;#define RX_BUFFER_SIZE1 64
;char rx_buffer1[RX_BUFFER_SIZE1];
;
;#if RX_BUFFER_SIZE1 <= 256
;unsigned char rx_wr_index1=0,rx_rd_index1=0;
;#else
;unsigned int rx_wr_index1=0,rx_rd_index1=0;
;#endif
;
;#if RX_BUFFER_SIZE1 < 256
;unsigned char rx_counter1=0;
;#else
;unsigned int rx_counter1=0;
;#endif
;
;// This flag is set on USART1 Receiver buffer overflow
;bit rx_buffer_overflow1;
;
;// USART1 Receiver interrupt service routine
;interrupt [USART1_RXC] void usart1_rx_isr(void)
; 0000 00D0 {
_usart1_rx_isr:
; .FSTART _usart1_rx_isr
	CALL SUBOPT_0x0
; 0000 00D1 char status,data;
; 0000 00D2 status=UCSR1A;
	ST   -Y,R17
	ST   -Y,R16
;	status -> R17
;	data -> R16
	LDS  R17,155
; 0000 00D3 data=UDR1;
	LDS  R16,156
; 0000 00D4 if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x14
; 0000 00D5    {
; 0000 00D6    rx_buffer1[rx_wr_index1++]=data;
	MOV  R30,R10
	INC  R10
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer1)
	SBCI R31,HIGH(-_rx_buffer1)
	ST   Z,R16
; 0000 00D7 #if RX_BUFFER_SIZE1 == 256
; 0000 00D8    // special case for receiver buffer size=256
; 0000 00D9    if (++rx_counter1 == 0) rx_buffer_overflow1=1;
; 0000 00DA #else
; 0000 00DB    if (rx_wr_index1 == RX_BUFFER_SIZE1) rx_wr_index1=0;
	LDI  R30,LOW(64)
	CP   R30,R10
	BRNE _0x15
	CLR  R10
; 0000 00DC    if (++rx_counter1 == RX_BUFFER_SIZE1)
_0x15:
	INC  R12
	LDI  R30,LOW(64)
	CP   R30,R12
	BRNE _0x16
; 0000 00DD       {
; 0000 00DE       rx_counter1=0;
	CLR  R12
; 0000 00DF       rx_buffer_overflow1=1;
	SET
	BLD  R2,1
; 0000 00E0       }
; 0000 00E1 #endif
; 0000 00E2    }
_0x16:
; 0000 00E3 }
_0x14:
_0x1AD:
	LD   R16,Y+
	LD   R17,Y+
_0x1AC:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
; .FEND
;
;// Get a character from the USART1 Receiver buffer
;#pragma used+
;char getchar1(void)
; 0000 00E8 {
; 0000 00E9 char data;
; 0000 00EA while (rx_counter1==0);
;	data -> R17
; 0000 00EB data=rx_buffer1[rx_rd_index1++];
; 0000 00EC #if RX_BUFFER_SIZE1 != 256
; 0000 00ED if (rx_rd_index1 == RX_BUFFER_SIZE1) rx_rd_index1=0;
; 0000 00EE #endif
; 0000 00EF #asm("cli")
; 0000 00F0 --rx_counter1;
; 0000 00F1 #asm("sei")
; 0000 00F2 return data;
; 0000 00F3 }
;#pragma used-
;// USART1 Transmitter buffer
;#define TX_BUFFER_SIZE1 64
;char tx_buffer1[TX_BUFFER_SIZE1];
;
;#if TX_BUFFER_SIZE1 <= 256
;unsigned char tx_wr_index1=0,tx_rd_index1=0;
;#else
;unsigned int tx_wr_index1=0,tx_rd_index1=0;
;#endif
;
;#if TX_BUFFER_SIZE1 < 256
;unsigned char tx_counter1=0;
;#else
;unsigned int tx_counter1=0;
;#endif
;
;// USART1 Transmitter interrupt service routine
;interrupt [USART1_TXC] void usart1_tx_isr(void)
; 0000 0107 {
_usart1_tx_isr:
; .FSTART _usart1_tx_isr
	ST   -Y,R26
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0108 if (tx_counter1)
	LDS  R30,_tx_counter1
	CPI  R30,0
	BREQ _0x1B
; 0000 0109    {
; 0000 010A    --tx_counter1;
	SUBI R30,LOW(1)
	STS  _tx_counter1,R30
; 0000 010B    UDR1=tx_buffer1[tx_rd_index1++];
	LDS  R30,_tx_rd_index1
	SUBI R30,-LOW(1)
	STS  _tx_rd_index1,R30
	SUBI R30,LOW(1)
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer1)
	SBCI R31,HIGH(-_tx_buffer1)
	LD   R30,Z
	STS  156,R30
; 0000 010C #if TX_BUFFER_SIZE1 != 256
; 0000 010D    if (tx_rd_index1 == TX_BUFFER_SIZE1) tx_rd_index1=0;
	LDS  R26,_tx_rd_index1
	CPI  R26,LOW(0x40)
	BRNE _0x1C
	LDI  R30,LOW(0)
	STS  _tx_rd_index1,R30
; 0000 010E #endif
; 0000 010F    }
_0x1C:
; 0000 0110 }
_0x1B:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R26,Y+
	RETI
; .FEND
;
;// Write a character to the USART1 Transmitter buffer
;#pragma used+
;void putchar1(char c)
; 0000 0115 {
; 0000 0116 while (tx_counter1 == TX_BUFFER_SIZE1);
;	c -> Y+0
; 0000 0117 #asm("cli")
; 0000 0118 if (tx_counter1 || ((UCSR1A & DATA_REGISTER_EMPTY)==0))
; 0000 0119    {
; 0000 011A    tx_buffer1[tx_wr_index1++]=c;
; 0000 011B #if TX_BUFFER_SIZE1 != 256
; 0000 011C    if (tx_wr_index1 == TX_BUFFER_SIZE1) tx_wr_index1=0;
; 0000 011D #endif
; 0000 011E    ++tx_counter1;
; 0000 011F    }
; 0000 0120 else
; 0000 0121    UDR1=c;
; 0000 0122 #asm("sei")
; 0000 0123 }
;#pragma used-
;
;// Standard Input/Output functions
;#include <stdio.h>
;
;unsigned int adc_data;
;// Voltage Reference: AVCC pin
;#define ADC_VREF_TYPE ((0<<REFS1) | (1<<REFS0) | (0<<ADLAR))
;
;// ADC interrupt service routine
;interrupt [ADC_INT] void adc_isr(void)
; 0000 012F {
_adc_isr:
; .FSTART _adc_isr
	ST   -Y,R30
	ST   -Y,R31
; 0000 0130 // Read the AD conversion result
; 0000 0131 adc_data=ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
	STS  _adc_data,R30
	STS  _adc_data+1,R31
; 0000 0132 }
	LD   R31,Y+
	LD   R30,Y+
	RETI
; .FEND
;
;// Read the AD conversion result
;// with noise canceling
;unsigned int read_adc(unsigned char adc_input)
; 0000 0137 {
; 0000 0138 ADMUX=adc_input | ADC_VREF_TYPE;
;	adc_input -> Y+0
; 0000 0139 // Delay needed for the stabilization of the ADC input voltage
; 0000 013A delay_us(10);
; 0000 013B #asm
; 0000 013C     in   r30,mcucr
; 0000 013D     cbr  r30,__sm_mask
; 0000 013E     sbr  r30,__se_bit | __sm_adc_noise_red
; 0000 013F     out  mcucr,r30
; 0000 0140     sleep
; 0000 0141     cbr  r30,__se_bit
; 0000 0142     out  mcucr,r30
; 0000 0143 #endasm
; 0000 0144 return adc_data;
; 0000 0145 }
;//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// ...
;void motorright() // Close
; 0000 0148 {
_motorright:
; .FSTART _motorright
; 0000 0149     if (RF3==1 || SPB1==1)
	SBIC 0x16,4
	RJMP _0x26
	SBIS 0x10,6
	RJMP _0x25
_0x26:
; 0000 014A     {
; 0000 014B             while(1)
_0x28:
; 0000 014C             {
; 0000 014D             Re2=1;
	SBI  0x1B,1
; 0000 014E             Re1=1;
	SBI  0x1B,0
; 0000 014F                         if (Mstop == 1 || RF2 == 1)
	SBIC 0x0,2
	RJMP _0x30
	SBIS 0x16,3
	RJMP _0x2F
_0x30:
; 0000 0150                         {
; 0000 0151                         Re2=0;
	CALL SUBOPT_0x1
; 0000 0152                         Re3=0;
; 0000 0153                         Re4=0;
; 0000 0154                         Re1=0;
; 0000 0155                         delay_ms(10);
; 0000 0156                         break;
	RJMP _0x2A
; 0000 0157                         }
; 0000 0158                         if (SUP==1)
_0x2F:
	SBIS 0x10,4
	RJMP _0x3A
; 0000 0159                         {
; 0000 015A                         Re2=0;
	CALL SUBOPT_0x2
; 0000 015B                         Re1=0;
; 0000 015C                         delay_ms(10);
; 0000 015D                         break;
	RJMP _0x2A
; 0000 015E                         }
; 0000 015F                         if (photo==1)
_0x3A:
	SBIS 0x0,7
	RJMP _0x3F
; 0000 0160                         {
; 0000 0161                             Re1=0;
	CALL SUBOPT_0x3
; 0000 0162                             Re2=0;
; 0000 0163                             delay_ms(2000);
; 0000 0164                             if (DS1==1)
	SBIS 0x13,0
	RJMP _0x44
; 0000 0165                             {
; 0000 0166                                 while(1)
_0x45:
; 0000 0167                                 {
; 0000 0168                                 Re4=1;
	CALL SUBOPT_0x4
; 0000 0169                                 delay_ms(10);
; 0000 016A                                 Re1=1;
; 0000 016B                                 delay_ms(10);
; 0000 016C                                     if (Mstop == 1 || RF2 == 1)
	SBIC 0x0,2
	RJMP _0x4D
	SBIS 0x16,3
	RJMP _0x4C
_0x4D:
; 0000 016D                                     {
; 0000 016E                                     Re2=0;
	CALL SUBOPT_0x1
; 0000 016F                                     Re3=0;
; 0000 0170                                     Re4=0;
; 0000 0171                                     Re1=0;
; 0000 0172                                     delay_ms(10);
; 0000 0173                                     break;
	RJMP _0x47
; 0000 0174                                     }
; 0000 0175                                     if (SDW==1)
_0x4C:
	SBIS 0x10,5
	RJMP _0x57
; 0000 0176                                     {
; 0000 0177                                     Re4=0;
	CALL SUBOPT_0x5
; 0000 0178                                     delay_ms(10);
; 0000 0179                                     Re1=0;
; 0000 017A                                     delay_ms(10);
; 0000 017B                                     Re2=0;
; 0000 017C                                     BUZZ=1;
; 0000 017D                                     delay_ms(3000);
	LDI  R26,LOW(3000)
	LDI  R27,HIGH(3000)
	CALL _delay_ms
; 0000 017E                                     break;
	RJMP _0x47
; 0000 017F                                     }
; 0000 0180                                 }
_0x57:
	RJMP _0x45
_0x47:
; 0000 0181                             }
; 0000 0182                             else if (DS1==0)
	RJMP _0x60
_0x44:
	SBIC 0x13,0
	RJMP _0x61
; 0000 0183                             {
; 0000 0184                               while(1)
_0x62:
; 0000 0185                               {
; 0000 0186                                 Re4=1;
	CALL SUBOPT_0x4
; 0000 0187                                 delay_ms(10);
; 0000 0188                                 Re1=1;
; 0000 0189                                 delay_ms(10);
; 0000 018A                                 if (Mstop == 1 || RF2 == 1)
	SBIC 0x0,2
	RJMP _0x6A
	SBIS 0x16,3
	RJMP _0x69
_0x6A:
; 0000 018B                                 {
; 0000 018C                                 Re2=0;
	CALL SUBOPT_0x1
; 0000 018D                                 Re3=0;
; 0000 018E                                 Re4=0;
; 0000 018F                                 Re1=0;
; 0000 0190                                 delay_ms(10);
; 0000 0191                                 break;
	RJMP _0x64
; 0000 0192                                 }
; 0000 0193                                 if (SDW==1)
_0x69:
	SBIS 0x10,5
	RJMP _0x74
; 0000 0194                                 {
; 0000 0195                                 Re4=0;
	CALL SUBOPT_0x5
; 0000 0196                                 delay_ms(10);
; 0000 0197                                 Re1=0;
; 0000 0198                                 delay_ms(10);
; 0000 0199                                 Re2=0;
; 0000 019A                                 BUZZ=1;
; 0000 019B                                 delay_ms(9500);
	LDI  R26,LOW(9500)
	LDI  R27,HIGH(9500)
	CALL _delay_ms
; 0000 019C                                     while(1)
_0x7D:
; 0000 019D                                     {
; 0000 019E                                         Re2=1;
	SBI  0x1B,1
; 0000 019F                                         Re1=1;
	SBI  0x1B,0
; 0000 01A0                                         if (Mstop == 1 || RF2 == 1)
	SBIC 0x0,2
	RJMP _0x85
	SBIS 0x16,3
	RJMP _0x84
_0x85:
; 0000 01A1                                         {
; 0000 01A2                                         Re2=0;
	CALL SUBOPT_0x1
; 0000 01A3                                         Re3=0;
; 0000 01A4                                         Re4=0;
; 0000 01A5                                         Re1=0;
; 0000 01A6                                         delay_ms(10);
; 0000 01A7                                         break;
	RJMP _0x7F
; 0000 01A8                                         }
; 0000 01A9                                         if (SUP==1)
_0x84:
	SBIS 0x10,4
	RJMP _0x8F
; 0000 01AA                                         {
; 0000 01AB                                         Re2=0;
	CALL SUBOPT_0x2
; 0000 01AC                                         Re1=0;
; 0000 01AD                                         delay_ms(10);
; 0000 01AE                                         break;
	RJMP _0x7F
; 0000 01AF                                         }
; 0000 01B0 
; 0000 01B1                                     }
_0x8F:
	RJMP _0x7D
_0x7F:
; 0000 01B2                                 break;
	RJMP _0x64
; 0000 01B3                                 }
; 0000 01B4                               }
_0x74:
	RJMP _0x62
_0x64:
; 0000 01B5 
; 0000 01B6                             break;
	RJMP _0x2A
; 0000 01B7 
; 0000 01B8                             }
; 0000 01B9                         }
_0x61:
_0x60:
; 0000 01BA             }
_0x3F:
	RJMP _0x28
_0x2A:
; 0000 01BB     }
; 0000 01BC }
_0x25:
	RET
; .FEND
;
;void motorleft() // Open
; 0000 01BF     {
_motorleft:
; .FSTART _motorleft
; 0000 01C0         if (RF4==1 || SPB2==1)
	SBIC 0x16,5
	RJMP _0x95
	SBIS 0x10,7
	RJMP _0x94
_0x95:
; 0000 01C1         {
; 0000 01C2                 while(1)
_0x97:
; 0000 01C3                 {
; 0000 01C4                 Re4=1;
	SBI  0x1B,3
; 0000 01C5                 Re1=1;
	SBI  0x1B,0
; 0000 01C6                         if (Mstop == 1)
	SBIS 0x0,2
	RJMP _0x9E
; 0000 01C7                         {
; 0000 01C8                         Re2=0;
	CALL SUBOPT_0x1
; 0000 01C9                         Re3=0;
; 0000 01CA                         Re4=0;
; 0000 01CB                         Re1=0;
; 0000 01CC                         delay_ms(10);
; 0000 01CD                         break;
	RJMP _0x99
; 0000 01CE                         }
; 0000 01CF                         if (SDW==1 || RF2==1)
_0x9E:
	SBIC 0x10,5
	RJMP _0xA8
	SBIS 0x16,3
	RJMP _0xA7
_0xA8:
; 0000 01D0                         {
; 0000 01D1                         Re4=0;
	CALL SUBOPT_0x6
; 0000 01D2                         Re1=0;
; 0000 01D3                         delay_ms(10);
; 0000 01D4                         break;
	RJMP _0x99
; 0000 01D5                         }
; 0000 01D6                         else
_0xA7:
; 0000 01D7                         {
; 0000 01D8                         continue;
	RJMP _0x97
; 0000 01D9                         }
; 0000 01DA                 }
_0x99:
; 0000 01DB         }
; 0000 01DC         else
_0x94:
; 0000 01DD         {
; 0000 01DE         //Re4=0;
; 0000 01DF         //Re1=0;
; 0000 01E0         }
; 0000 01E1     }
	RET
; .FEND
;
;void motor()
; 0000 01E4     {
_motor:
; .FSTART _motor
; 0000 01E5     motorright();
	RCALL _motorright
; 0000 01E6     motorleft();
	RCALL _motorleft
; 0000 01E7     }
	RET
; .FEND
;
;void TCP()
; 0000 01EA     {
_TCP:
; .FSTART _TCP
; 0000 01EB       E=getchar();
	RCALL _getchar
	MOV  R5,R30
; 0000 01EC       if(E == 'X')
	LDI  R30,LOW(88)
	CP   R30,R5
	BREQ PC+2
	RJMP _0xB0
; 0000 01ED       {
; 0000 01EE        printf(
; 0000 01EF        "$%1d%1d%1d%1d%1d%1d,%1d%1d%1d%1d%1d%1d,%1d%1d,%1d%1d%1d%1d%1d%1d%1d%1d\n\r",
; 0000 01F0        PINC.0,PINC.1,PINC.2,PINC.3,PINC.4,PINC.5,PINB.1,
; 0000 01F1        PINB.2,PINB.3,PINB.4,PINB.5,PINB.6,PIND.0,PIND.1,PIND.6,PIND.7,PIND.4,PIND.5,PINF.7,PINF.2,PINF.5,PINF.6);
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,0
	SBIC 0x13,0
	LDI  R30,1
	CALL SUBOPT_0x7
	LDI  R30,0
	SBIC 0x13,1
	LDI  R30,1
	CALL SUBOPT_0x7
	LDI  R30,0
	SBIC 0x13,2
	LDI  R30,1
	CALL SUBOPT_0x7
	LDI  R30,0
	SBIC 0x13,3
	LDI  R30,1
	CALL SUBOPT_0x7
	LDI  R30,0
	SBIC 0x13,4
	LDI  R30,1
	CALL SUBOPT_0x7
	LDI  R30,0
	SBIC 0x13,5
	LDI  R30,1
	CALL SUBOPT_0x7
	LDI  R30,0
	SBIC 0x16,1
	LDI  R30,1
	CALL SUBOPT_0x7
	LDI  R30,0
	SBIC 0x16,2
	LDI  R30,1
	CALL SUBOPT_0x7
	LDI  R30,0
	SBIC 0x16,3
	LDI  R30,1
	CALL SUBOPT_0x7
	LDI  R30,0
	SBIC 0x16,4
	LDI  R30,1
	CALL SUBOPT_0x7
	LDI  R30,0
	SBIC 0x16,5
	LDI  R30,1
	CALL SUBOPT_0x7
	LDI  R30,0
	SBIC 0x16,6
	LDI  R30,1
	CALL SUBOPT_0x7
	LDI  R30,0
	SBIC 0x10,0
	LDI  R30,1
	CALL SUBOPT_0x7
	LDI  R30,0
	SBIC 0x10,1
	LDI  R30,1
	CALL SUBOPT_0x7
	LDI  R30,0
	SBIC 0x10,6
	LDI  R30,1
	CALL SUBOPT_0x7
	LDI  R30,0
	SBIC 0x10,7
	LDI  R30,1
	CALL SUBOPT_0x7
	LDI  R30,0
	SBIC 0x10,4
	LDI  R30,1
	CALL SUBOPT_0x7
	LDI  R30,0
	SBIC 0x10,5
	LDI  R30,1
	CALL SUBOPT_0x7
	LDI  R30,0
	SBIC 0x0,7
	LDI  R30,1
	CALL SUBOPT_0x7
	LDI  R30,0
	SBIC 0x0,2
	LDI  R30,1
	CALL SUBOPT_0x7
	LDI  R30,0
	SBIC 0x0,5
	LDI  R30,1
	CALL SUBOPT_0x7
	LDI  R30,0
	SBIC 0x0,6
	LDI  R30,1
	CALL SUBOPT_0x7
	LDI  R24,88
	CALL _printf
	ADIW R28,63
	ADIW R28,27
; 0000 01F2       }
; 0000 01F3       if( E == 'C' )
_0xB0:
	LDI  R30,LOW(67)
	CP   R30,R5
	BREQ PC+2
	RJMP _0xB1
; 0000 01F4       {
; 0000 01F5                 while(1)
_0xB2:
; 0000 01F6             {
; 0000 01F7             Re2=1;
	SBI  0x1B,1
; 0000 01F8             Re1=1;
	SBI  0x1B,0
; 0000 01F9                         if (Mstop == 1 || RF2 == 1)
	SBIC 0x0,2
	RJMP _0xBA
	SBIS 0x16,3
	RJMP _0xB9
_0xBA:
; 0000 01FA                         {
; 0000 01FB                         Re2=0;
	CALL SUBOPT_0x1
; 0000 01FC                         Re3=0;
; 0000 01FD                         Re4=0;
; 0000 01FE                         Re1=0;
; 0000 01FF                         delay_ms(10);
; 0000 0200                         break;
	RJMP _0xB4
; 0000 0201                         }
; 0000 0202                         if (SUP==1)
_0xB9:
	SBIS 0x10,4
	RJMP _0xC4
; 0000 0203                         {
; 0000 0204                         Re2=0;
	CALL SUBOPT_0x2
; 0000 0205                         Re1=0;
; 0000 0206                         delay_ms(10);
; 0000 0207                         break;
	RJMP _0xB4
; 0000 0208                         }
; 0000 0209                         if (photo==1)
_0xC4:
	SBIS 0x0,7
	RJMP _0xC9
; 0000 020A                         {
; 0000 020B                             Re1=0;
	CALL SUBOPT_0x3
; 0000 020C                             Re2=0;
; 0000 020D                             delay_ms(2000);
; 0000 020E                             if (DS1==1)
	SBIS 0x13,0
	RJMP _0xCE
; 0000 020F                             {
; 0000 0210                                 while(1)
_0xCF:
; 0000 0211                                 {
; 0000 0212                                 Re4=1;
	CALL SUBOPT_0x4
; 0000 0213                                 delay_ms(10);
; 0000 0214                                 Re1=1;
; 0000 0215                                 delay_ms(10);
; 0000 0216                                     if (Mstop == 1 || RF2 == 1)
	SBIC 0x0,2
	RJMP _0xD7
	SBIS 0x16,3
	RJMP _0xD6
_0xD7:
; 0000 0217                                     {
; 0000 0218                                     Re2=0;
	CALL SUBOPT_0x1
; 0000 0219                                     Re3=0;
; 0000 021A                                     Re4=0;
; 0000 021B                                     Re1=0;
; 0000 021C                                     delay_ms(10);
; 0000 021D                                     break;
	RJMP _0xD1
; 0000 021E                                     }
; 0000 021F                                     if (SDW==1)
_0xD6:
	SBIS 0x10,5
	RJMP _0xE1
; 0000 0220                                     {
; 0000 0221                                     Re4=0;
	CALL SUBOPT_0x5
; 0000 0222                                     delay_ms(10);
; 0000 0223                                     Re1=0;
; 0000 0224                                     delay_ms(10);
; 0000 0225                                     Re2=0;
; 0000 0226                                     BUZZ=1;
; 0000 0227                                     delay_ms(3000);
	LDI  R26,LOW(3000)
	LDI  R27,HIGH(3000)
	CALL _delay_ms
; 0000 0228                                     break;
	RJMP _0xD1
; 0000 0229                                     }
; 0000 022A                                 }
_0xE1:
	RJMP _0xCF
_0xD1:
; 0000 022B                             }
; 0000 022C                             else if (DS1==0)
	RJMP _0xEA
_0xCE:
	SBIC 0x13,0
	RJMP _0xEB
; 0000 022D                             {
; 0000 022E                               while(1)
_0xEC:
; 0000 022F                               {
; 0000 0230                                 Re4=1;
	CALL SUBOPT_0x4
; 0000 0231                                 delay_ms(10);
; 0000 0232                                 Re1=1;
; 0000 0233                                 delay_ms(10);
; 0000 0234                                 if (Mstop == 1 || RF2 == 1)
	SBIC 0x0,2
	RJMP _0xF4
	SBIS 0x16,3
	RJMP _0xF3
_0xF4:
; 0000 0235                                 {
; 0000 0236                                 Re2=0;
	CALL SUBOPT_0x1
; 0000 0237                                 Re3=0;
; 0000 0238                                 Re4=0;
; 0000 0239                                 Re1=0;
; 0000 023A                                 delay_ms(10);
; 0000 023B                                 break;
	RJMP _0xEE
; 0000 023C                                 }
; 0000 023D                                 if (SDW==1)
_0xF3:
	SBIS 0x10,5
	RJMP _0xFE
; 0000 023E                                 {
; 0000 023F                                 Re4=0;
	CALL SUBOPT_0x5
; 0000 0240                                 delay_ms(10);
; 0000 0241                                 Re1=0;
; 0000 0242                                 delay_ms(10);
; 0000 0243                                 Re2=0;
; 0000 0244                                 BUZZ=1;
; 0000 0245                                 delay_ms(9500);
	LDI  R26,LOW(9500)
	LDI  R27,HIGH(9500)
	CALL _delay_ms
; 0000 0246                                     while(1)
_0x107:
; 0000 0247                                     {
; 0000 0248                                         Re2=1;
	SBI  0x1B,1
; 0000 0249                                         Re1=1;
	SBI  0x1B,0
; 0000 024A                                         if (Mstop == 1 || RF2 == 1)
	SBIC 0x0,2
	RJMP _0x10F
	SBIS 0x16,3
	RJMP _0x10E
_0x10F:
; 0000 024B                                         {
; 0000 024C                                         Re2=0;
	CALL SUBOPT_0x1
; 0000 024D                                         Re3=0;
; 0000 024E                                         Re4=0;
; 0000 024F                                         Re1=0;
; 0000 0250                                         delay_ms(10);
; 0000 0251                                         break;
	RJMP _0x109
; 0000 0252                                         }
; 0000 0253                                         if (SUP==1)
_0x10E:
	SBIS 0x10,4
	RJMP _0x119
; 0000 0254                                         {
; 0000 0255                                         Re2=0;
	CALL SUBOPT_0x2
; 0000 0256                                         Re1=0;
; 0000 0257                                         delay_ms(10);
; 0000 0258                                         break;
	RJMP _0x109
; 0000 0259                                         }
; 0000 025A 
; 0000 025B                                     }
_0x119:
	RJMP _0x107
_0x109:
; 0000 025C                                 break;
	RJMP _0xEE
; 0000 025D                                 }
; 0000 025E                               }
_0xFE:
	RJMP _0xEC
_0xEE:
; 0000 025F 
; 0000 0260                             break;
	RJMP _0xB4
; 0000 0261 
; 0000 0262                             }
; 0000 0263                         }
_0xEB:
_0xEA:
; 0000 0264             }
_0xC9:
	RJMP _0xB2
_0xB4:
; 0000 0265       }
; 0000 0266       else if( E == 'O' )
	RJMP _0x11E
_0xB1:
	LDI  R30,LOW(79)
	CP   R30,R5
	BRNE _0x11F
; 0000 0267       {
; 0000 0268                 while(1)
_0x120:
; 0000 0269                 {
; 0000 026A                 Re4=1;
	SBI  0x1B,3
; 0000 026B                 Re1=1;
	SBI  0x1B,0
; 0000 026C                         if (Mstop == 1)
	SBIS 0x0,2
	RJMP _0x127
; 0000 026D                         {
; 0000 026E                         Re2=0;
	CALL SUBOPT_0x1
; 0000 026F                         Re3=0;
; 0000 0270                         Re4=0;
; 0000 0271                         Re1=0;
; 0000 0272                         delay_ms(10);
; 0000 0273                         break;
	RJMP _0x122
; 0000 0274                         }
; 0000 0275                         if (SDW==1 || RF2==1)
_0x127:
	SBIC 0x10,5
	RJMP _0x131
	SBIS 0x16,3
	RJMP _0x130
_0x131:
; 0000 0276                         {
; 0000 0277                         Re4=0;
	CALL SUBOPT_0x6
; 0000 0278                         Re1=0;
; 0000 0279                         delay_ms(10);
; 0000 027A                         break;
	RJMP _0x122
; 0000 027B                         }
; 0000 027C                         else
_0x130:
; 0000 027D                         {
; 0000 027E                         continue;
	RJMP _0x120
; 0000 027F                         }
; 0000 0280                 }
_0x122:
; 0000 0281         }
; 0000 0282 
; 0000 0283       else if(E == 'S' )
	RJMP _0x138
_0x11F:
	LDI  R30,LOW(83)
	CP   R30,R5
	BRNE _0x139
; 0000 0284       {
; 0000 0285                 Re4=0;
	CBI  0x1B,3
; 0000 0286                 Re1=0;
	CBI  0x1B,0
; 0000 0287                 Re2=0;
	CBI  0x1B,1
; 0000 0288       }
; 0000 0289       else if( E == 'A' )
	RJMP _0x140
_0x139:
	LDI  R30,LOW(65)
	CP   R30,R5
	BRNE _0x141
; 0000 028A       {
; 0000 028B       Re1 = (Re1 == 1)?0:1;
	SBIS 0x1B,0
	RJMP _0x142
	LDI  R30,LOW(0)
	RJMP _0x143
_0x142:
	LDI  R30,LOW(1)
_0x143:
	CPI  R30,0
	BRNE _0x145
	CBI  0x1B,0
	RJMP _0x146
_0x145:
	SBI  0x1B,0
_0x146:
; 0000 028C       }
; 0000 028D       else if( E == 'B' )
	RJMP _0x147
_0x141:
	LDI  R30,LOW(66)
	CP   R30,R5
	BRNE _0x148
; 0000 028E       {
; 0000 028F       Re2 = (Re2 == 1)?0:1;
	SBIS 0x1B,1
	RJMP _0x149
	LDI  R30,LOW(0)
	RJMP _0x14A
_0x149:
	LDI  R30,LOW(1)
_0x14A:
	CPI  R30,0
	BRNE _0x14C
	CBI  0x1B,1
	RJMP _0x14D
_0x14C:
	SBI  0x1B,1
_0x14D:
; 0000 0290       }
; 0000 0291       else if( E == 'D' )
	RJMP _0x14E
_0x148:
	LDI  R30,LOW(68)
	CP   R30,R5
	BRNE _0x14F
; 0000 0292       {
; 0000 0293       Re3 = (Re3 == 1)?0:1;
	SBIS 0x1B,2
	RJMP _0x150
	LDI  R30,LOW(0)
	RJMP _0x151
_0x150:
	LDI  R30,LOW(1)
_0x151:
	CPI  R30,0
	BRNE _0x153
	CBI  0x1B,2
	RJMP _0x154
_0x153:
	SBI  0x1B,2
_0x154:
; 0000 0294       }
; 0000 0295       else if( E == 'E' )
	RJMP _0x155
_0x14F:
	LDI  R30,LOW(69)
	CP   R30,R5
	BRNE _0x156
; 0000 0296       {
; 0000 0297       Re4 = (Re4 == 1)?0:1;
	SBIS 0x1B,3
	RJMP _0x157
	LDI  R30,LOW(0)
	RJMP _0x158
_0x157:
	LDI  R30,LOW(1)
_0x158:
	CPI  R30,0
	BRNE _0x15A
	CBI  0x1B,3
	RJMP _0x15B
_0x15A:
	SBI  0x1B,3
_0x15B:
; 0000 0298       }
; 0000 0299       else if( E == 'F' )
	RJMP _0x15C
_0x156:
	LDI  R30,LOW(70)
	CP   R30,R5
	BRNE _0x15D
; 0000 029A       {
; 0000 029B       BUZZ = (BUZZ == 1)?0:1;
	SBIS 0x15,7
	RJMP _0x15E
	LDI  R30,LOW(0)
	RJMP _0x15F
_0x15E:
	LDI  R30,LOW(1)
_0x15F:
	CPI  R30,0
	BRNE _0x161
	CBI  0x15,7
	RJMP _0x162
_0x161:
	SBI  0x15,7
_0x162:
; 0000 029C       }
; 0000 029D       else if( E == 'G' )
	RJMP _0x163
_0x15D:
	LDI  R30,LOW(71)
	CP   R30,R5
	BRNE _0x164
; 0000 029E       {
; 0000 029F       LEDS2 = (LEDS2 == 1)?0:1;
	SBIS 0x15,6
	RJMP _0x165
	LDI  R30,LOW(0)
	RJMP _0x166
_0x165:
	LDI  R30,LOW(1)
_0x166:
	CPI  R30,0
	BRNE _0x168
	CBI  0x15,6
	RJMP _0x169
_0x168:
	SBI  0x15,6
_0x169:
; 0000 02A0       }
; 0000 02A1       else if( E == 'H' )
	RJMP _0x16A
_0x164:
	LDI  R30,LOW(72)
	CP   R30,R5
	BRNE _0x16B
; 0000 02A2       {
; 0000 02A3       LEDS1 = (LEDS1 == 1)?0:1;
	SBIS 0x1B,7
	RJMP _0x16C
	LDI  R30,LOW(0)
	RJMP _0x16D
_0x16C:
	LDI  R30,LOW(1)
_0x16D:
	CPI  R30,0
	BRNE _0x16F
	CBI  0x1B,7
	RJMP _0x170
_0x16F:
	SBI  0x1B,7
_0x170:
; 0000 02A4       }
; 0000 02A5     }
_0x16B:
_0x16A:
_0x163:
_0x15C:
_0x155:
_0x14E:
_0x147:
_0x140:
_0x138:
_0x11E:
	RET
; .FEND
;void Run()
; 0000 02A7     {
_Run:
; .FSTART _Run
; 0000 02A8         LEDS1=!LEDS1; delay_ms(100);
	SBIS 0x1B,7
	RJMP _0x171
	CBI  0x1B,7
	RJMP _0x172
_0x171:
	SBI  0x1B,7
_0x172:
	CALL SUBOPT_0x8
; 0000 02A9         LEDS2=!LEDS2; delay_ms(100);
	SBIS 0x15,6
	RJMP _0x173
	CBI  0x15,6
	RJMP _0x174
_0x173:
	SBI  0x15,6
_0x174:
	CALL SUBOPT_0x8
; 0000 02AA         LEDS1=!LEDS1; delay_ms(100);
	SBIS 0x1B,7
	RJMP _0x175
	CBI  0x1B,7
	RJMP _0x176
_0x175:
	SBI  0x1B,7
_0x176:
	CALL SUBOPT_0x8
; 0000 02AB         LEDS2=!LEDS2; delay_ms(100);
	SBIS 0x15,6
	RJMP _0x177
	CBI  0x15,6
	RJMP _0x178
_0x177:
	SBI  0x15,6
_0x178:
	CALL SUBOPT_0x8
; 0000 02AC         LEDS1=!LEDS1; delay_ms(100);
	SBIS 0x1B,7
	RJMP _0x179
	CBI  0x1B,7
	RJMP _0x17A
_0x179:
	SBI  0x1B,7
_0x17A:
	CALL SUBOPT_0x8
; 0000 02AD         LEDS2=!LEDS2; delay_ms(100);
	SBIS 0x15,6
	RJMP _0x17B
	CBI  0x15,6
	RJMP _0x17C
_0x17B:
	SBI  0x15,6
_0x17C:
	CALL SUBOPT_0x8
; 0000 02AE         LEDS1=!LEDS1; delay_ms(100);
	SBIS 0x1B,7
	RJMP _0x17D
	CBI  0x1B,7
	RJMP _0x17E
_0x17D:
	SBI  0x1B,7
_0x17E:
	CALL SUBOPT_0x8
; 0000 02AF         LEDS2=!LEDS2; delay_ms(100);
	SBIS 0x15,6
	RJMP _0x17F
	CBI  0x15,6
	RJMP _0x180
_0x17F:
	SBI  0x15,6
_0x180:
	CALL SUBOPT_0x8
; 0000 02B0         LEDS1=!LEDS1; delay_ms(100);
	SBIS 0x1B,7
	RJMP _0x181
	CBI  0x1B,7
	RJMP _0x182
_0x181:
	SBI  0x1B,7
_0x182:
	CALL SUBOPT_0x8
; 0000 02B1         LEDS2=!LEDS2; delay_ms(100);
	SBIS 0x15,6
	RJMP _0x183
	CBI  0x15,6
	RJMP _0x184
_0x183:
	SBI  0x15,6
_0x184:
	CALL SUBOPT_0x8
; 0000 02B2         LEDS1=!LEDS1; delay_ms(100);
	SBIS 0x1B,7
	RJMP _0x185
	CBI  0x1B,7
	RJMP _0x186
_0x185:
	SBI  0x1B,7
_0x186:
	CALL SUBOPT_0x8
; 0000 02B3         LEDS2=!LEDS2; delay_ms(100);
	SBIS 0x15,6
	RJMP _0x187
	CBI  0x15,6
	RJMP _0x188
_0x187:
	SBI  0x15,6
_0x188:
	CALL SUBOPT_0x8
; 0000 02B4         LEDS1=!LEDS1; delay_ms(100);
	SBIS 0x1B,7
	RJMP _0x189
	CBI  0x1B,7
	RJMP _0x18A
_0x189:
	SBI  0x1B,7
_0x18A:
	CALL SUBOPT_0x8
; 0000 02B5         LEDS2=!LEDS2; delay_ms(100);
	SBIS 0x15,6
	RJMP _0x18B
	CBI  0x15,6
	RJMP _0x18C
_0x18B:
	SBI  0x15,6
_0x18C:
	CALL SUBOPT_0x8
; 0000 02B6         LEDS1=1;
	SBI  0x1B,7
; 0000 02B7         LEDS2=0;
	CBI  0x15,6
; 0000 02B8         BUZZ=0;
	CBI  0x15,7
; 0000 02B9         delay_ms(60);
	LDI  R26,LOW(60)
	LDI  R27,0
	CALL _delay_ms
; 0000 02BA         BUZZ=1;
	SBI  0x15,7
; 0000 02BB         delay_ms(15);
	LDI  R26,LOW(15)
	LDI  R27,0
	CALL _delay_ms
; 0000 02BC     }
	RET
; .FEND
;
;//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// ...
;
;void main(void)
; 0000 02C1 {
_main:
; .FSTART _main
; 0000 02C2 // Declare your local variables here
; 0000 02C3 
; 0000 02C4 // Input/Output Ports initialization
; 0000 02C5 // Port A initialization
; 0000 02C6 // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 02C7 DDRA=(1<<DDA7) | (1<<DDA6) | (1<<DDA5) | (1<<DDA4) | (1<<DDA3) | (1<<DDA2) | (1<<DDA1) | (1<<DDA0);
	LDI  R30,LOW(255)
	OUT  0x1A,R30
; 0000 02C8 // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 02C9 PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 02CA 
; 0000 02CB // Port B initialization
; 0000 02CC // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 02CD DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	OUT  0x17,R30
; 0000 02CE // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 02CF PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	OUT  0x18,R30
; 0000 02D0 
; 0000 02D1 // Port C initialization
; 0000 02D2 // Function: Bit7=Out Bit6=Out Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 02D3 DDRC=(1<<DDC7) | (1<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	LDI  R30,LOW(192)
	OUT  0x14,R30
; 0000 02D4 // State: Bit7=1 Bit6=0 Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 02D5 PORTC=(1<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	LDI  R30,LOW(128)
	OUT  0x15,R30
; 0000 02D6 
; 0000 02D7 // Port D initialization
; 0000 02D8 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 02D9 DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	LDI  R30,LOW(0)
	OUT  0x11,R30
; 0000 02DA // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 02DB PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	OUT  0x12,R30
; 0000 02DC 
; 0000 02DD // Port E initialization
; 0000 02DE // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 02DF DDRE=(0<<DDE7) | (0<<DDE6) | (0<<DDE5) | (0<<DDE4) | (0<<DDE3) | (0<<DDE2) | (0<<DDE1) | (0<<DDE0);
	OUT  0x2,R30
; 0000 02E0 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 02E1 PORTE=(0<<PORTE7) | (0<<PORTE6) | (0<<PORTE5) | (0<<PORTE4) | (0<<PORTE3) | (0<<PORTE2) | (0<<PORTE1) | (0<<PORTE0);
	OUT  0x3,R30
; 0000 02E2 
; 0000 02E3 // Port F initialization
; 0000 02E4 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 02E5 DDRF=(0<<DDF7) | (0<<DDF6) | (0<<DDF5) | (0<<DDF4) | (0<<DDF3) | (0<<DDF2) | (0<<DDF1) | (0<<DDF0);
	STS  97,R30
; 0000 02E6 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 02E7 PORTF=(0<<PORTF7) | (0<<PORTF6) | (0<<PORTF5) | (0<<PORTF4) | (0<<PORTF3) | (0<<PORTF2) | (0<<PORTF1) | (0<<PORTF0);
	STS  98,R30
; 0000 02E8 
; 0000 02E9 // Port G initialization
; 0000 02EA // Function: Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 02EB DDRG=(0<<DDG4) | (0<<DDG3) | (0<<DDG2) | (0<<DDG1) | (0<<DDG0);
	STS  100,R30
; 0000 02EC // State: Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 02ED PORTG=(0<<PORTG4) | (0<<PORTG3) | (0<<PORTG2) | (0<<PORTG1) | (0<<PORTG0);
	STS  101,R30
; 0000 02EE 
; 0000 02EF // Timer/Counter 0 initialization
; 0000 02F0 // Clock source: System Clock
; 0000 02F1 // Clock value: Timer 0 Stopped
; 0000 02F2 // Mode: Normal top=0xFF
; 0000 02F3 // OC0 output: Disconnected
; 0000 02F4 ASSR=0<<AS0;
	OUT  0x30,R30
; 0000 02F5 TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
	OUT  0x33,R30
; 0000 02F6 TCNT0=0x00;
	OUT  0x32,R30
; 0000 02F7 OCR0=0x00;
	OUT  0x31,R30
; 0000 02F8 
; 0000 02F9 // Timer/Counter 1 initialization
; 0000 02FA // Clock source: System Clock
; 0000 02FB // Clock value: Timer1 Stopped
; 0000 02FC // Mode: Normal top=0xFFFF
; 0000 02FD // OC1A output: Disconnected
; 0000 02FE // OC1B output: Disconnected
; 0000 02FF // OC1C output: Disconnected
; 0000 0300 // Noise Canceler: Off
; 0000 0301 // Input Capture on Falling Edge
; 0000 0302 // Timer1 Overflow Interrupt: Off
; 0000 0303 // Input Capture Interrupt: Off
; 0000 0304 // Compare A Match Interrupt: Off
; 0000 0305 // Compare B Match Interrupt: Off
; 0000 0306 // Compare C Match Interrupt: Off
; 0000 0307 TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<COM1C1) | (0<<COM1C0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0000 0308 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	OUT  0x2E,R30
; 0000 0309 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 030A TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 030B ICR1H=0x00;
	OUT  0x27,R30
; 0000 030C ICR1L=0x00;
	OUT  0x26,R30
; 0000 030D OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 030E OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 030F OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0310 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0311 OCR1CH=0x00;
	STS  121,R30
; 0000 0312 OCR1CL=0x00;
	STS  120,R30
; 0000 0313 
; 0000 0314 // Timer/Counter 2 initialization
; 0000 0315 // Clock source: System Clock
; 0000 0316 // Clock value: Timer2 Stopped
; 0000 0317 // Mode: Normal top=0xFF
; 0000 0318 // OC2 output: Disconnected
; 0000 0319 TCCR2=(0<<WGM20) | (0<<COM21) | (0<<COM20) | (0<<WGM21) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 031A TCNT2=0x00;
	OUT  0x24,R30
; 0000 031B OCR2=0x00;
	OUT  0x23,R30
; 0000 031C 
; 0000 031D // Timer/Counter 3 initialization
; 0000 031E // Clock source: System Clock
; 0000 031F // Clock value: Timer3 Stopped
; 0000 0320 // Mode: Normal top=0xFFFF
; 0000 0321 // OC3A output: Disconnected
; 0000 0322 // OC3B output: Disconnected
; 0000 0323 // OC3C output: Disconnected
; 0000 0324 // Noise Canceler: Off
; 0000 0325 // Input Capture on Falling Edge
; 0000 0326 // Timer3 Overflow Interrupt: Off
; 0000 0327 // Input Capture Interrupt: Off
; 0000 0328 // Compare A Match Interrupt: Off
; 0000 0329 // Compare B Match Interrupt: Off
; 0000 032A // Compare C Match Interrupt: Off
; 0000 032B TCCR3A=(0<<COM3A1) | (0<<COM3A0) | (0<<COM3B1) | (0<<COM3B0) | (0<<COM3C1) | (0<<COM3C0) | (0<<WGM31) | (0<<WGM30);
	STS  139,R30
; 0000 032C TCCR3B=(0<<ICNC3) | (0<<ICES3) | (0<<WGM33) | (0<<WGM32) | (0<<CS32) | (0<<CS31) | (0<<CS30);
	STS  138,R30
; 0000 032D TCNT3H=0x00;
	STS  137,R30
; 0000 032E TCNT3L=0x00;
	STS  136,R30
; 0000 032F ICR3H=0x00;
	STS  129,R30
; 0000 0330 ICR3L=0x00;
	STS  128,R30
; 0000 0331 OCR3AH=0x00;
	STS  135,R30
; 0000 0332 OCR3AL=0x00;
	STS  134,R30
; 0000 0333 OCR3BH=0x00;
	STS  133,R30
; 0000 0334 OCR3BL=0x00;
	STS  132,R30
; 0000 0335 OCR3CH=0x00;
	STS  131,R30
; 0000 0336 OCR3CL=0x00;
	STS  130,R30
; 0000 0337 
; 0000 0338 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0339 TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
	OUT  0x37,R30
; 0000 033A ETIMSK=(0<<TICIE3) | (0<<OCIE3A) | (0<<OCIE3B) | (0<<TOIE3) | (0<<OCIE3C) | (0<<OCIE1C);
	STS  125,R30
; 0000 033B 
; 0000 033C // External Interrupt(s) initialization
; 0000 033D // INT0: Off
; 0000 033E // INT1: Off
; 0000 033F // INT2: Off
; 0000 0340 // INT3: Off
; 0000 0341 // INT4: Off
; 0000 0342 // INT5: Off
; 0000 0343 // INT6: Off
; 0000 0344 // INT7: Off
; 0000 0345 EICRA=(0<<ISC31) | (0<<ISC30) | (0<<ISC21) | (0<<ISC20) | (0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	STS  106,R30
; 0000 0346 EICRB=(0<<ISC71) | (0<<ISC70) | (0<<ISC61) | (0<<ISC60) | (0<<ISC51) | (0<<ISC50) | (0<<ISC41) | (0<<ISC40);
	OUT  0x3A,R30
; 0000 0347 EIMSK=(0<<INT7) | (0<<INT6) | (0<<INT5) | (0<<INT4) | (0<<INT3) | (0<<INT2) | (0<<INT1) | (0<<INT0);
	OUT  0x39,R30
; 0000 0348 
; 0000 0349 // USART0 initialization
; 0000 034A // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 034B // USART0 Receiver: On
; 0000 034C // USART0 Transmitter: On
; 0000 034D // USART0 Mode: Asynchronous
; 0000 034E // USART0 Baud Rate: 115200
; 0000 034F UCSR0A=(0<<RXC0) | (0<<TXC0) | (0<<UDRE0) | (0<<FE0) | (0<<DOR0) | (0<<UPE0) | (0<<U2X0) | (0<<MPCM0);
	OUT  0xB,R30
; 0000 0350 UCSR0B=(1<<RXCIE0) | (1<<TXCIE0) | (0<<UDRIE0) | (1<<RXEN0) | (1<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
	LDI  R30,LOW(216)
	OUT  0xA,R30
; 0000 0351 UCSR0C=(0<<UMSEL0) | (0<<UPM01) | (0<<UPM00) | (0<<USBS0) | (1<<UCSZ01) | (1<<UCSZ00) | (0<<UCPOL0);
	LDI  R30,LOW(6)
	STS  149,R30
; 0000 0352 UBRR0H=0x00;
	LDI  R30,LOW(0)
	STS  144,R30
; 0000 0353 UBRR0L=0x07;
	LDI  R30,LOW(7)
	OUT  0x9,R30
; 0000 0354 
; 0000 0355 // USART1 initialization
; 0000 0356 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 0357 // USART1 Receiver: On
; 0000 0358 // USART1 Transmitter: On
; 0000 0359 // USART1 Mode: Asynchronous
; 0000 035A // USART1 Baud Rate: 115200
; 0000 035B UCSR1A=(0<<RXC1) | (0<<TXC1) | (0<<UDRE1) | (0<<FE1) | (0<<DOR1) | (0<<UPE1) | (0<<U2X1) | (0<<MPCM1);
	LDI  R30,LOW(0)
	STS  155,R30
; 0000 035C UCSR1B=(1<<RXCIE1) | (1<<TXCIE1) | (0<<UDRIE1) | (1<<RXEN1) | (1<<TXEN1) | (0<<UCSZ12) | (0<<RXB81) | (0<<TXB81);
	LDI  R30,LOW(216)
	STS  154,R30
; 0000 035D UCSR1C=(0<<UMSEL1) | (0<<UPM11) | (0<<UPM10) | (0<<USBS1) | (1<<UCSZ11) | (1<<UCSZ10) | (0<<UCPOL1);
	LDI  R30,LOW(6)
	STS  157,R30
; 0000 035E UBRR1H=0x00;
	LDI  R30,LOW(0)
	STS  152,R30
; 0000 035F UBRR1L=0x07;
	LDI  R30,LOW(7)
	STS  153,R30
; 0000 0360 
; 0000 0361 // Analog Comparator initialization
; 0000 0362 // Analog Comparator: Off
; 0000 0363 // The Analog Comparator's positive input is
; 0000 0364 // connected to the AIN0 pin
; 0000 0365 // The Analog Comparator's negative input is
; 0000 0366 // connected to the AIN1 pin
; 0000 0367 ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0368 
; 0000 0369 // ADC initialization
; 0000 036A // ADC Clock frequency: 921.600 kHz
; 0000 036B // ADC Voltage Reference: AVCC pin
; 0000 036C ADMUX=ADC_VREF_TYPE;
	LDI  R30,LOW(64)
	OUT  0x7,R30
; 0000 036D ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (1<<ADIE) | (1<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	LDI  R30,LOW(140)
	OUT  0x6,R30
; 0000 036E SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 036F 
; 0000 0370 // SPI initialization
; 0000 0371 // SPI disabled
; 0000 0372 SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 0373 
; 0000 0374 // TWI initialization
; 0000 0375 // TWI disabled
; 0000 0376 TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	STS  116,R30
; 0000 0377 
; 0000 0378 // Global enable interrupts
; 0000 0379 #asm("sei")
	sei
; 0000 037A Run();
	RCALL _Run
; 0000 037B while (1)
_0x195:
; 0000 037C       {
; 0000 037D         if ( DS6 == 0 )
	SBIC 0x13,5
	RJMP _0x198
; 0000 037E         {
; 0000 037F             if(rx_counter0 > 0)
	LDI  R30,LOW(0)
	CP   R30,R6
	BRSH _0x199
; 0000 0380             {
; 0000 0381                 TCP();
	RCALL _TCP
; 0000 0382                 motor();
	RJMP _0x1AB
; 0000 0383             }
; 0000 0384             else if (rx_counter0==0)
_0x199:
	TST  R6
	BRNE _0x19B
; 0000 0385             {
; 0000 0386                 motor();
_0x1AB:
	RCALL _motor
; 0000 0387             }
; 0000 0388         }
_0x19B:
; 0000 0389         else if ( DS6 == 1 )
	RJMP _0x19C
_0x198:
	SBIC 0x13,5
; 0000 038A         {
; 0000 038B         motor();
	RCALL _motor
; 0000 038C         }
; 0000 038D 
; 0000 038E         if ( DS3 == 0 )
_0x19C:
	SBIC 0x13,2
	RJMP _0x19E
; 0000 038F         {
; 0000 0390             if ( SW2==0)
	SBIC 0x10,1
	RJMP _0x19F
; 0000 0391             {
; 0000 0392             LEDS2=1;
	SBI  0x15,6
; 0000 0393             delay_ms(100);
	CALL SUBOPT_0x8
; 0000 0394             LEDS2=0;
	CBI  0x15,6
; 0000 0395             delay_ms(100);
	CALL SUBOPT_0x8
; 0000 0396             }
; 0000 0397         }
_0x19F:
; 0000 0398         if ( DS2 == 0 )
_0x19E:
	SBIC 0x13,1
	RJMP _0x1A4
; 0000 0399         {
; 0000 039A             if ( SW1==0)
	SBIC 0x10,0
	RJMP _0x1A5
; 0000 039B             {
; 0000 039C             BUZZ=0;
	CBI  0x15,7
; 0000 039D             delay_ms(100);
	CALL SUBOPT_0x8
; 0000 039E             BUZZ=1;
	SBI  0x15,7
; 0000 039F             delay_ms(100);
	CALL SUBOPT_0x8
; 0000 03A0             }
; 0000 03A1         }
_0x1A5:
; 0000 03A2 
; 0000 03A3       }
_0x1A4:
	RJMP _0x195
; 0000 03A4 }
_0x1AA:
	RJMP _0x1AA
; .FEND

	.CSEG

	.DSEG

	.CSEG

	.CSEG
_strlen:
; .FSTART _strlen
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strlenf:
; .FSTART _strlenf
	ST   -Y,R27
	ST   -Y,R26
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_put_usart_G102:
; .FSTART _put_usart_G102
	ST   -Y,R27
	ST   -Y,R26
	LDD  R26,Y+2
	CALL _putchar
	LD   R26,Y
	LDD  R27,Y+1
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	ADIW R28,3
	RET
; .FEND
__print_G102:
; .FSTART __print_G102
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,6
	CALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2040016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2040018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x204001C
	CPI  R18,37
	BRNE _0x204001D
	LDI  R17,LOW(1)
	RJMP _0x204001E
_0x204001D:
	CALL SUBOPT_0x9
_0x204001E:
	RJMP _0x204001B
_0x204001C:
	CPI  R30,LOW(0x1)
	BRNE _0x204001F
	CPI  R18,37
	BRNE _0x2040020
	CALL SUBOPT_0x9
	RJMP _0x20400CC
_0x2040020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2040021
	LDI  R16,LOW(1)
	RJMP _0x204001B
_0x2040021:
	CPI  R18,43
	BRNE _0x2040022
	LDI  R20,LOW(43)
	RJMP _0x204001B
_0x2040022:
	CPI  R18,32
	BRNE _0x2040023
	LDI  R20,LOW(32)
	RJMP _0x204001B
_0x2040023:
	RJMP _0x2040024
_0x204001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2040025
_0x2040024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2040026
	ORI  R16,LOW(128)
	RJMP _0x204001B
_0x2040026:
	RJMP _0x2040027
_0x2040025:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x204001B
_0x2040027:
	CPI  R18,48
	BRLO _0x204002A
	CPI  R18,58
	BRLO _0x204002B
_0x204002A:
	RJMP _0x2040029
_0x204002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x204001B
_0x2040029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x204002F
	CALL SUBOPT_0xA
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0xB
	RJMP _0x2040030
_0x204002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2040032
	CALL SUBOPT_0xA
	CALL SUBOPT_0xC
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2040033
_0x2040032:
	CPI  R30,LOW(0x70)
	BRNE _0x2040035
	CALL SUBOPT_0xA
	CALL SUBOPT_0xC
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2040033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2040036
_0x2040035:
	CPI  R30,LOW(0x64)
	BREQ _0x2040039
	CPI  R30,LOW(0x69)
	BRNE _0x204003A
_0x2040039:
	ORI  R16,LOW(4)
	RJMP _0x204003B
_0x204003A:
	CPI  R30,LOW(0x75)
	BRNE _0x204003C
_0x204003B:
	LDI  R30,LOW(_tbl10_G102*2)
	LDI  R31,HIGH(_tbl10_G102*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x204003D
_0x204003C:
	CPI  R30,LOW(0x58)
	BRNE _0x204003F
	ORI  R16,LOW(8)
	RJMP _0x2040040
_0x204003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2040071
_0x2040040:
	LDI  R30,LOW(_tbl16_G102*2)
	LDI  R31,HIGH(_tbl16_G102*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x204003D:
	SBRS R16,2
	RJMP _0x2040042
	CALL SUBOPT_0xA
	CALL SUBOPT_0xD
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2040043
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2040043:
	CPI  R20,0
	BREQ _0x2040044
	SUBI R17,-LOW(1)
	RJMP _0x2040045
_0x2040044:
	ANDI R16,LOW(251)
_0x2040045:
	RJMP _0x2040046
_0x2040042:
	CALL SUBOPT_0xA
	CALL SUBOPT_0xD
_0x2040046:
_0x2040036:
	SBRC R16,0
	RJMP _0x2040047
_0x2040048:
	CP   R17,R21
	BRSH _0x204004A
	SBRS R16,7
	RJMP _0x204004B
	SBRS R16,2
	RJMP _0x204004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x204004D
_0x204004C:
	LDI  R18,LOW(48)
_0x204004D:
	RJMP _0x204004E
_0x204004B:
	LDI  R18,LOW(32)
_0x204004E:
	CALL SUBOPT_0x9
	SUBI R21,LOW(1)
	RJMP _0x2040048
_0x204004A:
_0x2040047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x204004F
_0x2040050:
	CPI  R19,0
	BREQ _0x2040052
	SBRS R16,3
	RJMP _0x2040053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2040054
_0x2040053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2040054:
	CALL SUBOPT_0x9
	CPI  R21,0
	BREQ _0x2040055
	SUBI R21,LOW(1)
_0x2040055:
	SUBI R19,LOW(1)
	RJMP _0x2040050
_0x2040052:
	RJMP _0x2040056
_0x204004F:
_0x2040058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x204005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x204005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x204005A
_0x204005C:
	CPI  R18,58
	BRLO _0x204005D
	SBRS R16,3
	RJMP _0x204005E
	SUBI R18,-LOW(7)
	RJMP _0x204005F
_0x204005E:
	SUBI R18,-LOW(39)
_0x204005F:
_0x204005D:
	SBRC R16,4
	RJMP _0x2040061
	CPI  R18,49
	BRSH _0x2040063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2040062
_0x2040063:
	RJMP _0x20400CD
_0x2040062:
	CP   R21,R19
	BRLO _0x2040067
	SBRS R16,0
	RJMP _0x2040068
_0x2040067:
	RJMP _0x2040066
_0x2040068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2040069
	LDI  R18,LOW(48)
_0x20400CD:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x204006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	CALL SUBOPT_0xB
	CPI  R21,0
	BREQ _0x204006B
	SUBI R21,LOW(1)
_0x204006B:
_0x204006A:
_0x2040069:
_0x2040061:
	CALL SUBOPT_0x9
	CPI  R21,0
	BREQ _0x204006C
	SUBI R21,LOW(1)
_0x204006C:
_0x2040066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2040059
	RJMP _0x2040058
_0x2040059:
_0x2040056:
	SBRS R16,0
	RJMP _0x204006D
_0x204006E:
	CPI  R21,0
	BREQ _0x2040070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0xB
	RJMP _0x204006E
_0x2040070:
_0x204006D:
_0x2040071:
_0x2040030:
_0x20400CC:
	LDI  R17,LOW(0)
_0x204001B:
	RJMP _0x2040016
_0x2040018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,20
	RET
; .FEND
_printf:
; .FSTART _printf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	ST   -Y,R17
	ST   -Y,R16
	MOVW R26,R28
	ADIW R26,4
	CALL __ADDW2R15
	MOVW R16,R26
	LDI  R30,LOW(0)
	STD  Y+4,R30
	STD  Y+4+1,R30
	STD  Y+6,R30
	STD  Y+6+1,R30
	MOVW R26,R28
	ADIW R26,8
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_usart_G102)
	LDI  R31,HIGH(_put_usart_G102)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,8
	RCALL __print_G102
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,8
	POP  R15
	RET
; .FEND

	.CSEG

	.CSEG

	.DSEG
_rx_buffer0:
	.BYTE 0x40
_tx_buffer0:
	.BYTE 0x40
_rx_buffer1:
	.BYTE 0x40
_tx_buffer1:
	.BYTE 0x40
_tx_wr_index1:
	.BYTE 0x1
_tx_rd_index1:
	.BYTE 0x1
_tx_counter1:
	.BYTE 0x1
_adc_data:
	.BYTE 0x2
__seed_G100:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:51 WORDS
SUBOPT_0x1:
	CBI  0x1B,1
	CBI  0x1B,2
	CBI  0x1B,3
	CBI  0x1B,0
	LDI  R26,LOW(10)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2:
	CBI  0x1B,1
	CBI  0x1B,0
	LDI  R26,LOW(10)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	CBI  0x1B,0
	CBI  0x1B,1
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x4:
	SBI  0x1B,3
	LDI  R26,LOW(10)
	LDI  R27,0
	CALL _delay_ms
	SBI  0x1B,0
	LDI  R26,LOW(10)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x5:
	CBI  0x1B,3
	LDI  R26,LOW(10)
	LDI  R27,0
	CALL _delay_ms
	CBI  0x1B,0
	LDI  R26,LOW(10)
	LDI  R27,0
	CALL _delay_ms
	CBI  0x1B,1
	SBI  0x15,7
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	CBI  0x1B,3
	CBI  0x1B,0
	LDI  R26,LOW(10)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 22 TIMES, CODE SIZE REDUCTION:60 WORDS
SUBOPT_0x7:
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 18 TIMES, CODE SIZE REDUCTION:31 WORDS
SUBOPT_0x8:
	LDI  R26,LOW(100)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x9:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xA:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xC:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xD:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xE66
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
