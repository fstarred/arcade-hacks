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
4. [Stage data](#a-stagemap)
   1. [Stage routine](#a-stageroutine)
   2. [Enemy routine](#a-enemyroutine)
   3. [Stage map](#a-stagemap)
   4. [Enemy map](#a-enemymap)
   5. [Stage table reference](#a-stagemapref)
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
9. [Graphics and Palette](#a-palette)
   1. [OBJ and Tiles](#a-tiles)
   2. [GFX RAM](#a-gfxram)
   3. [Colour layout](#a-colours)
   4. [Palette ID extraction routine](#a-paletteidroutine)
   5. [Boss Fix](#a-bosspalette)
   6. [Andore Fix](#a-andorefix)
   7. [Palette restore](#a-palrestore)
11. [Load ROM modification with MAME](#a-howtohack)      


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
O + 0x2F	alternative palette id
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
0x080A = dog
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
## Stage data

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

<a id="a-stagemapref"></a>
### Stage table reference

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
000E0006  6732                      11      BEQ.B .CHECK_POSITION
000E0008  4A2D 00BE                 12      TST.B ($BE,A5)
000E000C  6602                      13      BNE.B .LOAD_PALETTE
000E000E  4E75                      14      RTS
000E0010                            15  .LOAD_PALETTE:
000E0010  48E7 C0C0                 16      MOVEM.L D0-D1/A0-A1,-(SP)
000E0014  7007                      17      MOVEQ #8-1,D0
000E0016  122E 0015                 18      MOVE.B ($15,A6),D1
000E001A  EB59                      19      ROL #5,D1
000E001C  41F9 000C03E0             20      LEA $0C03E0,A0                  ; $0C0000 (SLUM PALETTE) + ($1E*$20)
000E0022  43F9 00914000             21      LEA $914000,A1                  
000E0028  43F1 1000                 22      LEA (A1,D1.W),A1                ; $914000 (PALETTE REGISTER) + ($XX*$20)    
000E002C                            23  .LOOPCOL:
000E002C  22D8                      24      MOVE.L (A0)+,(A1)+
000E002E  51C8 FFFC                 25      DBF D0,.LOOPCOL    
000E0032  4CDF 0303                 26      MOVEM.L (SP)+,D0-D1/A0-A1
000E0036  4A00                      27      TST.B D0                        ; RESET CARRY FLAG
000E0038  4E75                      28      RTS  
000E003A                            29  .CHECK_POSITION:    
000E003A  0C6D 0AA0 0412            30      CMPI.W #$0AA0,($412,A5)        
000E0040  4E75                      31      RTS
000E0042                            32  L40860:
000E0042  6700 000E                 33      BEQ .CHECKENERGY
000E0046  0C6D 0002 00BE            34      CMPI.W #0002,($BE,A5)
000E004C  660A                      35      BNE.B .FORCECARRYFLAG
000E004E  323C 00C8                 36      MOVE.W #$C8,D1
000E0052                            37  .CHECKENERGY    
000E0052  B26E 0018                 38      CMP.W ($18,A6),D1
000E0056  4E75                      39      RTS
000E0058                            40  .FORCECARRYFLAG:
000E0058  0C2E 0005 0012            41      CMPI.B #$5,($12,A6)             ; DEST OPERAND IS ALWAYS $04
000E005E  4E75                      42      RTS
000E0060                            43  L40B02:
000E0060  0C6D 0002 00BE            44      CMPI.W #0002,($BE,A5)
000E0066  6608                      45      BNE.B .EXIT
000E0068  0C40 0BF4                 46      CMPI.W #$BF4,D0
000E006C  6502                      47      BCS.B .EXIT
000E006E  4E75                      48      RTS
000E0070                            49  .EXIT    
000E0070  588F                      50      ADDQ.L #4,SP                    ; RESTORE STACK POINTER
000E0072  4EF9 00040B10             51      JMP $40B10
000E0078                            52  L40C02:
000E0078  0C6D 0002 00BE            53      CMPI.W #0002,($BE,A5)        
000E007E  6616                      54      BNE.B .EXIT
000E0080  0C43 0BF4                 55      CMPI.W #$BF4,D3
000E0084  6500 000A                 56      BCS .L40C08
000E0088                            57  .BRATO40C1E    
000E0088  588F                      58      ADDQ.L #4,SP                    ; RESTORE STACK POINTER
000E008A  4EF9 00040C1E             59      JMP $40C1E
000E0090                            60  .L40C08
000E0090  0C43 0AB4                 61      CMPI.W #$AB4,D3
000E0094  65F2                      62      BCS .BRATO40C1E            
000E0096                            63  .EXIT        
000E0096  4E75                      64      RTS
000E0098                            65  L40AF2:
000E0098  0C6D 0002 00BE            66      CMPI.W #0002,($BE,A5)
000E009E  660A                      67      BNE.B .EXIT
000E00A0  0C40 0AB4                 68      CMPI.W #$AB4,D0
000E00A4  6400 0004                 69      BCC .EXIT
000E00A8  4E75                      70      RTS        
000E00AA                            71  .EXIT
000E00AA  588F                      72      ADDQ.L #4,SP                    ; RESTORE STACK POINTER
000E00AC  4EF9 00040B02             73      JMP $40B02
000E00B2                            74  L3EC7A:
000E00B2  0C6D 0002 00BE            75      CMPI.W #0002,($BE,A5)
000E00B8  6606                      76      BNE.B .EXIT
000E00BA  1B7C 0001 012B            77      MOVE.B  #$1, ($12B,A5)
000E00C0                            78  .EXIT    
000E00C0  4E75                      79      RTS
000E00C2                            80  L3ECBC:
000E00C2  0C6D 0002 00BE            81      CMPI.W #0002,($BE,A5)
000E00C8  6606                      82      BNE.B .EXIT
000E00CA  1B7C 0001 0129            83      MOVE.B  #$1, ($129,A5)
000E00D0                            84  .EXIT    
000E00D0  4E75                      85      RTS
```

Then we can modify the following instructions:

```
03D3B2  jsr     $e0000.l                                    4EB9 000E 0000

03EC7A  jsr     $e00b2.l                                    4EB9 000E 00B2

03ECBC  jsr     $e00c2.l                                    4EB9 000E 00C2

04085E  nop                                                 4E71
040860  jsr     $e0042.l                                    4EB9 000E 0042
040866  nop                                                 4E71

040B02  jsr     $e0060.l                                    4EB9 000E 0060
040B08  addq.b  #1, D6                                      5206

040C02  jsr     $e0078.l                                    4EB9 000E 0078
040C08  nop                                                 4E71
040C0A  nop                                                 4E71
040C0C  nop                                                 4E71

040AF2  jsr     $e0098.l                                    4EB9 000E 0098
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
040CD8  move.b  #$5, ($13,A4)                               197C 0005 0013		; crowd sound / animation
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
000E0100                             9  L40CFA:            
000E0100  0C6D 0103 00BE            10      CMPI.W #$0103,($BE,A5)    
000E0106  6734                      11      BEQ.B .CHECK_POSITION
000E0108  0C2D 0001 00BE            12      CMPI.B #$01,($BE,A5)
000E010E  6602                      13      BNE.B .LOAD_PALETTE
000E0110  4E75                      14      RTS    
000E0112                            15  .LOAD_PALETTE:
000E0112  48E7 C0C0                 16      MOVEM.L D0-D1/A0-A1,-(SP)
000E0116  7007                      17      MOVEQ #8-1,D0
000E0118  122E 0015                 18      MOVE.B ($15,A6),D1
000E011C  EB59                      19      ROL #5,D1
000E011E  41F9 000C07E0             20      LEA $0C07E0,A0                  ; $0C0400 (SUBWAY PALETTE) + ($1E*$20)
000E0124  43F9 00914000             21      LEA $914000,A1                  
000E012A  43F1 1000                 22      LEA (A1,D1.W),A1                ; $914000 (PALETTE REGISTER) + ($XX*$20)    
000E012E                            23  .LOOPCOL:
000E012E  22D8                      24      MOVE.L (A0)+,(A1)+
000E0130  51C8 FFFC                 25      DBF D0,.LOOPCOL    
000E0134  4CDF 0303                 26      MOVEM.L (SP)+,D0-D1/A0-A1
000E0138  4A00                      27      TST.B D0                        ; RESET CARRY FLAG
000E013A  4E75                      28      RTS      
000E013C                            29  .CHECK_POSITION:    
000E013C  0C6D 1300 0412            30      CMPI.W #$1300,($412,A5)    
000E0142  4E75                      31      RTS
000E0144                            32  L42ACA:
000E0144  0C6D 0103 00BE            33      CMPI.W #$0103,($BE,A5)
000E014A  6614                      34      BNE.B .EXIT
000E014C  0C43 1200                 35      CMPI.W #$1200,D3
000E0150  6408                      36      BCC.B .L42AD0
000E0152                            37  .BRATO42ADC    
000E0152  588F                      38      ADDQ.L #4,SP
000E0154  4EF9 00042ADC             39      JMP $42ADC
000E015A                            40  .L42AD0:
000E015A  0C43 14E0                 41      CMPI.W #$14E0,D3
000E015E  64F2                      42      BCC.B .BRATO42ADC
000E0160                            43  .EXIT    
000E0160  4E75                      44      RTS
000E0162                            45  L40CD8:
000E0162  0C6D 0103 00BE            46      CMPI.W #$0103,($BE,A5)
000E0168  6608                      47      BNE.B .MOD
000E016A  197C 0005 0013            48      MOVE.B #$5,($13,A4)
000E0170  4E75                      49      RTS
000E0172                            50  .MOD    
000E0172  197C 0001 0013            51      MOVE.B #$1,($13,A4)
000E0178  4E75                      52      RTS        
000E017A                            53  L42600:
000E017A  0C6D 0103 00BE            54      CMPI.W #$0103,($BE,A5)
000E0180  6606                      55      BNE.B .EXIT
000E0182  1B7C 0001 012B            56      MOVE.B  #$1, ($12B,A5)
000E0188                            57  .EXIT    
000E0188  4E75                      58      RTS
000E018A                            59  L42698:
000E018A  0C6D 0103 00BE            60      CMPI.W #$0103,($BE,A5)
000E0190  6606                      61      BNE.B .EXIT
000E0192  1B7C 0001 0129            62      MOVE.B  #$1, ($129,A5)
000E0198                            63  .EXIT    
000E0198  4E75                      64      RTS
```

Then we can modify the instructions in order to fight Sodom on the subway stage 2 with no bad side effects:

```
040CD8  jsr     $e0162.l                                    4EB9 000E 0162

040CFA  jsr     $e0100.l                                    4EB9 000E 0100

042600  jsr     $e017a.l                                    4EB9 000E 017A

042698  jsr     $e018a.l                                    4EB9 000E 018A

042ACA  jsr     $e0144.l                                    4EB9 000E 0144
042AD0  nop                                                 4E71
042AD2  nop                                                 4E71
042AD4  nop                                                 4E71
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

but we can ignore this and focus to the flags above so they are enabled only on the last stage.

We write this code on a spare ROM address (in this example 0xE0200)

```
000E0200                             7      ORG    $E0200
000E0200                             8  START:   
000E0200                             9  L45FCC:
000E0200  1D7C 005A 001E            10      MOVE.B #$5A,($1E,A6)
000E0206  0C2D 0002 00BE            11      CMPI.B #$02,($BE,A5)
000E020C  6726                      12      BEQ.B .EXIT
000E020E                            13  .LOAD_PALETTE:
000E020E  48E7 C0C0                 14      MOVEM.L D0-D1/A0-A1,-(SP)
000E0212  7007                      15      MOVEQ #8-1,D0
000E0214  122E 0015                 16      MOVE.B ($15,A6),D1
000E0218  EB59                      17      ROL #5,D1
000E021A  41F9 000C0BE0             18      LEA $0C0BE0,A0                  ; $0C0800 (SUBWAY PALETTE) + ($1F*$20)
000E0220  43F9 00914000             19      LEA $914000,A1                  
000E0226  43F1 1000                 20      LEA (A1,D1.W),A1                ; $914000 (PALETTE REGISTER) + ($XX*$20)    
000E022A                            21  .LOOPCOL:
000E022A  22D8                      22      MOVE.L (A0)+,(A1)+
000E022C  51C8 FFFC                 23      DBF D0,.LOOPCOL    
000E0230  4CDF 0303                 24      MOVEM.L (SP)+,D0-D1/A0-A1
000E0234                            25  .EXIT                       
000E0234  4E75                      26      RTS      
000E0236                            27  L476CA:
000E0236  0C6D 00CA 00BE            28      CMPI.W #0202,($BE,A5)
000E023C  6606                      29      BNE.B .EXIT
000E023E  1B7C 0001 012B            30      MOVE.B  #$1, ($12B,A5)
000E0244                            31  .EXIT    
000E0244  4E75                      32      RTS
000E0246                            33  L47760:
000E0246  0C6D 00CA 00BE            34      CMPI.W #0202,($BE,A5)
000E024C  6606                      35      BNE.B .EXIT
000E024E  1B7C 0001 0129            36      MOVE.B  #$1, ($129,A5)
000E0254                            37  .EXIT    
000E0254  4E75                      38      RTS
```

and then we place our routine calls:

```
045FCC  jsr     $e0200.l                                    4EB9 000E 0200

0476CA  jsr     $e0236.l                                    4EB9 000E 0236

047760  jsr     $e0246.l                                    4EB9 000E 0246
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
000E0300                             9  L48AAA:              
000E0300  0C6D 012D 00BE            10      CMPI.W #0301,($BE,A5)
000E0306  6734                      11      BEQ.B .CHECK_POSITION
000E0308  0C2D 0003 00BE            12      CMPI.B #03,($BE,A5)
000E030E  6602                      13      BNE.B .LOAD_PALETTE
000E0310  4E75                      14      RTS
000E0312                            15  .LOAD_PALETTE:
000E0312  48E7 C0C0                 16      MOVEM.L D0-D1/A0-A1,-(SP)
000E0316  7007                      17      MOVEQ #8-1,D0
000E0318  122E 0015                 18      MOVE.B ($15,A6),D1
000E031C  EB59                      19      ROL #5,D1
000E031E  41F9 000C0FE0             20      LEA $0C0FE0,A0                  ; $0C0C00 (IND. AREA PALETTE) + ($1F*$20)
000E0324  43F9 00914000             21      LEA $914000,A1                  
000E032A  43F1 1000                 22      LEA (A1,D1.W),A1                ; $914000 (PALETTE REGISTER) + ($XX*$20)    
000E032E                            23  .LOOPCOL:
000E032E  22D8                      24      MOVE.L (A0)+,(A1)+
000E0330  51C8 FFFC                 25      DBF D0,.LOOPCOL    
000E0334  4CDF 0303                 26      MOVEM.L (SP)+,D0-D1/A0-A1
000E0338  4A00                      27      TST.B D0                        ; RESET CARRY FLAG
000E033A  4E75                      28      RTS  
000E033C                            29  .CHECK_POSITION:    
000E033C  0C6D 0AC0 045C            30      CMPI.W  #$AC0, ($45C,A5)    
000E0342  4E75                      31      RTS    
000E0344                            32  L4A252:
000E0344  0C6D 012D 00BE            33      CMPI.W #0301,($BE,A5)
000E034A  6606                      34      BNE.B .EXIT
000E034C  1B7C 0001 012B            35      MOVE.B  #$1, ($12B,A5)
000E0352                            36  .EXIT    
000E0352  4E75                      37      RTS
000E0354                            38  L4A314:
000E0354  0C6D 012D 00BE            39      CMPI.W #0301,($BE,A5)
000E035A  6606                      40      BNE.B .EXIT
000E035C  1B7C 0001 0129            41      MOVE.B  #$1, ($129,A5)
000E0362                            42  .EXIT    
000E0362  4E75                      43      RTS
```

Then we change the check at 0x48AAA so Rolento will immediately spawn when reaching position:

```
 048AAA  jsr     $E0300.l                                    4EB9 000E 0300

 04A252  jsr     $E0344.l                                    4EB9 000E 0344

 04A314  jsr     $E0354.l                                    4EB9 000E 0354
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

<a id="a-palette"></a>
## Graphics and palette

If you've come this far with reading, you may have noticed that bosses were tested on their own area.<br>
The main reason behind that is simple, the hack scripts we have seen in the chapters above cover some modification on the character behaviour in order to work on many scenarios as possible, but if you place, for instance, Sodom on the slum stage you'll see that colors are pretty messed up:

<img width="384" height="224" alt="0619" src="https://github.com/user-attachments/assets/4e8e370a-c52d-42a0-a91f-16efad81d116" />

The reason behind Sodom's wrong colours is pretty simple, the character is actually using Damnd's palette.

In order to understand how this is possible, let's do a bit of explanation about how CPS-1 OBJ sprites work.

<a id="a-tiles"></a>
### OBJ and Tiles

OBJ are basically the graphics that stands in front of the other layers, such as enemies, main characters or breakable objects.<br>
All graphics data on CPS-1 is composed by tiles, and their size can vary according to the layer type: OBJ use 16x16 pixels. <br>

OBJ can be displayed in Sprite/Shape mode:<br>
While the first one requires less instructions to draw, it is often inefficient in terms of memory, so the latter mode was mostly used on CPS1.<br>

On Shape mode every tile needs to be specified, so it allows the graphics to be more dynamic in terms of space and palette.

Now we take a look at OBJ layout:

```
OBJ entry layout : xxxx yyyy nnnn aaaa
xxxx = x position ( origin upper left )
yyyy = y position ( origin upper left )
nnnn = tile ID
aaaa = attribute word

// OBJ attribute WORD layout
0 b00000000_00011111 Palette ID
0 b00000000_00100000 X Flip
0 b00000000_01000000 Y Flip
0 b00000000_10000000 Unused
0 b00001111_00000000 X sprite size ( in tiles )
0 b11110000_00000000 Y sprite size ( in tiles )
```

We now realize that a single OBJ entry is formed by 8 bytes, like this: 

```
008F  00B4  0268  0000
```

we also know the palette id information is included in the last 5 bites of the attribute word, which are the OBJ's tile entry last 2 bytes.

<a id="a-gfxram"></a>
### GFX RAM

GFX RAM range is between address 0x900000-0x92FFFF (192 KiB); in order to draw objects on the screen we have to write data here.

In order to understand where exactly the data is poked for the different layers, let's take a look to the CPS-A register list:<br>

```
OBJ base 		0x00 OBJ GFXRAM absolute address
SCROLL1 base 		0x02 SCROLL1 GFXRAM absolute address
SCROLL2 base 		0x04 SCROLL2 GFXRAM absolute address
SCROLL3 base 		0x06 SCROLL3 GFXRAM absolute address
Rowscroll base 		0x08 Rowscroll GFXRAM absolute address
Palette base 		0x0A Palettes GFXRAM absolute address
Scroll 1 X 		0x0C SCROLL1 Offset X
Scroll 1 Y 		0x0E SCROLL1 Offset Y
Scroll 2 X 		0x10 SCROLL2 Offset X
Scroll 2 Y 		0x12 SCROLL2 Offset Y
Scroll 3 X 		0x14 SCROLL3 Offset X
Scroll 3 Y 		0x16 SCROLL3 Offset Y
Star1 X 		0x18 STAR1 Offset X
Star1 Y 		0x1A STAR1 Offset Y
Star2 X 		0x1C STAR2 Offset X
Star2 Y 		0x1E STAR2 Offset Y
Rowscroll Offsets 	0x20 Offsets into Rowscroll base
Video Control 		0x22 flip screen, rowscroll enable
```


On Final Fight we have a situation like this (consider some registers may vary during the gameplay):

```
00   9000  9080  90C0  9100  9100  9140  0000  0000   .....À.....@....
10   007B  0300  FFD6  0620  0000  0100  0000  0100   .{..ÿÖ. ........
20   0000  000E  0000  0000  0000  0000  0000  0000   ................
30   0000  0000  0000  0000  0000  0000  0000  0000   ................
```

The above register values have to be converted as 24 bit address; by shifting the first value 0x9000 by 8 we obtain 0x900000.<br>

This means that, in order to draw OBJ kind objects to the screen, we want to write values in memory between 0x900000 and 0x908000.<br>

The below data is a snapshot of OBJ base memory taken from Subway 4 (the Sodom stage), with Guy and Sodom displaying on the screen:

```
900000   008F  00B4  0268  0000  009F  00B4  0269  0000   ...´.h.....´.i..
900010   00AF  00B4  026A  0000  007F  00C4  0280  0000   .¯.´.j.....Ä....
900020   008F  00C4  0281  0000  009F  00C4  0282  0000   ...Ä.......Ä....
900030   00AF  00C4  0283  0000  00BF  00C4  0284  0000   .¯.Ä.....¿.Ä....
900040   00CF  00C4  0285  0000  00DF  00C4  0286  0000   .Ï.Ä.....ß.Ä....
900050   00EF  00C4  0287  0000  008F  00D4  0291  0000   .ï.Ä.......Ô....
900060   009F  00D4  0292  0000  00AF  00D4  0293  0000   ...Ô.....¯.Ô....
900070   00BF  00D4  0294  0000  0163  0060  1D98  0023   .¿.Ô.....c.`...#
900080   0153  0060  1D99  0023  0143  0060  1D9A  0023   .S.`...#.C.`...#
900090   0133  0060  1D9B  0023  0123  0060  1D9C  0023   .3.`...#.#.`...#
9000A0   0113  0060  1D9D  0023  0133  0090  1DBA  0023   ...`...#.3...º.#
9000B0   0153  00A0  1DC8  0023  0143  00A0  1DC9  0023   .S. .È.#.C. .É.#
9000C0   0133  00A0  1DCA  0023  0163  00B0  1DDA  0023   .3. .Ê.#.c.°.Ú.#
9000D0   0153  00B0  1DD8  0023  0143  00B0  1DD9  0023   .S.°.Ø.#.C.°.Ù.#
9000E0   0143  0060  1C01  003F  0133  0060  1C02  003F   .C.`...?.3.`...?
9000F0   0123  0060  1C05  003F  0153  0070  1C10  003F   .#.`...?.S.p...?
900100   0143  0070  1C11  003F  0133  0070  1C12  003F   .C.p...?.3.p...?
900110   0123  0070  1C15  003F  0153  0080  1C20  003F   .#.p...?.S... .?
900120   0143  0080  1C21  003F  0133  0080  1C22  003F   .C...!.?.3...".?
900130   0123  0080  1C25  003F  0153  0090  1E61  003F   .#...%.?.S...a.?
900140   0143  0090  1C31  003F  0133  0090  1C32  003F   .C...1.?.3...2.?
900150   0163  00A0  1C0A  003F  0153  00A0  1C0B  003F   .c. ...?.S. ...?
900160   0143  00A0  1C0C  003F  0133  00A0  1CD7  003F   .C. ...?.3. .×.?
900170   0163  00B0  1C1A  003F  0153  00B0  1C1B  003F   .c.°...?.S.°...?
900180   0143  00B0  1C1C  003F  0133  00B0  1C1D  003F   .C.°...?.3.°...?
900190   0173  00C0  11D8  003F  0163  00C0  11C8  003F   .s.À.Ø.?.c.À.È.?
9001A0   0153  00C0  1C2B  003F  0143  00C0  1C2C  003F   .S.À.+.?.C.À.,.?
9001B0   0133  00C0  1C2D  003F  0173  00D0  11FB  003F   .3.À.-.?.s.Ð.û.?
9001C0   0163  00D0  11FC  003F  0153  00D0  11FD  003F   .c.Ð.ü.?.S.Ð.ý.?
9001D0   0143  00D0  11FE  003F  0133  00D0  11FF  003F   .C.Ð.þ.?.3.Ð.ÿ.?
9001E0   0000  0000  0000  0000  0000  0000  0000  0000   ................
```

This is, for instance, a tile drawn on the screen:

```
900000   008F  00B4  0268  0000
```

By comparing the OBJ entry layout with this data we notice the palette ID equals ID 0.<br>

Each graphic layer can dispose of 32 palette, so possibile values are within **0x00** and **0x1F**.<br>

If we look back at address **0x0A** of **CPS-A register**, we can see the value of **0x9140**; by shifting again the value by << 8, 
we get **0x914000** address, which is where all set of OBJ palette are stored; notice that the values can be programmatically changed. <br>

<a id="a-colours"></a>
### Colour layout

The CPS-1 colour is a 16 bit entry composed by RGB values (each of 4 bit) and 4 bit (the MSB) dedicated to the brightness, therefore a total of 65536 available value.<br> 
Every palette set is composed by 32 (0x20) colour entries.<br>


| Brightness | Red  | Green | Blue |
| ---------- | ---- | ----- | ---- |
|    1111    | 1111 | 1111  | 1111 |
|    0x0F    | 0x0F | 0x0F  | 0x0F |

Let's have a practical example by showing the first 3 palette entries while playing the game:

```
914000   F111  FEDB  FECA  FCA8  FA86  F865  F630  FEA0   ñ.þÛþÊü¨ú.øeö0þ 
914010   FEEE  FE80  FE60  FC50  FA40  F840  F740  F000   þîþ.þ`üPú@ø@÷@ð.
914020   F553  FFDA  FFB8  FD97  FB75  F740  FFFF  FAA9   õSÿÚÿ¸ý.ûu÷@ÿÿú©
914030   FDDC  F9EF  F0AD  F079  F057  F000  F776  F000   ýÜùïð-ðyðWð.÷vð.
914040   F111  FFDA  FEB8  FC97  FA75  F964  F850  F740   ñ.ÿÚþ¸ü.úuùdøP÷@
914050   F530  F870  F760  F650  F540  F430  F320  F000   õ0øp÷`öPõ@ô0ó ð.
```

The above are the palette set dedicated for Guy (914000-914020), Cody (914020-914040) and Haggar (914040-914060).<br>

Notice that, despite on shape mode it is possible to set a specific palette ID for each tile, and a graphic object is typically formed by more tiles, luckily - at least for Final Fight - basically all characters use only one palette (there are just a few exceptions like Sodom handling swords on his hands)

Now we can have some fun; we could, for instance, switch **red** and **blue** values of Guy's palette so we achieve this result:

```
914000   F111  FEDB  FECA  FCA8  FA86  F865  F036  F0AE   ñ.þÛþÊü¨ú.øeð6ð®
914010   FEEE  F08E  F06E  F05C  F04A  F048  F047  F000   þîð.ðnð\ðJðHðGð.
```

<img width="384" height="224" alt="0004" src="https://github.com/user-attachments/assets/078ad4e4-b514-453f-b271-4147968722b4" />

Now that we better understand how CPS-1 palette works, we can back to OBJ base address 0x910000, and see what happen when a boss character display on the screen:<br>
We'll notice that basically all tiles (or almost all of them, as early said) point to palette **0x1F**.<br> 

Remember that palette ID is composed by 5 bits so, if you see values like 0x3F, it's because the tile is using the flip-x attribute; you have to ANDize it by #$1F to actually obtain the palette id value.<br>

Final Fight usually reload the palette set when entering a new area level with loading the new content from a specific ROM address.<br>

The routine that refresh the palette according to the area is the following:

```
06451A  moveq   #$0, D0                                     7000
06451C  move.b  ($be,A5), D0                                102D 00BE		; get area value
064520  add.w   D0, D0                                      D040
064522  add.w   D0, D0                                      D040		; multiply area value by 4
064524  lea     ($64536,PC), A0                             41FA 0010		; palette vector base address
064528  movea.l (A0,D0.w), A0                               2070 0000
06452C  lea     $914000.l, A1                               43F9 0091 4000
064532  bra     $6468c                                      6000 0158
...
06468C  move.w  #$1f, D7                                    3E3C 001F
064690  movem.l (A0)+, D0-D6/A2                             4CD8 047F
064694  movem.l D0-D6/A2, (A1)                              48D1 047F
064698  lea     ($20,A1), A1                                43E9 0020
06469C  dbra    D7, $64690                                  51CF FFF2
0646A0  rts                                                 4E75
```

So we can easily guess that by multiplying the area value (0xFF80BE, see also the table at [Area/Stage sequence chapter](#a-stageseq)) by 4 and adding 0x64536, we obtain the palette source address.<br>

This is the content of vector base address:
  
```
064536   000C  0000  000C  0400  000C  0800  000C  0C00   ................
064546   000C  1000  000C  1400  000C  1800  000C  1C00   ................
064556   000C  2000  000C  2400  41F9  000C  2800  43F9   .. ...$.Aù..(.Cù
```

There is also a routine called everytime the scene fade out and in, located at address **0x0027B8**.<br>

<a id="a-paletteidroutine"></a>
### Palette ID extraction routine

This is the most often called routine, used to extract the palette id for each engaged OBJ-kind object:

```
 016904  move.w  ($a,A1), D6                                 3C29 000A
 016908  tst.b   ($2f,A0)                                    4A28 002F
 01690C  beq     $1691c                                      670E
 01690E  move.b  ($2f,A0), D3                                1628 002F
 016912  andi.w  #$1f, D3                                    0243 001F
 016916  andi.w  #$ffe0, D6                                  0246 FFE0
 01691A  or.w    D3, D6                                      8C43
 01691C  cmpi.w  #$100, D6                                   0C46 0100
 016920  bcc     $1694e                                      6400 002C
 016924  move.b  ($0,A1), D0                                 1029 0000
 016928  ext.w   D0                                          4880
 01692A  movea.l ($6,PC,D0.w), A4                            287B 0006
 01692E  jmp     (A4)                                        4ED4
```

By placing a breakpoint at 0x01692E we can obtain the OBJ dedicated palette ID by having a look at register A0 - which is pointing at object's memory placement, for example 0xFF8568 for player 1 - and register D6, which contains the palette ID value.<br>

Notice that some characters (i.e. Andore variations starting from 2) have set a specific palette ID on OBJ memory's placement at offset + 0x2F.<br>

Therefore, for such specific cases, program takes the palette ID value at O + 0x2F as good with combining it (OR.W D3,D6) with the remaining attributes originally set on register D6.

The scene below show F.Andore, a character who has a dedicated palette specifically loaded at West Side 2 area; by applying an  hack I wrote that we'll see later, we can now display his colours correctly at any stage/area.

<img width="384" height="224" alt="0044" src="https://github.com/user-attachments/assets/ef6b0a6d-6d3e-4fe9-a524-28d4719cd0fa" />

<a id="a-bosspalette"></a>
### Boss fix

On previous chapters we read about the palette ID 0x1F that is used for all bosses, and the palette routine located at address 0x016904.<br>

My idea for fixing the wrong palette boss issue is based to these actions:

1. Check if the boss is on it's dedicated area (i.e. Damnd's area is Slum, Sodom has the Subway)
2. If not, load the palette from his specific address. For example, Damnd's palette is at 0XC0000 + (0x1F * 0x20) = 0XC03E0. Otherwise, do nothing and let us the default palette I'd 0x1F.
3. We use the byte value dedicated for the initial pose, which is actually unused for  boss character, as the palette ID to use in place of 0x1F. The palette loaded at point 2 will be so stored at location 0x914000 + (paletteID * 0x20); we have obviously to take care of not choosing a palette used by other OBJs in the stage, otherwise we'll screw up everything :)
4. Hack the OBJ palette ID extraction routines in order to change the original value 0x1F with ours. 

Here is the hack snippet code for Sodom:

```
    CMPI.B #$01,($BE,A5)
    BNE.B .LOAD_PALETTE
    RTS    
.LOAD_PALETTE:
    MOVEM.L D0-D1/A0-A1,-(SP)
    MOVEQ #8-1,D0
    MOVE.B ($15,A6),D1
    LSL #5,D1
    LEA $0C07E0,A0                  ; $0C0400 (SUBWAY PALETTE) + ($1E*$20)
    LEA $914000,A1                  
    LEA (A1,D1.W),A1                ; $914000 (PALETTE REGISTER) + ($XX*$20)    
.LOOPCOL:
    MOVE.L (A0)+,(A1)+
    DBF D0,.LOOPCOL    
    MOVEM.L (SP)+,D0-D1/A0-A1
```

Notice the _MOVE.B ($15,A6),D1_ instruction take the initial pose value at O + 15 and use it in combination with the base address 0x914000 to reload the palette.

Here is the complete hack script for the palette routines

```
000E0600                             7      ORG    $E0600
000E0600                             8  START:                  ; first instruction of program
000E0600                             9  
000E0600                            10  * Put program code here
000E0600                            11  
000E0600                            12  L16904:
000E0600  0C28 0004 0012            13      CMP.B #04,($12,A0)      ; CHECK IF BOSS CHARACTER
000E0606  662C                      14      BNE.B .ORIGINAL
000E0608  1C28 0013                 15      MOVE.B ($13,A0),D6      
000E060C  BC2D 00BE                 16      CMP.B ($BE,A5),D6       ; CHECK IF SAME BOSS AREA
000E0610  6722                      17      BEQ.B .ORIGINAL
000E0612  3C29 000A                 18      MOVE.W ($A,A1),D6
000E0616  BC3C 001F                 19      CMP.B #$1F,D6           
000E061A  651C                      20      BCS.B .EXIT             ; IF VAL < $1F EXIT
000E061C  0206 001F                 21      ANDI.B #$1F,D6
000E0620  0C06 001F                 22      CMPI.B #$1F,D6          
000E0624  660E                      23      BNE.B .ORIGINAL         ; IF VAL AND $1F != $1F EXEC ORIGINAL AND EXIT
000E0626  3C29 000A                 24      MOVE.W ($A,A1),D6       
000E062A                            25  .GET_CUSTOM:    
000E062A  0206 00E0                 26      ANDI.B #$E0,D6          ; KEEP ALL ATTRIBUTES BUT PALETTE
000E062E  8C28 0015                 27      OR.B ($15,A0),D6
000E0632  6004                      28      BRA.B .EXIT
000E0634                            29  .ORIGINAL
000E0634  3C29 000A                 30      MOVE.W ($A,A1),D6
000E0638                            31  .EXIT    
000E0638  4A28 002F                 32      TST.B ($2F,A0)
000E063C  4E75                      33      RTS    
000E063E                            34  L16B40:                     ; DAMND
000E063E  0C28 0004 0012            35      CMP.B #04,($12,A0)      ; CHECK IF BOSS CHARACTER
000E0644  6616                      36      BNE.B .ORIGINAL
000E0646  1C28 0013                 37      MOVE.B ($13,A0),D6      
000E064A  BC2D 00BE                 38      CMP.B ($BE,A5),D6       ; CHECK IF SAME BOSS AREA
000E064E  670C                      39      BEQ.B .ORIGINAL
000E0650  3C19                      40      MOVE.W (A1)+,D6
000E0652  0206 00E0                 41      ANDI.B #$E0,D6          ; KEEP ALL ATTRIBUTES BUT PALETTE
000E0656  8C28 0015                 42      OR.B ($15,A0),D6
000E065A  6002                      43      BRA.B .EXIT
000E065C                            44  .ORIGINAL
000E065C  3C19                      45      MOVE.W (A1)+,D6       
000E065E                            46  .EXIT    
000E065E  0A46 0020                 47      EORI.W #$20,D6        
000E0662  4E75                      48      RTS
000E0664                            49  L16AA2:                     ; DAMND
000E0664  3F00                      50      MOVE.W D0,-(SP)
000E0666  0C28 0004 0012            51      CMP.B #04,($12,A0)      ; CHECK IF BOSS CHARACTER
000E066C  6618                      52      BNE.B .ORIGINAL    
000E066E  1028 0013                 53      MOVE.B ($13,A0),D0
000E0672  B02D 00BE                 54      CMP.B ($BE,A5),D0       ; CHECK IF SAME BOSS AREA
000E0676  670E                      55      BEQ.B .ORIGINAL
000E0678  3019                      56      MOVE.W (A1)+,D0
000E067A  0200 00E0                 57      ANDI.B #$E0,D0          ; KEEP ALL ATTRIBUTES BUT PALETTE
000E067E  8028 0015                 58      OR.B ($15,A0),D0
000E0682  3CC0                      59      MOVE.W D0,(A6)+        
000E0684  6002                      60      BRA.B .EXIT        
000E0686                            61  .ORIGINAL
000E0686  3CD9                      62      MOVE.W  (A1)+,(A6)+    
000E0688                            63  .EXIT
000E0688  301F                      64      MOVE.W (SP)+,D0
000E068A  D65A                      65      ADD.W   (A2)+, D3
000E068C  D85A                      66      ADD.W   (A2)+, D4
000E068E  4E75                      67      RTS            
000E0690                            68  L16D44_16D18:               ; SODOM
000E0690  0C28 0004 0012            69      CMP.B #04,($12,A0)      ; CHECK IF BOSS CHARACTER
000E0696  6616                      70      BNE.B .ORIGINAL    
000E0698  1C28 0013                 71      MOVE.B ($13,A0),D6      
000E069C  BC2D 00BE                 72      CMP.B ($BE,A5),D6       ; CHECK IF SAME BOSS AREA
000E06A0  670C                      73      BEQ.B .ORIGINAL
000E06A2  3C1A                      74      MOVE.W  (A2)+, D6
000E06A4  0206 00E0                 75      ANDI.B #$E0,D6
000E06A8  8C28 0015                 76      OR.B ($15,A0),D6
000E06AC  6002                      77      BRA.B .EXIT
000E06AE                            78  .ORIGINAL
000E06AE  3C1A                      79      MOVE.W  (A2)+, D6
000E06B0                            80  .EXIT    
000E06B0  0A46 0020                 81      EORI.W  #$20, D6
000E06B4  4E75                      82      RTS
000E06B6                            83  L16C96:                     ; SODOM
000E06B6  610E                      84      BSR.B SHARED_1
000E06B8  4EF9 00016C86             85      JMP $16C86      
000E06BE                            86  L16CBE:                     ; SODOM
000E06BE  6106                      87      BSR.B SHARED_1
000E06C0  4EF9 00016CAE             88      JMP $16CAE      
000E06C6                            89  SHARED_1:
000E06C6  0C28 0004 0012            90      CMP.B #04,($12,A0)      ; CHECK IF BOSS CHARACTER
000E06CC  6616                      91      BNE.B .ORIGINAL  
000E06CE  1C28 0013                 92      MOVE.B ($13,A0),D6      
000E06D2  BC2D 00BE                 93      CMP.B ($BE,A5),D6       ; CHECK IF SAME BOSS AREA
000E06D6  670C                      94      BEQ.B .ORIGINAL         
000E06D8  3C1A                      95      MOVE.W  (A2)+, D6
000E06DA  0206 00E0                 96      ANDI.B #$E0,D6
000E06DE  8C28 0015                 97      OR.B ($15,A0),D6
000E06E2  6002                      98      BRA.B .EXIT
000E06E4                            99  .ORIGINAL
000E06E4  3C1A                     100      MOVE.W  (A2)+, D6
000E06E6                           101  .EXIT        
000E06E6  2452                     102      MOVEA.L  (A2),A2        
000E06E8  4E75                     103      RTS
000E06EA                           104  * Put variables and constants here
000E06EA                           105  
000E06EA                           106      END    START        ; last line of source
```

Then we program the jump as follow:

```
016904  jsr     $e0600.l                                    4EB9 000E 0600
01690A  nop                                                 4E71

016AA2  jsr     $e0664.l                                    4EB9 000E 0664

016B40  jsr     $e063e.l                                    4EB9 000E 063E

016C96  jmp     $e06b6.l                                    4EF9 000E 06B6

016CBE  jmp     $e06be.l                                    4EF9 000E 06BE

016D18  jsr     $e0690.l                                    4EB9 000E 0690

016D44  jsr     $e0690.l                                    4EB9 000E 0690
```

In addition to the 0x16904 routine, we had also to change other routines called specifically for Damnd, Sodom, etc.

Time to modify the Slum 1 stage map in order to place Sodom and use the palette ID 0x1D.

```
   06D02C   0070  0210  0040  0401  001D  0000  5000   .p...@......P.
```

we can safely use the palette ID 0x1D/0x1E, as are not used, at least for this stage.

After loading sodom and palette hack, we can now enjoy Sodom annoying us at Slum with his correct set of colours:

<img width="384" height="224" alt="0049" src="https://github.com/user-attachments/assets/2061af45-b4ff-4c8c-803d-3120dab9f72b" />

<a id="a-andorefix"></a>
### Andore fix

Andore's characters consists of such five variations; last 3 of them get their palette ID from the character's memory O + 0x2F.

```
02 03 02 = g.andore - palette ID 0x12
02 03 03 = u.andore - palette ID 0x13
02 03 04 = f.andore - palette ID 0x14
```

These palette IDs are normally used for G.Oriber and his variations (i.e. Bill Bull, Wong Who).<br>

The only scene when this palette needs to be reloaded for the Andore's is West Side, the twin stage.<br>
On that situation, as the stage initialize, the 3 palette's content refresh their content getting the required 96 bytes (0x60) from source location 0xE568.<br>

Therefore, in order to display the correct colours for Andore also on the other stages, we need to refresh the palette as well.<br>

Since the initial pose byte is used this time, I chose to use a different approach and take advantage of the O + 0x2F byte, already used for the extraction of the palette ID at routine 0x016904 (we already talk about that on the chapters above) and set it with my choosen palette.<br>

The only issue is that we actually don't have a spare byte available either on stage and enemy data mapping, as all of them are used.<br>

After some investigations I decided to use the byte that is used at character's memory offset + 0x62.<br>

It is not clear to me what's the purpose of this byte, by the way it seems everything works fine, more or less.<br>

So the steps for the Andore's palette hack are basically these:

1. When initializing the character, check if is actually Andore
2. Check if this Andore's variation have at least code >= 2
3. Load the palette from location E568 + (0x20 * variation code) to our specified palette ID
4. Set our palette ID to character's memory O + 0x2F.

The palette ID extraction routine will take care of that value and do the rest automatically.<br>

The hack script is the following:

```
    ORG    $E0700
    
START:    
L2CCB4:
    CMPI.W #$0203,($12,A6)
    BNE.B .ORIGINAL
    CMPI.B #$02,($14,A6)
    BCS.B .ORIGINAL
    CMPI.B #$01,($62,A6)
    BLE.B .ORIGINAL
.LOAD_PALETTE:
    MOVEM.L D0-D1/A0-A1,-(SP)
    MOVEQ #8-1,D0    
    MOVEQ #0,D1
    MOVE.B ($14,A6),D1              ; GET ANDORE VARIATION (2-4)
    SUBQ.B #2,D1                    ; 0-INDEX STARTS FROM 2
    LSL #5,D1
    LEA $E568,A0                        
    LEA (A0,D1.W),A0                ; $E568(ANDORE PALETTE) + ($XX*$20)
    MOVE.B ($62,A6),D1              ; GET PALETTE ID ($00-$1F)
    LSL #5,D1
    LEA $914000,A1                  
    LEA (A1,D1.W),A1                ; $914000 (PALETTE REGISTER) + ($XX*$20)    
.LOOPCOL:
    MOVE.L (A0)+,(A1)+
    DBF D0,.LOOPCOL    
    MOVEM.L (SP)+,D0-D1/A0-A1
.ORIGINAL    
    MOVE.B  #$1F, ($13,A4)    
    RTS
L2CCFA:
    CMPI.W #$0203,($12,A6)
    BNE.B .ORIGINAL
    CMPI.B #$02,($14,A6)
    BCS.B .ORIGINAL
    CMPI.B #$01,($62,A6)
    BLE.B .ORIGINAL
    MOVE.B ($62,A6),($2F,A6)
    ADDQ.L #6,(SP)                  ; FORCE SKIP NEXT 6-BYTE INSTRUCTION
.ORIGINAL
    MOVEQ #0,D0
    MOVE.B ($14,A6),D0
    RTS
```

And the below code is for the routine jumps:

```
 02CCB4  jsr     $e0700.l                                    4EB9 000E 0700

 02CCFA  jsr     $e0754.l                                    4EB9 000E 0754
```

Finally, we add G. Andore as first enemy of Slum 1 and we assign palette ID 0x1D:

```
   06D02C   0070  0210  0040  0203  0202  001D  0000   .p...@........
```

These are the results before and after the Andore hack:

| Before | After |
| ------ | ----- |
| <img width="384" height="224" alt="0053" src="https://github.com/user-attachments/assets/bbd8cf96-abad-447d-9dde-c4f26ecb024e" /> | <img width="384" height="224" alt="0054" src="https://github.com/user-attachments/assets/4cf2996a-7e98-4aca-8bdd-e3fbbc308611" /> |

<a id="a-palrestore"></a>
### Palette restore

When using these palette-hack scripts, we eventually dirty some palette IDs that might be later used for later stages.<br>

As a practical example, let's say I add Edi.E on Slum 1 and we assign palette ID 0x1F, because we know that palette ID is used only by Damnd on Slum 3. <br>

Since palette is normally realoaded on each new Area, we'd eventually use the Edi.E palette on Damnd, and this is not good.<br>

In order to avoid this, I wanted to call the palette routine (0x6451A) on every stage clear, so we are safe to not mess up with colours.<br>

The script is pretty short and simple:

```
000E0800                             7      ORG    $E0800
000E0800                             8  START:                  ; first instruction of program
000E0800                             9  
000E0800                            10  * Put program code here
000E0800                            11  
000E0800                            12  L4E86:
000E0800  3B7C 0004 0000            13      MOVE.W #$4,($0,A5)
000E0806  4EB9 0006451A             14      JSR $6451A
000E080C  4E75                      15      RTS
```

and so the programmed jump:

```
 004E86  jsr     $e0800.l                                    4EB9 000E 0800
```

<a id="a-howtohack"></a>
## Load ROM modifications with MAME

Place mod files under mame root directory, start mame with -debug option under prompt then type the following from the console prompt:

```
loadr damnd.bin,e0000,100,:maincpu
loadr damndmod.bin,03D3B2,3860,:maincpu

loadr sodom.bin,e0100,100,:maincpu
loadr sodommod.bin,040CD8,1e00,:maincpu

loadr edie.bin,e0200,100,:maincpu
loadr ediemod.bin,45FCC,17a0,:maincpu

loadr rolento.bin,e0300,100,:maincpu
loadr rolentomod.bin,48AAA,1870,:maincpu

loadr abigail.bin,e0400,100,:maincpu
loadr abigailmod.bin,4BE30,16c0,:maincpu

loadr belger.bin,e0500,100,:maincpu
loadr belgermod.bin,4ea0a,1c70,:maincpu

loadr palette.bin,e0600,120,:maincpu
loadr palettemod.bin,16904,450,:maincpu

loadr andore.bin,e0700,100,:maincpu
loadr andoremod.bin,2CCB4,4c,:maincpu

loadr palrestore.bin,E0800,10,:maincpu
loadr palrestoremod.bin,4e86,6,:maincpu
```

