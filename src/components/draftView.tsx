import { useState } from "react";
import { DEFAULT_NUM_GAMES, DEFAULT_NUM_PLAYERS } from "../utils/settings";
import { getNextPlayer } from "../utils/logic";
import { createCivButton } from "./civButton";
import { Civs } from "../utils/civs";

export interface DraftingState {
  selected: number | null;
  bannedCivs: number[];
  selectedCivs: Map<number, number[]>; // Map of player to an array of civs
  currentPlayer: number;
  civsRemainingThisRound: number;
  turnRound: number;
  totalGames: number;
  totalPlayers: number;
}

export function DraftingView(
  draftState: DraftingState,
  setDraftState: (state: DraftingState) => void
): JSX.Element {
  const {
    selected,
    bannedCivs,
    selectedCivs,
    currentPlayer,
    civsRemainingThisRound,
    turnRound,
    totalGames,
    totalPlayers,
  } = draftState;

  const totalTurns = totalPlayers * totalGames;
  // Number of picks left is the total number of turns minus the number of civs already selected by all playsre
  const picksLeft =
    totalTurns - Array.from(selectedCivs.values()).flat().length;

  const civButtons = Civs.map((civ) =>
    createCivButton(
      civ,
      draftState.selected,
      (id: number | null) => setDraftState({ ...draftState, selected: id }),
      draftState.bannedCivs,
      Array.from(selectedCivs.values()).flat(),
      "drafting"
    )
  );

  const handleConfirm = () => {
    if (selected === null) {
      console.log("No Civ Selected");
      return;
    }

    console.log("Player", currentPlayer, "selected", selected);

    // Add the civ to the selectedCivs map for that player
    const playersSelectedCivs = [
      ...(selectedCivs.get(currentPlayer) || []),
      selected,
    ];

    // Update the remaining players
    const newCivsRemainingThisRound =
      civsRemainingThisRound <= 1 ? totalPlayers : civsRemainingThisRound - 1;
    const newTurnRound =
      civsRemainingThisRound === 1 ? turnRound + 1 : turnRound;
    const newCurrentPlayer = getNextPlayer(
      currentPlayer,
      totalPlayers,
      newTurnRound,
      civsRemainingThisRound - 1,
      "normal"
    );

    // Determine if we need to move to the map selection
    if (newTurnRound === totalGames) {
      console.log("Moving to map selection");
    }

    setDraftState({
      ...draftState,
      selected: null,
      selectedCivs: new Map(
        selectedCivs.set(currentPlayer, playersSelectedCivs)
      ),
      civsRemainingThisRound: newCivsRemainingThisRound,
      turnRound: newTurnRound,
      currentPlayer: newCurrentPlayer,
    });
  };

  return (
    <main className="main">
      <div className="header">
        <div>
          <h1 className="text-5xl font-bold">The Civ Draft</h1>
          <em className="text-lg">Drafting Phase</em>
        </div>
        <div>
          <div className="text-5xl font-bold">Player {currentPlayer}</div>
          <em className="text-lg">{picksLeft} Picks Left</em>
        </div>
      </div>

      <div className="grid-container">{civButtons}</div>

      {selected !== null && (
        <button className="confirm-button" onClick={handleConfirm}>
          Confirm Selection
        </button>
      )}
    </main>
  );
}
