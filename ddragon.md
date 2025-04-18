# Double dragon

![img0](https://github.com/user-attachments/assets/1bdf2ccd-1e64-4a67-b02b-51633a74d1e3)

## System information

```
$026 = demo mode
$036 = level counter
$E5E = time counter
```

## Character's management

### Player data

Player data is stored on the following addressess:

```
$3A2 - Player 1
$400 - Player 2
```

```
O     = offset
O     = ground status ? (C1,C2)
O + 02 = animation
O + 05 = pos x
0 + 07 = pos y
0 + 1F = energy
...
```

### Enemy data

Everytime an enemy spawn in the fight, a free **slot** ram of $55 bytes is booked for managing enemy's data, such as animation, position, etc.

First slot start offset starts from $45e, then next slot will start from $45e+$55:

Here's an example of slot's map address:

1. $45e
2. $4b3
3. $508
4. $55d
[...]

Enemy's boss level often take address $706

Typically, when an enemy dies the address slot reserved for it get free so when the next enemy spawn on the screen can take it.
This is a bit of content map that an enemy slot can contains:

```
O = offset
O + 01 = character
O + 02 = animation
O + 05 = pos x
O + 07 = pos y
O + 1F = energy
...
```

### Characters

This is the character's available value that I discovered so far:

```
00 player 1
01 player 2
02 final boss
03 2nd level boss
04 giant white
05 giant black
06 giant white 2
07 giant black 2
08 white guy
09 white guy 2
0A woman 
0B unknow
22 black guy
23 black guy 2
```

For instance, by changing byte $45f content value to $04, you would change enemy character to giant white.

Notice that changing on runtime content slot value with $00 or $01 can cause player to be stuck on map.

### Enemy's spawn code

There are some routines responsable for the enemy spawning during gameplay.

The most often called routine is the following:

```
 6228  LDA    $4,Y                                         A6 24
 622A  ANDA   #$1F                                         84 1F
 622C  STA    $17,X                                        A7 88 17
 622F  LDU    #$6345                                       CE 63 45
 6232  LDB    A,U                                          E6 C6
 6234  STB    $1,X                                         E7 01
```

Basically, by taking the first 5 bits of the Y+4 address value you know which enemy is:

```
6345  02 03 04 05 06 07 08 09 0A 22 23
```

The above is somehow a vector address for the enemy character. 
For instance, if you replace $08 with $22 and you replace $22 with $08 as well,

you'll basically see the black guy spawning in place of the white guy and viceversa.

The working rule is quite simple:

Let's say at point $622C the A register contains value $06, then ($6345+$06) give $08, the white guy.

At $6234 the instruction store the enemy character on the free enemy slot + 1 (i.e. $45f)

### Routines for the enemy generation

These are routines for the enemy spawn on the map:

**Routine A**
```
6228  LDA    $4,Y                                         A6 24
622A  ANDA   #$1F                                         84 1F
622C  STA    $17,X                                        A7 88 17
622F  LDU    #$6345                                       CE 63 45
6232  LDB    A,U                                          E6 C6
6234  STB    $1,X                                         E7 01
```

**Routine B**
```
529F  LDA    ,Y+                                          A6 A0
52A1  STA    $1,X                                         A7 01
```

**Routine C**
```
59A4  LDA    #$04                                         86 04
59A6  LDB    $36                                          D6 36
59A8  BEQ    $59AC                                        27 02
59AA  LDA    #$07                                         86 07
59AC  STA    $1,X                                         A7 01
```

**Routine D**
```
64A8  LDA    #$85                                         86 85
64AA  STA    $17,X                                        A7 88 17
64AD  ADDA   #$02                                         8B 02
64AF  ANDA   #$7F                                         84 7F
64B1  STA    $1,X                                         A7 01
```

**Routine E**
```
5DA7  LDA    ,Y+                                          A6 A0
5DA9  STY    $00                                          10 9F 00
5DAC  PULS   Y                                            35 20
5DAE  STA    $1,X                                         A7 01
```

**Routine F**
```
A49D  LDA    #$16                                         86 16
A49F  STA    $1,X                                         A7 01
```

**Routine G**
```
A4CF  LDA    $1D,X                                        A6 88 1D
A4D2  STA    $1,X                                         A7 01
```

**Routine H**
```
55E1  LDA    ,Y+                                          A6 A0
55E3  STA    $1,X                                         A7 01
```

**Routine I**
```
63B2  LDA    #$03                                         86 03
63B4  STA    $1,X                                         A7 01
```

### Enemy character map

```
********** intro ************

B58F (4b4) = 8
B6BF (509) = 3
B6C4 (55e) = 9
B6C9 (5b3) = 2

*********** level 1 ***********

![img2](https://github.com/user-attachments/assets/39f6b9a9-b0f2-4244-8822-472432945f60)=46
6580=4A
66FD=27
6707=06
658B=46
dynamic=0A -> Routine B
6714=06
59A5=04 -> Routine C
6596=46
65A0=4A
65AA=4A
XXXX=07 -> Routine D

*********** level 2 ***********

65B5=49
65BF=47
65C9=09
65D3=07
6721=26
6541=41 (BOSS)
5316=0A -> Routine E
5317=0A -> Routine E
5318=08 -> Routine E
5310=0A -> Routine E
5311=0A -> Routine E

*********** level 3 ***********

65DF=46
65E9=4A
65F3=4A
672E=27
dynamic=0A -> Routine B
65FE=47
6608=46
6612=46
661C=46
6627=42
6631=43
663B=46
6645=46
673B=07
Routine F
Routine G
6649=46
665A=42
6664=42
6748=27

*********** level 4 ***********

666F=41
6679=41
6683=47
668D=41
05B6=46
560D=07 (BOSS) -> Routine H

*********** level 5 ***********

66A2=46
66AC=47
6756=29
Routine C
Routine C
66B7=47
66C1=49
66CB=42
654C=40 (boss)
XXXX=03 -> Routine I
XXXX=03 -> Routine I
XXXX=03 -> Routine I
```

![img2](https://github.com/user-attachments/assets/5e14afd5-6b53-4030-8e85-502be22b8fdd)

On the above image we see the value relative to the level 1's first enemy.

$46 AND $1F = $06

$06 from ($6345) = $08

## Hacks

### Enemy with 0 energy

There are several routines for dealing with enemy's energy like the one below:

```
59CE  LDA    $1,X                                         A6 01
59D0  JSR    $6419                                        BD 64 19
59D3  STB    $1F,X                                        E7 88 1F
```

If you remove the **STB** instruction, energy of the enemy won't be set,

so basically you'll get rid of in one shoot.

On MAME, open a new memory window and point to Region :maincpu

Then replace instruction **STB $1F,X** with 3 **NOP* (12,12,12)

59D3+C000
52CA+C000
631C+C000
64B6+C000
5DDA+C000
63BC+10000

![img3](https://github.com/user-attachments/assets/6a49310f-e0f8-4f4a-9bf2-0250ce6258a5)

### CPU control player 2

Address $26 control the game mode, possible values are:

```
$00 = demo mode on
$01 = demo mode off
```

When on demo mode on, players are controlled by CPU.

Said so, I guessed that was somehow possible to make game playable on cooperative mode with both human and CPU.

by placing a watchpoint on address $26 I discovered many routines that check for that address, but the one responsible
for the player's movement was located at address $4449:

```
FEB3  JMP    $FC78                                        7E FC 78
FEB6  JMP    $44CD                                        7E 44 CD
---
FEB9  JMP    $4449                                        7E 44 49
---
FEBC  JMP    $4736                                        7E 47 36
FEBF  JMP    $45D7                                        7E 45 D7
FEC2  JMP    $47DB                                        7E 47 DB
FEC5  JMP    $681B                                        7E 68 1B
FEC8  JMP    $6D64                                        7E 6D 64
FECB  JMP    $47E3                                        7E 47 E3
FECE  JMP    $47E9                                        7E 47 E9
FED1  JMP    $4804                                        7E 48 04
FED4  JMP    $675D                                        7E 67 5D
```

and this is beging the content of routine located at $4449:

```
4449  LDA    $26                                          96 26
444B  BNE    $445E                                        26 11
444D  LDA    $5C,X                                        A6 88 5C
4450  BEQ    $4457                                        27 05
4452  DEC    $5C,X                                        6A 88 5C
4455  BRA    $445A                                        20 03
4457  LBSR   $FAA0                                        17 B6 46
445A  LDA    $5A,X                                        A6 88 5A
445D  RTS                                                 39
445E  LDY    #$3800                                       10 8E 38 00
```

You can see that at $4449 code read from address $26.

If demo mode is off then branch to address $445e, otherwise continue.

By placing a breakpoint at address $4449, I noticed that register X value could be $3A2 or $400.

Do you recall that values? These are the vector base address for player 1 and player 2.

It is easy to guess that pointing to a different address than $26 might do the job.

The following code hack show how to achieve this;

open memory window on MAME and then edit the content as shown below:

```
*4449+C000
 4449  LDA    $25                                          96 25

*FEB9
 FEB9  JMP    $5000                                        7E 50 00

*5000+C000
 5000  CMPX   #$03A2                                       8C 03 A2
 5003  LBEQ   $445E                                        10 27 F4 57
 5007  JMP    $4449                                        7E 44 49
```
