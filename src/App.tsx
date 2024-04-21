"use client";
import { BanningState, BanningView } from "./components/banView";
import { DraftingState, DraftingView } from "./components/draftView";
import { useEffect, useState } from "react";
import { DEFAULT_NUM_GAMES, DEFAULT_NUM_PLAYERS } from "./utils/settings";

type views = "banning" | "drafting";

interface GlobalState {
  numPlayers: number;
  numGames: number;
  bannedCivs: number[];
}

export default function Home(): JSX.Element {
  const [activeView, setActiveView] = useState<views>("banning");

  // TODO: Be able to configure the number of players and games
  const [globalState, setGlobalState] = useState<GlobalState>({
    numPlayers: DEFAULT_NUM_PLAYERS,
    numGames: DEFAULT_NUM_GAMES,
    bannedCivs: [1, 3, 5, 12, 15, 29, 51, 22, 13],
  });

  const [banState, setBanState] = useState<BanningState>({
    selected: null,
    bannedCivs: [],
    currentPlayer: globalState.numGames,
    civsRemainingThisRound: globalState.numPlayers,
    turnRound: 0,
    totalGames: globalState.numGames,
    totalPlayers: globalState.numPlayers,
  });

  const [draftState, setDraftState] = useState<DraftingState>({
    selected: null,
    bannedCivs: [],
    currentPlayer: globalState.numGames,
    civsRemainingThisRound: globalState.numPlayers,
    turnRound: 0,
    totalGames: globalState.numGames,
    totalPlayers: globalState.numPlayers,
  });

  // Wrap set active view to only allow moving forward and also update the global state

  // If we are in the banning view, show the banning view
  if (activeView === "banning") {
    return BanningView(banState, setBanState, setActiveView);
  } else {
    return DraftingView(draftState, setDraftState);
    // TODO
    return <div></div>;
  }
}
