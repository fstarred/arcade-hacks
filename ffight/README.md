# Final Fight

![Andore at start](https://github.com/user-attachments/assets/62648f7e-de08-4460-a915-520712c65192)

## System information

**CPU**
* Motorola MC68000 10 MHz
* Zilog Z80 3.5 MHz

**Specs**<br>
[M68000](../specs/M68000_16_32-Bit_Microprocessor_Programmers_Reference_Manual_4th_Edition_text.pdf)

## General game data

```
0xFF8082 = demo mode (00=OFF | FF=ON)
0xFF80BE = area
0xFF80BF = stage
0xFF8412 = stage position x (word)
0xFF8129 = stage clear flag
0xFF812B = boss clear flag
0xFF845C = stage position y (word)
```

## Characters and objects data

### Player data

Player data is stored on the following addresses:

```
0xFF8568 - Player 1
0xFF8628 - Player 2
```

Starting from these offset, I found the following information stored for each player:

```
O = offset
O + 0x02 = status
O + 0x06 = pos x (3 bytes)
O + 0x0A = pos y (word)
O + 0x13 = character (byte, from 0 to 2)
0 + 0x25 = animation frame
...

STATUS
0x02 = player control
0x04 = dead
0x06 = continue screen
0x08 = stage start
0x0A = stage end
```



### Enemy data

Typically, when enemy data needs to be loaded into memory, the program delegates specific reserved slots of memory for it.
Here is a bit of content map that an enemy data contains:

```
O = offset
O + 0x06	pos x (word)
O + 0x0A        pos y (word)
O + 0x12	character
O + 0x13	character
O + 0x14	character
O + 0x15	initial pose
O + 0x18	energy		
O + 0x1C	energy bar size
O + 0x25        frame animation object (double)
...
```

### Characters

This is the character's available value that I discovered so far:

```

02 00 00 = bred
02 00 01 = doug
02 00 02 = jake
02 00 03 = simons
02 01 00 = j
02 01 01 = two.p
02 02 00 = axl
02 02 01 = slash
02 03 00 = andore jr.
02 03 01 = andore
02 03 02 = g.andore
02 03 03 = u.andore
02 03 04 = f.andore
02 04 00 = g. oriber
02 04 01 = bill bull
02 04 02 = wong who
02 05 00 = holly wood
02 05 01 = el gado
02 06 00 = roxy
02 06 01 = poison
02 08 00 = holly wood (red)
```

#### Initial pose

Below are some codes I found for the character's initial pose.
<br/>
Behaviour may vary according to the character kind itself, so for instance a value of 0x04 means staying crouched for Bred, while for Andore it means immediately charging the player

```
00 = *
01 = *
02 = lean against the wall
04 = *
06 = *
07 = coming from a door
0C = coming from above
```

### Objects

```
0x080F = sliding door
0x0816 = drop
0x082A = Rolento going down the ladder
0x0831 = break point arrow
0x0A00 = door
0x0A01 = drumcan
0x0A02 = chandelier
0x0A03 = billboard
0x0A04 = freight
0x0A05 = dustbin
0x0A06 = barrel
0x0A07 = tire
0x0A08 = tel.booth
0x0A09 = glass
0x0A0A = rolling drumcan
0x0A0F = grenade
0x0A10 = expanding flame
0x0A11 = flame
0x0A12 = wheelchair
```

### Boss

```
04 0000 = Damnd
04 0100 = Sodom
04 0200 = Edi.E
04 0300 = Rolento
04 0400 = Abigail
04 0500 = Belger
04 0600 = Bosstest
```

## Stage mapping

There are two main addresses for each stage dedicated for mapping enemies or objects, each of them are scanned by dedicated routines.

For the sake of convenience, we'll call in the following way:

**Stage routine:**

Scan from the vector address and load into memory mapped enemies and objects; enemies contained into this map are not blocking, so player can advance to next stage without killing them.

**Enemy routine:**

Scan from the vector address and load into memory mapped enemies. 

In order to advance forward in the level or go for the next stage, you must beat all of these enemies.


| STAGE     | STAGE R. | ENEMY R. |
| --------  | -------- | -------- |
| SLUM 1    | 0x06D02C | 0x070596 |
| SLUM 2    | 0x06D0CA | 0x0705FA |
| SLUM 3    | 0x06D122 | 0x07064E |
| SUBWAY 1  | 0x06D182 | 0x07071E |
| SUBWAY 2  | 0x06D1F6 | 0x070792 |
| SUBWAY 3  | 0x06D382 | 0x070866 |
| SUBWAY 4  | 0x06D44A | 0x0708EA |
| W. SIDE 1 | 0x06D454 | 0x0708F4 |
| W. SIDE 2 | 0x06D4D6 | 0x070AB6 |
| W. SIDE 3 | 0x06D52E | 0x070AFA |
| I. AREA 1 | 0x06D5FA | 0x070C64 |
| I. AREA 2 | 0x06D858 | 0x070EE8 |
| BAY AREA  | 0x06D968 | 0x070EEE |
| UP TOWN 1 | 0x06E1C2 | 0x071364 |
| UP TOWN 2 | 0x06E612 | 0x0714F8 |
| UP TOWN 3 | 0x06E8C4 | 0x07167C |

### Stage routine

The stage data address is extracted by the following routine called on stage init.

```
 00604A  lea     ($2bc,PC) ; ($6308), A3                     47FA 02BC	* = 6D024
 00604E  bsr     $614c                                       6100 00FC
 
 00614C  moveq   #$0, D0                                     7000
 00614E  move.b  ($be,A5), D0                                102D 00BE
 006152  lsl.w   #2, D0                                      E548               ; 32 bit address
 006154  movea.l (A3,D0.w), A3                               2673 0000		; get base address for main scenario (from 6308+x)
 006158  moveq   #$0, D0                                     7000
 00615A  move.b  ($bf,A5), D0                                102D 00BF
 00615E  add.w   D0, D0                                      D040
 006160  move.w  (A3,D0.w), D0                               3033 0000		
 006164  lea     (A3,D0.w), A3                               47F3 0000		; get base address + delta for sub scenario
 006168  rts                                                 4E75
	 
 006052  move.w  (A3)+, ($24,A6)                             3D5B 0024
 006056  move.l  A3, ($20,A6)                                2D4B 0020		; get final address in A3
 00605A  rts                                                 4E75               ; place a breakpoint here !

```

### Enemy routine

Information map enemy address is extracted by the following routine called on stage init.

```
005ADC  lea     ($442,PC) ; ($5f20), A3                     47FA 0442
005AE0  tst.w   $72600.l                                    4A79 0007 2600
005AE6  beq     $5aec                                       6704
005AE8  lea     ($456,PC) ; ($5f40), A3                     47FA 0456
005AEC  move.b  ($be,A5), D0                                102D 00BE
005AF0  lsl.w   #2, D0                                      E548
005AF2  movea.l (A3,D0.w), A3                               2673 0000
005AF6  moveq   #$0, D0                                     7000
005AF8  move.b  ($bf,A5), D0                                102D 00BF
005AFC  add.w   D0, D0                                      D040
005AFE  move.w  (A3,D0.w), D0                               3033 0000
005B02  lea     (A3,D0.w), A3                               47F3 0000		
005B06  move.w  (A3)+, ($a,A6)                              3D5B 000A		; get base address + delta for sub scenario
005B0A  move.l  A3, ($6,A6)                                 2D4B 0006
005B0E  rts                                                 4E75                 ; place a breakpoint here !
```


### Map information

Here's an example of the first stage map data (slum 1), located at address 0x06D02C:

```
O + 0x00 = when 0xFF8412 == value, then load into memory
O + 0x02 = position x (word)
O + 0x04 = position y (word)
O + 0x06 = character / object	(3 bytes)
O + 0x09 = initial pose (if character)
O + 0x08 = object contained (if object)
O + 0x0D = if value == 1, enabled only with two players

06D02C   0070  0210  0040  0200  0002  0000  0000   .p...@........
06D03A   0140  0228  00B8  080F  0000  0000  0000   .@.(.¸........
06D048   0150  02F0  003F  0A08  0186  0000  0000   .P.ð.?........
06D056   0190  0330  0040  0201  0002  0000  0000   ...0.@........
06D064   01C8  01A8  0028  0201  0000  0000  0000   .È.¨.(........
06D072   01C8  0368  003F  0A05  0187  0000  0000   .È.h.?........
06D080   01F8  0398  003F  0A05  0184  0000  0000   .ø...?........
06D08E   02B0  03B8  00B8  080F  0100  0000  0000   .°.¸.¸........
06D09C   0308  04A8  003F  0A05  0183  0000  0000   ...¨.?........
06D0AA   0338  04D8  003F  0A05  0503  0000  0000   .8.Ø.?........
06D0B8   03A0  0540  0019  0A05  028E  0000  0000   . .@..........
06D0C6   FFFF  0002  0650  06E0  003F  0A04  0126   ÿÿ...P.à.?...&
```

For the ease of reading or usage, we can split each block by 0x0E bytes so that we have first offset starting at 0x06D02C, then the next ones at 0x06D03A,0x06D048 and so on.

### Enemy information

Below's the enemy's map data of the first stage (slum 1)

```
O + 0x00 = when 0xFF8412 == value then load into memory the enemy data:
O + 0x00 = position x (word)
O + 0x02 = position y (word)
O + 0x04 = character / pose (double)
...

070596   03F0  1C20  0005  0000  0000  0007  05F4  0001  0001   .ð. .........
0705A8   03D0  0034  0200  0100  0000  0000  001E  0001         .Ð.4............
0705B8   03D0  0021  0200  0000  0000  0000  003C  0001         .Ð.!.........<..
0705C8   03D0  0034  0205  0000  0000  0000  001E  0001         .Ð.4............
0705D8   03D0  0021  0202  0000  0000  0400  001E  0001         .Ð.!............
0705E8   03D0  0021  0201  0000  0000  0001  8004  7FFF         .Ð.!...........ÿ

```

While the first offset takes 0x12 bytes to store general information, the other ones takes 0x10 bytes for storing enemy information

### Enemies coming from the door

You have probably noticed at stage Slum 1 there are enemies coming from two opening doors placed at beginning and in the middle of the stage.

![Enemies coming from the door](https://github.com/user-attachments/assets/9e33a266-db20-4706-a101-9941ea1c91db)

The information address for this part is the following:

```
O        = position x (word)
O + 0x02 = position y (word)
O + 0x0D = character
O + 0x10 = character
--- 2nd wave ---
O + 0x04 = position x (word)
O + 0x08 = position y (word)
O + 0x17 = character
O + 0x1A = character
O + 0x1D = character

01FB38   0240  003F  03D0  003F  0004  000E  0000  0001   .@.?.Ð.?........
01FB48   0100  0202  00FF  0000  0001  0100  0202  00FF   .....ÿ.........ÿ
01FB58   4EF8  38F2  102E  0002  323B  0006  4EFB  1002   Nø8ò....2;..Nû..
01FB68   0008  0026  006C  006C  302E  0006  906D  0412   ...&.l.l0....m..
01FB78   0640  0022  0C40  01C4  620A  542E  0002  1D7C   .@.".@.Äb.T....|
01FB88   0001  0001  4E75  102D  00A7  D007  0200  0001   ....Nu.-.§Ð.....
01FB98   6738  206E  0080  4A28  0000  6728  1028  0029   g8 n..J(..g(.(.)
01FBA8   0200  000F  43F9  0005  35A6  4EB8  3AD6  302E   ....Cù..5¦N¸:Ö0.
01FBB8   0006  906D  0412  0640  0022  0C40  01C4  6204   ...m...@.".@.Äb.
01FBC8   4EF8  368C  1D7C  0006  0002  4E75  4EF8  38F2   Nø6..|....NuNø8ò
01FBD8   102E  0002  323B  0006  4EFB  1002  0008  001C   ....2;..Nû......
01FBE8   0032  0032  1D7C  0002  0002  3D7C  0078  001E   .2.2.|....=|.x..
```

## Objects in memory

When a mapped object / enemy has to load into memory (see chapters above about map / enemy information), some reserved slots will fill with that data.

Here's an example of slot's available address list:

```
Enemy:
1. 0xff8fe8
2. 0xff8f28
3. 0xff8e68
4. 0xff8da8
5. 0xff8ce8
[...]

Boss:
1. 0xff9a68
2. 0xff99a8 * only for hacks; on regular game, boss is only one for area 
[...]

Objects:
1. 0xffba68
2. 0xffbb28
3. 0xffbbe8
4. 0xffbe28
```

Enemies and boss takes 0xC0 bytes size, so you can easily do a scan starting from the first index and decrease by 0xC0 for looking for the next one


## Special scenes

### Intro

```
O + 2 = position x
O + 4 = position y
O + 6 = object (word)
O + 8 = character
O + F = if value == 1, enabled only with two players

06EC28   0000  00EE  0018  0A01  00FF  0200  FF00   ...î.....ÿ..ÿ.
06EC36   0000  00FE  002C  0A01  00FF  0300  FF00   ...þ.,...ÿ..ÿ.
06EC44   0000  010E  003C  0A01  00FF  0400  FF00   .....<...ÿ..ÿ.
06EC52   0000  0128  0018  0A01  00FF  0500  FF00   ...(.....ÿ..ÿ.
06EC60   0000  0148  003C  0A01  00FF  0600  FF00   ...H.<...ÿ..ÿ.
06EC6E   0000  0180  002C  0A01  00FF  0700  FF00   .....,...ÿ..ÿ.
06EC7C   0000  0190  0038  0817  0000  0000  FF00   .....8......ÿ.
06EC8A   0000  0190  0038  0821  0000  0000  FF00   .....8.!....ÿ.
06EC98   0000  01C8  002C  0821  0100  0000  FF00   ...È.,.!....ÿ.
06ECA6   0000  0190  0018  0821  0200  0000  FF00   .......!....ÿ.
06ECB4   FFFF  0650  070E  00F0  0815  0017  0000   ÿÿ.P...ð......
```


| ROM     | VALUE  | CHARACTER | RAM      |
| ------- | ------ | --------- | -------- |
| 0x6EC91 | 0x2100 | Damnd     | 0xFFADE8 |
| 0x6EC9F | 0x2101 | Doug      | 0xFFAD28 |
| 0x6ECAD | 0x2102 | Jake      | 0xFFAC68 |


![weird intro](https://github.com/user-attachments/assets/7ecde17d-0264-45e0-9b48-252f9e0ff257)


### Bonus: Car

```
06F17A   0000  00D0  002B  0A0B  0100  0000  FF00   ...Ð.+......ÿ.
06F188   0000  0088  0032  0A0C  0000  0000  FF00   .....2......ÿ.
06F196   0000  00E0  0032  0A0D  0000  0000  FF00   ...à.2......ÿ.
06F1A4   0000  00D0  0023  0A0E  0000  0000  FF00   ...Ð.#......ÿ.
06F1B2   0000  00E0  0018  0602  0000  0000  FF00   ...à........ÿ.
06F1C0   0000  0000  0000  0812  0000  0000  0000   ..............
06F1CE   0000  0000  0000  082E  0000  0000  0000   ..............
06F1DC   0000  00C8  0018  082E  0100  0000  0000   ...È..........
06F1EA   0000  0088  0070  0831  0000  0000  0000   .....p.1......
06F1F8   0000  00F8  0070  0831  0100  0000  0000   ...ø.p.1......
06F206   0000  00D0  0058  0831  0200  0000  0000   ...Ð.X.1......
06F214   FFFF  0002  0000  03C8  00C8  080C  0100   ÿÿ.....È.È....
```

You could change the pipe with murasama by replacing value at 0x06F1B6 with 0x0601 for example;
<br>
or you could add another weapon by putting the following value at address 0x6F1CE:

```
06F1CE   0000  0140  0018  0601  0000  0000  FF01   ...@........ÿ.
```

(not sure about the side effects by the way)

![Bonus car](https://github.com/user-attachments/assets/3277f4d5-d300-4afb-848c-5580148b964c)


```
O = offset = 0xffaea8
O + 0x07  = pos x
O + 0x0B  = pos y
O + 0x13  = character
```

### Players catch by Andore at West Side 1



When screen position x (0xFF8412) = 0x600, player status pass to 0x0A (stage clear).
Then Andore reach and grab you.

![Andore take you into the ring](https://github.com/user-attachments/assets/d4215514-11f9-426c-b3ed-0237ea45b19c)

The below code show the trigger moment (see instruction at 0x061576).

```
06155C: jmp     ($2,PC,D1.w)
061566: move.b  ($40,A6), D0
06156A: move.w  ($6,PC,D0.w), D1
06156E: jmp     ($2,PC,D1.w)
061576: cmpi.w  #$600, ($6,A6)
06157C: bcs     $61588
06157E: addq.b  #2, ($40,A6)
061582: move.b  #$1, ($129,A5)
061588: rts
```

Andore information are at 0xff9a68 (same address dedicated to the boss area)

## Bosses data

Unlike ordinary enemies, bosses are not mapped into enemy / stage data (the only exception is Rolento); instead, when loading last stage's area, preliminary boss data is stored on memory starting at address 0xFF9A68, and other data won't be loaded until the meeting of specific criteria:
such conditions could be the reaching a specific screen horizontal position (0xFF8412), vertical position (0xFF845C) - and still is the case of Rolento - or other cases that we'll see later.

Despite all this logic stuff, IT IS POSSIBLE to put a boss on the map / enemy information; however that boss won't spawn until you do some modifications
on the logic ROM data (the only exception to this rule is Edi.E).

### Damnd

![Damnd giving prematurely his warmly welcome](https://github.com/user-attachments/assets/93d6dd61-d7de-4596-883e-0473004454ed)

Below are some critical instructions related to Damnd behaviour:

```
03D3B2  cmpi.w  #$aa0, ($412,A5)                            0C6D 00B0 0412		; when 0xFF8412 = x then boss is active
03EC7A  move.b  #$1, ($12b,A5)                              1B7C 0001 012B		; write boss clear flag
03ECBC  move.b  #$1, ($129,A5)                              1B7C 0001 0129		; write stage clear flag

040860  move.w  #$c8, D1                                    323C 00C8			; if energy drops below this value
040864  cmp.w   ($18,A6), D1                                B26E 0018			; (0xC8) then call for friend's support
040868  bcs     $40874                                      650A			; if carry flag is set, branch on 40874


040B02  cmpi.w  #$bf4, D0                                   0C40 0BF4			; when is thrown or jump over pos x, branch to 040B0A
040B0A  move.w  #$bf3, ($6,A6)                              3D7C 0213 0006		; set position with value x
040C02  cmpi.w  #$bf4, D3                                   0C43 0212			; don't know, set it as x max margin
040C08  cmpi.w  #$ab4, D3                                   0C43 00F4			; don't know, set it as x min margin
040AF2  cmpi.w  #$ab4, D0                                   0C40 00D4			; when is thrown or jump at position over x, branch to 0x040AFA
040AFA  move.w  #$ab4, ($6,A6)                              3D7C 00D4 0006		; set position with value x
```

So let's say we want to fight Damnd also on other stages, we could write some routines starting from a spare ROM slot, i.e. 0x90000:


```
00090000                             7      ORG    $90000
00090000                             8  START:
00090000                             9  CHECK_FINAL_STAGE:                  
00090000  4A2D 00BE                 10      TST.B ($BE,A5)
00090004  6606                      11      BNE.B EXIT
00090006  0C2D 0002 00BF            12      CMPI.B #2,($BF,A5)
0009000C                            13  EXIT:  
0009000C  4E75                      14      RTS    
0009000E                            15  CHECK_SPAWN:    
0009000E  61F0                      16      BSR.B CHECK_FINAL_STAGE
00090010  6706                      17      BEQ.B CHECK_POSITION
00090012                            18  FORCECARRY:
00090012  0C16 0000                 19      CMPI.B #0,(A6)
00090016  4E75                      20      RTS  
00090018                            21  CHECK_POSITION:    
00090018  0C6D 0AA0 0412            22      CMPI.W #$0AA0,($412,A5)    
0009001E  4E75                      23      RTS
00090020                            24  CALL_ENEMIES:
00090020  61DE                      25      BSR.B CHECK_FINAL_STAGE
00090022  66E8                      26      BNE.B EXIT
00090024  323C 00C8                 27      MOVE.W #$C8,D1
00090028  B26E 0018                 28      CMP.W ($18,A6),D1
0009002C  4E75                      29      RTS
0009002E                            30  BOSS_CLEAR_FLAG:
0009002E  61D0                      31      BSR.B CHECK_FINAL_STAGE
00090030  66DA                      32      BNE.B EXIT
00090032  1B7C 0001 012B            33      MOVE.B  #$1, ($12B,A5)
00090038  4E75                      34      RTS
0009003A                            35  STAGE_CLEAR_FLAG:
0009003A  61C4                      36      BSR.B CHECK_FINAL_STAGE
0009003C  66CE                      37      BNE.B EXIT
0009003E  1B7C 0001 0129            38      MOVE.B  #$1, ($129,A5)
00090044  4E75                      39      RTS
```

Then we can modify the following instructions:

```
03D3B2  jsr     $9000e.l                                    4EB9 0009 000E
03D3B8  bcs     $3d3dc                                      6522

03EC7A  jsr     $9002e.l                                    4EB9 0009 002E

03ECBC  jsr     $9003a.l                                    4EB9 0009 003A

040860  jsr     $90020.l                                    4EB9 0009 0020
040866  nop                                                 4E71
040868  bcs     $40874                                      650A

040C08  cmpi.w  #$50, D3                                    0C43

040AF2  cmpi.w  #$50, D0                                    0C40 0050

040AFA  move.w  #$50, ($6,A6)                               3D7C 0050 0006 
```

What we actually did is to modify some critical instructions when Damnd appears not on his expected stage.

0x03D3B2: removed the check with 0xFF8412 value <br>
0x03EC7A: removed the boss clear flag, so the enemies won't die automatically after boss death <br>
0x03ECBC: removed the stage clear flag, so area is not clear <br>
0x040868: avoid Damnd call for friend support when energy drop down to a certain value
0x040C08, 0x040AF2, 0x040AFA: lowered the left margin  <br>

Finally, let's say we want Damnd to show on all 3 slums stages.

Modify these two address in the following way:

```
06D02C   0070  0230  0040  0400  0000  0000  0000   .p.0.@........

06D0E6   0650  0770  002E  0400  0000  0100  0400   .P.p..........
```

![Slum 2](https://github.com/user-attachments/assets/17e03ed6-7cfd-4af3-85d2-9927d8b7124a)

... yeah, we do have it !

### Sodom

The below instructions are related to Sodom character:

```
00E164  cmpi.w  #$1300, ($412,A5)                           0C6D 1300 0412		; don't know
042600  move.b  #$1, ($12b,A5)                              1B7C 0001 012B		; write boss clear flag
042698  move.b  #$1, ($129,A5)                              1B7C 0001 0129		; write stage clear flag
040CFA  cmpi.w  #$1300, ($412,A5)                           0C6D 1300 0412		; when 0xFF8412 = x then boss is active
042ACA  cmpi.w  #$1200, D3                                  0C43 1200			; left stage margin
042AD0  cmpi.w  #$14e0, D3                                  0C43 14E0			; right stage margin
```

Let's do some modifications so that, for example, we face Sodom inside a subway's vagon.

Like we did for Damnd, we create some routines at a spare ROM space, this time at address 0x90100

```
00090100                             7      ORG    $90100
00090100                             8  START:   
00090100                             9  CHECK_FINAL_STAGE:              
00090100  0C2D 0001 00BE            10      CMPI.B #1,($BE,A5)
00090106  6606                      11      BNE.B EXIT
00090108  0C2D 0003 00BF            12      CMPI.B #3,($BF,A5)
0009010E                            13  EXIT:  
0009010E  4E75                      14      RTS    
00090110                            15  CHECK_MUST_SPAWN:    
00090110  61EE                      16      BSR.B CHECK_FINAL_STAGE
00090112  6706                      17      BEQ.B CHECK_POSITION
00090114                            18  FORCECARRY:
00090114  0C16 0000                 19      CMPI.B #0,(A6)
00090118  4E75                      20      RTS  
0009011A                            21  CHECK_POSITION:    
0009011A  0C6D 1300 0412            22      CMPI.W #$1300,($412,A5)    
00090120  4E75                      23      RTS
00090122                            24  BOSS_CLEAR_FLAG:
00090122  61DC                      25      BSR.B CHECK_FINAL_STAGE
00090124  66E8                      26      BNE.B EXIT
00090126  1B7C 0001 012B            27      MOVE.B  #$1, ($12B,A5)
0009012C  4E75                      28      RTS
0009012E                            29  STAGE_CLEAR_FLAG:
0009012E  61D0                      30      BSR.B CHECK_FINAL_STAGE
00090130  66DC                      31      BNE.B EXIT
00090132  1B7C 0001 0129            32      MOVE.B  #$1, ($129,A5)
00090138  4E75                      33      RTS
```

Then we can modify the instructions in order to fight Sodom on the subway stage 2 with no bad side effects:

```
040CFA  jsr     $90110.l                                    4EB9 0009 0110

042600  jsr     $90122.l                                    4EB9 0009 0122

042698  jsr     $9012e.l                                    4EB9 0009 012E

042ACA  cmpi.w  #$0100, D3                                  0C43 0100
```

Finally, we place Sodom at begin of the Subway stage 2 by modifying the related stage map

```
   06D1F6   0500  0606  0048  0201  0001  0000  FF00   .....H......ÿ.
...
   06D220   05BE  075E  0048  0401  0000  0000  FF00   .¾.^.H......ÿ.
...
```

![Sodom on subway 2](https://github.com/user-attachments/assets/008667b0-ef3a-4703-9c80-a8568c2ab8eb)

Maybe we can also make things harder.. so why not facing 2 Sodoms on the final stage's area ?

The idea here is to address the dedicated stage's information to another spare ROM location.

By placing a breakpoint at 0x614E and taking a look to the register A3, we'll first see the value 0x6308, which is the vector address for the first area; a long-word size after this and then we find the base vector of the 2nd area, which is 0x6D178.
By checking the content of 0x6D178, we see:

```
06D178   0008  007C  0208  02D0  0002  0130  02D0  0010   ...|.._þ...0.Ð..
```

The value at 0x6D178 + 0x06 contains the distance in bytes from 0x6D178 where the stage map is located (remember 0x06 = (2 bytes * 4 stage - 2)). <br>
Therefore, stage's data information of the Subway 4 is located at address 0x6D178 + 0x02D0 = 0x6D448. <br>
We can replace value 0x02D0 with 0x5FFE, so that we change the stage data to the spare ROM location 0x73176. 

```
06D178   0008  007C  0208  5FFE  0002  0130  02D0  0010   ...|.._þ...0.Ð..
```

Then we modify its content with the following:

```
073176   0002  1200  1250  0088  0401  0000  0000  0000   .....P..........
073186   FFFF  FFFF  FFFF  FFFF  FFFF  FFFF  FFFF  FFFF   ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
```

and voilà, 2 is better than one (or not?)

![2 Sodoms](https://github.com/user-attachments/assets/5dec5299-5962-452a-996f-b93457400f22)

### Edi.E

This is the easier boss to reuse on Final Fight, as it enough to place its character on the stage / enemy map data just like any other enemy.

These are the location related to the activation of stage and boss clear flags

```
0476CA  move.b  #$1, ($12b,A5)                              1B7C 0001 012B	  ; write boss clear flag
047760  move.b  #$1, ($129,A5)                              1B7C 0001 0129        ; write stage clear flag
```

This is the routine that checks on the West End stage if Edi.E character must be activated

```
 003234  move.w  ($6,A6), D0                                 302E 0006
 003238  sub.w   ($412,A5), D0                               906D 0412
 00323C  addi.w  #$30, D0                                    0640 0030
 003240  cmpi.w  #$1e0, D0                                   0C40 01E0	(this occurs when $ff8412 = $d10)
 003244  bhi     $3264                                       621E
```

but we can ignore this and focus to the flags above so they are enabled only on the last stage.

We write this code on a spare ROM address (in this example 0x90200)

```
00090200                             7      ORG    $90200
00090200                             8  START:   
00090200                             9  CHECK_FINAL_STAGE:              
00090200  0C2D 0002 00BE            10      CMPI.B #2,($BE,A5)
00090206  6606                      11      BNE.B EXIT
00090208  0C2D 0002 00BF            12      CMPI.B #2,($BF,A5)
0009020E                            13  EXIT:  
0009020E  4E75                      14      RTS    
00090210                            15  BOSS_CLEAR_FLAG:
00090210  61EE                      16      BSR.B CHECK_FINAL_STAGE
00090212  66FA                      17      BNE.B EXIT
00090214  1B7C 0001 012B            18      MOVE.B  #$1, ($12B,A5)
0009021A  4E75                      19      RTS
0009021C                            20  STAGE_CLEAR_FLAG:
0009021C  61E2                      21      BSR.B CHECK_FINAL_STAGE
0009021E  66EE                      22      BNE.B EXIT
00090220  1B7C 0001 0129            23      MOVE.B  #$1, ($129,A5)
00090226  4E75                      24      RTS
```

and then we place our routine calls:

```
0476CA  jsr     $90210.l                                    4EB9 0009 0210

047760  jsr     $9021C.l                                    4EB9 0009 021C
```

![Edi.E](https://github.com/user-attachments/assets/6dfd0edb-c7aa-41fc-b9e8-eb5fc4f892c3)

### Rolento

This is the only boss area thay is actually mapped into the stage map data, like an ordinary enemy.

Let's having a look at address 0x06D954:

```
   06D946   0910  0E20  0930  0205  0102  0000  0000    ..  0........
   06D954   0980  0D74  0A80  0403  0000  0000  FF00    ..t........ÿ.
   06D962   FFFF  0002  0002  0108  02A8  0040  0201   ÿÿ.......¨.@..
```

Notice that on this stage (Industrial Area 2) enemies load on memory according to the vertical stage position 0xFF845C.

```
 0060D2  cmp.w   ($45c,A5), D0                               B06D 045C
 0060D6  bgt     $60e2                                       6E0A
 0060D8  bsr     $616a                                       6100 0090
```

The first two times Rolento will appear on screen, we see him going up the ladder thowing some bombs. <br>

Technically, it's just an object (0x082A) mapped on the stage data at addresses 0x06D89E and 0x06D8D6, when stage's vertical position reach
value 0x01D4 and later 0x05DA

```
   06D89E   01D4  0D74  02D4  082A  0000  0000  0000   .Ô.t.Ô.*......
...
   06D8D6   05D4  0D74  06D4  082A  0000  0000  0000   .Ô.t.Ô.*......
```

As we seen above, Rolento is mapped at position 0x0980, however his status flag is updated when meeting the following condition:

```
 048AAA: cmpi.w  #$ac0, ($45c,A5)
 048AB0: bcs     $48aca
 048AB2: addq.b  #2, ($3,A6)
 048AB6: move.w  #$580, ($94,A6)
```

At a certain moment he will start jumping over the lift bars, we can see these two routines:

```
 049782  cmpi.w  #$8c, ($a,A6)                               0C6E 008C 000A
 049788  bcc     $4976c                                      64E2
 04978A  addq.b  #2, ($5,A6)                                 542E 0005
 04978E  move.w  #$8c, ($a,A6)                               3D7C 008C 000A

...

 049218  cmpi.w  #$8c, ($a,A6)                               0C6E 008C 000A
 04921E  bcc     $49206                                      64E6
 049220  addq.b  #2, ($5,A6)                                 542E 0005
 049224  move.w  #$8c, ($a,A6)                               3D7C 008C 000A
```

Notice, in case we want to change the value of the height Rolento will jump over, we can change the value 0x8C with something else.

Now, let's say we want to share the ring with Sodom and Rolento, but ONLY when playing 2 players mode:

As usually, we write a routine for Rolento, this time ad address 0x90300


```
00090300                             7      ORG    $90300
00090300                             8  START:   
00090300                             9  CHECK_FINAL_STAGE:              
00090300  0C2D 0003 00BE            10      CMPI.B #3,($BE,A5)
00090306  6606                      11      BNE.B EXIT
00090308  0C2D 0001 00BF            12      CMPI.B #1,($BF,A5)
0009030E                            13  EXIT:  
0009030E  4E75                      14      RTS    
00090310                            15  CHECK_SPAWN:    
00090310  61EE                      16      BSR.B CHECK_FINAL_STAGE
00090312  6708                      17      BEQ.B CHECK_POSITION
00090314                            18  FORCECARRY:
00090314  0C6D 0000 045C            19      CMPI.W  #$0, ($45C,A5)
0009031A  4E75                      20      RTS  
0009031C                            21  CHECK_POSITION:    
0009031C  0C6D 0AC0 045C            22      CMPI.W  #$AC0, ($45C,A5)    
00090322  4E75                      23      RTS    
00090324                            24  BOSS_CLEAR_FLAG:
00090324  61DA                      25      BSR.B CHECK_FINAL_STAGE
00090326  66E6                      26      BNE.B EXIT
00090328  1B7C 0001 012B            27      MOVE.B  #$1, ($12B,A5)
0009032E  4E75                      28      RTS
00090330                            29  STAGE_CLEAR_FLAG:
00090330  61CE                      30      BSR.B CHECK_FINAL_STAGE
00090332  66DA                      31      BNE.B EXIT
00090334  1B7C 0001 0129            32      MOVE.B  #$1, ($129,A5)
0009033A  4E75                      33      RTS
```

Then we change the check at 0x48AAA so Rolento will immediately appear when reaching position:

```
 048AAA  jsr     $90310.l                                    4EB9 0009 0310
```

As we did for Sodom, we modify this:

```
06D178   0008  007C  0208  5FFE  0002  0130  02D0  0010   ...|.._þ...0.Ð..
```

We change the stage map related to Subway 4 with this:

```
073176   0002  1200  1250  0088  0403  0000  0000  FF01   .....P..........
073186   FFFF  FFFF  FFFF  FFFF  FFFF  FFFF  FFFF  FFFF   ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
```

![Rolento&Sodom](https://github.com/user-attachments/assets/53173356-4862-451a-8aac-3b18ed7cfeb9)

We can enjoy Rolento & Sodom with 2P mode. On palette chapter we see how we can fix Rolento's palette

### Abigail

Like Edi.E, this is a quite simple boss to fit in any scenario.

As usually there's a position matching stage in order to make him spawn:

```
04BE30  cmpi.w  #$2280, ($412,A5)                           0C6D 2280 0412
04BE36  bcs     $4beb6                                      6500 007E
	
04D404  move.b  #$1, ($12b,A5)                              1B7C 0001 012B		; write boss clear flag

04D4E2  move.b  #$1, ($129,A5)                              1B7C 0001 0129		; write stage clear flag
```

We write the following routine:

```
00090400                             7      ORG    $90400
00090400                             8  START:   
00090400                             9  CHECK_FINAL_STAGE:              
00090400  0C2D 0004 00BE            10      CMPI.B #4,($BE,A5)
00090406                            11  EXIT    
00090406  4E75                      12      RTS    
00090408                            13  CHECK_SPAWN:    
00090408  61F6                      14      BSR.B CHECK_FINAL_STAGE
0009040A  6706                      15      BEQ.B CHECK_POSITION
0009040C                            16  FORCECARRY:
0009040C  0C16 0000                 17      CMPI.B #0,(A6)
00090410  4E75                      18      RTS  
00090412                            19  CHECK_POSITION:    
00090412  0C6D 2280 0412            20      CMPI.W #$2280,($412,A5)    
00090418  4E75                      21      RTS
0009041A                            22  BOSS_CLEAR_FLAG:
0009041A  61E4                      23      BSR.B CHECK_FINAL_STAGE
0009041C  66E8                      24      BNE.B EXIT
0009041E  1B7C 0001 012B            25      MOVE.B  #$1, ($12B,A5)
00090424  4E75                      26      RTS
00090426                            27  STAGE_CLEAR_FLAG:
00090426  61D8                      28      BSR.B CHECK_FINAL_STAGE
00090428  66DC                      29      BNE.B EXIT
0009042A  1B7C 0001 0129            30      MOVE.B  #$1, ($129,A5)
00090430  4E75                      31      RTS
```

And then we program the jump to:

```
 04D404  jsr     $9041a.l                                    4EB9 0009 041A

 04D4E2  jsr     $90426.l                                    4EB9 0009 0426
```

![Abigail on charge](https://github.com/user-attachments/assets/0ef99122-3366-4975-93f0-6e2c7d92b428)


### Belger

Last boss will not spawn until we reach the 0xFF8412 match value (horizontal stage position).

```
04EA0A: cmpi.w  #$3240, ($412,A5)			    0C6D 3240 0412
04EA14  move.w  #$3200, ($6,A6)                             3D7C 3200 0006
```

In most of the cases, stages vertical position (0xFF845C) equals 0, so in order to place Belger on our stage we need to replace this instruction:

```
04FF3C  subi.w  #$828, D0                                   0440 0828
```

with this:

```
04FF3C  subi.w  #$028, D0                                   0440 0028
```

You'll also notice that, when Belger is about to die, he keeps his position near the window of the building, so he can better take off at the right moment :)

There's an instruction that check for Belger's energy:

```
04F076  cmpi.w  #$32, ($18,A6)                              0C6E 0032 0018
04F07C  bhi     $4f096                                      6218
..
04F5E0  move.w  #$3370, ($a6,A6)                            3D7C 3370 00A6
..
050670  cmpi.w  #$32, ($18,A6)                              0C6E 0032 0018
050676  bhi     $50690                                      6218
```

We can skip that check by simply replacing that bhi with bra (6018) on 0x4F07C and 0x50676, so that we keep Belger stable on the screen

![Belger](https://github.com/user-attachments/assets/80641579-2f6a-4fb2-a65a-cceceee29e1d)
