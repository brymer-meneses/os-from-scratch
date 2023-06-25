#define VIDEO_ADDRESS 0xb8000
#define MAX_ROWS 25
#define MAX_COLS 80

#define REG_SCREEN_CTRL 0x3D4
#define REG_SCREEN_DATA 0x3D5

#define WHITE_ON_BLACK 0x0f

int main() {
  char* video_memory = (char*) 0xb8000;
  *video_memory = 'X';

  return 0;
}
