import { useState } from "react";
import { getNextPlayer } from "../utils/logic";
import { createCivButton } from "./civButton";
import { Civs } from "../utils/civs";
import { VIEWS } from "../utils/settings";
import RGL, { Layout, WidthProvider } from "react-grid-layout";

const GridLayout = WidthProvider(RGL);

export interface BanningState {
  selected: number | null;
  bannedCivs: number[];
  currentPlayer: number;
  civsRemainingThisRound: number;
  turnRound: number;
  totalGames: number;
  totalPlayers: number;
}

export function BanningView(
  banningState: BanningState,
  setBanningState: (state: BanningState) => void,
  setActiveView: (view: VIEWS, extraData: number[]) => void
): JSX.Element {
  const {
    selected,
    bannedCivs,
    currentPlayer,
    civsRemainingThisRound,
    turnRound,
    totalGames,
    totalPlayers,
  } = banningState;
  const totalTurns = banningState.totalPlayers * banningState.totalGames;
  const bansLeft = totalTurns - bannedCivs.length;

  // Sanity checks
  //  - Ensure that civsRemainingThisRound is always between 0 and totalPlayers
  if (civsRemainingThisRound < 0 || civsRemainingThisRound > totalPlayers) {
    console.error(`Invalid civsRemainingThisRound: ${civsRemainingThisRound}`);
    return <div></div>;
  }

  console.log(banningState);

  const handleConfirm = () => {
    if (selected === null) {
      console.log("No Civ Selected");
      return;
    }

    const newBannedCivs = [...bannedCivs, selected];
    const newCivsRemainingThisRound =
      civsRemainingThisRound <= 1 ? totalPlayers : civsRemainingThisRound - 1;
    const newTurnRound =
      civsRemainingThisRound === 1 ? turnRound + 1 : turnRound;
    const newCurrentPlayer = getNextPlayer(
      currentPlayer,
      banningState.totalPlayers,
      newTurnRound,
      civsRemainingThisRound - 1,
      "reverse"
    );

    setBanningState({
      ...banningState,
      selected: null, // Reset the selected civ
      bannedCivs: newBannedCivs,
      civsRemainingThisRound: newCivsRemainingThisRound,
      turnRound: newTurnRound,
      currentPlayer: newCurrentPlayer,
    });

    // Determine if we need to move to the drafting phase
    if (newTurnRound === banningState.totalGames) {
      setActiveView("drafting", newBannedCivs);
    }
  };

  console.log(Civs);

  const NUM_COLS = 12;

  const civButtons = Civs.map((civ, i) => (
    <div
      key={civ.id}
      data-grid={{
        x: i % NUM_COLS,
        y: Math.floor(i / NUM_COLS),
        w: 1,
        h: 1,
        static: true,
      }}
    >
      {createCivButton(
        civ,
        selected,
        (id: number | null) =>
          setBanningState({ ...banningState, selected: id }),
        bannedCivs,
        [],
        "banning"
      )}
    </div>
  ));

  return (
    <main className="main">
      <div className="header">
        <div>
          <h1 className="text-5xl font-bold">The Civ Draft</h1>
          <em className="text-lg">Banning Phase</em>
        </div>
        <div>
          <div className="text-5xl font-bold">Player {currentPlayer}</div>
          <em className="text-lg">{bansLeft} Bans Left</em>
        </div>
      </div>

      <GridLayout className="layout" isBounded={true}>
        {civButtons}
      </GridLayout>

      {selected !== null && (
        <button className="confirm-button" onClick={handleConfirm}>
          Confirm Selection
        </button>
      )}
    </main>
  );
}
