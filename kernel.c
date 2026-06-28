typedef unsigned char byte;
typedef unsigned short word;
typedef unsigned long dword;

extern const unsigned char fontdata[256 * 16];

#define BLACK   		0
#define BRRED   		1
#define BRGREEN    		2
#define BRYELLOW		3
#define BRBLUE  		4
#define BRPURPLE		5
#define LBRBLUE 		6
#define WHITE   		7
#define BRGREY	    	8
#define DKRED   		9
#define DKGREEN 		10
#define DKYELLOW		11
#define DKCYAN	    	12
#define DKPURPLE		13
#define LDKBLUE 		14
#define DKGREY  		15

void io_hlt();

void io_sti();
void io_cli();
void io_stihlt();

void io_in8();
void io_in16();
void io_in32();

void io_out8();
void io_out16();
void io_out32();

int load_eflags();
void store_eflags();

// clang_func

struct BootInfo{ // 
	char vmode;
	short scrnx, scrny;
	char *vram;
};

void init_palette();
void set_palette(int start,int end, unsigned char *rgb);
void rectfill(unsigned char* vram, int xsize, unsigned char c, int x0, int y0, int x1, int y1);
void putfont8(char* screen, int xsize, int x, int y, char c, char *font);

void drawScreen(char* vram1, int x, int y){
    char *vram;
    int xsize = x, ysize = y;
    vram = vram1;

    rectfill(vram, xsize, LDKBLUE, 	0,  0, 			xsize - 1, 	ysize - 1);

    rectfill(vram, xsize, BRGREY,   0,  ysize - 28, xsize -  1, ysize - 28);
	rectfill(vram, xsize, WHITE,    0,  ysize - 27, xsize -  1, ysize - 27);
	rectfill(vram, xsize, BRGREY,   0,  ysize - 26, xsize -  1, ysize -  1);

    return ;
}

void init(struct BootInfo* binfo){
	binfo->vram = (char*) 0xa0000;
	binfo->scrnx = 320;
	binfo->scrny = 200;
	binfo->vmode = 8;
}

void kmain() {
	io_cli();
	struct BootInfo* binfo = (struct BootInfo*) 0x8ff00;
	init(binfo);

    init_palette();

    drawScreen(binfo->vram, binfo->scrnx, binfo->scrny);

	putfont8(binfo->vram,binfo->scrnx,10,10,BLACK,fontdata + 'A' * 16);
    for(;;){
        io_hlt();
    }
}

void init_palette(void)
{
	static unsigned char table_rgb[16 * 3] = {
		0x00, 0x00, 0x00,	/*  0:黑 */
		0xff, 0x00, 0x00,	/*  1:梁红 */
		0x00, 0xff, 0x00,	/*  2:亮绿 */
		0xff, 0xff, 0x00,	/*  3:亮黄 */
		0x00, 0x00, 0xff,	/*  4:亮蓝 */
		0xff, 0x00, 0xff,	/*  5:亮紫 */
		0x00, 0xff, 0xff,	/*  6:浅亮蓝 */
		0xff, 0xff, 0xff,	/*  7:白 */
		0xc6, 0xc6, 0xc6,	/*  8:亮灰 */
		0x84, 0x00, 0x00,	/*  9:暗红 */
		0x00, 0x84, 0x00,	/* 10:暗绿 */
		0x84, 0x84, 0x00,	/* 11:暗黄 */
		0x00, 0x00, 0x84,	/* 12:暗青 */
		0x84, 0x00, 0x84,	/* 13:暗紫 */
		0x00, 0x84, 0x84,	/* 14:浅暗蓝 */
		0x84, 0x84, 0x84	/* 15:暗灰 */
	};
	set_palette(0, 15, table_rgb);
	return;
}

void set_palette(int start, int end, unsigned char *rgb)
{
	int i, eflags;
	eflags = load_eflags();	/* 记录中断许可标志的值 */
	io_cli(); 					/* 将中断许可标志置为0,禁止中断 */
	io_out8(0x03c8, start);
	for (i = start; i <= end; i++) {
		io_out8(0x03c9, rgb[0] / 4);
		io_out8(0x03c9, rgb[1] / 4);
		io_out8(0x03c9, rgb[2] / 4);
		rgb += 3;
	}
	store_eflags(eflags);	/* 复原中断许可标志 */
	return;
}

void rectfill(unsigned char* vram, int xsize, unsigned char c, int x0, int y0, int x1, int y1){
    for (int y = y0; y <= y1; y++){
        for (int x = x0; x < x1; x++){
            vram[y * xsize + x] = c;
        }
    }
}

void putfont8(char* screen, int xsize, int x, int y, char c, char *font){
	char d;
	char *p;
	for (int i = 0;i < 16;i++) {
		d = font[i];
		p = screen + (y+i) * xsize + x;
		if ((d & 0x80) != 0) { p[0] = c; }
		if ((d & 0x40) != 0) { p[1] = c; }
		if ((d & 0x20) != 0) { p[2] = c; }
		if ((d & 0x10) != 0) { p[3] = c; }
		if ((d & 0x08) != 0) { p[4] = c; }
		if ((d & 0x04) != 0) { p[5] = c; }
		if ((d & 0x02) != 0) { p[6] = c; }
		if ((d & 0x01) != 0) { p[7] = c; }
	}
}