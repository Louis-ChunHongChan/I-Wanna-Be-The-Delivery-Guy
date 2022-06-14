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
	.file	"mode0.c"
	.text
	.align	2
	.global	setPixel3
	.arch armv4t
	.syntax unified
	.arm
	.fpu softvfp
	.type	setPixel3, %function
setPixel3:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	ldr	r3, .L3
	rsb	r1, r1, r1, lsl #4
	ldr	r3, [r3]
	add	r0, r0, r1, lsl #4
	lsl	r0, r0, #1
	strh	r2, [r3, r0]	@ movhi
	bx	lr
.L4:
	.align	2
.L3:
	.word	.LANCHOR0
	.size	setPixel3, .-setPixel3
	.align	2
	.global	setPixel4
	.syntax unified
	.arm
	.fpu softvfp
	.type	setPixel4, %function
setPixel4:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	rsb	r1, r1, r1, lsl #4
	ldr	ip, .L9
	add	r3, r0, r1, lsl #4
	ldr	ip, [ip]
	add	r3, r3, r3, lsr #31
	bic	r3, r3, #1
	ldrh	r1, [ip, r3]
	sub	sp, sp, #8
	strh	r1, [sp, #6]	@ movhi
	ldrh	r1, [sp, #6]
	tst	r0, #1
	andne	r1, r1, #255
	andeq	r1, r1, #65280
	strhne	r1, [sp, #6]	@ movhi
	strheq	r1, [sp, #6]	@ movhi
	ldrhne	r1, [sp, #6]
	ldrheq	r1, [sp, #6]
	orrne	r2, r1, r2, lsl #8
	orreq	r2, r1, r2
	strh	r2, [sp, #6]	@ movhi
	ldrh	r2, [sp, #6]
	strh	r2, [ip, r3]	@ movhi
	add	sp, sp, #8
	@ sp needed
	bx	lr
.L10:
	.align	2
.L9:
	.word	.LANCHOR0
	.size	setPixel4, .-setPixel4
	.align	2
	.global	drawRect3
	.syntax unified
	.arm
	.fpu softvfp
	.type	drawRect3, %function
drawRect3:
	@ Function supports interworking.
	@ args = 4, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	subs	ip, r3, #0
	bxle	lr
	push	{r4, r5, lr}
	mov	lr, #0
	ldr	r5, .L20
	add	ip, r1, ip
	ldr	r3, [r5]
	rsb	r1, r1, r1, lsl #4
	rsb	ip, ip, ip, lsl #4
	add	r4, r0, r1, lsl #4
	add	ip, r0, ip, lsl #4
	ldr	r1, [r5, #4]
	orr	r0, r2, #-2130706432
	add	r2, r3, ip, lsl #1
	add	r3, r3, r4, lsl #1
.L13:
	add	ip, sp, #12
	str	lr, [r1, #44]
	str	ip, [r1, #36]
	str	r3, [r1, #40]
	add	r3, r3, #480
	cmp	r3, r2
	str	r0, [r1, #44]
	bne	.L13
	pop	{r4, r5, lr}
	bx	lr
.L21:
	.align	2
.L20:
	.word	.LANCHOR0
	.size	drawRect3, .-drawRect3
	.align	2
	.global	drawRect4
	.syntax unified
	.arm
	.fpu softvfp
	.type	drawRect4, %function
drawRect4:
	@ Function supports interworking.
	@ args = 4, pretend = 0, frame = 24
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, r7, r8, r9, r10, fp, lr}
	sub	sp, sp, #28
	ldrb	ip, [sp, #64]	@ zero_extendqisi2
	ldrb	lr, [sp, #64]	@ zero_extendqisi2
	subs	r7, r3, #0
	orr	ip, ip, lr, lsl #8
	strh	ip, [sp, #22]	@ movhi
	ble	.L22
	mov	r4, r2
	mov	r10, r1
	sub	r9, r2, #1
	sub	r2, r2, #2
	add	r9, r9, r9, lsr #31
	add	r2, r2, r2, lsr #31
	add	r3, r4, r4, lsr #31
	asr	r1, r9, #1
	asr	r2, r2, #1
	asr	r3, r3, #1
	add	fp, r4, r0
	orr	r1, r1, #-2130706432
	orr	r2, r2, #-2130706432
	orr	r3, r3, #-2130706432
	mov	r5, r0
	ldr	r9, .L41
	str	r1, [sp, #4]
	str	r2, [sp, #12]
	str	r3, [sp, #8]
	add	r7, r7, r10
	sub	fp, fp, #1
	b	.L29
.L39:
	add	r2, r5, #1
	rsb	r6, r10, r10, lsl #4
	add	r6, r2, r6, lsl #4
	add	r6, r6, r6, lsr #31
	cmp	r8, #0
	mov	r1, r10
	mov	r0, r5
	ldrb	r2, [sp, #64]	@ zero_extendqisi2
	bic	r6, r6, #1
	bne	.L36
	bl	setPixel4
	ldm	r9, {r0, r2}
	ldr	r3, [sp, #12]
	add	r6, r0, r6
	add	ip, sp, #22
	str	r8, [r2, #44]
	str	ip, [r2, #36]
	str	r6, [r2, #40]
	str	r3, [r2, #44]
	mov	r1, r10
	mov	r0, fp
	ldrb	r2, [sp, #64]	@ zero_extendqisi2
	bl	setPixel4
.L25:
	add	r10, r10, #1
	cmp	r10, r7
	beq	.L22
.L29:
	cmp	r4, #1
	beq	.L37
	cmp	r4, #2
	beq	.L38
	ands	r0, r5, #1
	and	r8, r4, #1
	bne	.L39
	rsb	r2, r10, r10, lsl #4
	add	r2, r5, r2, lsl #4
	ldr	ip, [r9]
	add	r2, r2, r2, lsr #31
	bic	r2, r2, #1
	cmp	r8, #0
	add	r2, ip, r2
	ldr	ip, [r9, #4]
	bne	.L40
	ldr	r3, [sp, #8]
	add	r10, r10, #1
	add	r0, sp, #22
	cmp	r10, r7
	str	r8, [ip, #44]
	str	r0, [ip, #36]
	str	r2, [ip, #40]
	str	r3, [ip, #44]
	bne	.L29
.L22:
	add	sp, sp, #28
	@ sp needed
	pop	{r4, r5, r6, r7, r8, r9, r10, fp, lr}
	bx	lr
.L37:
	mov	r1, r10
	mov	r0, r5
	ldrb	r2, [sp, #64]	@ zero_extendqisi2
	bl	setPixel4
	b	.L25
.L40:
	add	r3, sp, #22
	str	r0, [ip, #44]
	str	r3, [ip, #36]
	ldr	r3, [sp, #4]
	str	r2, [ip, #40]
	str	r3, [ip, #44]
	mov	r1, r10
	mov	r0, fp
	ldrb	r2, [sp, #64]	@ zero_extendqisi2
	bl	setPixel4
	b	.L25
.L38:
	mov	r1, r10
	mov	r0, r5
	ldrb	r2, [sp, #64]	@ zero_extendqisi2
	bl	setPixel4
	mov	r1, r10
	ldrb	r2, [sp, #64]	@ zero_extendqisi2
	add	r0, r5, #1
	bl	setPixel4
	b	.L25
.L36:
	bl	setPixel4
	mov	r0, #0
	ldm	r9, {r2, r3}
	add	r6, r2, r6
	add	r2, sp, #22
	str	r0, [r3, #44]
	str	r2, [r3, #36]
	ldr	r2, [sp, #4]
	str	r6, [r3, #40]
	str	r2, [r3, #44]
	b	.L25
.L42:
	.align	2
.L41:
	.word	.LANCHOR0
	.size	drawRect4, .-drawRect4
	.align	2
	.global	fillScreen3
	.syntax unified
	.arm
	.fpu softvfp
	.type	fillScreen3, %function
fillScreen3:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 0, uses_anonymous_args = 0
	mov	ip, #0
	str	lr, [sp, #-4]!
	sub	sp, sp, #20
	strh	r0, [sp, #6]	@ movhi
	ldr	r2, .L45
	ldrh	lr, [sp, #6]
	ldm	r2, {r1, r3}
	ldr	r2, .L45+4
	add	r0, sp, #14
	str	ip, [r3, #44]
	str	r0, [r3, #36]
	str	r1, [r3, #40]
	str	r2, [r3, #44]
	add	sp, sp, #20
	@ sp needed
	ldr	lr, [sp], #4
	bx	lr
.L46:
	.align	2
.L45:
	.word	.LANCHOR0
	.word	-2130668032
	.size	fillScreen3, .-fillScreen3
	.align	2
	.global	fillScreen4
	.syntax unified
	.arm
	.fpu softvfp
	.type	fillScreen4, %function
fillScreen4:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 0, uses_anonymous_args = 0
	str	lr, [sp, #-4]!
	mov	lr, #0
	sub	sp, sp, #20
	strb	r0, [sp, #7]
	ldr	r1, .L49
	ldrb	r2, [sp, #7]	@ zero_extendqisi2
	ldrb	ip, [sp, #7]	@ zero_extendqisi2
	ldm	r1, {r0, r3}
	ldr	r1, .L49+4
	orr	r2, r2, ip, lsl #8
	add	ip, sp, #14
	strh	r2, [sp, #14]	@ movhi
	str	lr, [r3, #44]
	str	ip, [r3, #36]
	str	r0, [r3, #40]
	str	r1, [r3, #44]
	add	sp, sp, #20
	@ sp needed
	ldr	lr, [sp], #4
	bx	lr
.L50:
	.align	2
.L49:
	.word	.LANCHOR0
	.word	-2130687232
	.size	fillScreen4, .-fillScreen4
	.align	2
	.global	drawImage3
	.syntax unified
	.arm
	.fpu softvfp
	.type	drawImage3, %function
drawImage3:
	@ Function supports interworking.
	@ args = 4, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	subs	ip, r3, #0
	bxle	lr
	push	{r4, r5, r6, lr}
	mov	r5, #0
	ldr	r6, .L60
	rsb	lr, r1, r1, lsl #4
	ldr	r3, [r6]
	add	lr, r0, lr, lsl #4
	ldr	r4, [sp, #16]
	ldr	r0, [r6, #4]
	add	r3, r3, lr, lsl #1
	add	ip, ip, r1
	lsl	lr, r2, #1
	orr	r2, r2, #-2147483648
.L54:
	cmp	r1, #0
	add	r1, r1, #1
	strge	r5, [r0, #44]
	strge	r4, [r0, #36]
	strge	r3, [r0, #40]
	strge	r2, [r0, #44]
	cmp	r1, ip
	add	r4, r4, lr
	add	r3, r3, #480
	bne	.L54
	pop	{r4, r5, r6, lr}
	bx	lr
.L61:
	.align	2
.L60:
	.word	.LANCHOR0
	.size	drawImage3, .-drawImage3
	.align	2
	.global	drawImage4
	.syntax unified
	.arm
	.fpu softvfp
	.type	drawImage4, %function
drawImage4:
	@ Function supports interworking.
	@ args = 4, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	cmp	r3, #0
	bxle	lr
	push	{r4, r5, r6, r7, r8, lr}
	mov	r5, #0
	ldr	r4, .L71
	add	r2, r2, r2, lsr #31
	asr	lr, r2, #1
	rsb	r8, r1, r1, lsl #4
	ldr	ip, [sp, #24]
	ldr	r7, [r4]
	ldr	r2, [r4, #4]
	orr	r6, lr, #-2147483648
	add	r4, r3, r1
	lsl	lr, lr, #1
	add	r0, r0, r8, lsl #4
.L65:
	cmp	r1, #0
	add	r1, r1, #1
	blt	.L64
	add	r3, r0, r0, lsr #31
	bic	r3, r3, #1
	add	r3, r7, r3
	str	r5, [r2, #44]
	str	ip, [r2, #36]
	str	r3, [r2, #40]
	str	r6, [r2, #44]
.L64:
	cmp	r1, r4
	add	r0, r0, #240
	add	ip, ip, lr
	bne	.L65
	pop	{r4, r5, r6, r7, r8, lr}
	bx	lr
.L72:
	.align	2
.L71:
	.word	.LANCHOR0
	.size	drawImage4, .-drawImage4
	.align	2
	.global	drawFullscreenImage3
	.syntax unified
	.arm
	.fpu softvfp
	.type	drawFullscreenImage3, %function
drawFullscreenImage3:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	mov	ip, #0
	ldr	r2, .L74
	ldr	r1, .L74+4
	ldm	r2, {r2, r3}
	str	ip, [r3, #44]
	str	r0, [r3, #36]
	str	r2, [r3, #40]
	str	r1, [r3, #44]
	bx	lr
.L75:
	.align	2
.L74:
	.word	.LANCHOR0
	.word	-2147445248
	.size	drawFullscreenImage3, .-drawFullscreenImage3
	.align	2
	.global	drawFullscreenImage4
	.syntax unified
	.arm
	.fpu softvfp
	.type	drawFullscreenImage4, %function
drawFullscreenImage4:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	mov	ip, #0
	ldr	r2, .L77
	ldr	r1, .L77+4
	ldm	r2, {r2, r3}
	str	ip, [r3, #44]
	str	r0, [r3, #36]
	str	r2, [r3, #40]
	str	r1, [r3, #44]
	bx	lr
.L78:
	.align	2
.L77:
	.word	.LANCHOR0
	.word	-2147464448
	.size	drawFullscreenImage4, .-drawFullscreenImage4
	.align	2
	.global	waitForVBlank
	.syntax unified
	.arm
	.fpu softvfp
	.type	waitForVBlank, %function
waitForVBlank:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	mov	r2, #67108864
.L80:
	ldrh	r3, [r2, #6]
	cmp	r3, #160
	bhi	.L80
	mov	r2, #67108864
.L81:
	ldrh	r3, [r2, #6]
	cmp	r3, #159
	bls	.L81
	bx	lr
	.size	waitForVBlank, .-waitForVBlank
	.align	2
	.global	flipPage
	.syntax unified
	.arm
	.fpu softvfp
	.type	flipPage, %function
flipPage:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	mov	r3, #67108864
	ldrh	r1, [r3]
	tst	r1, #16
	ldr	r2, .L88
	moveq	r2, #100663296
	ldr	r1, .L88+4
	str	r2, [r1]
	ldrh	r2, [r3]
	eor	r2, r2, #16
	strh	r2, [r3]	@ movhi
	bx	lr
.L89:
	.align	2
.L88:
	.word	100704256
	.word	.LANCHOR0
	.size	flipPage, .-flipPage
	.align	2
	.global	DMANow
	.syntax unified
	.arm
	.fpu softvfp
	.type	DMANow, %function
DMANow:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, lr}
	mov	r4, #0
	ldr	ip, .L92
	ldr	lr, [ip, #4]
	add	r0, r0, r0, lsl #1
	add	ip, lr, r0, lsl #2
	orr	r3, r3, #-2147483648
	lsl	r0, r0, #2
	str	r4, [ip, #8]
	str	r1, [lr, r0]
	str	r2, [ip, #4]
	pop	{r4, lr}
	str	r3, [ip, #8]
	bx	lr
.L93:
	.align	2
.L92:
	.word	.LANCHOR0
	.size	DMANow, .-DMANow
	.align	2
	.global	collision
	.syntax unified
	.arm
	.fpu softvfp
	.type	collision, %function
collision:
	@ Function supports interworking.
	@ args = 16, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	str	lr, [sp, #-4]!
	ldr	lr, [sp, #8]
	ldr	ip, [sp, #16]
	add	ip, lr, ip
	sub	ip, ip, #1
	cmp	ip, r1
	ble	.L98
	add	r1, r1, r3
	sub	r1, r1, #1
	cmp	r1, lr
	bgt	.L100
.L98:
	mov	r0, #0
	ldr	lr, [sp], #4
	bx	lr
.L100:
	ldr	r3, [sp, #4]
	ldr	r1, [sp, #12]
	add	r3, r3, r1
	sub	r3, r3, #1
	cmp	r3, r0
	ble	.L98
	ldr	r3, [sp, #4]
	add	r0, r0, r2
	sub	r0, r0, #1
	cmp	r0, r3
	movle	r0, #0
	movgt	r0, #1
	ldr	lr, [sp], #4
	bx	lr
	.size	collision, .-collision
	.align	2
	.global	hideSprites
	.syntax unified
	.arm
	.fpu softvfp
	.type	hideSprites, %function
hideSprites:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	@ link register save eliminated.
	mov	r1, #512
	ldr	r3, .L105
	add	r2, r3, #1024
.L102:
	strh	r1, [r3], #8	@ movhi
	cmp	r3, r2
	bne	.L102
	bx	lr
.L106:
	.align	2
.L105:
	.word	shadowOAM
	.size	hideSprites, .-hideSprites
	.align	2
	.global	collisionCheck
	.syntax unified
	.arm
	.fpu softvfp
	.type	collisionCheck, %function
collisionCheck:
	@ Function supports interworking.
	@ args = 16, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, lr}
	ldr	ip, [sp, #12]
	ldr	r4, [sp, #20]
	add	ip, r3, ip
	add	lr, r3, r4
	sub	r3, ip, #1
	add	r3, r3, r4
	mla	ip, r1, lr, r0
	mul	r1, r3, r1
	ldr	r3, [sp, #8]
	ldr	lr, [sp, #16]
	add	r3, r2, r3
	sub	r3, r3, #1
	add	r2, r2, lr
	add	r3, r3, lr
	ldrb	lr, [ip, r3]	@ zero_extendqisi2
	ldrb	ip, [ip, r2]	@ zero_extendqisi2
	add	r3, r0, r3
	add	r0, r0, r2
	ldrb	r0, [r0, r1]	@ zero_extendqisi2
	ldrb	r2, [r3, r1]	@ zero_extendqisi2
	cmp	ip, lr
	movcs	ip, lr
	cmp	r0, r2
	movge	r0, r2
	cmp	r0, ip
	movge	r0, ip
	pop	{r4, lr}
	bx	lr
	.size	collisionCheck, .-collisionCheck
	.align	2
	.global	collisionLadderCheck
	.syntax unified
	.arm
	.fpu softvfp
	.type	collisionLadderCheck, %function
collisionLadderCheck:
	@ Function supports interworking.
	@ args = 16, pretend = 0, frame = 0
	@ frame_needed = 0, uses_anonymous_args = 0
	push	{r4, r5, r6, lr}
	ldr	r5, [sp, #28]
	add	ip, r3, r5
	mla	ip, r1, ip, r0
	ldr	r4, [sp, #24]
	add	lr, r2, r4
	ldrb	r6, [ip, lr]	@ zero_extendqisi2
	cmp	r6, #2
	beq	.L113
	ldr	r6, [sp, #16]
	add	r2, r2, r6
	sub	r2, r2, #1
	add	r2, r2, r4
	ldrb	ip, [ip, r2]	@ zero_extendqisi2
	cmp	ip, #2
	beq	.L113
	ldr	ip, [sp, #20]
	add	r3, r3, ip
	sub	r3, r3, #1
	add	r3, r3, r5
	mul	r1, r3, r1
	add	lr, r0, lr
	ldrb	r3, [lr, r1]	@ zero_extendqisi2
	cmp	r3, #2
	beq	.L113
	add	r2, r0, r2
	ldrb	r0, [r2, r1]	@ zero_extendqisi2
	sub	r3, r0, #2
	rsbs	r0, r3, #0
	adc	r0, r0, r3
	pop	{r4, r5, r6, lr}
	bx	lr
.L113:
	mov	r0, #1
	pop	{r4, r5, r6, lr}
	bx	lr
	.size	collisionLadderCheck, .-collisionLadderCheck
	.global	dma
	.global	videoBuffer
	.data
	.align	2
	.set	.LANCHOR0,. + 0
	.type	videoBuffer, %object
	.size	videoBuffer, 4
videoBuffer:
	.word	100663296
	.type	dma, %object
	.size	dma, 4
dma:
	.word	67109040
	.ident	"GCC: (devkitARM release 53) 9.1.0"
