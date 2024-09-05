use stm32f3::stm32f302::{GPIOB, RCC, SPI2};

/// Controller for SPI flash connected via SPI2
pub struct Flash {
    pub spi: SPI2,
}

impl Flash {
    /// Create a new flash memory controller using the given SPI2 register block.
    /// Also selects AF5 for GPIO pins B12-15
    pub fn new(rcc: &mut RCC, gpiob: &mut GPIOB, spi: SPI2) -> Self {
        gpiob.afrh.modify(|_, w| {
            w.afrh12()
                .af5()
                .afrh13()
                .af5()
                .afrh14()
                .af5()
                .afrh15()
                .af5()
        });

        spi.cr1.write(|w|
            w
                .bidimode().unidirectional()
                .crcen().disabled()
                .mstr().master()
        );

        spi.cr2.write(|w|
            w
                .ds().eight_bit()
                .rxneie().not_masked()
                .nssp().pulse_generated()
                .ssoe().enabled()
        );
        
        spi.cr1.modify(|_, w| w.spe().enabled());

        rcc.apb1enr.modify(|_, w| w.spi2en().bit(true));


        Self { spi }
    }
}
