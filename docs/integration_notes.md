# Integration Notes

## Clock and Reset

- **Clock**: Single clock domain using `wb_clk_i` from the Caravel management SoC
- **Reset**: Synchronous active-high reset `wb_rst_i` from the Caravel management SoC
- **Clock Period**: 25ns (40MHz) - configurable in OpenLane config

## Bus Interface

- **Protocol**: Wishbone B4 Classic 32-bit
- **Address Decode**: 1KB blocks with 10-bit address masking
- **Timing**: Single-cycle read latency with registered outputs
- **Byte Lanes**: Supported via `wbs_sel_i` for partial word writes

## Address Decoding

The design uses a simple address masking scheme:
```verilog
localparam ADDR_MASK = 32'hFFFF_FC00; // 1KB blocks
assign masked_addr = wbs_adr_i & ADDR_MASK;
```

Each peripheral occupies a 1KB address space:
- SPI Masters: 0x3000_0000, 0x3000_0400, 0x3000_0800, 0x3000_0C00
- I3C Controller: 0x3000_1000
- GPIO Controller: 0x3000_2000

## Interrupt Handling

Three interrupt lines are used:
- `user_irq[0]`: OR of all SPI master interrupts
- `user_irq[1]`: I3C controller interrupt  
- `user_irq[2]`: GPIO edge-detect interrupts

All interrupts are level-high and should be cleared by writing to the respective IC (Interrupt Clear) registers.

## Power Connections

The design uses Caravel's user area power domain:
- **VPWR**: Connected to `vccd1` (1.8V)
- **VGND**: Connected to `vssd1` (digital ground)

## Simulation Notes

### RTL Simulation
Run RTL simulation using the provided testbenches in `verilog/dv/`.

### Gate-Level Simulation  
After OpenLane hardening, gate-level simulation can be run using the generated netlist in `verilog/gl/`.

### SDF Simulation
For timing-accurate simulation, use the SDF files generated in `signoff/` directory.

## OpenLane Configuration

### User Project Wrapper
- **Design**: `user_project_wb_wrapper`
- **Clock Period**: 25ns
- **Core Utilization**: 40%
- **Files**: All RTL files including utility libraries

### Build Process
1. Harden the user project wrapper macro
2. Copy views using the provided script
3. Update user_project_wrapper configuration
4. Harden the final user_project_wrapper

## Testing Strategy

### Unit Tests
- Individual peripheral tests for SPI, I3C, and GPIO
- Address decode verification
- Interrupt functionality tests

### Integration Tests  
- Multi-peripheral concurrent operation
- Bus arbitration and timing
- Power-on reset behavior

### Caravel Integration Tests
- Management SoC communication
- Logic analyzer integration
- Full-chip simulation with Caravel testbench

## Known Limitations

1. **I3C Features**: Currently uses I2C IP as base - full I3C features not implemented
2. **FIFO Depths**: Default FIFO depths used - may need tuning for specific applications
3. **Clock Domains**: Single clock domain - no CDC for multi-clock operation

## Debug Features

Logic analyzer connections provide visibility into:
- Wishbone bus transactions (address, data, control)
- Interrupt status
- Internal state for debugging

Access via `la_data_out[127:0]` signals in simulation or through Caravel's logic analyzer interface.