# Double dragon

![img0](https://github.com/user-attachments/assets/1bdf2ccd-1e64-4a67-b02b-51633a74d1e3)

#### Character's management

##### Enemy data

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
O+1=character
O+2=animation
O+5=pos x
0+7=pos y
...
```

##### Characters

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

#### Enemy's spawn code

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

#### Routines for the enemy generation

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

#### Enemy character map

```
********** intro ************

B58F (4b4) = 8
B6BF (509) = 3
B6C4 (55e) = 9
B6C9 (5b3) = 2

*********** level 1 ***********

6576=46
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

### CPU control
  
![img1](https://github.com/user-attachments/assets/725832da-a029-4bab-908b-c7519d65af8b)
