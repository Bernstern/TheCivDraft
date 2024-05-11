export type Civ = {
  nationName: string;
  leaderName: string;
  id: number;
  iconName?: string;
};

// All of the civilizations in the game
export const Civs: Civ[] = [
  {
    nationName: "America",
    leaderName: "Abraham Lincoln",
  },
  {
    nationName: "Macedon",
    leaderName: "Alexander",
  },
  {
    nationName: "Nubia",
    leaderName: "Amanitore",
  },
  {
    nationName: "Gaul",
    leaderName: "Ambiorix",
  },
  {
    nationName: "Byzantium",
    leaderName: "Basil II",
  },
  {
    nationName: "Vietnam",
    leaderName: "Bà Triệu",
  },
  {
    nationName: "France",
    leaderName: "Catherine de Medici (Black Queen)",
  },
  {
    nationName: "France",
    leaderName: "Catherine de Medici (Magnificence)",
  },
  {
    nationName: "India",
    leaderName: "Chandragupta",
  },
  {
    nationName: "Egypt",
    leaderName: "Cleopatra (Egyptian)",
  },
  {
    nationName: "Egypt",
    leaderName: "Cleopatra (Ptolemaic)",
  },
  {
    nationName: "Persia",
    leaderName: "Cyrus",
  },
  {
    nationName: "Phoenicia",
    leaderName: "Dido",
  },
  {
    nationName: "England",
    leaderName: "Eleanor of Aquitaine",
  },
  {
    nationName: "France",
    leaderName: "Eleanor of Aquitaine",
  },
  {
    nationName: "England",
    leaderName: "Elizabeth I",
  },
  {
    nationName: "Germany",
    leaderName: "Frederick Barbarossa",
  },
  {
    nationName: "India",
    leaderName: "Gandhi",
  },
  {
    nationName: "Mongolia",
    leaderName: "Genghis Khan",
  },
  {
    nationName: "Sumeria",
    leaderName: "Gilgamesh",
  },
  {
    nationName: "Indonesia",
    leaderName: "Gitarja",
  },
  {
    nationName: "Greece",
    leaderName: "Gorgo",
  },
  {
    nationName: "Babylon",
    leaderName: "Hammurabi",
  },
  {
    nationName: "Norway",
    leaderName: "Harald Hardrada (Konge)",
  },
  {
    nationName: "Norway",
    leaderName: "Harald Hardrada (Varangian)",
  },
  {
    nationName: "Japan",
    leaderName: "Hojo Tokimune",
  },
  {
    nationName: "Poland",
    leaderName: "Jadwiga",
  },
  {
    nationName: "Khmer",
    leaderName: "Jayavarman VII",
  },
  {
    nationName: "Australia",
    leaderName: "John Curtin",
  },
  {
    nationName: "Portugal",
    leaderName: "João III",
  },
  {
    nationName: "Rome",
    leaderName: "Julius Caesar",
  },
  {
    nationName: "Sweden",
    leaderName: "Kristina",
  },
  {
    nationName: "China",
    leaderName: "Kublai Khan",
  },
  {
    nationName: "Mongolia",
    leaderName: "Kublai Khan",
  },
  {
    nationName: "Maori",
    leaderName: "Kupe",
  },
  {
    nationName: "Maya",
    leaderName: "Lady Six Sky",
  },
  {
    nationName: "Mapuche",
    leaderName: "Lautaro",
  },
  {
    nationName: "Germany",
    leaderName: "Ludwig II",
  },
  {
    nationName: "Mali",
    leaderName: "Mansa Musa",
  },
  {
    nationName: "Hungary",
    leaderName: "Matthias Corvinus",
  },
  {
    nationName: "Ethiopia",
    leaderName: "Menelik II",
  },
  {
    nationName: "Aztec",
    leaderName: "Montezuma",
  },
  {
    nationName: "Kongo",
    leaderName: "Mvemba a Nzinga",
  },
  {
    nationName: "Persia",
    leaderName: "Nader Shah",
  },
  {
    nationName: "Kongo",
    leaderName: "Nzinga Mbande",
  },
  {
    nationName: "Inca",
    leaderName: "Pachacuti",
  },
  {
    nationName: "Brazil",
    leaderName: "Pedro II",
  },
  {
    nationName: "Greece",
    leaderName: "Pericles",
  },
  {
    nationName: "Russia",
    leaderName: "Peter",
  },
  {
    nationName: "Spain",
    leaderName: "Philip II",
  },
  {
    nationName: "Cree",
    leaderName: "Poundmaker",
  },
  {
    nationName: "China",
    leaderName: "Qin Shi Huang (Mandate)",
  },
  {
    nationName: "China",
    leaderName: "Qin Shi Huang (Unifier)",
  },
  {
    nationName: "Egypt",
    leaderName: "Ramses II",
  },
  {
    nationName: "Scotland",
    leaderName: "Robert the Bruce",
  },
  {
    nationName: "Arabia",
    leaderName: "Saladin (Vizier)",
  },
  {
    nationName: "Arabia",
    leaderName: "Saladin (Sultan)",
  },
  {
    nationName: "Korea",
    leaderName: "Sejong",
  },
  {
    nationName: "Korea",
    leaderName: "Seondeok",
  },
  {
    nationName: "Zulu",
    leaderName: "Shaka",
  },
  {
    nationName: "Gran Colombian",
    leaderName: "Simón Bolívar",
    iconName: "colombia",
  },
  {
    nationName: "Ottomans",
    leaderName: "Suleiman (Kanuni)",
  },
  {
    nationName: "Ottomans",
    leaderName: "Suleiman (Muhteşem)",
  },
  {
    nationName: "Mali",
    leaderName: "Sundiata Keita",
  },
  {
    nationName: "Georgia",
    leaderName: "Tamar",
  },
  {
    nationName: "America",
    leaderName: "Teddy Roosevelt (Bull Moose)",
  },
  {
    nationName: "America",
    leaderName: "Teddy Roosevelt (Rough Rider)",
  },
  {
    nationName: "Byzantium",
    leaderName: "Theodora",
  },
  {
    nationName: "Japan",
    leaderName: "Tokugawa",
  },
  {
    nationName: "Scythia",
    leaderName: "Tomyris",
  },
  {
    nationName: "Rome",
    leaderName: "Trajan",
  },
  {
    nationName: "England",
    leaderName: "Victoria (Age of Empire)",
  },
  {
    nationName: "England",
    leaderName: "Victoria (Age of Steam)",
  },
  {
    nationName: "Canada",
    leaderName: "Wilfrid Laurier",
  },
  {
    nationName: "Netherlands",
    leaderName: "Wilhelmina",
  },
  {
    nationName: "China",
    leaderName: "Wu Zetian",
  },
  {
    nationName: "China",
    leaderName: "Yongle",
  },
]
  .sort((a, b) => a.leaderName.localeCompare(b.leaderName))
  .map((civ, index) => ({
    ...civ,
    id: index, // This will assign an ID starting from 0 to each civ
  }));

// Add a civ at -1 to represent the "None" option
export const EMPTY_CIV: Civ = {
  nationName: "",
  leaderName: "",
  iconName: "",
  id: -1,
};
