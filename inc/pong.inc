; Macros
        %define sizeof(name) name%+_size
        %define L(x) __?utf16?__(x)

; Constants
        %define FRAMEBUFFER_WIDTH 640
        %define FRAMEBUFFER_HEIGHT 480
	%define FRAMEBUFFER_SIZE (FRAMEBUFFER_WIDTH * FRAMEBUFFER_HEIGHT)
