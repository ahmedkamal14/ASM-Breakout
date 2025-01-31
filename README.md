<h1 align ='center' >          Brick Breaker Game (8086 Assembly)</h1> 
<p align="center">

  <img width="700" height ="400" align="center" src="https://maximkoshel.github.io/web/images/brick_breaker.gif" alt="demo"/>
</p>

## Overview <img src="https://i.imgur.com/JvvuvsB.png" width = "28" />

This is a Brick Breaker game developed in Assembly 8086, featuring multiple gameplay modes including single-player, two-player, and chat functionality via serial communication. The game includes challenging mechanics, power-ups, and a competitive ping pong phase!

## Features <img src="https://i.imgur.com/5Wgs9AN.png" width="28" />

Let's introduce the main page first, as the following image shows, you can go through any mode of the four available modes by pressing their keys.

<img width="700" height ="400" align="center" src="Pasted image 20250131201437.png" alt="demo"/>

### 1. Chat Mode <img src="https://i.imgur.com/oX0oaoH.png" width="24" />

In this mode, communication takes place through text mode. Players can exchange messages via serial communication, allowing both sending and receiving of messages between them.
<img width="700" height ="400" align="center" src="Pasted image 20250131201344.png" alt="demo"/>

### 2. One Player Mode <img src="https://i.imgur.com/SzHotcI.png" width="24" />

This mode operates in assembly video mode and includes the following exciting features:

- Three levels of increasing difficulty.
- Bricks with varying health values (requiring multiple hits to break).
- Power-ups that enhance the speed of the paddle and ball.
- Three lives per player with a scoring system.

### <img src="https://i.imgur.com/vI2uXuF.png" width="28" /> To start playing this mode, use the 1 and 3 keys on your keyboard (not the left and right arrow keys). <img src="https://i.imgur.com/vI2uXuF.png" width="28" />

<img width="700" height ="400" align="center" src="Pasted image 20250131201359.png" alt="demo"/>
### 3. Two Player Mode <img src="https://i.imgur.com/dA4mclF.png" width="24" />

This mode operates in assembly video mode and includes the following exciting features:

- Two players compete on separate computers via serial communication.
- The first player to clear all bricks wins.
- If a player loses all lives first, they lose the match.
- The winner of the brick-breaker phase gains an advantage in the next phase.
- <span style="color:yellow">Ping Pong Phase</span> The game transitions into a ping pong match where the winner from the brick-breaker game has a larger paddle.

<img src="https://i.imgur.com/vI2uXuF.png" width="24" /> **NOTE**

- Press the `F` key to start the two-player mode synchronously. Remember, use **uppercase F**, not **lowercase f**.
- To start playing, use the `1` and `3` keys on your keyboard (not the left and right arrow keys).

<img width="700" height ="400" align="center" src="Pasted image 20250131201416.png" alt="demo"/>
### 4. Ping Pong Mode <img src="https://i.imgur.com/H9sDMIn.png" width="24" />

As mentioned earlier, you can access this mode either by pressing `4` from the main menu or by playing the two-player mode, which will automatically transition into the ping pong game after the brick-breaker phase.
This mode operates in assembly video mode and includes the following exciting features:

- A standalone ping pong match using serial communication.
- The first player to reach the target score wins.

<img src="https://i.imgur.com/vI2uXuF.png" width="24" /> **NOTE**

- Press the `Q` key to start the two-player mode synchronously. Remember, use **uppercase Q**, not **lowercase q**.
- To start playing, use the `2` and `5` keys on your keyboard (not the up and down arrow keys).

<img width="700" height ="400" align="center" src="Pasted image 20250131201423.png" alt="demo"/>

## Setup Requirements <img src="https://i.imgur.com/DRfWA84.png" width="28" />

- DOSBox
- MASM/TASM assembler.
- Serial communication setup for multiplayer modes.

## Installation <img src="https://i.imgur.com/38wRuFY.png" width="28" />

1. Ensure you have an emulator like DOSBox or a real 8086-compatible system.

2. Install an assembler like MASM or TASM.

3. Clone this repository:

   ```sh
   git clone https://github.com/ahmedkamal14/ASM-Breakout.git
   ```

4. Assemble the game:

   ```sh
   tasm main.asm
   ```

5. Link the executable:

   ```sh
   link main.obj
   ```

6. Run the game:
   ```sh
   main.exe
   ```

## Controls <img src="https://i.imgur.com/SL1knAy.png" width="28" />

To ensure you have a fantastic experience with our game, here’s a summary of how each mode works:

1. **Starting a Mode**

   - Press the designated key from the main menu to select a mode.
   - **Two-Player Mode:** Press **F** (uppercase) to start synchronously. Do not use lowercase **f**.
   - **Ping Pong Mode:** Press **Q** (uppercase) to start synchronously. Do not use lowercase **q**.

2. **Paddle Controls**
   - **Two-Player Mode:** Use the **1** and **3** keys to move the paddle (not the left and right arrow keys).
   - **Ping Pong Mode:** Use the **2** and **5** keys to move the paddle (not the up and down arrow keys).

## Acknowledgments <img src="https://i.imgur.com/RKvyljD.png" width="28" />

This project was developed as part of a microprocessors course, showcasing game development using low-level assembly programming and serial communication.

## Contributors <img src="https://i.imgur.com/SfBB4jV.png" width="28" />

| <a href="https://avatars.githubusercontent.com/u/149877108?s=400&v=4"><img src="https://avatars.githubusercontent.com/u/149877108?s=400&v=4" alt="Amira" width="150"></a> | <a href="https://avatars.githubusercontent.com/u/69475479?v=4"><img src="https://avatars.githubusercontent.com/u/69475479?v=4" alt="Alyaa" width="150"></a> | <a href="https://avatars.githubusercontent.com/u/153025116?v=4"><img src="https://avatars.githubusercontent.com/u/153025116?v=4" alt="Ahmed" width="150"></a> | <a href="https://avatars.githubusercontent.com/u/149868137?v=4"><img src="https://avatars.githubusercontent.com/u/149868137?v=4" alt="Ahmed Hazem" width="150"></a> |
| :-----------------------------------------------------------------------------------------------------------------------------------------------------------------------: | :---------------------------------------------------------------------------------------------------------------------------------------------------------: | :-----------------------------------------------------------------------------------------------------------------------------------------------------------: | :-----------------------------------------------------------------------------------------------------------------------------------------------------------------: |
|                                                             [Amira Khalid](https://github.com/AmiraKhalid04)                                                              |                                                          [Alyaa Ali](https://github.com/Alyaa242)                                                           |                                                        [Ahmed Kamal](https://github.com/ahmedkamal14)                                                         |                                                             [Ahmed Hazem](https://github.com/ahmed-haz)                                                             |
