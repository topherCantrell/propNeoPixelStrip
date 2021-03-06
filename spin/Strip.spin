CON
  _clkmode        = xtal1 + pll16x
  _xinfreq        = 5_000_000

{{

    Propeller Quick Start Board                                                 

                  74125       330Ω
         P0  ────────────────── NeoPixel DIN
      
      +5 In  ──────────┐
        GND  ───────┐  │
                     │  │
                     │  │
    2A Wall Wart     │  │
                     │  │
         +5  ────────┼──┻─────────┳─ NeoPixel +5
                     │     1000µF  
        GND  ────────┻────────────┻─ NeoPixel GND

}}

{{

Serial Protocol:

  clear()        C
  set(n,p)       S n p
  test()         X

}}

CON
    PIN_NEO = 0

VAR
    long palBuf[4*256]
    byte pixBuf[144*4]

    byte patterns[145*16]

OBJ    
    
    NEOStrip : "NeoPixelStrip"
    PST      : "Parallax Serial Terminal"          
    
PUB Main | x,c,n,p,i,j

  ' Go ahead and drive the pixel plate data line low. The driver
  ' will too, but it might be a little while before it gets called.
  ' If we wait then the first pixel will show random data.
  dira[PIN_NEO] := 1
  outa[PIN_NEO] := 0

  ' Start the COG
  NEOStrip.init
  PauseMSec(500)

  ' Blank the strip
  NEOStrip.draw(2,@palBuf,@pixBuf,PIN_NEO, 144)
          
  PST.start(115200)

  repeat
    c := PST.charIn 
      
    CASE c
      "D" :
        NEOStrip.draw(2,@datPalette, @datBuffer, PIN_NEO, 144)
         
      "C" :
        repeat x from 0 to 143
          byte[@datBuffer+x] := 0
          
      "S" :
        n := PST.charIn
        p := PST.charIn
        byte[@datBuffer+n] := p

      "F" :
        n := PST.charIn
        p := PST.charIn
        i := PST.charIn
        repeat x from n to p
          byte[@datBuffer+x] := i

      "P" :   ' G R B
        n := PST.charIn
        p := PST.charIn ' red
        i := PST.charIn ' green
        j := PST.charIn ' blue
        x := i<<16 | p<<8 | j
        long[@datPalette+n*4] := x

      "I" :
        p := PST.charIn ' number
        p := @patterns + p*145
        n := PST.charIn ' count
        byte[p] := n
        repeat x from 1 to n
          byte[p+x] := PST.charIn

      "M" :
        p := PST.charIn ' pattern number
        p := @patterns + p*145
        n := byte[p]
        i := PST.charIn ' pixel index
        repeat x from 1 to n
          byte[@datBuffer+i+x-1] := byte[p+x]        

    ' Echo the command as a throttle
    PST.char("!")

    
     
PRI PauseMSec(Duration)
  waitcnt(((clkfreq / 1_000 * Duration - 3932) #> 381) + cnt)  

DAT

' 144 pixels in the strip

datPalette

 long $00_00_00_00 ' Black
 long $00_00_00_08 ' Blue
 long $00_00_08_00 ' Red
 long $00_00_08_08 ' Blue+Red (Purple)
 long $00_08_00_00 ' Green
 long $00_08_00_08 ' Green+Blue (Cyan)
 long $00_08_08_00 ' Green+Red (yellow)
 long $00_08_08_08 ' White

 long $00_00_00_00 ' Black
 long $00_00_00_10 ' Blue
 long $00_00_10_00 ' Red
 long $00_00_10_10 ' Blue+Red (Purple)
 long $00_10_00_00 ' Green
 long $00_10_00_10 ' Green+Blue (Cyan)
 long $00_10_10_00 ' Green+Red (yellow)
 long $00_10_10_10 ' White

 long $00_00_00_00 ' Black
 long $00_00_00_20 ' Blue
 long $00_00_20_00 ' Red
 long $00_00_20_20 ' Blue+Red (Purple)
 long $00_20_00_00 ' Green
 long $00_20_00_20 ' Green+Blue (Cyan)
 long $00_20_20_00 ' Green+Red (yellow)
 long $00_20_20_20 ' White

 long $00_00_00_00 ' Black
 long $00_00_00_40 ' Blue
 long $00_00_40_00 ' Red
 long $00_00_40_40 ' Blue+Red (Purple)
 long $00_40_00_00 ' Green
 long $00_40_00_40 ' Green+Blue (Cyan)
 long $00_40_40_00 ' Green+Red (yellow)
 long $00_40_40_40 ' White

 long 0,0,0,0,0,0,0,0
 long 0,0,0,0,0,0,0,0
 long 0,0,0,0,0,0,0,0
 long 0,0,0,0,0,0,0,0
 long 0,0,0,0,0,0,0,0
 long 0,0,0,0,0,0,0,0
 long 0,0,0,0,0,0,0,0
 long 0,0,0,0,0,0,0,0
 long 0,0,0,0,0,0,0,0
 long 0,0,0,0,0,0,0,0
 long 0,0,0,0,0,0,0,0
 long 0,0,0,0,0,0,0,0
 long 0,0,0,0,0,0,0,0
 long 0,0,0,0,0,0,0,0
 long 0,0,0,0,0,0,0,0
 long 0,0,0,0,0,0,0,0
 long 0,0,0,0,0,0,0,0
 long 0,0,0,0,0,0,0,0
 long 0,0,0,0,0,0,0,0
 long 0,0,0,0,0,0,0,0
 long 0,0,0,0,0,0,0,0
 long 0,0,0,0,0,0,0,0
 long 0,0,0,0,0,0,0,0
 long 0,0,0,0,0,0,0,0
 long 0,0,0,0,0,0,0,0
 long 0,0,0,0,0,0,0,0
 long 0,0,0,0,0,0,0,0
 long 0,0,0,0,0,0,0,0   
 
datBuffer
  byte 0,0,0,0,0,0,0,0,0,0,0,0
  byte 0,0,0,0,0,0,0,0,0,0,0,0
  byte 0,0,0,0,0,0,0,0,0,0,0,0
  byte 0,0,0,0,0,0,0,0,0,0,0,0
  byte 0,0,0,0,0,0,0,0,0,0,0,0
  byte 0,0,0,0,0,0,0,0,0,0,0,0
  byte 0,0,0,0,0,0,0,0,0,0,0,0
  byte 0,0,0,0,0,0,0,0,0,0,0,0
  byte 0,0,0,0,0,0,0,0,0,0,0,0
  byte 0,0,0,0,0,0,0,0,0,0,0,0
  byte 0,0,0,0,0,0,0,0,0,0,0,0
  byte 0,0,0,0,0,0,0,0,0,0,0,0

  byte 0,0,0,0,0,0,0,0,0,0,0,0
  byte 0,0,0,0,0,0,0,0,0,0,0,0
  byte 0,0,0,0,0,0,0,0,0,0,0,0
  byte 0,0,0,0,0,0,0,0,0,0,0,0

   