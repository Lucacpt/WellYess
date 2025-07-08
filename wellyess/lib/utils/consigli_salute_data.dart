// Lista di consigli per l'attività fisica, ogni elemento è una mappa con dettagli e suggerimenti
final List<Map<String, dynamic>> attivitaFisicaTips = [
  // Consiglio Attività Fisica 1: Camminata leggera
  {
    "svgAssetPath": "assets/icons/Vector.svg", // Percorso icona SVG
    "title": "Camminata leggera",               // Titolo del consiglio
    "subtitle": "Almeno 30 minuti al giorno",   // Sottotitolo
    "description":
        "La camminata leggera è una delle forme di esercizio più semplici, sicure ed efficaci per le persone anziane. Praticata con regolarità, contribuisce al mantenimento della salute fisica e mentale senza richiedere attrezzature o ambienti specifici. Bastano 30 minuti al giorno per trarne benefici concreti e duraturi.",
    "topics": [
      {
        "title": "Benefici", // Titolo sezione
        "text": [
          "Migliora la salute cardiovascolare",
          "Riduce lo stress",
          "Aiuta il controllo del peso"
        ]
      },
      {
        "title": "Quando praticarla",
        "text":
            "Preferibilmente al mattino o nel tardo pomeriggio, evitando le ore più calde."
      },
      {
        "title": "Consigli pratici",
        "text": [
          "Indossa scarpe comode",
          "Mantieni un ritmo costante",
          "Idratati spesso"
        ]
      },
    ]
  },

  // Consiglio Attività Fisica 2: Stretching dolce
  {
    "svgAssetPath": "assets/icons/dolce.svg",
    "title": "Stretching dolce",
    "subtitle": "Esercizi di mobilità",
    "description":
        "Lo stretching dolce è una pratica fondamentale per mantenere la mobilità articolare, prevenire dolori e migliorare la qualità dei movimenti quotidiani. È adatto a tutte le età e può essere adattato alle condizioni fisiche di ciascuno. La costanza è la chiave per ottenere benefici nel tempo.",
    "topics": [
      {
        "title": "Benefici",
        "text": [
          "Migliora la flessibilità",
          "Riduce la rigidità muscolare",
          "Aiuta l'equilibrio"
        ]
      },
      {
        "title": "Quando praticarlo",
        "text":
            "Al mattino per attivare il corpo o la sera per rilassarsi. Anche prima o dopo altre attività."
      },
      {
        "title": "Consigli pratici",
        "text": [
          "Usa un tappetino o una sedia stabile",
          "Respira profondamente",
          "Non forzare mai i movimenti"
        ]
      },
    ]
  },

  // Consiglio Attività Fisica 3: Orari consigliati
  {
    "svgAssetPath": "assets/icons/compass.svg",
    "title": "Orari consigliati",
    "subtitle": "Evita le ore calde",
    "description":
        "Durante le stagioni calde è importante scegliere con attenzione l’orario per fare attività fisica o uscire. Le alte temperature possono aumentare il rischio di disidratazione e affaticamento. Meglio approfittare delle ore più fresche.",
    "topics": [
      {
        "title": "Perché è importante",
        "text": [
          "Riduce il rischio di colpi di calore",
          "Aiuta a mantenere l’energia durante l’attività"
        ]
      },
      {
        "title": "Orari ideali",
        "text":
            "Al mattino presto o nel tardo pomeriggio in estate, a metà giornata in inverno."
      },
      {
        "title": "Consigli pratici",
        "text": [
          "Usa cappello e occhiali da sole",
          "Idratati regolarmente",
          "Evita attività sotto il sole diretto"
        ]
      },
    ]
  },
  // Consiglio Attività Fisica 4: Esercizi da seduti
  {
    "svgAssetPath": "assets/icons/divano.svg",
    "title": "Esercizi da seduti",
    "subtitle": "Attiva la circolazione",
    "description":
        "Gli esercizi da seduti sono ideali per chi ha mobilità ridotta. Si possono svolgere in sicurezza anche a casa, e aiutano a mantenere attivi muscoli e articolazioni, favorendo la circolazione sanguigna.",
    "topics": [
      {
        "title": "Benefici",
        "text": [
          "Stimola la circolazione",
          "Mantiene attivi muscoli e articolazioni",
          "Migliora la coordinazione"
        ]
      },
      {
        "title": "Quando praticarli",
        "text":
            "Ogni giorno, anche per brevi sessioni. Ottimo al mattino o durante lunghi periodi seduti."
      },
      {
        "title": "Consigli pratici",
        "text": [
          "Usa una sedia stabile",
          "Mantieni una postura corretta",
          "Accompagna l’esercizio con musica rilassante"
        ]
      },
    ]
  },
];

// Lista di consigli per l'alimentazione, ogni elemento è una mappa con dettagli e suggerimenti
final List<Map<String, dynamic>> alimentazioneTips = [
  // Consiglio Alimentazione 1: Frutta e verdura
  {
    "svgAssetPath": "assets/icons/mela.svg",
    "title": "Frutta e verdura",
    "subtitle": "Cinque porzioni al giorno",
    "description":
        "Frutta e verdura sono essenziali per una dieta equilibrata, soprattutto in età avanzata. Ricche di vitamine, fibre e antiossidanti, aiutano a mantenere il benessere generale e a rafforzare le difese immunitarie. Variarle ogni giorno, anche nei colori, è importante per assumere diversi nutrienti.",
    "topics": [
      {
        "title": "Benefici",
        "text": [
          "Apportano fibre, vitamine e antiossidanti",
          "Migliorano la digestione",
          "Rafforzano il sistema immunitario"
        ]
      },
      {
        "title": "Quando consumarle",
        "text":
            "Ogni giorno, suddivise tra i pasti principali e gli spuntini."
      },
      {
        "title": "Consigli pratici",
        "text": [
          "Scegli prodotti di stagione",
          "Prepara frullati, zuppe e insalate",
          "Alterna frutta e verdura di diversi colori"
        ]
      },
    ]
  },
  // Consiglio Alimentazione 2: Proteine magre
  {
    "svgAssetPath": "assets/icons/fish.svg",
    "title": "Proteine magre",
    "subtitle": "Pesce, legumi, carni bianche",
    "description":
        "Le proteine magre aiutano a mantenere la massa muscolare e a supportare il metabolismo. Preferire fonti leggere come pesce, legumi e carni bianche permette di nutrirsi in modo sano senza sovraccaricare l’organismo con grassi saturi.",
    "topics": [
      {
        "title": "Benefici",
        "text": [
          "Mantengono il tono muscolare",
          "Favoriscono la rigenerazione cellulare",
          "Aiutano il sistema immunitario"
        ]
      },
      {
        "title": "Quando consumarle",
        "text":
            "Ogni giorno nei pasti principali, alternando le fonti tra pesce, legumi e carni bianche."
      },
      {
        "title": "Consigli pratici",
        "text": [
          "Prediligi cotture leggere (vapore, forno)",
          "Usa erbe aromatiche al posto del sale",
          "Abbina le proteine a verdure e cereali integrali"
        ]
      },
    ]
  },
  // Consiglio Alimentazione 3: Limitare lo zucchero
  {
    "svgAssetPath": "assets/icons/no_sugar.svg",
    "title": "Limitare lo zucchero",
    "subtitle": "Evitare bevande zuccherate",
    "description":
        "Un consumo eccessivo di zucchero aumenta il rischio di diabete, sovrappeso e malattie cardiovascolari. È importante ridurre dolci, snack e bevande zuccherate, preferendo alimenti naturali e poco lavorati.",
    "topics": [
      {
        "title": "Rischi dell’eccesso",
        "text":
            "Favorisce sovrappeso, diabete, problemi cardiovascolari e carie dentali."
      },
      {
        "title": "Alimenti da limitare",
        "text":
            "Bevande zuccherate, succhi confezionati, dolci industriali, snack e cereali zuccherati."
      },
      {
        "title": "Consigli pratici",
        "text": [
          "Sostituisci i dolci con frutta fresca",
          "Leggi le etichette",
          "Riduci gradualmente lo zucchero in tè e caffè"
        ]
      },
    ]
  },
  // Consiglio Alimentazione 4: Bere regolarmente
  {
    "svgAssetPath": "assets/icons/bottle.svg",
    "title": "Bere regolarmente",
    "subtitle": "Mantieni il corpo idratato",
    "description":
        "Con l’avanzare dell’età, la percezione della sete si riduce, ma il bisogno di acqua resta elevato. Bere regolarmente aiuta a mantenere il corpo idratato, supporta le funzioni vitali e previene problemi come crampi, stanchezza e infezioni urinarie.",
    "topics": [
      {
        "title": "Benefici",
        "text": [
          "Favorisce la digestione",
          "Regola la temperatura corporea",
          "Aiuta il funzionamento dei reni e del cervello"
        ]
      },
      {
        "title": "Quando bere",
        "text":
            "Durante tutta la giornata, anche senza sete. Meglio prima dei pasti, dopo attività fisica e con il caldo."
      },
      {
        "title": "Consigli pratici",
        "text": [
          "Tieni sempre a portata una bottiglia d’acqua",
          "Imposta promemoria",
          "Bevi tisane non zuccherate e brodi leggeri"
        ]
      },
    ]
  },
];