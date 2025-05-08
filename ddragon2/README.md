# Double dragon II

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
$04B = game status ($04 = initial screen, $0B = intro)
$E5E = time counter
```

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



