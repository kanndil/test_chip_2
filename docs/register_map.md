# Register Map

## Address Map Overview

| Base Address | Size | Peripheral | Description |
|--------------|------|------------|-------------|
| 0x3000_0000  | 1KB  | SPI Master 0 | SPI Master Controller 0 |
| 0x3000_0400  | 1KB  | SPI Master 1 | SPI Master Controller 1 |
| 0x3000_0800  | 1KB  | SPI Master 2 | SPI Master Controller 2 |
| 0x3000_0C00  | 1KB  | SPI Master 3 | SPI Master Controller 3 |
| 0x3000_1000  | 1KB  | I3C Controller | I3C/I2C Controller |
| 0x3000_2000  | 1KB  | GPIO Controller | 2-bit GPIO with interrupts |

## SPI Master Registers (4 instances)

Each SPI master has the following register map:

| Offset | Name | Access | Reset | Description |
|--------|------|--------|-------|-------------|
| 0x00   | RXDATA | RO | 0x00 | Receive Data Register |
| 0x04   | TXDATA | WO | 0x00 | Transmit Data Register |
| 0x08   | CFG    | RW | 0x00 | Configuration Register |
| 0x0C   | CTRL   | RW | 0x00 | Control Register |
| 0x10   | PR     | RW | 0x01 | Prescaler Register |
| 0x14   | STATUS | RO | 0x00 | Status Register |
| 0x18   | RX_FIFO_LEVEL | RO | 0x00 | RX FIFO Level |
| 0x1C   | RX_FIFO_THRESHOLD | RW | 0x00 | RX FIFO Threshold |
| 0x20   | RX_FIFO_FLUSH | WO | 0x00 | RX FIFO Flush |
| 0x24   | TX_FIFO_LEVEL | RO | 0x00 | TX FIFO Level |
| 0x28   | TX_FIFO_THRESHOLD | RW | 0x00 | TX FIFO Threshold |
| 0x2C   | TX_FIFO_FLUSH | WO | 0x00 | TX FIFO Flush |
| 0xFF00 | IM     | RW | 0x00 | Interrupt Mask |
| 0xFF04 | MIS    | RO | 0x00 | Masked Interrupt Status |
| 0xFF08 | RIS    | RO | 0x00 | Raw Interrupt Status |
| 0xFF0C | IC     | WO | 0x00 | Interrupt Clear |

## I3C Controller Registers

| Offset | Name | Access | Reset | Description |
|--------|------|--------|-------|-------------|
| 0x00   | PRESCALE | RW | 0x01 | Clock Prescaler |
| 0x04   | CTRL     | RW | 0x00 | Control Register |
| 0x08   | DATA     | RW | 0x00 | Data Register |
| 0x0C   | CMD      | WO | 0x00 | Command Register |
| 0x10   | STATUS   | RO | 0x00 | Status Register |
| 0xFF00 | IM       | RW | 0x00 | Interrupt Mask |
| 0xFF04 | MIS      | RO | 0x00 | Masked Interrupt Status |
| 0xFF08 | RIS      | RO | 0x00 | Raw Interrupt Status |
| 0xFF0C | IC       | WO | 0x00 | Interrupt Clear |

## GPIO Controller Registers

| Offset | Name | Access | Reset | Description |
|--------|------|--------|-------|-------------|
| 0x00   | DATAI | RO | 0x00 | Data Input Register |
| 0x04   | DATAO | RW | 0x00 | Data Output Register |
| 0x08   | DIR   | RW | 0x00 | Direction Register (0=input, 1=output) |
| 0xFF00 | IM    | RW | 0x00 | Interrupt Mask |
| 0xFF04 | MIS   | RO | 0x00 | Masked Interrupt Status |
| 0xFF08 | RIS   | RO | 0x00 | Raw Interrupt Status |
| 0xFF0C | IC    | WO | 0x00 | Interrupt Clear |

## Interrupt Mapping

| IRQ Line | Source | Description |
|----------|--------|-------------|
| user_irq[0] | SPI Masters | OR of all 4 SPI master interrupts |
| user_irq[1] | I3C Controller | I3C controller interrupt |
| user_irq[2] | GPIO | GPIO edge-detect interrupts |