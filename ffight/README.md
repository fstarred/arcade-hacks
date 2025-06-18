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
0xFF8412 = scene position x (word)
0xFF8129 = stage clear
0xFF812B = boss clear
0xFF845C = scene position y (word)
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

**Map routine:**

Scan from the vector address and load into memory mapped enemies and objects; enemies contained into this map are not mandatory to beat for advancing the next stage.

**Enemy routine:**

Scan from the vector address and load into memory mapped enemies. 

In order to advance forward in the level or go for the next stage, you must beat all of these enemies.


| STAGE     | MAP R.   | ENEMY R. |
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

### Map routine

Information map address is extracted by the following routine called on stage init.

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

Here's an example of the first stage map (slum 1), located at address 0x06D02C:

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

We can divide each block by 0x0E bytes, so we have first offset starting at 0x06D02C, then the next ones at 0x06D03A,0x06D048 and so on.

### Enemy information

Below's the enemy's map of the first stage (slum 1)

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

Unlike ordinary enemies, boss position is not stored in any map; instead, when loading last stage's area, initial boss data is stored on memory from address 0xFF9A68.

Boss won't be activated until meeting certain conditions, such as reaching a specific screen horizontal position (0xFF8412), vertical position (0xFF845C) - that's the case of Rolento - or other cases that we'll see later.

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
00090000  4A2D 00BE                  9      TST.B ($BE,A5)
00090004  6606                      10      BNE.B EXIT
00090006  0C2D 0002 00BF            11      CMPI.B #2,($BF,A5)
0009000C                            12  EXIT:
0009000C  4E75                      13      RTS    
0009000E                            14  CHECK_FINAL_STAGE:    
0009000E  61F0                      15      BSR.B START
00090010  6706                      16      BEQ.B CHECK_ENABLE
00090012                            17  FORCECARRY:
00090012  0C16 0000                 18      CMPI.B #0,(A6)
00090016  4E75                      19      RTS  
00090018                            20  CHECK_ENABLE:    
00090018  0C6D 0AA0 0412            21      CMPI.W #$0AA0,($412,A5)    
0009001E  4E75                      22      RTS
00090020                            23  CALL_ENEMIES:
00090020  61DE                      24      BSR.B START
00090022  66E8                      25      BNE.B EXIT
00090024  323C 00C8                 26      MOVE.W #$C8,D1
00090028  B26E 0018                 27      CMP.W ($18,A6),D1
0009002C  4E75                      28      RTS
0009002E                            29  BOSS_CLEAR_FLAG:
0009002E  61D0                      30      BSR.B START
00090030  66DA                      31      BNE.B EXIT
00090032  1B7C 0001 012B            32      MOVE.B  #$1, ($12B,A5)
00090038  4E75                      33      RTS
0009003A                            34  STAGE_CLEAR_FLAG:
0009003A  61C4                      35      BSR.B START
0009003C  66CE                      36      BNE.B EXIT
0009003E  1B7C 0001 0129            37      MOVE.B  #$1, ($129,A5)
00090044  4E75                      38      RTS
00090046                            39      
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
00090100  0C2D 0001 00BE             9      CMPI.B #1,($BE,A5)
00090106  6606                      10      BNE.B EXIT
00090108  0C2D 0003 00BF            11      CMPI.B #3,($BF,A5)
0009010E                            12  EXIT:  
0009010E  4E75                      13      RTS    
00090110                            14  CHECK_FINAL_STAGE:    
00090110  61EE                      15      BSR.B START
00090112  6706                      16      BEQ.B CHECK
00090114                            17  FORCECARRY:
00090114  0C16 0000                 18      CMPI.B #0,(A6)
00090118  4E75                      19      RTS  
0009011A                            20  CHECK:    
0009011A  0C6D 1300 0412            21      CMPI.W #$1300,($412,A5)    
00090120  4E75                      22      RTS
00090122                            23  BOSS_CLEAR_FLAG:
00090122  61DC                      24      BSR.B START
00090124  66E8                      25      BNE.B EXIT
00090126  1B7C 0001 012B            26      MOVE.B  #$1, ($12B,A5)
0009012C  4E75                      27      RTS
0009012E                            28  STAGE_CLEAR_FLAG:
0009012E  61D0                      29      BSR.B START
00090130  66DC                      30      BNE.B EXIT
00090132  1B7C 0001 0129            31      MOVE.B  #$1, ($129,A5)
00090138  4E75                      32      RTS
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

The idea here is to address the dedicated map's information to another spare ROM location.

If we place a breakpoint at 0x614E and we take a look to the register A3, we'll first see the value 0x6308, which is the vector address for the first area; a long-word size after we find the base vector of the 2nd area, which is 0x6D178.
By checking the content of 0x6D178, we see:

```
06D178   0008  007C  0208  02D0  0002  0130  02D0  0010   ...|.._þ...0.Ð..
```

The value at 0x6D178 + 0x06 contains the offset from 6D178 where the map is located, since 0x06 = (2 bytes * 4 stage - 2). <br>
Therefore, map information of the Subway last stage is located at address 0x6D178 + 0x02D0 = 0x6D448. <br>
We can replace value 0x02D0 with 0x5FFE, so that final map location will be on the spare ROM 0x73176 and modify its content with the following:

```
073176   0002  1200  1250  0088  0401  0000  0000  0000   .....P..........
073186   FFFF  FFFF  FFFF  FFFF  FFFF  FFFF  FFFF  FFFF   ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
```

and voilà, 2 is better than one (or not?)

![2 Sodoms](https://github.com/user-attachments/assets/5dec5299-5962-452a-996f-b93457400f22)

