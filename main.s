	.cpu arm7tdmi
	.eabi_attribute 20, 1
	.eabi_attribute 21, 1
	.eabi_attribute 23, 3
	.eabi_attribute 24, 1
	.eabi_attribute 25, 1
	.eabi_attribute 26, 1
	.eabi_attribute 30, 2
	.eabi_attribute 34, 0
	.eabi_attribute 18, 4
	.file	"main.c"
	.text
	.align	2
	.global	goToStart
	.arch armv4t
	.syntax unified
	.arm
	.fpu softvfp
	.type	goToStart, %function
goToStart:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, lr}
	mov	r5, #67108864
	ldr	r3, .L4
	mov	lr, pc
	bx	r3
	ldr	r3, .L4+4
	mov	lr, pc
	bx	r3
	ldr	r2, .L4+8
	ldr	r4, .L4+12
	strh	r2, [r5]	@ movhi
	mov	r3, #256
	mov	r2, #83886080
	mov	r0, #3
	ldr	r1, .L4+16
	mov	lr, pc
	bx	r4
	mov	r3, #8704
	mov	r2, #100663296
	mov	r0, #3
	ldr	r1, .L4+20
	mov	lr, pc
	bx	r4
	mov	r3, #1024
	mov	r0, #3
	ldr	r2, .L4+24
	ldr	r1, .L4+28
	mov	lr, pc
	bx	r4
	mov	r2, #4608
	mov	r3, #256
	strh	r2, [r5]	@ movhi
	mov	r0, #3
	ldr	r2, .L4+32
	ldr	r1, .L4+36
	mov	lr, pc
	bx	r4
	mov	r0, #3
	mov	r3, #16384
	ldr	r2, .L4+40
	ldr	r1, .L4+44
	mov	lr, pc
	bx	r4
	mov	r1, #0
	ldr	r2, .L4+48
	ldr	r3, .L4+52
	str	r1, [r2]
	mov	lr, pc
	bx	r3
	ldr	r3, .L4+56
	mov	r2, #1
	ldr	r1, [r3]
	ldr	r0, .L4+60
	ldr	r3, .L4+64
	mov	lr, pc
	bx	r3
	pop	{r4, r5, r6, lr}
	bx	lr
.L5:
	.align	2
.L4:
	.word	hideSprites
	.word	waitForVBlank
	.word	4611
	.word	DMANow
	.word	titlePal
	.word	titleTiles
	.word	100726784
	.word	titleMap
	.word	83886592
	.word	spritesheetPal
	.word	100728832
	.word	spritesheetTiles
	.word	state
	.word	stopSound
	.word	menuSong_length
	.word	menuSong_data
	.word	playSoundA
	.size	goToStart, .-goToStart
	.align	2
	.global	initialize
	.syntax unified
	.arm
	.fpu softvfp
	.type	initialize, %function
initialize:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, lr}
	mov	r4, #3
	mov	r3, #0
	mov	r2, #67108864
	mov	ip, #4864
	mov	r1, #57088
	ldr	lr, .L8
	ldr	r0, .L8+4
	str	r4, [lr]
	ldr	lr, .L8+8
	str	r3, [r0]
	ldrh	lr, [lr, #48]
	ldr	r0, .L8+12
	strh	lr, [r0]	@ movhi
	ldr	r0, .L8+16
	strh	r3, [r0]	@ movhi
	ldr	r0, .L8+20
	strh	ip, [r2]	@ movhi
	strh	r1, [r2, #10]	@ movhi
	str	r3, [r0]
	ldr	r1, .L8+24
	strh	r3, [r2, #18]	@ movhi
	strh	r3, [r2, #16]	@ movhi
	mov	lr, pc
	bx	r1
	ldr	r3, .L8+28
	mov	lr, pc
	bx	r3
	mov	r1, #121
	mov	r2, #16
	ldr	r3, .L8+32
	stm	r3, {r1, r4}
	pop	{r4, lr}
	str	r2, [r3, #8]
	str	r2, [r3, #12]
	b	goToStart
.L9:
	.align	2
.L8:
	.word	life
	.word	delivered
	.word	67109120
	.word	buttons
	.word	oldButtons
	.word	t_select
	.word	setupSounds
	.word	setupTimerInterrupts
	.word	arrow
	.size	initialize, .-initialize
	.align	2
	.syntax unified
	.arm
	.fpu softvfp
	.type	instruction.part.0, %function
instruction.part.0:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L12
	ldrh	r3, [r3]
	tst	r3, #4
	bxne	lr
	b	initialize
.L13:
	.align	2
.L12:
	.word	buttons
	.size	instruction.part.0, .-instruction.part.0
	.set	pause.part.0,instruction.part.0
	.align	2
	.syntax unified
	.arm
	.fpu softvfp
	.type	win.part.0, %function
win.part.0:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L16
	ldrh	r3, [r3]
	tst	r3, #8
	bxne	lr
	b	initialize
.L17:
	.align	2
.L16:
	.word	buttons
	.size	win.part.0, .-win.part.0
	.set	lose.part.0,win.part.0
	.align	2
	.global	initArrow
	.syntax unified
	.arm
	.fpu softvfp
	.type	initArrow, %function
initArrow:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	mov	r2, #16
	mov	r0, #121
	mov	r1, #3
	ldr	r3, .L19
	stm	r3, {r0, r1}
	str	r2, [r3, #8]
	str	r2, [r3, #12]
	bx	lr
.L20:
	.align	2
.L19:
	.word	arrow
	.size	initArrow, .-initArrow
	.align	2
	.global	drawArrow
	.syntax unified
	.arm
	.fpu softvfp
	.type	drawArrow, %function
drawArrow:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	mov	r1, #0
	ldr	r3, .L22
	ldm	r3, {r0, r2}
	ldr	r3, .L22+4
	orr	r2, r2, #16384
	strh	r2, [r3, #114]	@ movhi
	strh	r0, [r3, #112]	@ movhi
	strh	r1, [r3, #116]	@ movhi
	bx	lr
.L23:
	.align	2
.L22:
	.word	arrow
	.word	shadowOAM
	.size	drawArrow, .-drawArrow
	.align	2
	.global	goToInstruction
	.syntax unified
	.arm
	.fpu softvfp
	.type	goToInstruction, %function
goToInstruction:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, lr}
	mov	r5, #67108864
	ldr	r3, .L26
	mov	lr, pc
	bx	r3
	ldr	r4, .L26+4
	mov	r3, #512
	mov	r2, #117440512
	mov	r0, #3
	ldr	r1, .L26+8
	mov	lr, pc
	bx	r4
	ldr	r2, .L26+12
	mov	r3, #256
	strh	r2, [r5]	@ movhi
	mov	r0, #3
	mov	r2, #83886080
	ldr	r1, .L26+16
	mov	lr, pc
	bx	r4
	mov	r2, #100663296
	mov	r0, #3
	ldr	r3, .L26+20
	ldr	r1, .L26+24
	mov	lr, pc
	bx	r4
	mov	r3, #1024
	mov	r0, #3
	ldr	r2, .L26+28
	ldr	r1, .L26+32
	mov	lr, pc
	bx	r4
	mov	r2, #4608
	ldr	r3, .L26+36
	strh	r2, [r5]	@ movhi
	mov	lr, pc
	bx	r3
	mov	r2, #1
	ldr	r3, .L26+40
	pop	{r4, r5, r6, lr}
	str	r2, [r3]
	bx	lr
.L27:
	.align	2
.L26:
	.word	hideSprites
	.word	DMANow
	.word	shadowOAM
	.word	4611
	.word	instructionPal
	.word	8864
	.word	instructionTiles
	.word	100726784
	.word	instructionMap
	.word	waitForVBlank
	.word	state
	.size	goToInstruction, .-goToInstruction
	.align	2
	.global	instruction
	.syntax unified
	.arm
	.fpu softvfp
	.type	instruction, %function
instruction:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L30
	ldrh	r3, [r3]
	tst	r3, #4
	bxeq	lr
	b	instruction.part.0
.L31:
	.align	2
.L30:
	.word	oldButtons
	.size	instruction, .-instruction
	.align	2
	.global	goToGame
	.syntax unified
	.arm
	.fpu softvfp
	.type	goToGame, %function
goToGame:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	mov	r3, #0
	push	{r4, r5, r6, lr}
	mov	r4, #67108864
	ldr	ip, .L34
	ldr	r0, .L34+4
	ldr	r1, .L34+8
	ldr	r2, .L34+12
	str	r3, [ip]
	str	r3, [r0]
	str	r3, [r1]
	mov	lr, pc
	bx	r2
	ldr	r3, .L34+16
	mov	lr, pc
	bx	r3
	ldr	r2, .L34+20
	ldr	r5, .L34+24
	strh	r2, [r4]	@ movhi
	mov	r3, #256
	mov	r2, #83886080
	mov	r0, #3
	ldr	r1, .L34+28
	mov	lr, pc
	bx	r5
	mov	r0, #3
	ldr	r3, .L34+32
	ldr	r2, .L34+36
	ldr	r1, .L34+40
	mov	lr, pc
	bx	r5
	mov	r3, #3072
	mov	r0, #3
	ldr	r2, .L34+44
	ldr	r1, .L34+48
	mov	lr, pc
	bx	r5
	mov	r0, #4352
	mov	r1, #2
	ldr	r3, .L34+52
	ldr	r2, .L34+56
	strh	r3, [r4, #8]	@ movhi
	strh	r0, [r4]	@ movhi
	ldr	r3, .L34+60
	str	r1, [r2]
	mov	lr, pc
	bx	r3
	ldr	r3, .L34+64
	mov	r2, #1
	ldr	r1, [r3]
	ldr	r0, .L34+68
	ldr	r3, .L34+72
	mov	lr, pc
	bx	r3
	pop	{r4, r5, r6, lr}
	bx	lr
.L35:
	.align	2
.L34:
	.word	paused
	.word	won
	.word	lost
	.word	hideSprites
	.word	waitForVBlank
	.word	4356
	.word	DMANow
	.word	levelPal
	.word	12064
	.word	100679680
	.word	levelTiles
	.word	100720640
	.word	levelMap
	.word	-25084
	.word	state
	.word	stopSound
	.word	gameSong_length
	.word	gameSong_data
	.word	playSoundA
	.size	goToGame, .-goToGame
	.align	2
	.global	start
	.syntax unified
	.arm
	.fpu softvfp
	.type	start, %function
start:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, lr}
	ldr	r3, .L55
	mov	lr, pc
	bx	r3
	mov	r1, #0
	ldr	r5, .L55+4
	ldr	r3, [r5, #4]
	ldr	r4, .L55+8
	ldr	r0, [r5]
	orr	r3, r3, #16384
	strh	r3, [r4, #114]	@ movhi
	strh	r0, [r4, #112]	@ movhi
	strh	r1, [r4, #116]	@ movhi
	ldr	r2, .L55+12
	mov	lr, pc
	bx	r2
	mov	r1, r4
	mov	r3, #512
	mov	r2, #117440512
	mov	r0, #3
	ldr	r4, .L55+16
	mov	lr, pc
	bx	r4
	ldr	r3, .L55+20
	ldrh	r3, [r3]
	tst	r3, #128
	beq	.L37
	ldr	r2, .L55+24
	ldrh	r2, [r2]
	tst	r2, #128
	beq	.L52
.L37:
	tst	r3, #64
	beq	.L38
	ldr	r2, .L55+24
	ldrh	r2, [r2]
	ands	r2, r2, #64
	beq	.L53
.L38:
	tst	r3, #8
	beq	.L36
	ldr	r3, .L55+24
	ldrh	r3, [r3]
	tst	r3, #8
	bne	.L36
	ldr	r3, .L55+28
	ldr	r3, [r3]
	cmp	r3, #0
	beq	.L54
	cmp	r3, #1
	beq	.L41
.L36:
	pop	{r4, r5, r6, lr}
	bx	lr
.L53:
	ldr	r1, .L55+28
	ldr	r0, [r1]
	cmp	r0, #1
	ldreq	r0, [r5]
	subeq	r0, r0, #20
	streq	r2, [r1]
	streq	r0, [r5]
	b	.L38
.L52:
	ldr	r2, .L55+28
	ldr	r1, [r2]
	cmp	r1, #0
	moveq	r0, #1
	ldreq	r1, [r5]
	addeq	r1, r1, #20
	streq	r1, [r5]
	streq	r0, [r2]
	b	.L37
.L54:
	ldr	r3, .L55+32
	mov	lr, pc
	bx	r3
	pop	{r4, r5, r6, lr}
	b	goToGame
.L41:
	pop	{r4, r5, r6, lr}
	b	goToInstruction
.L56:
	.align	2
.L55:
	.word	hideSprites
	.word	arrow
	.word	shadowOAM
	.word	waitForVBlank
	.word	DMANow
	.word	oldButtons
	.word	buttons
	.word	t_select
	.word	initGame
	.size	start, .-start
	.align	2
	.global	goToPause
	.syntax unified
	.arm
	.fpu softvfp
	.type	goToPause, %function
goToPause:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, lr}
	mov	r1, #29
	mov	r5, #1
	mov	r6, #67108864
	ldr	r0, .L59
	ldr	r2, .L59+4
	ldr	r3, .L59+8
	str	r5, [r0]
	str	r1, [r2]
	mov	lr, pc
	bx	r3
	ldr	r3, .L59+12
	mov	lr, pc
	bx	r3
	ldr	r4, .L59+16
	mov	r3, #512
	mov	r2, #117440512
	mov	r0, #3
	ldr	r1, .L59+20
	mov	lr, pc
	bx	r4
	ldr	r2, .L59+24
	mov	r3, #256
	strh	r2, [r6]	@ movhi
	mov	r0, #3
	mov	r2, #83886080
	ldr	r1, .L59+28
	mov	lr, pc
	bx	r4
	mov	r2, #100663296
	mov	r0, #3
	ldr	r3, .L59+32
	ldr	r1, .L59+36
	mov	lr, pc
	bx	r4
	mov	r0, #3
	mov	r3, #1024
	ldr	r2, .L59+40
	ldr	r1, .L59+44
	mov	lr, pc
	bx	r4
	mov	r3, #4608
	mov	r1, #3
	ldr	r2, .L59+48
	strh	r3, [r6]	@ movhi
	ldr	r3, .L59+52
	str	r1, [r2]
	mov	lr, pc
	bx	r3
	ldr	r3, .L59+56
	mov	r2, r5
	ldr	r1, [r3]
	ldr	r0, .L59+60
	ldr	r3, .L59+64
	mov	lr, pc
	bx	r3
	pop	{r4, r5, r6, lr}
	bx	lr
.L60:
	.align	2
.L59:
	.word	paused
	.word	upward
	.word	hideSprites
	.word	waitForVBlank
	.word	DMANow
	.word	shadowOAM
	.word	4611
	.word	pausePal
	.word	7888
	.word	pauseTiles
	.word	100726784
	.word	pauseMap
	.word	state
	.word	stopSound
	.word	menuSong_length
	.word	menuSong_data
	.word	playSoundA
	.size	goToPause, .-goToPause
	.align	2
	.global	pause
	.syntax unified
	.arm
	.fpu softvfp
	.type	pause, %function
pause:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, lr}
	ldr	r4, .L69
	ldrh	r3, [r4]
	tst	r3, #8
	beq	.L62
	ldr	r2, .L69+4
	ldrh	r2, [r2]
	tst	r2, #8
	beq	.L68
.L62:
	tst	r3, #4
	popne	{r4, lr}
	bne	pause.part.0
.L61:
	pop	{r4, lr}
	bx	lr
.L68:
	bl	goToGame
	ldrh	r3, [r4]
	b	.L62
.L70:
	.align	2
.L69:
	.word	oldButtons
	.word	buttons
	.size	pause, .-pause
	.align	2
	.global	goToWin
	.syntax unified
	.arm
	.fpu softvfp
	.type	goToWin, %function
goToWin:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, lr}
	mov	r6, #1
	mov	r4, #67108864
	ldr	r2, .L73
	ldr	r3, .L73+4
	str	r6, [r2]
	mov	lr, pc
	bx	r3
	ldr	r3, .L73+8
	mov	lr, pc
	bx	r3
	ldr	r5, .L73+12
	mov	r3, #512
	mov	r2, #117440512
	mov	r0, #3
	ldr	r1, .L73+16
	mov	lr, pc
	bx	r5
	ldr	r2, .L73+20
	mov	r3, #256
	strh	r2, [r4]	@ movhi
	mov	r0, #3
	mov	r2, #83886080
	ldr	r1, .L73+24
	mov	lr, pc
	bx	r5
	mov	r2, #100663296
	mov	r0, #3
	ldr	r3, .L73+28
	ldr	r1, .L73+32
	mov	lr, pc
	bx	r5
	mov	r3, #1024
	mov	r0, #3
	ldr	r2, .L73+36
	ldr	r1, .L73+40
	mov	lr, pc
	bx	r5
	mov	r3, #0
	mov	r2, #4608
	mov	r0, #4
	ldr	r1, .L73+44
	strh	r2, [r4]	@ movhi
	strh	r3, [r4, #22]	@ movhi
	ldr	r2, .L73+48
	strh	r3, [r4, #20]	@ movhi
	str	r0, [r1]
	mov	lr, pc
	bx	r2
	ldr	r3, .L73+52
	mov	r2, r6
	ldr	r1, [r3]
	ldr	r0, .L73+56
	ldr	r3, .L73+60
	mov	lr, pc
	bx	r3
	pop	{r4, r5, r6, lr}
	bx	lr
.L74:
	.align	2
.L73:
	.word	won
	.word	hideSprites
	.word	waitForVBlank
	.word	DMANow
	.word	shadowOAM
	.word	4611
	.word	winPal
	.word	8400
	.word	winTiles
	.word	100726784
	.word	winMap
	.word	state
	.word	stopSound
	.word	winSong_length
	.word	winSong_data
	.word	playSoundA
	.size	goToWin, .-goToWin
	.align	2
	.global	win
	.syntax unified
	.arm
	.fpu softvfp
	.type	win, %function
win:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L77
	ldrh	r3, [r3]
	tst	r3, #8
	bxeq	lr
	b	win.part.0
.L78:
	.align	2
.L77:
	.word	oldButtons
	.size	win, .-win
	.align	2
	.global	goToLose
	.syntax unified
	.arm
	.fpu softvfp
	.type	goToLose, %function
goToLose:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	mov	r1, #1
	push	{r4, r5, r6, lr}
	mov	r4, #67108864
	ldr	r2, .L81
	ldr	r3, .L81+4
	str	r1, [r2]
	mov	lr, pc
	bx	r3
	ldr	r3, .L81+8
	mov	lr, pc
	bx	r3
	ldr	r5, .L81+12
	mov	r3, #512
	mov	r2, #117440512
	mov	r0, #3
	ldr	r1, .L81+16
	mov	lr, pc
	bx	r5
	ldr	r2, .L81+20
	mov	r3, #256
	strh	r2, [r4]	@ movhi
	mov	r0, #3
	mov	r2, #83886080
	ldr	r1, .L81+24
	mov	lr, pc
	bx	r5
	mov	r3, #9472
	mov	r2, #100663296
	mov	r0, #3
	ldr	r1, .L81+28
	mov	lr, pc
	bx	r5
	mov	r0, #3
	mov	r3, #1024
	ldr	r2, .L81+32
	ldr	r1, .L81+36
	mov	lr, pc
	bx	r5
	mov	r5, #0
	mov	r3, #4608
	mov	r1, #5
	ldr	r2, .L81+40
	strh	r3, [r4]	@ movhi
	strh	r5, [r4, #22]	@ movhi
	ldr	r3, .L81+44
	strh	r5, [r4, #20]	@ movhi
	str	r1, [r2]
	mov	lr, pc
	bx	r3
	ldr	r3, .L81+48
	mov	r2, r5
	ldr	r1, [r3]
	ldr	r0, .L81+52
	ldr	r3, .L81+56
	mov	lr, pc
	bx	r3
	pop	{r4, r5, r6, lr}
	bx	lr
.L82:
	.align	2
.L81:
	.word	lost
	.word	hideSprites
	.word	waitForVBlank
	.word	DMANow
	.word	shadowOAM
	.word	4611
	.word	losePal
	.word	loseTiles
	.word	100726784
	.word	loseMap
	.word	state
	.word	stopSound
	.word	loseSong_length
	.word	loseSong_data
	.word	playSoundA
	.size	goToLose, .-goToLose
	.align	2
	.global	game
	.syntax unified
	.arm
	.fpu softvfp
	.type	game, %function
game:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, lr}
	ldr	r3, .L97
	mov	lr, pc
	bx	r3
	ldr	r3, .L97+4
	mov	lr, pc
	bx	r3
	ldr	r3, .L97+8
	ldrh	r3, [r3]
	tst	r3, #8
	beq	.L84
	ldr	r3, .L97+12
	ldrh	r3, [r3]
	tst	r3, #8
	beq	.L95
.L84:
	ldr	r3, .L97+16
	ldr	r3, [r3]
	cmp	r3, #0
	beq	.L85
	ldr	r2, .L97+20
	ldr	r3, .L97+24
	ldr	r2, [r2]
	ldr	r3, [r3]
	orrs	r3, r2, r3
	beq	.L85
	ldr	r3, .L97+28
	ldr	r3, [r3]
	cmp	r3, #0
	bne	.L96
.L83:
	pop	{r4, lr}
	bx	lr
.L85:
	bl	goToLose
	ldr	r3, .L97+28
	ldr	r3, [r3]
	cmp	r3, #0
	beq	.L83
.L96:
	pop	{r4, lr}
	b	goToWin
.L95:
	bl	goToPause
	b	.L84
.L98:
	.align	2
.L97:
	.word	updateGame
	.word	drawGame
	.word	oldButtons
	.word	buttons
	.word	life
	.word	time_m
	.word	time_s
	.word	delivered
	.size	game, .-game
	.section	.text.startup,"ax",%progbits
	.align	2
	.global	main
	.syntax unified
	.arm
	.fpu softvfp
	.type	main, %function
main:
	@ Function supports interworking.
	@ Volatile: function does not return.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	ldr	r6, .L115
	ldr	r10, .L115+4
	push	{r4, r7, fp, lr}
	ldr	r3, .L115+8
	mov	lr, pc
	bx	r3
	ldr	r5, .L115+12
	ldr	r2, [r6]
	ldrh	r0, [r10]
	ldr	fp, .L115+16
	ldr	r9, .L115+20
	ldr	r8, .L115+24
	ldr	r7, .L115+28
	ldr	r4, .L115+32
.L101:
	strh	r0, [r5]	@ movhi
	ldrh	r3, [r4, #48]
	strh	r3, [r10]	@ movhi
	cmp	r2, #5
	ldrls	pc, [pc, r2, asl #2]
	b	.L110
.L103:
	.word	.L108
	.word	.L107
	.word	.L106
	.word	.L105
	.word	.L104
	.word	.L102
.L102:
	tst	r0, #8
	beq	.L110
	ldr	r3, .L115+36
	mov	lr, pc
	bx	r3
	ldr	r2, [r6]
	ldrh	r0, [r10]
	b	.L101
.L104:
	tst	r0, #8
	beq	.L110
	ldr	r3, .L115+40
	mov	lr, pc
	bx	r3
	ldr	r2, [r6]
	ldrh	r0, [r10]
	b	.L101
.L105:
	mov	lr, pc
	bx	r7
	ldr	r2, [r6]
	ldrh	r0, [r10]
	b	.L101
.L106:
	mov	lr, pc
	bx	r8
	ldr	r2, [r6]
	ldrh	r0, [r10]
	b	.L101
.L107:
	tst	r0, #4
	beq	.L110
	mov	lr, pc
	bx	fp
	ldr	r2, [r6]
	ldrh	r0, [r10]
	b	.L101
.L108:
	mov	lr, pc
	bx	r9
	ldr	r2, [r6]
	ldrh	r0, [r10]
	b	.L101
.L110:
	mov	r0, r3
	b	.L101
.L116:
	.align	2
.L115:
	.word	state
	.word	buttons
	.word	initialize
	.word	oldButtons
	.word	instruction.part.0
	.word	start
	.word	game
	.word	pause
	.word	67109120
	.word	lose.part.0
	.word	win.part.0
	.size	main, .-main
	.text
	.align	2
	.global	lose
	.syntax unified
	.arm
	.fpu softvfp
	.type	lose, %function
lose:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	b	win
	.size	lose, .-lose
	.comm	shadowOAM,1024,4
	.comm	oldButtons,2,2
	.comm	buttons,2,2
	.comm	arrow,16,4
	.comm	t_select,4,4
	.comm	state,4,4
	.comm	soundB,32,4
	.comm	soundA,32,4
	.ident	"GCC: (devkitARM release 53) 9.1.0"
