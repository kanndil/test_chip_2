#include <firmware_apis.h>

void user_project_test() {
    // Configure management GPIO for signaling
    ManagmentGpio_outputEnable();
    ManagmentGpio_write(0);
    
    // Enable user project power
    PowerGpio_outputEnable();
    PowerGpio_write(1);
    
    // Configure user project pads
    // SPI pads (8-23): configure as outputs for MOSI/SCLK/CSB, inputs for MISO
    for (int i = 8; i <= 23; i++) {
        if ((i == 9) || (i == 13) || (i == 17) || (i == 21)) {
            // MISO pins - configure as inputs
            GPIOs_configure(i, GPIO_MODE_USER_STD_INPUT_NOPULL);
        } else {
            // MOSI/SCLK/CSB pins - configure as outputs
            GPIOs_configure(i, GPIO_MODE_USER_STD_OUTPUT);
        }
    }
    
    // I3C pads (24-25): configure as bidirectional
    GPIOs_configure(24, GPIO_MODE_USER_STD_BIDIRECTIONAL);
    GPIOs_configure(25, GPIO_MODE_USER_STD_BIDIRECTIONAL);
    
    // GPIO pads (26-27): configure as bidirectional
    GPIOs_configure(26, GPIO_MODE_USER_STD_BIDIRECTIONAL);
    GPIOs_configure(27, GPIO_MODE_USER_STD_BIDIRECTIONAL);
    
    // Signal ready to Python testbench
    ManagmentGpio_write(1);
    
    // Keep firmware running
    while (1) {
        // Can add additional test logic here if needed
    }
}