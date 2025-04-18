# Double dragon

![img0](https://github.com/user-attachments/assets/1bdf2ccd-1e64-4a67-b02b-51633a74d1e3)

#### Enemy's management

Each enemy that is engaged in fight takes a ram slot of $55 bytes size.
So the slots offset starts from:

1. 45e
2. 4b3
3. 508
4. 55d
[...]

Typically, when an enemy dies the slot get free so it would be taken from the next enemy displaying on the screen.

```
O+1=character
O+2=animation
...
```

This is the enemy value map that I discovered so far:

```
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

#### Enemy's generation code

There are some routines responsables for the enemy spawning on the level.

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

The above is somehow a vector address for the enemy character, so let's say you replace on the above table $08 with $22
and $22 replaced with $08, you'll  basically have on the map the white guy replaced with black guy enemy, and viceversa.

So let's say at point $622C the A register contains value $06, then ($6345+$06) give $08, the white guy.

At $6234 the instruction store the enemy character on the free enemy slot + 1 (i.e. $45f)

There are other routines for enemy spawning:

```
529F  LDA    ,Y+                                          A6 A0
52A1  STA    $1,X                                         A7 01
```

```
59A4  LDA    #$04                                         86 04
59A6  LDB    $36                                          D6 36
59A8  BEQ    $59AC                                        27 02
59AA  LDA    #$07                                         86 07
59AC  STA    $1,X                                         A7 01
```

```
64A8  LDA    #$85                                         86 85
64AA  STA    $17,X                                        A7 88 17
64AD  ADDA   #$02                                         8B 02
64AF  ANDA   #$7F                                         84 7F
64B1  STA    $1,X                                         A7 01
```

```
5DA7  LDA    ,Y+                                          A6 A0
5DA9  STY    $00                                          10 9F 00
5DAC  PULS   Y                                            35 20
5DAE  STA    $1,X                                         A7 01
```

### CPU control
  
![img1](https://github.com/user-attachments/assets/725832da-a029-4bab-908b-c7519d65af8b)
