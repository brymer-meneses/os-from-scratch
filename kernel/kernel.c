
#define VIDEO_ADDRESS 0xb8000
#define MAX_ROWS 25
#define MAX_COLS 80

#define WHITE_ON_BLACK 0x0f

void clear_screen() {
    // Get a pointer to the video memory
    char* video_memory = (char*)0xB8000;
    
    // Clear each character cell
    for (int i = 0; i < MAX_ROWS * MAX_COLS * 2; i += 2) {
        video_memory[i] = ' ';
        video_memory[i + 1] = WHITE_ON_BLACK;  // Attribute byte for white-on-black
    }
}

int main() {
  clear_screen();

  return 0;
}
