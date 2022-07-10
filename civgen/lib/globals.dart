library civgen.globals;

// Setup fields
int numPlayers = 3;
int numCivs = 3;

int maxPlayers = 12;
int maxCivs = 6;

List<String> civList = [
  "American (RR)",
  "American (BM)",
  "Arabian",
  "Australia",
  "Aztec",
  "Babylonian",
  "Brazilian",
  "Byzantine",
  "Canadian",
  "Chinese (KK)",
  "Chinese (QSH)",
  "Cree",
  "Dutch",
  "Egyptian",
  "English (V)",
  "English (E)",
  "Ethiopia",
  "French (BQ)",
  "French (M)",
  "Gallic",
  "Georgian",
  "German",
  "Gran Colombian",
  "Greek (P)",
  "Greek (G)",
  "Hungarian",
  "Indian (G)",
  "Indian (C)",
  "Japanese",
  "Khmer",
  "Kongolese",
  "Korean",
  "Incan",
  "Indonesia",
  "Macedonian",
  "Mali",
  "Māori",
  "Mapuche",
  "Mayan",
  "Mongolian (GK)",
  "Mongolian (KK)",
  "Persia",
  "Phoenician",
  "Poland",
  "Portugal",
  "Roman",
  "Russian",
  "Scythian",
  "Scottish",
  "Spanish",
  "Swedish",
  "Sumerian",
  "Vietnam",
  "Zulu"
];
List<bool> isBannedList = List<bool>.generate(civList.length, (i) => false);
