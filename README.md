# Assembly File Encryption & Crypto Coprocessor
## Semester Project

A comprehensive encryption system implemented in two layers: **software-level encryption** using MIPS Assembly and **hardware-level encryption** using Logisim circuit design.

---

## 📋 Project Overview

This project demonstrates a complete encryption pipeline with dual implementation approaches:

1. **MIPS Assembly Software** - Full-featured file encryption/decryption system
2. **Logisim Hardware Design** - Hardware co-processor for efficient encryption operations

The encryption algorithm uses a **hybrid approach** combining two cryptographic techniques for enhanced security.

---

## 🔐 Encryption Algorithm

### Hybrid Encryption Approach

The system employs a two-stage encryption process:

#### **Stage 1: XOR Operation**
- Uses **Key 1** as the XOR cipher key
- XOR operation: `encrypted_char = original_char XOR key1`
- Provides basic bitwise encryption layer

#### **Stage 2: Caesar Cipher with Circular Rotation**
- Uses **Key 2** to determine the number of bit rotations
- Implements **circular left rotation** for encryption
- Implements **circular right rotation** for decryption
- Key value modulo 8 determines actual rotation amount

### Encryption Flow
```
Original Text → XOR with Key1 → Rotate Left by Key2 → Encrypted Text
```

### Decryption Flow
```
Encrypted Text → Rotate Right by Key2 → XOR with Key1 → Original Text
```

---

## 📂 Project Structure

```
Assembly File Encryption & Crypto Coprocessor/
├── COA_semester_project.asm          # Main MIPS Assembly implementation
├── Encryptor_processor.circ          # Logisim hardware circuit design
└── README.md                          # Project documentation (this file)
```

---

## 🖥️ Software Implementation (MIPS Assembly)

### File: `COA_semester_project.asm`

**Language:** MIPS Assembly (MARS/SPIM compatible)

#### Key Features

- **File I/O Operations**
  - Read input text files in chunks (4096 bytes)
  - Write encrypted/decrypted output to new files
  - Proper file descriptor management

- **User Interface**
  - Interactive prompts for input/output file names
  - Key input for both encryption keys
  - Action selection (Encrypt: 1, Decrypt: 2)

- **Core Functions**

| Function | Purpose |
|----------|---------|
| `main` | Main program flow control |
| `encrypt` | Encrypts data using XOR + Caesar cipher |
| `decrypt` | Decrypts data by reversing the process |
| `shift` | Performs circular bit rotation (left/right) |
| `takeFileNames` | Gets input/output file names from user |
| `TakeKeys` | Gets encryption keys from user |
| `TakeAction` | Gets user choice (encrypt/decrypt) |
| `refine_string` | Removes newline characters from strings |

### Data Structure

```
.data Section:
- inputFilePrompt      → String prompt for input file
- outputFilePrompt     → String prompt for output file
- key1Prompt           → String prompt for first key
- key2Prompt           → String prompt for second key
- actionPrompt         → String prompt for operation choice
- inputFile            → Storage for input filename (50 bytes)
- outputFile           → Storage for output filename (50 bytes)
- inputDescriptor      → File handle for input file
- outputDescriptor     → File handle for output file
- action               → Operation type (1=encrypt, 2=decrypt)
- Line                 → Buffer for file data (4096 bytes)
```

### Register Usage

| Register | Purpose |
|----------|---------|
| `$s0-$s3` | Intermediate calculations |
| `$s5` | Line buffer address |
| `$s6` | Key 1 (XOR key) |
| `$s7` | Key 2 (Caesar rotation key) |
| `$t0-$t8` | Temporary values in shift operation |
| `$v0` | Syscall numbers and return values |
| `$a0-$a3` | Function arguments |

### Execution Flow

```
1. Prompt for file names (input & output)
2. Prompt for two encryption keys
3. Prompt for action (encrypt/decrypt)
4. Refine file names (remove newlines)
5. Open input file in read mode
6. Open output file in write mode
7. Main loop:
   - Read 4096 bytes from input file
   - If no data, go to file end
   - Apply encryption/decryption based on action
   - Write processed data to output file
   - Repeat until EOF
8. Close both files
9. Exit program
```

---

## 🔌 Hardware Implementation (Logisim)

### File: `Encryptor_processor.circ`

**Tool:** Logisim Version 2.7.1

#### Hardware Components

The co-processor implements encryption operations at the hardware level with the following components:

**Logic Gates:**
- **AND Gates** - For bit masking operations
- **OR Gates** (8-bit width) - For combining bit values
- **XOR Gates** (8-bit width) - For XOR encryption layer

**Additional Modules:**
- **Multiplexers** - Input/output selection
- **Arithmetic Units** - For rotation calculations
- **Memory (ROM)** - Potential lookup tables

#### Control Interface

The hardware includes physical controls:

| Control | Function |
|---------|----------|
| **START Button** | Initiates encryption/decryption process |
| **RESET Button** | Resets the co-processor state |
| **BUSY Indicator** | Shows if operation is in progress |
| **END Indicator** | Shows when operation is complete |

#### Operation Flow

```
[START] → [BUSY = 1] → Process Data → [END = 1] → [RESET] → Ready
```

#### Design Advantages

- **High-speed processing** - Hardware-level operations faster than software
- **Parallel processing** - Multiple bit operations simultaneously
- **Low latency** - Direct hardware implementation of XOR and rotation
- **Dedicated co-processor** - Offloads encryption from CPU

---

## 🚀 How to Use

### Software (Assembly)

**Requirements:**
- MARS (MIPS Assembler and Runtime Simulator) or SPIM
- Text files to encrypt

**Steps:**
1. Load `COA_semester_project.asm` in MARS/SPIM
2. Run the program
3. Enter input filename (e.g., `input.txt`)
4. Enter output filename (e.g., `encrypted.txt`)
5. Enter Key 1 (integer, preferably 0-255)
6. Enter Key 2 (integer, preferably 0-255)
7. Choose action: `1` for encrypt, `2` for decrypt
8. Program will process and create output file

**Example Session:**
```
Enter input file name: message.txt
Enter Output File Name: encrypted.txt
Enter Key 1: 42
Enter Key 2: 15
Enter 1 for Encrypt
Enter 2 for decrypt: 1
[Processing...]
```

### Hardware (Logisim)

**Requirements:**
- Logisim version 2.7.1 or compatible
- 8-bit data input
- Keys for XOR and rotation

**Steps:**
1. Load `Encryptor_processor.circ` in Logisim
2. Set up input data (8-bit value)
3. Configure keys (XOR key and rotation key)
4. Click **START** button
5. Monitor **BUSY** indicator
6. Wait for **END** indicator
7. Read encrypted output
8. Click **RESET** to process next value

---

## 🔑 Key Features

### Security Aspects
- ✅ **Dual-layer encryption** - XOR + Caesar cipher
- ✅ **Variable keys** - Two independent encryption keys
- ✅ **Reversible encryption** - Full decryption capability
- ✅ **Byte-level processing** - Works with any binary data

### Technical Highlights
- ✅ **File streaming** - Handles large files efficiently (4096-byte chunks)
- ✅ **Circular rotation** - Proper 8-bit bit rotation implementation
- ✅ **Hardware acceleration** - Dedicated co-processor design
- ✅ **User-friendly** - Interactive CLI interface

### Educational Value
- ✅ Demonstrates MIPS architecture fundamentals
- ✅ Shows practical file I/O in assembly
- ✅ Illustrates hardware-software co-design
- ✅ Examples of encryption implementation

---

## 📊 Performance Considerations

### Software Implementation
- **Throughput:** ~4KB per iteration
- **Speed:** Dependent on CPU and system load
- **Memory:** ~4KB buffer for file reading
- **Scalability:** Works with files of any size

### Hardware Implementation
- **Throughput:** Single 8-bit word per clock cycle
- **Latency:** Minimal (direct hardware implementation)
- **Power:** Dedicated power for crypto operations
- **Efficiency:** No CPU overhead

---

## 🎯 Example Usage Scenario

**Encrypting a message:**

```
Input File: secrets.txt
Content: "Hello World"
Key 1: 123
Key 2: 5

Processing:
H (0x48) → XOR 123 → Rotate Left 5 → Encrypted byte
e (0x65) → XOR 123 → Rotate Left 5 → Encrypted byte
...

Output: Binary encrypted data in encrypted_secrets.txt
```

**Decrypting the file:**

```
Input File: encrypted_secrets.txt
Key 1: 123 (same)
Key 2: 5 (same)
Action: 2 (Decrypt)

Processing:
Encrypted byte → Rotate Right 5 → XOR 123 → 'H'
Encrypted byte → Rotate Right 5 → XOR 123 → 'e'
...

Output: "Hello World" in decrypted_secrets.txt
```

---

## 🔧 Technical Details

### MIPS Syscall Codes Used
| Code | Operation |
|------|-----------|
| 4 | Print string |
| 5 | Read integer |
| 8 | Read string |
| 10 | Exit program |
| 13 | Open file |
| 14 | Read file |
| 15 | Write file |
| 16 | Close file |

### Rotation Algorithm
```
LEFT ROTATE:
1. Shift value left by 1: sll $t6, $t3, 1
2. Extract MSB (bit 7): andi $t7, $t3, 0x80
3. Move MSB to position: srl $t7, $t7, 7
4. Combine: or $t3, $t6, $t7
5. Mask to 8 bits: andi $t3, $t3, 0xFF

RIGHT ROTATE:
1. Extract LSB (bit 0): andi $t7, $t3, 0x01
2. Move LSB to MSB: sll $t7, $t7, 7
3. Shift right: srl $t6, $t3, 1
4. Combine: or $t3, $t6, $t7
5. Mask to 8 bits: andi $t3, $t3, 0xFF
```

---

## 📝 Notes

- **Key Modulo:** Rotation amount is automatically `key % 8` (valid for 8-bit values)
- **Buffer Size:** 4096 bytes for efficient file processing
- **File Names:** Limited to 50 characters
- **Text Files:** Works with any text format
- **Keys:** Unsigned integers (typical range 0-255 for full effect)

---

## 👨‍💻 Author

**Semester Project** - Computer Organization & Architecture (COA)

**Date:** January 2026

---

## 📚 References

- MIPS Instruction Set Architecture
- Logisim Circuit Simulation Software
- Caesar Cipher Cryptography
- XOR Encryption Principles

---

## 📄 License

Educational project - Use for learning purposes.

---

## ✅ Checklist for Project Submission

- [x] MIPS Assembly implementation with encryption/decryption
- [x] Hardware design using Logisim
- [x] File I/O operations
- [x] User interactive interface
- [x] Proper function documentation
- [x] Control signals (START, RESET, BUSY, END)
- [x] Comprehensive README

---

**Project Complete!** 🎉
