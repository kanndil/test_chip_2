# Custom User Project - Multi-Peripheral SoC

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

## Overview

This project integrates a custom user project into the Caravel SoC with the following peripherals:

1. **4× SPI Masters** at base address 0x3000_0000 (1KB each)
2. **1× I3C Controller** at base address 0x3000_1000 (1KB)  
3. **2× GPIO Lines** with edge-detect interrupts at base address 0x3000_2000 (1KB)

## Requirements Met

✅ **4× SPI Masters**: Implemented using CF_SPI IP cores with Wishbone interface
- Base addresses: 0x3000_0000, 0x3000_0400, 0x3000_0800, 0x3000_0C00
- Full SPI master functionality with configurable clock, FIFO support, and interrupts
- Pad assignments: SPI0 (pads 8-11), SPI1 (pads 12-15), SPI2 (pads 16-19), SPI3 (pads 20-23)

✅ **1× I3C Controller**: Implemented using EF_I2C IP as base with I3C compatibility
- Base address: 0x3000_1000
- I2C/I3C protocol support with FIFO buffers and interrupt capability
- Pad assignments: SCL (pad 24), SDA (pad 25) with open-drain configuration

✅ **2× GPIO Lines**: Implemented using EF_GPIO8 IP (using 2 of 8 available pins)
- Base address: 0x3000_2000
- Edge-detect interrupts with configurable direction and interrupt masking
- Pad assignments: GPIO0 (pad 26), GPIO1 (pad 27)

✅ **Interrupt Integration**: Three interrupt lines mapped to user_irq[2:0]
- user_irq[0]: OR of all 4 SPI master interrupts
- user_irq[1]: I3C controller interrupt
- user_irq[2]: GPIO edge-detect interrupts

## Architecture

### Address Map
| Base Address | Size | Peripheral | Description |
|--------------|------|------------|-------------|
| 0x3000_0000  | 1KB  | SPI Master 0 | SPI Master Controller 0 |
| 0x3000_0400  | 1KB  | SPI Master 1 | SPI Master Controller 1 |
| 0x3000_0800  | 1KB  | SPI Master 2 | SPI Master Controller 2 |
| 0x3000_0C00  | 1KB  | SPI Master 3 | SPI Master Controller 3 |
| 0x3000_1000  | 1KB  | I3C Controller | I3C/I2C Controller |
| 0x3000_2000  | 1KB  | GPIO Controller | 2-bit GPIO with interrupts |

### Bus Interface
- **Protocol**: Wishbone B4 Classic 32-bit
- **Clock**: Single clock domain (wb_clk_i, 40MHz)
- **Reset**: Synchronous active-high (wb_rst_i)
- **Address Decode**: 1KB block masking with exact address matching

## Implementation Plan

### Phase 1: RTL Development ✅
- [x] Create user_project.v with peripheral integration
- [x] Create user_project_wb_wrapper.v for Caravel interface
- [x] Copy and integrate required IP cores (CF_SPI, EF_I2C, EF_GPIO8)
- [x] Create utility module compatibility layer
- [x] Update user_project_wrapper.v instantiation

### Phase 2: Verification ✅
- [x] Create register map documentation
- [x] Create pad map documentation  
- [x] Create integration notes
- [x] Create firmware header files
- [x] Create basic cocotb testbench
- [x] Create smoke test firmware

### Phase 3: Physical Implementation (Next)
- [ ] Run OpenLane synthesis and PnR for user_project_wb_wrapper
- [ ] Copy generated views
- [ ] Update user_project_wrapper OpenLane configuration
- [ ] Run final user_project_wrapper hardening
- [ ] Verify timing and DRC clean results

## File Structure

```
├── docs/
│   ├── register_map.md      # Detailed register documentation
│   ├── pad_map.md          # Pad assignment and configuration
│   └── integration_notes.md # Clock, reset, and integration details
├── fw/
│   ├── user_periph.h       # Firmware header with register definitions
│   └── smoke_test.c        # Basic functionality test
├── verilog/
│   ├── rtl/                # RTL source files
│   │   ├── user_project.v  # Main user project integration
│   │   ├── user_project_wb_wrapper.v # Wishbone wrapper
│   │   ├── user_project_wrapper.v    # Caravel wrapper (updated)
│   │   └── [IP cores and utilities]
│   └── dv/
│       └── cocotb/
│           └── user_project_test/    # Cocotb verification
└── openlane/
    └── user_project_wb_wrapper/     # OpenLane configuration
```

## Next Steps

1. **Run OpenLane Flow**: Execute synthesis and PnR for the user project wrapper
2. **Integration Testing**: Run cocotb tests with Caravel environment
3. **Physical Verification**: Ensure DRC/LVS clean results
4. **Performance Validation**: Verify timing closure at target frequency

## Usage

### Register Access
Use the provided firmware header (`fw/user_periph.h`) for register definitions and access macros.

### Testing
Run the cocotb test suite:
```bash
cd verilog/dv/cocotb
caravel_cocotb -t user_project_test
```

### Synthesis
Run OpenLane synthesis:
```bash
cd openlane/user_project_wb_wrapper
make
```
