# Kick and Run (Taito 1986) - Team Attributes & Palette Hack

<img width="256" height="224" alt="0735" src="https://github.com/user-attachments/assets/f624261a-b5ad-4456-a899-55f9dc414cb1" />

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

Each 16-byte block follows this schema:



| Offset | Description | Analysis |
| :--- | :--- | :--- |
| `+01` | **Agility** | Lower values (e.g., `64`) yield faster rotation/handling. |
| `+03` | **Acceleration** | Primary speed/accel constant. England is fastest (`0B`). |
| `+06` | **Kick Power (Low)** | Initial velocity for short passes. |
| `+07` | **Shot Velocity** | Maximum ball speed for long shots. Brazil is max (`28`). |
| `+0C` | **Palette Index** | Multiplied by 8 via `RLCA` x3 to find shirt color. |
| `+0D` | **AI Aggression** | Defines Goalkeeper/Teammate response level. |



---



## 💻 Logic Reverse Engineering



### 1. The Team Index

The current team selected is tracked in RAM at address **`$D975`**. During the boot sequence and team selection, this index is read and processed to load the correct attribute block.



### 2. The Color Calculation (Z80)

The game uses the following assembly routine to calculate the palette offset for the team shirts:

```asm

862B: ld a, ($D975)  ; Load Team Index

...

8634: rlca           ; Rotate Left (Value * 2)

8635: rlca           ; Rotate Left (Value * 4)

8636: rlca           ; Rotate Left (Value * 8)

8637: ld (ix+$07), a ; Store in Palette Offset

