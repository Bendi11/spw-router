#![no_std]
#![no_main]

use core::panic::PanicInfo;

use cortex_m_rt::entry;
use stm32f3::stm32f302::Peripherals;

#[panic_handler]
fn panic(pinfo: &PanicInfo) -> ! {
    loop {}
}

#[entry]
fn main() -> ! {
    let gpio = Peripherals::take().unwrap();

    loop {}
}
