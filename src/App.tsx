"use client";
import { BanningState } from "./components/banView";
import { DraftingState, DraftView } from "./components/draftView";
import { SelectionState, SelectionView } from "./components/selectionView";
import { useEffect, useState } from "react";
import {
  DEFAULT_NUM_GAMES,
  DEFAULT_NUM_PLAYERS,
  VIEWS,
} from "./utils/settings";
import { BanningView } from "./components/banView";

interface GlobalState {
  numPlayers: number;
  numGames: number;
}

export default function Home(): JSX.Element {
  const [activeView, setActiveView] = useState<VIEWS>("banning");

  // TODO: Be able to configure the number of players and games
  const [globalState, setGlobalState] = useState<GlobalState>({
    numPlayers: DEFAULT_NUM_PLAYERS,
    numGames: DEFAULT_NUM_GAMES,
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
    selectedCivs: new Map(),
    currentPlayer: 1,
    civsRemainingThisRound: globalState.numPlayers,
    turnRound: 0,
    totalGames: globalState.numGames,
    totalPlayers: globalState.numPlayers,
  });

  const [selectionState, setSelectionState] = useState<SelectionState>({
    selected: null,
    // draftedCivs: new Map(),
    draftedCivs: new Map([
      [1, [1, 2, 13]],
      [2, [4, 5, 22]],
      [3, [7, 8, 25]],
    ]),
    // Initialize selected civs to be -1 for all players for all games
    selectedCivs: new Map(),
    currentPlayer: globalState.numPlayers,
    civsRemainingThisRound: globalState.numPlayers,
    turnRound: 0,
    totalGames: globalState.numGames,
    totalPlayers: globalState.numPlayers,
  });

  // Wrap set active view to only allow moving forward and also update the global state
  const setActiveViewWrapper = (view: VIEWS, extraData: any) => {
    // If we are in banning and want to progress to drafting
    if (activeView === "banning") {
      console.log("Moving from banning to drafting");
      setDraftState({
        ...draftState,
        bannedCivs: extraData,
      });
      setActiveView(view);
      return;
    }

    // If we are in drafting and want to progress to selection
    if (activeView === "drafting") {
      console.log("Moving from drafting to selection");
      setSelectionState({
        ...selectionState,
        draftedCivs: extraData,
      });
      setActiveView(view);
      return;
    }

    // Throw an error of an invalid view transition is attempted
    throw new Error(`Invalid view transition from ${activeView} to ${view}`);
  };

  // If we are in the banning view, show the banning view
  if (activeView === "banning") {
    // return BanningView(banState, setBanState, setActiveViewWrapper);
    return BanningView(banState, setBanState, setActiveViewWrapper);
    // } else if (activeView === "drafting") {
    // return new DraftView({ draftState, setDraftState }).render();
  } else if (activeView === "selecting") {
    return new SelectionView({}, selectionState, setSelectionState).render();
  } else {
    throw new Error(`Invalid view: ${activeView}`);
  }
}
