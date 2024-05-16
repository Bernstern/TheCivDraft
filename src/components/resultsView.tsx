import React, { useState } from "react";
import {
  DEFAULT_NUM_GAMES,
  DEFAULT_NUM_PLAYERS,
  VIEWS,
} from "../utils/settings";
import { getNextPlayer } from "../utils/logic";
import { createCivButton } from "./civButton";
import { Civ, Civs, EMPTY_CIV } from "../utils/civs";
import RGL, { WidthProvider } from "react-grid-layout";

const GridLayout = WidthProvider(RGL);

export interface ResultsState {
  selectedCivs: Map<number, number[]>;
}

export function ResultsView(resultsState: ResultsState): JSX.Element {
  const { selectedCivs } = resultsState;
  const gridCells = [];
  const numPlayers = selectedCivs.size;
  const numGames = selectedCivs.get(1)?.length || DEFAULT_NUM_GAMES;

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
    ></div>
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
        <div className="text-center">Game {i + 1}</div>
      </div>
    );
  }

  // Then for each player, add a cell for the player number and then n cells for n civs they selected
  for (let i = 1; i <= numPlayers; i++) {
    gridCells.push(
      <div
        key={`player=${i}`}
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

    console.log(selectedCivs.get(i));
    for (let j = 0; j < numGames; j++) {
      const civId: number = selectedCivs.get(i)?.[j] || -1;
      const civ: Civ = Civs.find((c) => c.id === civId) || EMPTY_CIV;

      gridCells.push(
        <div
          key={`player=${i}-game=${j}`}
          data-grid={{
            x: j + 1,
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

  return (
    <main className="main">
      <div className="header">
        <div>
          <h1 className="text-5xl font-bold">The Civ Draft</h1>
          <em className="text-lg">Draft Results</em>
        </div>
      </div>

      <div className="centered-div">
        <GridLayout className="grid-layout" isBounded={true} width={1200}>
          {gridCells}
        </GridLayout>
      </div>
    </main>
  );
}
