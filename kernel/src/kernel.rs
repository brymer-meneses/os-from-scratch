#![no_std]
#![no_main]
mod vga_buffer;
use core::panic::PanicInfo;

// should print green if it panics
#[panic_handler]
fn panic(_info: &PanicInfo) -> ! {
    // Get a mutable pointer to the video memory
    let video_memory = VIDEO_ADDRESS as *mut u16;

    // Clear each character cell
    for i in 0..MAX_ROWS * MAX_COLS {
        unsafe {
            video_memory
                .add(i)
                .write_volatile((b' ' as u16) | ((0x20 as u16) << 8));
        }
    }
    loop {}
}

const VIDEO_ADDRESS: *mut u8 = 0xb8000 as *mut u8;
const MAX_ROWS: usize = 25;
const MAX_COLS: usize = 80;
const WHITE_ON_BLACK: u8 = 0x0f;

#[no_mangle]
pub extern "C" fn _start() -> ! {
    vga_buffer::print_something();
    loop {}
}
