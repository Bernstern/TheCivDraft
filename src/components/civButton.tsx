import { Civ } from "../utils/civs";
import { VIEWS } from "../utils/settings";

export function createCivButton(
  civ: Civ,
  selected: number | null,
  setSelected: (id: number | null) => void,
  isBanned: number[],
  isSelected: number[],
  activeView: VIEWS
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

  if (activeView === "banning") {
    if (selected === civ.id) {
      extra_css = "bg-red-500";
    } else if (isBanned.includes(civ.id)) {
      extra_css = "bg-red-950 cursor-not-allowed";
    } else {
      extra_css = "bg-sky-800";
    }
  } else if (activeView === "drafting") {
    if (selected === civ.id) {
      extra_css = "bg-green-500";
    } else if (isBanned.includes(civ.id)) {
      extra_css = "bg-red-950 cursor-not-allowed";
    } else if (isSelected.includes(civ.id)) {
      extra_css = "bg-green-950 cursor-not-allowed";
    } else {
      extra_css = "bg-sky-800";
    }
  }

  return (
    <button
      key={`${activeView}=${civ.id}`}
      className={`relative flex flex-col items-center justify-center border-2 ${extra_css} text-white rounded`}
      style={{
        flex: 1,
        flexDirection: "column",
        minHeight: "100px",
        width: "90%",
      }}
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
