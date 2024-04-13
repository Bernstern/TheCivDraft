"use client";
import { Civ, Civs } from "./utils/civs";
import { DEFAULT_NUM_GAMES, DEFAULT_NUM_PLAYERS } from "./utils/settings";
import { useEffect, useState } from "react";

function getNextPlayer(
  current: number,
  max: number,
  turnRound: number
): number {
  if (turnRound % 2 === 0) {
    // Even rounds (0, 2, 4,...) go backwards
    return current > 1 ? current - 1 : max;
  } else {
    // Odd rounds (1, 3, 5,...) go forwards
    return current < max ? current + 1 : 1;
  }
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
    extra_css = "bg-green-500";
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
  const [selected, setSelected] = useState<number | null>(null);
  const [bannedCivs, setBannedCivs] = useState<number[]>([]);
  const [currentPlayer, setCurrentPlayer] = useState(DEFAULT_NUM_PLAYERS);
  const [civsRemainingThisRound, setCivsRemainingThisRound] =
    useState<number>(DEFAULT_NUM_GAMES);
  const [turnRound, setTurnRound] = useState(0);
  const totalTurns = DEFAULT_NUM_PLAYERS * DEFAULT_NUM_GAMES;
  const bansLeft = totalTurns - bannedCivs.length;

  console.log("bannedCivs", bannedCivs);
  console.log("currentPlayer", currentPlayer);
  console.log("civsRemainingThisRound", civsRemainingThisRound);
  console.log("turnRound", turnRound);
  console.log("totalTurns", totalTurns);
  console.log("bansLeft", bansLeft);

  const handleConfirm = () => {
    if (selected === null) {
      console.log("No Civ Selected");
      return;
    }

    // Calculate all updates first
    const newBannedCivs = [...bannedCivs, selected];
    const newCivsRemainingThisRound = civsRemainingThisRound - 1;
    const newTurnRound =
      newCivsRemainingThisRound === 0 ? turnRound + 1 : turnRound;
    const newCurrentPlayer = getNextPlayer(
      currentPlayer,
      DEFAULT_NUM_PLAYERS,
      newTurnRound
    );

    // Now, batch the updates
    setBannedCivs(newBannedCivs);
    setSelected(null); // Reset the selected civ
    setCivsRemainingThisRound(
      newCivsRemainingThisRound <= 0
        ? DEFAULT_NUM_GAMES
        : newCivsRemainingThisRound
    );
    setTurnRound(newTurnRound);
    setCurrentPlayer(newCurrentPlayer);
  };

  const civButtons = Civs.map((civ) =>
    createCivButton(civ, selected, setSelected, bannedCivs)
  );

  return (
    <main className="flex min-h-screen flex-col items-center justify-between p-24">
      <div className="flex w-full justify-between items-center">
        <div>
          <h1 className="text-5xl font-bold">The Civ Draft</h1>
          <em className="text-lg">Banning Phase</em>
        </div>
        <div>
          <div className="text-5xl font-bold">Player {currentPlayer}</div>
          <em className="text-lg">{bansLeft} Bans Left</em>
        </div>
      </div>

      <div
        style={{
          display: "grid",
          gridTemplateColumns: "repeat(11, 1fr)",
          gap: "6px",
          overflowY: "auto",
          minHeight: "80vh",
        }}
      >
        {civButtons}
      </div>

      {selected !== null && (
        <button
          className="mt-4 p-2 bg-green-600 text-white rounded shadow-lg hover:bg-green-700 transition-colors"
          onClick={handleConfirm}
        >
          Confirm Selection
        </button>
      )}
    </main>
  );
}
