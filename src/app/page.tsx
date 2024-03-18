import Image from "next/image";
import { Civ, Civs } from "@/library/civs";

export default function Home() {
  // Create a list of buttons for each civ with a click handler
  const civButtons = Civs.map((civ: Civ) => {
    let imgPath =
      "/images/" +
      (civ.iconName ? civ.iconName : civ.nationName.toLowerCase()) +
      ".png";

    const match = civ.leaderName.match(/\((.*?)\)/);

    let subscript = civ.nationName;
    if (match) {
      civ.leaderName = civ.leaderName.replace(match[0], "").trim();
      subscript = civ.nationName + " - " + match[1];
    }

    return (
      <button
        key={civ.leaderName}
        className="relative flex flex-col items-center justify-center p-1 m-2 border-2 border-white bg-sky-900 text-white  rounded"
        style={{
          flex: 1,
          flexDirection: "column",
          minHeight: "100px",
        }}
      >
        <img
          src={imgPath}
          alt={civ.nationName}
          className="absolute inset-0 h-full w-full object-cover opacity-25"
        />

        <span className="text-xl">{civ.leaderName}</span>

        {/* Nation name in italics */}
        <i className="text-lg">{subscript}</i>
      </button>
    );
  });

  return (
    <main className="flex min-h-screen flex-col items-center justify-between p-24">
      <div className="flex flex-col items-center">
        <h1 className="text-5xl font-bold">The Civ Draft</h1>
        Banning Phase
      </div>

      <div
        style={{
          display: "grid",
          gridTemplateColumns: "repeat(11, 1fr)",
          gap: "6px",
          overflowY: "auto",
          scrollbarWidth: "none" /* For Firefox */,
          msOverflowStyle: "none" /* For Internet Explorer and Edge */,
          minHeight: "80vh",
        }}
      >
        {civButtons}
      </div>
    </main>
  );
}
