import { useState } from "react";
import { getNextPlayer } from "../utils/logic";
import { createCivButton } from "./civButton";
import { Civs, EMPTY_CIV } from "../utils/civs";
import { VIEWS } from "../utils/settings";

export interface SelectionState {
  selected: number | null;
  draftedCivs: Map<number, number[]>;
  selectedCivs: Map<number, number[]>;
  currentPlayer: number;
  civsRemainingThisRound: number;
  turnRound: number;
  totalGames: number;
  totalPlayers: number;
}

export function SelectionView(
  selectionState: SelectionState,
  setSelectionState: (state: SelectionState) => void
): JSX.Element {
  let {
    selected,
    draftedCivs,
    selectedCivs,
    currentPlayer,
    civsRemainingThisRound,
    turnRound,
    totalGames,
    totalPlayers,
  } = selectionState;

  // Header content
  const totalTurns = totalPlayers * totalGames;
  const picksLeft =
    totalTurns - Array.from(selectedCivs.values()).flat().length;

  // Create a grid where the number of columns is how many games there are * 2
  //  and the number of rows is the number of players
  const gridColumns = totalGames * 2;
  const gridRows = totalPlayers;

  const playerRows = [];

  for (let i = 1; i <= totalPlayers; i++) {
    console.log("Creating player row", i);
    const playerRow = [];

    const onSelection = function (playerId: number, civId: number) {
      console.log("Player", playerId, "selected", civId);
      // Remove the civ from the drafted civs for the player and then add it to their selected civs
      const playerDraftedCivs = draftedCivs.get(playerId) || [];
      const playerSelectedCivs = selectedCivs.get(playerId) || [];

      const civIndex = playerDraftedCivs.indexOf(civId);
      if (civIndex !== -1) {
        playerDraftedCivs.splice(civIndex, 1);
        playerSelectedCivs.push(civId);
      } else {
        console.error(
          `Player ${playerId} did not have civ ${civId} in their drafted civs`
        );
      }

      draftedCivs.set(playerId, playerDraftedCivs);
      selectedCivs.set(playerId, playerSelectedCivs);

      setSelectionState({
        ...selectionState,
        draftedCivs: new Map(draftedCivs),
        selectedCivs: new Map(selectedCivs),
      });
    };

    // Add a button for each of their drafted civs
    const playerDraftedCivs = draftedCivs.get(i) || [];
    for (let j = 0; j < playerDraftedCivs.length; j++) {
      const civ = Civs[playerDraftedCivs[j]] || EMPTY_CIV;
      playerRow.push(
        <div className="flex" key={`civButton-${i}-${j}`}>
          {createCivButton(
            civ,
            null,
            () => {
              onSelection(i, civ.id);
            },
            [],
            [],
            "selecting"
          )}
        </div>
      );
    }

    // Wrap the player row in a flex container so that it is displayed horizontally
    playerRows.push({ playerRow });
  }

  return (
    <main className="main">
      <div className="header">
        <div>
          <h1 className="text-5xl font-bold">The Civ Draft</h1>
          <em className="text-lg">Selection Phase</em>
        </div>
        <div>
          <div className="text-5xl font-bold">Player {currentPlayer}</div>
          <em className="text-lg">{picksLeft} Selections Left</em>
        </div>
      </div>

      <div className="selection-container">{playerRows}</div>
    </main>
  );
}
