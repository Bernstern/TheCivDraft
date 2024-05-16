"use client";
import { BanningState } from "./components/banView";
import { DraftingState, DraftingView } from "./components/draftView";
import { SelectionState, SelectionView } from "./components/selectionView";
import { ResultsState, ResultsView } from "./components/resultsView";
import { useEffect, useState } from "react";
import {
  DEFAULT_NUM_GAMES,
  DEFAULT_NUM_PLAYERS,
  VIEWS,
} from "./utils/settings";
import { BanningView } from "./components/banView";
import { set } from "lodash";

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
    bannedCivs: [5, 17, 12],
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
      [1, [1, 2, 13, 19]],
      [2, [4, 5, 22, 29]],
      [3, [7, 8, 25, 31]],
    ]),
    // Initialize selected civs to be -1 for all players for all games
    selectedCivs: new Map(),
    currentPlayer: globalState.numPlayers,
    civsRemainingThisRound: globalState.numPlayers,
    turnRound: 0,
    totalGames: globalState.numGames,
    totalPlayers: globalState.numPlayers,
  });

  const [resultsState, setResultsState] = useState<ResultsState>({
    selectedCivs: new Map([
      [1, [1, 2, 13, 19]],
      [2, [4, 5, 22, 29]],
      [3, [7, 8, 25, 31]],
    ]),
  });

  // Wrap set active view to only allow moving forward and also update the global state
  const setActiveViewWrapper = (view: VIEWS, extraData: any) => {
    // If we are in banning and want to progress to drafting
    if (activeView === "banning" && view === "drafting") {
      console.log("Moving from banning to drafting");
      setDraftState({
        ...draftState,
        bannedCivs: extraData,
      });
      setActiveView(view);
      return;
    }

    // If we are in drafting and want to progress to selection
    if (activeView === "drafting" && view === "selecting") {
      console.log("Moving from drafting to selection");
      setSelectionState({
        ...selectionState,
        draftedCivs: extraData,
      });
      setActiveView(view);
      return;
    }

    // If we are in selection and want to progress to results
    if (activeView === "selecting" && view === "results") {
      console.log("Moving from selecting to results");
      setResultsState({
        ...resultsState,
        selectedCivs: extraData,
      });
      setActiveView(view);
      return;
    }

    // Throw an error of an invalid view transition is attempted
    throw new Error(`Invalid view transition from ${activeView} to ${view}`);
  };

  // If we are in the banning view, show the banning view
  if (activeView === "banning") {
    return BanningView(banState, setBanState, setActiveViewWrapper);
  } else if (activeView === "drafting") {
    return DraftingView(draftState, setDraftState, setActiveViewWrapper);
  } else if (activeView === "selecting") {
    return SelectionView(
      selectionState,
      setSelectionState,
      setActiveViewWrapper
    );
  } else if (activeView === "results") {
    return ResultsView(resultsState);
  } else {
    throw new Error(`View not supported at app.tsx: ${activeView}`);
  }
}
