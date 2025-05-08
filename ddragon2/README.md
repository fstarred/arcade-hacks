# Double Dragon II

![intro](https://github.com/user-attachments/assets/fcf78f78-c200-42dd-b9b3-0784a8dd53e8)

## System information

**CPU**
* Hitachi HD6309E
* Zilog Z80

**Specs**<br>
[H 6309 reference](../specs/Motorola%206809%20and%20Hitachi%206309%20Programming%20Reference%20(Darren%20Atkinson).pdf)

## General information

```
$026 = demo mode
$036 = level counter
$04B = palette 
$F49 = time counter
```

Notice that, by changing $4B = $0B after the intro, will make show the intro scene again

## Legacy

A lot of data from the first episode is still present on the second.
For example, by changing the content at address $3A4 (p1 animation) with $1A, $1B you can see the head butt animation; $1E,$1F for front kick.

## Character's management

### Player data

Player data is stored on the following addresses:

```
$3A2 - Player 1
$400 - Player 2
```

```
O     = offset
O     = ground status ? (C1,C2)
0 + 01 = character
O + 02 = animation
O + 05 = pos x
0 + 07 = pos y
0 + 1F = energy
...
```

### Enemy data

Everytime an enemy spawn in the fight, a free **slot** ram of $55 bytes is booked for managing enemy's data, such as animation, position, etc.

First slot start offset starts from $460, then next slot will start from $460+$63:

Here's an example of slot's map address:

1. $460
2. $463
3. $4C6
4. $529
[...]

Enemy's boss level often take address $778

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
00 Billy
01 Jimmy
02 Willy
03 Jeff
04 Oharra
05 Abore
06 Bolo
07 Chin Taimei
08 Williams
09 Roper
0A Linda 
0B Burnov
22 Williams
23 Roper
32 Doppelganger
```

For instance, by changing byte $461 content value to $0B, you would change enemy character to Burnov.

Notice that changing on runtime content slot value with $00 or $01 can cause player to be stuck on map.

#### Enemies intro
```
$79B5+$20000	$02	Willy
$7AB7+$20000	$07	Chin Taimei
$7ABB+$20000	$0B	Burnov
```

### Actions ###

Every time player or enemy are involved in some actions like punching, kicking, jumping etc. , a JMP
instruction orchestrate for which routine will be called, according to the action taken.

The following routine is called when player 1 or player 2 take an action:

```
 9630  LDA    $1E,X                                        A6 88 1E
 9633  ANDA   #$7F                                         84 7F
 9635  CMPA   #$16                                         81 16
 9637  BCC    $9637                                        24 FE
 9639  ASLA                                                48
 963A  LDY    #$9640                                       10 8E 96 40
 963E  JMP    [A,Y]                                        6E B6
 9640  LDA    $6C                                          96 6C
 9642  STA    $04                                          97 04
 9644  STA    $59                                          97 59
 9646  EORA   $E7                                          98 E7
```

Let's say player is jumping, register A value = $04 and Y = $9640, when PC is at $963E, then JMP instruction will make jump PC to the address stored at $9640+$04, which is $9759.
<br>
We can so change the content location at Y+A register with another routine in order to change control's behavior:
For instance, by swapping the word size content at $9640 and $9640+$02, we could throw punch instead of kick and viceversa.
<br>
This actually make not sense at all, but whatever.. we might, for example, to forbid the enemy for a specific move.
<br>
Notice that, for enemy, a similar JMP statement can be found at address $ABB5.

Therefore:

```
Action JMP routine:
$963E player
$ABB5 enemy
```
