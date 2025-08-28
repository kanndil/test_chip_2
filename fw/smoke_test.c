#include "user_periph.h"
#include "firmware_apis.h"

void smoke_test() {
    // Initialize peripherals
    spi_init(SPI0_BASE_ADDR, 0x10, 0x00);  // SPI0 with prescaler 16
    i3c_init(0x10);                        // I3C with prescaler 16
    gpio_init();                           // GPIO initialization
    
    // Configure GPIO pins
    gpio_set_direction(0, GPIO_DIR_OUTPUT);
    gpio_set_direction(1, GPIO_DIR_INPUT);
    
    // Test SPI loopback (connect MOSI to MISO externally)
    uint8_t spi_test_data = 0xA5;
    uint8_t spi_result = spi_transfer(SPI0_BASE_ADDR, spi_test_data);
    
    // Test GPIO output
    gpio_write(0, 1);
    
    // Test I3C (basic register access)
    I3C_REG(I3C_PRESCALE_OFFSET) = 0x10;
    uint32_t i3c_prescale = I3C_REG(I3C_PRESCALE_OFFSET);
    
    // Signal test completion
    if (spi_result == spi_test_data && i3c_prescale == 0x10) {
        // Test passed - signal via management GPIO
        ManagmentGpio_write(1);
        print("Smoke test PASSED\n");
    } else {
        // Test failed
        ManagmentGpio_write(0);
        print("Smoke test FAILED\n");
    }
}

// Simple peripheral functions
void spi_init(uint32_t base_addr, uint8_t prescaler, uint8_t config) {
    SPI_REG(base_addr, SPI_PR_OFFSET) = prescaler;
    SPI_REG(base_addr, SPI_CFG_OFFSET) = config;
}

uint8_t spi_transfer(uint32_t base_addr, uint8_t data) {
    // Write data and start transfer
    SPI_REG(base_addr, SPI_TXDATA_OFFSET) = data;
    SPI_REG(base_addr, SPI_CTRL_OFFSET) = SPI_CTRL_GO;
    
    // Wait for completion
    while (SPI_REG(base_addr, SPI_CTRL_OFFSET) & SPI_CTRL_BSY);
    
    // Read result
    return SPI_REG(base_addr, SPI_RXDATA_OFFSET) & 0xFF;
}

void i3c_init(uint8_t prescaler) {
    I3C_REG(I3C_PRESCALE_OFFSET) = prescaler;
}

void gpio_init(void) {
    // Clear all GPIO interrupts
    GPIO_REG(GPIO_IC_OFFSET) = 0xFF;
}

void gpio_set_direction(uint8_t pin, uint8_t dir) {
    uint32_t reg_val = GPIO_REG(GPIO_DIR_OFFSET);
    if (dir == GPIO_DIR_OUTPUT) {
        reg_val |= (1 << pin);
    } else {
        reg_val &= ~(1 << pin);
    }
    GPIO_REG(GPIO_DIR_OFFSET) = reg_val;
}

void gpio_write(uint8_t pin, uint8_t value) {
    uint32_t reg_val = GPIO_REG(GPIO_DATAO_OFFSET);
    if (value) {
        reg_val |= (1 << pin);
    } else {
        reg_val &= ~(1 << pin);
    }
    GPIO_REG(GPIO_DATAO_OFFSET) = reg_val;
}

uint8_t gpio_read(uint8_t pin) {
    return (GPIO_REG(GPIO_DATAI_OFFSET) >> pin) & 1;
}