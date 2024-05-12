import RGL, { WidthProvider } from "react-grid-layout";
import { Civs, EMPTY_CIV } from "../utils/civs";
import { getNextPlayer } from "../utils/logic";
import { createCivButton } from "./civButton";

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

const GridLayout = WidthProvider(RGL);

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

  // Get all the selected civs
  const allSelectedCivs = Array.from(selectedCivs.values()).flat();

  // Sanity checks
  if (picksLeft <= 0) {
    console.error(`Invalid civsRemainingThisRound: ${civsRemainingThisRound}`);
    return <div></div>;
  }

  // Here we are going to show one massive grid
  const selectionGridCells = [];

  // Header row will have a cell for the player number, and then n cells for n totalGames for each pick, an empty cell for spacing, then again n cells for the selected civs
  selectionGridCells.push(
    <div
      key="header"
      data-grid={{
        x: 0,
        y: 0,
        w: 1,
        h: 1,
        static: true,
      }}
    ></div>
  );

  // Add a header row with n columns for n totalGames
  for (let i = 0; i < totalGames; i++) {
    selectionGridCells.push(
      <div
        key={`drafted-header-${i}`}
        data-grid={{
          x: i + 1,
          y: 0,
          w: 1,
          h: 1,
          static: true,
        }}
      >
        <div className="text-center">Pick {i + 1}</div>
      </div>
    );
  }

  // Add an empty cell for spacing
  selectionGridCells.push(
    <div
      key="empty"
      data-grid={{
        x: totalGames + 1,
        y: 0,
        w: 1,
        h: 1,
        static: true,
      }}
    ></div>
  );

  // Add a header row with n columns for n totalGames
  for (let i = 0; i < totalGames; i++) {
    selectionGridCells.push(
      <div
        key={`selected-header-${i}`}
        data-grid={{
          x: totalGames + 2 + i,
          y: 0,
          w: 1,
          h: 1,
          static: true,
        }}
      >
        <div className="text-center">Game {i + 1}</div>
      </div>
    );
  }

  // Add one more empty cell for spacing
  selectionGridCells.push(
    <div
      key="empty-2"
      data-grid={{
        x: totalGames + 2 + totalGames + 1,
        y: 0,
        w: 1,
        h: 1,
        static: true,
      }}
    ></div>
  );

  // Now for each player, we will add a row with n columns for n totalGames for each pick, an empty cell for spacing, then again n cells for the selected civs
  for (let i = 1; i <= totalPlayers; i++) {
    // Player number
    selectionGridCells.push(
      <div
        key={`player-${i}`}
        data-grid={{
          x: 0,
          y: i,
          w: 1,
          h: 1,
          static: true,
        }}
      >
        <div className="text-center">Player {i}</div>
      </div>
    );

    // Add a cell for each pick
    for (let j = 0; j < totalGames; j++) {
      const civId = draftedCivs.get(i)?.[j] || EMPTY_CIV;
      const civ = Civs.find((c) => c.id === civId) || EMPTY_CIV;

      selectionGridCells.push(
        <div
          key={`drafted-${i}-${j}`}
          data-grid={{
            x: j + 1,
            y: i,
            w: 1,
            h: 1,
            static: true,
          }}
        >
          {createCivButton(
            civ,
            selected,
            currentPlayer == i
              ? (id: number | null) =>
                  setSelectionState({ ...selectionState, selected: id })
              : () => {},
            [],
            allSelectedCivs,
            "selecting",
            draftedCivs.get(currentPlayer) // Only allow the current player to select
          )}
        </div>
      );
    }

    // Add an empty cell for spacing
    selectionGridCells.push(
      <div
        key={`empty-${i}`}
        data-grid={{
          x: totalGames + 1,
          y: i,
          w: 1,
          h: 1,
          static: true,
        }}
      >
        <div className="text-center"> </div>
      </div>
    );

    // Add a cell for each selected civ
    const selectedCivsForPlayer = selectedCivs.get(i) || [];
    for (let j = 0; j < selectedCivsForPlayer.length; j++) {
      const civId = selectedCivsForPlayer[j];
      const civ = Civs.find((c) => c.id === civId) || EMPTY_CIV;

      selectionGridCells.push(
        <div
          key={`selected-${i}-${j}`}
          data-grid={{
            x: totalGames + 2 + j,
            y: i,
            w: 1,
            h: 1,
            static: true,
          }}
        >
          {createCivButton(civ, null, () => {}, [], [], "results", [])}
        </div>
      );
    }
  }

  const handleConfirm = () => {
    if (selected === null) {
      console.log("No Civ Selected");
      return;
    }

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
      "reverse"
    );

    setSelectionState({
      ...selectionState,
      selected: null,
      selectedCivs: new Map(
        selectedCivs.set(currentPlayer, playersSelectedCivs)
      ),
      currentPlayer: newCurrentPlayer,
      civsRemainingThisRound: newCivsRemainingThisRound,
      turnRound: newTurnRound,
    });
  };

  return (
    <main className="main">
      <div className="header">
        <div>
          <h1 className="text-5xl font-bold">The Civ Draft</h1>
          <em className="text-lg">Selection Phase</em>
        </div>
        <div>
          <div className="text-5xl font-bold">Player {currentPlayer}</div>
          <em className="text-lg">Selecting {picksLeft}</em>
        </div>
      </div>

      <div className="centered-div">
        <GridLayout className="grid-layout" isBounded={true} width={1200}>
          {selectionGridCells}
        </GridLayout>
      </div>

      {selected !== null && (
        <button className="confirm-button" onClick={handleConfirm}>
          Confirm Selection
        </button>
      )}
    </main>
  );
}
