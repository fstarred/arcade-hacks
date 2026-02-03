# Kick and Run (Taito 1986) - Team Attributes & Palette Hack

<img width="256" height="224" alt="0953" src="https://github.com/user-attachments/assets/6a4f9b1b-44e2-4dd8-8eca-ce05af511099" />

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



### 2. The Color Calculation (Z80)

The game uses the following assembly routine to calculate the palette offset for the team shirts:

```asm

862B: ld a, ($D975)  ; Load Team Index



8634: rlca           ; Rotate Left (Value * 2)

8635: rlca           ; Rotate Left (Value * 4)

8636: rlca           ; Rotate Left (Value * 8)

8637: ld (ix+$07), a ; Store in Palette Offset

```

## Patch List: Bypassing Protection & Checksums

| Address | Original Hex | Patch Hex | Description |
|:---|:---|:---|:---|
| **07CC** | `21 00 00` | `21 00 00` | **Force Checksum:** Ensures HL is $0000 before validation. |
| **07D2** | `16` | `17` | **Break Checksum Loop:** Adjusts JR Z offset to skip the RET at 07E9. |
| **0804** | `5E` | `C9` | **Global Summation Kill:** Forces an immediate RET from the ROM sum routine. |
| **0815** | `3A 04 E4` | `C3 B1 08` | **MCU Comm Bypass:** Skips "BAD COM" handshake loop and jumps to $08B1. |
| **020C** | `DA 00 00` | `00 00 00` | **Sanity Check 1:** Prevents reset if RAM $E800 is uninitialized. |
| **0211** | `D2 00 00` | `00 00 00` | **Sanity Check 2:** Prevents reset if version string check fails. |
| **0218** | `C2 00 00` | `00 00 00` | **Interrupt Check:** Prevents reset based on the I register state. |
| **0223** | `20 32` | `00 00` | **Hardware ID Bypass:** Prevents jump to "BAD" screen at $0257. |
| **0261** | `C3 07 02` | `00 00 00` | **Master Loop Break:** Stops the infinite loop between $0207 and $0261. |

If you want to easily skip all validations, just change address `0x804` to `C9`
