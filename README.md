<h1 align ='center' >          Brick Breaker Game (8086 Assembly)</h1> 

>> Put GIF
>> Put Dividers 
>> Notes must be shown as very important instructions
## Overview

This is a Brick Breaker game developed in Assembly 8086, featuring multiple gameplay modes including single-player, two-player, and chat functionality via serial communication. The game includes challenging mechanics, power-ups, and a competitive ping pong phase!

## Features

Let's introduce the main page first, as the following image shows, you can go through any mode of the four available modes by pressing their keys.
### 1.  **Chat Mode**:
In this mode, communication takes place through text mode. Players can exchange messages via serial communication, allowing both sending and receiving of messages between them.
___
### 2.  **One Player Mode**:


This mode operates in assembly video mode and includes the following exciting features:

- Three levels of increasing difficulty.
- Bricks with varying health values (requiring multiple hits to break).
- Power-ups that enhance the speed of the paddle and ball.
- Three lives per player with a scoring system.

### NOTE: To start playing this mode, use the 1 and 3 keys on your keyboard (not the left and right arrow keys).
___
### 3. **Two Player Mode**:
This mode operates in assembly video mode and includes the following exciting features:
  - Two players compete on separate computers via serial communication.
  - The first player to clear all bricks wins.
  - If a player loses all lives first, they lose the match.
  - The winner of the brick-breaker phase gains an advantage in the next phase.
>> Put icons here to show that it is a special phase 
  - **Ping Pong Phase**: The game transitions into a ping pong match where the winner from the brick-breaker game has a larger paddle.
  
  ## NOTE:
- Press the `F` key to start the two-player mode synchronously. Remember, use **uppercase F**, not **lowercase f**.
- To start playing, use the `1` and `3` keys on your keyboard (not the left and right arrow keys).
  ___
### 4.  **Ping Pong Mode**:

As mentioned earlier, you can access this mode either by pressing `4` from the main menu or by playing the two-player mode, which will automatically transition into the ping pong game after the brick-breaker phase.

This mode operates in assembly video mode and includes the following exciting features:
  - A standalone ping pong match using serial communication.
  - The first player to reach the target score wins.

  ## NOTE:
- Press the `Q` key to start the two-player mode synchronously. Remember, use **uppercase Q**, not **lowercase q**.
- To start playing, use the `2` and `5` keys on your keyboard (not the up and down arrow keys).

## Setup Requirements 

- DOSBox
- MASM/TASM assembler.
- Serial communication setup for multiplayer modes.

## Installation

1. Ensure you have an emulator like DOSBox or a real 8086-compatible system.
2. Install an assembler like MASM or TASM.
3. Clone this repository:
   ```sh
   git clone <repository-url>
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

## Controls

To sum up what we have introduced in each mode to ensure you have a wonderful experience with our game:

### 1. **Start the mode** after pressing its key from the main menu (not to mess up between those two things)
  - Press the `F` key to start the two-player mode synchronously. Remember, use **uppercase F**, not **lowercase f**.
 - Press the `Q` key to start the ping pong mode synchronously. Remember, use **uppercase Q**, not **lowercase q**.
 
### 2. **Arrow Keys**: Move the paddle 

- To start playing the two-player game, use the `1` and `3` keys on your keyboard (not the left and right arrow keys).
- To start playing ping pong, use the `2` and `5` keys on your keyboard (not the up and down arrow keys).
## Acknowledgments

This project was developed as part of a microprocessors course, showcasing game development using low-level assembly programming and serial communication.


## Contributors



<div style="display: flex; flex-wrap: wrap; gap: 20px; justify-content: center;">
  <div style="text-align: center;">
    <a href="https://github.com/AmiraKhalid04" target="_blank">
      <img src="https://avatars.githubusercontent.com/u/149877108?s=400&v=4" alt="Amira" style="width: 100px; height: 100px; border-radius: 50%;"/>
    </a>
    <p><strong><a href="https://github.com/AmiraKhalid04" target="_blank">Amira Khalid</a></strong></p>
  </div>
  
  <div style="text-align: center;">
    <a href="https://github.com/Alyaa242" target="_blank">
      <img src="https://avatars.githubusercontent.com/u/69475479?v=4" alt="Alyaa" style="width: 100px; height: 100px; border-radius: 50%;"/>
    </a>
    <p><strong><a href="https://github.com/Alyaa242" target="_blank">Alyaa Ali</a></strong></p>
  </div>
  <div style="text-align: center;">
    <a href="https://github.com/ahmedkamal14" target="_blank">
      <img src="https://avatars.githubusercontent.com/u/153025116?v=4" alt="Ahmed Kamal" style="width: 100px; height: 100px; border-radius: 50%;"/>
    </a>
    <p><strong><a href="https://github.com/ahmedkamal14" target="_blank">Ahmed Kamal</a></strong></p>
  </div>


  <div style="text-align: center;">
    <a href="https://github.com/ahmed-haz" target="_blank">
      <img src="https://avatars.githubusercontent.com/u/149868137?v=4" alt="Ahmed Hazem" style="width: 100px; height: 100px; border-radius: 50%;"/>
    </a>
    <p><strong><a href="https://github.com/ahmed-haz" target="_blank">Ahmed Hazem</a></strong></p>
  </div>
</div>
