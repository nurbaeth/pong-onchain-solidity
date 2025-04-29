// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PongGame {
    uint8 public constant WIDTH = 10;
    uint8 public constant HEIGHT = 5;

    struct Game {
        address player1;
        address player2;
        uint8 paddle1Y;
        uint8 paddle2Y;
        uint8 ballX;
        uint8 ballY;
        int8 ballVX;
        int8 ballVY;
        uint8 score1;
        uint8 score2;
        bool started;
    }

    Game public game;

    modifier onlyPlayers() {
        require(msg.sender == game.player1 || msg.sender == game.player2, "Not a player");
        _;
    }

    function joinGame() external {
        if (game.player1 == address(0)) {
            game.player1 = msg.sender;
        } else if (game.player2 == address(0)) {
            require(msg.sender != game.player1, "Already joined");
            game.player2 = msg.sender;
            _startGame();
        } else {
            revert("Game full");
        }
    }

    function _startGame() internal {
        game.paddle1Y = HEIGHT / 2;
        game.paddle2Y = HEIGHT / 2;
        game.ballX = WIDTH / 2;
        game.ballY = HEIGHT / 2;
        game.ballVX = 1;
        game.ballVY = 1;
        game.started = true;
    }

    function movePaddle(bool up) external onlyPlayers {
        if (msg.sender == game.player1) {
            if (up && game.paddle1Y > 0) game.paddle1Y--;
            else if (!up && game.paddle1Y < HEIGHT - 1) game.paddle1Y++;
        } else {
            if (up && game.paddle2Y > 0) game.paddle2Y--;
            else if (!up && game.paddle2Y < HEIGHT - 1) game.paddle2Y++;
        }
    }

    function updateBall() external onlyPlayers {
        require(game.started, "Game not started");

        // Move ball
        int8 newX = int8(game.ballX) + game.ballVX;
        int8 newY = int8(game.ballY) + game.ballVY;

        // Bounce on top/bottom
        if (newY < 0 || newY >= int8(HEIGHT)) {
            game.ballVY *= -1;
            newY = int8(game.ballY) + game.ballVY;
        }

        // Left paddle
        if (newX == 0) {
            if (newY == int8(game.paddle1Y)) {
                game.ballVX *= -1;
            } else {
                game.score2++;
                _resetBall();
                return;
            }
        }

        // Right paddle
        if (newX == int8(WIDTH) - 1) {
            if (newY == int8(game.paddle2Y)) {
                game.ballVX *= -1;
            } else {
                game.score1++;
                _resetBall();
                return;
            }
        }

        game.ballX = uint8(int8(game.ballX) + game.ballVX);
        game.ballY = uint8(int8(game.ballY) + game.ballVY);
    }

    function _resetBall() internal {
        game.ballX = WIDTH / 2;
        game.ballY = HEIGHT / 2;
        game.ballVX *= -1;
        game.ballVY = (game.ballVY == 0) ? int8(1) : game.ballVY;
    }

    function getState() external view returns (
        uint8 paddle1Y,
        uint8 paddle2Y,
        uint8 ballX,
        uint8 ballY,
        int8 ballVX,
        int8 ballVY,
        uint8 score1,
        uint8 score2
    ) {
        return (
            game.paddle1Y,
            game.paddle2Y,
            game.ballX,
            game.ballY,
            game.ballVX,
            game.ballVY,
            game.score1,
            game.score2
        );
    }
}
