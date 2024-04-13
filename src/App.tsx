"use client";
import { Civ, Civs } from "./utils/civs";
import { getNextPlayer } from "./utils/logic";
import { DEFAULT_NUM_GAMES, DEFAULT_NUM_PLAYERS } from "./utils/settings";
import { useEffect, useState } from "react";

interface BanningState {
  selected: number | null;
  bannedCivs: number[];
  currentPlayer: number;
  civsRemainingThisRound: number;
  turnRound: number;
}

function createCivButton(
  civ: Civ,
  selected: number | null,
  setSelected: (id: number | null) => void,
  isBanned: number[]
): JSX.Element {
  const imgPath = `/images/${
    civ.iconName ? civ.iconName : civ.nationName.toLowerCase()
  }.png`;
  const match = civ.leaderName.match(/\((.*?)\)/);
  const leaderName = match
    ? civ.leaderName.replace(match[0], "").trim()
    : civ.leaderName;
  const subscript = match ? `${civ.nationName} - ${match[1]}` : civ.nationName;

  let extra_css = "bg-sky-900";

  if (selected === civ.id) {
    extra_css = "bg-red-500";
  } else if (isBanned.includes(civ.id)) {
    extra_css = "bg-stone-900 cursor-not-allowed";
  } else {
    extra_css = "bg-sky-800";
  }

  return (
    <button
      key={civ.id}
      className={`relative flex flex-col items-center justify-center p-1 m-2 border-2 ${extra_css} text-white rounded`}
      style={{ flex: 1, flexDirection: "column", minHeight: "100px" }}
      onClick={() =>
        !isBanned.includes(civ.id) &&
        setSelected(selected === civ.id ? null : civ.id)
      }
      disabled={isBanned.includes(civ.id)}
    >
      <img
        src={imgPath}
        alt={civ.nationName}
        className="absolute inset-0 h-full w-full object-cover opacity-25"
      />
      <span className="text-xl">{leaderName}</span>
      <i className="text-lg">{subscript}</i>
    </button>
  );
}

export default function Home(): JSX.Element {
  const [gameState, setGameState] = useState<BanningState>({
    selected: null,
    bannedCivs: [],
    currentPlayer: DEFAULT_NUM_PLAYERS,
    civsRemainingThisRound: DEFAULT_NUM_GAMES,
    turnRound: 0,
  });

  const {
    selected,
    bannedCivs,
    currentPlayer,
    civsRemainingThisRound,
    turnRound,
  } = gameState;
  const totalTurns = DEFAULT_NUM_PLAYERS * DEFAULT_NUM_GAMES;
  const bansLeft = totalTurns - bannedCivs.length;

  const handleConfirm = () => {
    if (selected === null) {
      console.log("No Civ Selected");
      return;
    }

    const newBannedCivs = [...bannedCivs, selected];
    const newCivsRemainingThisRound = civsRemainingThisRound - 1;
    const newTurnRound =
      newCivsRemainingThisRound === 0 ? turnRound + 1 : turnRound;
    const newCurrentPlayer = getNextPlayer(
      currentPlayer,
      DEFAULT_NUM_PLAYERS,
      newTurnRound,
      newCivsRemainingThisRound
    );

    setGameState({
      ...gameState,
      selected: null, // Reset the selected civ
      bannedCivs: newBannedCivs,
      civsRemainingThisRound: newCivsRemainingThisRound,
      turnRound: newTurnRound,
      currentPlayer: newCurrentPlayer,
    });
  };

  const civButtons = Civs.map((civ) =>
    createCivButton(
      civ,
      selected,
      (id: number | null) => setGameState({ ...gameState, selected: id }),
      bannedCivs
    )
  );

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

      <div className="grid-container">{civButtons}</div>

      {selected !== null && (
        <button className="confirm-button" onClick={handleConfirm}>
          Confirm Selection
        </button>
      )}
    </main>
  );
}
