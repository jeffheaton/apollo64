*= 49152:;.OBJ "INTERFACE1.0"

TI =$A0
TEMP1 =$FB
TEMP2 =$FC
MSG'PTR =$FE

REC'BUFFER =$0C00
TRN'BUFFER =$0D00
UTL'BUFFER =$0E00

ST = 144

;AREA =2048
TOP =2048
LAST =2050
WARM = 42115
SYNTAX = $0B
SCANNEXT = $A906
LOOKUP = $B08B
VARADDR = $49
FLACC1 = $61
DISCRD = $B6A3
STRRES = $B475
FRMEVL = $AD9E
QINT = $BC9B
COMMA =$AEFD
INTFLT =$B391
FLTEXP =$AD9E
KEYTABLE =$A09E
CHRIN =$FFCF
INFLT =$B391
STACK =$0100
FLTASC =$BDDD
LOAD =$FFD5



S =54272
BASBUF =$0200
IRQVEC =$0314
HOURS = $DC0B
MINUTES =$DC0A
SECONDS =$DC09
TENTHS =$DC08
CHKOUT =$FFC9
CHKIN =$FFC6
CHROUT =$FFD2
CLRCHN =$FFCC
GETIN =$FFE4
CHRGET =$0073
CHRGOT =$0079
CLOSE =$FFC3
SETNAM =$FFBD
SETLFS =$FFBA
OPEN =$FFC0
SAVE =$FFD8
READST =$FFB7
MESSAGE'BUFFER =$A000





 JMP START
 JMP DOLIST
 JMP ADD
 JMP DUMP
 JMP TERM
 JMP TREG'LINE
 JMP GR'LINE
 JMP RAINBOW
 JMP FORCE'CHAT

 JMP DISPLAY
 JMP DISPLAY2
 JMP READ
 JMP REREAD
 JMP POST
 JMP AUTOREPLY
 JMP DELETE
 JMP SAVE'BASE
 JMP READ'SET
 JMP BLOCKS
START SEI
 LDA #<IRQ
 STA $0314
 LDA #>IRQ
 STA $0315
 CLI
 LDA #0
 STA $DC08
 STA 53281
 STA 53280
 LDX #2
 JSR CLOSE
 LDA #>REC'BUFFER
 STA 248
 LDA #>TRN'BUFFER
 STA 250
 LDA #$02
 TAX
 TAY
 JSR $FFBA
 LDA #$04
 LDX #<PARMS
 LDY #>PARMS
 JSR $FFBD
 JSR $FFC0
 LDA #$02
 JSR $FFD2
 LDA #150
 STA S
 STA S+1
 LDA #8
 STA S+5
 LDA #248
 STA S+6
 LDA #15
 STA S+24
 LDA #17
 STA S+4
 LDA #<MYERROR
 STA 768
 LDA #>MYERROR
 STA 769
 LDA #<CRASH1
 STA 770
 LDA #>CRASH1
 STA 771
 LDA #<CRASH2
 STA 790
 LDA #>CRASH2
 STA 791
 RTS
PARMS .BYT 0,0,64,1

MYERROR CPX #SYNTAX
 BEQ +
 JMP 58251
+ JSR CHRGOT
 CMP #"@"
 BEQ +
 JMP 58251
+ PLA
 PLA
 JSR PASER
 JMP SCANNEXT
PASER JSR CHRGET
 CMP #"P"
 BNE +
 JSR CHRGET
 JMP PRINT
+ CMP #"M"
 BNE +
 JSR CHRGET
 JSR GR'LINE
 JMP TOSTRING
+ CMP #"I"
 BNE +
 JSR CHRGET
 JSR REG'LINE
 JMP TOSTRING
+ CMP #"K"
 BNE +
 JSR CHRGET
 JSR GETKEY
 LDA 1043
 STA UTL'BUFFER
 LDA #1
 STA $02
 JMP TOSTRING
+ CMP #"J"
 BNE +
 JSR CHRGET
 JMP JUMP
+  CMP #"G"
 BNE +
 JSR CHRGET
 JSR GET
 LDA 1043
 STA UTL'BUFFER
 LDA #1
 STA $02
 JMP TOSTRING
+ CMP #"D"
 BNE +
 JMP DOLIST
+ JMP 58251

JUMP JSR FRMEVL
 JSR QINT
 LDA $65
 STA JSRVEC+1
 LDA $64
 STA JSRVEC+2
 JSR BASICOUT
JSRVEC JSR $0000
 JMP BASICIN




IRQ LDA 835
 STA 1049

 LDA $DC09
 CMP #1
 BNE +
 LDA FLAG
 BNE +
 LDA #1
 STA FLAG
 LDA 835
 BEQ NODC
 DEC 835
NODC LDA HOURS
 CMP #18
 BNE +
 LDA MINUTES
 CMP #0
 BNE +
 JSR NEWDAY
 JMP IRQ'PT2
+ LDA SECONDS
 CMP #2
 BNE IRQ'PT2
 LDA #0
 STA FLAG
IRQ'PT2 LDY #0
- LDA 700,Y
 STA 1024,Y
 INY
 CPY #10
 BNE -

LDA #$BA
 STA $0422
 STA $0425
 LDA $DC0B
 AND #$10
 LSR
 LSR
 LSR
 LSR
 ORA #$B0
 STA $0420
 LDA $DC0B
 AND #$0F
 ORA #$B0
 STA $0421
 LDA $DC0A
 AND #$F0
 LSR
 LSR
 LSR
 LSR
 ORA #$B0
 STA $0423
 LDA $DC0A
 AND #$0F
 ORA #$B0
 STA $0424
 LDA $DC09
 AND #$F0
 LSR
 LSR
 LSR
 LSR
 ORA #$B0
 STA $0426
 LDA $DC09
 AND #$0F
 ORA #$B0
 STA $0427
 LDA $DC08

 LDA TEMP1
 PHA
 LDA TEMP2
 PHA
 LDA HOURS
 STA TEMP1
 LDA MINUTES
 BNE EXIT
 LDA SECONDS
 BNE EXIT
 LDA TENTHS
 BNE EXIT
 LDA TEMP1
 AND #$0F
 STA TEMP2
 LDA TEMP1
 AND #$10
 BEQ SKIPTEN
 CLC
 LDA #$0A
 ADC TEMP2
 STA TEMP2
SKIPTEN LDA TEMP1
 BPL SKIPAP
 CLC
 LDA #$0C
 ADC TEMP2
 STA TEMP2
SKIPAP LDY TEMP2
 LDA TABLE1,Y
 STA TI
 LDA TABLE2,Y
 STA TI+1
 LDA TABLE3,Y
 STA TI+2
EXIT LDA TENTHS
 PLA
 STA TEMP2
 PLA
 STA TEMP1

 LDA 833
 BNE +
 LDA "L"
 STA 1045
 JMP CARRIER
+ LDA 56577
 AND #16
 BEQ +
 LDA #@"C"
 STA 1045
 LDA #255
 STA 842
 JMP CARRIER
+ LDA #" "
 STA 1045
 LDA #0
 STA 842
CARRIER LDA 832
 JSR FIG'NUM
 STX 1051
 STY 1052
 LDA #"/"
 STA 1053
 LDA 831
 JSR FIG'NUM
 STX 1054
 STY 1055
 JMP $EA31

NEWDAY INC 53280
 INC 831
 LDY 832
 DEY
 LDA DAYS,Y
 CMP 831
 BNE +
 INC 832
 LDA #1
 STA 831
 LDA 832
 CMP #13
 BNE +
 LDA #1
 STA 832
+ RTS

FIG'NUM CMP #30
 BCC +
 LDX #51
 SEC
 SBC #30
 CLC
 ADC #48
 TAY
 RTS
+ CMP #20
 BCC +
 LDX #50
 SEC
 SBC #20
 CLC
 ADC #48
 TAY
 RTS
+ CMP #10
 BCC +
 LDX #49
 SEC
 SBC #10
 CLC
 ADC #48
 TAY
 RTS
+ LDX #48
 CLC
 ADC #48
 TAY
 RTS

DAYS .BYT 32,30,32,31,32,31,32,32,31,32,31,32

TABLE1 .BYT $00,$03,$06,$09,$0D,$10,$13,$17,$1A,$1D,$20,$24,$00,$2A,$2E,$31,$34,$38,$3B,$3E,$41,$45,$48,$4B,$27
TABLE2 .BYT $00,$4B,$97,$E3,$2F,$7A,$C6,$12,$5E,$A9,$F5,$41,$00,$D8,$24,$70,$BC,$07,$53,$9F,$EB,$36,$82,$CE,$8D
TABLE3 .BYT $00,$C0,$80,$40,$00,$C0,$80,$40,$00,$C0,$80,$40,$00,$C0,$80,$40,$00,$C0,$80,$40,$00,$C0,$80,$40,$00

PRINT JSR CHRGOT
 CMP #34
 BNE VAR
 LDY #1
- LDA ($7A),Y
 CMP #34
 BEQ +
 JSR MYCHROUT
 INY
 JMP -
/ JSR CHRGET
 CMP #34
 BNE -
 JSR CHRGET
SEMI CMP #";"
 BEQ +
 LDA #13
 JSR MYCHROUT
- RTS
+ JSR CHRGET
 BEQ -
 JMP PRINT
 RTS

VAR JSR $AD9E
 JSR $B6A6
 TAX
 INX
 LDY #0
- LDA ($22),Y
 DEX
 BEQ +
 JSR MYCHROUT
 INY
 JMP -
+ JSR CHRGOT
  JMP SEMI

GETKEY LDA #0
 STA $DD09
 STA $DD0A
 STA $DD08
 STA 1020
- LDA 833
 BEQ LOCAL
 LDA 842
 BEQ XX
LOCAL LDA $DD0A
 CMP #2
 BEQ XX
 JSR MYGETIN
 JSR FUNCTIONS
 BEQ -
 STA 1043
 RTS
XX JMP TIMEOUT

GET LDA 833
 BEQ LC
 LDA 842
 BEQ XX
LC JSR MYGETIN
 STA 1043
 RTS


- RTS
ASCII PHA
 LDA 828
 BEQ -
 PLA
 CMP #20
 BNE TAPDL
 LDA #127
 JMP +
TAPDL CMP #127
 BNE +
 LDA #20
+ CMP #145
 BNE +
 LDA #13
+ CMP #192
 BCC TAP2
 CMP #224
 BCS TAP2
 SEC
 SBC #96
TAP2 CMP #224
 BCC TAP3
 CMP #255
 BCS TAP3
 SEC
 SBC #64
TAP3 CMP #255
 BNE TAP4
 LDA #126
TAP4 AND #127
 CMP #65
 BCC TAP5
 CMP #91
 BCS TAP5
 CLC
 ADC #32
 JMP +
TAP5 CMP #97
 BCC TAP6
 CMP #123
 BCS TAP6
 SEC
 SBC #32
 JMP +
TAP6 NOP
+ RTS


FUNCTIONS CMP #16
 BNE +
 LDA NOABT
 BEQ EXZ
 JMP ABORT
EXZ PLA
 PLA
 LDA #0
 RTS
+ CMP #19
 BNE +
- LDA #"<"
 JSR MYCHROUT
 LDA #20
 JSR MYCHROUT
 LDA #">"
 JSR MYCHROUT
 LDA #20
 JSR MYCHROUT
 JSR GET
 CMP #32
 BNE -
 JSR CLRCHN
 LDA #0
+ PHA
 PLA
 RTS

MYCHROUT STA $FB
 LDA #0
 STA $D4
 TYA
 PHA
 TXA
 PHA
 LDA 830
 BNE +
 JSR CLRCHN
 LDA $FB
 JSR MCI
 STA $FB
 JSR CHROUT
+ LDA $FB
 JSR MODEM'OUT
 PLA
 TAX
 PLA
 TAY
 LDA $FB
 RTS
MCI CMP #1
 BNE +
 LDA #13
 RTS
+ CMP #4
 BNE +
 JMP RAINBOW
+ CMP #15
 BNE +
 LDA #142
 RTS
+ RTS

MYGETIN LDA #0
 STA 834
 LDA 830
 BNE USRIN
 JSR GETIN
 BEQ USRIN
 STA 834
 CMP #133
 BNE +
 JMP FORCE'CHAT
+ CMP #134
 BNE +
 LDY #255
- INY
 LDA S3,Y
 JSR MYCHROUT
 BNE -
 LDA #0
 STA 833
 RTS
+ CMP #138
 BNE +
 LDA #255
 STA 833
 LDA #13
 JSR MYCHROUT
 RTS
+ CMP #140
 BNE +
 JMP TIMEOUT
+ RTS

USRIN STX $FB
 JSR MODEM'IN
 RTS




DUMP LDY #0
 STY 1020
 LDX #5
 JSR CHKIN
- JSR GETIN
 STA UTL'BUFFER,Y
 INY
 LDA ST
 STA DVARS+1
 BNE +
 CPY #253
 BNE -
+ STY DVARS
 JSR CLRCHN
 LDA 833
 BEQ +
WTL JSR GET
 JSR FUNCTIONS
 CMP #32
 BEQ DUMP'EXIT
 LDA 669
 CMP 670
 BNE WTL

+ LDY #0
 LDX #2
 JSR CHKOUT
- LDA UTL'BUFFER,Y
 JSR CHROUT
 INY
 CPY DVARS
 BNE -
 JSR CLRCHN
 LDY #0
- LDA UTL'BUFFER,Y
 JSR CHROUT
 TYA
 PHA
 JSR GET
 CMP #32
 BEQ EXII
 PLA
 TAY
 INY
 CPY DVARS
 BEQ +
 CPY #253
 BNE -
+ LDA DVARS+1
 BEQ DUMP
 RTS
DUMP'EXIT LDA #255
 STA 1020
 RTS
EXII PLA
 JMP DUMP'EXIT




DVARS .WOR 0

BASICIN LDA 1
 ORA #1
 STA 1
 RTS
BASICOUT LDA 1
 AND #254
 STA 1
 RTS

WAIT LDA 669
 CMP 670
 BNE WAIT
 RTS

CHAT LDA #0
 STA S+24
 STA 53280
 LDA #0
 STA 830
 LDA #1
 STA NOABT
- JSR MYGETIN
 BEQ -
 CMP #19
 BEQ -
 CMP #133
 BEQ -
 JSR MYCHROUT
 LDA 834
 CMP #137
 BEQ +
 JMP -
+ LDA #0
 STA NOABT
 RTS

TERM JSR CLRCHN
 JSR GETIN
 BEQ TERM'P2
 CMP #95
 BEQ +
 JSR MYCHROUT
TERM'P2 JSR MYGETIN
 PHA
 JSR CLRCHN
 PLA
 JSR CHROUT
 JMP TERM
+ JSR CLRCHN
 RTS

MODEM'IN LDA 833
 BNE +
 RTS
+ TXA
 PHA
 TYA
 PHA
 JSR READST
 AND #8
 BNE +
 LDX #2
 JSR CHKIN
 JSR GETIN
 STA $FB
- JSR CLRCHN
 PLA
 TAY
 PLA
 TAX
 LDA $FB
 JSR ASCII
 RTS
+ LDA #0
 STA $FB
 JMP -

MODEM'OUT CMP #3
 BEQ MIEX
 CMP #"+"
 BEQ MIEX
 JSR ASCII
 STA $FB
 LDA 833
 BNE +
 RTS
+ TXA
 PHA
 TYA
 PHA
 LDX #2
 JSR CHKOUT
 JSR WAIT
 LDA $FB
 JSR CHROUT
 JSR CLRCHN
 PLA
 TAY
 PLA
 TAX
 LDA $FB
MIEX RTS

FEX2 ASL $FE
 ROL $FF
 RTS

FORCE'CHAT TAY
 PHA
 LDY #0
- LDA CHAT1,Y
 JSR MYCHROUT
 INY
 CMP #0
 BNE -
 JSR CHAT
 LDY #0
- LDA CHAT2,Y
 JSR MYCHROUT
 INY
 CMP #0
 BNE -
 PLA
 TAY
 RTS

REG'LINE JSR FRMEVL
 JSR QINT
 LDA $65
 STA 1021
 JSR COMMA
 JSR FRMEVL
 JSR QINT
 LDA $65
 STA $03
 JSR COMMA
TREG'LINE LDA #0
 STA $02
- JSR GETKEY
 LDA 1043
 CMP #34
 BEQ -
 AND #127
 CMP #13
 BEQ +
 CMP #20
 BEQ REG'DEL
 LDX $02
 CPX $03
 BEQ -
 CMP #32
 BCC LNRG'SKIP
 CMP #125
 BCC LNRG'TAKE
 JMP LNRG'SKIP
LNRG'TAKE LDY $02
 STA UTL'BUFFER,Y
 INC $02
 PHA
 LDA 1021
 BEQ BLACK'OUT
 PLA
 JSR MYCHROUT
 JMP -
BLACK'OUT PLA
 LDA #"*"
 JSR MYCHROUT
 JMP -
LNRG'SKIP JMP -
REG'DEL LDA $02
 BEQ -
 DEC $02
 LDA #20
 JSR MYCHROUT
 JMP -
+ LDA #13
 JSR MYCHROUT
 RTS

GR'LINE LDA 845
 CMP #255
 BEQ ERRBUF
 CMP #0
 BNE +
ERRBUF LDY #0
 LDA #0
- STA UTL'BUFFER,Y
 INY
 BNE -

+ LDA 845
 CMP #255
 BEQ WW
 CMP #0
 BNE WW1
WW LDA #0
 STA $02
 JMP +
WW1 JSR WORDWRAP2
/ LDA $02
 CMP #$50
 BEQ +
 JSR GETKEY
 LDA 1043
 BEQ -
 CMP #19
 BEQ -
 CMP #13
 BEQ +
 CMP #20
 BEQ GR'DEL
 TAX
 LDA $D3
 CMP #38
 BNE NOTYET
TST LDA 845
 CMP #255
 BEQ -
 TXA
 LDY $02
 STA UTL'BUFFER,Y
 INC $02
 TXA
 JMP WORDWRAP1
NOTYET CMP #78
 BEQ TST
 TXA
 CMP #8
 BEQ -
 CMP #9
 BEQ -
 LDX #0
X1L CMP X1,X
 BEQ GET'RESTENT
 INX
 CPX #4
 BEQ X1L
 LDY $02
 STA UTL'BUFFER,Y
 INC $02
 JSR MYCHROUT
 JMP -
GR'DEL LDA $02
 BEQ -
 DEC $02
 LDA #20
 JSR MYCHROUT
 JMP -
GET'REST LDA $02
 CMP #200
 BEQ +
 JSR GETKEY
 BEQ GET'REST
 JSR MYCHROUT
 CMP #13
 BEQ +
GET'RESTENT LDY 2
 STA UTL'BUFFER,Y
 INC $02
 JMP GET'REST
+ LDA #0
 STA 845
 RTS

WORDWRAP1 LDY $02
 STY 845
 LDA UTL'BUFFER,Y
 TXA
 CMP #32
 BEQ WW1EXT
 INY
 LDX #0
- DEY
 INX
 CPX #20
 BEQ WW1EXT
 LDA UTL'BUFFER,Y
 CMP #32
 BNE -
 INY
 STY $02
 CPY 845
 BEQ WW1EXT
 BCS WW1EXT

- LDY $D3
 DEY
 LDA ($D1),Y
 AND #127
 CMP #32
 BEQ +
 LDA #20
 JSR MYCHROUT
 JMP -
+ RTS
WW1EXT LDA #0
 STA 845
 RTS

WORDWRAP2 LDX #0
 LDY $02
- LDA UTL'BUFFER,Y
 STA UTL'BUFFER,X
 JSR MYCHROUT
 INY
 INX
 CPY 845
 BNE -
 STX $02
- RTS
TOSTRING LDA $02
 BEQ TSEXIT
 CMP #255
 BEQ TSEXIT
+ PHA
 PHA
 JSR LOOKUP
 STA VARADDR
 STY VARADDR+1
 JSR DISCRD
 PLA
 JSR STRRES
 LDY #2
- LDA FLACC1,Y
 STA (VARADDR),Y
 DEY
 BPL -
 INY
 PLA
 TAX
- LDA UTL'BUFFER,Y
 STA (FLACC1+1),Y
 INY:DEX
 BNE -
+ RTS
TSEXIT JSR LOOKUP
 RTS

RAINBOW INC PAGE
 TYA
 PHA
 LDY PAGE
 CPY #7
 BNE +
 LDY #0
 STY PAGE
+ LDA BOW,Y
 JSR MYCHROUT
 PLA
 TAY
 RTS

TIMEOUT JSR CLRCHN
 LDA #13
 JSR CHROUT
 JSR CHROUT
 JSR CHROUT
 LDY #0
- LDA GO,Y
 BEQ +
 JSR CHROUT
 INY
 JMP -
+ LDA #13
 JSR CHROUT
 LDA #145
 JSR $FFD2
 LDA #13
 STA 631
 LDA #1
 STA 198
 JMP WARM

CRASH1 LDA 833
 BNE CRASH'ENT
 JMP WARM
CRASH'ENT LDA #13
 LDX #<FL2
 LDY #>FL2
 JSR SETNAM
 LDA #5
 LDX #8
 LDY #5
 JSR SETLFS
 LDA #<1024
 STA $FB
 LDA #>1024
 STA $FC
 LDA #$FB
 LDX #<2048
 LDY #>2048
 JSR SAVE
 JSR CLRCHN
 LDA #13
 JSR CHROUT
 JSR CHROUT
 JSR CHROUT
 LDY #0
- LDA BR,Y
 BEQ +
 JSR CHROUT
 INY
 JMP -
+ LDA #13
 JSR CHROUT
 LDA #145
 JSR CHROUT
 LDA #1
 STA 198
 LDA #13
 STA 631
 JMP WARM

CRASH2 JSR CLRCHN
 LDY #0
- LDA BK,Y
 JSR CHROUT
 INY
 CMP #0
 BNE -
 JMP CRASH'ENT

ABORT LDA #13
 JSR CHROUT
 JSR CHROUT
 JSR CHROUT
 JSR CLRCHN
 LDY #0
- LDA ABT,Y
 JSR CHROUT
 INY
 CMP #0
 BNE -
 LDA #13
 JSR CHROUT
 LDA #145
 JSR CHROUT
 LDA #1
 STA 198
 LDA #13
 STA 631
 JMP WARM

RESET LDA #<AREA
 STA MSG'PTR
 LDA #>AREA
 STA MSG'PTR+1
 RTS

BASE LDY #0
- LDA (MSG'PTR),Y
 CMP #$FF
 BEQ +
 STA 3112,Y
 INY
 CPY #250
 BNE -
+ STY $02
 JSR SEARCH
 JMP SEARCH

SEARCH LDY #0
SR'LOOP LDX #0
- LDA (MSG'PTR),Y
 INC MSG'PTR
 BNE +
 INC MSG'PTR+1
+ CMP #255
 BNE SR'LOOP
 INX
 CPX #2
 BNE -
 RTS

DSEARCH LDY #0
DSR'LOOP LDX #0
- LDA (MSG'PTR),Y
 INC MSG'PTR
 BNE +
 INC MSG'PTR+1
+ CMP #255
 BNE DSR'LOOP
 INX
 CPX #4
 BNE -
 RTS

INSERT LDA #<3068
 STA $4B
 LDA #>3068
 STA $4B+1
 LDA #<3070
 STA $4B+2
 LDA #>3070
 STA $4B+3
- LDY #0
 LDA ($4B),Y
 STA ($4B+2),Y
 SEC
 LDA $4B
 SBC #1
 STA $4B
 LDA $4C
 SBC #0
 STA $4C
 SEC
 LDA $4D
 SBC #1
 STA $4D
 LDA $4E
 SBC #0
 STA $4E
 LDA $4D
 CMP MSG'PTR
 BNE -
 LDA $4E
 CMP MSG'PTR+1
 BNE -
 RTS

DISPLAY LDA #9
 JSR MYCHROUT
 LDA #0
 STA 1020
 LDA #14
 JSR MYCHROUT
 LDA #154
 JSR MYCHROUT
 LDA #176
 JSR MYCHROUT
 JSR LINE
 LDA #174
 JSR MYCHROUT
 LDA #1
 STA TEMP
 JSR RESET
 JSR SEARCH
 LDA #0
 STA TOT'NEW
DIS'TOP LDA #0
 STA PER'BASE
 STA NEW'BASE
 JSR RAINBOW
 LDA TEMP
 CLC
 ADC #96
 JSR MYCHROUT
 LDA #">"
 JSR MYCHROUT
 INC 1020
 LDA #32
 JSR MYCHROUT
 JSR MYCHROUT
 JSR MYCHROUT
 LDY #0
- LDA (MSG'PTR),Y
 PHA
 JSR MYCHROUT
 CLC
 LDA MSG'PTR
 ADC #1
 STA MSG'PTR
 LDA MSG'PTR+1
 ADC #0
 STA MSG'PTR+1
 PLA
 CMP #1
 BEQ +
 CMP #0
 BNE -
/ LDA #32
 JSR MYCHROUT
 LDA 211
 CMP #30
 BEQ RECON
 CMP #70
 BEQ RECON
 JMP -
RECON LDY #0
 LDA (MSG'PTR),Y
 CMP #255
 BNE +
 INY
 LDA (MSG'PTR),Y
 CMP #255
 BNE +
 INY
 LDA (MSG'PTR),Y
 CMP #255
 BNE +
 INY
 LDA (MSG'PTR),Y
 CMP #$FE
 BEQ DISEX
 CMP #255
 BNE +
 JSR SEARCH
 JSR SEARCH
 INC TEMP
 LDA PER'BASE
 JSR NUMBER
 LDA #"/"
 JSR MYCHROUT
 LDA NEW'BASE
 JSR NUMBER
 LDA #13
 JSR MYCHROUT
 JMP DIS'TOP
DISEX LDA PER'BASE
 JSR NUMBER
 LDA #"/"
 JSR MYCHROUT
 LDA NEW'BASE
 JSR NUMBER
 LDA #13
 JSR MYCHROUT
 JMP DISEND
+ LDY #0
 LDA (MSG'PTR),Y
 STA NUM'BUF
 LDY #1
 LDA (MSG'PTR),Y
 STA NUM'BUF+1
 CLC
 LDA MSG'PTR
 ADC #2
 STA MSG'PTR
 LDA MSG'PTR+1
 ADC #0
 STA MSG'PTR+1
 LDY #0
 LDA NUM'BUF
 CMP #$FF
 BNE +
 LDY #1
 LDA NUM'BUF+1
 CMP #$FF
 BNE +
 JMP RECON
+ INC PER'BASE
 JSR DCMP
 BCC +
 INC NEW'BASE
 INC TOT'NEW
+ JMP RECON
DISEND LDA #154
 JSR MYCHROUT
 LDA #173
 JSR MYCHROUT
 JSR LINE
 LDA #189
 JSR MYCHROUT
 LDY #0
- LDA S1,Y
 INY
 JSR MYCHROUT
 BNE -
 LDA TOT'NEW
 JSR NUMBER
 LDY #0
- LDA S2,Y
 INY
 JSR MYCHROUT
 BNE -
 RTS





LINE LDY #0
- LDA #192
 JSR MYCHROUT
 INY
 CPY #38
 BNE -
 RTS




NUMBER TAY
 JSR $B3A2
 JSR $BDDD
 LDY #1
- LDA $0100,Y
 JSR MYCHROUT
 INY
 CMP #0
 BNE -
 RTS

DCMP SEC
 LDA NUM'BUF
 SBC NEW
 STA TEMP+1
 LDA NUM'BUF+1
 SBC NEW+1
 ORA TEMP+1
 RTS

DISPLAY2 LDA #0
 STA 1020
 LDA #1
 STA TEMP
 JSR RESET
 JSR SEARCH
 JMP +
DISLP2 JSR DSEARCH
+ LDY #0
JSR RAINBOW
CLC
LDA TEMP
ADC #96
JSR MYCHROUT
LDA #">"
JSR MYCHROUT
INC 1020
LDA #" "
JSR MYCHROUT
- LDA (MSG'PTR),Y
 INY
 CMP #1
 BEQ +
 JSR MYCHROUT
 CMP #0
 BNE -
 LDA #13
 JSR MYCHROUT
 INC TEMP
 JMP DISLP2
+ RTS

READ'SET JSR RESET
 JSR SEARCH
 LDA 1020
 BEQ +
 STA TEMP
- JSR DSEARCH
 DEC TEMP
 BNE -
+ LDY #0
 LDX #0
- LDA (MSG'PTR),Y
 INC MSG'PTR
 BNE +
 INC MSG'PTR+1
+ CMP #0
 BEQ +
 STA UTL'BUFFER,X
 INX
 JMP -
+ STX $02
 JMP TOSTRING

READ LDX #0
 STX 1020
- LDY #0
 LDA (MSG'PTR),Y
 STA 836
 INY
 LDA (MSG'PTR),Y
 STA 837
 CLC
 LDA MSG'PTR
 ADC #2
 STA MSG'PTR
 LDA MSG'PTR+1
 ADC #0
 STA MSG'PTR+1
 LDA 836
 CMP #255
 BNE +
 LDA 837
 CMP #255
 BNE +
 INX
 INC 1020
 CPX #2
 BNE -
 LDA #50
 STA 1020
 RTS
+ LDX #0
 LDA 836
 STA NUM'BUF
 LDA 837
 STA NUM'BUF+1
 JSR DCMP
 BCC -
 RTS

REREAD SEC
 LDA MSG'PTR
 SBC #4
 STA MSG'PTR
 LDA MSG'PTR+1
 SBC #0
 STA MSG'PTR+1
 LDX #0
 STX 1020
- LDY #0
 LDA (MSG'PTR),Y
 STA 836
 INY
 LDA (MSG'PTR),Y
 STA 837
 LDA 836
 CMP #255
 BNE +
 LDA 837
 CMP #255
 BNE +
 JMP REREAD'END
+ CLC
 LDA MSG'PTR
 ADC #2
 STA MSG'PTR
 LDA MSG'PTR+1
 ADC #0
 STA MSG'PTR+1
 RTS
REREAD'END LDA #1
 STA 1020
 RTS

POST JSR READ'SET
 JSR DSEARCH
 SEC
 LDA MSG'PTR
 SBC #4
 STA MSG'PTR
 LDA MSG'PTR+1
 SBC #0
 STA MSG'PTR+1
 JSR INSERT
 JSR INSERT
 LDY #0
 LDA #255
 STA (MSG'PTR),Y
 INY
 STA (MSG'PTR),Y
 INY
WREND LDA 2049
 STA (MSG'PTR),Y
 INY
 LDA 2050
 STA (MSG'PTR),Y
 CLC
 LDA 2049
 ADC #1
 STA 2049
 LDA 2050
 ADC #0
 STA 2050
 RTS;INTER CONNECTED ^^^
AUTOREPLY JSR SEARCH;^^^
 SEC
 LDA MSG'PTR
 SBC #2
 STA MSG'PTR
 LDA MSG'PTR+1
 SBC #0
 STA MSG'PTR+1
 JSR INSERT
 LDY #0
 JMP WREND

SAVE'BASE LDA #13
 LDX #<FL
 LDY #>FL
 JSR SETNAM
 LDA #5
 LDX #8
 LDY #5
 JSR SETLFS
 LDA #<2048
 STA $FB
 LDA #>2048
 STA $FC
 LDA #$FB
 LDX #<3072
 LDY #>3072
 JMP SAVE

DEL LDA MSG'PTR
 STA $4B
 LDA MSG'PTR+1
 STA $4B+1
 CLC
 LDA MSG'PTR
 ADC #<2
 STA $4B+2
 LDA MSG'PTR+1
 ADC #>2
 STA $4B+3

- LDY #0
 LDA ($4B+2),Y
 STA ($4B),Y
 CLC
 LDA $4B
 ADC #1
 STA $4B
 LDA $4C
 ADC #0
 STA $4C
 CLC
 LDA $4D
 ADC #1
 STA $4D
 LDA $4E
 ADC #0
 STA $4E
 LDA $4D
 CMP #<3072
 BNE -
 LDA $4E
 CMP #>3072
 BNE -
 RTS

DELETE JSR DEL
 SEC
 LDA MSG'PTR
 SBC #2
 STA MSG'PTR
 BCS +
 DEC MSG'PTR+1
+ LDY #0
 LDA (MSG'PTR),Y
 CMP #255
 BNE DLEX
 INY
 LDA (MSG'PTR),Y
 CMP #255
 BNE DLEX
 JMP DEL
DLEX JMP READ

BLOCKS LDA #5
 LDX 840
 LDY #0
 JSR SETLFS
 LDX #<DIRPAT
 LDY #>DIRPAT
 LDA #2
 JSR SETNAM
 LDA #0
 LDX #<UTL'BUFFER
 LDY #>UTL'BUFFER
 JSR $FFD5
 LDA UTL'BUFFER+32
 LDX UTL'BUFFER+33
 STA 840
 STX 841
 RTS

TP .BYT 0,0

DOLIST LDA #0
 STA TP
 JSR OPENINPUT
 JSR CHRIN
 JSR CHRIN
DIRLOOP LDA #0
 STA QUOTEFLAG
 LDA #13
 JSR MYCHROUT:JSR BACK
 JSR CHRIN
 JSR CHRIN
 JSR CHRIN
 STA TP
 JSR CHRIN
 STA TP+1
 JSR READST
 BEQ +
 JMP CLOSEINPUT
+ LDA TP+1
 LDY TP
 JSR INFLT
 JSR FLTASC
 LDY #1
PROUTNUM LDA STACK,Y
 BEQ ADDSPACE
 JSR MYCHROUT:JSR BACK
 INY
 BNE PROUTNUM
ADDSPACE LDA #" "
 JSR MYCHROUT:JSR BACK
DIRLINE JSR CHRIN
 BEQ DIRLOOP
 BMI ISKEY
 JSR MYCHROUT:JSR BACK
 CMP #34
 BNE DIRLINE
 INC QUOTEFLAG
 LDA QUOTEFLAG
 AND #1
 STA QUOTEFLAG
 BPL DIRLINE
ISKEY LDX QUOTEFLAG
 BEQ DOKEY
DONTDOK JSR MYCHROUT:JSR BACK
 JMP DIRLINE
DOKEY CMP #255
 BEQ DONTDOK
 JSR LISTKEY
 JMP DIRLINE
DIREND JMP CLOSEINPUT
LISTKEY LDY #0
 SEC
 SBC #$80
 BEQ PRKEY
 TAX
 LDA #$FF
SKEYTAB INY
 LDA KEYTABLE,Y
 BMI +
 BNE SKEYTAB
+ DEX
 BNE SKEYTAB
 INY
PRKEY LDA KEYTABLE,Y
 BMI ENDPRKEY
 JSR MYCHROUT:JSR BACK
 INY
 BNE PRKEY
ENDPRKEY SEC
 SBC #$80
 JSR MYCHROUT:JMP BACK

OPENINPUT JSR GETSTRING
 JSR SETNAM
 LDY TP
 LDA #127
 LDX 840
 JSR SETLFS
 JSR OPEN
 LDX #127
 JMP CHKIN

CLOSEINPUT JSR CLRCHN
 LDA #127
 JMP CLOSE

GETSTRING JSR CHRGET
 JSR FLTEXP
 JMP DISCRD

BACK PHA
 TXA
 PHA
 LDX #127
 JSR CHKIN
 PLA
 TAX
 PLA
 RTS

ADD JSR COMMA
 JSR FRMEVL
 JSR QINT
 LDA $65
 STA 1020
 LDA $31
 STA $FB
 LDA $32
 STA $FC
 CLC
 LDA $31
 STA $FD
 LDA $32
 ADC 1020
 STA $FE

 LDY #0
- LDA ($FB),Y
 STA ($FD),Y
 SEC
 LDA $FB
 SBC #1
 STA $FB
 LDA $FC
 SBC #0
 STA $FC
 SEC
 LDA $FD
 SBC #1
 STA $FD
 LDA $FE
 SBC #0
 STA $FE
 LDA $FB
 CMP $2D
 BNE -
 LDA $FC
 CMP $2E
 BNE -

 CLC
 LDA $2E
 ADC 1020
 STA $2E
 LDA $30
 ADC 1020
 STA $30
 LDA $32
 ADC 1020
 STA $32

 LDA #<59999
 STA $14
 LDA #>59999
 STA $15
 JSR $A613
 LDY #2
 LDA ($5F),Y
 STA $FB
 INY
 LDA ($5F),Y
 STA $FC

 JSR COMMA
 JSR FRMEVL
 JSR QINT
 LDA 665
 STA OVL+5
 LDA #6
 LDX #<OVL
 LDY #>OVL
 JSR SETNAM
 LDA #5
 LDA #8
 LDA #0
 JSR SETLFS
 LDA #0
 LDX #$FB
 LDY #$FC
 JSR LOAD
 JSR $A533
 JSR $B526
 RTS

;************
X1 .BYT 17,145,147,19

S1 .BYT 13,159:.ASC "�HERE ARE ":BRK
S2 .ASC " NEW MESSAGE(S).":BRK
S3 .BYT 13,13,13,159:.ASC "PLEASE WAIT...":BRK

FL .ASC "+MESSAGE BASE"
FL2 .ASC "+SYSTEM CRASH"
CHAT1 .BYT 13,13,7:.ASC "�HAT �ODE �CTIVE":.BYT 13,13,0
CHAT2 .BYT 13,13,7:.ASC "�HAT �OD �XIT.":.BYT 13,13,0
BOW .BYT 5,150,30,154,156,158,153
PAGE .BYT 0

FLAG .BYT 0

TEMP .WOR 0

PER'BASE .BYT 0
NEW'BASE .BYT 0
TOT'NEW .BYT 0

NUM'BUF .WOR 0

NOABT =846
NEW =838

AREA = 2060

PATCH RTS
DIRPAT .ASC "$#"

GO .ASC "GOTO14500":BRK
BR .ASC "GOTO14600":BRK
BK .ASC "ML BREAK!!":BRK
QUOTEFLAG BRK
ABT .ASC "GOTO10999":BRK
OVL .ASC "+OVL X"
