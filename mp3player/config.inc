{
  Diese Datei geh�rt zu MP3FileUtils.pas
}

{
  Compiler-Schalter-TNT: (zum Benutzen der TNTs den Punkt . vor dem $ l�schen)
  Es werden einige Funktionen der TNTs benutzt, insbesondere
  WideFileExists und
  TTntFileStream
  Wenn diese nicht benutzt werden sollen, weil man nur Unterst�tzung f�r Ansi-Dateinamen haben m�chte,
  werden dann die Ansi-Typen/-Funktionen verwendet.
}

{.$DEFINE USE_TNT_COMPOS}

{
  Compiler-Schalter DIConverters (zum Benutzen von DIConverters den Punkt . vor dem $ l�schen)
  F�r eine korrekte Darstellung von Tags, bei deren Erstellung ein anderer Zeichensatz verwendet wurde,
  ist ein Umkonvertierung n�tig.
  Dazu wird DI_Converters ben�tigt.

  Hinweis:
  Dies ist eigentlich nur dann sinnvoll, wenn man auch die TNTs mit einbindet, denn das kann nur auftreten
  (bzw. kann nur korrigiert werden), wenn die Dateinamen passende Unicode-Zeichen enthalten!
}

{.$DEFINE USE_DIConverters}