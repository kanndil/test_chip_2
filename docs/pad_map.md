# Pad Map

## Default Pad Assignments

| Pad Index | Signal | Direction | Type | Description |
|-----------|--------|-----------|------|-------------|
| 8  | SPI0_MOSI | Output | Push-pull | SPI Master 0 MOSI |
| 9  | SPI0_MISO | Input  | Input     | SPI Master 0 MISO |
| 10 | SPI0_SCLK | Output | Push-pull | SPI Master 0 Clock |
| 11 | SPI0_CSB  | Output | Push-pull | SPI Master 0 Chip Select |
| 12 | SPI1_MOSI | Output | Push-pull | SPI Master 1 MOSI |
| 13 | SPI1_MISO | Input  | Input     | SPI Master 1 MISO |
| 14 | SPI1_SCLK | Output | Push-pull | SPI Master 1 Clock |
| 15 | SPI1_CSB  | Output | Push-pull | SPI Master 1 Chip Select |
| 16 | SPI2_MOSI | Output | Push-pull | SPI Master 2 MOSI |
| 17 | SPI2_MISO | Input  | Input     | SPI Master 2 MISO |
| 18 | SPI2_SCLK | Output | Push-pull | SPI Master 2 Clock |
| 19 | SPI2_CSB  | Output | Push-pull | SPI Master 2 Chip Select |
| 20 | SPI3_MOSI | Output | Push-pull | SPI Master 3 MOSI |
| 21 | SPI3_MISO | Input  | Input     | SPI Master 3 MISO |
| 22 | SPI3_SCLK | Output | Push-pull | SPI Master 3 Clock |
| 23 | SPI3_CSB  | Output | Push-pull | SPI Master 3 Chip Select |
| 24 | I3C_SCL   | Bidir  | Open-drain | I3C Clock Line |
| 25 | I3C_SDA   | Bidir  | Open-drain | I3C Data Line |
| 26 | GPIO0     | Bidir  | Configurable | GPIO Line 0 |
| 27 | GPIO1     | Bidir  | Configurable | GPIO Line 1 |

## Unused Pads

Pads 0-7 and 28-37 are configured as inputs (high-Z) and tied to ground output.

## Changing Pad Assignments

To change the pad assignments, modify the pad connection section in `verilog/rtl/user_project.v`:

```verilog
// SPI0: MOSI=8, MISO=9, SCLK=10, CSB=11
// SPI1: MOSI=12, MISO=13, SCLK=14, CSB=15  
// SPI2: MOSI=16, MISO=17, SCLK=18, CSB=19
// SPI3: MOSI=20, MISO=21, SCLK=22, CSB=23
// I3C: SCL=24, SDA=25
// GPIO: GPIO0=26, GPIO1=27
```

Update the assignments in the IO pad connections section and ensure the unused IO pins section is updated accordingly.

## Pad Configuration Notes

- **SPI signals**: Use push-pull outputs for MOSI, SCLK, and CSB. MISO is configured as input.
- **I3C signals**: Use open-drain configuration (io_oeb controlled by the IP core) for proper I3C/I2C operation.
- **GPIO signals**: Direction controlled by the GPIO controller's DIR register.
- **Unused pads**: Configured as inputs with output tied to ground to minimize power consumption.