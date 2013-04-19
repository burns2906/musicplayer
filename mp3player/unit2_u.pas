{
  -------------------------------------------------------
  MP3FileUtils v0.4
  -------------------------------------------------------
}
{
  -------------------------------------------------------
  Copyright (C) 2005-2008, Daniel Gaussmann
  All rights reserved.

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
  
  * Redistributions of source code must retain the above copyright notice,
    this list of conditions and the following disclaimer.
  * Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions and the following disclaimer in the documentation
    and/or other materials provided with the distribution.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
  GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
  HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
  LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
  OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
  SUCH DAMAGE.

  -------------------------------------------------------
}
// OR (please choose the terms of use you want/need)
{
  -------------------------------------------------------
  This library is free software; you can redistribute it and/or
  modify it under the terms of the GNU Lesser General Public
  License as published by the Free Software Foundation; either
  version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public
  License along with this library; if not, write to the Free Software
  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
  -------------------------------------------------------
}

{
  Die hier implementierten Klassen ermöglichen es, diverse
  Informationen aus mp3 Dateien auszulesen und zu schreiben.

  Fragen hierzu an gausi@entwickler-ecke.de

  -------------------------------------------------------
  Hinweise zu den Lizenzvereinbarungen:
  -------------------------------------------------------
  Ich möchte, dass diese Unit auch ohne "Copyleft" verwendet werden kann. Die
  Doppellizensierung ist aber nötig, da diese Unit auch dafür ausgelegt werden
  kann, mit einer Bibliothek zu arbeiten, die unter der LGPL steht.
  Um für diesen Fall eventuelle Konflikte zu vermeiden, gibt es auch die
  LGPL-Variante. Die Benutzung dieser Zusatzunit (DiConverters) kann über
  Compilerschalter (de)aktiviert werden.

          Diese Unit basiert _zum Teil_ auf "UltimaTag"
          Copyright (C) 2003 by tommie-lie, tommie-lie@delphi-forum.de
          http://www.delphi-forum.de/viewtopic.php?t=11032

          Es sind zwar noch einige Reste dieser Unit hier enthalten, allerdings
          bin ich der Ansicht, dass diese Reste ausreichend klein und von
          allgemeiner, fast trivialer Art sind. Ich habe mich daher entschieden,
          mich (als Alternative) von der LGPL zu verabschieden, unter der UT steht.
          Ich denke, man kann das "Work based on" aus dem Text der LGPL
          hierauf nicht mehr wirklich anwenden. Eher ein "inspired by".
  -------------------------------------------------------


  Folgende Klassen werden zur Verfügung gestellt:
      - TID3v1Tag:
        Lesen und Schreiben des ID3v1-Tags.
        Alle Informationen werden ausgewertet.
        Die Version v1.1 wird erkannt.

      - TMpegInfo
        Lesen der MPEG-Informationen

      - TID3v2Tag:
        Lesen und schreiben von ID3v2-Tags.
        Es werden die Versionen 2.2, 2.3 und 2.4 unterstützt.

      - TID3v2Frame:
        Bearbeiten von einzelnen Frames im ID3v2-Tag


  unter Umständen benötigte Zusatz-Komponenten/Units
  ========================================================================================================
    - TntWare Delphi Unicode Controls
      Download unter: http://www.tntware.com/delphicontrols/unicode/
      Hinweis:  Tnt wird hier nur für den Dateizugriff benötigt.
                Wenn man sich damit begnügen möchte, nur Ansi-Dateinamen verarbeiten zu können, dann benötigt man
                sie nicht - siehe Compilerschalter.

    - DIConverters
      Download unter: http://www.zeitungsjunge.de/delphi/converters/
      Hinweis: Diese recht umfangreiche Unit (mit den ganzen *.obj-Dateien) erledigt die Kodierung und Dekodierun
               von Unicode-Zeichen in beliebige andere Zeichensätze.
               Sie ist nicht nötig, kann aber unter Umständen gewisse Fehler in ID3-Tags korrigieren.


  Version-History

  ========================================================================================================
  Juni 2008: v0.3b -> 0.4
  =======================
    - Code anders strukturiert - einiges in die Klasse TID3v2Frame ausgelagert
    - Unterstützung von Unsynchronisation
    - Unterstützung von GroupID und DataLength-Flags in Frame-Headern
    - Bei Compression und/oder Encryption wird das Auslesen abgebrochen
    - Unterstützung von URLs
    - Unterstützung von Bewertungen
    - Fehler in der Behandlung bei "Beschreibungen" mit Unicode - das führte u.a. dazu,
      dass viele Cover in Dateien von jamendo.com nicht angezeigt wurden.

  Februar 2008: v0.3a -> 0.3b
  ==========================
    - Funktion GetTrackFromV2TrackString hinzugefügt
    - Bug in der Funktion GetPaddingSize behoben

  Juni 2007: v0.3 -> 0.3a
  ==========================
    - Bei den Gettern des ID3v1-Tags wurden häufig Leerstellen und/oder Nullbytes mit übergeben, was ein Trim() außerhalb
      der Klasse nötig machte. Das wurde korrigiert - das trim() wird jetzt hier intern gemacht.
    - Schönheitsfehler bei der Benennung beseitigt: TPictureFrameDes()ription heißt jetzt TPictureFrameDes(c)ription 


  Februar 2007: v0.2a -> 0.3
  ==========================
    - INT/WE- Versionen über Compiler-Schalter vereint.
      Siehe dazu das Ende dieses einleitenden Kommentars
    - Fehler entfernt, die bei einer Verkleinerung des ID3v2-Tags unter gewissen Umständen zu unschönen
      Effekten bei den getaggten mp3s führte - die letzten Frames/Sekunden des Liedes wurden dann doppelt
      abgespielt.
    - intelligenteres Padding-System (abhängig von der Clustergröße)
      für den ID3v1Tag werden 128 Byte im Cluster freigehalten (falls er nicht existiert), so
      dass ein nachträgliches Einfügen keinen Zusatzplatz benötigt.


  ========================================================================================================
  September 2006: v0.2 -> 0.2a (beide Versionen)
  ==============================================
    - katastrophalen Bug behoben, der ungültige ID3v2-TextFrames erzeugt.


  August 2006:  v0.1 -> v0.2(International)
  =========================================

    Kleinere Bugs:
    ==============
    - Der ID3v1-Tag wurde vor dem Lesen nicht gelöscht, so dass u.U noch alte Informationen übrigblieben
    - Unter gewissen Umständen wurden Lyrics und Comments bei ID3v2 nicht richtig ausgelesen.
      Das lag aber an fehlerhaften Language-Informationen, die jetzt ausgebügelt werden.
    - Fehler beim Lesen einer Variante von Unicode behoben (Stichwort: Byte-Order)
    - Finalize-Abschnitt (wieder) hinzugefügt. Der ist zwischendurch mal irgendwo verlorengegangen.

    Updates/Änderungen:
    ===================
       Klasse TID3v1Tag:
       -----------------
       - in der 'International'-Version werden alle Textinformationen als WideString zurückgeliefert
       - beim Lesen findet ggf. eine Konvertierung statt, die vom CharCode abhängt.
         Mit Hilfe der Funktion GetCharCode aus der Unit U_CharCode (mitgeliefert) kann
         der beim Taggen verwendete Zeichensatz anhand des Dateinamens bestimmt werden.
         Das funktioniert natürlich nur mit einer gewissen Fehlerquote. Mehr dazu in der Datei 'Unicode.txt'.
       - beim Schreiben wird ebenfalls dieser Zeichensatz verwendet und der WideString entsprechend konvertiert
       - Flag 'AcceptAllEncodings' hinzugefügt. Ist dieser 'False', findet keine Konvertierung statt
         (weder beim schreiben, noch beim lesen).
         Was das für einen Effekt auf Systemen außerhalb Westeuropas hat, kann ich nicht genau sagen.

       Klasse TID3v2Tag:
       -----------------
       - Sämtliche TextInformationen werden jetzt als WideString geliefert.
       - Textinformationen werden automatisch im Unicode-Format gespeichert, falls dies nötig ist.
       - Flag 'AlwaysWriteUnicode' hinzugefügt. Ist dies gesetzt, wird immer im Unicode-Format gespeichert,
         auch wenn das nicht nötig ist (d.h. wenn nur "Standard"-Buchstaben verwendet werden)
       - beim Lesen findet ggf. eine Konvertierung statt, die vom CharCode abhängt.
         Mit Hilfe der Funktion GetCharCode aus der Unit U_CharCode (mitgeliefert) kann
         der beim Taggen verwendete Zeichensatz anhand des Dateinamens bestimmt werden.
         Im Gegensatz zur Klasse ID3v1Tag tritt dies nur dann auf, wenn beim Taggen auf Unicode verzichtet
         wurde. D.h. auch wenn das Flag 'AcceptAllEncodings' nicht gesetzt ist, kann man kyrillische oder asiatische (oder...)
         Zeichen erhalten. Dies sollte eigentlich sogar die Regel sein - ist es aber nicht, weswegen ich den ganzen
         Kram mit der Konvertierung überhaupt implementieren musste.
         Das funktioniert natürlich nur mit einer gewissen Fehlerquote. Mehr dazu in der Datei 'Unicode.txt'.
       - Flag 'AcceptAllEncodings' hinzugefügt. Ist dieser 'False', findet keine Konvertierung statt
}


unit unit2_u;

{$I config.inc}

interface

uses
  SysUtils, Classes, Windows, Contnrs, dialogs
  {$IFDEF USE_DIConverters},DIConverters, U_CharCode{$ENDIF}
  {$IFDEF USE_TNT_COMPOS}, TntSysUtils, TntClasses{$ENDIF},id3v2_u;

type

  {$IFNDEF USE_TNT_COMPOS}
  TTNTFileStream = TFileStream;
  TTNTStrings = TStrings;
  {$ENDIF}

//--------------------------------------------------------------------
// Teil 1: Allgemeine Hilfstypen
//--------------------------------------------------------------------
  TBuffer = Array of byte;
  TMP3Error = (MP3ERR_None, MP3ERR_NoFile, MP3ERR_FOpenCrt, MP3ERR_FOpenR,
               MP3ERR_FOpenRW, MP3ERR_FOpenW, MP3ERR_SRead, MP3ERR_SWrite,
               ID3ERR_Cache, ID3ERR_NoTag, ID3ERR_Invalid_Header, ID3ERR_Compression,
               ID3ERR_Unclassified,
               MPEGERR_NoFrame );
  TID3Version = record
    Major: Byte;
    Minor: Byte;
  end;
//--------------------------------------------------------------------


//--------------------------------------------------------------------
// Teil 2: Typen für ID3v1Tag
//--------------------------------------------------------------------
  String4  = String[4];
  String30 =  String[30];

  // Struktur des ID3v1Tags in der Datei
  TID3v1Structure = record
    ID: array[1..3] of Char;
    Title: Array [1..30] of Char;
    Artist: Array [1..30] of Char;
    Album: Array [1..30] of Char;
    Year: array [1..4] of Char;
    Comment: Array [1..30] of Char;
    Genre: Byte;
  end;

  TID3v1Tag = class(TObject)
  private
    FTitle: String30;
    FArtist: String30;
    FAlbum: String30;
    FComment: String30;
    FTrack: Byte;
    FYear: String4;
    FGenre: Byte;
    FExists: Boolean;
    FVersion: Byte;

    {$IFDEF USE_DIConverters}
    // Für die Umkodierung
    FCharCode: TCharCode;
    FAcceptAllEncodings: Boolean;
    conv: conv_t;
    function GetConvertedUnicodeText(Value: String30): WideString;
    {$ENDIF}

    function GetTitle: WideString;
    function GetArtist: WideString;
    function GetAlbum: WideString;
    function GetComment: WideString;

    function GetGenre: String;
    function GetTrack: String;
    function GetYear: String4;

    function SetString30(value: WideString): String30;
    procedure SetTitle(Value: WideString);
    procedure SetArtist(Value: WideString);
    procedure SetAlbum(Value: WideString);
    procedure SetGenre(Value: String);
    procedure SetYear(Value: String4);
    procedure SetComment(Value: WideString);
    procedure SetTrack(Value: String);
  public
    constructor Create;
    destructor destroy; override;
    property TagExists: Boolean read FExists;
    property Exists:    Boolean read FExists;

    property Version: Byte read FVersion;
    property Title: WideString read GetTitle write SetTitle;
    property Artist: WideString read GetArtist write SetArtist;
    property Album: WideString read GetAlbum write SetAlbum;
    property Genre: String read GetGenre write SetGenre;
    property Track: String read GetTrack write SetTrack;
    property Year: String4 read GetYear write SetYear;
    property Comment: WideString read GetComment write SetComment;

    {$IFDEF USE_DIConverters}
    property CharCode: TCharCode read FCharCode write FCharCode;
    property AcceptAllEncodings: Boolean read FAcceptAllEncodings write FAcceptAllEncodings;
    {$ENDIF}

    procedure Clear;
    function ReadFromStream(Stream: TStream): TMP3Error;
    function WriteToStream(Stream: TStream): TMP3Error;
    function RemoveFromStream(Stream: TStream): TMP3Error;
    function ReadFromFile(Filename: WideString): TMP3Error;
    function WriteToFile(Filename: WideString): TMP3Error;
    function RemoveFromFile(Filename: WideString): TMP3Error;
  end;
//--------------------------------------------------------------------



//--------------------------------------------------------------------
// Teil 3: Typen für ID3v2-tags
//--------------------------------------------------------------------
  TInt28 = array[0..3] of Byte;   // Sync-Safe Integer


  TFrameDescription  = record
    Language: String;
    Description: WideString;
  end;

  TPictureFrameDescription = record
    Description: String;
    Bildtyp: Byte;
  end;

  TFrameDescriptionArray = Array of TFrameDescription;
  TPictureFrameDescriptionArray = Array of TPictureFrameDescription;


  // Header-Struktur des ID3v2-Tags
  // ist bei allen Versionen gleich
  TID3v2Header = record
    ID: array[1..3] of Char;
    Version: Byte;
    Revision: Byte;
    Flags: Byte;
    TagSize: TInt28;
  end;

  TID3v2Tag = class(TObject)
  private
    Frames: TObjectList;
    fExists: Boolean;
    fVersion: TID3Version;
    fFlgUnsynch: Boolean;
    fFlgCompression: Boolean;
    fFlgExtended: Boolean;
    fFlgExperimental: Boolean;
    fFlgFooterPresent: Boolean;
    fFlgUnknown: Boolean;
    fPaddingSize: LongWord;
    fTagSize: LongWord;
    fDataSize: LongWord;
    fUsePadding: Boolean;
    fUseClusteredPadding: Boolean;
    // für die Cluster-größen-bestimmung
    fFilename: WideString;

    // Immer Unicode schreiben, ohne Überprüfung obs nötig ist
    fAlwaysWriteUnicode: Boolean;
    {$IFDEF USE_DIConverters}
    // Keine Konvertierung entsprechend des Dateinamens durchführen
    fAcceptAllEncodings: Boolean;
    fCharCode: TCharCode;
    conv: conv_struct;
    {$ENDIF}

    function GetFrameIDString(ID:TFrameIDs):string;

    function GetFrameIndex(ID:TFrameIDs):integer;
    function GetDescribedTextFrameIndex(ID:TFrameIDs; Language:string; Description:WideString):integer;
    function GetPictureFrameIndex(aDescription: WideString): Integer;
    function GetUserDefinedURLFrameIndex(Description: WideString): Integer;
    function GetPopularimaterFrameIndex(aEMail: String):integer;

    function GetDescribedTextFrame(ID:TFrameIDs; Language:string; Description:WideString):WideString;
    procedure SetDescribedTextFrame(ID:TFrameIDs; Language:string; Description:WideString; Value:WideString);

    // Für Comments- und Lyrics-Frames
    function GetAllFrameDescriptions(FrameID:TFrameIDs): TFrameDescriptionArray;
    function ReadFrames(From: LongInt; Stream: TStream): TMP3Error;
    function ReadHeader(Stream: TStream): TMP3Error;
    procedure SyncStream(Source, Target: TStream);

    // property read functions
    function GetTitle: WideString;
    function GetArtist: WideString;
    function GetAlbum: WideString;
    function ParseID3v2Genre(value:WideString):WideString;
    function GetGenre: WideString;
    function GetTrack: WideString;
    function GetYear: WideString;
    function GetStandardComment: WideString;
    function GetStandardLyrics: WideString;
    function GetComposer: WideString;
    function GetOriginalArtist: WideString;
    function GetCopyright: WideString;
    function GetEncodedBy: WideString;
    function GetLanguages: WideString;
    function GetSoftwareSettings: WideString;
    function GetMediatype: WideString;
    function Getid3Length: WideString;
    function GetPublisher: WideString;
    function GetOriginalFilename: WideString;
    function GetOriginalLyricist: WideString;
    function GetOriginalReleaseYear: WideString;
    function GetOriginalAlbumTitel: WideString;

    //property set functions
    procedure SetTitle(Value: WideString);
    procedure SetArtist(Value: WideString);
    procedure SetAlbum(Value: WideString);
    function BuildID3v2Genre(value:WideString):WideString;
    procedure SetGenre(Value: WideString);
    procedure SetTrack(Value: WideString);
    procedure SetYear(Value: WideString);
    procedure SetStandardComment(Value: WideString);
    procedure SetStandardLyrics(Value: WideString);
    procedure SetComposer(Value: WideString);
    procedure SetOriginalArtist(Value: WideString);
    procedure SetCopyright(Value: WideString);
    procedure SetEncodedBy(Value: WideString);
    procedure SetLanguages(Value: WideString);
    procedure SetSoftwareSettings(Value: WideString);
    procedure SetMediatype(Value: WideString);
    procedure Setid3Length(Value: WideString);
    procedure SetPublisher(Value: WideString);
    procedure SetOriginalFilename(Value: WideString);
    procedure SetOriginalLyricist(Value: WideString);
    procedure SetOriginalReleaseYear(Value: WideString);
    procedure SetOriginalAlbumTitel(Value: WideString);

    function GetStandardUserDefinedURL: String;
    procedure SetStandardUserDefinedURL(Value: String);

    function GetArbitraryRating: Byte;
    procedure SetArbitraryRating(Value: Byte);

    {$IFDEF USE_DIConverters}
    procedure SetCharCode(Value: TCharCode);
    procedure SetAcceptAllEncodings(Value: Boolean);
    {$ENDIF}


  public


    constructor Create;
    destructor Destroy; override;

    // "Level 1": Einfacher Zugriff über Properties.
    //            Die Setter und Getter erledigen den ganzen Rest.
    //            wie z.B. Frame finden und bei Bedarf erstellen
    property Title:   WideString read GetTitle  write SetTitle;
    property Artist:  WideString read GetArtist write SetArtist;
    property Album:   WideString read GetAlbum  write SetAlbum;
    property Genre:   WideString read GetGenre  write SetGenre;
    property Track:   WideString read GetTrack  write SetTrack;
    property Year:    WideString read GetYear   write SetYear;

    property Comment: WideString read GetStandardComment write SetStandardComment;
    property Lyrics : WideString read GetStandardLyrics write SetStandardLyrics;
    property URL: String read GetStandardUserDefinedURL write SetStandardUserDefinedURL;
    property Rating: Byte read GetArbitraryRating write SetArbitraryRating;

    property Composer:         WideString read  GetComposer           write  SetComposer        ;
    property OriginalArtist:   WideString read  GetOriginalArtist     write  SetOriginalArtist  ;
    property Copyright:        WideString read  GetCopyright          write  SetCopyright       ;
    property EncodedBy:        WideString read  GetEncodedBy          write  SetEncodedBy       ;
    property Languages:        WideString read  GetLanguages          write  SetLanguages       ;
    property SoftwareSettings: WideString read  GetSoftwareSettings   write  SetSoftwareSettings;
    property Mediatype:        WideString read  GetMediatype          write  SetMediatype       ;
    property id3Length:           WideString read  Getid3Length           write Setid3Length          ;
    property Publisher:           WideString read  GetPublisher           write SetPublisher          ;
    property OriginalFilename:    WideString read  GetOriginalFilename    write SetOriginalFilename   ;
    property OriginalLyricist:    WideString read  GetOriginalLyricist    write SetOriginalLyricist   ;
    property OriginalReleaseYear: WideString read  GetOriginalReleaseYear write SetOriginalReleaseYear;
    property OriginalAlbumTitel:  WideString read  GetOriginalAlbumTitel  write SetOriginalAlbumTitel ;



    property FlgUnsynch       : Boolean read fFlgUnsynch write fFlgUnsynch;
    property FlgCompression   : Boolean read fFlgCompression;
    property FlgExtended      : Boolean read fFlgExtended;
    property FlgExperimental  : Boolean read fFlgExperimental;
    property FlgFooterPresent : Boolean read fFlgFooterPresent;
    property FlgUnknown       : Boolean read fFlgUnknown;

    property Size:       LongWord    read fTagSize;
    property Exists:     Boolean     read fExists;      //  2 Eigenschaften doppelt
    property TagExists:  Boolean     read fExists;      //  aus Gründen der
    property Padding:    Longword    read fPaddingSize; //  Abwärtskompatibilität
    property PaddingSize:Longword    read fPaddingSize; //

    property Version:    TID3Version read fVersion;
    property UsePadding: Boolean     read fUsePadding write fUsePadding;
    property UseClusteredPadding: Boolean read fUseClusteredPadding write fUseClusteredPadding;

    property  AlwaysWriteUnicode: Boolean read fAlwaysWriteUnicode write fAlwaysWriteUnicode;
    {$IFDEF USE_DIConverters}
    property CharCode: TCharCode read fCharCode write SetCharCode;
    property  AcceptAllEncodings: Boolean read fAcceptAllEncodings write SetAcceptAllEncodings;
    {$ENDIF}

    function ReadFromStream(Stream: TStream): TMP3Error;
    function WriteToStream(Stream: TStream): TMP3Error;
    function RemoveFromStream(Stream: TStream): TMP3Error;
    function ReadFromFile(Filename: WideString): TMP3Error;
    function WriteToFile(Filename: WideString): TMP3Error;
    function RemoveFromFile(Filename: WideString): TMP3Error;
    procedure Clear;


    // "Level 2": Einige etwas kompliziertere Frames gezielt auf Tag-Ebene setzen
    //           zugehörige Frames werden automatisch ermittelt und bei Bedarf erstellt
    //           Übergeben von Value = '' löscht den Frame

    function GetText(FrameID: TFrameIDs):WideString;
    procedure SetText(FrameID:TFrameIDs; Value: WideString);

    function GetURL(FrameID: TFrameIDs):String;
    procedure SetURL(FrameID:TFrameIDs; Value: String);


    // Comments  (COMM)
    // Hinweis: Delete über Set(..., '');
    procedure SetExtendedComment(Language: string; Description: WideString; value:WideString);
    function GetExtendedComment(Language: string; Description: WideString): WideString;
    procedure DeleteExtendedComment(Language: string; Description: WideString);                 Deprecated;

    // Lyrics
    // Hinweis: Delete über Set(..., '');
    procedure SetLyrics(Language: string; Description: WideString; value: WideString);
    function GetLyrics(Language: string; Description: WideString): WideString;
    procedure DeleteLyrics(Language: string; Description: WideString);                          Deprecated;

    // Pictures (APIC)
    // Hinweis: Die Routinen mit "TPictureFrameDescription" sind auf Grund der Abwärtskompatibilität da
    //          Delete über Stream = Nil
    procedure _GetPicture(stream: TStream; Description: TPictureFrameDescription);  Deprecated;
    function GetPicture(stream: TStream; Description: WideString): String; // Rückgabe: Mime-Type
    procedure _SetPicture(stream: TStream; Description: TPictureFrameDescription);   Deprecated;
    procedure SetPicture(MimeTyp: String; PicType: Byte; Description: WideString; stream: TStream);
    procedure DeletePicture(Description:TPictureFrameDescription);                           Deprecated;

    // User-definierte URL (WXXX)
    // Hinweis: Delete über Set(..., '');    
    function GetUserDefinedURL(Description: WideString): String;
    procedure SetUserDefinedURL(Description: WideString; Value: String);

    // Bewertungen (POPM)
    // Hinweis: GetRating('*') holt eine beliebige Bewertung!
    //          SetRating('*', ..) überschreibt eine beliebige Bewertung
    //                             ist noch keine vorhanden, wird ein Frame mit
    //                             'Mp3FileUtils, www.gausi.de' erstellt
    function GetRating(aEMail: String): Byte;
    procedure SetRating(aEMail: String; Value: Byte);

    //für diverse Anzeigen, z.B. um Auswahl der MehrfachFrames zu realisieren - veraltet
    function GetAllCommentDescriptions: TFrameDescriptionArray;                Deprecated;
    function GetAllLyricsDescriptions: TFrameDescriptionArray;                 Deprecated;
    function GetAllPictureFrameDescriptions: TPictureFrameDescriptionArray;    Deprecated;


    // "Level 3": Manipulation auf Frame-Level
    //            Das Auslesen und schreiben wird ausschließlich in der Klasse ID3v2Frames
    //            erledigt.
    //            Hier werden Methoden bereitgestellt, um die Frames vorzusortieren.
    //            Und neue Frames dem Tag hinzuzufügen bzw. zu löschen

    function GetAllFrames: TObjectlist;
    function GetAllTextFrames: TObjectlist;
    function GetAllCommentFrames: TObjectlist;
    function GetAllLyricFrames: TObjectlist;
    function GetAllUserDefinedURLFrames: TObjectlist;
    function GetAllPictureFrames: TObjectlist;
    function GetAllPopularimeterFrames: TObjectlist;
    function GetAllURLFrames: TObjectlist;

    // überprüft, ob ein neu zu erstellender Frame gültig, d.h. eindeutig ist
    function ValidNewCommentFrame(Language: String; Description: WideString): Boolean;
    function ValidNewLyricFrame(Language: String; Description: WideString): Boolean;
    function ValidNewPictureFrame(Description: WideString): Boolean;
    function ValidNewUserDefUrlFrame(Description: WideString): Boolean;
    function ValidNewPopularimeterFrame(EMail: String): Boolean;

    // liefert in der Liste die Frame-IDs zurück, die erstellt werden dürfen
    function GetAllowedTextFrames: TList;
    function GetAllowedURLFrames: TList; // die WOAR, etc, NICHT die WXXX

    function AddFrame(aID: TFrameIDs): TID3v2Frame;
    procedure DeleteFrame(aFrame: TID3v2Frame);
  end;
//--------------------------------------------------------------------


//--------------------------------------------------------------------
// Teil 4. Typen für die MPEG-Behandlung
//--------------------------------------------------------------------

  TMpegHeader = record
    version: byte;
    layer: byte;
    protection: boolean;
    bitrate: LongInt;
    samplerate: LongInt;
    channelmode: byte;
    extension: byte;
    copyright: boolean;
    original: boolean;
    emphasis: byte;
    padding: boolean;
    framelength: word;
    valid: boolean;
  end;

  TXingHeader = record
    Frames: integer;
    Size: integer;
    valid: boolean;
  end;

  TMpegInfo = class(TObject)
  Private
    FFilesize: int64;
    Fversion:integer;
    Flayer:integer;
    Fprotection:boolean;
    Fbitrate:word;
    Fsamplerate:integer;
    Fchannelmode:byte;
    Fextension:byte;
    Fcopyright:boolean;
    Foriginal:boolean;
    Femphasis:byte;
    Fframes:Integer;
    Fdauer:Longint;
    Fvbr:boolean;
    Fvalid: boolean;
    FfirstHeaderPosition: int64;

    // Überprüft, ob im Array aBuffer an Position position ein gültiger MpegHeader ist
    // und liefert diesen zurück
    function GetValidatedHeader(aBuffer: TBuffer; position: integer): TMpegHeader;
    // Überprüft, ob nach dem aMpegHeader in aBuffer (pos entsprechend setzen) ein Xing-Frame kommt
    function GetXingHeader(aMpegheader: TMpegHeader; aBuffer: TBuffer; position: integer ): TXingHeader;
    function GetFramelength(version:byte;layer:byte;bitrate:integer;Samplerate:integer;padding:boolean):integer;

  public
    constructor create;
    function LoadFromStream(stream: tStream): TMP3Error;
    function LoadFromFile(filename: string): TMP3Error;
    property Filesize: int64          read   FFilesize;
    property Version: integer         read   Fversion;
    property Layer: integer           read   Flayer;
    property Protection: boolean      read   Fprotection;
    property Bitrate: word            read   Fbitrate;
    property Samplerate: integer      read   Fsamplerate;
    property Channelmode: byte        read   Fchannelmode;
    property Extension: byte          read   Fextension;
    property Copyright: boolean       read   Fcopyright;
    property Original: boolean        read   Foriginal;
    property Emphasis: byte           read   Femphasis;
    property Frames: Integer          read   Fframes;
    property Dauer: Longint           read   Fdauer;
    property Vbr: boolean             read   Fvbr;
    property Valid: boolean           read   Fvalid;
    property FirstHeaderPosition: int64 read   FfirstHeaderPosition;
  end;



// Funktionen, die nicht zu den Klassen hier gehören,
// aber dennoch sinnvoll damit in Zusammenhang stehen.
// sie können z.B. im OnChange eines Editfeldes benutzt werden
  function IsValidV2TrackString(value:string):boolean;
  function IsValidV1TrackString(value:string):boolean;
  function IsValidYearString(value:string):boolean;

  // Eine kleine Funktion, um aus einem v2-TrackString die Nummer zu bekommen
  // z.B.: 3/15 => 3
  function GetTrackFromV2TrackString(value: string): Byte;


const

 MPEG_BIT_RATES : array[1..3] of array[1..3] of array[0..15] of word =
  { Version 1, Layer I }
    (((0,32,64,96,128,160,192,224,256,288,320,352,384,416,448,0),
  { Version 1, Layer II }
    (0,32,48,56, 64, 80, 96,112,128,160,192,224,256,320,384,0),
  { Version 1, Layer III }
    (0,32,40,48, 56, 64, 80, 96,112,128,160,192,224,256,320,0)),
  { Version 2, Layer I }
    ((0,32,48, 56, 64, 80, 96,112,128,144,160,176,192,224,256,0),
  { Version 2, Layer II }
    (0, 8,16,24, 32, 40, 48, 56, 64, 80, 96, 112,128,144,160,0),
  { Version 2, Layer III }
    (0, 8,16,24, 32, 40, 48, 56, 64, 80, 96, 112,128,144,160,0)),
  { Version 2.5, Layer I }
    ((0,32,48, 56, 64, 80, 96,112,128,144,160,176,192,224,256,0),
  { Version 2.5, Layer II }
    (0, 8,16,24, 32, 40, 48, 56, 64, 80, 96, 112,128,144,160,0),
  { Version 2.5, Layer III }
    (0, 8,16,24, 32, 40, 48, 56, 64, 80, 96, 112,128,144,160,0)));

  sample_rates: array[1..3] of array [0..3] of word=
    ((44100,48000,32000,0),
    (22050,24000,16000,0),
    (11025,12000,8000,0));
  channel_modes:array[0..3] of string=('Stereo','Joint stereo','Dual channel (Stereo)','Single channel (Mono)');
  extensions:array[1..3] of array [0..3] of string=
    (('bands 4 to 31','bands 8 to 32','bands 12 to 31','bands 16 to 31'),
     ('bands 4 to 31','bands 8 to 32','bands 12 to 31','bands 16 to 31'),
     ('IS:off, MS:off','IS:on, MS:off','IS:off, MS:on','IS:on, MS:on'));
  emphasis_values: array[0..3] of string = ('None', '50/15ms','reserved','CCIT J.17');

  {$Message Hint 'You should change the default rating description for your projects'}
  DefaultRatingDescription: String = 'Mp3FileUtils, www.gausi.de';


var
  Genres: TStringList;
  LanguageCodes: TStringlist;
  LanguageNames: TStringlist;


implementation



//--------------------------------------------------------------------
// Einige Hilfsprozeduren
//--------------------------------------------------------------------

//--------------------------------------------------------------------
// Setzt bei Bedarf die Funktion WideFileExists auf die Ansi-Version
//--------------------------------------------------------------------
{$IFNDEF USE_TNT_COMPOS}
function  WideFileExists(aString:string):boolean;
begin
  result := FileExists(aString);
end;

function WideExtractFileDrive(aString: String): string;
begin
  result := ExtractFileDrive(aString);
end;
{$ENDIF}


//--------------------------------------------------------------------
// Überprüft, ob die Frame-ID gültig ist
//--------------------------------------------------------------------
function ValidFrame(ID: string): Boolean;
var
  i: Cardinal;
begin
  result := true;
  for i := 1 to length(ID) do
    if not (ID[i] in ['0'..'9', 'A'..'Z']) then
    begin
      result := false;
      Break;
    end;
end;

function ValidTextFrame(ID: string): Boolean;
begin
  result := (length(ID) >= 3) and (ID[1] = 'T');
end;

//--------------------------------------------------------------------
// Konvertiert ein 28bit integer in ein 32bit integer
//--------------------------------------------------------------------
function Int28ToInt32(Value: TInt28): LongWord;
begin
  // Take the rightmost byte and let it there,
  // take the second rightmost byte and move it 7bit to left
  //                                    (in an 32bit-variable)
  // a.s.o.
  result := (Value[3]) shl  0 or
            (Value[2]) shl  7 or
            (Value[1]) shl 14 or
            (Value[0]) shl 21;
end;

//--------------------------------------------------------------------
// Konvertiert ein 32bit integer in ein 28bit integer
//--------------------------------------------------------------------
function Int32ToInt28(Value: LongWord): TInt28;
begin
  // move every byte in Value to the right, take the 7 LSBs
  // and assign them to the result
  Result[3] := (Value shr  0) and $7F;
  Result[2] := (Value shr  7) and $7F;
  Result[1] := (Value shr 14) and $7F;
  Result[0] := (Value shr 21) and $7F;
end;

//--------------------------------------------------------------------
// Ermittelt einen temporären Dateinamen zum Cachen von Audio/Frames
//--------------------------------------------------------------------
function GetTempFile: String;
var
  Path: String;
  i: Integer;
begin
  SetLength(Path, 256);
  FillChar(PChar(Path)^, 256, 0);
  GetTempPath(256, PChar(Path));
  Path := Trim(Path);
  if Path[Length(Path)] <> '\' then
    Path := Path + '\';
  i := 0;
  repeat
    result := Path + 'TagTemp.t' + IntToHex(i, 2);
    inc(i);
  until not FileExists(result);
end;


//--------------------------------------------------------------------
// ID3v1 oder ID3v1.1
//--------------------------------------------------------------------
function GetID3v1Version(Tag: TID3v1Structure): Byte;
begin
  // Ist 29. Byte des Kommentar-Feldes 0, und
  // das 30. ungleich 0, so gibt dieses die Track-Nr. an
  if (Tag.Comment[29] = #00) and (Tag.Comment[30] <> #00) then
    result := 1
  else
    result := 0;
end;

//---------------------------------------------------
// Überprüft, ob ein String gültig für die Angabe eines v2-Tracks ist
//---------------------------------------------------
function IsValidV2TrackString(value:string):boolean;
var
  del: Integer;
  Track, Overall: String;
begin
  del := Pos('/', Value);       // getting the position of the delimiter
  if del = 0 then
    // If there is none, then the whole string is the TrackNumber
    result := (StrToIntDef(Value, -1) > -1)
  else begin
    Overall := Trim(Copy(Value, del + 1, Length(Value) - (del)));
    Track := Trim(Copy(Value, 1, del - 1));
    result := ((StrToIntDef(Track, -1) > -1) AND (StrToIntDef(Overall, -1) > -1))
  end;
end;

//--------------------------------------------------------------------
// ... und für v1
//--------------------------------------------------------------------
function IsValidV1TrackString(value:string):boolean;
begin
  result := (StrToIntDef(Value, -1) > -1);
end;

//--------------------------------------------------------------------
// Überprüfen auf gültige Jahresangabe
//--------------------------------------------------------------------
function IsValidYearString(value:string):boolean;
var tmp:integer;
begin
  tmp := StrToIntDef(Value, -1);
  result := (tmp > -1) AND (tmp < 10000);
end;

//--------------------------------------------------------------------
// Track-Nr. aus track-String ermitteln
//--------------------------------------------------------------------
function GetTrackFromV2TrackString(value: string): Byte;
var
  del: Integer;
  Track: String;
begin
  del := Pos('/', Value);       // getting the position of the delimiter
  if del = 0 then
    // If there is none, then the whole string is the TrackNumber
    result := StrToIntDef(Value, 0)
  else begin
    //Overall := Trim(Copy(Value, del + 1, Length(Value) - (del)));
    Track := Trim(Copy(Value, 1, del - 1));
    result := StrToIntDef(Track, 0);
  end;
end;

//--------------------------------------------------------------------
// Ermittelt eine "sinnvolle" Paddinggröße
//--------------------------------------------------------------------
function GetPaddingSize(DataSize: Int64; aFilename: WideString; UseClusterSize: Boolean): Cardinal;
var
   Drive: string;
   ClusterSize           : Cardinal;
   SectorPerCluster      : Cardinal;
   BytesPerSector        : Cardinal;
   NumberOfFreeClusters  : Cardinal;
   TotalNumberOfClusters : Cardinal;
begin
  Drive := WideExtractFileDrive(aFileName);
  if UseClusterSize and (trim(Drive) <> '')then
  begin
      if Drive[Length(Drive)]<>'\' then Drive := Drive+'\';
      try
          if GetDiskFreeSpace(PChar(Drive),
                              SectorPerCluster,
                              BytesPerSector,
                              NumberOfFreeClusters,
                              TotalNumberOfClusters) then
            ClusterSize := SectorPerCluster * BytesPerSector
          else
            ClusterSize := 2048;
      except
        ClusterSize := 2048;
      end;
  end else
    ClusterSize := 2048;
  Result := (((DataSize DIV ClusterSize) + 1) * Clustersize) - DataSize;
end;


//--------------------------------------------------------------------
//--------------------------------------------------------------------
//        *** TID3v1Tag ***
//--------------------------------------------------------------------
//--------------------------------------------------------------------


constructor TID3v1Tag.Create;
begin
  inherited Create;
  // Standard-Werte setzen
  Clear;
  {$IFDEF USE_DIConverters}
  FillChar(conv, SizeOf(conv), 0);
  FCharCode := DefaultCharCode;
  AcceptAllEncodings := True;
  {$ENDIF}
end;

destructor TID3v1Tag.destroy;
begin
  inherited destroy;
end;

// Den Tag aus einem Stream lesen
function TID3v1Tag.ReadFromStream(Stream: TStream): TMP3Error;
var
  RawTag: TID3v1Structure;
begin
  clear;
  result := MP3ERR_None;
  FExists := False;
  try
    Stream.Seek(-128, soFromEnd);
    if (Stream.Read(RawTag, 128) = 128) then
      if (RawTag.ID = 'TAG') then
      begin
        FExists := True;
        FVersion := GetID3v1Version(RawTag);
        FTitle := (RawTag.Title);
        FArtist := (RawTag.Artist);
        FAlbum := (RawTag.Album);
        FYear := TrimRight(RawTag.Year);
        if FVersion = 0 then
        begin
          FComment := (RawTag.Comment);
          FTrack := 0;
        end
        else
        begin
          Move(RawTag.Comment[1], FComment[1], 28);
          FComment[29] := #0;
          FComment[30] := #0;
          FTrack := Ord(RawTag.Comment[30]);
        end;
        FGenre := RawTag.Genre;
      end
      else
        result := ID3ERR_NoTag
    else
      result := MP3ERR_SRead;
  except
    on E: Exception do
    begin
      result := ID3ERR_Unclassified;
      MessageBox(0, PChar(E.Message), PChar('Error'), MB_OK or MB_ICONERROR or MB_TASKMODAL or MB_SETFOREGROUND);
    end;
  end;
end;

// Tag in einen Stream schreiben
function TID3v1Tag.WriteToStream(Stream: TStream): TMP3Error;
var
  RawTag: TID3v1Structure;
  Buffer: Array [1..3] of Char;
begin
  result := MP3ERR_NONE;
  try
    FillChar(RawTag, 128, 0);
    RawTag.ID := 'TAG';
    Move(FTitle[1], RawTag.Title, Length(FTitle));
    Move(FArtist[1], RawTag.Artist, Length(FArtist));
    Move(FAlbum[1], RawTag.Album, Length(FAlbum));
    Move(FYear[1], RawTag.Year, Length(FYear));
    Move(FComment[1], RawTag.Comment, Length(FComment));
    if FTrack > 0 then
    begin
      RawTag.Comment[29] := #0;
      RawTag.Comment[30] := Chr(FTrack);
    end;
    RawTag.Genre := FGenre;

    // Nach einem vorhandenen Tag suchen und Positon im Stream passend setzen
    Stream.Seek(-128, soFromEnd);
    Stream.Read(Buffer[1], 3);
    if (Buffer[1]='T') AND (Buffer[2]='A') AND (Buffer[3]='G') then
      Stream.Seek(-128, soFromEnd)
    else
      Stream.Seek(0, soFromEnd);

    if Stream.Write(RawTag, 128) <> 128 then
      result := MP3ERR_SWrite;
  except
    on E: Exception do
    begin
      result := ID3ERR_Unclassified;
      MessageBox(0, PChar(E.Message), PChar('Error'), MB_OK or MB_ICONERROR or MB_TASKMODAL or MB_SETFOREGROUND);
    end;
  end;
end;

// Tag löschen, falls er existiert
function TID3v1Tag.RemoveFromStream(Stream: TStream): TMP3Error;
var
  Buffer: Array [1..3] of Char;
begin
  result := MP3ERR_NONE;
  try
    Stream.Seek(-128, soFromEnd);
    Stream.Read(Buffer[1], 3);
    if (Buffer[1]='T') AND (Buffer[2]='A') AND (Buffer[3]='G') then
    begin
      Stream.Seek(-128, soFromEnd);
      SetStreamEnd(Stream);
    end
    else
      result := ID3ERR_NoTag;
  except
    on E: Exception do
    begin
      result := ID3ERR_Unclassified;
      MessageBox(0, PChar(E.Message), PChar('Error'), MB_OK or MB_ICONERROR or MB_TASKMODAL or MB_SETFOREGROUND);
    end;
  end;
end;

// Standard-Werte setzen
procedure TID3v1Tag.Clear;
begin
  FTitle   := StringOfChar(#0, 30);
  FArtist  := StringOfChar(#0, 30);
  FAlbum   := StringOfChar(#0, 30);
  FYear    := StringOfChar(#0, 30);
  FComment := StringOfChar(#0, 30);

  FTrack   := 0;
  FGenre   := 0;
  FVersion := 0;
  FExists  := False;
end;

// Einen Tag aus einer Datei lesen
// -> Stream-Funktion benutzen
function TID3v1Tag.ReadFromFile(Filename: WideString): TMP3Error;
var
  Stream: TTntFileStream;
begin
  if WideFileExists(Filename) then
    try
      Stream := TTntFileStream.Create(Filename, fmOpenRead or fmShareDenyWrite);
      try
        result := ReadFromStream(Stream);
      finally
        Stream.Free;
      end;
    except
      result := MP3ERR_FOpenR;
    end
  else
    result := MP3ERR_NoFile;
end;

// Einen Tag in eine Datei schreiben
// -> Stream-Funktion benutzen
function TID3v1Tag.WriteToFile(Filename: WideString): TMP3Error;
var
  Stream: TTntFileStream;
begin
  if WideFileExists(Filename) then
    try
      Stream := TTntFileStream.Create(Filename, fmOpenReadWrite or fmShareDenyWrite);
      try
        result := WriteToStream(Stream);
      finally
        Stream.Free;
      end;
    except
      result := MP3ERR_FOpenRW;
    end
  else
    result := MP3ERR_NoFile;
end;

// Einen Tag aus einer Datei löschen
// -> Stream-Funktion benutzen
function TID3v1Tag.RemoveFromFile(Filename: WideString): TMP3Error;
var
  Stream: TTntFileStream;
begin
  if WideFileExists(Filename) then
    try
      Stream := TTntFileStream.Create(Filename, fmOpenReadWrite or fmShareDenyWrite);
      try
        result := RemoveFromStream(Stream);
      finally
        Stream.Free;
      end;
    except
      result := MP3ERR_FOpenRW;
    end
  else
    result := MP3ERR_NoFile;
end;

{$IFDEF USE_DIConverters}
function TID3v1Tag.GetConvertedUnicodeText(Value: String30): WideString;
var
  pwc: ucs4_t;
  i,i_result:integer;
  tmp: string;
begin
    if AcceptAllEncodings then
    begin
        // Länge des Ergebnis-Strings setzen
        // Länger als 30 kann es nicht sein.
        Setlength(result, 30);
        Fillchar(result[1], length(result)*2 ,0);
        i:= 1;
        i_result := 1;
        while i <= 30 do
        begin
          if (CharCode.ByteCount = 2) AND (CharCode.DecodeFunction(conv, pwc, @Value[i], 1) = 1) then
          begin
            result[i_result] := WideChar(pwc);
            inc(i,1);
          end
          else
          begin
            if CharCode.DecodeFunction(conv, pwc, @Value[i], CharCode.ByteCount) = CharCode.ByteCount then
              result[i_result] := WideChar(pwc)
            else
              result[i_result] := '?';
            inc(i,CharCode.ByteCount);
          end;
          inc(i_result);
        end;
        // String trimmen (Nullen und Leerzeichen entfernen)
        result := Trim(Result);
    end else
    begin
      // einfach in einen temporären String rüberschaufeln
      // und anschließend konvertieren.
      setlength(tmp,30);
      move(Value[1], tmp[1], 30);
      result := trim(tmp);
    end;
end;
{$ENDIF}

function TID3v1Tag.GetTitle: WideString;
begin
  {$IFDEF USE_DIConverters}
  result := GetConvertedUnicodeText(FTitle);
  {$ELSE}
  result := Trim(WideString(FTitle));
  {$ENDIF}
end;
function TID3v1Tag.GetArtist: WideString;
begin
  {$IFDEF USE_DIConverters}
  result := GetConvertedUnicodeText(FArtist);
  {$ELSE}
  result := Trim(WideString(FArtist));
  {$ENDIF}
end;
function TID3v1Tag.GetAlbum: WideString;
begin
  {$IFDEF USE_DIConverters}
  result := GetConvertedUnicodeText(FAlbum);
  {$ELSE}
  result := Trim(WideString(FAlbum));
  {$ENDIF}
end;
function TID3v1Tag.GetComment: WideString;
begin
  {$IFDEF USE_DIConverters}
  result := GetConvertedUnicodeText(FComment);
  {$ELSE}
  result := Trim(WideString(FComment));
  {$ENDIF}
end;
function TID3v1Tag.GetGenre: String;
begin
  if FGenre <= 125 then
    result := Genres[FGenre]
  else
    result := '';
end;
function TID3v1Tag.GetTrack: String;
begin
  result := IntToStr(FTrack);
end;

function TID3v1Tag.GetYear: String4;
begin
  result := Trim(FYear);
end;



function TID3v1Tag.SetString30(value: WideString):String30;
var i,max: integer;
  tmpstr: string;
  {$IFDEF USE_DIConverters}
  del_i,trybw, BytesWritten: Integer;
  {$ENDIF}
begin
  result := StringOfChar(#0, 30);

  {$IFDEF USE_DIConverters}
  if FAcceptAllEncodings then
  begin
    // Konvertierungsarbeit nötig
    max := length(value);
    if max > 30 then max := 30;

    i := 1;
    BytesWritten := 0;

    while (i <= max) AND (BytesWritten < 30) do
    begin
      trybw := FCharCode.EnCodeFunction
              ( conv,
                @result[1 + Byteswritten],
                cardinal(value[i]),
                30 - BytesWritten );
      if trybw > 0  then
      begin
        inc(Byteswritten, trybw);
        inc(i);
      end
      else
      begin
        // das letzte Multi-Byte-Zeichen hat nicht mehr reingepasst
        // also: das letzte wieder löschen und exit.
        for del_i := 1 + Byteswritten to 30 do
          result[del_i] := ' ';
        BytesWritten := 30;
      end;
    end;
  end else
  {$ENDIF}
  begin
    // wieder der trick über einen normalen String,
    // der dann zeichen für Zeichen kopiert wird.
    tmpstr := value;
    max := length(tmpstr);
    if max > 30 then max := 30;
    for i :=1 to max do
      result[i] := tmpstr[i];
  end;
end;


procedure TID3v1Tag.SetTitle(Value: WideString);
begin
  FTitle := SetString30(Value);
end;
procedure TID3v1Tag.SetArtist(Value: WideString);
begin
  FArtist := SetString30(Value);
end;
procedure TID3v1Tag.SetAlbum(Value: WideString);
begin
  FAlbum := SetString30(Value);
end;
procedure TID3v1Tag.SetGenre(Value: String);
var
  i: integer;
begin
  i := Genres.IndexOf(Value);
  if i in [0..125] then
    FGenre := i
  else
    FGenre := 255; // undefiniert
end;

procedure TID3v1Tag.SetYear(Value: String4);
begin
  FYear := TrimRight(Value);
end;

procedure TID3v1Tag.SetComment(Value: WideString);
begin
  FComment := SetString30(Value);
end;
procedure TID3v1Tag.SetTrack(Value : String);
begin
  FTrack := StrToIntDef(Value, 0);
end;






//--------------------------------------------------------------------
//--------------------------------------------------------------------
//        *** TID3v2Tag ***
//--------------------------------------------------------------------
//--------------------------------------------------------------------

constructor TID3v2Tag.Create;
begin
  inherited Create;
  Frames := TObjectList.Create(True);

  FUseClusteredPadding := True;
  AlwaysWriteUnicode := False;
  {$IFDEF USE_DIConverters}
  FillChar(conv, SizeOf(conv), 0);
  FCharCode := DefaultCharCode;
  AcceptAllEncodings := True;
  {$ENDIF}
  FVersion.Major := 3;
  FVersion.Minor := 0;
  FExists := False;
  FTagSize := 0;
  fPaddingSize := 0;
  fFlgUnsynch       := False;
  fFlgCompression   := False;
  fFlgExtended      := False;
  fFlgExperimental  := False;
  fFlgFooterPresent := False;
  fFlgUnknown       := False;
end;

Destructor TID3v2tag.Destroy;
begin
  Frames.Free;
  inherited destroy;
end;

function TID3v2Tag.GetFrameIDString(ID:TFrameIDs):string;
begin
  case fVersion.Major of
    2: result := ID3v2KnownFrames[ID].IDs[FV_2];
    3: result := ID3v2KnownFrames[ID].IDs[FV_3];
    4: result := ID3v2KnownFrames[ID].IDs[FV_4];
    else result := '';
  end;
end;

// Zum lesen der Infos aus den Frames
// Achtung: Diese Prozedur nur für Frames verwenden, die eindeutig sind.
// Es gibt Frame-IDs, die mehrfach verwendet werden dürfen,
// z.B. die COMMent-Frames, die sich dann durch Sprache oder Beschreibung unterscheiden!
function TID3v2Tag.GetFrameIndex(ID:TFrameIDs):integer;
var i:integer;
    IDstr:string;
begin
  result := -1;
  idstr := GetFrameIDString(ID);
  for i := 0 to Frames.Count - 1 do
  begin
      if (Frames[i] as TID3v2Frame).FrameIDString = IDstr then
      begin
          result := i;
          break;
      end;
  end;
end;

// Liefert den Index eines Frames mit einer Sprach- und Beschreibungseigenschaft
function TID3v2Tag.GetDescribedTextFrameIndex(ID:TFrameIDs; Language:string; Description:WideString):integer;
var i:integer;
  IDstr:string;
  iLanguage: String;
  iDescription: WideString;
  check: Boolean;
begin
  // z.B. im Comment-Frame, oder im Lyric-Frame
  result := -1;
  idstr := GetFrameIDString(ID);
  for i := 0 to Frames.Count - 1 do
  begin
      if (Frames[i] as TID3v2Frame).FrameIDString = IDstr then
      begin
          (Frames[i] as TID3v2Frame).GetCommentsLyrics(iLanguage, iDescription);
          check := False;
          if ((Language = '*') OR (Language = '')) or (Language = iLanguage) then
              Check := True;
          If Check and ((Description = '*') or (Description = iDescription)) then
          begin
              result := i;
              break;
          end;
      end;
  end;
end;

function TID3v2Tag.GetPictureFrameIndex(aDescription: WideString): Integer;
var mime, idstr: string;
  i: integer;
  PictureData : TMemoryStream;
  desc: WideString;
  picTyp: Byte;
begin
  result := -1;
  idstr := GetFrameIDString(IDv2_PICTURE);
  for i := 0 to Frames.Count - 1 do
    if (Frames[i] as TID3v2Frame).FrameIDString = IDstr then
    begin
        // passender IDstring gefunden
        PictureData := TMemoryStream.Create;
        (Frames[i] as TID3v2Frame).GetPicture(Mime, PicTyp, Desc, PictureData);
        PictureData.Free;

        if (aDescription = Desc) or (aDescription = '*') then
        begin
            result := i;
            break;
        end;
    end;
end;

function TID3v2Tag.GetUserDefinedURLFrameIndex(Description: WideString): Integer;
var i:integer;
  IDstr:string;
  iDescription: WideString;
begin
  // z.B. im Comment-Frame, oder im Lyric-Frame
  result := -1;
  idstr := GetFrameIDString(IDv2_USERDEFINEDURL);
  for i := 0 to Frames.Count - 1 do
  begin
      if (Frames[i] as TID3v2Frame).FrameIDString = IDstr then
      begin
          (Frames[i] as TID3v2Frame).GetUserdefinedURL(iDescription);
          If Description = iDescription then
          begin
              result := i;
              break;
          end;
      end;
  end;
end;

function TID3v2Tag.GetPopularimaterFrameIndex(aEMail: String):integer;
var idstr, iEMail: String;
    i: Integer;
begin
    result := -1;
    idstr := GetFrameIDString(IDv2_RATING);
    for i := 0 to Frames.Count - 1 do
        if (Frames[i] as TID3v2Frame).FrameIDString = IDstr then
        begin
            (Frames[i] as TID3v2Frame).GetRating(iEMail);
            if (aEMail = iEMail) or (aEMail = '*') then
            begin
                result := i;
                break;
            end;
        end;
end;



//--------------------------------------------------------------------
// Liest den ID3v2Header ein
//--------------------------------------------------------------------
function TID3v2Tag.ReadHeader(Stream: TStream): TMP3Error;
var
  RawHeader: TID3v2Header;
  ExtendedHeader: Array[0..5] of byte;
  ExtendedHeaderSize: Integer;
begin
  result := MP3ERR_None;
  try
    Stream.Seek(0, soFromBeginning);
    Stream.ReadBuffer(RawHeader, 10);
    if RawHeader.ID = 'ID3' then
      if RawHeader.Version in  [2,3,4] then
      begin
        FTagSize := Int28ToInt32(RawHeader.TagSize) + 10;
        FExists := True;
        case RawHeader.Version of
            2: begin
                FFlgUnsynch := (RawHeader.Flags and 128) = 128;
                fFlgCompression := (RawHeader.Flags and 64) = 64;
                fFlgUnknown := (RawHeader.Flags and 63) <> 0;
                FFlgExtended := False;
                FFlgExperimental := False;
                if fFlgCompression then
                  result := ID3ERR_Compression;
                FFlgFooterPresent := False;
            end;
            3: begin
                FFlgUnsynch := (RawHeader.Flags and 128) = 128;
                FFlgExtended := (RawHeader.Flags and 64) = 64;
                FFlgExperimental := (RawHeader.Flags and 32) = 32;
                fFlgUnknown := (RawHeader.Flags and 31) <> 0;
                fFlgCompression := False;
                FFlgFooterPresent := False;
            end;
            4: begin
                FFlgUnsynch := (RawHeader.Flags and 128) = 128;
                FFlgExtended := (RawHeader.Flags and 64) = 64;
                FFlgExperimental := (RawHeader.Flags and 32) = 32;
                fFlgCompression := False;
                FFlgFooterPresent := (RawHeader.Flags and 16) = 16;
                fFlgUnknown := (RawHeader.Flags and 15) <> 0;                
                if FFlgFooterPresent then
                  FTagSize := FTagSize + 10;
            end;
        end;

        // Version setzen
        FVersion.Major := RawHeader.Version;
        FVersion.Minor := RawHeader.Revision;

        // Wenn ExtendedHeader, dann Größe des Extended Header lesen
        // und entsprechend weiterspringen.
        // Beim Schreiben des ID3v2Tags wird dieser nicht beachtet!
        if FFlgExtended then
        begin
            // VERSION /// NUR IN 2.4 IST EXTENDED HEADER SIZE SYNC-SAFE!!!
            Stream.ReadBuffer(ExtendedHeader[0], 6); // Minimumgröße für Extended Header ist 6
            if fversion.Major =4 then
              ExtendedHeaderSize := 2097152 * ExtendedHeader[0]
                + 16384 * ExtendedHeader[1]
                + 128 * ExtendedHeader[2]
                + ExtendedHeader[3]
            else
              ExtendedHeaderSize := 16777216 * ExtendedHeader[0]
                + 65536 * ExtendedHeader[1]
                + 256 * ExtendedHeader[2]
                + ExtendedHeader[3];

            Stream.Seek(ExtendedHeaderSize-6, soFromCurrent);
        end;
      end
      else
          // Version kleiner als 2 oder größer als 4 -> ungültig
          result := ID3ERR_Invalid_Header
    else
        result := ID3ERR_NoTag;
  except
    on EReadError do result := MP3ERR_SRead;
    on E: Exception do
    begin
      result := ID3ERR_Unclassified;
      MessageBox(0, PChar(E.Message), PChar('Error'), MB_OK or MB_ICONERROR or MB_TASKMODAL or MB_SETFOREGROUND);
    end;
  end;
end;

//--------------------------------------------------------------------
// Lese die Frames des ID3v2 Tags
//--------------------------------------------------------------------
function TID3v2Tag.ReadFrames(From: LongInt; Stream: TStream): TMP3Error;
var FrameIDstr: string;
    newFrame: TID3v2Frame;
begin
  result := MP3ERR_None;
  FUsePadding := False;
  try
    case fVersion.Major of
      // Version 2-Header hat eine Größe von 6 Byte (3 Byte ID, 3 Byte Größe)
      2 : Setlength(FrameIDstr,3)
      else Setlength(FrameIDstr,4);
    end;

    if Stream.Position <> From then
      Stream.Position := From;

    // evtl. alte Frames entfernen
    Frames.Clear;

    while (Stream.Position < (FTagSize - fPaddingSize))
                                       and (Stream.Position < Stream.Size) do
    begin
      // FrameID aus Stream lesen
      Stream.Read(FrameIDStr[1], length(FrameIDStr));

      if ValidFrame(FrameIDstr) then
      begin
        newFrame := TID3v2Frame.Create(FrameIDstr, TID3v2FrameVersions(FVersion.Major));
        newFrame.ReadFromStream(Stream);
        NewFrame.AlwaysWriteUnicode := fAlwaysWriteUnicode;
        {$IFDEF USE_DIConverters}
        newFrame.CharCode := fCharCode;
        NewFrame.AcceptAllEncodings := fAcceptAllEncodings;
        {$ENDIF}
        Frames.Add(newFrame);
      end else
      // Kein neuer gültiger Frame gefunden. Der Rest des Tags ist also Padding
      // Den evtl. vorhandenen Footer ignoriere ich (bzw. ersetze ihn durch 0)
      begin
        fPaddingSize := FTagSize - (Stream.Position - length(FrameIDStr));
        FUsePadding := True;
        Break;
      end;
    end;

  except
    on EReadError do result := MP3ERR_SRead;
    on E: Exception do
    begin
      result := ID3ERR_Unclassified;
      MessageBox(0, PChar(E.Message), PChar('Error'), MB_OK or MB_ICONERROR or MB_TASKMODAL or MB_SETFOREGROUND);
    end;
  end;
end;

procedure TID3v2Tag.SyncStream(Source, Target: TStream);
var buf: TBuffer;
    i, last: Int64;
begin
    if FTagSize = 0 then exit; // aber das sollte nie auftreten !!
    setlength(buf, FTagSize);
    Source.Read(buf[0], FTagSize);
    Target.Size := FTagSize;
    i := 0;
    last := 0;
    while i <= length(buf)-1 do
    begin
        While (i < length(buf)-2) and ((buf[i] <> $FF) or (buf[i+1] <> $00)) do
            inc(i);
        // i ist hier maximal length(buf)-2, d.h. buf[i] ist das vorletzte gültige Element
        // oder buf[i] = 255 und buf[i+1] = 0
        // also: vom letzten Fund bis zu i in den neuen Stream kopieren und buf[i+1] überspringen
        Target.Write(buf[last], i - last + 1);
        last := i + 2;
        inc(i, 2);   // d.h. last = i
    end;
    // den Rest schreiben
    if last <= length(buf)-1 then
        Target.Write(buf[last], length(buf) - last);

    SetStreamEnd(Target);
end;

//--------------------------------------------------------------------
// Tag lesen. Erst den Header, dann ggf. die Frames
//--------------------------------------------------------------------
function TID3v2Tag.ReadFromStream(Stream: TStream): TMP3Error;
var SyncedStream: TMemoryStream;
begin
  // Tag löschen - es könnten Frames enthalten sein
  clear;
  ////

  result := ReadHeader(Stream);
  if (FExists) and (result = MP3ERR_None) then
  begin
      // Falls unsync und Version 2.2 oder 2.3 then:
      // ReadfromStream - Synch in neuen Stream - Readframes von neuem Stream
      if (Version.Major <> 4) and (FFlgUnsynch) then
      begin
          SyncedStream := TMemoryStream.Create;
          SyncStream(Stream, SyncedStream);
          SyncedStream.Position := 0;
          result := ReadFrames(SyncedStream.Position, SyncedStream);
          SyncedStream.Free;
      end else
          // andernfalls:
          // Frames einfach aus dem Original-Stream lesen.
          // bei 2.4 wird Sync auf Frame-Level erledigt.
          result := ReadFrames(Stream.Position, Stream)
  end;
end;


//--------------------------------------------------------------------
// Tag schreiben
//--------------------------------------------------------------------
function TID3v2Tag.WriteToStream(Stream: TStream): TMP3Error;
var
  aHeader: TID3v2Header;
  TmpStream, ID3v2Stream: TtntFileStream;
  TmpName, FrameName: String;
  v1Tag: String[3];
  v1AdditionalPadding: Cardinal;
  Buffer: TBuffer;
  CacheAudio: Boolean;
  i: Integer;
  AudioDataSize: int64;
  tmpFrameStream: TMemoryStream;
  ExistingID3Tag: TID3v2Tag;
begin
  result := MP3ERR_None;
  AudioDataSize := 0;
  v1AdditionalPadding := 0;

  // Ein ID3v2Tag muss mindestens einen Frame enthalten, und dieser muss mindestens ein
  // Byte lang sein.
  // Sollten alle Frames gelöscht worden sein, so muss hier ein Frame erzeugt werden.
  // Ich nehme hier den Titel-Frame und weise diesem dern Wert ' ' zu (ein Leerzeichen)
  //
  // Hinweis: Dass die anderen Frames nicht leer sind, liegt in der "Verantwortung der Frames"
  //          d.h. beim setzen der Eigenschaft muss ggf. der ganze Frame gelöscht werden, wenn
  //          er durch die Änderung keine Daten mehr enthält.

  if Frames.Count = 0 then
    Title := ' ';


  // Frames in tmp. Datei schreiben
  FrameName := GetTempFile;
  try
    ID3v2Stream := TTntFileStream.Create(FrameName, fmCreate or fmShareDenyWrite);

    try
      // Baue einen neuen Header
      // Die Größe des gesamten Tags ist hier noch unbekannt -
      // sie wird später neugesetzt
      aHeader.ID := 'ID3';
      aHeader.Version := fVersion.Major;
      aHeader.Revision := fVersion.Minor;
      for i:=0 to 3 do
          aHeader.TagSize[i] := 0;

      if fFlgUnsynch then
      begin
          // Flag im header setzen!!
          aHeader.Flags := $80;
          // Header schreiben. Die Größe wird später korrigiert.
          ID3v2Stream.WriteBuffer(aHeader,10);
          case fversion.Major of
              2,3: begin
                  tmpFrameStream := TMemoryStream.Create;
                  for i := 0 to Frames.Count - 1 do
                      (Frames[i] as TID3v2Frame).WriteToStream(tmpFrameStream);
                  tmpFrameStream.Position := 0;
                  UnSyncStream(tmpFrameStream, ID3v2Stream);
                  tmpFrameStream.Free;
              end ;
              4: begin
                  // Frames schreiben. Unsynchronisation wird von den Frames erledigt.
                  for i := 0 to Frames.Count - 1 do
                      (Frames[i] as TID3v2Frame).WriteUnsyncedToStream(ID3v2Stream);
              end;
           end;
      end else
      begin
          aHeader.Flags := $00;
          ID3v2Stream.WriteBuffer(aHeader,10);
          // schreibe alle Frames in ein temporäres File 
          for i := 0 to Frames.Count - 1 do
              (Frames[i] as TID3v2Frame).WriteToStream(ID3v2Stream);
      end;

      // wenn ein Frame geschrieben wurde, dann weiter mit schreiben im eigentlichen Sinn
      if ID3v2Stream.Size > 0 then
      begin
          // Tag auslesen, der sich evtl. in der Datei befindet
          ExistingID3Tag := TID3v2Tag.Create;
          ExistingID3Tag.ReadHeader(Stream);

          // Ans Ende des evtl vorhandenen Tags im Stream gehen
          Stream.Seek(ExistingID3Tag.FTagSize, soFromBeginning);

          // Wenn Padding erwünscht ist, und genug Platz da ist: Kein Caching
          if FUsePadding and (ExistingID3Tag.FTagSize > (ID3v2Stream.Size + 30)) then
              CacheAudio := False
          else
              // Andernfalls Audiodaten cachen
              CacheAudio := True;

          if CacheAudio then
          begin
            // Alter ID3v2Tag ist zu klein (oder zu groß !!) für unsere neuen Frames, daher muss
            // der Stream komplett neu geschrieben werden.
            // Dazu:  Audio-Daten in Temp-File schreiben
            TmpName := GetTempFile;
            try
                TmpStream := TTntFileStream.Create(TmpName, fmCreate or fmShareDenyWrite);
                TmpStream.Seek(0, soFromBeginning);

                AudioDataSize := Stream.Size - Stream.Position;
                if TmpStream.CopyFrom(Stream, Stream.Size - Stream.Position) <> AudioDataSize then
                begin
                    TmpStream.Free;
                    result := ID3ERR_Cache;
                    Exit;
                end;

                // Nach einem ID3v1Tag suchen
                // Je nach Existenz werden 128Byte im letzten Cluster dafür "freigehalten"
                Stream.Seek(-128, soFromEnd);
                v1Tag := '   ';
                if (Stream.Read(v1Tag[1], 3) = 3) then
                begin
                  if (v1Tag = 'TAG') then
                    v1AdditionalPadding := 0
                  else
                    v1AdditionalPadding := 128;
                end;
                TmpStream.Free;
              except
                result := ID3ERR_Cache;
                // Cachen ging schief -> Abbruch, um die Datei nicht zu beschädigen!!
                Exit;
              end;
          end;
          // Damit liegt jetzt der komplette (d.h. bis auf das Padding) ID3 Tag im Stream  "ID3v2Stream"
          // und die AudioDaten im Stream "tmpstream" (falls das nötig war)

          // allerdings ist der Header noch ungültig - es fehlt ja noch die Größe des Tags
          // Dazu ist aber auch noch das Padding nötig:
          FDataSize := ID3v2Stream.Size;
          if FUsePadding then
          begin
              // Größe des Paddings bestimmen
              if CacheAudio then
              begin
                  fPaddingSize := GetPaddingSize(AudioDataSize + FDataSize + v1AdditionalPadding, FFilename, FUseClusteredPadding);
                  FTagSize := FDataSize + fPaddingSize;
              end
              else begin
                  fPaddingSize := ExistingID3Tag.FTagSize - FDataSize;
                  FTagSize := ExistingID3Tag.FTagSize;
              end;
          end else
          begin
              // Padding-Größe ist 0
              fPaddingSize := 0;
              FTagSize := FDataSize;
          end;

          // Jetzt die Größe des Headers neu schreiben
          aHeader.TagSize := Int32ToInt28(FTagSize - 10);

          ID3v2Stream.Seek(0, soFromBeginning);
          ID3v2Stream.WriteBuffer(aHeader,10);

          // zum Anfang des Streams gehen, und mit dem eigentlichen
          // schreiben beginnen
          Stream.Seek(0, soFromBeginning);
          ID3v2Stream.Seek(0, soFromBeginning);

          // ID3v2 Header und Daten schreiben
          Stream.CopyFrom(ID3v2Stream, ID3v2Stream.Size);

          setlength(Buffer, fPaddingSize);
          FillChar(Buffer[0], fPaddingSize, 0);
          Stream.Write(Buffer[0], fPaddingSize);

          // ggf. gecachte AudioDaten schreiben
          if CacheAudio then
          begin
            try
              TmpStream := TTntFileStream.Create(TmpName, fmOpenRead);
              try
                TmpStream.Seek(0, soFromBeginning);
                Stream.CopyFrom(TmpStream, TmpStream.Size);
                SetStreamEnd(Stream);
              finally
                TmpStream.Free;
              end;
            except
              result := MP3ERR_FOpenR;
              Exit;
            end;
          end;
          // Audio-Cache-File löschen
          DeleteFile(PChar(TmpName));

          // existierenden Tag wieder freigeben
          ExistingID3Tag.Free;

      end;  // if ID3v2Stream.Size > 0;

    finally
      ID3v2Stream.Free;
      // tmp-File für den ID3Tag löschen
      DeleteFile(PChar(FrameName));
    end;
  except
    on EFCreateError do result := MP3ERR_FopenCRT;
    on EWriteError do result := MP3ERR_SWrite;
    on E: Exception do
    begin
      result := ID3ERR_Unclassified;
      MessageBox(0, PChar(E.Message), PChar('Error Error'), MB_OK or MB_ICONERROR or MB_TASKMODAL or MB_SETFOREGROUND);
    end;
  end;
end;

//--------------------------------------------------------------------
// Tag löschen
//--------------------------------------------------------------------
function TID3v2Tag.RemoveFromStream(Stream: TStream): TMP3Error;
var
  TmpStream: TTntFileStream;
  TmpName: String;
//  ActualVersion: TID3Version;
  tmpsize: int64;
  ExistingID3Tag: TID3v2Tag;
begin
  result := MP3ERR_None;
  try
      ExistingID3Tag := TID3v2Tag.Create;
      ExistingID3Tag.ReadHeader(Stream);

      // wenn ein Tag existiert...
      if ExistingID3Tag.FExists then
      begin
          // ...zum Ende springen...
          Stream.Seek(ExistingID3Tag.FTagSize, soFromBeginning);

          // ...die Audiodaten cachen...
          TmpName := GetTempFile;
          try
              TmpStream := TTntFileStream.Create(TmpName, fmCreate);
              try
                  TmpStream.Seek(0, soFromBeginning);
                  tmpsize := Stream.Size - Stream.Position;
                  if TmpStream.CopyFrom(Stream, Stream.Size - Stream.Position) <> tmpsize then
                  begin
                      TmpStream.Free;
                      result := ID3ERR_Cache;
                      Exit;
                  end;
                  // ...den Stream kürzen...
                  Stream.Seek(-ExistingID3Tag.FTagSize, soFromEnd);
                  SetStreamEnd(Stream);
                  ExistingID3Tag.Free;
                  // ...und die Audiodaten zurückschreiben.
                  Stream.Seek(0, soFromBeginning);
                  TmpStream.Seek(0, soFromBeginning);
                  if Stream.CopyFrom(TmpStream, TmpStream.Size) <> TmpStream.Size then
                  begin
                      TmpStream.Free;
                      result := ID3ERR_Cache;
                      Exit;
                  end;
              except
                  on EWriteError do result := MP3ERR_SWrite;
                  on E: Exception do
                  begin
                      result := ID3ERR_Unclassified;
                      MessageBox(0, PChar(E.Message), PChar('Error'), MB_OK or MB_ICONERROR or MB_TASKMODAL or MB_SETFOREGROUND);
                  end;
              end;
              // tmp-Datei löschen
              TmpStream.Free;
              DeleteFile(PChar(TmpName));
          except
              on EFOpenError do result := MP3ERR_FOpenCRT;
              on E: Exception do
              begin
                  result := ID3ERR_Unclassified;
                  MessageBox(0, PChar(E.Message), PChar('Error'), MB_OK or MB_ICONERROR or MB_TASKMODAL or MB_SETFOREGROUND);
              end;
          end;
      end
      else
          result := ID3ERR_NoTag;
  except
      on E: Exception do
      begin
          result := ID3ERR_Unclassified;
          MessageBox(0, PChar(E.Message), PChar('Error'), MB_OK or MB_ICONERROR or MB_TASKMODAL or MB_SETFOREGROUND);
      end;
  end;
end;


//--------------------------------------------------------------------
// Tag aus Datei lesen
//--------------------------------------------------------------------
function TID3v2Tag.ReadFromFile(Filename: WideString): TMP3Error;
var Stream: TTntFileStream;
begin
  if WideFileExists(Filename) then
    try
      FFilename := Filename;
      Stream := TTntFileStream.Create(Filename, fmOpenRead or fmShareDenyWrite);
      try
        result := ReadFromStream(Stream);
      finally
        Stream.Free;
      end;
    except
      result := MP3ERR_FOpenR;
    end
  else
    result := MP3ERR_NoFile;
end;

//--------------------------------------------------------------------
// Tag in Datei schreiben
//--------------------------------------------------------------------
function TID3v2Tag.WriteToFile(Filename: WideString): TMP3Error;
var Stream: TTntFileStream;
begin
  if WideFileExists(Filename) then
    try
      FFilename := Filename;
      Stream := TTntFileStream.Create(Filename, fmOpenReadWrite or fmShareDenyWrite);
      try
        result := WriteToStream(Stream);
      finally
        Stream.Free;
      end;
    except
      result := MP3ERR_FOpenRW;
    end
  else
    result := MP3ERR_NoFile;
end;

//--------------------------------------------------------------------
// Tag aus Datei löschen
//--------------------------------------------------------------------
function TID3v2Tag.RemoveFromFile(Filename: WideString): TMP3Error;
var Stream: TTntFileStream;
begin
  if WideFileExists(Filename) then
    try
      FFilename := Filename;
      Stream := TTntFileStream.Create(Filename, fmOpenReadWrite or fmShareDenyWrite);
      try
        result := RemoveFromStream(Stream);
      finally
        Stream.Free;
      end;
    except
      result := MP3ERR_FOpenRW;
    end
  else
    result := MP3ERR_NoFile;
end;


procedure TID3v2Tag.Clear;
begin
  // Default-Verison ist bei mir 3. Diese schreibe ich, wenn kein ID3v2Tag gefunden wird.
  FVersion.Major := 3;
  FVersion.Minor := 0;
  FTagSize := 0;
  FDataSize :=0;
  fPaddingSize := 0;
  FExists := False;
  FUsePadding := True;
  fFlgUnsynch       := False;
  fFlgCompression   := False;
  fFlgExtended      := False;
  fFlgExperimental  := False;
  fFlgFooterPresent := False;
  fFlgUnknown       := False;
  FUseClusteredPadding := True;

  // Das nicht, da Clear bei ReadfromStream aufgerufen wird,
  // und damit ggf. Information verloren geht!
//  AlwaysWriteUnicode := False;
//  {$IFDEF USE_DIConverters}
//  FillChar(conv, SizeOf(conv), 0);
//  FCharCode := DefaultCharCode;
//  AcceptAllEncodings := True;
//  {$ENDIF}
  Frames.Clear;
end;


//--------------------------------------------------------------------
// Liefert die Textinformationen aus einem textframe zurück
//--------------------------------------------------------------------
function TID3v2Tag.GetText(FrameID: TFrameIDs):WideString;
var i:integer;
begin
  i := GetFrameIndex(FrameID);
  if i > -1 then
    result := (Frames[i] as TID3v2Frame).GetText
  else
    result := '';
end;

//--------------------------------------------------------------------
// Schreibt einen String in einen Textframe
// Ist der übergebene String leer, wird der gesamte Frame gelöscht
//--------------------------------------------------------------------
procedure TID3v2Tag.SetText(FrameID:TFrameIDs; Value: WideString);
var i:integer;
  idStr: String;
  NewFrame: TID3v2Frame;
begin
  // nicht alle Frames sind in allen Versionen enthalten, daher ggf. abbrechen
  idStr := GetFrameIDString(FrameID);
  if not ValidTextFrame(iDStr) then exit;

  i := GetFrameIndex(FrameID);
  if i > -1 then
  begin
      // Frame exitiert schon
      if value = '' then
          Frames.Delete(i)
      else
          (Frames[i] as TID3v2Frame).SetText(Value);
  end
  else
      if value <> '' then
      begin
          // neuen Frame erstellen
          NewFrame := TID3v2Frame.Create(idStr, TID3v2FrameVersions(FVersion.Major));
          NewFrame.AlwaysWriteUnicode := fAlwaysWriteUnicode;
          {$IFDEF USE_DIConverters}
          newFrame.CharCode := fCharCode;
          NewFrame.AcceptAllEncodings := fAcceptAllEncodings;
          {$ENDIF}
          Frames.Add(newFrame);
          newFrame.SetText(Value);
      end;
end;

function TID3v2Tag.GetURL(FrameID: TFrameIDs):String;
var i:integer;
begin
  i := GetFrameIndex(FrameID);
  if i > -1 then
    result := (Frames[i] as TID3v2Frame).GetURL
  else
    result := '';
end;
procedure TID3v2Tag.SetURL(FrameID:TFrameIDs; Value: String);
var i:integer;
  idStr: String;
  NewFrame: TID3v2Frame;
begin
  // nicht alle Frames sind in allen Versionen enthalten, daher ggf. abbrechen
  idStr := GetFrameIDString(FrameID);
  if not ValidFrame(iDStr) then exit;

  i := GetFrameIndex(FrameID);
  if i > -1 then
  begin
      // Frame exitiert schon
      if value = '' then
          Frames.Delete(i)
      else
          (Frames[i] as TID3v2Frame).SetURL(Value);
  end
  else
      if value <> '' then
      begin
          // neuen Frame erstellen
          NewFrame := TID3v2Frame.Create(idStr, TID3v2FrameVersions(FVersion.Major));
          NewFrame.AlwaysWriteUnicode := fAlwaysWriteUnicode;
          {$IFDEF USE_DIConverters}
          newFrame.CharCode := fCharCode;
          NewFrame.AcceptAllEncodings := fAcceptAllEncodings;
          {$ENDIF}
          Frames.Add(newFrame);
          newFrame.SetURL(Value);
      end;
end;

//--------------------------------------------------------------------
// Liest den String aus einem "Beschriebenen" Textframe, z.B. Commentare, Lyrics
//--------------------------------------------------------------------
function TID3v2Tag.GetDescribedTextFrame(ID: TFrameIDs; Language: string; Description: WideString): WideString;
var i: integer;
    DummyLanguage: String;
    DummyDescription: WideString;
begin
  i := GetDescribedTextFrameIndex(ID,Language,Description);
  if i > -1 then
      result := (Frames[i] as TID3v2Frame).GetCommentsLyrics(DummyLanguage,DummyDescription)
  else
      result:='';
end;

procedure TID3v2Tag.SetDescribedTextFrame(ID:TFrameIDs;Language:string;Description:WideString; Value:WideString);
var i:integer;
    idstr: String;
    NewFrame: TID3v2Frame;
begin
  // Hinweis zur Benutzung dieser Funktion:
  // der Comment-Frame im id3v2Tag _kann_ mehrfach auftreten - jeweils einer mit eindeutiger Sprache|Description
  // Viele ID3Tagger zeigen aber eine Art "Standard-Comment" an.
  // Dieser hat die Description '' (Leerstring). Die Sprache ist aber nicht einheitlich.
  // Um diesen "Pseudo-Standard-Kommentar" zu setzen erlaube ich die Übergabe von "*" im Sprach-Parameter.
  // Dann wird der erste gefundene Frame, der mit der Beschreibung zusammenpasst, überschrieben. Wird kein
  // passender Frame gefunden, wird die Sprache auf 'eng' (english) gesetzt.

  idStr := GetFrameIDString(ID);
  if not ValidFrame(iDStr) then exit;

  if (language <>'*') AND (length(language)<>3)
    then language := 'eng';

  // Frame suchen
  i := GetDescribedTextFrameIndex(ID, Language, Description);

  if i > -1 then
  begin
      // Frame exitiert schon
      if value= '' then
          Frames.Delete(i)
      else
        (Frames[i] as TID3v2Frame).SetCommentsLyrics(Language, Description, Value);
  end
  else
      if value <> '' then
      begin
          // neuen Frame erstellen
          NewFrame := TID3v2Frame.Create(idStr, TID3v2FrameVersions(FVersion.Major));
          NewFrame.AlwaysWriteUnicode := fAlwaysWriteUnicode;
          {$IFDEF USE_DIConverters}
          newFrame.CharCode := fCharCode;
          NewFrame.AcceptAllEncodings := fAcceptAllEncodings;
          {$ENDIF}
          Frames.Add(newFrame);
          newFrame.SetCommentsLyrics(Language, Description, Value);
      end;
end;


function TID3v2Tag.GetAllFrameDescriptions(FrameID:TFrameIDs): TFrameDescriptionArray;
var idstr, Language: string;
  i:integer;
  Comm, Desc: WideString;
begin
  setlength(result,0);
  idstr := GetFrameIDString(FrameID);
  for i := 0 to Frames.Count - 1 do
    if (Frames[i]as TID3v2Frame).FrameIDString = IDstr then
    begin
        Comm := (Frames[i]as TID3v2Frame).GetCommentsLyrics(Language, Desc);
        setlength(result, length(result) + 1);
        result[length(result)-1].Language := (Language);
        result[length(result)-1].Description := (Desc);
    end;
end;

function TID3v2Tag.GetAllPictureFrameDescriptions: TPictureFrameDescriptionArray;
var idstr, mime: string;
  i:integer;
  arrayIDX:integer;
  PictureData : TMemoryStream;
  desc: WideString;
  picTyp: Byte;
begin
  setlength(result,0);
  idstr := GetFrameIDString(IDv2_PICTURE);
  for i := 0 to Frames.Count - 1 do
    if (Frames[i]as TID3v2Frame).FrameIDString = IDstr then
    begin
      arrayIDX := length(result);
      setlength(result,arrayIDX+1);

      PictureData := TMemoryStream.Create;
      (Frames[i] as TID3v2Frame).GetPicture(Mime, PicTyp, Desc, PictureData);
      PictureData.Free;

      result[arrayIdx].Description := Desc;
      result[arrayIdx].Bildtyp := PicTyp;
    end;
end;


// ------------------------------------------
// Erweiterte Comments schreiben und lesen
// ------------------------------------------
procedure TID3v2Tag.SetExtendedComment(Language:string;Description:WideString; value:WideString);
begin
  SetDescribedTextFrame(IDv2_COMMENT,Language,Description,value);
end;
function TID3v2Tag.GetExtendedComment(Language:string;Description:WideString): WideString;
begin
  result := GetDescribedTextFrame(IDv2_COMMENT,Language,Description);
end;
function TID3v2Tag.GetAllCommentDescriptions: TFrameDescriptionArray;
begin
  result := GetAllFrameDescriptions(IDv2_COMMENT);
end;
procedure TID3v2Tag.DeleteExtendedComment(Language:string;Description:WideString);
begin
  SetDescribedTextFrame(IDv2_COMMENT, Language, Description, '');
end;

// ------------------------------------------
// Lyrics lesen und schreiben
// ------------------------------------------
procedure TID3v2Tag.SetLyrics(Language:string;Description:WideString; value:WideString);
begin
  SetDescribedTextFrame(IDv2_LYRICS,Language,Description,value);
end;
function TID3v2Tag.GetLyrics(Language:string;Description:WideString): WideString;
begin
  result := GetDescribedTextFrame(IDv2_LYRICS,Language,Description);
end;
function TID3v2Tag.GetAllLyricsDescriptions: TFrameDescriptionArray;
begin
  result := GetAllFrameDescriptions(IDv2_LYRICS);
end;
procedure TID3v2Tag.DeleteLyrics(Language:string;Description:WideString);
begin
  //DeleteDescribedTextFrame(IDv2_LYRICS, Language, Description);
  SetDescribedTextFrame(IDv2_LYRICS, Language, Description, '');
end;


// ------------------------------------------
// Bild lesen
// ------------------------------------------
function TID3v2Tag.GetPicture(stream: TStream; Description: WideString): String;
var idx: Integer;
    mime: string;
    DummyPicTyp: Byte;
    DummyDesc: WideString;
begin
    IDX := GetPictureFrameIndex( Description);
    if IDX <> -1 then
    begin
      (Frames[IDX] as TID3v2Frame).GetPicture(Mime, DummyPicTyp, DummyDesc, stream);
      result := mime;
    end else
      result := '';
end;

// Alte Variante
procedure TID3v2Tag._GetPicture(stream: TStream; Description:TPictureFrameDescription);
begin
    GetPicture(stream, Description.Description);
end;

// ------------------------------------------
// Bild schreiben
// ------------------------------------------
procedure TID3v2Tag.SetPicture(MimeTyp: String; PicType: Byte; Description: WideString; stream: TStream);
var IDX: Integer;
    NewFrame: TID3v2Frame;
    idStr: String;
    oldMime: String;
    oldDescription: WideString;
    oldType: Byte;
    oldStream: TMemoryStream;
begin
    // neue Version
    idStr := GetFrameIDString(IDv2_PICTURE);
    IDX := GetPictureFrameIndex({PicType,} Description);
    if IDX <> -1 then
    begin
        if Stream = NIL then
          Frames.Delete(IDX)
        else
        begin
            if (Description = '*') or (MimeTyp = '*') or (Stream.size = 0) then
            begin
                oldStream := TMemoryStream.Create;
                (Frames[IDX] as TID3v2Frame).GetPicture(oldMime, oldType, oldDescription, oldStream);
                if (Description = '*') then
                  Description := oldDescription;
                if (MimeTyp = '*') then
                  MimeTyp := oldMime;
                if Stream.Size = 0 then
                  oldStream.SaveToStream(Stream);
                oldStream.Free;
            end;
            (Frames[IDX] as TID3v2Frame).SetPicture(MimeTyp, PicType, Description, Stream)
        end;

    end else
    begin
        if (Stream <> NIL) and (Stream.Size > 0)then
        begin
            // neuen Frame erstellen
            NewFrame := TID3v2Frame.Create(idStr, TID3v2FrameVersions(FVersion.Major));
            NewFrame.AlwaysWriteUnicode := fAlwaysWriteUnicode;
            {$IFDEF USE_DIConverters}
            newFrame.CharCode := fCharCode;
            NewFrame.AcceptAllEncodings := fAcceptAllEncodings;
            {$ENDIF}
            Frames.Add(newFrame);
            if (Description = '*') then
                Description := '';
            if (MimeTyp = '*') then
                  MimeTyp := 'image/jpeg';
            newFrame.SetPicture(MimeTyp, PicType, Description, stream)
        end;
    end;
end;

procedure TID3v2Tag._SetPicture(stream: TStream; Description:TPictureFrameDescription);
begin  // alte Version
    SetPicture('image/jpeg',  Description.Bildtyp, Description.Description, stream);
end;

procedure TID3v2Tag.DeletePicture(Description:TPictureFrameDescription);
var idx: integer;
begin
  IDX := GetPictureFrameIndex({Description.Bildtyp, }Description.Description);
  if IDX > -1 then
    Frames.Delete(IDX);
end;



function TID3v2Tag.GetUserDefinedURL(Description: WideString): String;
var IDX: Integer;
    DummyDesc: WideString;
begin
    IDX := GetUserDefinedURLFrameIndex(Description);
    if IDX <> -1 then
        result := (Frames[IDX] as TID3v2Frame).GetUserdefinedURL(DummyDesc);
end;

procedure TID3v2Tag.SetUserDefinedURL(Description: WideString; Value: String);
var IDX: Integer;
    NewFrame: TID3v2Frame;
    idStr: String;
begin
    // neue Version
    idStr := GetFrameIDString(IDv2_USERDEFINEDURL);
    IDX := GetUserDefinedURLFrameIndex(Description);
    if IDX <> -1 then
    begin
        if Value <> '' then
            (Frames[IDX] as TID3v2Frame).SetUserdefinedURL(Description, Value)
        else
            Frames.Delete(IDX);
    end else
    begin
        if Value <> '' then
        begin
            // neuen Frame erstellen
            NewFrame := TID3v2Frame.Create(idStr, TID3v2FrameVersions(FVersion.Major));
            NewFrame.AlwaysWriteUnicode := fAlwaysWriteUnicode;
            {$IFDEF USE_DIConverters}
            newFrame.CharCode := fCharCode;
            NewFrame.AcceptAllEncodings := fAcceptAllEncodings;
            {$ENDIF}
            Frames.Add(newFrame);
            newFrame.SetUserdefinedURL(Description, Value)
        end;
    end;
end;


function TID3v2Tag.GetStandardUserDefinedURL: String;
begin
    result := GetUserDefinedURL('');
end;

procedure TID3v2Tag.SetStandardUserDefinedURL(Value: String);
begin
    SetUserDefinedURL('', Value);
end;

function TID3v2Tag.GetArbitraryRating: Byte;
begin
    result := GetRating('*');
end;
procedure TID3v2Tag.SetArbitraryRating(Value: Byte);
begin
    SetRating('*', Value);
end;



// ------------------------------------------
// Lesen der Bewertungen
// ------------------------------------------

function TID3v2Tag.GetRating(aEMail: String): Byte;
var IDX: Integer;
begin
    IDX := GetPopularimaterFrameIndex(aEMail);
    if IDX <> -1 then
        result := (Frames[IDX] as TID3v2Frame).GetRating(aEMail)
    else
        result := 0;
end;

procedure TID3v2Tag.SetRating(aEMail: String; Value: Byte);
var IDX: Integer;
    NewFrame: TID3v2Frame;
    idStr: String;
begin
    idStr := GetFrameIDString(IDv2_RATING);
    IDX := GetPopularimaterFrameIndex(aEMail);
    if IDX <> -1 then
    begin
        if Value <> 0 then
        begin
            if aEMail = '*' then // alte Adresse weiterbenutzen
                (Frames[IDX] as TID3v2Frame).GetRating(aEMail);
            (Frames[IDX] as TID3v2Frame).SetRating(aEMail, Value);
        end
        else
            Frames.Delete(IDX);
    end else
    begin
        if Value <> 0 then
        begin
            // neuen Frame erstellen
            NewFrame := TID3v2Frame.Create(idStr, TID3v2FrameVersions(FVersion.Major));
            NewFrame.AlwaysWriteUnicode := fAlwaysWriteUnicode;
            {$IFDEF USE_DIConverters}
            newFrame.CharCode := fCharCode;
            NewFrame.AcceptAllEncodings := fAcceptAllEncodings;
            {$ENDIF}
            Frames.Add(newFrame);
            if aEMail = '*' then
                aEMail := DefaultRatingDescription;
            newFrame.SetRating(aEMail, Value);
        end;
    end;
end;



// ------------------------------------------
// Set-Funktionen der Standard-Eigenschaften
// ------------------------------------------
procedure TID3v2Tag.SetTitle(Value: WideString);
begin
  SetText(IDv2_TITEL, Value);
end;
procedure TID3v2Tag.SetArtist(Value: WideString);
begin
  SetText(IDv2_ARTIST, Value);
end;
procedure TID3v2Tag.SetAlbum(Value: WideString);
begin
  SetText(IDv2_ALBUM, Value);
end;
function TID3v2Tag.BuildID3v2Genre(value:WideString):WideString;
begin
  // Baue einen String der Form "(<Index>)<Name>"
  if Genres.IndexOf(value) > -1 then
    result := '(' + inttostr(Genres.IndexOf(value)) + ')' + value
  else
    result := value;
end;
procedure TID3v2Tag.SetGenre(Value: WideString);
begin
  SetText(IDv2_GENRE, BuildID3v2Genre(Value));
end;
procedure TID3v2Tag.SetYear(Value: WideString);
var temp:integer;
begin
  // Value Korrigieren
  temp := StrToIntDef(Trim(Value), 0);
  if  (temp > 0) and (temp < 10000) then
  begin
    Value := Trim(Value);
    Insert(StringOfChar('0', 4 - Length(Value)), Value, 1);
  end
  else
    Value := '';
  SetText(IDv2_YEAR, Value);
end;
procedure TID3v2Tag.SetTrack(Value: WideString);
begin
  SetText(IDv2_TRACK, Value);
end;
procedure TID3v2Tag.SetStandardComment(Value: WideString);
begin
  SetDescribedTextFrame(IDv2_COMMENT,'*','',value);
end;
procedure TID3v2Tag.SetStandardLyrics(Value: WideString);
begin
  SetDescribedTextFrame(IDv2_Lyrics,'*','',value);
end;

procedure TID3v2Tag.SetComposer(Value: WideString);
begin
  SetText(IDv2_COMPOSER, value);
end;
procedure TID3v2Tag.SetOriginalArtist(Value: WideString);
begin
  SetText(IDv2_ORIGINALARTIST, value);
end;
procedure TID3v2Tag.SetCopyright(Value: WideString);
begin
  SetText(IDv2_COPYRIGHT, value);
end;
procedure TID3v2Tag.SetEncodedBy(Value: WideString);
begin
  SetText(IDv2_ENCODEDBY, value);
end;
procedure TID3v2Tag.SetLanguages(Value: WideString);
begin
  SetText(IDv2_LANGUAGES, value);
end;
procedure TID3v2Tag.SetSoftwareSettings(Value: WideString);
begin
  SetText(IDv2_SOFTWARESETTINGS, value);
end;
procedure TID3v2Tag.SetMediatype(Value: WideString);
begin
  SetText(IDv2_MEDIATYPE, value);
end;

procedure TID3v2Tag.Setid3Length(Value: WideString);
begin
  SetText(Idv2_LENGTH, value);
end;
procedure TID3v2Tag.SetPublisher(Value: WideString);
begin
  SetText(Idv2_PUBLISHER, value);
end;
procedure TID3v2Tag.SetOriginalFilename(Value: WideString);
begin
  SetText(Idv2_ORIGINALFILENAME, value);
end;
procedure TID3v2Tag.SetOriginalLyricist(Value: WideString);
begin
  SetText(Idv2_ORIGINALLYRICIST, value);
end;
procedure TID3v2Tag.SetOriginalReleaseYear(Value: WideString);
begin
  SetText(Idv2_ORIGINALRELEASEYEAR, value);
end;
procedure TID3v2Tag.SetOriginalAlbumTitel(Value: WideString);
begin
  SetText(Idv2_ORIGINALALBUMTITEL, value);
end;


// ------------------------------------------
// Get-Funktionen der Standard-Eigenschaften
// ------------------------------------------
function TID3v2Tag.GetTitle:WideString;
begin
  result := GetText(IDv2_TITEL);
end;
function TID3v2Tag.GetArtist:WideString;
begin
  result := GetText(IDv2_ARTIST);
end;
function TID3v2Tag.GetAlbum:WideString;
begin
  result := GetText(IDv2_ALBUM);
end;
function TID3v2Tag.ParseID3v2Genre(value:WideString):WideString;
var posauf, poszu: integer;
  GenreID:Byte;
begin
  //Erwartete Formate des Genrestrings im ID3v2Tag:
  // (a): (nr), wobei nr. die v1-ID ist, oder sein sollte
  // (b): (nr)BEZEICHNUNG, wobei "Bezeichnung" zusätzlich die entsprechende Benennung zur ID sein sollte
  // (c): BEZEICHNUNG, die dann in dem Array genres[] gesucht werden sollte.}
  // Default
  result := value;
  // Fall a, b: Klammern vorhanden
  posauf := pos('(',value);
  poszu := pos(')',value);
  if posauf<poszu then
  begin
    GenreID := StrTointDef(copy(value,posauf+1, poszu-posauf-1),255);
    if GenreID < 126 then
      result := Genres[GenreID];
  end;
end;
function TID3v2Tag.GetGenre:WideString;
begin
  result := ParseID3v2Genre(GetText(IDv2_GENRE));
end;
function TID3v2Tag.GetYear:WideString;
begin
  result := GetText(IDv2_YEAR);
end;
function TID3v2Tag.GetTrack:WideString;
begin
  result := GetText(IDv2_TRACK);
end;
function TID3v2Tag.GetStandardComment: WideString;
begin
  result := GetDescribedTextFrame(IDv2_COMMENT,'*','');
end;
function TID3v2Tag.GetStandardLyrics: WideString;
begin
  result := GetDescribedTextFrame(IDv2_Lyrics,'*','');
end;

function TID3v2Tag.GetComposer: WideString;
begin
  result := GetText(IDv2_COMPOSER);
end;
function TID3v2Tag.GetOriginalArtist: WideString;
begin
  result := GetText(IDv2_ORIGINALARTIST);
end;
function TID3v2Tag.GetCopyright: WideString;
begin
  result := GetText(IDv2_COPYRIGHT);
end;
function TID3v2Tag.GetEncodedBy: WideString;
begin
  result := GetText(IDv2_ENCODEDBY);
end;
function TID3v2Tag.GetLanguages: WideString;
begin
  result := GetText(IDv2_LANGUAGES);
end;
function TID3v2Tag.GetSoftwareSettings: WideString;
begin
  result := GetText(IDv2_SOFTWARESETTINGS);
end;
function TID3v2Tag.GetMediatype: WideString;
begin
  result := GetText(IDv2_MEDIATYPE);
end;

function TID3v2Tag.Getid3Length: WideString;
begin
  result := GetText(IDv2_LENGTH);
end;
function TID3v2Tag.GetPublisher: WideString;
begin
  result := GetText(IDv2_PUBLISHER);
end;
function TID3v2Tag.GetOriginalFilename: WideString;
begin
  result := GetText(IDv2_ORIGINALFILENAME);
end;
function TID3v2Tag.GetOriginalLyricist: WideString;
begin
  result := GetText(IDv2_ORIGINALLYRICIST);
end;
function TID3v2Tag.GetOriginalReleaseYear: WideString;
begin
  result := GetText(IDv2_ORIGINALRELEASEYEAR);
end;
function TID3v2Tag.GetOriginalAlbumTitel: WideString;
begin
  result := GetText(IDv2_ORIGINALALBUMTITEL);
end;


function TID3v2Tag.GetAllFrames: TObjectlist;
var i: Integer;
begin
  result := TObjectList.Create(False);
  for i := 0 to Frames.Count-1 do
      result.Add(Frames[i]);
end;
function TID3v2Tag.GetAllTextFrames: TObjectlist;
var i: Integer;
begin
  result := TObjectList.Create(False);
  for i := 0 to Frames.Count-1 do
  begin
    if (Frames[i] as TID3v2Frame).FrameIDString[1] = 'T' then
        result.Add(Frames[i]);
  end;
end;
function TID3v2Tag.GetAllCommentFrames: TObjectlist;
var i: Integer;
    idStr: String;
begin
  result := TObjectList.Create(False);
  idStr := GetFrameIDString(IDv2_Comment);
  for i := 0 to Frames.Count-1 do
  begin
    if (Frames[i] as TID3v2Frame).FrameIDString = idStr then
        result.Add(Frames[i]);
  end;
end;
function TID3v2Tag.GetAllLyricFrames: TObjectlist;
var i: Integer;
    idStr: String;
begin
  result := TObjectList.Create(False);
  idStr := GetFrameIDString(IDv2_Lyrics);
  for i := 0 to Frames.Count-1 do
  begin
    if (Frames[i] as TID3v2Frame).FrameIDString = idStr then
        result.Add(Frames[i]);
  end;
end;
function TID3v2Tag.GetAllUserDefinedURLFrames: TObjectlist;
var i: Integer;
    idStr: String;
begin
  result := TObjectList.Create(False);
  idStr := GetFrameIDString(IDv2_USERDEFINEDURL);
  for i := 0 to Frames.Count-1 do
  begin
    if (Frames[i] as TID3v2Frame).FrameIDString = idStr then
        result.Add(Frames[i]);
  end;
end;

function TID3v2Tag.GetAllPictureFrames: TObjectlist;
var i: Integer;
    idStr: String;
begin
  result := TObjectList.Create(False);
  idStr := GetFrameIDString(IDv2_Picture);
  for i := 0 to Frames.Count-1 do
  begin
    if (Frames[i] as TID3v2Frame).FrameIDString = idStr then
        result.Add(Frames[i]);
  end;
end;
function TID3v2Tag.GetAllPopularimeterFrames: TObjectlist;
var i: Integer;
    idStr: String;
begin
  result := TObjectList.Create(False);
  idStr := GetFrameIDString(IDv2_Rating);
  for i := 0 to Frames.Count-1 do
  begin
    if (Frames[i] as TID3v2Frame).FrameIDString = idStr then
        result.Add(Frames[i]);
  end;
end;
function TID3v2Tag.GetAllURLFrames: TObjectlist;
var i: Integer;
    idStr: String;
begin
  result := TObjectList.Create(False);
  idStr := GetFrameIDString(IDv2_Rating);
  for i := 0 to Frames.Count-1 do
  begin
    if (Frames[i] as TID3v2Frame).FrameType = FT_URLFrame then
        result.Add(Frames[i]);
  end;
end;


function TID3v2Tag.ValidNewCommentFrame(Language: String; Description: WideString): Boolean;
begin
    result := GetDescribedTextFrameIndex(IDv2_Comment, Language, Description) = -1;
end;
function TID3v2Tag.ValidNewLyricFrame(Language: String; Description: WideString): Boolean;
begin
    result := GetDescribedTextFrameIndex(IDv2_Lyrics, Language, Description) = -1;
end;
function TID3v2Tag.ValidNewPictureFrame(Description: WideString): Boolean;
begin
    result := GetPictureFrameIndex(Description) = -1;
end;
function TID3v2Tag.ValidNewUserDefUrlFrame(Description: WideString): Boolean;
begin
    result := GetUserDefinedURLFrameIndex(Description) = -1;
end;
function TID3v2Tag.ValidNewPopularimeterFrame(EMail: String): Boolean;
begin
    result := GetPopularimaterFrameIndex(EMail) = -1;
end;


function TID3v2Tag.GetAllowedTextFrames: TList;
var i: TFrameIDs;
begin
    result := TList.Create;
    for i := IDv2_ARTIST to IDv2_SETSUBTITLE do
      if (GetFrameIDString(i)[1] <> '-') AND (GetFrameIndex(i) = -1)
      then
        result.Add(Pointer(i));
end;

function TID3v2Tag.GetAllowedURLFrames: TList; // die WOAR, etc, NICHT die WXXX
var i: TFrameIDs;
begin
    result := TList.Create;
    for i := IDv2_AUDIOFILEURL to IDv2_PAYMENTURL do
      if (GetFrameIDString(i)[1] <> '-') AND (GetFrameIndex(i) = -1)
      then
        result.Add(Pointer(i));
end;

function TID3v2Tag.AddFrame(aID: TFrameIDs): TID3v2Frame;
begin
    result := TID3v2Frame.Create( GetFrameIDString(aID), TID3v2FrameVersions(Version.Major));
    Frames.Add(result);
end;

procedure TID3v2Tag.DeleteFrame(aFrame: TID3v2Frame);
begin
    Frames.Remove(aFrame);
end;

{$IFDEF USE_DIConverters}
procedure TID3v2Tag.SetCharCode(Value: TCharCode);
var i: Integer;
begin
    fCharCode := Value;
    for i := 0 to Frames.Count - 1 do
        (Frames[i] as TID3v2Frame).CharCode := Value;
end;

procedure TID3v2Tag.SetAcceptAllEncodings(Value: Boolean);
var i: Integer;
begin
    fAcceptAllEncodings := Value;
    for i := 0 to Frames.Count - 1 do
        (Frames[i] as TID3v2Frame).AcceptAllEncodings := Value;
end;
{$ENDIF}


//------------------------------------------------------
//------------------------------------------------------
//          *** mpeg ***
//------------------------------------------------------
//------------------------------------------------------


constructor TMpegInfo.create;
begin
  inherited create;
end;

//------------------------------------------------------
// Liefert die MPEG-Informationen aus einem Stream
//------------------------------------------------------
function TMpegInfo.LoadFromStream(stream: tStream): TMP3Error;
var buffer: TBuffer;
  erfolg: boolean;
  positionInStream: int64;  // position in der Datei/Stream
  max: int64;
  c,bufferpos: integer;
  tmpMpegHeader, tmp2MpegHeader: TMpegHeader;
  tmpXingHeader: tXingHeader;
  // evtl. nur den Header in ein "kleines" Array schreiben
  smallBuffer1, smallBuffer2: TBuffer;
  blocksize: integer;
begin
  // hier erstmal negativ anfangen.
  // Wird ein frame gefunden, dann wird das Ergebnis auf MP3ERR_None gesetzt
  result := MPEGERR_NoFrame;

  Fvalid := False;
  FfirstHeaderPosition := -1;
  blocksize := 512;
  // Gesamtposition im Stream -- gibt am Ende die Position des ersten Mpeg-Headers an.
  positionInStream := Stream.Position-1 ;
  // position im Buffer-Array
  bufferpos := -1 ;

  setlength(buffer, blocksize);
  c := Stream.Read(buffer[0], length(buffer));
  if c<blocksize then Setlength(Buffer, c);
  max := Stream.Size;
  erfolg :=False;

  FFilesize := max;

  while ( (NOT erfolg) AND (positionInStream + 3 < max ) )
  do begin
    inc(bufferpos);
    inc(positionInStream);
    // damit ist sind wir beim ersten durchlauf an Position 0 im BufferArray;

    // beim nächsten Durchlauf der Schleife sind wir evtl. übers Ende des Buffers hinaus
    // Wir lesen ja jeweils im Laufe der Prozedur 4 Byte Daten ein, also pos,pos+1,pos+2,pos+3
    if (bufferpos+3) = (length(buffer)-1) then
    begin
      //stream.Seek(-4, soFromCurrent);
      Stream.Position := PositionInStream;
      c := Stream.Read(buffer[0], length(buffer));
      if c<blocksize then
        Setlength(Buffer, c);
      bufferpos := 0;
    end;

    tmpXingHeader.valid := False;

    // Schritt 1: Test, ob hier ein Mpeg-Header beginnt.
    // ---------------------------------------------------------------------------
    tmpMpegHeader := GetValidatedHeader(Buffer, bufferpos);
    if not tmpMpegHeader.valid then continue;

    // Nächster Schritt 2: Test auf XingHeader
    // ---------------------------------------------------------------------------
    // dazu: evtl. Daten in einen Puffer laden, falls der Frame des
    //       gefundenen Headers nicht mehr komplett im Buffer entahlten ist.
    //      (ich lade ggf. direkt den nächsten Header mit)
    if (bufferpos + tmpMpegHeader.framelength + 3 > length(buffer)-1)  // nächster Header nicht mehr im Buffer
       AND
       (positionInStream + tmpMpegHeader.framelength + 3 < max) // aber noch im Stream
       then
    begin
      // StreamPostition setzen auf den Beginn des aktuellen Headers
      Stream.Position := PositionInStream;
      setlength(smallBuffer1,tmpMpegHeader.framelength + 4);
      // Daten in Buffer lesen
      Stream.Read(smallBuffer1[0],length(smallBuffer1));
      // XingHeader und nächsten MPEG HEader überprüfen
      try
        tmpXingHeader := GetXingHeader(tmpMpegheader, smallbuffer1, 0);        // !!!!!????!!!!!!!!!
        tmp2MpegHeader := GetValidatedHeader(smallBuffer1, tmpMpegHeader.framelength );
      except
        tmp2MpegHeader.valid := false;
      end;
      Stream.Position := PositionInStream;
    end else
    begin
      if (positionInStream + tmpMpegHeader.framelength + 3 > max) then
      begin
        continue;
      end;
      // XingHeader und nächsten MpegHeader aus Buffer lesen
      tmpXingHeader := GetXingHeader(tmpMpegheader, buffer, bufferpos );         // !!!!!!?????!!!!!!!!
      tmp2MpegHeader := GetValidatedHeader(buffer, bufferpos + tmpMpegHeader.framelength);
    end;
    // wenn der neue Header nicht gültig ist: Abbruch
    if not tmp2MpegHeader.valid then continue;

    // 3. Schritt: Einen dritten MpegHeader suchen
    // ---------------------------------------------------------------------------
    // dazu: wieder ggf. nachladen                                          // + 3: Darauf wird zugegriffen!
    if (bufferpos + tmpMpegHeader.framelength + tmp2MpegHeader.framelength + 3 > length(buffer)-1)  // nächster Header nicht mehr im Buffer
       AND
       (positionInStream + tmpMpegHeader.framelength + tmp2MpegHeader.framelength + 3 < max) // aber noch im Stream
    then // nachladen
    begin
      // StreamPostition setzen auf den Beginn des aktuellen Headers                 // !!!!!!!!??????!!!!!!
      Stream.Position := PositionInStream + tmpMpegHeader.framelength + tmp2MpegHeader.framelength;
      setlength(smallBuffer2,4);
      // Daten in Buffer lesen
      Stream.Read(smallBuffer2[0],length(smallBuffer2));
      Stream.Position := PositionInStream;
      if (smallbuffer2[0]<>$FF) OR (smallbuffer2[1]<$E0) then continue;
    end
    else
    begin
      if (positionInStream + tmpMpegHeader.framelength + tmp2MpegHeader.framelength + 3 > max)
      then continue;

      if (buffer[bufferpos + tmpMpegHeader.framelength + tmp2MpegHeader.framelength] <> $FF)
      OR (buffer[bufferpos + tmpMpegHeader.framelength + tmp2MpegHeader.framelength+1] < $E0)
      then continue;
    end;


    // 4. Schritt: Bis hier durchgekommen? - Daten setzen!
    // ---------------------------------------------------------------------------
    Fversion := tmpMpegHeader.version;
    Flayer := tmpMpegHeader.layer;
    Fprotection := tmpMpegHeader.protection;
    Fsamplerate := tmpMpegHeader.samplerate;
    Fchannelmode := tmpMpegHeader.channelmode;
    Fextension := tmpMpegHeader.extension;
    Fcopyright := tmpMpegHeader.copyright;
    Foriginal := tmpMpegHeader.original;
    Femphasis := tmpMpegHeader.emphasis;

    // Hinweis zu dem " - PositionInStream"
    // Was am Anfang des mp3Files nicht als AudioFrame erkannt wurde
    // (z.B. ID3v2Tag), darf nicht in die Längenberechnung eingehen
    // eigentlich müsste man ggf. Auf den ID3v1 Tag abziehen,
    // aber das dürfte nur sehr selten einen Unterschied machen (max. +/- 1 Frame)
    if tmpXingHeader.valid then
      try
        Fbitrate := trunc((tmpMpegheader.samplerate/1000 *
          (max - PositionInStream - tmpXingHeader.Size))  /   (tmpXingHeader.frames*144));
        Fvbr := True;
        Fdauer := ((max-PositionInStream-tmpXingHeader.Size)*8) div ((Fbitrate)*1000);
        FFrames := tmpXingHeader.Frames;
      except
        continue;
      end
    else
      try
        Fframes := trunc((max - PositionInStream)/tmpMpegheader.framelength);
        FBitrate := tmpMpegHeader.bitrate;
        Fvbr := False;
        Fdauer := ((max - PositionInStream)*8) div ((Fbitrate)*1000);
      except
        continue;
      end;

    Fvalid := True;
    FfirstHeaderPosition := PositionInStream;
    result := MP3ERR_None;
    erfolg := True;
  end;
end;

function TMpegInfo.LoadFromFile(filename: string): TMP3Error;
var Stream: TTntFileStream;
begin
  if WideFileExists(Filename) then
    try
      stream := TTntFileStream.Create(filename, fmOpenRead or fmShareDenyWrite);
      try
        result := LoadFromStream(Stream);
      finally
        Stream.Free;
      end;
    except
      result := MP3ERR_FOpenR;
    end
  else
    result := MP3ERR_NoFile;
end;

//------------------------------------------------------
// Überprüft, ob an Postion von aBuffer ein gültiger MpegHeader steht
// und liefert diesen zurück
// Eigenschaft .valid ist dabei entscheidend !!!
//------------------------------------------------------
function TMpegInfo.GetValidatedHeader(aBuffer: TBuffer; position: integer): TMpegheader;
var bitrateindex, versionindex: byte;
    samplerateindex:byte;
begin
  // Ein MpegHeader beginnt mit 11 gesetzen Bytes
  if (abuffer[position]<>$FF) OR (abuffer[position+1]<$E0)
  then
  begin
    result.valid := False;
    exit;
  end;

  //Byte 1 und 2: AAAAAAAA AAABBCCD
  //A=1 (11 Sync bytes) am Anfang
  //B: Version, bei Standard-mp3 (=MPEG1, Layer3) sollte BB=11 sein
  //C: Layer, III ist CC=01
  //D: Protection BIT wenn gesetzt, folgt dem mpeg-header 16bit CRC
  Versionindex := (abuffer[position+1] shr 3) and 3;
  case versionindex of
      0: result.version := 3; //eigentlich ist das Version 2.5 aber wegen dem Array-Index...
      1: result.version := 0; //Reserved
      2: result.version := 2;
      3: result.version := 1;
  end;
  result.Layer := 4-((abuffer[position+1] shr 1) and 3);
  result.protection := (abuffer[position+1] AND 1)=0;

  // --->
  // Dank an terryk aus dem Delphi-Forum
  if (Result.version = 0) or (Result.Layer = 4) then
  begin
    Result.valid := False;
    Exit;
  end;
  // <---

  // Byte 3: EEEEFFGH
  // E: Bitrate-Index
  // F: Samplerate-Index
  // G: Padding Bit
  // H: Private Bit
  bitrateindex := (abuffer[position+2] shr 4) AND $F;
  result.bitrate := MPEG_BIT_RATES[result.version][result.layer][bitrateindex];
  if bitrateindex=$F then
  begin
    result.valid := false; // Bad Value !
    exit;
  end;
  samplerateindex := (abuffer[position+2] shr 2) AND $3;
  result.samplerate := sample_rates[result.version][samplerateindex];
  result.padding := ((abuffer[position+2] shr 1) AND $1) = 1;

  // Byte 4: IIJJKLMM
  // I: Channel mode
  // J: Mode extension (for Joint Stereo)
  // K: copyright
  // L: original
  // M: Emphasis  meistens =0
  result.channelmode := ((abuffer[position+3] shr 6) AND 3);
  result.extension := ((abuffer[position+3] shr 4) AND 3);
  result.copyright := ((abuffer[position+3] shr 3) AND 1)=1;
  result.original := ((abuffer[position+3] shr 2) AND 1)=1;
  result.emphasis := (abuffer[position+3] AND 3);

  // "For Layer II there are some combinations of bitrate and mode which are not allowed."
  if result.layer=2 then
      if ((result.bitrate=32) AND (result.channelmode<>3))
          OR ((result.bitrate=48) AND (result.channelmode<>3))
          OR ((result.bitrate=56) AND (result.channelmode<>3))
          OR ((result.bitrate=80) AND (result.channelmode<>3))
          OR ((result.bitrate=224) AND (result.channelmode=3))
          OR ((result.bitrate=256) AND (result.channelmode=3))
          OR ((result.bitrate=320) AND (result.channelmode=3))
          OR ((result.bitrate=384) AND (result.channelmode=3))
      then begin
        result.valid := false;
        exit;
      end;

  // aus gewonnenen Daten die Framelength des dahinterliegenden Frames bestimmen
  result.framelength := GetFramelength(result.version, result.layer,
                              result.bitrate,
                              result.Samplerate,
                              result.padding);
  if result.framelength<=0 then
  begin
    result.valid := false;
    exit;
  end;
  // Erfolg!!
  result.valid := True;
end;

//------------------------------------------------------
// Überprüft, ob an Postion von aBuffer ein gültiger XingHeader steht
// und liefert diesen zurück
// Eigenschaft .valid ist dabei entscheidend !!!
//------------------------------------------------------
function TMpegInfo.GetXingHeader(aMpegheader: TMpegHeader; aBuffer: TBuffer; position: integer ): TXingHeader;
var Xing_offset: integer;
  Xing_Flags: byte;
begin
  if aMpegheader.version=1 then
    if aMpegheader.channelmode<>3 then
      xing_offset := 32+4
    else
      xing_offset := 17+4
  else
    if aMpegheader.channelmode<>3 then
      xing_offset := 17+4
    else
      xing_offset := 9+4;

  // --->
  // Dank an terryk aus dem Delphi-Forum
  if Length(abuffer) <= (position + xing_offset + 11) then
  begin
    Result.valid := False;
    Exit;
  end;
  // <---

  if (abuffer[position+xing_offset]=$58)        {'Xing'}
     AND (abuffer[position+xing_offset+1]=$69)
     AND (abuffer[position+xing_offset+2]=$6E)
     AND (abuffer[position+xing_offset+3]=$67)
     then // Xing Tag vorhanden
  begin
          // Die nächsten 4 Bytes sind die "Flags", wobei eigentlich nur das 4te interessant ist
          Xing_flags := abuffer[position+xing_offset+7];
          if (Xing_flags AND 1)=1 then
          begin //Anzahl der frames in den nächsten 4 Bytes gespeichert
              result.frames := 16777216 * abuffer[position+xing_offset+8]
                  + 65536 * abuffer[position+xing_offset+9]
                  + 256 * abuffer[position+xing_offset+10]
                  + abuffer[position+xing_offset+11];
          end
          else
            result.frames := 0;
          // Warnung: evtl. liegt hier eine Fehlerquelle:
          //      Wenn der Xing header so fehlerhaft ist,
          //      werden weitrere Berechnungen aufgrund des ersten vbr-Frames erstellt!
          result.Size := aMpegHeader.framelength;
          result.valid := True;
  end else
    result.valid := False;
end;

function TMpegInfo.GetFramelength(version:byte;layer:byte;bitrate:longint;Samplerate:longint;padding:boolean):integer;
begin
  if samplerate=0 then result := -2
  else
    if Layer=1 then
      result := trunc(12*bitrate*1000 / samplerate+Integer(padding)*4)
    else
      if Version = 1 then
        result :=  144 * bitrate * 1000 DIV samplerate + integer(padding)
      else
        result := 72 * bitrate * 1000 DIV samplerate + integer(padding)

end;

//
//
//
//
//
//
//
//

initialization

  Genres := TStringList.Create;
  Genres.CaseSensitive := False;
  // Standard-Genres (ID3v1 Standard)
  Genres.Add('Blues');
  Genres.Add('Classic Rock');
  Genres.Add('Country');
  Genres.Add('Dance');
  Genres.Add('Disco');
  Genres.Add('Funk');
  Genres.Add('Grunge');
  Genres.Add('Hip-Hop');
  Genres.Add('Jazz');
  Genres.Add('Metal');
  Genres.Add('New Age');
  Genres.Add('Oldies');
  Genres.Add('Other');
  Genres.Add('Pop');
  Genres.Add('R&B');
  Genres.Add('Rap');
  Genres.Add('Reggae');
  Genres.Add('Rock');
  Genres.Add('Techno');
  Genres.Add('Industrial');
  Genres.Add('Alternative');
  Genres.Add('Ska');
  Genres.Add('Death Metal');
  Genres.Add('Pranks');
  Genres.Add('Soundtrack');
  Genres.Add('Euro-Techno');
  Genres.Add('Ambient');
  Genres.Add('Trip-Hop');
  Genres.Add('Vocal');
  Genres.Add('Jazz+Funk');
  Genres.Add('Fusion');
  Genres.Add('Trance');
  Genres.Add('Classical');
  Genres.Add('Instrumental');
  Genres.Add('Acid');
  Genres.Add('House');
  Genres.Add('Game');
  Genres.Add('Sound Clip');
  Genres.Add('Gospel');
  Genres.Add('Noise');
  Genres.Add('AlternRock');
  Genres.Add('Bass');
  Genres.Add('Soul');
  Genres.Add('Punk');
  Genres.Add('Space');
  Genres.Add('Meditative');
  Genres.Add('Instrumental Pop');
  Genres.Add('Instrumental Rock');
  Genres.Add('Ethnic');
  Genres.Add('Gothic');
  Genres.Add('Darkwave');
  Genres.Add('Techno-Industrial');
  Genres.Add('Electronic');
  Genres.Add('Pop-Folk');
  Genres.Add('Eurodance');
  Genres.Add('Dream');
  Genres.Add('Southern Rock');
  Genres.Add('Comedy');
  Genres.Add('Cult');
  Genres.Add('Gangsta');
  Genres.Add('Top 40');
  Genres.Add('Christian Rap');
  Genres.Add('Pop/Funk');
  Genres.Add('Jungle');
  Genres.Add('Native American');
  Genres.Add('Cabaret');
  Genres.Add('New Wave');
  Genres.Add('Psychadelic');
  Genres.Add('Rave');
  Genres.Add('Showtunes');
  Genres.Add('Trailer');
  Genres.Add('Lo-Fi');
  Genres.Add('Tribal');
  Genres.Add('Acid Punk');
  Genres.Add('Acid Jazz');
  Genres.Add('Polka');
  Genres.Add('Retro');
  Genres.Add('Musical');
  Genres.Add('Rock & Roll');
  Genres.Add('Hard Rock');

  // WinAmp-genres
  Genres.Add('Folk');
  Genres.Add('Folk-Rock');
  Genres.Add('National Folk');
  Genres.Add('Swing');
  Genres.Add('Fast Fusion');
  Genres.Add('Bebob');
  Genres.Add('Latin');
  Genres.Add('Revival');
  Genres.Add('Celtic');
  Genres.Add('Bluegrass');
  Genres.Add('Avantgarde');
  Genres.Add('Gothic Rock');
  Genres.Add('Progessive Rock');
  Genres.Add('Psychedelic Rock');
  Genres.Add('Symphonic Rock');
  Genres.Add('Slow Rock');
  Genres.Add('Big Band');
  Genres.Add('Chorus');
  Genres.Add('Easy Listening');
  Genres.Add('Acoustic');
  Genres.Add('Humour');
  Genres.Add('Speech');
  Genres.Add('Chanson');
  Genres.Add('Opera');
  Genres.Add('Chamber Music');
  Genres.Add('Sonata');
  Genres.Add('Symphony');
  Genres.Add('Booty Bass');
  Genres.Add('Primus');
  Genres.Add('Porn Groove');
  Genres.Add('Satire');
  Genres.Add('Slow Jam');
  Genres.Add('Club');
  Genres.Add('Tango');
  Genres.Add('Samba');
  Genres.Add('Folklore');
  Genres.Add('Ballad');
  Genres.Add('Power Ballad');
  Genres.Add('Rhythmic Soul');
  Genres.Add('Freestyle');
  Genres.Add('Duet');
  Genres.Add('Punk Rock');
  Genres.Add('Drum Solo');
  Genres.Add('A capella');
  Genres.Add('Euro-House');
  Genres.Add('Dance Hall');

  // Quelle für die Sprachcodes und Namen:
  // http://www.id3.org/iso639-2.html
  LanguageCodes := TStringList.Create;
  LanguageNames := TStringList.Create;
  LanguageCodes.CaseSensitive := False;
  LanguageNames.CaseSensitive := False;
  LanguageCodes.Add('aar');  LanguageNames.Add('Afar');
  LanguageCodes.Add('abk');  LanguageNames.Add('Abkhazian');
  LanguageCodes.Add('ace');  LanguageNames.Add('Achinese');
  LanguageCodes.Add('ach');  LanguageNames.Add('Acoli');
  LanguageCodes.Add('ada');  LanguageNames.Add('Adangme');
  LanguageCodes.Add('afa');  LanguageNames.Add('Afro-Asiatic (Other)');
  LanguageCodes.Add('afh');  LanguageNames.Add('Afrihili');
  LanguageCodes.Add('afr');  LanguageNames.Add('Afrikaans');
  LanguageCodes.Add('aka');  LanguageNames.Add('Akan');
  LanguageCodes.Add('akk');  LanguageNames.Add('Akkadian');
  LanguageCodes.Add('alb');  LanguageNames.Add('Albanian');
  LanguageCodes.Add('ale');  LanguageNames.Add('Aleut');
  LanguageCodes.Add('alg');  LanguageNames.Add('Algonquian Languages');
  LanguageCodes.Add('amh');  LanguageNames.Add('Amharic');
  LanguageCodes.Add('ang');  LanguageNames.Add('English, Old (ca. 450-1100)');
  LanguageCodes.Add('apa');  LanguageNames.Add('Apache Languages');
  LanguageCodes.Add('ara');  LanguageNames.Add('Arabic');
  LanguageCodes.Add('arc');  LanguageNames.Add('Aramaic');
  LanguageCodes.Add('arm');  LanguageNames.Add('Armenian');
  LanguageCodes.Add('arn');  LanguageNames.Add('Araucanian');
  LanguageCodes.Add('arp');  LanguageNames.Add('Arapaho');
  LanguageCodes.Add('art');  LanguageNames.Add('Artificial (Other)');
  LanguageCodes.Add('arw');  LanguageNames.Add('Arawak');
  LanguageCodes.Add('asm');  LanguageNames.Add('Assamese');
  LanguageCodes.Add('ath');  LanguageNames.Add('Athapascan Languages');
  LanguageCodes.Add('ava');  LanguageNames.Add('Avaric');
  LanguageCodes.Add('ave');  LanguageNames.Add('Avestan');
  LanguageCodes.Add('awa');  LanguageNames.Add('Awadhi');
  LanguageCodes.Add('aym');  LanguageNames.Add('Aymara');
  LanguageCodes.Add('aze');  LanguageNames.Add('Azerbaijani');
  LanguageCodes.Add('bad');  LanguageNames.Add('Banda');
  LanguageCodes.Add('bai');  LanguageNames.Add('Bamileke Languages');
  LanguageCodes.Add('bak');  LanguageNames.Add('Bashkir');
  LanguageCodes.Add('bal');  LanguageNames.Add('Baluchi');
  LanguageCodes.Add('bam');  LanguageNames.Add('Bambara');
  LanguageCodes.Add('ban');  LanguageNames.Add('Balinese');
  LanguageCodes.Add('baq');  LanguageNames.Add('Basque');
  LanguageCodes.Add('bas');  LanguageNames.Add('Basa');
  LanguageCodes.Add('bat');  LanguageNames.Add('Baltic (Other)');
  LanguageCodes.Add('bej');  LanguageNames.Add('Beja');
  LanguageCodes.Add('bel');  LanguageNames.Add('Byelorussian');
  LanguageCodes.Add('bem');  LanguageNames.Add('Bemba');
  LanguageCodes.Add('ben');  LanguageNames.Add('Bengali');
  LanguageCodes.Add('ber');  LanguageNames.Add('Berber (Other)');
  LanguageCodes.Add('bho');  LanguageNames.Add('Bhojpuri');
  LanguageCodes.Add('bih');  LanguageNames.Add('Bihari');
  LanguageCodes.Add('bik');  LanguageNames.Add('Bikol');
  LanguageCodes.Add('bin');  LanguageNames.Add('Bini');
  LanguageCodes.Add('bis');  LanguageNames.Add('Bislama');
  LanguageCodes.Add('bla');  LanguageNames.Add('Siksika');
  LanguageCodes.Add('bnt');  LanguageNames.Add('Bantu (Other)');
  LanguageCodes.Add('bod');  LanguageNames.Add('Tibetan');
  LanguageCodes.Add('bra');  LanguageNames.Add('Braj');
  LanguageCodes.Add('bre');  LanguageNames.Add('Breton');
  LanguageCodes.Add('bua');  LanguageNames.Add('Buriat');
  LanguageCodes.Add('bug');  LanguageNames.Add('Buginese');
  LanguageCodes.Add('bul');  LanguageNames.Add('Bulgarian	');
  LanguageCodes.Add('bur');  LanguageNames.Add('Burmese	');
  LanguageCodes.Add('cad');  LanguageNames.Add('Caddo');
  LanguageCodes.Add('cai');  LanguageNames.Add('Central American Indian (Other)');
  LanguageCodes.Add('car');  LanguageNames.Add('Carib');
  LanguageCodes.Add('cat');  LanguageNames.Add('Catalan	');
  LanguageCodes.Add('cau');  LanguageNames.Add('Caucasian (Other)');
  LanguageCodes.Add('ceb');  LanguageNames.Add('Cebuano');
  LanguageCodes.Add('cel');  LanguageNames.Add('Celtic (Other)');
  LanguageCodes.Add('ces');  LanguageNames.Add('Czech');
  LanguageCodes.Add('cha');  LanguageNames.Add('Chamorro');
  LanguageCodes.Add('chb');  LanguageNames.Add('Chibcha	');
  LanguageCodes.Add('che');  LanguageNames.Add('Chechen');
  LanguageCodes.Add('chg');  LanguageNames.Add('Chagatai');
  LanguageCodes.Add('chi');  LanguageNames.Add('Chinese');
  LanguageCodes.Add('chm');  LanguageNames.Add('Mari');
  LanguageCodes.Add('chn');  LanguageNames.Add('Chinook jargon');
  LanguageCodes.Add('cho');  LanguageNames.Add('Choctaw');
  LanguageCodes.Add('chr');  LanguageNames.Add('Cherokee');
  LanguageCodes.Add('chu');  LanguageNames.Add('Church Slavic');
  LanguageCodes.Add('chv');  LanguageNames.Add('Chuvash');
  LanguageCodes.Add('chy');  LanguageNames.Add('Cheyenne');
  LanguageCodes.Add('cop');  LanguageNames.Add('Coptic');
  LanguageCodes.Add('cor');  LanguageNames.Add('Cornish');
  LanguageCodes.Add('cos');  LanguageNames.Add('Corsican');
  LanguageCodes.Add('cpe');  LanguageNames.Add('Creoles and Pidgins, English-based (Other)');
  LanguageCodes.Add('cpf');  LanguageNames.Add('Creoles and Pidgins, French-based (Other)');
  LanguageCodes.Add('cpp');  LanguageNames.Add('Creoles and Pidgins, Portuguese-based (Other)');
  LanguageCodes.Add('cre');  LanguageNames.Add('Cree');
  LanguageCodes.Add('crp');  LanguageNames.Add('Creoles and Pidgins (Other)	');
  LanguageCodes.Add('cus');  LanguageNames.Add('Cushitic (Other)');
  LanguageCodes.Add('cym');  LanguageNames.Add('Welsh	');
  LanguageCodes.Add('cze');  LanguageNames.Add('Czech');
  LanguageCodes.Add('dak');  LanguageNames.Add('Dakota');
  LanguageCodes.Add('dan');  LanguageNames.Add('Danish');
  LanguageCodes.Add('del');  LanguageNames.Add('Delaware');
  LanguageCodes.Add('deu');  LanguageNames.Add('German');
  LanguageCodes.Add('din');  LanguageNames.Add('Dinka	');
  LanguageCodes.Add('div');  LanguageNames.Add('Divehi');
  LanguageCodes.Add('doi');  LanguageNames.Add('Dogri	');
  LanguageCodes.Add('dra');  LanguageNames.Add('Dravidian (Other)');
  LanguageCodes.Add('dua');  LanguageNames.Add('Duala');
  LanguageCodes.Add('dum');  LanguageNames.Add('Dutch, Middle (ca. 1050-1350)');
  LanguageCodes.Add('dut');  LanguageNames.Add('Dutch	');
  LanguageCodes.Add('dyu');  LanguageNames.Add('Dyula');
  LanguageCodes.Add('dzo');  LanguageNames.Add('Dzongkha');
  LanguageCodes.Add('efi');  LanguageNames.Add('Efik');
  LanguageCodes.Add('egy');  LanguageNames.Add('Egyptian (Ancient)');
  LanguageCodes.Add('eka');  LanguageNames.Add('Ekajuk');
  LanguageCodes.Add('ell');  LanguageNames.Add('Greek, Modern (1453-)');
  LanguageCodes.Add('elx');  LanguageNames.Add('Elamite');
  LanguageCodes.Add('eng');  LanguageNames.Add('English');
  LanguageCodes.Add('enm');  LanguageNames.Add('English, Middle (ca. 1100-1500)');
  LanguageCodes.Add('epo');  LanguageNames.Add('Esperanto	');
  LanguageCodes.Add('esk');  LanguageNames.Add('Eskimo (Other)');
  LanguageCodes.Add('esl');  LanguageNames.Add('Spanish');
  LanguageCodes.Add('est');  LanguageNames.Add('Estonian');
  LanguageCodes.Add('eus');  LanguageNames.Add('Basque');
  LanguageCodes.Add('ewe');  LanguageNames.Add('Ewe');
  LanguageCodes.Add('ewo');  LanguageNames.Add('Ewondo');
  LanguageCodes.Add('fan');  LanguageNames.Add('Fang');
  LanguageCodes.Add('fao');  LanguageNames.Add('Faroese');
  LanguageCodes.Add('fas');  LanguageNames.Add('Persian');
  LanguageCodes.Add('fat');  LanguageNames.Add('Fanti');
  LanguageCodes.Add('fij');  LanguageNames.Add('Fijian');
  LanguageCodes.Add('fin');  LanguageNames.Add('Finnish');
  LanguageCodes.Add('fiu');  LanguageNames.Add('Finno-Ugrian (Other)');
  LanguageCodes.Add('fon');  LanguageNames.Add('Fon');
  LanguageCodes.Add('fra');  LanguageNames.Add('French');
  LanguageCodes.Add('fre');  LanguageNames.Add('French');
  LanguageCodes.Add('frm');  LanguageNames.Add('French, Middle (ca. 1400-1600)');
  LanguageCodes.Add('fro');  LanguageNames.Add('French, Old (842- ca. 1400)');
  LanguageCodes.Add('fry');  LanguageNames.Add('Frisian');
  LanguageCodes.Add('ful');  LanguageNames.Add('Fulah');
  LanguageCodes.Add('gaa');  LanguageNames.Add('Ga');
  LanguageCodes.Add('gae');  LanguageNames.Add('Gaelic (Scots)');
  LanguageCodes.Add('gai');  LanguageNames.Add('Irish');
  LanguageCodes.Add('gay');  LanguageNames.Add('Gayo');
  LanguageCodes.Add('gdh');  LanguageNames.Add('Gaelic (Scots)');
  LanguageCodes.Add('gem');  LanguageNames.Add('Germanic (Other)');
  LanguageCodes.Add('geo');  LanguageNames.Add('Georgian');
  LanguageCodes.Add('ger');  LanguageNames.Add('German');
  LanguageCodes.Add('gez');  LanguageNames.Add('Geez');
  LanguageCodes.Add('gil');  LanguageNames.Add('Gilbertese');
  LanguageCodes.Add('glg');  LanguageNames.Add('Gallegan');
  LanguageCodes.Add('gmh');  LanguageNames.Add('German, Middle High (ca. 1050-1500)');
  LanguageCodes.Add('goh');  LanguageNames.Add('German, Old High (ca. 750-1050)');
  LanguageCodes.Add('gon');  LanguageNames.Add('Gondi');
  LanguageCodes.Add('got');  LanguageNames.Add('Gothic');
  LanguageCodes.Add('grb');  LanguageNames.Add('Grebo');
  LanguageCodes.Add('grc');  LanguageNames.Add('Greek, Ancient (to 1453)');
  LanguageCodes.Add('gre');  LanguageNames.Add('Greek, Modern (1453-)');
  LanguageCodes.Add('grn');  LanguageNames.Add('Guarani');
  LanguageCodes.Add('guj');  LanguageNames.Add('Gujarati');
  LanguageCodes.Add('hai');  LanguageNames.Add('Haida');
  LanguageCodes.Add('hau');  LanguageNames.Add('Hausa');
  LanguageCodes.Add('haw');  LanguageNames.Add('Hawaiian');
  LanguageCodes.Add('heb');  LanguageNames.Add('Hebrew');
  LanguageCodes.Add('her');  LanguageNames.Add('Herero');
  LanguageCodes.Add('hil');  LanguageNames.Add('Hiligaynon');
  LanguageCodes.Add('him');  LanguageNames.Add('Himachali');
  LanguageCodes.Add('hin');  LanguageNames.Add('Hindi');
  LanguageCodes.Add('hmo');  LanguageNames.Add('Hiri Motu');
  LanguageCodes.Add('hun');  LanguageNames.Add('Hungarian');
  LanguageCodes.Add('hup');  LanguageNames.Add('Hupa');
  LanguageCodes.Add('hye');  LanguageNames.Add('Armenian');
  LanguageCodes.Add('iba');  LanguageNames.Add('Iban');
  LanguageCodes.Add('ibo');  LanguageNames.Add('Igbo');
  LanguageCodes.Add('ice');  LanguageNames.Add('Icelandic');
  LanguageCodes.Add('ijo');  LanguageNames.Add('Ijo');
  LanguageCodes.Add('iku');  LanguageNames.Add('Inuktitut');
  LanguageCodes.Add('ilo');  LanguageNames.Add('Iloko');
  LanguageCodes.Add('ina');  LanguageNames.Add('Interlingua (International Auxiliary language Association)');
  LanguageCodes.Add('inc');  LanguageNames.Add('Indic (Other)');
  LanguageCodes.Add('ind');  LanguageNames.Add('Indonesian');
  LanguageCodes.Add('ine');  LanguageNames.Add('Indo-European (Other)');
  LanguageCodes.Add('ine');  LanguageNames.Add('Interlingue');
  LanguageCodes.Add('ipk');  LanguageNames.Add('Inupiak');
  LanguageCodes.Add('ira');  LanguageNames.Add('Iranian (Other)');
  LanguageCodes.Add('iri');  LanguageNames.Add('Irish');
  LanguageCodes.Add('iro');  LanguageNames.Add('Iroquoian uages');
  LanguageCodes.Add('isl');  LanguageNames.Add('Icelandic');
  LanguageCodes.Add('ita');  LanguageNames.Add('Italian');
  LanguageCodes.Add('jav');  LanguageNames.Add('Javanese');
  LanguageCodes.Add('jaw');  LanguageNames.Add('Javanese');
  LanguageCodes.Add('jpn');  LanguageNames.Add('Japanese');
  LanguageCodes.Add('jpr');  LanguageNames.Add('Judeo-Persian');
  LanguageCodes.Add('jrb');  LanguageNames.Add('Judeo-Arabic');
  LanguageCodes.Add('kaa');  LanguageNames.Add('Kara-Kalpak');
  LanguageCodes.Add('kab');  LanguageNames.Add('Kabyle');
  LanguageCodes.Add('kac');  LanguageNames.Add('Kachin');
  LanguageCodes.Add('kal');  LanguageNames.Add('Greenlandic');
  LanguageCodes.Add('kam');  LanguageNames.Add('Kamba');
  LanguageCodes.Add('kan');  LanguageNames.Add('Kannada');
  LanguageCodes.Add('kar');  LanguageNames.Add('Karen');
  LanguageCodes.Add('kas');  LanguageNames.Add('Kashmiri	');
  LanguageCodes.Add('kat');  LanguageNames.Add('Georgian');
  LanguageCodes.Add('kau');  LanguageNames.Add('Kanuri');
  LanguageCodes.Add('kaw');  LanguageNames.Add('Kawi');
  LanguageCodes.Add('kaz');  LanguageNames.Add('Kazakh');
  LanguageCodes.Add('kha');  LanguageNames.Add('Khasi');
  LanguageCodes.Add('khi');  LanguageNames.Add('Khoisan (Other)');
  LanguageCodes.Add('khm');  LanguageNames.Add('Khmer');
  LanguageCodes.Add('kho');  LanguageNames.Add('Khotanese');
  LanguageCodes.Add('kik');  LanguageNames.Add('Kikuyu');
  LanguageCodes.Add('kin');  LanguageNames.Add('Kinyarwanda');
  LanguageCodes.Add('kir');  LanguageNames.Add('Kirghiz');
  LanguageCodes.Add('kok');  LanguageNames.Add('Konkani');
  LanguageCodes.Add('kom');  LanguageNames.Add('Komi');
  LanguageCodes.Add('kon');  LanguageNames.Add('Kongo');
  LanguageCodes.Add('kor');  LanguageNames.Add('Korean');
  LanguageCodes.Add('kpe');  LanguageNames.Add('Kpelle');
  LanguageCodes.Add('kro');  LanguageNames.Add('Kru');
  LanguageCodes.Add('kru');  LanguageNames.Add('Kurukh');
  LanguageCodes.Add('kua');  LanguageNames.Add('Kuanyama');
  LanguageCodes.Add('kum');  LanguageNames.Add('Kumyk');
  LanguageCodes.Add('kur');  LanguageNames.Add('Kurdish');
  LanguageCodes.Add('kus');  LanguageNames.Add('Kusaie');
  LanguageCodes.Add('kut');  LanguageNames.Add('Kutenai');
  LanguageCodes.Add('lad');  LanguageNames.Add('Ladino');
  LanguageCodes.Add('lah');  LanguageNames.Add('Lahnda');
  LanguageCodes.Add('lam');  LanguageNames.Add('Lamba');
  LanguageCodes.Add('lao');  LanguageNames.Add('Lao');
  LanguageCodes.Add('lat');  LanguageNames.Add('Latin');
  LanguageCodes.Add('lav');  LanguageNames.Add('Latvian');
  LanguageCodes.Add('lez');  LanguageNames.Add('Lezghian');
  LanguageCodes.Add('lin');  LanguageNames.Add('Lingala');
  LanguageCodes.Add('lit');  LanguageNames.Add('Lithuanian');
  LanguageCodes.Add('lol');  LanguageNames.Add('Mongo');
  LanguageCodes.Add('loz');  LanguageNames.Add('Lozi');
  LanguageCodes.Add('ltz');  LanguageNames.Add('Letzeburgesch');
  LanguageCodes.Add('lub');  LanguageNames.Add('Luba-Katanga');
  LanguageCodes.Add('lug');  LanguageNames.Add('Ganda');
  LanguageCodes.Add('lui');  LanguageNames.Add('Luiseno');
  LanguageCodes.Add('lun');  LanguageNames.Add('Lunda');
  LanguageCodes.Add('luo');  LanguageNames.Add('Luo (Kenya and Tanzania)');
  LanguageCodes.Add('mac');  LanguageNames.Add('Macedonian');
  LanguageCodes.Add('mad');  LanguageNames.Add('Madurese');
  LanguageCodes.Add('mag');  LanguageNames.Add('Magahi');
  LanguageCodes.Add('mah');  LanguageNames.Add('Marshall');
  LanguageCodes.Add('mai');  LanguageNames.Add('Maithili');
  LanguageCodes.Add('mak');  LanguageNames.Add('Macedonian');
  LanguageCodes.Add('mak');  LanguageNames.Add('Makasar');
  LanguageCodes.Add('mal');  LanguageNames.Add('Malayalam	');
  LanguageCodes.Add('man');  LanguageNames.Add('Mandingo');
  LanguageCodes.Add('mao');  LanguageNames.Add('Maori');
  LanguageCodes.Add('map');  LanguageNames.Add('Austronesian (Other)');
  LanguageCodes.Add('mar');  LanguageNames.Add('Marathi');
  LanguageCodes.Add('mas');  LanguageNames.Add('Masai');
  LanguageCodes.Add('max');  LanguageNames.Add('Manx');
  LanguageCodes.Add('may');  LanguageNames.Add('Malay');
  LanguageCodes.Add('men');  LanguageNames.Add('Mende');
  LanguageCodes.Add('mga');  LanguageNames.Add('Irish, Middle (900 - 1200)');
  LanguageCodes.Add('mic');  LanguageNames.Add('Micmac');
  LanguageCodes.Add('min');  LanguageNames.Add('Minangkabau');
  LanguageCodes.Add('mis');  LanguageNames.Add('Miscellaneous (Other)');
  LanguageCodes.Add('mkh');  LanguageNames.Add('Mon-Kmer (Other)');
  LanguageCodes.Add('mlg');  LanguageNames.Add('Malagasy');
  LanguageCodes.Add('mlt');  LanguageNames.Add('Maltese');
  LanguageCodes.Add('mni');  LanguageNames.Add('Manipuri');
  LanguageCodes.Add('mno');  LanguageNames.Add('Manobo Languages');
  LanguageCodes.Add('moh');  LanguageNames.Add('Mohawk');
  LanguageCodes.Add('mol');  LanguageNames.Add('Moldavian');
  LanguageCodes.Add('mon');  LanguageNames.Add('Mongolian');
  LanguageCodes.Add('mos');  LanguageNames.Add('Mossi');
  LanguageCodes.Add('mri');  LanguageNames.Add('Maori');
  LanguageCodes.Add('msa');  LanguageNames.Add('Malay');
  LanguageCodes.Add('mul');  LanguageNames.Add('Multiple Languages');
  LanguageCodes.Add('mun');  LanguageNames.Add('Munda Languages');
  LanguageCodes.Add('mus');  LanguageNames.Add('Creek');
  LanguageCodes.Add('mwr');  LanguageNames.Add('Marwari');
  LanguageCodes.Add('mya');  LanguageNames.Add('Burmese');
  LanguageCodes.Add('myn');  LanguageNames.Add('Mayan Languages');
  LanguageCodes.Add('nah');  LanguageNames.Add('Aztec');
  LanguageCodes.Add('nai');  LanguageNames.Add('North American Indian (Other)');
  LanguageCodes.Add('nau');  LanguageNames.Add('Nauru');
  LanguageCodes.Add('nav');  LanguageNames.Add('Navajo');
  LanguageCodes.Add('nbl');  LanguageNames.Add('Ndebele, South');
  LanguageCodes.Add('nde');  LanguageNames.Add('Ndebele, North');
  LanguageCodes.Add('ndo');  LanguageNames.Add('Ndongo');
  LanguageCodes.Add('nep');  LanguageNames.Add('Nepali');
  LanguageCodes.Add('new');  LanguageNames.Add('Newari');
  LanguageCodes.Add('nic');  LanguageNames.Add('Niger-Kordofanian (Other)');
  LanguageCodes.Add('niu');  LanguageNames.Add('Niuean');
  LanguageCodes.Add('nla');  LanguageNames.Add('Dutch');
  LanguageCodes.Add('nno');  LanguageNames.Add('Norwegian (Nynorsk)');
  LanguageCodes.Add('non');  LanguageNames.Add('Norse, Old');
  LanguageCodes.Add('nor');  LanguageNames.Add('Norwegian');
  LanguageCodes.Add('nso');  LanguageNames.Add('Sotho, Northern');
  LanguageCodes.Add('nub');  LanguageNames.Add('Nubian Languages');
  LanguageCodes.Add('nya');  LanguageNames.Add('Nyanja');
  LanguageCodes.Add('nym');  LanguageNames.Add('Nyamwezi');
  LanguageCodes.Add('nyn');  LanguageNames.Add('Nyankole');
  LanguageCodes.Add('nyo');  LanguageNames.Add('Nyoro	');
  LanguageCodes.Add('nzi');  LanguageNames.Add('Nzima');
  LanguageCodes.Add('oci');  LanguageNames.Add('Langue d''Oc (post 1500)');
  LanguageCodes.Add('oji');  LanguageNames.Add('Ojibwa');
  LanguageCodes.Add('ori');  LanguageNames.Add('Oriya');
  LanguageCodes.Add('orm');  LanguageNames.Add('Oromo');
  LanguageCodes.Add('osa');  LanguageNames.Add('Osage');
  LanguageCodes.Add('oss');  LanguageNames.Add('Ossetic');
  LanguageCodes.Add('ota');  LanguageNames.Add('Turkish, Ottoman (1500 - 1928)');
  LanguageCodes.Add('oto');  LanguageNames.Add('Otomian Languages');
  LanguageCodes.Add('paa');  LanguageNames.Add('Papuan-Australian (Other)');
  LanguageCodes.Add('pag');  LanguageNames.Add('Pangasinan');
  LanguageCodes.Add('pal');  LanguageNames.Add('Pahlavi');
  LanguageCodes.Add('pam');  LanguageNames.Add('Pampanga');
  LanguageCodes.Add('pan');  LanguageNames.Add('Panjabi');
  LanguageCodes.Add('pap');  LanguageNames.Add('Papiamento');
  LanguageCodes.Add('pau');  LanguageNames.Add('Palauan');
  LanguageCodes.Add('peo');  LanguageNames.Add('Persian, Old (ca 600 - 400 B.C.)');
  LanguageCodes.Add('per');  LanguageNames.Add('Persian');
  LanguageCodes.Add('phn');  LanguageNames.Add('Phoenician');
  LanguageCodes.Add('pli');  LanguageNames.Add('Pali');
  LanguageCodes.Add('pol');  LanguageNames.Add('Polish');
  LanguageCodes.Add('pon');  LanguageNames.Add('Ponape');
  LanguageCodes.Add('por');  LanguageNames.Add('Portuguese');
  LanguageCodes.Add('pra');  LanguageNames.Add('Prakrit uages');
  LanguageCodes.Add('pro');  LanguageNames.Add('Provencal, Old (to 1500)');
  LanguageCodes.Add('pus');  LanguageNames.Add('Pushto');
  LanguageCodes.Add('que');  LanguageNames.Add('Quechua');
  LanguageCodes.Add('raj');  LanguageNames.Add('Rajasthani');
  LanguageCodes.Add('rar');  LanguageNames.Add('Rarotongan');
  LanguageCodes.Add('roa');  LanguageNames.Add('Romance (Other)');
  LanguageCodes.Add('roh');  LanguageNames.Add('Rhaeto-Romance');
  LanguageCodes.Add('rom');  LanguageNames.Add('Romany');
  LanguageCodes.Add('ron');  LanguageNames.Add('Romanian');
  LanguageCodes.Add('rum');  LanguageNames.Add('Romanian');
  LanguageCodes.Add('run');  LanguageNames.Add('Rundi');
  LanguageCodes.Add('rus');  LanguageNames.Add('Russian');
  LanguageCodes.Add('sad');  LanguageNames.Add('Sandawe');
  LanguageCodes.Add('sag');  LanguageNames.Add('Sango');
  LanguageCodes.Add('sah');  LanguageNames.Add('Yakut');
  LanguageCodes.Add('sai');  LanguageNames.Add('South American Indian (Other)');
  LanguageCodes.Add('sal');  LanguageNames.Add('Salishan Languages');
  LanguageCodes.Add('sam');  LanguageNames.Add('Samaritan Aramaic');
  LanguageCodes.Add('san');  LanguageNames.Add('Sanskrit');
  LanguageCodes.Add('sco');  LanguageNames.Add('Scots');
  LanguageCodes.Add('scr');  LanguageNames.Add('Serbo-Croatian');
  LanguageCodes.Add('sel');  LanguageNames.Add('Selkup');
  LanguageCodes.Add('sem');  LanguageNames.Add('Semitic (Other)');
  LanguageCodes.Add('sga');  LanguageNames.Add('Irish, Old (to 900)');
  LanguageCodes.Add('shn');  LanguageNames.Add('Shan');
  LanguageCodes.Add('sid');  LanguageNames.Add('Sidamo');
  LanguageCodes.Add('sin');  LanguageNames.Add('Singhalese');
  LanguageCodes.Add('sio');  LanguageNames.Add('Siouan Languages');
  LanguageCodes.Add('sit');  LanguageNames.Add('Sino-Tibetan (Other)');
  LanguageCodes.Add('sla');  LanguageNames.Add('Slavic (Other)');
  LanguageCodes.Add('slk');  LanguageNames.Add('Slovak');
  LanguageCodes.Add('slo');  LanguageNames.Add('Slovak');
  LanguageCodes.Add('slv');  LanguageNames.Add('Slovenian');
  LanguageCodes.Add('smi');  LanguageNames.Add('Sami Languages');
  LanguageCodes.Add('smo');  LanguageNames.Add('Samoan');
  LanguageCodes.Add('sna');  LanguageNames.Add('Shona');
  LanguageCodes.Add('snd');  LanguageNames.Add('Sindhi');
  LanguageCodes.Add('sog');  LanguageNames.Add('Sogdian');
  LanguageCodes.Add('som');  LanguageNames.Add('Somali');
  LanguageCodes.Add('son');  LanguageNames.Add('Songhai');
  LanguageCodes.Add('sot');  LanguageNames.Add('Sotho, Southern');
  LanguageCodes.Add('spa');  LanguageNames.Add('Spanish');
  LanguageCodes.Add('sqi');  LanguageNames.Add('Albanian');
  LanguageCodes.Add('srd');  LanguageNames.Add('Sardinian	');
  LanguageCodes.Add('srr');  LanguageNames.Add('Serer');
  LanguageCodes.Add('ssa');  LanguageNames.Add('Nilo-Saharan (Other)');
  LanguageCodes.Add('ssw');  LanguageNames.Add('Siswant');
  LanguageCodes.Add('ssw');  LanguageNames.Add('Swazi');
  LanguageCodes.Add('suk');  LanguageNames.Add('Sukuma');
  LanguageCodes.Add('sun');  LanguageNames.Add('Sudanese');
  LanguageCodes.Add('sus');  LanguageNames.Add('Susu');
  LanguageCodes.Add('sux');  LanguageNames.Add('Sumerian');
  LanguageCodes.Add('sve');  LanguageNames.Add('Swedish');
  LanguageCodes.Add('swa');  LanguageNames.Add('Swahili');
  LanguageCodes.Add('swe');  LanguageNames.Add('Swedish');
  LanguageCodes.Add('syr');  LanguageNames.Add('Syriac');
  LanguageCodes.Add('tah');  LanguageNames.Add('Tahitian');
  LanguageCodes.Add('tam');  LanguageNames.Add('Tamil');
  LanguageCodes.Add('tat');  LanguageNames.Add('Tatar');
  LanguageCodes.Add('tel');  LanguageNames.Add('Telugu');
  LanguageCodes.Add('tem');  LanguageNames.Add('Timne');
  LanguageCodes.Add('ter');  LanguageNames.Add('Tereno');
  LanguageCodes.Add('tgk');  LanguageNames.Add('Tajik');
  LanguageCodes.Add('tgl');  LanguageNames.Add('Tagalog');
  LanguageCodes.Add('tha');  LanguageNames.Add('Thai');
  LanguageCodes.Add('tib');  LanguageNames.Add('Tibetan');
  LanguageCodes.Add('tig');  LanguageNames.Add('Tigre');
  LanguageCodes.Add('tir');  LanguageNames.Add('Tigrinya');
  LanguageCodes.Add('tiv');  LanguageNames.Add('Tivi');
  LanguageCodes.Add('tli');  LanguageNames.Add('Tlingit	');
  LanguageCodes.Add('tmh');  LanguageNames.Add('Tamashek');
  LanguageCodes.Add('tog');  LanguageNames.Add('Tonga (Nyasa)	');
  LanguageCodes.Add('ton');  LanguageNames.Add('Tonga (Tonga Islands)');
  LanguageCodes.Add('tru');  LanguageNames.Add('Truk');
  LanguageCodes.Add('tsi');  LanguageNames.Add('Tsimshian');
  LanguageCodes.Add('tsn');  LanguageNames.Add('Tswana');
  LanguageCodes.Add('tso');  LanguageNames.Add('Tsonga');
  LanguageCodes.Add('tuk');  LanguageNames.Add('Turkmen');
  LanguageCodes.Add('tum');  LanguageNames.Add('Tumbuka');
  LanguageCodes.Add('tur');  LanguageNames.Add('Turkish');
  LanguageCodes.Add('tut');  LanguageNames.Add('Altaic (Other)');
  LanguageCodes.Add('twi');  LanguageNames.Add('Twi');
  LanguageCodes.Add('tyv');  LanguageNames.Add('Tuvinian');
  LanguageCodes.Add('uga');  LanguageNames.Add('Ugaritic');
  LanguageCodes.Add('uig');  LanguageNames.Add('Uighur');
  LanguageCodes.Add('ukr');  LanguageNames.Add('Ukrainian');
  LanguageCodes.Add('umb');  LanguageNames.Add('Umbundu');
  LanguageCodes.Add('und');  LanguageNames.Add('Undetermined');
  LanguageCodes.Add('urd');  LanguageNames.Add('Urdu');
  LanguageCodes.Add('uzb');  LanguageNames.Add('Uzbek');
  LanguageCodes.Add('vai');  LanguageNames.Add('Vai');
  LanguageCodes.Add('ven');  LanguageNames.Add('Venda');
  LanguageCodes.Add('vie');  LanguageNames.Add('Vietnamese');
  LanguageCodes.Add('vol');  LanguageNames.Add('Volapük');
  LanguageCodes.Add('vot');  LanguageNames.Add('Votic');
  LanguageCodes.Add('wak');  LanguageNames.Add('Wakashan Languages');
  LanguageCodes.Add('wal');  LanguageNames.Add('Walamo');
  LanguageCodes.Add('war');  LanguageNames.Add('Waray');
  LanguageCodes.Add('was');  LanguageNames.Add('Washo');
  LanguageCodes.Add('wel');  LanguageNames.Add('Welsh');
  LanguageCodes.Add('wen');  LanguageNames.Add('Sorbian Languages');
  LanguageCodes.Add('wol');  LanguageNames.Add('Wolof');
  LanguageCodes.Add('xho');  LanguageNames.Add('Xhosa');
  LanguageCodes.Add('yao');  LanguageNames.Add('Yao');
  LanguageCodes.Add('yap');  LanguageNames.Add('Yap');
  LanguageCodes.Add('yid');  LanguageNames.Add('Yiddish');
  LanguageCodes.Add('yor');  LanguageNames.Add('Yoruba');
  LanguageCodes.Add('zap');  LanguageNames.Add('Zapotec');
  LanguageCodes.Add('zen');  LanguageNames.Add('Zenaga');
  LanguageCodes.Add('zha');  LanguageNames.Add('Zhuang');
  LanguageCodes.Add('zho');  LanguageNames.Add('Chinese');
  LanguageCodes.Add('zul');  LanguageNames.Add('Zulu');
  LanguageCodes.Add('zun');  LanguageNames.Add('Zuni');

finalization

 Genres.Free;
 LanguageCodes.Free;
 LanguageNames.Free;

end.
