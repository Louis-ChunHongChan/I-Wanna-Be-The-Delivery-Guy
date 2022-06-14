#include <stdlib.h>
#include "mode0.h"
#include "game.h"
#include "spritesheet.h"
#include "title.h"
#include "sound.h"
#include "collisionmap.h"
#include "sheidGuard.h"

#define CRAZYCOUNT 9
#define HEARTCOUNT 3

// variables
int life;
int delivered;
int hOff;
int vOff;
int guyhOff, guyvOff;
int gravity;
int paused, won, lost;
int upward;

int jumping;
int down;
int climbing;
int jumpBoosted, floating;
int frame;
int jumpFrame, downFrame, bootsFrame, bubbleFrame, crazyFrame;

int time_m, time_s;

unsigned char * collisionMap = (unsigned char*) collisionmapBitmap;

// States used for ANISPRITE
enum { LEFT, LEFTJUMP, RIGHT, RIGHTJUMP, CLIMB, DOWN, FLOAT, LOST, IDLE };

ANISPRITE guy;
ANISPRITE customer;
CRAZY crazy[CRAZYCOUNT];
UI heart[HEARTCOUNT];
UI key[3];
UI shirt[2];
UI tele[2];
UI bubble[2];
UI door[3];
UI boots;

void displayTime() {
    short time_m_1s = time_m % 10;
    short time_m_10s = time_m / 10;
    short time_s_1s = time_s % 10;
    short time_s_10s = time_s / 10;

    shadowOAM[20].attr0 = (guy.row - 16 - guyvOff) | ATTR0_SQUARE;
    shadowOAM[20].attr1 = (guy.col - 4 - guyhOff) | ATTR1_TINY;
    shadowOAM[20].attr2 = ATTR2_TILEID(0, time_m_10s + 2) | ATTR2_PALROW(0);

    shadowOAM[21].attr0 = (guy.row - 16 - guyvOff) | ATTR0_SQUARE;
    shadowOAM[21].attr1 = (guy.col - guyhOff) | ATTR1_TINY;
    shadowOAM[21].attr2 = ATTR2_TILEID(0, time_m_1s + 2) | ATTR2_PALROW(0);

    shadowOAM[22].attr0 = (guy.row - 16 - guyvOff) | ATTR0_SQUARE;
    shadowOAM[22].attr1 = (guy.col + 4 - guyhOff) | ATTR1_TINY;
    shadowOAM[22].attr2 = ATTR2_TILEID(0, 12) | ATTR2_PALROW(0);

    shadowOAM[23].attr0 = (guy.row - 16 - guyvOff) | ATTR0_SQUARE;
    shadowOAM[23].attr1 = (guy.col + 8 - guyhOff) | ATTR1_TINY;
    shadowOAM[23].attr2 = ATTR2_TILEID(0, time_s_10s + 2) | ATTR2_PALROW(0);

    shadowOAM[24].attr0 = (guy.row - 16 - guyvOff) | ATTR0_SQUARE;
    shadowOAM[24].attr1 = (guy.col + 12 - guyhOff) | ATTR1_TINY;
    shadowOAM[24].attr2 = ATTR2_TILEID(0, time_s_1s + 2) | ATTR2_PALROW(0);
}

void timerInterruptHandler(void) {
    REG_IME = 0;

    if (!paused) {
        if (REG_IF & INT_TM2) {
            time_s--;
            if (time_s < 0) {
                time_m--;
                time_s = 59;
            }
        }
    }

    if (!won && !lost && !paused) {
        if (REG_IF & INT_VBLANK) {
            displayTime();
            
            if (soundA.isPlaying) {
                soundA.vBlankCount = soundA.vBlankCount + 1;
                if (soundA.vBlankCount > soundA.duration) {
                    if (soundA.loops) {
                        playSoundA(soundA.data, soundA.length, soundA.loops);
                    } else {
                        soundA.isPlaying = 0;
                        dma[1].cnt = 0;
                        REG_TM0CNT = TIMER_OFF;
                    }
                }
            }

            if (soundB.isPlaying) {

                soundB.vBlankCount = soundB.vBlankCount + 1;
                if (soundB.vBlankCount > soundB.duration) {
                    if (soundB.loops) {
                        playSoundB(soundB.data, soundB.length, soundB.loops);
                    } else {
                        soundB.isPlaying = 0;
                        dma[2].cnt = 0;
                        REG_TM1CNT = TIMER_OFF;
                    }
                }
            }
        }
    }
    else {
        if (REG_IF & INT_VBLANK) {
            
            if (soundA.isPlaying) {
                soundA.vBlankCount = soundA.vBlankCount + 1;
                if (soundA.vBlankCount > soundA.duration) {
                    if (soundA.loops) {
                        playSoundA(soundA.data, soundA.length, soundA.loops);
                    } else {
                        soundA.isPlaying = 0;
                        dma[1].cnt = 0;
                        REG_TM0CNT = TIMER_OFF;
                    }
                }
            }

            if (soundB.isPlaying) {

                soundB.vBlankCount = soundB.vBlankCount + 1;
                if (soundB.vBlankCount > soundB.duration) {
                    if (soundB.loops) {
                        playSoundB(soundB.data, soundB.length, soundB.loops);
                    } else {
                        soundB.isPlaying = 0;
                        dma[2].cnt = 0;
                        REG_TM1CNT = TIMER_OFF;
                    }
                }
            }
        }
    }

    if ((REG_IF & INT_BUTTON) && (~BUTTONS & BUTTON_SELECT)) {
        REG_TM2CNT = TIMER_OFF;
    }

    REG_IF = REG_IF;
    REG_IME = 1;
}

void enableTimerInterrupts(void) {
    REG_IE |= INT_TM2;
    REG_TM2CNT = 0;
    REG_TM2D = 65536 - 16384;
    REG_TM2CNT = TM_FREQ_1024 | TIMER_ON | TM_IRQ;

    // REG_TM2CNT = 0;
    // REG_TM2D = 65536 - 60;
    // REG_TM2CNT = TM_CASCADE | TIMER_ON | TM_IRQ;
}

void setupTimerInterrupts(void) {
    REG_IME = 0;
    REG_IE |= INT_VBLANK;
    REG_DISPSTAT |= INT_VBLANK_ENABLE;
    REG_INTERRUPT = timerInterruptHandler;
    enableTimerInterrupts();
    
    REG_IME = 1;
}

void initGame() {
    // initialize all the variables
    life = 2;
    delivered = 0;
    gravity = 10;
    jumping = 0;
    down = 0;
    climbing = 0;
    jumpBoosted = 0;
    frame = 0;
    jumpFrame = 0;
    downFrame = 0;
    crazyFrame = 0;
    bootsFrame = 0;
    floating = 0;
    time_m = 2;
    time_s = 0;
    upward = 29;
    
    // screen initialization
    vOff = 96+512;
    guyvOff = 96+512;
    hOff = 0;
    guyhOff = 0;

    // initialize all the functions
    initGuy();
    initDoor();
    initKey();
    initTele();
    initBoots();
    initHeart();
    initShirt();
    initCustomer();
    initBubble();
    initCrazy();

    // Hide all sprites with hideSprites()
    hideSprites();

    buttons = BUTTONS;
}

void initGuy() {
    // Initialize guy and place in the middle of the screen in the world location chosen earlier
    guy.width = 16;
    guy.height = 16;
    guy.cdel = 1;
    guy.rdel = 1;
    guy.row = 230+512;
    guy.col = SCREENWIDTH / 2 - guy.width * 7;
    
    guy.aniCounter = 0;
    guy.curFrame = 0;
    guy.numFrames = 4;
    guy.aniState = RIGHT;
    guy.hasKey1 = 0;
    guy.hasKey2 = 0;
    guy.hasKey3 = 0;
}

void initDoor() {
    for (int i = 0; i < 3; i++) {
        if (i == 0) {
            door[i].width = 16;
            door[i].height = 32;
            door[i].col = SCREENWIDTH / 2 + door[i].width * 3 - 4;
            door[i].row = 220+256;
            door[i].active = 1;
        }
        else if (i == 1) {
            door[i].width = 16;
            door[i].height = 32;
            door[i].col = SCREENWIDTH / 2 + door[i].width * 5;
            door[i].row = 768-32*4;
            door[i].active = 1;
        }
        else {
            door[i].width = 16;
            door[i].height = 32;
            door[i].col = SCREENWIDTH / 2 - door[i].height * 2 - 8;
            door[i].row = 230;
            door[i].active = 1;
        }
    }
}

void initKey() {
    for (int i = 0; i < 3; i++) {
        key[i].width = 16;
        key[i].height = 16;
        key[i].active = 1;
        if (i == 0) {
            key[i].col = SCREENWIDTH / 2 + key[i].width * 2;
            key[i].row = 68+256;
        }
        else if (i == 1) {
            key[i].col = SCREENWIDTH / 2 + key[i].width * 4;
            key[i].row = 768 - 200;
        }
        else {
            key[i].col = SCREENWIDTH - 8;
            key[i].row = 100;
        }
    }
}

void initTele() {
    for (int i = 0; i < 2; i++) {
        if (i == 0) {
            tele[i].width = 32;
            tele[i].height = 32;
            tele[i].col = SCREENWIDTH - tele[i].width;
            tele[i].row = 37;
        }
        else {
            tele[i].width = 32;
            tele[i].height = 32;
            tele[i].col = SCREENWIDTH / 2 - tele[i].width * 2;
            tele[i].row = 230 - 8;
        }
    }
}

void initBoots() {
    boots.width = 16;
    boots.height = 16;
    boots.col = SCREENWIDTH / 2 - boots.width * 3;
    boots.row = 110+256;
    boots.active = 1;
}

void initShirt() {
    for (int i = 0; i < 2; i++) {
        shirt[i].width = 16;
        shirt[i].height = 16;
        shirt[i].active = 1;
        if (i == 0) {
            shirt[i].col = SCREENWIDTH / 2 - shirt[i].width * 6 - 8;
            shirt[i].row = 26+256;
        }
        else {
            shirt[i].col = SCREENWIDTH / 2 + 16;
            shirt[i].row = 60;
        }
    }
}

void initCustomer() {
    customer.width = 16;
    customer.height = 16;
    // customer.cdel = 0;
    // customer.rdel = 0;
    customer.row = 17;
    customer.col = SCREENWIDTH / 2 - customer.width * 7 + 5;
    customer.aniCounter = 0;
    customer.curFrame = 0;
    customer.numFrames = 4;
    // customer.aniState = 0;
}

void initBubble() {
    for (int i = 0; i < 2; i++) {
        if (i == 0) {
            bubble[i].width = 16;
            bubble[i].height = 16;
            bubble[i].col = SCREENWIDTH / 2 - bubble[i].width * 5;
            bubble[i].row = 60+256;
            bubble[i].active = 1;
        }
        else {
            bubble[i].width = 16;
            bubble[i].height = 16;
            bubble[i].col = SCREENWIDTH / 2 - bubble[i].width * 3;
            bubble[i].row = 150;
            bubble[i].active = 1;
        }
    }
}

void initCrazy() {
    // int shift = 0;
    for(int i = 0; i < CRAZYCOUNT; i++){
        crazy[i].width = 32;
        crazy[i].height = 32;
        crazy[i].cdel = 1;
        crazy[i].rdel = 1;
        if (i == 0) {
            // 512-24
            crazy[i].row = 232+256;
            crazy[i].col = SCREENWIDTH / 2 + crazy[i].width;
        }
        if (i == 1) {
            crazy[i].row = 173+256;
            crazy[i].col = SCREENWIDTH / 2 + 16;
        }
        if (i == 2) {
            crazy[i].row = 128+256;
            crazy[i].col = SCREENWIDTH / 2 - crazy[i].width * 6;
        }
        if (i == 3) {
            crazy[i].row = 72+256;
            crazy[i].col = SCREENWIDTH / 2 - crazy[i].width * 5;
        }
        if (i == 4) {
            crazy[i].row = 29+256;
            crazy[i].col = SCREENWIDTH / 2;
        }
        if (i == 5) {
            crazy[i].row = 148+256;
            crazy[i].col = SCREENWIDTH / 2 + 16;
        }
        if (i == 6) {
            crazy[i].width = 16;
            crazy[i].height = 32;
            crazy[i].row = 237;
            crazy[i].col = SCREENWIDTH / 2 - crazy[i].width * 2;
        }
        if (i == 7) {
            crazy[i].row = 185;
            crazy[i].col = SCREENWIDTH / 2 + crazy[i].width * 2 - 8;
        }
        if (i == 8) {
            crazy[i].width = 16;
            crazy[i].height = 32;
            crazy[i].row = 93;
            crazy[i].col = SCREENWIDTH / 2 + crazy[i].width * 2 + 6;
        }
        // crazy[i].aniCounter = 0;
        crazy[i].curFrame = 0;
        crazy[i].numFrames = 4;
        // crazy[i].aniState = 1;
        crazy[i].climbed = 0;
        crazy[i].active = 1;
    }
}

void initHeart() {
    int shift = 0;
    for (int i = 0; i < HEARTCOUNT; i++) {
        heart[i].width = 16;
        heart[i].height = 16;
        heart[i].row = guy.row - 16;
        heart[i].col = guy.col - 16 + shift;
        heart[i].active = 1;
        shift += 16;
    }
}

void updateGame() {
    frame++;

    // Modify at runtime
    if (!paused && !lost && !won) {
        if (frame % 10 == 0) {
            if (upward == 20) {
                SCREENBLOCK[30].tilemap[OFFSET(13, 30, 32)] = SCREENBLOCK[30].tilemap[OFFSET(13, 21, 32)];
                SCREENBLOCK[30].tilemap[OFFSET(14, 30, 32)] = SCREENBLOCK[30].tilemap[OFFSET(14, 21, 32)];
                SCREENBLOCK[30].tilemap[OFFSET(13, 21, 32)] = SCREENBLOCK[30].tilemap[OFFSET(1, 2, 32)];
                SCREENBLOCK[30].tilemap[OFFSET(14, 21, 32)] = SCREENBLOCK[30].tilemap[OFFSET(1, 2, 32)];
                upward = 29;
            }
            else {
                SCREENBLOCK[30].tilemap[OFFSET(13, upward, 32)] = SCREENBLOCK[30].tilemap[OFFSET(13, upward+1, 32)];
                SCREENBLOCK[30].tilemap[OFFSET(14, upward, 32)] = SCREENBLOCK[30].tilemap[OFFSET(14, upward+1, 32)];
                SCREENBLOCK[30].tilemap[OFFSET(13, upward+1, 32)] = SCREENBLOCK[30].tilemap[OFFSET(1, 2, 32)];
                SCREENBLOCK[30].tilemap[OFFSET(14, upward+1, 32)] = SCREENBLOCK[30].tilemap[OFFSET(1, 2, 32)];
                upward--;
            }
        }
    }

    // falling
    if (vOff+1 < (MAPHEIGHT - SCREENHEIGHT) && (guy.row - guyvOff) > SCREENHEIGHT / 2) {
        guyvOff++;
        vOff++;
    }
    if (vOff-1 > 0 && guy.row - guyvOff <= SCREENHEIGHT / 2) {
        // Update background offset (aka move the screen) if the above is true
        guyvOff--;
        vOff--;
    }

    // to delay other inputs and gravity when guy is jumping by calculating difference between current frame and start jumping frames
    if (jumping) {
        if (frame - jumpFrame == 25) {
            jumping = 0;
            gravity = 10;
        }
    }

    // real gravity
    if (!climbing && !jumping && !floating) {
        int kept = 0;
        while (collisionCheck(collisionMap, MAPWIDTH, guy.col, guy.row, guy.width, guy.height, 0, kept) && kept < gravity) {
            kept++;
        }
        guy.row += (kept-1);
    }

    // prevent inputs when guy was knocked down by crazy or Donkey Kong and lock aniState
    if (down) {
        guy.aniState = DOWN;
        if (frame - downFrame == 30) {
            down = 0;
        }
    }

    // boots power up finished after 150 frames
    if (jumpBoosted) {
        if (frame - bootsFrame == 120) {
            jumpBoosted = 0;
        }
    }

    // boots respawn
    if (!jumpBoosted) {
        if (frame - bootsFrame == 300) {
            boots.active = 1;
        }
    }

    if (floating) {
        if (collisionCheck(collisionMap, MAPWIDTH, guy.col, guy.row, guy.width, guy.height, 0, -guy.rdel) && guy.row > 0) {
            guy.row--;
        }
        if (frame - bubbleFrame == 130) {
            floating = 0;
            gravity = 10;
        }
    }

    if (!floating) {
        if (frame - bubbleFrame == 300) {
            for (int i = 0; i < 2; i++) {
                bubble[i].active = 1;
            }
        }
        
    }

    // when guy is off ladder
    if (climbing && !collisionCheck(collisionMap, MAPWIDTH, guy.col, guy.row, guy.width, guy.height, 0, guy.rdel)) {
        // guy.row += guy.rdel;
        climbing = 0;
    }

    updateGuy();
    updateDoor();
    updateKey();
    updateTele();
    updateBoots();
    updateHeart();
    updateShirt();
    updateBubble();
    updateCrazy();
    
}

void updateGuy() {
    // Customer collision
    if (life > 0 && collision(guy.col, guy.row, guy.width, guy.height*2, customer.col, customer.row, customer.width, customer.height)) {
        delivered = 1;
    }

    // Crazy collision
    for (int i = 0; i < CRAZYCOUNT; i++) {
        if (crazy[i].active && collision(guy.col, guy.row, guy.width/2, guy.height/2, crazy[i].col, crazy[i].row, crazy[i].width/2, crazy[i].height/2)) {
            life--;
            down = 1;
            downFrame = frame;
            crazyFrame = frame;
            crazy[i].active = 0;
            playSoundB(sheidGuard_data, sheidGuard_length, 0);
        }
    }

    // start adjusting voff & hoff
    // guy to climb ladders
    if (!down && !jumping && !floating) {
        if(BUTTON_HELD(BUTTON_UP)) {
            // guy.col + guy.width/2
            if (collisionLadderCheck(collisionMap, MAPWIDTH, guy.col + guy.width/2 - 1, guy.row, guy.width/4, guy.height, 0, -guy.rdel)) {
                guy.row -= guy.rdel;
                climbing = 1;

                // vOff-1 >= 0 && (guy.row - guyvOff) <= (SCREENHEIGHT / 2)
                if (vOff-1 >= 0 && (guy.row - guyvOff) <= SCREENHEIGHT/2) {
                    // Update background offset (aka move the screen) if the above is true
                    guyvOff -= guy.rdel;
                    vOff -= guy.rdel;
                }
            }
        }

        if(BUTTON_HELD(BUTTON_DOWN)) {
            if (collisionLadderCheck(collisionMap, MAPWIDTH, guy.col + guy.width/2 - 1, guy.row, guy.width/4, guy.height, 0, guy.rdel)) {
                guy.row += guy.rdel;
                climbing = 1;

                if ((vOff+1 < (MAPHEIGHT - SCREENHEIGHT)) && ((guy.row - guyvOff) > SCREENHEIGHT / 2)) {
                    guyvOff += guy.rdel;
                    vOff += guy.rdel;
                }
            }
        }
    }
    
    // guy move left or right
    if (!climbing && !jumping && !down) {
        if(BUTTON_HELD(BUTTON_LEFT)) {
            if (collisionCheck(collisionMap, MAPWIDTH, guy.col, guy.row, guy.width, guy.height, -guy.cdel, 0) && guy.col > 0) {
                guy.col -= guy.cdel;

                if (hOff-1 >= 0 && (guy.col - guyhOff) <= SCREENWIDTH/2) {
                    hOff -= guy.cdel;
                    guyhOff -= guy.cdel;
                }
            }
        }

        if(BUTTON_HELD(BUTTON_RIGHT)) {
            if (collisionCheck(collisionMap, MAPWIDTH, guy.col, guy.row, guy.width, guy.height, guy.cdel, 0)
                    && guy.col + guy.width - 1 < MAPWIDTH) {
                guy.col += guy.cdel;

                if (hOff+1 < (MAPWIDTH - SCREENWIDTH) && (guy.col - guyhOff) > SCREENWIDTH / 2) {
                    hOff += guy.cdel;
                    guyhOff += guy.cdel;
                }
            }
        }
    }

    animateGuy();

    if (vOff <= 512-SCREENHEIGHT/2) {
        REG_BG0CNT = BG_CHARBLOCK(1) | BG_SCREENBLOCK(28) | BG_SIZE_TALL | BG_4BPP;
    }
    REG_BG0VOFF = vOff;
}

void updateDoor() {
    for (int i = 0; i < 3; i++) {
        if (i == 0) {
            if (guy.hasKey1 && collision(guy.col, guy.row, guy.width, guy.height, door[i].col, door[i].row, door[i].width, door[i].height)) {
                door[i].active = 0;
                // Modify at runtime
                for (int i = 0; i < 3; i++) {
                    SCREENBLOCK[29].tilemap[OFFSET(20 + i, 28, 32)] = SCREENBLOCK[29].tilemap[OFFSET(1, 28, 32)];
                    for (int j = 0; j < 3; j++) {
                        SCREENBLOCK[29].tilemap[OFFSET(20 + i, 28 + j, 32)] = SCREENBLOCK[29].tilemap[OFFSET(1, 28, 32)];
                    }
                }
            }
            else if (!guy.hasKey1 && collision(guy.col, guy.row, guy.width, guy.height, door[i].col, door[i].row, door[i].width, door[i].height)) {
                guy.col -= 1;
            }
        }
        else if (i == 1) {
            if (guy.hasKey3 && collision(guy.col, guy.row, guy.width, guy.height, door[i].col, door[i].row, door[i].width, door[i].height)) {
                door[i].active = 0;
                // Modify at runtime
                for (int i = 0; i < 5; i++) {
                    SCREENBLOCK[30].tilemap[OFFSET(25, 15+i, 32)] = SCREENBLOCK[29].tilemap[OFFSET(1, 28, 32)];
                }
            }
            else if (!guy.hasKey3 && collision(guy.col, guy.row, guy.width, guy.height, door[i].col, door[i].row, door[i].width, door[i].height)) {
                guy.col -= 1;
            }
        }
        else {
            if (guy.hasKey2 && collision(guy.col, guy.row, guy.width, guy.height, door[i].col, door[i].row, door[i].width, door[i].height)) {
                door[i].active = 0;
                // Modify at runtime
                for (int i = 0; i < 3; i++) {
                    SCREENBLOCK[28].tilemap[OFFSET(5 + i, 28, 32)] = SCREENBLOCK[29].tilemap[OFFSET(1, 28, 32)];
                    for (int j = 0; j < 3; j++) {
                        SCREENBLOCK[28].tilemap[OFFSET(5 + i, 28 + j, 32)] = SCREENBLOCK[29].tilemap[OFFSET(1, 28, 32)];
                    }
                }
            }
            else if (!guy.hasKey2 && collision(guy.col, guy.row, guy.width, guy.height, door[i].col, door[i].row, door[i].width, door[i].height)) {
                guy.col += 1;
            }
        }
        
    }
}

void updateKey() {
    for (int i = 0; i < 3; i++) {
        if (i == 0) {
            if ((!guy.hasKey1 && collision(guy.col, guy.row, guy.width, guy.height, key[i].col, key[i].row, key[i].width, key[i].height)) || guy.row <= 29+256) {
                key[i].active = 0;
                guy.hasKey1 = 1;
            }
        }
        else if (i == 1) {
            if (!guy.hasKey3 && collision(guy.col, guy.row, guy.width, guy.height, key[i].col, key[i].row, key[i].width, key[i].height)) {
                key[i].active = 0;
                guy.hasKey3 = 1;
            }
        }
        else {
            if (!guy.hasKey2 && collision(guy.col, guy.row, guy.width, guy.height, key[i].col, key[i].row, key[i].width, key[i].height)) {
                key[i].active = 0;
                guy.hasKey2 = 1;
            }
        }
    }
}

void updateTele() {
    if (collision(guy.col, guy.row, guy.width, guy.height, tele[0].col, tele[0].row, tele[0].width, tele[0].height)) {
        vOff = 96;
        guyvOff = 96;
        guy.row = 230;
        guy.col = SCREENWIDTH / 2 - tele[0].width * 2 + guy.width;
    }
}

void updateBoots() {
    if (boots.active && collision(guy.col, guy.row, guy.width, guy.height, boots.col, boots.row, boots.width, boots.height)) {
        boots.active = 0;
        bootsFrame = frame;
        jumpBoosted = 1;
    }
}

void updateShirt() {
    for (int i = 0; i < 2; i++) {
        if (shirt[i].active && collision(guy.col, guy.row, guy.width, guy.height, shirt[i].col, shirt[i].row, shirt[i].width, shirt[i].height)) {
            shirt[i].active = 0;
            life++;
        }
    }
}

void updateBubble() {
    for (int i = 0; i < 2; i++) {
        if (bubble[i].active && collision(guy.col, guy.row, guy.width, guy.height, bubble[i].col, bubble[i].row, bubble[i].width, bubble[i].height)) {
            bubble[i].active = 0;
            bubbleFrame = frame;
            floating = 1;
            guy.aniState = FLOAT;
        }
    }
}

void updateCustomer() {
    animateCustomer();
}

void updateCrazy() {

    // barrels animation
    for (int i = 0; i < CRAZYCOUNT; i++) {
        if (frame - crazyFrame >= 50) {
            if (!crazy[i].active) {
                crazy[i].active = 1;
            }
        }

        if (i == 0) {
            // adjust
            if (crazy[i].col >= SCREENWIDTH / 2 + crazy[i].width / 2) {
                crazy[i].cdel = -1;
            }
            if (crazy[i].col <= SCREENWIDTH / 2 - crazy[i].width * 2 - 8) {
                crazy[i].cdel = 1;
            }
            crazy[i].col += crazy[i].cdel;
        }
        if (i == 2) {
            if (crazy[i].col >= SCREENWIDTH / 2 - crazy[i].width - 25) {
                crazy[i].cdel = -1;
            }
            if (crazy[i].col <= SCREENWIDTH / 2 - crazy[i].width * 3) {
                crazy[i].cdel = 1;
            }
            crazy[i].col += crazy[i].cdel;
        }
        if (i == 3) {
            if (crazy[i].col >= SCREENWIDTH / 2 - crazy[i].width * 2 - 5) {
                crazy[i].cdel = -1;
            }
            if (crazy[i].col <= SCREENWIDTH / 2 - crazy[i].width * 3 - 16) {
                crazy[i].cdel = 1;
            }
            crazy[i].col += crazy[i].cdel;
        }
        if (i == 6) {
            if (crazy[i].col >= SCREENWIDTH / 2 + crazy[i].height * 3) {
                crazy[i].cdel = -1;
            }
            if (crazy[i].col <= SCREENWIDTH / 2 - crazy[i].height) {
                crazy[i].cdel = 1;
            }
            crazy[i].col += crazy[i].cdel;
        }
        if (i == 8) {
            if (crazy[i].col >= SCREENWIDTH / 2 + crazy[i].height * 3) {
                crazy[i].cdel = -1;
            }
            if (crazy[i].col <= SCREENWIDTH / 2 + crazy[i].height) {
                crazy[i].cdel = 1;
            }
            crazy[i].col += crazy[i].cdel;
        }
        
    }


    animateCrazy();
}

void updateHeart() {
    // update (inactive) heart object pool based on life left
    for (int i = 0; i < life; i++) {
        heart[i].active = 1;
    }
    for (int i = 0; i < (HEARTCOUNT - life); i++) {
        if (heart[i].active) {
            heart[i].active = 0;
        }
    }
}

void animateGuy() {
    // Set previous state to current state
    guy.prevAniState = guy.aniState;
    guy.aniState = IDLE;

    // Change the animation frame every 15 frames of gameplay
    if(guy.aniCounter % 8 == 0) {
        guy.curFrame = (guy.curFrame + 1) % guy.numFrames;
    }

    // Control movement and change animation state
    if (!climbing && !down && !jumping) {
            if(BUTTON_HELD(BUTTON_LEFT) && !floating) {
                guy.aniState = LEFT;
            }
            if(BUTTON_HELD(BUTTON_RIGHT) && !floating) {
                guy.aniState = RIGHT;
            }
            if (!down && !jumping && !floating) {

                if (guy.aniState == LEFT && BUTTON_PRESSED(BUTTON_B) && !collisionCheck(collisionMap, MAPWIDTH, guy.col, guy.row, guy.width, guy.height, 0, guy.rdel)) {
                    guy.aniState = LEFTJUMP;
                    jumping = 1;
                    jumpFrame = frame;
                    gravity = 0;

                    if (collisionCheck(collisionMap, MAPWIDTH, guy.col, guy.row, guy.width, guy.height, -15, -24)) {
                        if (jumpBoosted) {
                            guy.row -= 50;
                            guy.col -= 25;
                        }
                        else {
                            guy.row -= 24;
                            guy.col -= 15;
                        }
                    }
                    
                }
                else if (guy.aniState == RIGHT && BUTTON_PRESSED(BUTTON_B) && !collisionCheck(collisionMap, MAPWIDTH, guy.col, guy.row, guy.width, guy.height, 0, guy.rdel)) {
                    guy.aniState = RIGHTJUMP;
                    jumping = 1;
                    jumpFrame = frame;
                    gravity = 0;
                    if (collisionCheck(collisionMap, MAPWIDTH, guy.col, guy.row, guy.width, guy.height, 15, -24)) {
                        if (jumpBoosted) {
                            guy.row -= 50;
                            guy.col += 25;
                        }
                        else {
                            guy.row -= 24;
                            guy.col += 15;
                        }
                    }
                }
            }
            
        }
        else if (!down && !jumping && !floating) {
            if(BUTTON_HELD(BUTTON_UP) || BUTTON_HELD(BUTTON_DOWN)) {
                guy.aniState = CLIMB;
            }
        }

    if (guy.aniState == IDLE) {
        guy.curFrame = 0;
        guy.aniCounter = 0;
        guy.aniState = guy.prevAniState;
    }
    else {
        guy.aniCounter++;
    }

}

void animateCustomer() {
    // Change the animation frame every 15 frames of gameplay
    customer.aniCounter++;

    if(customer.aniCounter % 10 == 0) {
        customer.curFrame = (customer.curFrame + 1) % customer.numFrames;
    }
}

void animateCrazy() {
    for (int i = 0; i < CRAZYCOUNT; i++) {
        crazy[i].aniCounter++;
        if (crazy[i].aniCounter % 8 == 0) {
            if (crazy[i].active) {
                crazy[i].curFrame = (crazy[i].curFrame + 1) % crazy[i].numFrames;
            }
        }
    }
}

void drawGame() {
    drawGuy();
    drawDoor();
    drawKey();
    drawTele();
    drawBoots();
    drawHeart();
    drawShirt();
    drawCustomer();
    drawBubble();
    drawCrazy();
    waitForVBlank();

    // Copy the shadowOAM into the OAM:
    DMANow(3, shadowOAM, OAM, 128 * 4);

    // Updating BG0 hOff and vOff
    REG_BG0HOFF = hOff;
    REG_BG0VOFF = vOff;
}

void drawGuy() {
    guy.numFrames = 4;
    if (life == 0 || (time_m == 0 && time_s == 0)) {
        shadowOAM[0].attr0 = ((guy.row - guyvOff) & ROWMASK) | ATTR0_SQUARE;
        shadowOAM[0].attr1 = ((guy.col - guyhOff) & COLMASK) | ATTR1_SMALL;
        shadowOAM[0].attr2 = ATTR2_TILEID(15, guy.curFrame * 2) | ATTR2_PALROW(0);
    }
    else if (guy.aniState == LEFT) {
        shadowOAM[0].attr0 = ((guy.row - guyvOff) & ROWMASK) | ATTR0_SQUARE;
        shadowOAM[0].attr1 = ((guy.col - guyhOff) & COLMASK) | ATTR1_SMALL;
        shadowOAM[0].attr2 = ATTR2_TILEID(17, guy.curFrame * 2) | ATTR2_PALROW(0);
    }
    else if (guy.aniState == RIGHT) {
        shadowOAM[0].attr0 = ((guy.row - guyvOff) & ROWMASK) | ATTR0_SQUARE;
        shadowOAM[0].attr1 = ((guy.col - guyhOff) & COLMASK) | ATTR1_SMALL;
        shadowOAM[0].attr2 = ATTR2_TILEID(15, guy.curFrame * 2) | ATTR2_PALROW(0);
    }
    else if (guy.aniState == LEFTJUMP) {
        shadowOAM[0].attr0 = ((guy.row - guyvOff) & ROWMASK) | ATTR0_SQUARE;
        shadowOAM[0].attr1 = ((guy.col - guyhOff) & COLMASK) | ATTR1_SMALL;
        shadowOAM[0].attr2 = ATTR2_TILEID(23, 0) | ATTR2_PALROW(0);
    }
    else if (guy.aniState == RIGHTJUMP) {
        shadowOAM[0].attr0 = ((guy.row - guyvOff) & ROWMASK) | ATTR0_SQUARE;
        shadowOAM[0].attr1 = ((guy.col - guyhOff) & COLMASK) | ATTR1_SMALL;
        guy.numFrames = 2;
        shadowOAM[0].attr2 = ATTR2_TILEID(21, guy.curFrame * 2) | ATTR2_PALROW(0);
    }
    else if (guy.aniState == DOWN) {
        shadowOAM[0].attr0 = ((guy.row - guyvOff) & ROWMASK) | ATTR0_SQUARE;
        shadowOAM[0].attr1 = ((guy.col - guyhOff) & COLMASK) | ATTR1_SMALL;
        shadowOAM[0].attr2 = ATTR2_TILEID(19, 0) | ATTR2_PALROW(0);
    }
    else if (guy.aniState == CLIMB) {
        shadowOAM[0].attr0 = ((guy.row - guyvOff) & ROWMASK) | ATTR0_SQUARE;
        shadowOAM[0].attr1 = ((guy.col - guyhOff) & COLMASK) | ATTR1_SMALL;
        guy.numFrames = 2;
        shadowOAM[0].attr2 = ATTR2_TILEID(25, guy.curFrame * 2) | ATTR2_PALROW(0);
    }
    else if (guy.aniState == FLOAT) {
        shadowOAM[0].attr0 = ((guy.row - guyvOff) & ROWMASK) | ATTR0_SQUARE;
        shadowOAM[0].attr1 = ((guy.col - guyhOff) & COLMASK) | ATTR1_SMALL;
        shadowOAM[0].attr2 = ATTR2_TILEID(15, guy.curFrame * 2) | ATTR2_PALROW(0);
    }
}

void drawDoor() {
    for (int i = 0; i < 3; i++) {
        if (door[i].active && door[i].row - vOff > 0 && door[i].col - hOff > 0 && door[i].col - hOff < SCREENWIDTH && door[i].row - vOff < SCREENHEIGHT) {
            shadowOAM[15].attr0 = ((door[i].row - vOff) & ROWMASK) | ATTR0_TALL;
            shadowOAM[15].attr1 = ((door[i].col - hOff) & COLMASK) | ATTR1_MEDIUM;
            shadowOAM[15].attr2 = ATTR2_TILEID(8, 0) | ATTR2_PALROW(0);
        }
        else {
            shadowOAM[15].attr0 = ATTR0_HIDE;
        }
    }
}

void drawKey() {
    for (int i = 0; i < 3; i++) {
        if (i == 0 || i == 1) {
            if (key[i].active && key[i].row - vOff > 0 && key[i].col - hOff > 0 && key[i].col - hOff < SCREENWIDTH && key[i].row - vOff < SCREENHEIGHT) {
                shadowOAM[80+i].attr0 = ((key[i].row - vOff) & ROWMASK) | ATTR0_SQUARE;
                shadowOAM[80+i].attr1 = ((key[i].col - hOff) & COLMASK) | ATTR1_SMALL;
                shadowOAM[80+i].attr2 = ATTR2_TILEID(6, 0) | ATTR2_PALROW(0);
            }
            else {
                shadowOAM[80+i].attr0 = ATTR0_HIDE;
            }
        }
        else {
            if (key[i].active && key[i].row - vOff > 0 && key[i].col - hOff > 0 && key[i].col - hOff < SCREENWIDTH && key[i].row - vOff < SCREENHEIGHT) {
                shadowOAM[80+i].attr0 = ((key[i].row - vOff) & ROWMASK) | ATTR0_SQUARE;
                shadowOAM[80+i].attr1 = ((key[i].col - hOff) & COLMASK) | ATTR1_SMALL;
                shadowOAM[80+i].attr2 = ATTR2_TILEID(6, 2) | ATTR2_PALROW(0);
            }
            else {
                shadowOAM[80+i].attr0 = ATTR0_HIDE;
            }
        }
        
    }
}

void drawTele() {
    for (int i = 0; i < 2; i++) {
        if (tele[i].row - vOff > 0 && tele[i].col - hOff > 0 && tele[i].col - hOff < SCREENWIDTH && tele[i].row - vOff < SCREENHEIGHT) {
            if (i == 0) {
                shadowOAM[50+i].attr0 = ((tele[i].row - vOff) & ROWMASK) | ATTR0_SQUARE;
                shadowOAM[50+i].attr1 = ((tele[i].col - hOff) & COLMASK) | ATTR1_MEDIUM;
                shadowOAM[50+i].attr2 = ATTR2_TILEID(28, 20) | ATTR2_PALROW(0);
            }
            else {
                shadowOAM[50+i].attr0 = ((tele[i].row - vOff) & ROWMASK) | ATTR0_SQUARE;
                shadowOAM[50+i].attr1 = ((tele[i].col - hOff) & COLMASK) | ATTR1_MEDIUM;
                shadowOAM[50+i].attr2 = ATTR2_TILEID(28, 16) | ATTR2_PALROW(0);
            }
        }
        else {
            shadowOAM[50+i].attr0 = ATTR0_HIDE;
        }
    }
}

void drawBoots() {
    if (boots.active && boots.row - vOff > 0 && boots.col - hOff > 0 && boots.col - hOff < SCREENWIDTH && boots.row - vOff < SCREENHEIGHT) {
        shadowOAM[17].attr0 = ((boots.row - vOff) & ROWMASK) | ATTR0_SQUARE;
        shadowOAM[17].attr1 = ((boots.col - hOff) & COLMASK) | ATTR1_SMALL;
        shadowOAM[17].attr2 = ATTR2_TILEID(4, 0) | ATTR2_PALROW(0);
    }
    else {
        shadowOAM[17].attr0 = ATTR0_HIDE;
    }
}

void drawShirt() {
    for (int i = 0; i < 2; i++) {
        if (shirt[i].active && shirt[i].row - vOff > 0 && shirt[i].col - hOff > 0 && shirt[i].col - hOff < SCREENWIDTH && shirt[i].row - vOff < SCREENHEIGHT) {
            shadowOAM[60+i].attr0 = ((shirt[i].row - vOff) & ROWMASK) | ATTR0_SQUARE;
            shadowOAM[60+i].attr1 = ((shirt[i].col - hOff) & COLMASK) | ATTR1_SMALL;
            shadowOAM[60+i].attr2 = ATTR2_TILEID(2, 0) | ATTR2_PALROW(0);
        }
        else {
            shadowOAM[60+i].attr0 = ATTR0_HIDE;
        }
    }
}

void drawBubble() {
    for (int i = 0; i < 2; i++) {
        if (bubble[i].active && bubble[i].row - vOff > 0 && bubble[i].col - hOff > 0 && bubble[i].col - hOff < SCREENWIDTH && bubble[i].row - vOff < SCREENHEIGHT) {
            shadowOAM[70+i].attr0 = ((bubble[i].row - vOff) & ROWMASK) | ATTR0_SQUARE;
            shadowOAM[70+i].attr1 = ((bubble[i].col - hOff) & COLMASK) | ATTR1_SMALL;
            shadowOAM[70+i].attr2 = ATTR2_TILEID(10, 0) | ATTR2_PALROW(0);
        }
        else {
            shadowOAM[70+i].attr0 = ATTR0_HIDE;
        }
    }
}

void drawCustomer() {
    if (customer.row - vOff > 0 && customer.col - hOff > 0 && customer.col - hOff < SCREENWIDTH && customer.row - vOff < SCREENHEIGHT) {
        shadowOAM[2].attr0 = (customer.row - vOff) | ATTR0_SQUARE;
        shadowOAM[2].attr1 = (customer.col - hOff) | ATTR1_SMALL;
        // customer.curFrame * 4
        shadowOAM[2].attr2 = ATTR2_TILEID(13, customer.curFrame * 2) | ATTR2_PALROW(0);
    }
    else {
        shadowOAM[2].attr0 = ATTR0_HIDE;
    }
    
}

void drawCrazy() {
    for (int i = 0; i < CRAZYCOUNT; i++) {
        shadowOAM[30+i].attr0 = ((crazy[i].row - 14 - vOff) & ROWMASK) | ATTR0_SQUARE;
        shadowOAM[30+i].attr1 = ((crazy[i].col - hOff) & COLMASK) | ATTR1_MEDIUM;
        if (crazy[i].row - vOff > 0 && crazy[i].col - hOff > 0 && crazy[i].col - hOff < SCREENWIDTH && crazy[i].row - vOff < SCREENHEIGHT) {
            // shadowOAM[30+i].attr2 = ATTR2_TILEID(30, 0) | ATTR2_PALROW(0);
            if (i == 0 || i == 2 || i == 3) {
                if (crazy[i].cdel == -1) {
                    shadowOAM[30+i].attr2 = ATTR2_TILEID(1, 4 + crazy[i].curFrame * 4) | ATTR2_PALROW(0);
                }
                else {
                    shadowOAM[30+i].attr2 = ATTR2_TILEID(5, 4 + crazy[i].curFrame * 4) | ATTR2_PALROW(0);
                }
            }
            // zombie
            else if (i == 6 || i == 8) {
                shadowOAM[30+i].attr0 = ((crazy[i].row - 17 - vOff) & ROWMASK) | ATTR0_TALL;
                shadowOAM[30+i].attr1 = ((crazy[i].col - hOff) & COLMASK) | ATTR1_MEDIUM;
                if (crazy[i].cdel == 1) {
                    shadowOAM[30+i].attr2 = ATTR2_TILEID(27, crazy[i].curFrame * 4) | ATTR2_PALROW(0);
                }
                else {
                    shadowOAM[30+i].attr2 = ATTR2_TILEID(29, crazy[i].curFrame * 4) | ATTR2_PALROW(0);
                }
                
            }
            // city enemy
            else if (i == 7) {
                shadowOAM[30+i].attr2 = ATTR2_TILEID(19, 2 + crazy[i].curFrame * 4) | ATTR2_PALROW(0);
            }
            else {
                shadowOAM[30+i].attr2 = ATTR2_TILEID(9, 4 + crazy[i].curFrame * 4) | ATTR2_PALROW(0);
            }
            
        }
        else {
            shadowOAM[30+i].attr0 = ATTR0_HIDE;
        }
    }
}

void drawHeart() {
    int shift = 0;
    for (int i = 0; i < HEARTCOUNT; i++) {
        if (heart[i].active) {
            shadowOAM[9+i].attr0 = (guy.row - 8 - guyvOff) | ATTR0_SQUARE;
            // 8 * HEARTCOUNT/2
            shadowOAM[9+i].attr1 = (guy.col - 8 + shift - guyhOff) | ATTR1_TINY;
            shadowOAM[9+i].attr2 = ATTR2_TILEID(12, 0) | ATTR2_PALROW(0);
        }
        else {
            shadowOAM[9+i].attr0 = ATTR0_HIDE;
        }
        shift += 8;
    }
}
