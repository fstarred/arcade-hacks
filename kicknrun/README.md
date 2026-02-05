# Kick and Run (Taito 1986) - Team Attributes & Palette Hack

<img width="1300" height="974" alt="Screenshot 2026-02-03 13-44-47" src="https://github.com/user-attachments/assets/93cb1319-dc24-49f7-8039-4c65529fd179" />


Technical documentation for modifying team skills, physics, and color palettes in the arcade classic *Kick and Run* (also known as *Mexico 86*).

## 🛠 Hardware Overview

- **CPU**: Zilog Z80 (@ 6.0 MHz)

- **MCU**: Hitachi 6801 (Address range `0xE800 - 0xEFF0`)

- **Banking**: 16KB ROM banks swapped into `$8000 - $BFFF`

- **Driver Reference**: `kikikai.cpp`



---



## 📊 Team Data Structure

Team statistics are stored in a fixed-length table in **ROM Bank 1**. Each team is allocated a **$10 (16-byte)** block.



### ROM Memory Locations (MAME Region Offset)

| Team | Offset (Bank 1) | Original Color |
| :--- | :--- | :--- |
| **Japan** | `0x140F0` | Red (`00`) |
| **W. Germany** | `0x14100` | Grey (`08`) |
| **Brazil** | `0x14110` | Green (`10`) |
| **Italy** | `0x14120` | Yellow (`18`) |
| **England** | `0x14130` | Blue (`20`) |
| **USA** | `0x14140` | Azure (`28`) |
| **Argentina** | `0x14150` | White (`38`) |



### Byte Map (Attribute Offsets)

```
000140F1 DC 02 0C 0D:00 50 20 D0|01 0D 06 00:08 10 1F 0F -> Japan
00014101 64 02 0D 0D:00 58 24 C0|02 0C 05 08:EE 30 3F 07 -> W.Germany
00014111 80 02 0C 0D:00 60 28 D0|01 0E 07 10:F6 08 7F 1F -> Brazil
00014121 B4 02 0C 0D:00 50 24 D0|02 0D 06 18:0A 10 1F 0F -> Italy
00014131 C0 02 0B 0C:00 58 24 F0|04 0C 05 20:12 24 3F 07 -> England
00014141 40 02 0E 0E:00 40 20 C0|02 0C 06 28:F6 F0 3F 0F -> USA
00014151 A4 02 0D 0D:00 40 20 A0|03 0C 07 38:00 02 3F 0F -> Argentina
```

Each 16-byte block follows this schema:

| Offset | Description | Analysis |
| :--- | :--- | :--- |
| `+01` | **Agility** | Lower values (e.g., `64`) yield faster rotation/handling. |
| `+02` | **Acceleration** | Primary speed/accel constant. England is fastest (`0B`). |
| `+06` | **Kick Power (Low)** | Initial velocity for short passes. |
| `+07` | **Shot Velocity** | Maximum ball speed for long shots. Brazil is max (`28`). |
| `+0B` | **Palette Index** | Multiplied by 8 via `RLCA` x3 to find shirt color. |
| `+0D` | **AI Aggression** | Defines Goalkeeper/Teammate response level. |

---

Source bank is at address `0x80F1+0xC000` of `region:maincpu`.<br>

Selected teams attributes values are copied at `0xE820` (1P) and `0xE830` (2P)

## 💻 Logic Reverse Engineering



### 1. The Team Index

The current team selected is tracked in RAM at address **`$D975`**. During the boot sequence and team selection, this index is read and processed to load the correct attribute block.

| Player | Address |
| :--- | :--- | 
| 1P | D975 | 
| 2P | D976 | 

### 2. The Color Calculation (Z80)

The game uses the following assembly routine to calculate the palette offset for the team shirts:

```asm

862B: ld a, ($D975)  ; Load Team Index
8634: rlca           ; Rotate Left (Value * 2)
8635: rlca           ; Rotate Left (Value * 4)
8636: rlca           ; Rotate Left (Value * 8)
8637: ld (ix+$07), a ; Store in Palette Offset

```

also:

```asm
 80BB  jr   nz,$80C2                                       20 05
 80BD  ld   a,($D975)                                      3A 75 D9 ; 1P
 80C0  jr   $80C5                                          18 03
 80C2  ld   a,($D976)                                      3A 76 D9 ; 2P
 80C5  cp   $06                                            FE 06 ; Argentine selected?
 80C7  jr   c,$80CA                                        38 01
 80C9  inc  a                                              3C    ; if Argentine, increment accumulator to 07
 80CA  rlca                                                07
 80CB  rlca                                                07
 80CC  rlca                                                07
 80CD  ld   (de),a                                         12    ; write to address (de) the accumulator value
 80CE  push hl                                             E5
 80CF  push de                                             D5
 80D0  pop  hl                                             E1
```

#### Team Selection

| Player | Address | Delta |
| :--- | :--- | :--- |
| 1P | E007 | +0  |
| 2P | E107 | +40 |

#### Players takes the field

| 1P Address | 2P Address | 
| :--- | :--- |
| E037 | E137 |
| E047 | E147 |
| E057 | E157 |
| E067 | E167 |
| E077 | E177 |
| E087 | E187 |
| E097 | E197 |
| E0A7 | E1A7 |
| E0B7 | E1B7 |

### Palette attributes

Palette information is stored on these 3 ROM files:

| ROM | Color component |
| :--- | :--- |
|a87-10.g15 | **RED** |
|a87-12.g12 | **GREEN** |
|a87-11.g14 | **BLUE** |

Japan palette attributes is stored starting from address `0000`, W. Germany from address `0x0010`, and so on.
Argentine is stored at index bank `+38`, so starting from address `0x0070`


| Offset | Object |
| :--- | :--- |
| +01  | Sock A |
| +02  | Sock B |
| +03  | Shirt A |
| +04  | Shirt B |
| +05  | Shoes A |
| +06  | Shoes B |
| +07  | Hair    |
| +08  | Shorts A |
| +09  | Shorts B |
| +0A  | Shirt A |
| +0B  | Shirt B |
| +0C  | Skin A |
| +0D  | Skin B |
| +0E  | Bg color |


## 3. Patch List: Bypassing Protection & Checksums

| Address | Original Hex | Patch Hex | Description |
|:---|:---|:---|:---|
| **07CC** | `22 7D E8` | `21 00 00` | **Force Checksum:** Ensures HL is $0000 before validation. |
| **07D2** | `16` | `17` | **Break Checksum Loop:** Adjusts JR Z offset to skip the RET at 07E9. |
| **0804** | `5E` | `C9` | **Global Summation Kill:** Forces an immediate RET from the ROM sum routine. |
| **0815** | `3A 04 E4` | `C3 B1 08` | **MCU Comm Bypass:** Skips "BAD COM" handshake loop and jumps to $08B1. |
| **020C** | `DA 00 00` | `00 00 00` | **Sanity Check 1:** Prevents reset if RAM $E800 is uninitialized. |
| **0211** | `D2 00 00` | `00 00 00` | **Sanity Check 2:** Prevents reset if version string check fails. |
| **0218** | `C2 00 00` | `00 00 00` | **Interrupt Check:** Prevents reset based on the I register state. |
| **0223** | `20 32` | `00 00` | **Hardware ID Bypass:** Prevents jump to "BAD" screen at $0257. |
| **0261** | `C3 07 02` | `00 00 00` | **Master Loop Break:** Stops the infinite loop between $0207 and $0261. |

If you want to easily skip all validations, just change address `0x804` to `C9`
