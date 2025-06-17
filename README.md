# 🕹️ Pong On-Chain (Solidity Edition)   
   
This is a fully on-chain Pong game built with Solidity.    
It's a turn-based, two-player logic game where ball movement, paddle positions, and scoring happen **entirely inside a smart contract**. No frontend — just pure Ethereum magic 🧙‍♂️

---

## ⚙️ How It Works

- Two players join the game via `joinGame()`
- Paddles are moved using `movePaddle(bool up)`  
- Ball is updated using `updateBall()` — it checks for collisions, bounces, and scores
- Game state is tracked with on-chain variables: positions, scores, velocity 

> Think of it as **on-chain chess** but for Pong 

---

## 🚀 Features

- ⛓️ 100% on-chain logic (no JS frontend) 
- 🧠 Smart contract-based physics (velocity, collision, scoring)
- 👥 Two-player mode (only one game at a time)
- 📦 Minimalistic and gas-conscious design

---

## 🧪 Example Interaction

```solidity
// Player 1 joins
pong.joinGame();

// Player 2 joins
pong.joinGame();

// Move paddle down
pong.movePaddle(false);

// Update ball (any player can call)
pong.updateBall();

// View state
pong.getState();
