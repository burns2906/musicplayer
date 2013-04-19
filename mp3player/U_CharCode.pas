{

Unit U_CharCode v0.1
-------------------------------------------------------
  August 2006, Daniel 'Gausi' Gaussmann
  Fragen hierzu an gausi@entwickler-ecke.de

  Bereitgestellt wird im Wesentlichen ein paar Datentypen, um mit Hilfe der Unit DIConverters
  eine Konvertierung von einigen Zeichensätzen nach Unicode und umgekehrt zu ermöglichen.

  Verwendet wird diese Unit hauptsächlich von MP3FileUtils_i v0.2 (International)
  Die Konstanten-Array [Language]Encodings können von Anwendungen zur Auswahl mehrerer möglicher
  Zeichensätze verwendet werden.
  In einer Variable vom Typ TConvertOptions können die bevorzugten Zeichensätze angeben werden.
  Eine Beipielanwendung sollte bei dieser Datei beiliegen.
  Falls nicht, kontaktieren sie mich bitte über E-Mail: gausi@entwickler-ecke.de


  Diese Unit kann frei verwendet und modifiziert werden


  Benötigte Zusatz-Komponenten/Units
  ========================================================================================================
  - DIConverters
      Download unter: http://www.zeitungsjunge.de/delphi/converters/
}


unit U_CharCode;

interface

uses
  SysUtils, Classes, Windows, DIConverters;

type

  TCharCode = record
      Bezeichnung: string;
      DecodeFunction: xxx_mbtowc;
      EnCodeFunction: xxx_wctomb;
      ByteCount: integer;
      Index: integer;
  end;

  TConvertOptions = record
      Greek    : TCharCode;
      Cyrillic : TCharCode;
      Hebrew   : TCharCode;
      Arabic   : TCharCode;
      Thai     : TCharCode;
      Korean   : TCharCode;
      Chinese  : TCharCode;
      Japanese : TCharCode;
  end;


const
    DefaultCharCode : TCharCode =
    (Bezeichnung: 'ISO 8859-1 Latin-1 (Westeuropäisch)'; DecodeFunction: iso8859_1_mbtowc; EncodeFunction: iso8859_1_wctomb; ByteCount :1; Index:0);

    // AllEnCodings: Array[0..1] of TCharCode =
    // (....)



    GreekEncodings : Array[0..3] of TCharCode =
        ( (Bezeichnung: 'MS Windows Griechisch'; DecodeFunction: cp1253_mbtowc;    EncodeFunction: cp1253_wctomb;    ByteCount :1; Index:0),
          (Bezeichnung: 'IBM PC Griechisch'     ; DecodeFunction: cp869_mbtowc;     EncodeFunction: cp869_wctomb;     ByteCount :1; Index:1),
          (Bezeichnung: 'ISO 8859-7 (Latin/Griechisch)' ; DecodeFunction: iso8859_7_mbtowc; EncodeFunction: iso8859_7_wctomb; ByteCount :1; Index:2),
          (Bezeichnung: 'Macintosh Griechisch' ;          DecodeFunction: mac_greek_mbtowc; EncodeFunction: mac_greek_wctomb; ByteCount :1; Index:3));

    CyrillicEncodings : Array[0..3] of TCharCode =
        ( (Bezeichnung: 'MS Windows Kyrillisch'; DecodeFunction: cp1251_mbtowc;       EncodeFunction: cp1251_wctomb;       ByteCount :1; Index:0),
          (Bezeichnung: 'IBM PC Kyrillisch'     ; DecodeFunction: cp855_mbtowc;        EncodeFunction: cp855_wctomb;        ByteCount :1; Index:1),
          (Bezeichnung: 'ISO 8859-5 Latin/Kyrillisch'   ; DecodeFunction: iso8859_5_mbtowc;    EncodeFunction: iso8859_5_wctomb;    ByteCount :1; Index:2),
          (Bezeichnung: 'Macintosh Kyrillisch' ;          DecodeFunction: mac_cyrillic_mbtowc; EncodeFunction: mac_cyrillic_wctomb; ByteCount :1; Index:3));

    HebrewEncodings : Array[0..2] of TCharCode =
        ( (Bezeichnung: 'ISO 8859-8 Latin/Hebräisch' ;    DecodeFunction: iso8859_8_mbtowc;    EncodeFunction: iso8859_8_wctomb;    ByteCount :1; Index:0),
          (Bezeichnung: 'Alternatives Hebräisch'; DecodeFunction: cp856_mbtowc;        EncodeFunction: cp856_wctomb;        ByteCount :1; Index:1),
          (Bezeichnung: 'PC Hebräisch';           DecodeFunction: cp862_mbtowc;        EncodeFunction: cp862_wctomb;        ByteCount :1; Index:2));

    ArabicEncodings : Array[0..2] of TCharCode =
        ( (Bezeichnung: 'PC Arabisch';           DecodeFunction: cp864_mbtowc;        EncodeFunction: cp864_wctomb;        ByteCount :1; Index:0),
          (Bezeichnung: 'MS Windows Arabisch';  DecodeFunction: cp1256_mbtowc;       EncodeFunction: cp1256_wctomb;       ByteCount :1; Index:1),
          (Bezeichnung: 'ISO 8859-6 Latin/Arabisch' ;    DecodeFunction: iso8859_6_mbtowc;    EncodeFunction: iso8859_6_wctomb;    ByteCount :1; Index:2));

    ThaiEncodings : Array[0..1] of TCharCode =
        ( (Bezeichnung: 'TIS-620 Thai Standard';              DecodeFunction: tis620_mbtowc;   EncodeFunction: tis620_wctomb;       ByteCount :1; Index:0),
          (Bezeichnung: 'Microsoft Thai SB-Codepage'; DecodeFunction: cp874_mbtowc;    EncodeFunction: cp874_wctomb;        ByteCount :1; Index:1));

    ChineseEncodings : Array[0..1] of TCharCode =
        ( (Bezeichnung: 'PC (MS) Traditionelles Chinesisch'; DecodeFunction: cp950_mbtowc; EncodeFunction: cp950_wctomb; ByteCount :2; Index:0 ),
          (Bezeichnung: 'big5 Traditionelles Chinesisch'         ; DecodeFunction: big5_mbtowc ; EncodeFunction: big5_wctomb ; ByteCount :2; Index:1));

    KoreanEncodings : Array[0..1] of TCharCode =
        ( (Bezeichnung: 'PC (MS) Koreanisch'; DecodeFunction: cp949_mbtowc;        EncodeFunction: cp949_wctomb;        ByteCount :2; Index:0),
          (Bezeichnung: 'EUC KSC Koreanisch'; DecodeFunction: euc_kr_mbtowc;       EncodeFunction: euc_kr_wctomb;       ByteCount :2; Index:1));

    JapaneseEncodings : Array[0..2] of TCharCode =
        ( (Bezeichnung: 'MS Windows Japanisch';   DecodeFunction: cp932_mbtowc;        EncodeFunction: cp932_wctomb;        ByteCount :2; Index:0),
          (Bezeichnung: 'EUC-JP Japanisch';               DecodeFunction: euc_jp_mbtowc;       EncodeFunction: euc_jp_wctomb;       ByteCount :2; Index:1),
          (Bezeichnung: 'SHIFT_JIS';                      DecodeFunction: sjis_mbtowc;         EncodeFunction: sjis_wctomb;         ByteCount :2; Index:2));

function GetCharCode(aFilename: WideString; Options: TConvertOptions): TCharCode;

implementation


function GetCharCode(aFilename: WideString; Options: TConvertOptions): TCharCode;
var Greek, Cyrillic, Hebrew, Arabic, Thai, Korean, Chinese, Japanese: integer;
    i, max: integer;
begin
  Greek    := 0;  Cyrillic := 0;
  Hebrew   := 0;  Arabic   := 0;
  Thai     := 0;  Korean   := 0;
  Chinese  := 0;  Japanese := 0;
  
  for i:= 1 to length(aFilename) do
  begin
    case Longint(aFilename[i]) of
      $0384..$03CE : inc(Greek);
      $0401..$045F : inc(Cyrillic);
      $05D1..$05EA : inc(Hebrew);
      $061B..$0652 : inc(Arabic);
      $0E01..$0E5B : inc(Thai);
      $AC02..$CEFF : inc(Korean);   //Hangeul
      $3041..$30F6 : inc(Japanese); //Hiragana/Katakana
      $3105..$3129 : inc(Chinese);  //Bopomofo bzw. Zhuyin
      $4E00..$9F67 : begin             // Ideographen, die scheinbar
                        inc(Japanese); // in allen drei Sprachen
                        inc(Chinese);  // vorkommen.
                        inc(Korean);
                     end;
    end;
  end;

  result := DefaultCharCode;
  max := 0;

  if Greek > max then
  begin
    max := Greek  ;
    result := Options.Greek;
  end;

  if Cyrillic > max then
  begin
    max := Cyrillic  ;
    result := Options.Cyrillic;
  end;

  if Hebrew > max then
  begin
    max := Hebrew    ;
    result := Options.Hebrew;
  end;

  if Arabic > max then
  begin
    max := Arabic    ;
    result := Options.Arabic;
  end;

  if Thai > max then
  begin
    max := Thai      ;
    result := Options.Thai;
  end;

  if Korean > max then
  begin
    max := Korean    ;
    result := Options.Korean;
  end;

  if Japanese > max then
  begin
    max := Japanese  ;
    result := Options.Japanese;
  end;
  
  if (Chinese >= max) And (max>0) then  // >= !! Weil: Japanisch, koreanisch, chinesisch
  begin                        //     benutzen alle drei die Ideographen-Zeichen
    //max := Chinese;          //     Wahrscheinlich (?) ist es aber chinesisch,
    result := Options.Chinese; //     wenn nur solche Ideographen verwendet wurden
  end;                         //     (und somit 'Korean', 'Japanese', 'Chinese' gleich sind)
end;

end.
