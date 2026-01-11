# Assembly File Encryption & Crypto Coprocessor

**Author:** smuhammadkahaf  
**Course:** Computer Organization & Architecture (COA)

---

## Overview

A semester project implementing file encryption in two ways:
- **Software:** MIPS Assembly program for file encryption/decryption
- **Hardware:** Logisim co-processor circuit design

---

## How It Works

**Encryption Method:** Two-stage hybrid approach
1. **XOR Operation** using Key 1
2. **Circular Bit Rotation** using Key 2

**Encryption Flow:** Text → XOR with Key1 → Rotate Left by Key2 → Encrypted  
**Decryption Flow:** Encrypted → Rotate Right by Key2 → XOR with Key1 → Text

---

## Software (MIPS Assembly)

**File:** `COA_semester_project.asm`

**Main Functions:**
- `encrypt` - Encrypts data using XOR + Caesar cipher
- `decrypt` - Reverses the encryption process
- `shift` - Performs circular bit rotation
- File I/O operations with 4KB buffering

**How to Run:**
1. Load file in MARS or SPIM simulator
2. Enter input filename
3. Enter output filename
4. Enter Key 1 (0-255)
5. Enter Key 2 (0-255)
6. Choose: 1 for encrypt, 2 for decrypt

---

## Hardware (Logisim)

**File:** `Encryptor_processor.circ`

**Components:**
- XOR gates (8-bit) for encryption layer
- AND/OR gates for bit manipulation
- Multiplexers for routing
- ROM for lookup tables (optional)

**Control Buttons:**
- **START** - Begins encryption process
- **RESET** - Resets co-processor state
- **BUSY Indicator** - Shows operation in progress
- **END Indicator** - Shows operation complete

---

## Quick Example

**Encrypt "Hello":**
- Input file: `message.txt`
- Output file: `encrypted.txt`
- Key 1: `42`
- Key 2: `15`
- Action: `1` (encrypt)

Result: Encrypted file created with same content encrypted

---

## Key Features

✅ File streaming (handles large files)  
✅ Interactive user interface  
✅ Reversible encryption/decryption  
✅ Hardware co-processor design  
✅ Dual encryption keys for security  

---

## Technical Notes

- Buffer size: 4096 bytes per read
- File names limited to 50 characters
- Rotation amount: key % 8
- Works with any text files
- Keys: unsigned integers (0-255 recommended)

---

## Project Files

```
COA_semester_project.asm       → MIPS Assembly implementation
Encryptor_processor.circ       → Logisim hardware design
README.md                      → This documentation
```

---

**Status:** Complete ✓
