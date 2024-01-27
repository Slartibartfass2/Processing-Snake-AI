# Processing-Snake-AI

An evolutional AI playing Snake.

This was a project I made in 2018 when I got inspired by [The Coding Train](https://www.youtube.com/@TheCodingTrain/videos) to work with [Processing](https://processing.org/).

## What it does

1. Generates a set of neural networks (snake brains) with randomized weights.
2. The neural network has:
    - an input layer with 6 nodes (0-2: are the neighboring tiles clear, 3-5: is there food on the neighboring tiles)
    - two hidden layers with 8 nodes each
    - an output layer with 3 nodes for each direction, the snake will go in the direction with the highest value
3. Every round the neural network is evaluated and the snake moves to the next tile.
4. The new position of the snake is evaluated and stored in a score.
5. After all snakes have died (or when only snakes with negative scores remain), the brains of the top 10% are cloned and mutated to create the next generation of snakes.
