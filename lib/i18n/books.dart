// [BIB7E-ORBIT-27] books.dart — i18n de nomes + helpers

const List<String> kBooksCanon = [
  "genesis","exodo","levitico","numeros","deuteronomio","josue","juizes","rute",
  "1samuel","2samuel","1reis","2reis","1cronicas","2cronicas","esdras","neemias",
  "ester","jo","salmos","proverbios","eclesiastes","cantares","isaias","jeremias",
  "lamentacoes","ezequiel","daniel","oseias","joel","amos","obadias","jonas",
  "miqueias","naum","habacuque","sofonias","ageu","zacarias","malaquias",
  "mateus","marcos","lucas","joao","atos","romanos","1corintios","2corintios",
  "galatas","efesios","filipenses","colossenses","1tessalonicenses","2tessalonicenses",
  "1timoteo","2timoteo","tito","filemom","hebreus","tiago","1pedro","2pedro",
  "1joao","2joao","3joao","judas","apocalipse"
];

const Map<String, String> kNamesPT = {
  "genesis":"Gênesis","exodo":"Êxodo","levitico":"Levítico","numeros":"Números","deuteronomio":"Deuteronômio",
  "josue":"Josué","juizes":"Juízes","rute":"Rute","1samuel":"1 Samuel","2samuel":"2 Samuel",
  "1reis":"1 Reis","2reis":"2 Reis","1cronicas":"1 Crônicas","2cronicas":"2 Crônicas",
  "esdras":"Esdras","neemias":"Neemias","ester":"Ester","jo":"Jó","salmos":"Salmos",
  "proverbios":"Provérbios","eclesiastes":"Eclesiastes","cantares":"Cânticos","isaias":"Isaías",
  "jeremias":"Jeremias","lamentacoes":"Lamentações","ezequiel":"Ezequiel","daniel":"Daniel",
  "oseias":"Oséias","joel":"Joel","amos":"Amós","obadias":"Obadias","jonas":"Jonas",
  "miqueias":"Miquéias","naum":"Naum","habacuque":"Habacuque","sofonias":"Sofonias",
  "ageu":"Ageu","zacarias":"Zacarias","malaquias":"Malaquias",
  "mateus":"Mateus","marcos":"Marcos","lucas":"Lucas","joao":"João","atos":"Atos",
  "romanos":"Romanos","1corintios":"1 Coríntios","2corintios":"2 Coríntios",
  "galatas":"Gálatas","efesios":"Efésios","filipenses":"Filipenses","colossenses":"Colossenses",
  "1tessalonicenses":"1 Tessalonicenses","2tessalonicenses":"2 Tessalonicenses",
  "1timoteo":"1 Timóteo","2timoteo":"2 Timóteo","tito":"Tito","filemom":"Filemom",
  "hebreus":"Hebreus","tiago":"Tiago","1pedro":"1 Pedro","2pedro":"2 Pedro",
  "1joao":"1 João","2joao":"2 João","3joao":"3 João","judas":"Judas","apocalipse":"Apocalipse"
};

const Map<String, String> kNamesEN = {
  "genesis":"Genesis","exodo":"Exodus","levitico":"Leviticus","numeros":"Numbers","deuteronomio":"Deuteronomy",
  "josue":"Joshua","juizes":"Judges","rute":"Ruth","1samuel":"1 Samuel","2samuel":"2 Samuel",
  "1reis":"1 Kings","2reis":"2 Kings","1cronicas":"1 Chronicles","2cronicas":"2 Chronicles",
  "esdras":"Ezra","neemias":"Nehemiah","ester":"Esther","jo":"Job","salmos":"Psalms",
  "proverbios":"Proverbs","eclesiastes":"Ecclesiastes","cantares":"Song of Songs","isaias":"Isaiah",
  "jeremias":"Jeremiah","lamentacoes":"Lamentations","ezequiel":"Ezekiel","daniel":"Daniel",
  "oseias":"Hosea","joel":"Joel","amos":"Amos","obadias":"Obadiah","jonas":"Jonah",
  "miqueias":"Micah","naum":"Nahum","habacuque":"Habakkuk","sofonias":"Zephaniah",
  "ageu":"Haggai","zacarias":"Zechariah","malaquias":"Malachi",
  "mateus":"Matthew","marcos":"Mark","lucas":"Luke","joao":"John","atos":"Acts",
  "romanos":"Romans","1corintios":"1 Corinthians","2corintios":"2 Corinthians",
  "galatas":"Galatians","efesios":"Ephesians","filipenses":"Philippians","colossenses":"Colossians",
  "1tessalonicenses":"1 Thessalonians","2tessalonicenses":"2 Thessalonians",
  "1timoteo":"1 Timothy","2timoteo":"2 Timothy","tito":"Titus","filemom":"Philemon",
  "hebreus":"Hebrews","tiago":"James","1pedro":"1 Peter","2pedro":"2 Peter",
  "1joao":"1 John","2joao":"2 John","3joao":"3 John","judas":"Jude","apocalipse":"Revelation"
};

String mapSlugToName(String slug, {String lang = "pt"}) {
  final s = (slug).toLowerCase();
  final dict = lang == "en" ? kNamesEN : kNamesPT;
  if (dict.containsKey(s)) return dict[s]!;
  if (lang != "pt" && kNamesPT.containsKey(s)) return kNamesPT[s]!;
  // fallback: “1corintios” → “1 Corintios”
  final spaced = s.replaceAllMapped(RegExp(r'(\\d)([a-z])'), (m) => '${m[1]} ${m[2]}').replaceAll('-', ' ');
  return spaced.split(' ').map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1)}').join(' ');
}

