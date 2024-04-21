export type SNAKE_DIRECTION = "normal" | "reverse";

/**
 * Calculates the next player's turn in a round-robin fashion.
 *
 * @param current - The current player's number.
 * @param max - The maximum number of players.
 * @param turnRound - The current round number.
 * @param civsRemainingThisRound - The number of civilizations remaining in the current round.
 * @param snakeDirection - The direction of the snake draft.
 * @returns The number of the next player. If the current round is odd, the next player is the one after the current player, wrapping around to 1 after reaching the maximum. If the current round is even, the next player is the one before the current player, wrapping around to the maximum after reaching 1. If there are no civilizations remaining in the current round, the next player is 1 if the current round is odd, or the maximum if the current round is even.
 */
export function getNextPlayer(
  current: number,
  max: number,
  turnRound: number,
  civsRemainingThisRound: number,
  snakeDirection: SNAKE_DIRECTION
): number {
  let isForward: boolean = false;

  // Depending on the snake direction, the player order is reversed every other round
  if (snakeDirection === "normal") {
    isForward = turnRound % 2 === 0;
  } else {
    isForward = turnRound % 2 === 1;
  }

  if (civsRemainingThisRound === 0) {
    return isForward ? 1 : max;
  }

  if (isForward) {
    return current === max ? 1 : current + 1;
  } else {
    return current === 1 ? max : current - 1;
  }
}
