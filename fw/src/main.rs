#![no_std]
#![no_main]

mod flash;

use core::{ops::Deref, panic::PanicInfo};

use cortex_m_rt::entry;
use stm32f3::stm32f302::Peripherals;

#[panic_handler]
fn panic(pinfo: &PanicInfo) -> ! {
    loop {}
}

#[entry]
fn main() -> ! {
    let periph = Peripherals::take().unwrap();

    loop {
        cortex_m::asm::delay(1);
    }
}
