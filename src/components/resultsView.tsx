import React, { useState } from "react";
import {
  DEFAULT_NUM_GAMES,
  DEFAULT_NUM_PLAYERS,
  VIEWS,
} from "../utils/settings";
import { getNextPlayer } from "../utils/logic";
import { createCivButton } from "./civButton";
import { Civs } from "../utils/civs";
import RGL, { WidthProvider } from "react-grid-layout";

const GridLayout = WidthProvider(RGL);

export interface ResultsState {
  selectedCivs: Map<number, number[]>;
}

export function ResultsView(resultsState: ResultsState): JSX.Element {
  const { selectedCivs } = resultsState;

  const gridCells = [];
  const numGames = selectedCivs.size;

  // Add a header row for the player number and then n cells for n totalGames
  gridCells.push(
    <div
      key="header"
      data-grid={{
        x: 0,
        y: 0,
        w: 1,
        h: 1,
        static: true,
      }}
    >
      Player
    </div>
  );

  for (let i = 0; i < numGames; i++) {
    gridCells.push(
      <div
        key={`header=${i}`}
        data-grid={{
          x: i + 1,
          y: 0,
          w: 1,
          h: 1,
          static: true,
        }}
      >
        Game {i + 1}
      </div>
    );
  }

  return (
    <GridLayout className="layout" cols={12} rowHeight={30} width={1200}>
      {gridCells}
    </GridLayout>
  );
}
