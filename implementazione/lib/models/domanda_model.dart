// lib/models/domanda_model.dart

enum StatoDomanda {
  nuova,
  incompleta,
  completa,
}

class DomandaModel {
  final String testo;
  final DateTime data;
  StatoDomanda stato;
  final String personaggio;   // NUOVO CAMPO: Nome del personaggio o dell'argomento della chat
  final String immagineAsset; // NUOVO CAMPO: Percorso dell'immagine da usare in assets

  DomandaModel({
    required this.testo,
    required this.data,
    this.stato = StatoDomanda.nuova,
    required this.personaggio,   // Richiedi questo campo nel costruttore
    required this.immagineAsset, // Richiedi questo campo nel costruttore
  });

  // Metodo per cambiare lo stato (esistente)
  void cambiaStato(StatoDomanda nuovoStato) {
    stato = nuovoStato;
  }

  // Metodo per verificare se la domanda è stata aperta (esistente)
  void apriDomanda() {
    if (stato == StatoDomanda.nuova) {
      stato = StatoDomanda.incompleta;
    }
  }

  // Metodo per segnare come completata (esistente)
  void completaDomanda() {
    stato = StatoDomanda.completa;
  }

  // Getter per ottenere il colore dello stato (esistente)
  String get statoLabel {
    switch (stato) {
      case StatoDomanda.nuova:
        return "Nuova";
      case StatoDomanda.incompleta:
        return "Incompleta";
      case StatoDomanda.completa:
        return "Completata";
    }
  }

  // Aggiunto il metodo copyWith per aggiornare facilmente le istanze immutabili
  DomandaModel copyWith({
    String? testo,
    DateTime? data,
    StatoDomanda? stato,
    String? personaggio,
    String? immagineAsset,
  }) {
    return DomandaModel(
      testo: testo ?? this.testo,
      data: data ?? this.data,
      stato: stato ?? this.stato,
      personaggio: personaggio ?? this.personaggio,
      immagineAsset: immagineAsset ?? this.immagineAsset,
    );
  }
}