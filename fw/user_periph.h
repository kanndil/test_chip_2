#ifndef USER_PERIPH_H
#define USER_PERIPH_H

#include <stdint.h>

// Base addresses
#define USER_BASE_ADDR      0x30000000
#define SPI0_BASE_ADDR      0x30000000
#define SPI1_BASE_ADDR      0x30000400
#define SPI2_BASE_ADDR      0x30000800
#define SPI3_BASE_ADDR      0x30000C00
#define I3C_BASE_ADDR       0x30001000
#define GPIO_BASE_ADDR      0x30002000

// SPI Register offsets
#define SPI_RXDATA_OFFSET           0x00
#define SPI_TXDATA_OFFSET           0x04
#define SPI_CFG_OFFSET              0x08
#define SPI_CTRL_OFFSET             0x0C
#define SPI_PR_OFFSET               0x10
#define SPI_STATUS_OFFSET           0x14
#define SPI_RX_FIFO_LEVEL_OFFSET    0x18
#define SPI_RX_FIFO_THRESHOLD_OFFSET 0x1C
#define SPI_RX_FIFO_FLUSH_OFFSET    0x20
#define SPI_TX_FIFO_LEVEL_OFFSET    0x24
#define SPI_TX_FIFO_THRESHOLD_OFFSET 0x28
#define SPI_TX_FIFO_FLUSH_OFFSET    0x2C
#define SPI_IM_OFFSET               0xFF00
#define SPI_MIS_OFFSET              0xFF04
#define SPI_RIS_OFFSET              0xFF08
#define SPI_IC_OFFSET               0xFF0C

// I3C Register offsets
#define I3C_PRESCALE_OFFSET         0x00
#define I3C_CTRL_OFFSET             0x04
#define I3C_DATA_OFFSET             0x08
#define I3C_CMD_OFFSET              0x0C
#define I3C_STATUS_OFFSET           0x10
#define I3C_IM_OFFSET               0xFF00
#define I3C_MIS_OFFSET              0xFF04
#define I3C_RIS_OFFSET              0xFF08
#define I3C_IC_OFFSET               0xFF0C

// GPIO Register offsets
#define GPIO_DATAI_OFFSET           0x00
#define GPIO_DATAO_OFFSET           0x04
#define GPIO_DIR_OFFSET             0x08
#define GPIO_IM_OFFSET              0xFF00
#define GPIO_MIS_OFFSET             0xFF04
#define GPIO_RIS_OFFSET             0xFF08
#define GPIO_IC_OFFSET              0xFF0C

// Register access macros
#define REG32(addr) (*(volatile uint32_t *)(addr))

// SPI register access macros
#define SPI_REG(base, offset) REG32((base) + (offset))
#define SPI0_REG(offset) SPI_REG(SPI0_BASE_ADDR, offset)
#define SPI1_REG(offset) SPI_REG(SPI1_BASE_ADDR, offset)
#define SPI2_REG(offset) SPI_REG(SPI2_BASE_ADDR, offset)
#define SPI3_REG(offset) SPI_REG(SPI3_BASE_ADDR, offset)

// I3C register access macros
#define I3C_REG(offset) REG32(I3C_BASE_ADDR + (offset))

// GPIO register access macros
#define GPIO_REG(offset) REG32(GPIO_BASE_ADDR + (offset))

// SPI Control register bits
#define SPI_CTRL_GO         (1 << 0)
#define SPI_CTRL_BSY        (1 << 1)
#define SPI_CTRL_NEG        (1 << 2)

// SPI Configuration register bits
#define SPI_CFG_CPOL        (1 << 0)
#define SPI_CFG_CPHA        (1 << 1)

// SPI Status register bits
#define SPI_STATUS_TIP      (1 << 0)
#define SPI_STATUS_IF       (1 << 1)
#define SPI_STATUS_RXNE     (1 << 2)
#define SPI_STATUS_TXE      (1 << 3)
#define SPI_STATUS_RXFULL   (1 << 4)
#define SPI_STATUS_TXEMPTY  (1 << 5)

// GPIO Direction register bits
#define GPIO_DIR_INPUT      0
#define GPIO_DIR_OUTPUT     1

// Function prototypes
void spi_init(uint32_t base_addr, uint8_t prescaler, uint8_t config);
uint8_t spi_transfer(uint32_t base_addr, uint8_t data);
void spi_write(uint32_t base_addr, uint8_t data);
uint8_t spi_read(uint32_t base_addr);

void i3c_init(uint8_t prescaler);
void i3c_write(uint8_t addr, uint8_t data);
uint8_t i3c_read(uint8_t addr);

void gpio_init(void);
void gpio_set_direction(uint8_t pin, uint8_t dir);
void gpio_write(uint8_t pin, uint8_t value);
uint8_t gpio_read(uint8_t pin);
void gpio_enable_interrupt(uint8_t pin);
void gpio_clear_interrupt(uint8_t pin);

#endif // USER_PERIPH_H