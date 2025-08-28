import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, ClockCycles
from caravel_cocotb.caravel_interfaces import test_configure, report_test

@cocotb.test()
@report_test
async def user_project_test(dut):
    """Test the custom user project with SPI, I3C, and GPIO peripherals"""
    
    # Configure Caravel environment
    caravelEnv = await test_configure(dut)
    
    # Test addresses
    SPI0_BASE = 0x30000000
    SPI1_BASE = 0x30000400
    I3C_BASE = 0x30001000
    GPIO_BASE = 0x30002000
    
    # Test SPI0 register access
    cocotb.log.info("Testing SPI0 register access...")
    
    # Write to SPI0 prescaler register
    await caravelEnv.write_wb(SPI0_BASE + 0x10, 0x10)
    
    # Read back prescaler register
    prescaler_val = await caravelEnv.read_wb(SPI0_BASE + 0x10)
    assert prescaler_val == 0x10, f"SPI0 prescaler mismatch: expected 0x10, got {prescaler_val:02x}"
    
    # Test SPI0 configuration register
    await caravelEnv.write_wb(SPI0_BASE + 0x08, 0x03)  # CPOL=1, CPHA=1
    cfg_val = await caravelEnv.read_wb(SPI0_BASE + 0x08)
    assert (cfg_val & 0x03) == 0x03, f"SPI0 config mismatch: expected 0x03, got {cfg_val:02x}"
    
    # Test I3C register access
    cocotb.log.info("Testing I3C register access...")
    
    # Write to I3C prescaler register
    await caravelEnv.write_wb(I3C_BASE + 0x00, 0x20)
    
    # Read back prescaler register
    i3c_prescaler = await caravelEnv.read_wb(I3C_BASE + 0x00)
    assert i3c_prescaler == 0x20, f"I3C prescaler mismatch: expected 0x20, got {i3c_prescaler:02x}"
    
    # Test GPIO register access
    cocotb.log.info("Testing GPIO register access...")
    
    # Set GPIO direction (pin 0 = output, pin 1 = input)
    await caravelEnv.write_wb(GPIO_BASE + 0x08, 0x01)
    
    # Read back direction register
    dir_val = await caravelEnv.read_wb(GPIO_BASE + 0x08)
    assert (dir_val & 0x03) == 0x01, f"GPIO direction mismatch: expected 0x01, got {dir_val:02x}"
    
    # Write to GPIO output
    await caravelEnv.write_wb(GPIO_BASE + 0x04, 0x01)
    
    # Read back output register
    out_val = await caravelEnv.read_wb(GPIO_BASE + 0x04)
    assert (out_val & 0x01) == 0x01, f"GPIO output mismatch: expected 0x01, got {out_val:02x}"
    
    # Test address decode - access invalid address should return 0
    cocotb.log.info("Testing address decode...")
    invalid_val = await caravelEnv.read_wb(0x30003000)  # Invalid address
    assert invalid_val == 0, f"Invalid address should return 0, got {invalid_val:08x}"
    
    # Test multiple SPI instances
    cocotb.log.info("Testing multiple SPI instances...")
    
    # Configure different prescalers for each SPI
    await caravelEnv.write_wb(SPI0_BASE + 0x10, 0x10)
    await caravelEnv.write_wb(SPI1_BASE + 0x10, 0x20)
    
    # Verify each SPI has correct prescaler
    spi0_pr = await caravelEnv.read_wb(SPI0_BASE + 0x10)
    spi1_pr = await caravelEnv.read_wb(SPI1_BASE + 0x10)
    
    assert spi0_pr == 0x10, f"SPI0 prescaler mismatch: expected 0x10, got {spi0_pr:02x}"
    assert spi1_pr == 0x20, f"SPI1 prescaler mismatch: expected 0x20, got {spi1_pr:02x}"
    
    cocotb.log.info("All tests passed!")