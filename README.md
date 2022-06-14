# I-Wanna-Be-The-Delivery-Guy

## A GBA Platformer

------------------------------------------------

**Game Settings**：
**States**
A state machine is set with enum: instruction, start, game, pause, win, lose

**Collision checks**
The idea is to check the movement the character is trying to accomplish beforehand; if the movement will cause a collision with the blocks in the collision map, then ignore the movement input, otherwise, move the character in the game world. In other words, all movements will need to pass this before implementation.

**Timer**
The time limit to complete the game is set to 2 minutes.

**Gravity**
Gravity is set to 10 (the character is keeping moving downward by 10 per frame if not on the ground). When the character is jumping, climbing ladders, or floating, gravity is set to 0 and back to 10 after the action or the power-up effect is finished.

**Movement**
Character move left/right or climb up/down the ladder based on its row speed and col speed, which are set to 1. So, the character’s position in the game world will increase or decrease corresponding to the speed.

**Jump**
Jumping is achieved by moving the character 15 towards left or right and 24 upward in the game world. It lasts 25 frames.

**Teleporter**
A pair of devices that will teleport the character after encountering the entrance one by setting the character’s coordinate in the game world to another.

**Cheat**
There are doors in the game and corresponding keys to unlock them to use the shortcut ladder, which acts as a cheat to make the game easier (and to fulfil the nostalgia of GBA games).

**Power-ups:**

**Super jump**
A power-up that allows the character to jump higher temporarily (25 toward left or right and 50 upward). It lasts 120 frames.

**Float**
A power-up that will float the character (keep moving upward by speed 1 if no obstacles are encountered), the player can control the character to move towards left or right at the same movement speed, but no other inputs are allowed. It lasts 130 frames.

**Extra life**
An item that can give the character an extra life.



**<u>Game Design</u>**：
*All the designs are done surrounding the core experience.*

The target gameplay experience is to throw the player in a highly intense environment, with no space for relaxation but focus on the game, and need to think, make decisions quickly and play carefully. Meanwhile, the player will need to keep learning and adapting as they discover new environments and obstacles along the way. Hence, different items with different effects that can help the player to proceed forward are designed correspondingly. Also, a countdown timer is set to increase the intensity.

Moreover, since this is a game for the GBA platform, a retro life system is implemented instead of checkpoints for each level, and if the character lost all its lives, the player will be forced to restart the game. Therefore, it requires players to play precisely and intentionally under pressure rather than just spam inputs. There is a delay for each jumping input after the first one because it is a quite ‘powerful’ movement that allows the character to escape from enemies and overcome obstacles, and the delay is to make it scarce to force the player to use it precisely.



<u>**Level Design**</u>:
*Levels are designed to provide different feelings that can enrich player experience.*

The environment is designed to be intuitive, so players can know clearly where they should go next and have a smooth movement flow across levels.

Also, the levels are designed for the player to choose whether to use the cheat or not, both sides will come with risks. This is to let the player have a sense of control and the degree of freedom to make choices. The conflict is that they must do it under pressure, and the time limit of power-ups and the game, so that the intensity is increased with the tasks that have to be completed in a short time period.

The first level is for guidance, implying the gameplay mechanics, input logic, the style of levels, and how to use the cheat.

The second level is to introduce most of the enemies and power-ups, the peak of the difficulty on the player's learning curve.

The last level is to let the player use all they learned from the previous levels with a little something new.

 

<u>**Enemies & Interactions**</u>:
Since the character is just a messenger, to maintain the verisimilitude, the game is designed to encourage the player to avoid enemies by not giving any abilities or weapons to fight back, and if the character collides with enemies, one life will be deducted.

To keep the consistency in gameplay, the character picks up power-ups by colliding with the item or the objects in the game world (ladders, teleporter) to interact with them directly rather than requiring another key input.

There are two types of enemies:

1. Forever patrolling in an area
    The movements are hardcoded, easier for the player to dodge and predict actions.
2. Static and attacks with a certain pattern
    The player has to learn the attack pattern to avoid life deduction.

There will be invincible frames for the character after collision with enemies.

 

\#All art assets are from creators on itch.io and used in this project for educational purposes
