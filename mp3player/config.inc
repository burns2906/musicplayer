{
  Diese Datei gehört zu MP3FileUtils.pas
}

{
  Compiler-Schalter-TNT: (zum Benutzen der TNTs den Punkt . vor dem $ löschen)
  Es werden einige Funktionen der TNTs benutzt, insbesondere
  WideFileExists und
  TTntFileStream
  Wenn diese nicht benutzt werden sollen, weil man nur Unterstützung für Ansi-Dateinamen haben möchte,
  werden dann die Ansi-Typen/-Funktionen verwendet.
}

{.$DEFINE USE_TNT_COMPOS}

{
  Compiler-Schalter DIConverters (zum Benutzen von DIConverters den Punkt . vor dem $ löschen)
  Für eine korrekte Darstellung von Tags, bei deren Erstellung ein anderer Zeichensatz verwendet wurde,
  ist ein Umkonvertierung nötig.
  Dazu wird DI_Converters benötigt.

  Hinweis:
  Dies ist eigentlich nur dann sinnvoll, wenn man auch die TNTs mit einbindet, denn das kann nur auftreten
  (bzw. kann nur korrigiert werden), wenn die Dateinamen passende Unicode-Zeichen enthalten!
}

{.$DEFINE USE_DIConverters}