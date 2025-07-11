# Final Fight

# Table of Contents
1. [System information](#a-system)	
2. [General game data](#a-general)
3. [Characters and objects data](#a-objdata)
   1. [Player data](#a-playerdata)
   2. [Enemy data](#a-enemydata)
   3. [Characters](#a-charsdata)   
   4. [Mappable objects](#a-mappableobj)
   5. [Breakable objects](#a-breakobj)
4. [Stage mapping](#a-stagemap)
   1. [Stage routine](#a-stageroutine)
   2. [Enemy routine](#a-enemyroutine)
   3. [Stage map](#a-stagemap)
   4. [Enemy map](#a-enemymap)
5. [Area/Stage sequence](#a-stageseq)
6. [Objects in memory](#a-objectsmem)
7. [Special scenes](#a-specialscenes)
   1. [Presentation](#a-presentation)
   2. [Demo scenes](#a-demoscenes)
   3. [Slum intro](#a-slumintro)
   4. [Bonus car](#a-bonuscar)
   5. [West Side 1 Andore](#a-wside1andore)
8. [Bosses](#a-bosses)
   1. [Damnd](#a-damnd)
   2. [Sodom](#a-sodom)
   3. [Edi.E](#a-edie)
   4. [Rolento](#a-rolento)
   5. [Abigail](#a-abigail)
   6. [Belger](#a-belger)


![Andore at start](https://github.com/user-attachments/assets/62648f7e-de08-4460-a915-520712c65192)

<a id="a-system"></a>
## System information

**CPU**
* Motorola MC68000 10 MHz
* Zilog Z80 3.5 MHz

**Specs**<br>
[M68000](../specs/M68000_16_32-Bit_Microprocessor_Programmers_Reference_Manual_4th_Edition_text.pdf)

**Other references**<br>
[The Book of CP-System](https://fabiensanglard.net/cpsb/index.html)

<a id="a-general"></a>
## General game data

```
0xFF8082 = demo mode (00=OFF | FF=ON)
0xFF80BE = area value
0xFF80BF = stage value
0xFF80C1 = level sequence
0xFF8412 = stage position x (word)
0xFF8129 = stage clear flag
0xFF812B = area clear flag
0xFF845C = stage position y (word)
```

<a id="a-objdata"></a>
## Characters and objects data

<a id="a-playerdata"></a>
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

<a id="a-enemydata"></a>
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

<a id="a-charsdata"></a>
### Characters

This is the character's available value that I discovered so far:

#### Ordinary enemies

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

#### Bosses

```
04 0000 = Damnd
04 0100 = Sodom
04 0200 = Edi.E
04 0300 = Rolento
04 0400 = Abigail
04 0500 = Belger
04 0600 = Bosstest
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

<a id="a-mappableobj"></a>
### Mappable objects

```
0x080F = sliding door
0x0816 = drop
0x082A = Rolento going down the ladder
0x0831 = break point arrow

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

0x120000 = barbecue		
0x120001 = steak				
0x120002 = chicken			
0x120003 = hamburger	
0x120004 = hot dog			
0x120005 = pizza				
0x120006 = curry				
0x120007 = sushi				
0x120008 = banana				
0x120009 = pineapple	
0x12000A = apple				
0x12000B = orange				
0x12000C = grape				
0x12000D = soft drink
0x12000E = soft drink
0x12000F = beer					
0x120010 = beer					
0x120011 = whisky				
0x120012 = beer					
0x120013 = gum					
0x120014 = diamond			
0x120015 = gold bar		
0x120016 = ruby					
0x120017 = emerdald		
0x120018 = pearl				
0x120019 = topaz				
0x12001A = necklace		
0x12001B = watch				
0x12001C = dollar				
0x12001D = yen					
0x12001E = yen					
0x12001F = radio				
0x120020 = napkin				
0x120021 = hat					
0x120022 = hammer				

0x060000 = knife		
0x060100 = murasama		
0x060200 = pipe			
```

<a id="a-breakobj"></a>
### Breakable objects

The following is a code map of the objects that pop up once you destroy some objects (i.e. a drumcan, barrel, tire, etc.).

Unfortunately I still have to understand the logic behind these codes, however you can try by yourself; set the 2 bytes code right after the object type on the stage map (see offset + 0x08 on Map information chapter)

```
0x100 = food (barbecue)
0x101 = food (steak)
0x102 = food (barbecue)
0x124 = knife
0x125 = muramasa
0x126 = pipe
0x180 = nothing
0x181 = food
0x185 = topaz
0x186 = point
0x183 = food (beer)
0x187 = nothing
0x18a = weapon
0x18e = hot dog
0x200 = food (barbecue)
0x225 = muramasa
0x226 = pipe
0x282 = food (pineapple)
0x283 = food (beer)
0x503 = food
```

<a id="a-stagemap"></a>
## Stage mapping

There are two main addresses for each stage dedicated for mapping enemies or objects, each of them are scanned by dedicated routines.

For the sake of convenience, we'll call in the following way:

**Stage routine:**

Scan from the vector address and load into memory mapped enemies and objects; enemies contained into this map are not blocking, so player can advance to next stage without killing them.

**Enemy routine:**

Scan from the vector address and load into memory mapped enemies. 

In order to advance forward in the level or go for the next stage, you must beat all of these enemies.

<a id="a-stageroutine"></a>
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

<a id="a-enemyroutine"></a>
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

<a id="a-stagemap"></a>
### Stage map

Here's an example of the first stage map data (slum 1), located at address 0x06D02C:

```
O + 0x00 = when 0xFF8412 == value, then load into memory
O + 0x02 = position x (word)
O + 0x04 = position y (word)
O + 0x06 = character / object	(3 bytes for characters, 2 for objects)
O + 0x08 = object inside (only for object)
O + 0x09 = initial pose (only for character)
O + 0x0D = if value == 1, enabled only with 2 players mode

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

<a id="a-enemymap"></a>
### Enemy map

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

#### Stage mapping addresses

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

#### Enemies coming from the door

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

<a id="a-stageseq"></a>
## Area/Stage sequence

After the player select sequence, these instruction initialize the stage / area value to 0:

```
 05C8BE  move.b  ($e,A6), ($be,A5)                           1B6E 000E 00BE
 05C8C4  move.b  ($f,A6), ($bf,A5)                           1B6E 000F 00BF

 004D30  clr.b   ($bf,A5)                                    422D 00BF
```

You may take a look at this routine called after clearing a stage:

```
 004E70  addq.b  #1, ($bf,A5)                                522D 00BF                  ; increase stage value
 004E74  bsr     $5476                                       6100 0600
...
 005476  moveq   #$0, D0                                     7000
 005478  move.b  ($be,A5), D0                                102D 00BE
 00547C  move.b  ($4,PC,D0.w), D0                            103B 0004			; read from address 0x005482,x
...
 004E78  cmp.b   ($bf,A5), D0                                B02D 00BF
 004E7C  bhi     $4e86                                       6208
 004E7E  move.w  #$a, ($0,A5)                                3B7C 000A 0000
 004E84  rts                                                 4E75
... if passes on PC = 0x04E7E
 0054C0  move.b  ($c1,A5), D0                                102D 00C1			; 0xFF80C1 = sequence level
 0054C4  add.b   D0, D0                                      D000
 0054C6  move.b  ($34,PC,D0.w), ($be,A5)                     1B7B 0034 00BE
 0054CC  move.b  ($2f,PC,D0.w), ($122,A5)                    1B7B 002F 0122		; read from address 0x0054FC,x
 0054D2  rts                                                 4E75
```

To better understand the above routine, consider this:<br>

Each time a stage is clear, its value increase (see 0x004E70). <br>

This is the content of address 0x005482:

```
 005482   0304  0302  0103  0101  0101  102D  0065  0200   ...........-.e..
```

Every bytes simple means the number of stages for each area. (i.e. SLUM = 03, SUBWAY = 04, W.SIDE = 03, etc..)

| STAGE      | AREA | LEVEL SEQ | STAGES |
| ---------- | ---- | --------- | ------ |
| SLUM       | 0x00 | 0x00      | 3      |
| SUBWAY     | 0x01 | 0x01      | 4      |
| B. CAR     | 0x06 | 0x02      | -      |
| WEST SIDE  | 0x02 | 0x03      | 3      |
| IND. AREA  | 0x03 | 0x04      | 2      |
| B. GLASS   | 0x07 | 0x05      | -      |
| BAY AREA   | 0x04 | 0x06      | 1      |
| UP TOWN    | 0x05 | 0x07      | 3      |

After increasing its value, if current stage value equals the number of the stages related to the current area (see instruction 0x00547C),
the sequence byte increases its value (0xFF80C1) so that the routine point to next expected area

```
0054FC   0000  0100  0601  0200  0300  0701  0400  0500   ................	
```

You can see from the above data - expressed in word unit - the area sequence planned during the game.

#### Changing the area sequence order

As usually, let's do a simple drill to demonstrate how this stuff work; we'll start from Subway area (value 1), then we'll back to Slum area (value 0), and then
we'll switch the bonus area.<br>

So we modify the area init instruction with:

```
05C8BE  move.b  #0, ($be,A5)                           1B7C 0000 00BE
```

and then the content of the area sequence:

```
0054FC   0000  0000  0701  0200  0300  0601  0400  0500   ................	
```

Notice the first two bytes are actually unused, because if you want to change the starting area you have to modify the instruction at 0x05C8BE, as we did above


<a id="a-objectsmem"></a>
## Objects in memory

Each type of object (i.e. enemy, food, breakable obstacle) has its reserved size of RAM to fill when need to be displayed.

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

Obstacles:
1. 0xffba68
2. 0xffbb28
3. 0xffbbe8
4. 0xffbe28
```

Enemies and boss takes 0xC0 bytes size, so you can easily do a scan starting from the first index and decrease by 0xC0 for looking for the next one


<a id="a-specialscenes"></a>
## Special scenes

<a id="a-presentation"></a>
### Presentation

![Guy](https://github.com/user-attachments/assets/bd76ddc4-09dd-4dfd-99c9-4e7b3f1924af)

All these scenes occurs during demo mode.

The below data is the Guy's movement's map that is used for his presentation which takes place in the subway 2 stage.

```
   072200   0000  0012  0001  0013  0000  0022  0001  001D   ..........."....
   072210   0011  0007  0001  0001  0000  0004  0010  0006   ................
   072220   0000  0FF8  5688  2006  0000  0003  0010  0005   ...øV. .........
   072230   0000  0004  0010  0004  0000  0004  0010  0004   ................
   072240   0000  0004  0010  0003  0000  0005  0010  0006   ................
   072250   0000  001A  0020  0004  0022  0003  0002  0007   ..... ..."......
   072260   0000  0027  0001  0038  0021  0008  0001  0003   ...'...8.!......
   072270   0000  0006  0010  0005  0000  010B  0020  000A   ............. ..
   072280   0000  0001  0010  0007  0000  0059  0001  0002   ...........Y....
   072290   0021  0008  0001  0004  0011  0006  0001  0002   .!..............
   0722A0   0000  0016  0000  0000  0000  0000  0000  0000   ................
   0722B0   0000  0000  0000  0000  0000  0000  0000  0000   ................
```

The structure is quite simple:

```
O + 0 = character's movement (2 bytes)
O + 2 = timing (2 bytes)
...
```

#### controls

The following is the input byte table:

```
0x01 Right
0x02 Left
0x04 Up
0x08 Down
0x10 Button 1    
0x20 Button 2    
```

These value can be combined using OR operator.

Now we take as an example the values contained at address 0x72210 which are :

```
0011 movement
0007 timing
```

This means that for 0x7 VBLANK times, the registered movement is 0x11, which equals to:

01 OR 10, RIGHT + BUTTON 1<br>

Timing value is registered at memory 0xFF12AC, while movement at 0xFF805C and 0xFF8568+82.

The following is where we can find the table of movements for each hero:

| GUY     | CODY    | HAGGAR  |
| --------| ------- | ------- |
| 0x72200 | 0x72300 | 0x72400 |

<a id="a-demoscenes"></a>
### Demo scenes

![0523](https://github.com/user-attachments/assets/ba9a48c0-8d27-4e82-a201-5f7d86067478)

Like hero's preview, stage demo works in a similar way.

The following routine init the map of movement address at memory 0xFF80E4 and 0x0FF80F4, respectively for player 1 and 2.

```
 002AC0  move.w  (-$4,A1), D0                                3029 FFFC
 002AC4  lea     (-$4,A1,D0.w), A2                           45F1 00FC
 002AC8  move.l  A2, ($e4,A5)                                2B4A 00E4 ; init P1 movement map address at RAM 0xFF80E4
 002ACC  move.w  (-$2,A1), D0                                3029 FFFE 
 002AD0  lea     (-$4,A1,D0.w), A2                           45F1 00FC
 002AD4  move.l  A2, ($f4,A5)                                2B4A 00F4 ; init P2 movement map address at RAM 0xFF80F4
 002AD8  rts                                                 4E75
```

These are the movement address map for the 3 demo scenes:

| Player 1 | Player 2 | Stage     |
| -------- | -------- | --------- |
| 0x63FEC  | 0x6406C  | SLUM 3    |
| 0x64120  | 0x641C0  | I. AREA 1 |
| 0x642C4  | 0x643E4  | SUBWAY 2  |

For instance, this is the movement's map of Guy at Slum 3 stage (the first demo scene in co-op with Haggar).

```
O + 0 = timing   (byte)
O + 1 = movement (byte)
...

   063FEC   3E00  0610  D700  1008  0900  0610  1C00  0901   >...×... ..... .
   063FFC   0100  0810  1400  1101  0A11  4901  0300  1602   ..........I.....
   06400C   0800  6801  2200  0504  1106  0604  0605  1101   ..h."...........
   06401C   0D00  0B01  1109  0218  0A10  0C00  4502  1A06   ..... ......E...
   06402C   0D04  0105  0101  2900  0A08  1309  0201  1300   ......).... ....
   06403C   0D04  0705  0315  0114  0410  1900  1B02  0F00   ................
   06404C   0302  120A  0102  1600  0A04  1605  0204  0500   ................
   06405C   0810  0B00  0810  3B00  0808  FF00  0000  0000   ......;...ÿ.....
   06406C   3E00  0702  1400  0701  1400  0210  4B00  0304   >...........K...
   06407C   7005  1504  1505  0F01  0411  1C01  0E09  0D01   p............ ..
   06408C   0511  5401  0211  0110  0304  0600  0210  0800   ..T.............
   06409C   0310  0700  0510  0700  0410  0600  0510  1100   ................
```

While playing the scene, this routine read and set either timing and movement code from the address is currently pointing at 0xFF80E4 / 0xFF80F4

```
 002C50  move.b  ($0,A2), ($6,A3)                            176A 0000 0006 ; read and set timing value
 002C56  beq     $2c66                                       670E
 002C58  subq.b  #1, ($6,A3)                                 532B 0006
 002C5C  move.b  ($1,A2), ($82,A4)                           196A 0001 0082 ; read and set movement value
 002C62  addq.l  #2, ($0,A3)                                 54AB 0000
 002C66  rts                                                 4E75
```

Timing value is registered at memory 0xFF80EA for P1 and 0xFF80FA for P2, while movements on Player reserved address (either 0xFF8568 or 0xFF8628) + 0x82.

```
   O + 0 = pointer to registered movement map
   O + 6 = current timing value, decrease each VBLANK occurs

   FF80E4   0006  3FEE  0000  3D00  0000  0000  0000  0000   ..?î..=......... ; P1
   FF80F4   0006  406E  0000  3D00  0000  0000  0000  0000   ..@n..=......... ; P2
```

<a id="a-slumintro"></a>
### Slum intro

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

<a id="a-bonuscar"></a>
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

<a id="a-wside1andore"></a>
### West Side 1 Andore scene

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

<a id="a-bosses"></a>
## Bosses

Unlike ordinary enemies, bosses are not mapped into enemy / stage data (the only exception is Rolento); instead, when loading last stage's area, preliminary boss data is stored on memory starting at address 0xFF9A68, and other data won't be loaded until the meeting of specific criteria:
such conditions could be the reaching a specific screen horizontal position (0xFF8412), vertical position (0xFF845C) - and still is the case of Rolento - or other cases that we'll see later.

Despite all this logic stuff, IT IS POSSIBLE to put a boss on the map / enemy information; however that boss won't spawn until you do some modifications
on the logic ROM data (the only exception to this rule is Edi.E).

<a id="a-damnd"></a>
### Damnd

![Damnd giving prematurely his warmly welcome](https://github.com/user-attachments/assets/93d6dd61-d7de-4596-883e-0473004454ed)

Below are listed some instructions that affect Damnd's behaviour:

```
03D3B2  cmpi.w  #$aa0, ($412,A5)                            0C6D 00B0 0412		; when 0xFF8412 = x then boss is active
03EC7A  move.b  #$1, ($12b,A5)                              1B7C 0001 012B		; write boss clear flag
03ECBC  move.b  #$1, ($129,A5)                              1B7C 0001 0129		; write stage clear flag

040860  move.w  #$c8, D1                                    323C 00C8			; if energy drops below this value
040864  cmp.w   ($18,A6), D1                                B26E 0018			; (0xC8) then call for friend's support
040868  bcs     $40874                                      650A			; if carry flag is set, branch on 40874


040B02  cmpi.w  #$bf4, D0                                   0C40 0BF4			; when is thrown or jump over pos x, branch to 040B0A
040B0A  move.w  #$bf3, ($6,A6)                              3D7C 0213 0006		; set position with value x
040C02  cmpi.w  #$bf4, D3                                   0C43 0212			; unknown
040C08  cmpi.w  #$ab4, D3                                   0C43 00F4			; unknown
040AF2  cmpi.w  #$ab4, D0                                   0C40 00D4			; when is thrown or jump at position over x, branch to 0x040AFA
040AFA  move.w  #$ab4, ($6,A6)                              3D7C 00D4 0006		; set position with value x
```

Ok, let's say we want to fight Damnd also on other stages, we could write some routines starting from a spare ROM slot, i.e. 0xE0000:


```
000E0000                             7      ORG    $E0000
000E0000                             8  START:
000E0000                             9  L3D3B2:    
000E0000  0C6D 0002 00BE            10      CMPI.W #$0002,($BE,A5)
000E0006  6720                      11      BEQ.B .CHECK_POSITION
000E0008                            12  .LOAD_COLORS:
000E0008  48E7 80C0                 13      MOVEM.L D0/A0-A1,-(SP)
000E000C  7008                      14      MOVEQ #8,D0
000E000E  41F9 000C03E0             15      LEA $0C03E0,A0                  ; $0C0000 (SLUM PALETTE) + ($1E*$20)
000E0014  43F9 009143A0             16      LEA $9143A0,A1                  ; $914000 (PALETTE REGISTER) + ($1D*$20)
000E001A                            17  .LOOPCOL:
000E001A  22D8                      18      MOVE.L (A0)+,(A1)+
000E001C  51C8 FFFC                 19      DBF D0,.LOOPCOL    
000E0020  4CDF 0301                 20      MOVEM.L (SP)+,D0/A0-A1
000E0024  4A00                      21      TST.B D0                        ; RESET CARRY FLAG
000E0026  4E75                      22      RTS  
000E0028                            23  .CHECK_POSITION:    
000E0028  0C6D 0AA0 0412            24      CMPI.W #$0AA0,($412,A5)    
000E002E  4E75                      25      RTS
000E0030                            26  L40860:
000E0030  6700 000E                 27      BEQ .CHECKENERGY
000E0034  0C6D 0002 00BE            28      CMPI.W #0002,($BE,A5)
000E003A  660A                      29      BNE.B .FORCECARRYFLAG
000E003C  323C 00C8                 30      MOVE.W #$C8,D1
000E0040                            31  .CHECKENERGY    
000E0040  B26E 0018                 32      CMP.W ($18,A6),D1
000E0044  4E75                      33      RTS
000E0046                            34  .FORCECARRYFLAG:
000E0046  0C2E 0005 0012            35      CMPI.B #$5,($12,A6)             ; DEST OPERAND IS ALWAYS $04
000E004C  4E75                      36      RTS
000E004E                            37  L40B02:
000E004E  0C6D 0002 00BE            38      CMPI.W #0002,($BE,A5)
000E0054  6608                      39      BNE.B .EXIT
000E0056  0C40 0BF4                 40      CMPI.W #$BF4,D0
000E005A  6502                      41      BCS.B .EXIT
000E005C  4E75                      42      RTS
000E005E                            43  .EXIT    
000E005E  588F                      44      ADDQ.L #4,SP
000E0060  4EF9 00040B10             45      JMP $40B10
000E0066                            46  L40C02:
000E0066  0C6D 0002 00BE            47      CMPI.W #0002,($BE,A5)        
000E006C  6616                      48      BNE.B .EXIT
000E006E  0C43 0BF4                 49      CMPI.W #$BF4,D3
000E0072  6500 000A                 50      BCS .L40C08
000E0076                            51  .BRATO40C1E    
000E0076  588F                      52      ADDQ.L #4,SP
000E0078  4EF9 00040C1E             53      JMP $40C1E
000E007E                            54  .L40C08
000E007E  0C43 0AB4                 55      CMPI.W #$AB4,D3
000E0082  65F2                      56      BCS .BRATO40C1E            
000E0084                            57  .EXIT        
000E0084  4E75                      58      RTS
000E0086                            59  L40AF2:
000E0086  0C6D 0002 00BE            60      CMPI.W #0002,($BE,A5)
000E008C  660A                      61      BNE.B .EXIT
000E008E  0C40 0AB4                 62      CMPI.W #$AB4,D0
000E0092  6400 0004                 63      BCC .EXIT
000E0096  4E75                      64      RTS        
000E0098                            65  .EXIT
000E0098  588F                      66      ADDQ.L #4,SP
000E009A  4EF9 00040B02             67      JMP $40B02
000E00A0                            68  L3EC7A:
000E00A0  0C6D 0002 00BE            69      CMPI.W #0002,($BE,A5)
000E00A6  6606                      70      BNE.B .EXIT
000E00A8  1B7C 0001 012B            71      MOVE.B  #$1, ($12B,A5)
000E00AE                            72  .EXIT    
000E00AE  4E75                      73      RTS
000E00B0                            74  L3ECBC:
000E00B0  0C6D 0002 00BE            75      CMPI.W #0002,($BE,A5)
000E00B6  6606                      76      BNE.B .EXIT
000E00B8  1B7C 0001 0129            77      MOVE.B  #$1, ($129,A5)
000E00BE                            78  .EXIT    
000E00BE  4E75                      79      RTS
```

Then we can modify the following instructions:

```
03D3B2  jsr     $e0000.l                                    4EB9 000E 0000

03EC7A  jsr     $e00a0.l                                    4EB9 000E 00A0

03ECBC  jsr     $e00b0.l                                    4EB9 000E 00B0

04085E  nop                                                 4E71
040860  jsr     $e0030.l                                    4EB9 000E 0030
040866  nop                                                 4E71

040B02  jsr     $e004e.l                                    4EB9 000E 004E
040B08  addq.b  #1, D6                                      5206

040C02  jsr     $e0066.l                                    4EB9 000E 0066
040C08  nop                                                 4E71
040C0A  nop                                                 4E71
040C0C  nop                                                 4E71

040AF2  jsr     $e0086.l                                    4EB9 000E 0086
040AF8  addq.b  #1, D6                                      5206

```

What we actually did is to modify some critical instructions when Damnd appears on a different stage than **Slum 3**.

0x03D3B2: removed the check with 0xFF8412 value <br>
0x03EC7A: removed the area clear flag, so the enemies won't die automatically after boss death <br>
0x03ECBC: removed the stage clear flag <br>
0x040860: avoid Damnd call for support when energy drop down to a certain value
The remaining addresses are about some checks on position, mostly the margin of Slum 3 ($ab4 - $bf4)  <br>

Finally, let's say we want Damnd to show on all 3 slums stages.

Modify these two address in the following way:

```
06D02C   0070  0230  0040  0400  0000  0000  0000   .p.0.@........

06D0E6   0650  0770  002E  0400  0000  0100  0400   .P.p..........
```

![Slum 2](https://github.com/user-attachments/assets/17e03ed6-7cfd-4af3-85d2-9927d8b7124a)

... yeah, we do have it !

<a id="a-sodom"></a>
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

Like we did for Damnd, we create some routines at a spare ROM space, this time at address 0xE0100

```
000E0100                             7      ORG    $E0100
000E0100                             8  START:   
000E0100                             9  CHECK_FINAL_STAGE:              
000E0100  0C2D 0001 00BE            10      CMPI.B #1,($BE,A5)
000E0106  6606                      11      BNE.B EXIT
000E0108  0C2D 0003 00BF            12      CMPI.B #3,($BF,A5)
000E010E                            13  EXIT:  
000E010E  4E75                      14      RTS    
000E0110                            15  CHECK_MUST_SPAWN:    
000E0110  61EE                      16      BSR.B CHECK_FINAL_STAGE
000E0112  6706                      17      BEQ.B CHECK_POSITION
000E0114                            18  FORCECARRY:
000E0114  0C16 0000                 19      CMPI.B #0,(A6)
000E0118  4E75                      20      RTS  
000E011A                            21  CHECK_POSITION:    
000E011A  0C6D 1300 0412            22      CMPI.W #$1300,($412,A5)    
000E0120  4E75                      23      RTS
000E0122                            24  BOSS_CLEAR_FLAG:
000E0122  61DC                      25      BSR.B CHECK_FINAL_STAGE
000E0124  66E8                      26      BNE.B EXIT
000E0126  1B7C 0001 012B            27      MOVE.B  #$1, ($12B,A5)
000E012C  4E75                      28      RTS
000E012E                            29  STAGE_CLEAR_FLAG:
000E012E  61D0                      30      BSR.B CHECK_FINAL_STAGE
000E0130  66DC                      31      BNE.B EXIT
000E0132  1B7C 0001 0129            32      MOVE.B  #$1, ($129,A5)
000E0138  4E75                      33      RTS
```

Then we can modify the instructions in order to fight Sodom on the subway stage 2 with no bad side effects:

```
040CFA  jsr     $E0110.l                                    4EB9 000E 0110

042600  jsr     $E0122.l                                    4EB9 000E 0122

042698  jsr     $E012e.l                                    4EB9 000E 012E

042ACA  cmpi.w  #$0050, D3                                  0C43 0050
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

First off, if you want to refresh your mind about the below content, take a look at Stage routine chapter.

Now, by placing a breakpoint at 0x614E and taking a look to the register A3, we'll first see the value 0x6308, which is the vector address for the first area; a long-word size after this and then we find the base vector of the 2nd area, which is 0x6D178.
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

<a id="a-edie"></a>
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

We write this code on a spare ROM address (in this example 0xE0200)

```
000E0200                             7      ORG    $E0200
000E0200                             8  START:   
000E0200                             9  CHECK_FINAL_STAGE:              
000E0200  0C2D 0002 00BE            10      CMPI.B #2,($BE,A5)
000E0206  6606                      11      BNE.B EXIT
000E0208  0C2D 0002 00BF            12      CMPI.B #2,($BF,A5)
000E020E                            13  EXIT:  
000E020E  4E75                      14      RTS    
000E0210                            15  BOSS_CLEAR_FLAG:
000E0210  61EE                      16      BSR.B CHECK_FINAL_STAGE
000E0212  66FA                      17      BNE.B EXIT
000E0214  1B7C 0001 012B            18      MOVE.B  #$1, ($12B,A5)
000E021A  4E75                      19      RTS
000E021C                            20  STAGE_CLEAR_FLAG:
000E021C  61E2                      21      BSR.B CHECK_FINAL_STAGE
000E021E  66EE                      22      BNE.B EXIT
000E0220  1B7C 0001 0129            23      MOVE.B  #$1, ($129,A5)
000E0226  4E75                      24      RTS
```

and then we place our routine calls:

```
0476CA  jsr     $E0210.l                                    4EB9 000E 0210

047760  jsr     $E021C.l                                    4EB9 000E 021C
```

![Edi.E](https://github.com/user-attachments/assets/6dfd0edb-c7aa-41fc-b9e8-eb5fc4f892c3)

<a id="a-rolento"></a>
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

As usually, we write a routine for Rolento, this time at address 0xE0300


```
000E0300                             7      ORG    $E0300
000E0300                             8  START:   
000E0300                             9  CHECK_FINAL_STAGE:              
000E0300  0C2D 0003 00BE            10      CMPI.B #3,($BE,A5)
000E0306  6606                      11      BNE.B EXIT
000E0308  0C2D 0001 00BF            12      CMPI.B #1,($BF,A5)
000E030E                            13  EXIT:  
000E030E  4E75                      14      RTS    
000E0310                            15  CHECK_SPAWN:    
000E0310  61EE                      16      BSR.B CHECK_FINAL_STAGE
000E0312  6708                      17      BEQ.B CHECK_POSITION
000E0314                            18  FORCECARRY:
000E0314  0C6D 0000 045C            19      CMPI.W  #$0, ($45C,A5)
000E031A  4E75                      20      RTS  
000E031C                            21  CHECK_POSITION:    
000E031C  0C6D 0AC0 045C            22      CMPI.W  #$AC0, ($45C,A5)    
000E0322  4E75                      23      RTS    
000E0324                            24  BOSS_CLEAR_FLAG:
000E0324  61DA                      25      BSR.B CHECK_FINAL_STAGE
000E0326  66E6                      26      BNE.B EXIT
000E0328  1B7C 0001 012B            27      MOVE.B  #$1, ($12B,A5)
000E032E  4E75                      28      RTS
000E0330                            29  STAGE_CLEAR_FLAG:
000E0330  61CE                      30      BSR.B CHECK_FINAL_STAGE
000E0332  66DA                      31      BNE.B EXIT
000E0334  1B7C 0001 0129            32      MOVE.B  #$1, ($129,A5)
000E033A  4E75                      33      RTS
```

Then we change the check at 0x48AAA so Rolento will immediately spawn when reaching position:

```
 048AAA  jsr     $E0310.l                                    4EB9 000E 0310

 04A252  jsr     $E0324.l                                    4EB9 000E 0324

 04A314  jsr     $E0330.l                                    4EB9 000E 0330
```

As we did for Sodom, we modify the stage data address with this:

```
06D178   0008  007C  0208  5FFE  0002  0130  02D0  0010   ...|.._þ...0.Ð..
```

We change the stage map related to Subway 4 with this:

```
073176   0002  1200  1250  0088  0403  0000  0000  FF01   .....P..........
073186   FFFF  FFFF  FFFF  FFFF  FFFF  FFFF  FFFF  FFFF   ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ
```

![Rolento&Sodom](https://github.com/user-attachments/assets/53173356-4862-451a-8aac-3b18ed7cfeb9)

We can enjoy Rolento & Sodom with 2P mode. We'll see later how to fix Rolento's colors on Palette chapter

<a id="a-abigail"></a>
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
000E0400                             7      ORG    $E0400
000E0400                             8  START:   
000E0400                             9  CHECK_FINAL_STAGE:              
000E0400  0C2D 0004 00BE            10      CMPI.B #4,($BE,A5)
000E0406                            11  EXIT    
000E0406  4E75                      12      RTS    
000E0408                            13  CHECK_SPAWN:    
000E0408  61F6                      14      BSR.B CHECK_FINAL_STAGE
000E040A  6706                      15      BEQ.B CHECK_POSITION
000E040C                            16  FORCECARRY:
000E040C  0C16 0000                 17      CMPI.B #0,(A6)
000E0410  4E75                      18      RTS  
000E0412                            19  CHECK_POSITION:    
000E0412  0C6D 2280 0412            20      CMPI.W #$2280,($412,A5)    
000E0418  4E75                      21      RTS
000E041A                            22  BOSS_CLEAR_FLAG:
000E041A  61E4                      23      BSR.B CHECK_FINAL_STAGE
000E041C  66E8                      24      BNE.B EXIT
000E041E  1B7C 0001 012B            25      MOVE.B  #$1, ($12B,A5)
000E0424  4E75                      26      RTS
000E0426                            27  STAGE_CLEAR_FLAG:
000E0426  61D8                      28      BSR.B CHECK_FINAL_STAGE
000E0428  66DC                      29      BNE.B EXIT
000E042A  1B7C 0001 0129            30      MOVE.B  #$1, ($129,A5)
000E0430  4E75                      31      RTS
```

And then we program the jump routines as follows:

```
 04BE30  jsr     $E0408.l                                    4EB9 000E 0408

 04D404  jsr     $E041a.l                                    4EB9 000E 041A

 04D4E2  jsr     $E0426.l                                    4EB9 000E 0426
```

![Abigail on charge](https://github.com/user-attachments/assets/0ef99122-3366-4975-93f0-6e2c7d92b428)

<a id="a-belger"></a>
### Belger

Last boss will not spawn until we reach the 0xFF8412 match value (horizontal stage position).

```
04EA0A: cmpi.w  #$3240, ($412,A5)			    0C6D 3240 0412
04EA14  move.w  #$3200, ($6,A6)                             3D7C 3200 0006
```

In most of the cases, stage vertical position value (0xFF845C) equals 0, so in order to place Belger on our stage we need to replace this instruction:

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

We can skip that check by simply replacing that bhi with bra (6018) on 0x4F07C and 0x50676, so that we keep Belger stable on the screen.

Finally, we have the instructions for writing the stage / area clear flag

```
04F9B2  move.b  #$1, ($12b,A5)                              1B7C 0001 012B

04FA4E  move.b  #$1, ($129,A5)                              1B7C 0001 0129

04FA38  move.b  #$1, ($129,A5)                              1B7C 0001 0129
```

This is the complete routine if you want to face Belger earlier than expected:

```
000E0500                             7      ORG    $E0500
000E0500                             8  START:   
000E0500                             9  CHECK_FINAL_STAGE:              
000E0500  0C2D 0005 00BE            10      CMPI.B #5,($BE,A5)
000E0506  6606                      11      BNE.B EXIT
000E0508  0C2D 0002 00BF            12      CMPI.B #2,($BF,A5)
000E050E                            13  EXIT:  
000E050E  4E75                      14      RTS    
000E0510                            15  CHECK_MUST_SPAWN:    
000E0510  61EE                      16      BSR.B CHECK_FINAL_STAGE
000E0512  6706                      17      BEQ.B CHECK_POSITION
000E0514                            18  FORCECARRY:
000E0514  0C16 0000                 19      CMPI.B #0,(A6)
000E0518  4E75                      20      RTS  
000E051A                            21  CHECK_POSITION:    
000E051A  0C6D 3240 0412            22      CMPI.W #$3240,($412,A5)    
000E0520  4E75                      23      RTS
000E0522                            24  MOVE_TO_POSITION:
000E0522  61DC                      25      BSR.B CHECK_FINAL_STAGE
000E0524  6712                      26      BEQ.B MOVE_TO_LS_POSITION        
000E0526  2F00                      27      MOVE.L D0,-(SP)
000E0528  302D 0412                 28      MOVE.W ($412,A5),D0
000E052C  0440 0040                 29      SUB.W #$40,D0
000E0530  3D40 0006                 30      MOVE.W D0,($6,A6)
000E0534  201F                      31      MOVE.L (SP)+,D0
000E0536  4E75                      32      RTS    
000E0538                            33  MOVE_TO_LS_POSITION:
000E0538  3D7C 3200 0006            34      MOVE.W #$3200,($6,A6)
000E053E  4E75                      35      RTS
000E0540                            36  CHECK_IS_ON_VCENTRE:
000E0540  61BE                      37      BSR.B CHECK_FINAL_STAGE
000E0542  6706                      38      BEQ.B CHECK_LS_VPOS
000E0544  0440 0010                 39      SUBI.W #$10, D0
000E0548  4E75                      40      RTS
000E054A                            41  CHECK_LS_VPOS:
000E054A  0440 0810                 42      SUBI.W #$810, D0
000E054E  4E75                      43      RTS
000E0550                            44  CHECK_ABOUT_TO_DIE:
000E0550  61AE                      45      BSR.B CHECK_FINAL_STAGE
000E0552  6708                      46      BEQ.B IS_ABOUT_TO_DIE
000E0554  0C6E 0000 0012            47      CMPI.W #$0,($12,A6)
000E055A  4E75                      48      RTS
000E055C                            49  IS_ABOUT_TO_DIE:
000E055C  0C6E 0032 0018            50      CMPI.W #$32,($18,A6)
000E0562  4E75                      51      RTS
000E0564                            52  BOSS_CLEAR_FLAG:
000E0564  619A                      53      BSR.B CHECK_FINAL_STAGE
000E0566  66A6                      54      BNE.B EXIT
000E0568  1B7C 0001 012B            55      MOVE.B  #$1, ($12B,A5)
000E056E  4E75                      56      RTS    
000E0570                            57  STAGE_CLEAR_FLAG:
000E0570  618E                      58      BSR.B CHECK_FINAL_STAGE
000E0572  669A                      59      BNE.B EXIT
000E0574  1B7C 0001 0129            60      MOVE.B  #$1, ($129,A5)
000E057A  4E75                      61      RTS
000E057C                            62  ENDING_SET_FLAG:
000E057C  6182                      63      BSR.B CHECK_FINAL_STAGE
000E057E  668E                      64      BNE.B EXIT
000E0580  1B7C 00FF 0129            65      MOVE.B #$FF, ($129,A5)
000E0586  4E75                      66      RTS    
000E0588                            67        
```

We need to modify these routines as written below:

```
 04EA0A  jsr     $e0510.l                                    4EB9 000E 0510

 04EA14  jsr     $e0522.l                                    4EB9 000E 0522

 04FF3C  jsr     $e0540.l                                    4EB9 000E 0540
 04FF42  nop                                                 4E71

 04F076  jsr     $e0550.l                                    4EB9 000E 0550

 050670  jsr     $e0550.l                                    4EB9 000E 0550

 04F9B2  jsr     $e0564.l                                    4EB9 000E 0564

 04FA4E  jsr     $e0570.l                                    4EB9 000E 0570

 04FA38  jsr     $e0570.l                                    4EB9 000E 0570

 00ED1A  jsr     $e057c.l                                    4EB9 000E 057C
```

![Belger](https://github.com/user-attachments/assets/80641579-2f6a-4fb2-a65a-cceceee29e1d)



