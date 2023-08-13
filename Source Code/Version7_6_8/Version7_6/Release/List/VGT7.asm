
;CodeVisionAVR C Compiler V2.05.3 Standard
;(C) Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega64A
;Program type             : Application
;Clock frequency          : 14.745600 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 1024 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;Global 'const' stored in FLASH     : Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions         : On
;Smart register allocation          : On
;Automatic register allocation      : On

	#pragma AVRPART ADMIN PART_NAME ATmega64A
	#pragma AVRPART MEMORY PROG_FLASH 65536
	#pragma AVRPART MEMORY EEPROM 2048
	#pragma AVRPART MEMORY INT_SRAM SIZE 4351
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
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
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
	.DEF _timeLimit=R4
	.DEF _timeCounter=R6
	.DEF _timeOK=R8
	.DEF _E=R11
	.DEF _rx_wr_index0=R10
	.DEF _rx_rd_index0=R13
	.DEF _rx_counter0=R12

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
	JMP  _timer0_ovf_isr
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

_0x1B7:
	.DB  0x98,0x4,0x0,0x0,0x1,0x0,0x0,0x0
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
	.DW  _0x1B7*2

	.DW  0x01
	.DW  __seed_G100
	.DW  _0x2000060*2

_0xFFFFFFFF:
	.DW  0

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

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

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
;unsigned int timeLimit=1176; //20 seconds
;unsigned int timeCounter=0;
;unsigned int timeOK=1;
;char E;
;
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 0047 {

	.CSEG
_timer0_ovf_isr:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0048 // har sarriz mosavi ba 17ms mibashad
; 0000 0049 //timeLimit*17=meghdar be mili sanie
; 0000 004A 
; 0000 004B if(timeOK==1)
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R8
	CPC  R31,R9
	BRNE _0x3
; 0000 004C     {
; 0000 004D     timeCounter++;
	MOVW R30,R6
	ADIW R30,1
	MOVW R6,R30
; 0000 004E     }
; 0000 004F if(timeCounter>=timeLimit)
_0x3:
	__CPWRR 6,7,4,5
	BRLO _0x4
; 0000 0050     {
; 0000 0051     timeOK=0;
	CLR  R8
	CLR  R9
; 0000 0052     timeCounter=0;
	CLR  R6
	CLR  R7
; 0000 0053     Re2=0;
	CALL SUBOPT_0x0
; 0000 0054     Re3=0;
; 0000 0055     Re4=0;
; 0000 0056     Re1=0;
; 0000 0057     delay_ms(2000);
	CALL SUBOPT_0x1
; 0000 0058     }
; 0000 0059 }
_0x4:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
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
; 0000 0076 {
_usart0_rx_isr:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0077 char status,data;
; 0000 0078 status=UCSR0A;
	ST   -Y,R17
	ST   -Y,R16
;	status -> R17
;	data -> R16
	IN   R17,11
; 0000 0079 data=UDR0;
	IN   R16,12
; 0000 007A if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0xD
; 0000 007B    {
; 0000 007C    rx_buffer0[rx_wr_index0++]=data;
	MOV  R30,R10
	INC  R10
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer0)
	SBCI R31,HIGH(-_rx_buffer0)
	ST   Z,R16
; 0000 007D #if RX_BUFFER_SIZE0 == 256
; 0000 007E    // special case for receiver buffer size=256
; 0000 007F    if (++rx_counter0 == 0) rx_buffer_overflow0=1;
; 0000 0080 #else
; 0000 0081    if (rx_wr_index0 == RX_BUFFER_SIZE0) rx_wr_index0=0;
	LDI  R30,LOW(64)
	CP   R30,R10
	BRNE _0xE
	CLR  R10
; 0000 0082    if (++rx_counter0 == RX_BUFFER_SIZE0)
_0xE:
	INC  R12
	LDI  R30,LOW(64)
	CP   R30,R12
	BRNE _0xF
; 0000 0083       {
; 0000 0084       rx_counter0=0;
	CLR  R12
; 0000 0085       rx_buffer_overflow0=1;
	SET
	BLD  R2,0
; 0000 0086       }
; 0000 0087 #endif
; 0000 0088    }
_0xF:
; 0000 0089 }
_0xD:
	LD   R16,Y+
	LD   R17,Y+
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Get a character from the USART0 Receiver buffer
;#define _ALTERNATE_GETCHAR_
;#pragma used+
;char getchar(void)
; 0000 0090 {
_getchar:
; 0000 0091 char data;
; 0000 0092 while (rx_counter0==0);
	ST   -Y,R17
;	data -> R17
_0x10:
	TST  R12
	BREQ _0x10
; 0000 0093 data=rx_buffer0[rx_rd_index0++];
	MOV  R30,R13
	INC  R13
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer0)
	SBCI R31,HIGH(-_rx_buffer0)
	LD   R17,Z
; 0000 0094 #if RX_BUFFER_SIZE0 != 256
; 0000 0095 if (rx_rd_index0 == RX_BUFFER_SIZE0) rx_rd_index0=0;
	LDI  R30,LOW(64)
	CP   R30,R13
	BRNE _0x13
	CLR  R13
; 0000 0096 #endif
; 0000 0097 #asm("cli")
_0x13:
	cli
; 0000 0098 --rx_counter0;
	DEC  R12
; 0000 0099 #asm("sei")
	sei
; 0000 009A return data;
	MOV  R30,R17
	LD   R17,Y+
	RET
; 0000 009B }
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
; 0000 00B1 {
_usart0_tx_isr:
	CALL SUBOPT_0x2
; 0000 00B2 if (tx_counter0)
	LDS  R30,_tx_counter0
	CPI  R30,0
	BREQ _0x14
; 0000 00B3    {
; 0000 00B4    --tx_counter0;
	SUBI R30,LOW(1)
	STS  _tx_counter0,R30
; 0000 00B5    UDR0=tx_buffer0[tx_rd_index0++];
	LDS  R30,_tx_rd_index0
	SUBI R30,-LOW(1)
	STS  _tx_rd_index0,R30
	CALL SUBOPT_0x3
	LD   R30,Z
	OUT  0xC,R30
; 0000 00B6 #if TX_BUFFER_SIZE0 != 256
; 0000 00B7    if (tx_rd_index0 == TX_BUFFER_SIZE0) tx_rd_index0=0;
	LDS  R26,_tx_rd_index0
	CPI  R26,LOW(0x40)
	BRNE _0x15
	LDI  R30,LOW(0)
	STS  _tx_rd_index0,R30
; 0000 00B8 #endif
; 0000 00B9    }
_0x15:
; 0000 00BA }
_0x14:
	RJMP _0x1B6
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Write a character to the USART0 Transmitter buffer
;#define _ALTERNATE_PUTCHAR_
;#pragma used+
;void putchar(char c)
; 0000 00C1 {
_putchar:
; 0000 00C2 while (tx_counter0 == TX_BUFFER_SIZE0);
	ST   -Y,R26
;	c -> Y+0
_0x16:
	LDS  R26,_tx_counter0
	CPI  R26,LOW(0x40)
	BREQ _0x16
; 0000 00C3 #asm("cli")
	cli
; 0000 00C4 if (tx_counter0 || ((UCSR0A & DATA_REGISTER_EMPTY)==0))
	LDS  R30,_tx_counter0
	CPI  R30,0
	BRNE _0x1A
	SBIC 0xB,5
	RJMP _0x19
_0x1A:
; 0000 00C5    {
; 0000 00C6    tx_buffer0[tx_wr_index0++]=c;
	LDS  R30,_tx_wr_index0
	SUBI R30,-LOW(1)
	STS  _tx_wr_index0,R30
	CALL SUBOPT_0x3
	LD   R26,Y
	STD  Z+0,R26
; 0000 00C7 #if TX_BUFFER_SIZE0 != 256
; 0000 00C8    if (tx_wr_index0 == TX_BUFFER_SIZE0) tx_wr_index0=0;
	LDS  R26,_tx_wr_index0
	CPI  R26,LOW(0x40)
	BRNE _0x1C
	LDI  R30,LOW(0)
	STS  _tx_wr_index0,R30
; 0000 00C9 #endif
; 0000 00CA    ++tx_counter0;
_0x1C:
	LDS  R30,_tx_counter0
	SUBI R30,-LOW(1)
	STS  _tx_counter0,R30
; 0000 00CB    }
; 0000 00CC else
	RJMP _0x1D
_0x19:
; 0000 00CD    UDR0=c;
	LD   R30,Y
	OUT  0xC,R30
; 0000 00CE #asm("sei")
_0x1D:
	sei
; 0000 00CF }
	ADIW R28,1
	RET
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
; 0000 00E8 {
_usart1_rx_isr:
	CALL SUBOPT_0x2
; 0000 00E9 char status,data;
; 0000 00EA status=UCSR1A;
	ST   -Y,R17
	ST   -Y,R16
;	status -> R17
;	data -> R16
	LDS  R17,155
; 0000 00EB data=UDR1;
	LDS  R16,156
; 0000 00EC if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x1E
; 0000 00ED    {
; 0000 00EE    rx_buffer1[rx_wr_index1++]=data;
	LDS  R30,_rx_wr_index1
	SUBI R30,-LOW(1)
	STS  _rx_wr_index1,R30
	SUBI R30,LOW(1)
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer1)
	SBCI R31,HIGH(-_rx_buffer1)
	ST   Z,R16
; 0000 00EF #if RX_BUFFER_SIZE1 == 256
; 0000 00F0    // special case for receiver buffer size=256
; 0000 00F1    if (++rx_counter1 == 0) rx_buffer_overflow1=1;
; 0000 00F2 #else
; 0000 00F3    if (rx_wr_index1 == RX_BUFFER_SIZE1) rx_wr_index1=0;
	LDS  R26,_rx_wr_index1
	CPI  R26,LOW(0x40)
	BRNE _0x1F
	LDI  R30,LOW(0)
	STS  _rx_wr_index1,R30
; 0000 00F4    if (++rx_counter1 == RX_BUFFER_SIZE1)
_0x1F:
	LDS  R26,_rx_counter1
	SUBI R26,-LOW(1)
	STS  _rx_counter1,R26
	CPI  R26,LOW(0x40)
	BRNE _0x20
; 0000 00F5       {
; 0000 00F6       rx_counter1=0;
	LDI  R30,LOW(0)
	STS  _rx_counter1,R30
; 0000 00F7       rx_buffer_overflow1=1;
	SET
	BLD  R2,1
; 0000 00F8       }
; 0000 00F9 #endif
; 0000 00FA    }
_0x20:
; 0000 00FB }
_0x1E:
	LD   R16,Y+
	LD   R17,Y+
	RJMP _0x1B6
;
;// Get a character from the USART1 Receiver buffer
;#pragma used+
;char getchar1(void)
; 0000 0100 {
; 0000 0101 char data;
; 0000 0102 while (rx_counter1==0);
;	data -> R17
; 0000 0103 data=rx_buffer1[rx_rd_index1++];
; 0000 0104 #if RX_BUFFER_SIZE1 != 256
; 0000 0105 if (rx_rd_index1 == RX_BUFFER_SIZE1) rx_rd_index1=0;
; 0000 0106 #endif
; 0000 0107 #asm("cli")
; 0000 0108 --rx_counter1;
; 0000 0109 #asm("sei")
; 0000 010A return data;
; 0000 010B }
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
; 0000 011F {
_usart1_tx_isr:
	CALL SUBOPT_0x2
; 0000 0120 if (tx_counter1)
	LDS  R30,_tx_counter1
	CPI  R30,0
	BREQ _0x25
; 0000 0121    {
; 0000 0122    --tx_counter1;
	SUBI R30,LOW(1)
	STS  _tx_counter1,R30
; 0000 0123    UDR1=tx_buffer1[tx_rd_index1++];
	LDS  R30,_tx_rd_index1
	SUBI R30,-LOW(1)
	STS  _tx_rd_index1,R30
	SUBI R30,LOW(1)
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer1)
	SBCI R31,HIGH(-_tx_buffer1)
	LD   R30,Z
	STS  156,R30
; 0000 0124 #if TX_BUFFER_SIZE1 != 256
; 0000 0125    if (tx_rd_index1 == TX_BUFFER_SIZE1) tx_rd_index1=0;
	LDS  R26,_tx_rd_index1
	CPI  R26,LOW(0x40)
	BRNE _0x26
	LDI  R30,LOW(0)
	STS  _tx_rd_index1,R30
; 0000 0126 #endif
; 0000 0127    }
_0x26:
; 0000 0128 }
_0x25:
_0x1B6:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R26,Y+
	RETI
;
;// Write a character to the USART1 Transmitter buffer
;#pragma used+
;void putchar1(char c)
; 0000 012D {
; 0000 012E while (tx_counter1 == TX_BUFFER_SIZE1);
;	c -> Y+0
; 0000 012F #asm("cli")
; 0000 0130 if (tx_counter1 || ((UCSR1A & DATA_REGISTER_EMPTY)==0))
; 0000 0131    {
; 0000 0132    tx_buffer1[tx_wr_index1++]=c;
; 0000 0133 #if TX_BUFFER_SIZE1 != 256
; 0000 0134    if (tx_wr_index1 == TX_BUFFER_SIZE1) tx_wr_index1=0;
; 0000 0135 #endif
; 0000 0136    ++tx_counter1;
; 0000 0137    }
; 0000 0138 else
; 0000 0139    UDR1=c;
; 0000 013A #asm("sei")
; 0000 013B }
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
; 0000 0147 {
_adc_isr:
	ST   -Y,R30
	ST   -Y,R31
; 0000 0148 // Read the AD conversion result
; 0000 0149 adc_data=ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
	STS  _adc_data,R30
	STS  _adc_data+1,R31
; 0000 014A }
	LD   R31,Y+
	LD   R30,Y+
	RETI
;
;// Read the AD conversion result
;// with noise canceling
;unsigned int read_adc(unsigned char adc_input)
; 0000 014F {
; 0000 0150 ADMUX=adc_input | ADC_VREF_TYPE;
;	adc_input -> Y+0
; 0000 0151 // Delay needed for the stabilization of the ADC input voltage
; 0000 0152 delay_us(10);
; 0000 0153 #asm
; 0000 0154     in   r30,mcucr
; 0000 0155     cbr  r30,__sm_mask
; 0000 0156     sbr  r30,__se_bit | __sm_adc_noise_red
; 0000 0157     out  mcucr,r30
; 0000 0158     sleep
; 0000 0159     cbr  r30,__se_bit
; 0000 015A     out  mcucr,r30
; 0000 015B #endasm
; 0000 015C return adc_data;
; 0000 015D }
;/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
;void motorright() // Close
; 0000 0160 {
_motorright:
; 0000 0161     if (RF3==1 || SPB1==1)
	SBIC 0x16,4
	RJMP _0x30
	SBIS 0x10,6
	RJMP _0x2F
_0x30:
; 0000 0162     {
; 0000 0163             while(timeOK)
_0x32:
	MOV  R0,R8
	OR   R0,R9
	BRNE PC+3
	JMP _0x34
; 0000 0164             {
; 0000 0165             Re2=1;
	SBI  0x1B,1
; 0000 0166             Re1=1;
	SBI  0x1B,0
; 0000 0167                         if (Mstop == 1 || RF2 == 1)
	SBIC 0x0,2
	RJMP _0x3A
	SBIS 0x16,3
	RJMP _0x39
_0x3A:
; 0000 0168                         {
; 0000 0169                         Re2=0;
	CALL SUBOPT_0x0
; 0000 016A                         Re3=0;
; 0000 016B                         Re4=0;
; 0000 016C                         Re1=0;
; 0000 016D                         delay_ms(10);
	CALL SUBOPT_0x4
; 0000 016E                         break;
	RJMP _0x34
; 0000 016F                         }
; 0000 0170                         if (SUP==1)
_0x39:
	SBIS 0x10,4
	RJMP _0x44
; 0000 0171                         {
; 0000 0172                         Re2=0;
	CALL SUBOPT_0x5
; 0000 0173                         Re1=0;
; 0000 0174                         delay_ms(10);
; 0000 0175                         break;
	RJMP _0x34
; 0000 0176                         }
; 0000 0177                         if (photo==1)
_0x44:
	SBIS 0x0,7
	RJMP _0x49
; 0000 0178                         {
; 0000 0179                             Re1=0;
	CBI  0x1B,0
; 0000 017A                             Re2=0;
	CBI  0x1B,1
; 0000 017B                             delay_ms(2000);
	CALL SUBOPT_0x1
; 0000 017C                             if (DS1==1)
	SBIS 0x13,0
	RJMP _0x4E
; 0000 017D                             {
; 0000 017E                                 while(1)
_0x4F:
; 0000 017F                                 {
; 0000 0180                                 Re4=1;
	SBI  0x1B,3
; 0000 0181                                 delay_ms(10);
	CALL SUBOPT_0x4
; 0000 0182                                 Re1=1;
	SBI  0x1B,0
; 0000 0183                                 delay_ms(10);
	CALL SUBOPT_0x4
; 0000 0184                                     if (Mstop == 1 || RF2 == 1)
	SBIC 0x0,2
	RJMP _0x57
	SBIS 0x16,3
	RJMP _0x56
_0x57:
; 0000 0185                                     {
; 0000 0186                                     Re2=0;
	CALL SUBOPT_0x0
; 0000 0187                                     Re3=0;
; 0000 0188                                     Re4=0;
; 0000 0189                                     Re1=0;
; 0000 018A                                     delay_ms(10);
	CALL SUBOPT_0x4
; 0000 018B                                     break;
	RJMP _0x51
; 0000 018C                                     }
; 0000 018D                                     if (SDW==1)
_0x56:
	SBIS 0x10,5
	RJMP _0x61
; 0000 018E                                     {
; 0000 018F                                     Re4=0;
	CBI  0x1B,3
; 0000 0190                                     delay_ms(10);
	CALL SUBOPT_0x4
; 0000 0191                                     Re1=0;
	CBI  0x1B,0
; 0000 0192                                     delay_ms(10);
	CALL SUBOPT_0x4
; 0000 0193                                     Re2=0;
	CALL SUBOPT_0x6
; 0000 0194                                     BUZZ=1;
; 0000 0195                                     delay_ms(3000);
; 0000 0196                                     break;
	RJMP _0x51
; 0000 0197                                     }
; 0000 0198                                 }
_0x61:
	RJMP _0x4F
_0x51:
; 0000 0199                             }
; 0000 019A                             else if (DS1==0)
	RJMP _0x6A
_0x4E:
	SBIC 0x13,0
	RJMP _0x6B
; 0000 019B                             {
; 0000 019C                               while(1)
_0x6C:
; 0000 019D                               {
; 0000 019E                                 Re4=1;
	SBI  0x1B,3
; 0000 019F                                 delay_ms(10);
	CALL SUBOPT_0x4
; 0000 01A0                                 Re1=1;
	SBI  0x1B,0
; 0000 01A1                                 delay_ms(10);
	CALL SUBOPT_0x4
; 0000 01A2                                 if (Mstop == 1 || RF2 == 1)
	SBIC 0x0,2
	RJMP _0x74
	SBIS 0x16,3
	RJMP _0x73
_0x74:
; 0000 01A3                                 {
; 0000 01A4                                 Re2=0;
	CALL SUBOPT_0x0
; 0000 01A5                                 Re3=0;
; 0000 01A6                                 Re4=0;
; 0000 01A7                                 Re1=0;
; 0000 01A8                                 delay_ms(10);
	CALL SUBOPT_0x4
; 0000 01A9                                 break;
	RJMP _0x6E
; 0000 01AA                                 }
; 0000 01AB                                 if (SDW==1)
_0x73:
	SBIS 0x10,5
	RJMP _0x7E
; 0000 01AC                                 {
; 0000 01AD                                 Re4=0;
	CBI  0x1B,3
; 0000 01AE                                 delay_ms(10);
	CALL SUBOPT_0x4
; 0000 01AF                                 Re1=0;
	CBI  0x1B,0
; 0000 01B0                                 delay_ms(10);
	CALL SUBOPT_0x4
; 0000 01B1                                 Re2=0;
	CALL SUBOPT_0x7
; 0000 01B2                                 BUZZ=1;
; 0000 01B3                                 delay_ms(9500);
; 0000 01B4                                     while(1)
_0x87:
; 0000 01B5                                     {
; 0000 01B6                                         Re2=1;
	SBI  0x1B,1
; 0000 01B7                                         Re1=1;
	SBI  0x1B,0
; 0000 01B8                                         if (Mstop == 1 || RF2 == 1)
	SBIC 0x0,2
	RJMP _0x8F
	SBIS 0x16,3
	RJMP _0x8E
_0x8F:
; 0000 01B9                                         {
; 0000 01BA                                         Re2=0;
	CALL SUBOPT_0x0
; 0000 01BB                                         Re3=0;
; 0000 01BC                                         Re4=0;
; 0000 01BD                                         Re1=0;
; 0000 01BE                                         delay_ms(10);
	CALL SUBOPT_0x4
; 0000 01BF                                         break;
	RJMP _0x89
; 0000 01C0                                         }
; 0000 01C1                                         if (SUP==1)
_0x8E:
	SBIS 0x10,4
	RJMP _0x99
; 0000 01C2                                         {
; 0000 01C3                                         Re2=0;
	CALL SUBOPT_0x5
; 0000 01C4                                         Re1=0;
; 0000 01C5                                         delay_ms(10);
; 0000 01C6                                         break;
	RJMP _0x89
; 0000 01C7                                         }
; 0000 01C8 
; 0000 01C9                                     }
_0x99:
	RJMP _0x87
_0x89:
; 0000 01CA                                 break;
	RJMP _0x6E
; 0000 01CB                                 }
; 0000 01CC                               }
_0x7E:
	RJMP _0x6C
_0x6E:
; 0000 01CD 
; 0000 01CE                             break;
	RJMP _0x34
; 0000 01CF 
; 0000 01D0                             }
; 0000 01D1                         }
_0x6B:
_0x6A:
; 0000 01D2             }
_0x49:
	RJMP _0x32
_0x34:
; 0000 01D3     }
; 0000 01D4 }
_0x2F:
	RET
;
;void motorleft() // Open
; 0000 01D7     {
_motorleft:
; 0000 01D8         if (RF4==1 || SPB2==1)
	SBIC 0x16,5
	RJMP _0x9F
	SBIS 0x10,7
	RJMP _0x9E
_0x9F:
; 0000 01D9         {
; 0000 01DA                 while(timeOK)
_0xA1:
	MOV  R0,R8
	OR   R0,R9
	BREQ _0xA3
; 0000 01DB                 {
; 0000 01DC                 Re4=1;
	SBI  0x1B,3
; 0000 01DD                 Re1=1;
	SBI  0x1B,0
; 0000 01DE                         if (Mstop == 1)
	SBIS 0x0,2
	RJMP _0xA8
; 0000 01DF                         {
; 0000 01E0                         Re2=0;
	CALL SUBOPT_0x0
; 0000 01E1                         Re3=0;
; 0000 01E2                         Re4=0;
; 0000 01E3                         Re1=0;
; 0000 01E4                         delay_ms(10);
	CALL SUBOPT_0x4
; 0000 01E5                         break;
	RJMP _0xA3
; 0000 01E6                         }
; 0000 01E7                         if (SDW==1 || RF2==1)
_0xA8:
	SBIC 0x10,5
	RJMP _0xB2
	SBIS 0x16,3
	RJMP _0xB1
_0xB2:
; 0000 01E8                         {
; 0000 01E9                         Re4=0;
	CBI  0x1B,3
; 0000 01EA                         Re1=0;
	CBI  0x1B,0
; 0000 01EB                         delay_ms(10);
	CALL SUBOPT_0x4
; 0000 01EC                         break;
	RJMP _0xA3
; 0000 01ED                         }
; 0000 01EE                         else
_0xB1:
; 0000 01EF                         {
; 0000 01F0                         continue;
	RJMP _0xA1
; 0000 01F1                         }
; 0000 01F2                 }
_0xA3:
; 0000 01F3         }
; 0000 01F4         else
_0x9E:
; 0000 01F5         {
; 0000 01F6         //Re4=0;
; 0000 01F7         //Re1=0;
; 0000 01F8         }
; 0000 01F9     }
	RET
;
;void motor()
; 0000 01FC     {
_motor:
; 0000 01FD     motorright();
	RCALL _motorright
; 0000 01FE     motorleft();
	RCALL _motorleft
; 0000 01FF     }
	RET
;
;void TCP()
; 0000 0202     {
_TCP:
; 0000 0203       E=getchar();
	RCALL _getchar
	MOV  R11,R30
; 0000 0204       if(E == 'X')
	LDI  R30,LOW(88)
	CP   R30,R11
	BREQ PC+3
	JMP _0xBA
; 0000 0205       {
; 0000 0206        printf(
; 0000 0207        "$%1d%1d%1d%1d%1d%1d,%1d%1d%1d%1d%1d%1d,%1d%1d,%1d%1d%1d%1d%1d%1d%1d%1d\n\r",
; 0000 0208        PINC.0,PINC.1,PINC.2,PINC.3,PINC.4,PINC.5,PINB.1,
; 0000 0209        PINB.2,PINB.3,PINB.4,PINB.5,PINB.6,PIND.0,PIND.1,PIND.6,PIND.7,PIND.4,PIND.5,PINF.7,PINF.2,PINF.5,PINF.6);
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,0
	SBIC 0x13,0
	LDI  R30,1
	CALL SUBOPT_0x8
	LDI  R30,0
	SBIC 0x13,1
	LDI  R30,1
	CALL SUBOPT_0x8
	LDI  R30,0
	SBIC 0x13,2
	LDI  R30,1
	CALL SUBOPT_0x8
	LDI  R30,0
	SBIC 0x13,3
	LDI  R30,1
	CALL SUBOPT_0x8
	LDI  R30,0
	SBIC 0x13,4
	LDI  R30,1
	CALL SUBOPT_0x8
	LDI  R30,0
	SBIC 0x13,5
	LDI  R30,1
	CALL SUBOPT_0x8
	LDI  R30,0
	SBIC 0x16,1
	LDI  R30,1
	CALL SUBOPT_0x8
	LDI  R30,0
	SBIC 0x16,2
	LDI  R30,1
	CALL SUBOPT_0x8
	LDI  R30,0
	SBIC 0x16,3
	LDI  R30,1
	CALL SUBOPT_0x8
	LDI  R30,0
	SBIC 0x16,4
	LDI  R30,1
	CALL SUBOPT_0x8
	LDI  R30,0
	SBIC 0x16,5
	LDI  R30,1
	CALL SUBOPT_0x8
	LDI  R30,0
	SBIC 0x16,6
	LDI  R30,1
	CALL SUBOPT_0x8
	LDI  R30,0
	SBIC 0x10,0
	LDI  R30,1
	CALL SUBOPT_0x8
	LDI  R30,0
	SBIC 0x10,1
	LDI  R30,1
	CALL SUBOPT_0x8
	LDI  R30,0
	SBIC 0x10,6
	LDI  R30,1
	CALL SUBOPT_0x8
	LDI  R30,0
	SBIC 0x10,7
	LDI  R30,1
	CALL SUBOPT_0x8
	LDI  R30,0
	SBIC 0x10,4
	LDI  R30,1
	CALL SUBOPT_0x8
	LDI  R30,0
	SBIC 0x10,5
	LDI  R30,1
	CALL SUBOPT_0x8
	LDI  R30,0
	SBIC 0x0,7
	LDI  R30,1
	CALL SUBOPT_0x8
	LDI  R30,0
	SBIC 0x0,2
	LDI  R30,1
	CALL SUBOPT_0x8
	LDI  R30,0
	SBIC 0x0,5
	LDI  R30,1
	CALL SUBOPT_0x8
	LDI  R30,0
	SBIC 0x0,6
	LDI  R30,1
	CALL SUBOPT_0x8
	LDI  R24,88
	CALL _printf
	ADIW R28,63
	ADIW R28,27
; 0000 020A       }
; 0000 020B       if( E == 'C' )
_0xBA:
	LDI  R30,LOW(67)
	CP   R30,R11
	BREQ PC+3
	JMP _0xBB
; 0000 020C       {
; 0000 020D                 while(timeOK)
_0xBC:
	MOV  R0,R8
	OR   R0,R9
	BRNE PC+3
	JMP _0xBE
; 0000 020E             {
; 0000 020F             Re2=1;
	SBI  0x1B,1
; 0000 0210             Re1=1;
	SBI  0x1B,0
; 0000 0211                         if (Mstop == 1 || RF2 == 1)
	SBIC 0x0,2
	RJMP _0xC4
	SBIS 0x16,3
	RJMP _0xC3
_0xC4:
; 0000 0212                         {
; 0000 0213                         Re2=0;
	CALL SUBOPT_0x0
; 0000 0214                         Re3=0;
; 0000 0215                         Re4=0;
; 0000 0216                         Re1=0;
; 0000 0217                         delay_ms(10);
	CALL SUBOPT_0x4
; 0000 0218                         break;
	RJMP _0xBE
; 0000 0219                         }
; 0000 021A                         if (SUP==1)
_0xC3:
	SBIS 0x10,4
	RJMP _0xCE
; 0000 021B                         {
; 0000 021C                         Re2=0;
	CALL SUBOPT_0x5
; 0000 021D                         Re1=0;
; 0000 021E                         delay_ms(10);
; 0000 021F                         break;
	RJMP _0xBE
; 0000 0220                         }
; 0000 0221                         if (photo==1)
_0xCE:
	SBIS 0x0,7
	RJMP _0xD3
; 0000 0222                         {
; 0000 0223                             Re1=0;
	CBI  0x1B,0
; 0000 0224                             Re2=0;
	CBI  0x1B,1
; 0000 0225                             delay_ms(2000);
	CALL SUBOPT_0x1
; 0000 0226                             if (DS1==1)
	SBIS 0x13,0
	RJMP _0xD8
; 0000 0227                             {
; 0000 0228                                 while(1)
_0xD9:
; 0000 0229                                 {
; 0000 022A                                 Re4=1;
	SBI  0x1B,3
; 0000 022B                                 delay_ms(10);
	CALL SUBOPT_0x4
; 0000 022C                                 Re1=1;
	SBI  0x1B,0
; 0000 022D                                 delay_ms(10);
	CALL SUBOPT_0x4
; 0000 022E                                     if (Mstop == 1 || RF2 == 1)
	SBIC 0x0,2
	RJMP _0xE1
	SBIS 0x16,3
	RJMP _0xE0
_0xE1:
; 0000 022F                                     {
; 0000 0230                                     Re2=0;
	CALL SUBOPT_0x0
; 0000 0231                                     Re3=0;
; 0000 0232                                     Re4=0;
; 0000 0233                                     Re1=0;
; 0000 0234                                     delay_ms(10);
	CALL SUBOPT_0x4
; 0000 0235                                     break;
	RJMP _0xDB
; 0000 0236                                     }
; 0000 0237                                     if (SDW==1)
_0xE0:
	SBIS 0x10,5
	RJMP _0xEB
; 0000 0238                                     {
; 0000 0239                                     Re4=0;
	CBI  0x1B,3
; 0000 023A                                     delay_ms(10);
	CALL SUBOPT_0x4
; 0000 023B                                     Re1=0;
	CBI  0x1B,0
; 0000 023C                                     delay_ms(10);
	CALL SUBOPT_0x4
; 0000 023D                                     Re2=0;
	CALL SUBOPT_0x6
; 0000 023E                                     BUZZ=1;
; 0000 023F                                     delay_ms(3000);
; 0000 0240                                     break;
	RJMP _0xDB
; 0000 0241                                     }
; 0000 0242                                 }
_0xEB:
	RJMP _0xD9
_0xDB:
; 0000 0243                             }
; 0000 0244                             else if (DS1==0)
	RJMP _0xF4
_0xD8:
	SBIC 0x13,0
	RJMP _0xF5
; 0000 0245                             {
; 0000 0246                               while(1)
_0xF6:
; 0000 0247                               {
; 0000 0248                                 Re4=1;
	SBI  0x1B,3
; 0000 0249                                 delay_ms(10);
	CALL SUBOPT_0x4
; 0000 024A                                 Re1=1;
	SBI  0x1B,0
; 0000 024B                                 delay_ms(10);
	CALL SUBOPT_0x4
; 0000 024C                                 if (Mstop == 1 || RF2 == 1)
	SBIC 0x0,2
	RJMP _0xFE
	SBIS 0x16,3
	RJMP _0xFD
_0xFE:
; 0000 024D                                 {
; 0000 024E                                 Re2=0;
	CALL SUBOPT_0x0
; 0000 024F                                 Re3=0;
; 0000 0250                                 Re4=0;
; 0000 0251                                 Re1=0;
; 0000 0252                                 delay_ms(10);
	CALL SUBOPT_0x4
; 0000 0253                                 break;
	RJMP _0xF8
; 0000 0254                                 }
; 0000 0255                                 if (SDW==1)
_0xFD:
	SBIS 0x10,5
	RJMP _0x108
; 0000 0256                                 {
; 0000 0257                                 Re4=0;
	CBI  0x1B,3
; 0000 0258                                 delay_ms(10);
	CALL SUBOPT_0x4
; 0000 0259                                 Re1=0;
	CBI  0x1B,0
; 0000 025A                                 delay_ms(10);
	CALL SUBOPT_0x4
; 0000 025B                                 Re2=0;
	CALL SUBOPT_0x7
; 0000 025C                                 BUZZ=1;
; 0000 025D                                 delay_ms(9500);
; 0000 025E                                     while(1)
_0x111:
; 0000 025F                                     {
; 0000 0260                                         Re2=1;
	SBI  0x1B,1
; 0000 0261                                         Re1=1;
	SBI  0x1B,0
; 0000 0262                                         if (Mstop == 1 || RF2 == 1)
	SBIC 0x0,2
	RJMP _0x119
	SBIS 0x16,3
	RJMP _0x118
_0x119:
; 0000 0263                                         {
; 0000 0264                                         Re2=0;
	CALL SUBOPT_0x0
; 0000 0265                                         Re3=0;
; 0000 0266                                         Re4=0;
; 0000 0267                                         Re1=0;
; 0000 0268                                         delay_ms(10);
	CALL SUBOPT_0x4
; 0000 0269                                         break;
	RJMP _0x113
; 0000 026A                                         }
; 0000 026B                                         if (SUP==1)
_0x118:
	SBIS 0x10,4
	RJMP _0x123
; 0000 026C                                         {
; 0000 026D                                         Re2=0;
	CALL SUBOPT_0x5
; 0000 026E                                         Re1=0;
; 0000 026F                                         delay_ms(10);
; 0000 0270                                         break;
	RJMP _0x113
; 0000 0271                                         }
; 0000 0272 
; 0000 0273                                     }
_0x123:
	RJMP _0x111
_0x113:
; 0000 0274                                 break;
	RJMP _0xF8
; 0000 0275                                 }
; 0000 0276                               }
_0x108:
	RJMP _0xF6
_0xF8:
; 0000 0277 
; 0000 0278                             break;
	RJMP _0xBE
; 0000 0279 
; 0000 027A                             }
; 0000 027B                         }
_0xF5:
_0xF4:
; 0000 027C             }
_0xD3:
	RJMP _0xBC
_0xBE:
; 0000 027D       }
; 0000 027E       else if( E == 'O' )
	RJMP _0x128
_0xBB:
	LDI  R30,LOW(79)
	CP   R30,R11
	BRNE _0x129
; 0000 027F       {
; 0000 0280                 while(timeOK)
_0x12A:
	MOV  R0,R8
	OR   R0,R9
	BREQ _0x12C
; 0000 0281                 {
; 0000 0282                 Re4=1;
	SBI  0x1B,3
; 0000 0283                 Re1=1;
	SBI  0x1B,0
; 0000 0284                         if (Mstop == 1)
	SBIS 0x0,2
	RJMP _0x131
; 0000 0285                         {
; 0000 0286                         Re2=0;
	CALL SUBOPT_0x0
; 0000 0287                         Re3=0;
; 0000 0288                         Re4=0;
; 0000 0289                         Re1=0;
; 0000 028A                         delay_ms(10);
	CALL SUBOPT_0x4
; 0000 028B                         break;
	RJMP _0x12C
; 0000 028C                         }
; 0000 028D                         if (SDW==1 || RF2==1)
_0x131:
	SBIC 0x10,5
	RJMP _0x13B
	SBIS 0x16,3
	RJMP _0x13A
_0x13B:
; 0000 028E                         {
; 0000 028F                         Re4=0;
	CBI  0x1B,3
; 0000 0290                         Re1=0;
	CBI  0x1B,0
; 0000 0291                         delay_ms(10);
	CALL SUBOPT_0x4
; 0000 0292                         break;
	RJMP _0x12C
; 0000 0293                         }
; 0000 0294                         else
_0x13A:
; 0000 0295                         {
; 0000 0296                         continue;
	RJMP _0x12A
; 0000 0297                         }
; 0000 0298                 }
_0x12C:
; 0000 0299         }
; 0000 029A 
; 0000 029B       else if(E == 'S' )
	RJMP _0x142
_0x129:
	LDI  R30,LOW(83)
	CP   R30,R11
	BRNE _0x143
; 0000 029C       {
; 0000 029D                 Re4=0;
	CBI  0x1B,3
; 0000 029E                 Re1=0;
	CBI  0x1B,0
; 0000 029F                 Re2=0;
	CBI  0x1B,1
; 0000 02A0       }
; 0000 02A1       else if( E == 'A' )
	RJMP _0x14A
_0x143:
	LDI  R30,LOW(65)
	CP   R30,R11
	BRNE _0x14B
; 0000 02A2       {
; 0000 02A3       Re1 = (Re1 == 1)?0:1;
	SBIS 0x1B,0
	RJMP _0x14C
	LDI  R30,LOW(0)
	RJMP _0x14D
_0x14C:
	LDI  R30,LOW(1)
_0x14D:
	CPI  R30,0
	BRNE _0x14F
	CBI  0x1B,0
	RJMP _0x150
_0x14F:
	SBI  0x1B,0
_0x150:
; 0000 02A4       }
; 0000 02A5       else if( E == 'B' )
	RJMP _0x151
_0x14B:
	LDI  R30,LOW(66)
	CP   R30,R11
	BRNE _0x152
; 0000 02A6       {
; 0000 02A7       Re2 = (Re2 == 1)?0:1;
	SBIS 0x1B,1
	RJMP _0x153
	LDI  R30,LOW(0)
	RJMP _0x154
_0x153:
	LDI  R30,LOW(1)
_0x154:
	CPI  R30,0
	BRNE _0x156
	CBI  0x1B,1
	RJMP _0x157
_0x156:
	SBI  0x1B,1
_0x157:
; 0000 02A8       }
; 0000 02A9       else if( E == 'D' )
	RJMP _0x158
_0x152:
	LDI  R30,LOW(68)
	CP   R30,R11
	BRNE _0x159
; 0000 02AA       {
; 0000 02AB       Re3 = (Re3 == 1)?0:1;
	SBIS 0x1B,2
	RJMP _0x15A
	LDI  R30,LOW(0)
	RJMP _0x15B
_0x15A:
	LDI  R30,LOW(1)
_0x15B:
	CPI  R30,0
	BRNE _0x15D
	CBI  0x1B,2
	RJMP _0x15E
_0x15D:
	SBI  0x1B,2
_0x15E:
; 0000 02AC       }
; 0000 02AD       else if( E == 'E' )
	RJMP _0x15F
_0x159:
	LDI  R30,LOW(69)
	CP   R30,R11
	BRNE _0x160
; 0000 02AE       {
; 0000 02AF       Re4 = (Re4 == 1)?0:1;
	SBIS 0x1B,3
	RJMP _0x161
	LDI  R30,LOW(0)
	RJMP _0x162
_0x161:
	LDI  R30,LOW(1)
_0x162:
	CPI  R30,0
	BRNE _0x164
	CBI  0x1B,3
	RJMP _0x165
_0x164:
	SBI  0x1B,3
_0x165:
; 0000 02B0       }
; 0000 02B1       else if( E == 'F' )
	RJMP _0x166
_0x160:
	LDI  R30,LOW(70)
	CP   R30,R11
	BRNE _0x167
; 0000 02B2       {
; 0000 02B3       BUZZ = (BUZZ == 1)?0:1;
	SBIS 0x15,7
	RJMP _0x168
	LDI  R30,LOW(0)
	RJMP _0x169
_0x168:
	LDI  R30,LOW(1)
_0x169:
	CPI  R30,0
	BRNE _0x16B
	CBI  0x15,7
	RJMP _0x16C
_0x16B:
	SBI  0x15,7
_0x16C:
; 0000 02B4       }
; 0000 02B5       else if( E == 'G' )
	RJMP _0x16D
_0x167:
	LDI  R30,LOW(71)
	CP   R30,R11
	BRNE _0x16E
; 0000 02B6       {
; 0000 02B7       LEDS2 = (LEDS2 == 1)?0:1;
	SBIS 0x15,6
	RJMP _0x16F
	LDI  R30,LOW(0)
	RJMP _0x170
_0x16F:
	LDI  R30,LOW(1)
_0x170:
	CPI  R30,0
	BRNE _0x172
	CBI  0x15,6
	RJMP _0x173
_0x172:
	SBI  0x15,6
_0x173:
; 0000 02B8       }
; 0000 02B9       else if( E == 'H' )
	RJMP _0x174
_0x16E:
	LDI  R30,LOW(72)
	CP   R30,R11
	BRNE _0x175
; 0000 02BA       {
; 0000 02BB       LEDS1 = (LEDS1 == 1)?0:1;
	SBIS 0x1B,7
	RJMP _0x176
	LDI  R30,LOW(0)
	RJMP _0x177
_0x176:
	LDI  R30,LOW(1)
_0x177:
	CPI  R30,0
	BRNE _0x179
	CBI  0x1B,7
	RJMP _0x17A
_0x179:
	SBI  0x1B,7
_0x17A:
; 0000 02BC       }
; 0000 02BD     }
_0x175:
_0x174:
_0x16D:
_0x166:
_0x15F:
_0x158:
_0x151:
_0x14A:
_0x142:
_0x128:
	RET
;void Run()
; 0000 02BF     {
_Run:
; 0000 02C0         LEDS1=!LEDS1; delay_ms(100);
	SBIS 0x1B,7
	RJMP _0x17B
	CBI  0x1B,7
	RJMP _0x17C
_0x17B:
	SBI  0x1B,7
_0x17C:
	CALL SUBOPT_0x9
; 0000 02C1         LEDS2=!LEDS2; delay_ms(100);
	SBIS 0x15,6
	RJMP _0x17D
	CBI  0x15,6
	RJMP _0x17E
_0x17D:
	SBI  0x15,6
_0x17E:
	CALL SUBOPT_0x9
; 0000 02C2         LEDS1=!LEDS1; delay_ms(100);
	SBIS 0x1B,7
	RJMP _0x17F
	CBI  0x1B,7
	RJMP _0x180
_0x17F:
	SBI  0x1B,7
_0x180:
	CALL SUBOPT_0x9
; 0000 02C3         LEDS2=!LEDS2; delay_ms(100);
	SBIS 0x15,6
	RJMP _0x181
	CBI  0x15,6
	RJMP _0x182
_0x181:
	SBI  0x15,6
_0x182:
	CALL SUBOPT_0x9
; 0000 02C4         LEDS1=!LEDS1; delay_ms(100);
	SBIS 0x1B,7
	RJMP _0x183
	CBI  0x1B,7
	RJMP _0x184
_0x183:
	SBI  0x1B,7
_0x184:
	CALL SUBOPT_0x9
; 0000 02C5         LEDS2=!LEDS2; delay_ms(100);
	SBIS 0x15,6
	RJMP _0x185
	CBI  0x15,6
	RJMP _0x186
_0x185:
	SBI  0x15,6
_0x186:
	CALL SUBOPT_0x9
; 0000 02C6         LEDS1=!LEDS1; delay_ms(100);
	SBIS 0x1B,7
	RJMP _0x187
	CBI  0x1B,7
	RJMP _0x188
_0x187:
	SBI  0x1B,7
_0x188:
	CALL SUBOPT_0x9
; 0000 02C7         LEDS2=!LEDS2; delay_ms(100);
	SBIS 0x15,6
	RJMP _0x189
	CBI  0x15,6
	RJMP _0x18A
_0x189:
	SBI  0x15,6
_0x18A:
	CALL SUBOPT_0x9
; 0000 02C8         LEDS1=!LEDS1; delay_ms(100);
	SBIS 0x1B,7
	RJMP _0x18B
	CBI  0x1B,7
	RJMP _0x18C
_0x18B:
	SBI  0x1B,7
_0x18C:
	CALL SUBOPT_0x9
; 0000 02C9         LEDS2=!LEDS2; delay_ms(100);
	SBIS 0x15,6
	RJMP _0x18D
	CBI  0x15,6
	RJMP _0x18E
_0x18D:
	SBI  0x15,6
_0x18E:
	CALL SUBOPT_0x9
; 0000 02CA         LEDS1=!LEDS1; delay_ms(100);
	SBIS 0x1B,7
	RJMP _0x18F
	CBI  0x1B,7
	RJMP _0x190
_0x18F:
	SBI  0x1B,7
_0x190:
	CALL SUBOPT_0x9
; 0000 02CB         LEDS2=!LEDS2; delay_ms(100);
	SBIS 0x15,6
	RJMP _0x191
	CBI  0x15,6
	RJMP _0x192
_0x191:
	SBI  0x15,6
_0x192:
	CALL SUBOPT_0x9
; 0000 02CC         LEDS1=!LEDS1; delay_ms(100);
	SBIS 0x1B,7
	RJMP _0x193
	CBI  0x1B,7
	RJMP _0x194
_0x193:
	SBI  0x1B,7
_0x194:
	CALL SUBOPT_0x9
; 0000 02CD         LEDS2=!LEDS2; delay_ms(100);
	SBIS 0x15,6
	RJMP _0x195
	CBI  0x15,6
	RJMP _0x196
_0x195:
	SBI  0x15,6
_0x196:
	CALL SUBOPT_0x9
; 0000 02CE         LEDS1=1;
	SBI  0x1B,7
; 0000 02CF         LEDS2=0;
	CBI  0x15,6
; 0000 02D0         BUZZ=0;
	CBI  0x15,7
; 0000 02D1         delay_ms(60);
	LDI  R26,LOW(60)
	LDI  R27,0
	CALL _delay_ms
; 0000 02D2         BUZZ=1;
	SBI  0x15,7
; 0000 02D3         delay_ms(15);
	LDI  R26,LOW(15)
	LDI  R27,0
	CALL _delay_ms
; 0000 02D4     }
	RET
;
;//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
;
;void main(void)
; 0000 02D9 {
_main:
; 0000 02DA // Declare your local variables here
; 0000 02DB 
; 0000 02DC // Input/Output Ports initialization
; 0000 02DD // Port A initialization
; 0000 02DE // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 02DF DDRA=(1<<DDA7) | (1<<DDA6) | (1<<DDA5) | (1<<DDA4) | (1<<DDA3) | (1<<DDA2) | (1<<DDA1) | (1<<DDA0);
	LDI  R30,LOW(255)
	OUT  0x1A,R30
; 0000 02E0 // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 02E1 PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 02E2 
; 0000 02E3 // Port B initialization
; 0000 02E4 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 02E5 DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	OUT  0x17,R30
; 0000 02E6 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 02E7 PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	OUT  0x18,R30
; 0000 02E8 
; 0000 02E9 // Port C initialization
; 0000 02EA // Function: Bit7=Out Bit6=Out Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 02EB DDRC=(1<<DDC7) | (1<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	LDI  R30,LOW(192)
	OUT  0x14,R30
; 0000 02EC // State: Bit7=1 Bit6=0 Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 02ED PORTC=(1<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	LDI  R30,LOW(128)
	OUT  0x15,R30
; 0000 02EE 
; 0000 02EF // Port D initialization
; 0000 02F0 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 02F1 DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	LDI  R30,LOW(0)
	OUT  0x11,R30
; 0000 02F2 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 02F3 PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	OUT  0x12,R30
; 0000 02F4 
; 0000 02F5 // Port E initialization
; 0000 02F6 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 02F7 DDRE=(0<<DDE7) | (0<<DDE6) | (0<<DDE5) | (0<<DDE4) | (0<<DDE3) | (0<<DDE2) | (0<<DDE1) | (0<<DDE0);
	OUT  0x2,R30
; 0000 02F8 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 02F9 PORTE=(0<<PORTE7) | (0<<PORTE6) | (0<<PORTE5) | (0<<PORTE4) | (0<<PORTE3) | (0<<PORTE2) | (0<<PORTE1) | (0<<PORTE0);
	OUT  0x3,R30
; 0000 02FA 
; 0000 02FB // Port F initialization
; 0000 02FC // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 02FD DDRF=(0<<DDF7) | (0<<DDF6) | (0<<DDF5) | (0<<DDF4) | (0<<DDF3) | (0<<DDF2) | (0<<DDF1) | (0<<DDF0);
	STS  97,R30
; 0000 02FE // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 02FF PORTF=(0<<PORTF7) | (0<<PORTF6) | (0<<PORTF5) | (0<<PORTF4) | (0<<PORTF3) | (0<<PORTF2) | (0<<PORTF1) | (0<<PORTF0);
	STS  98,R30
; 0000 0300 
; 0000 0301 // Port G initialization
; 0000 0302 // Function: Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0303 DDRG=(0<<DDG4) | (0<<DDG3) | (0<<DDG2) | (0<<DDG1) | (0<<DDG0);
	STS  100,R30
; 0000 0304 // State: Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0305 PORTG=(0<<PORTG4) | (0<<PORTG3) | (0<<PORTG2) | (0<<PORTG1) | (0<<PORTG0);
	STS  101,R30
; 0000 0306 
; 0000 0307 // Timer/Counter 0 initialization
; 0000 0308 // Clock source: System Clock
; 0000 0309 // Clock value: 14.400 kHz
; 0000 030A // Mode: Normal top=0xFF
; 0000 030B // OC0 output: Disconnected
; 0000 030C ASSR=0x00;
	OUT  0x30,R30
; 0000 030D TCCR0=0x07;
	LDI  R30,LOW(7)
	OUT  0x33,R30
; 0000 030E TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 030F OCR0=0x00;
	OUT  0x31,R30
; 0000 0310 
; 0000 0311 // Timer/Counter 1 initialization
; 0000 0312 // Clock source: System Clock
; 0000 0313 // Clock value: Timer1 Stopped
; 0000 0314 // Mode: Normal top=0xFFFF
; 0000 0315 // OC1A output: Disconnected
; 0000 0316 // OC1B output: Disconnected
; 0000 0317 // OC1C output: Disconnected
; 0000 0318 // Noise Canceler: Off
; 0000 0319 // Input Capture on Falling Edge
; 0000 031A // Timer1 Overflow Interrupt: Off
; 0000 031B // Input Capture Interrupt: Off
; 0000 031C // Compare A Match Interrupt: Off
; 0000 031D // Compare B Match Interrupt: Off
; 0000 031E // Compare C Match Interrupt: Off
; 0000 031F TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<COM1C1) | (0<<COM1C0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0000 0320 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	OUT  0x2E,R30
; 0000 0321 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 0322 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0323 ICR1H=0x00;
	OUT  0x27,R30
; 0000 0324 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0325 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0326 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0327 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0328 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0329 OCR1CH=0x00;
	STS  121,R30
; 0000 032A OCR1CL=0x00;
	STS  120,R30
; 0000 032B 
; 0000 032C // Timer/Counter 2 initialization
; 0000 032D // Clock source: System Clock
; 0000 032E // Clock value: Timer2 Stopped
; 0000 032F // Mode: Normal top=0xFF
; 0000 0330 // OC2 output: Disconnected
; 0000 0331 TCCR2=(0<<WGM20) | (0<<COM21) | (0<<COM20) | (0<<WGM21) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 0332 TCNT2=0x00;
	OUT  0x24,R30
; 0000 0333 OCR2=0x00;
	OUT  0x23,R30
; 0000 0334 
; 0000 0335 // Timer/Counter 3 initialization
; 0000 0336 // Clock source: System Clock
; 0000 0337 // Clock value: Timer3 Stopped
; 0000 0338 // Mode: Normal top=0xFFFF
; 0000 0339 // OC3A output: Disconnected
; 0000 033A // OC3B output: Disconnected
; 0000 033B // OC3C output: Disconnected
; 0000 033C // Noise Canceler: Off
; 0000 033D // Input Capture on Falling Edge
; 0000 033E // Timer3 Overflow Interrupt: Off
; 0000 033F // Input Capture Interrupt: Off
; 0000 0340 // Compare A Match Interrupt: Off
; 0000 0341 // Compare B Match Interrupt: Off
; 0000 0342 // Compare C Match Interrupt: Off
; 0000 0343 TCCR3A=(0<<COM3A1) | (0<<COM3A0) | (0<<COM3B1) | (0<<COM3B0) | (0<<COM3C1) | (0<<COM3C0) | (0<<WGM31) | (0<<WGM30);
	STS  139,R30
; 0000 0344 TCCR3B=(0<<ICNC3) | (0<<ICES3) | (0<<WGM33) | (0<<WGM32) | (0<<CS32) | (0<<CS31) | (0<<CS30);
	STS  138,R30
; 0000 0345 TCNT3H=0x00;
	STS  137,R30
; 0000 0346 TCNT3L=0x00;
	STS  136,R30
; 0000 0347 ICR3H=0x00;
	STS  129,R30
; 0000 0348 ICR3L=0x00;
	STS  128,R30
; 0000 0349 OCR3AH=0x00;
	STS  135,R30
; 0000 034A OCR3AL=0x00;
	STS  134,R30
; 0000 034B OCR3BH=0x00;
	STS  133,R30
; 0000 034C OCR3BL=0x00;
	STS  132,R30
; 0000 034D OCR3CH=0x00;
	STS  131,R30
; 0000 034E OCR3CL=0x00;
	STS  130,R30
; 0000 034F 
; 0000 0350 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0351 TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
	OUT  0x37,R30
; 0000 0352 ETIMSK=(0<<TICIE3) | (0<<OCIE3A) | (0<<OCIE3B) | (0<<TOIE3) | (0<<OCIE3C) | (0<<OCIE1C);
	STS  125,R30
; 0000 0353 
; 0000 0354 // External Interrupt(s) initialization
; 0000 0355 // INT0: Off
; 0000 0356 // INT1: Off
; 0000 0357 // INT2: Off
; 0000 0358 // INT3: Off
; 0000 0359 // INT4: Off
; 0000 035A // INT5: Off
; 0000 035B // INT6: Off
; 0000 035C // INT7: Off
; 0000 035D EICRA=(0<<ISC31) | (0<<ISC30) | (0<<ISC21) | (0<<ISC20) | (0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	STS  106,R30
; 0000 035E EICRB=(0<<ISC71) | (0<<ISC70) | (0<<ISC61) | (0<<ISC60) | (0<<ISC51) | (0<<ISC50) | (0<<ISC41) | (0<<ISC40);
	OUT  0x3A,R30
; 0000 035F EIMSK=(0<<INT7) | (0<<INT6) | (0<<INT5) | (0<<INT4) | (0<<INT3) | (0<<INT2) | (0<<INT1) | (0<<INT0);
	OUT  0x39,R30
; 0000 0360 
; 0000 0361 // USART0 initialization
; 0000 0362 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 0363 // USART0 Receiver: On
; 0000 0364 // USART0 Transmitter: On
; 0000 0365 // USART0 Mode: Asynchronous
; 0000 0366 // USART0 Baud Rate: 115200
; 0000 0367 UCSR0A=(0<<RXC0) | (0<<TXC0) | (0<<UDRE0) | (0<<FE0) | (0<<DOR0) | (0<<UPE0) | (0<<U2X0) | (0<<MPCM0);
	OUT  0xB,R30
; 0000 0368 UCSR0B=(1<<RXCIE0) | (1<<TXCIE0) | (0<<UDRIE0) | (1<<RXEN0) | (1<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
	LDI  R30,LOW(216)
	OUT  0xA,R30
; 0000 0369 UCSR0C=(0<<UMSEL0) | (0<<UPM01) | (0<<UPM00) | (0<<USBS0) | (1<<UCSZ01) | (1<<UCSZ00) | (0<<UCPOL0);
	LDI  R30,LOW(6)
	STS  149,R30
; 0000 036A UBRR0H=0x00;
	LDI  R30,LOW(0)
	STS  144,R30
; 0000 036B UBRR0L=0x07;
	LDI  R30,LOW(7)
	OUT  0x9,R30
; 0000 036C 
; 0000 036D // USART1 initialization
; 0000 036E // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 036F // USART1 Receiver: On
; 0000 0370 // USART1 Transmitter: On
; 0000 0371 // USART1 Mode: Asynchronous
; 0000 0372 // USART1 Baud Rate: 115200
; 0000 0373 UCSR1A=(0<<RXC1) | (0<<TXC1) | (0<<UDRE1) | (0<<FE1) | (0<<DOR1) | (0<<UPE1) | (0<<U2X1) | (0<<MPCM1);
	LDI  R30,LOW(0)
	STS  155,R30
; 0000 0374 UCSR1B=(1<<RXCIE1) | (1<<TXCIE1) | (0<<UDRIE1) | (1<<RXEN1) | (1<<TXEN1) | (0<<UCSZ12) | (0<<RXB81) | (0<<TXB81);
	LDI  R30,LOW(216)
	STS  154,R30
; 0000 0375 UCSR1C=(0<<UMSEL1) | (0<<UPM11) | (0<<UPM10) | (0<<USBS1) | (1<<UCSZ11) | (1<<UCSZ10) | (0<<UCPOL1);
	LDI  R30,LOW(6)
	STS  157,R30
; 0000 0376 UBRR1H=0x00;
	LDI  R30,LOW(0)
	STS  152,R30
; 0000 0377 UBRR1L=0x07;
	LDI  R30,LOW(7)
	STS  153,R30
; 0000 0378 
; 0000 0379 // Analog Comparator initialization
; 0000 037A // Analog Comparator: Off
; 0000 037B // The Analog Comparator's positive input is
; 0000 037C // connected to the AIN0 pin
; 0000 037D // The Analog Comparator's negative input is
; 0000 037E // connected to the AIN1 pin
; 0000 037F ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0380 
; 0000 0381 // ADC initialization
; 0000 0382 // ADC Clock frequency: 921.600 kHz
; 0000 0383 // ADC Voltage Reference: AVCC pin
; 0000 0384 ADMUX=ADC_VREF_TYPE;
	LDI  R30,LOW(64)
	OUT  0x7,R30
; 0000 0385 ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (1<<ADIE) | (1<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	LDI  R30,LOW(140)
	OUT  0x6,R30
; 0000 0386 SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 0387 
; 0000 0388 // SPI initialization
; 0000 0389 // SPI disabled
; 0000 038A SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 038B 
; 0000 038C // TWI initialization
; 0000 038D // TWI disabled
; 0000 038E TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	STS  116,R30
; 0000 038F 
; 0000 0390 // Global enable interrupts
; 0000 0391 #asm("sei")
	sei
; 0000 0392 Run();
	RCALL _Run
; 0000 0393 while (1)
_0x19F:
; 0000 0394       {
; 0000 0395         if ( DS6 == 0 )
	SBIC 0x13,5
	RJMP _0x1A2
; 0000 0396         {
; 0000 0397             if(rx_counter0 > 0)
	LDI  R30,LOW(0)
	CP   R30,R12
	BRSH _0x1A3
; 0000 0398             {
; 0000 0399                 TCP();
	RCALL _TCP
; 0000 039A                 motor();
	RJMP _0x1B5
; 0000 039B             }
; 0000 039C             else if (rx_counter0==0)
_0x1A3:
	TST  R12
	BRNE _0x1A5
; 0000 039D             {
; 0000 039E                 motor();
_0x1B5:
	RCALL _motor
; 0000 039F             }
; 0000 03A0         }
_0x1A5:
; 0000 03A1         else if ( DS6 == 1 )
	RJMP _0x1A6
_0x1A2:
	SBIC 0x13,5
; 0000 03A2         {
; 0000 03A3         motor();
	RCALL _motor
; 0000 03A4         }
; 0000 03A5 
; 0000 03A6         if ( DS3 == 0 )
_0x1A6:
	SBIC 0x13,2
	RJMP _0x1A8
; 0000 03A7         {
; 0000 03A8             if ( SW2==0)
	SBIC 0x10,1
	RJMP _0x1A9
; 0000 03A9             {
; 0000 03AA             LEDS2=1;
	SBI  0x15,6
; 0000 03AB             delay_ms(100);
	CALL SUBOPT_0x9
; 0000 03AC             LEDS2=0;
	CBI  0x15,6
; 0000 03AD             delay_ms(100);
	CALL SUBOPT_0x9
; 0000 03AE             }
; 0000 03AF         }
_0x1A9:
; 0000 03B0         if ( DS2 == 0 )
_0x1A8:
	SBIC 0x13,1
	RJMP _0x1AE
; 0000 03B1         {
; 0000 03B2             if ( SW1==0)
	SBIC 0x10,0
	RJMP _0x1AF
; 0000 03B3             {
; 0000 03B4             BUZZ=0;
	CBI  0x15,7
; 0000 03B5             delay_ms(100);
	CALL SUBOPT_0x9
; 0000 03B6             BUZZ=1;
	SBI  0x15,7
; 0000 03B7             delay_ms(100);
	CALL SUBOPT_0x9
; 0000 03B8             }
; 0000 03B9         }
_0x1AF:
; 0000 03BA 
; 0000 03BB       }
_0x1AE:
	RJMP _0x19F
; 0000 03BC }
_0x1B4:
	RJMP _0x1B4

	.CSEG

	.DSEG

	.CSEG

	.CSEG
_strlen:
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
_strlenf:
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
__print_G102:
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
	BRNE PC+3
	JMP _0x2040018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x204001C
	CPI  R18,37
	BRNE _0x204001D
	LDI  R17,LOW(1)
	RJMP _0x204001E
_0x204001D:
	CALL SUBOPT_0xA
_0x204001E:
	RJMP _0x204001B
_0x204001C:
	CPI  R30,LOW(0x1)
	BRNE _0x204001F
	CPI  R18,37
	BRNE _0x2040020
	CALL SUBOPT_0xA
	RJMP _0x20400C9
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
	BREQ PC+3
	JMP _0x204001B
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
	CALL SUBOPT_0xB
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0xC
	RJMP _0x2040030
_0x204002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2040032
	CALL SUBOPT_0xB
	CALL SUBOPT_0xD
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2040033
_0x2040032:
	CPI  R30,LOW(0x70)
	BRNE _0x2040035
	CALL SUBOPT_0xB
	CALL SUBOPT_0xD
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
	BREQ PC+3
	JMP _0x2040071
_0x2040040:
	LDI  R30,LOW(_tbl16_G102*2)
	LDI  R31,HIGH(_tbl16_G102*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x204003D:
	SBRS R16,2
	RJMP _0x2040042
	CALL SUBOPT_0xB
	CALL SUBOPT_0xE
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
	CALL SUBOPT_0xB
	CALL SUBOPT_0xE
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
	CALL SUBOPT_0xA
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
	CALL SUBOPT_0xA
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
	RJMP _0x20400CA
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
_0x20400CA:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x204006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	CALL SUBOPT_0xC
	CPI  R21,0
	BREQ _0x204006B
	SUBI R21,LOW(1)
_0x204006B:
_0x204006A:
_0x2040069:
_0x2040061:
	CALL SUBOPT_0xA
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
	CALL SUBOPT_0xC
	RJMP _0x204006E
_0x2040070:
_0x204006D:
_0x2040071:
_0x2040030:
_0x20400C9:
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
_printf:
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

	.CSEG

	.CSEG

	.DSEG
_rx_buffer0:
	.BYTE 0x40
_tx_buffer0:
	.BYTE 0x40
_tx_wr_index0:
	.BYTE 0x1
_tx_rd_index0:
	.BYTE 0x1
_tx_counter0:
	.BYTE 0x1
_rx_buffer1:
	.BYTE 0x40
_rx_wr_index1:
	.BYTE 0x1
_rx_rd_index1:
	.BYTE 0x1
_rx_counter1:
	.BYTE 0x1
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
;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x0:
	CBI  0x1B,1
	CBI  0x1B,2
	CBI  0x1B,3
	CBI  0x1B,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2:
	ST   -Y,R26
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	SUBI R30,LOW(1)
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer0)
	SBCI R31,HIGH(-_tx_buffer0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 32 TIMES, CODE SIZE REDUCTION:121 WORDS
SUBOPT_0x4:
	LDI  R26,LOW(10)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5:
	CBI  0x1B,1
	CBI  0x1B,0
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	CBI  0x1B,1
	SBI  0x15,7
	LDI  R26,LOW(3000)
	LDI  R27,HIGH(3000)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	CBI  0x1B,1
	SBI  0x15,7
	LDI  R26,LOW(9500)
	LDI  R27,HIGH(9500)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 22 TIMES, CODE SIZE REDUCTION:60 WORDS
SUBOPT_0x8:
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 18 TIMES, CODE SIZE REDUCTION:65 WORDS
SUBOPT_0x9:
	LDI  R26,LOW(100)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xA:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xB:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xC:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xD:
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
SUBOPT_0xE:
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
