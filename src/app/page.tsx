import { Civs, Civ } from "./settings";

export default function Home() {
  console.log(Civs);

  // Create a scrollable list of all the civilizations
  const civList = Civs.map((civ) => {
    return (
      <div
        key={civ.nationName}
        className="flex items-center p-4 m-2 bg-blue-500 text-white rounded-lg"
      >
        <img
          src={civ.iconPath || "Icon_civilization_america.webp"}
          alt={civ.nationName}
          className="w-10 h-10"
        />
        <div className="ml-4">
          <h2 className="text-xl font-bold">{civ.nationName}</h2>
          <p>{civ.leaderName}</p>
        </div>
      </div>
    );
  });

  return (
    <main className="flex min-h-screen flex-col items-center justify-center p-24">
      <div className="flex flex-col items-center justify-center">
        <h1 className="text-5xl font-bold">The Civ Draft</h1>
        <p className="text-center">Coming Spring 2024</p>
      </div>

      {/* <div className="relative flex place-items-center before:absolute before:h-[300px] before:w-full sm:before:w-[480px] before:-translate-x-1/2 before:rounded-full before:bg-gradient-radial before:from-white before:to-transparent before:blur-2xl before:content-[''] after:absolute after:-z-20 after:h-[180px] after:w-full sm:after:w-[240px] after:translate-x-1/3 after:bg-gradient-conic after:from-sky-200 after:via-blue-200 after:blur-2xl after:content-[''] before:dark:bg-gradient-to-br before:dark:from-transparent before:dark:to-blue-700 before:dark:opacity-10 after:dark:from-sky-900 after:dark:via-[#0141ff] after:dark:opacity-40 before:lg:h-[360px] z-[-1]">
        <Image
          className="relative dark:drop-shadow-[0_0_0.3rem_#ffffff70] dark:invert"
          src="/next.svg"
          alt="Next.js Logo"
          width={180}
          height={37}
          priority
        />
      </div> */}
    </main>
  );
}
