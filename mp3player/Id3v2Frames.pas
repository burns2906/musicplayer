unit ID3v2Frames;

{$I config.inc}

interface

uses
  SysUtils, Classes, Windows, dialogs
  {$IFDEF USE_DIConverters},DIConverters, U_CharCode{$ENDIF}
  {$IFDEF USE_TNT_COMPOS}, TntSysUtils, TntClasses{$ENDIF};

type

  {$IFNDEF USE_TNT_COMPOS}
  TTNTFileStream = TFileStream;
  TTNTStrings = TStrings;
  {$ENDIF}

  TID3v2FrameTypes = (FT_INVALID, FT_UNKNOWN,
                      FT_TextFrame,
                      FT_CommentFrame,
                      FT_LyricFrame,
                      FT_UserDefinedURLFrame,
                      FT_PictureFrame,
                      FT_PopularimeterFrame,
                      FT_URLFrame
                      );

  TID3v2FrameVersions = (FV_2 = 2, FV_3, FV_4);

    // Flags, die in den Frame-Headern gesetzt sein können
    // Die Unknown-Falgs brauche ich zum Löschen eben dieser beim Schreiben!
  TFrameFlags = (FF_TagAlter, FF_FileAlter, FF_ReadOnly, FF_UnknownStatus,
                 FF_Compression, FF_Encryption, FF_GroupID, FF_Unsync, FF_DataLength, FF_UnknownFormat);

const TFrameFlagValues : Array [TID3v2FrameVersions] of Array [TFrameFlags] of Byte =
             (
              (0,0,0,0,0,0,0,0,0,0),  // im v2-Tag gibts keine Flags
              (128, 64, 32, 31, 128, 64, 32, 0, 0, 31 ),
              (128, 64, 32, 31,   8,  4, 64, 2, 1, 176)
             );
Type TFrameIDs = (
  IDv2_UNKNOWN,
  IDv2_MP3FileUtilsExperimental, // Warnung!!! DIESEN FRAME NICHT WIRKLICH BENUTZEN !!!
  // Text-Frames
  IDv2_ARTIST, IDv2_TITEL, IDv2_ALBUM, IDv2_YEAR, IDv2_GENRE,  // ----
  IDv2_TRACK, IDv2_COMPOSER, IDv2_ORIGINALARTIST, IDv2_COPYRIGHT, IDv2_ENCODEDBY, // ----
  IDv2_LANGUAGES, IDv2_SOFTWARESETTINGS, IDv2_MEDIATYPE, IDv2_LENGTH, IDv2_PUBLISHER,  // ----
  IDv2_ORIGINALFILENAME, IDv2_ORIGINALLYRICIST, IDv2_ORIGINALRELEASEYEAR, IDv2_ORIGINALALBUMTITEL,// ---- // bishier gabs die Textframes in 0.3
  IDv2_BPM, IDv2_PLAYLISTDELAY, IDv2_FILETYPE, IDv2_INITIALKEY, IDv2_BANDACCOMPANIMENT, // ----
  IDv2_CONDUCTORREFINEMENT, IDv2_INTERPRETEDBY, IDv2_PARTOFASET, IDv2_ISRC, IDv2_CONTENTGROUPDESCRIPTION,  // ----
  IDv2_SUBTITLEREFINEMENT, IDv2_LYRICIST, IDv2_FILEOWNER, IDv2_INTERNETRADIONAME, IDv2_INTERNETRADIOOWNER, // ----
  // folgende Textframes nur in 2.4
  IDv2_ENCODINGTIME, IDv2_RECORDINGTIME, IDv2_RELEASETIME, IDv2_TAGGINGTIME, IDv2_MUSICIANCREDITLIST, //----
  IDv2_MOOD, IDv2_PRODUCEDNOTICE, IDv2_ALBUMSORTORDER, IDv2_PERFORMERSORTORDER, IDv2_TITLESORTORDER, IDv2_SETSUBTITLE,
  //---
  // Benutzerdefinierte Text-Frames
  IDv2_USERDEFINEDTEXT,
  //----//----//----
  // URL-Frames
  IDv2_AUDIOFILEURL, IDv2_ARTISTURL, IDv2_AUDIOSOURCEURL, IDv2_COMMERCIALURL, IDv2_COPYRIGHTURL,
  IDv2_PUBLISHERSURL, IDv2_RADIOSTATIONURL, IDv2_PAYMENTURL,
  //----//----
  // Weitere Frames
  IDv2_PICTURE, IDv2_LYRICS, IDv2_COMMENT, IDv2_RATING, IDv2_USERDEFINEDURL, IDv2_RECOMMENDEDBUFFERSIZE, //----
  IDv2_PLAYCOUNTER, IDv2_AUDIOENCRYPTION, IDv2_EVENTTIMINGCODES, IDv2_EQUALIZATION, IDv2_GENERALOBJECT, //----
  IDv2_LINKEDINFORMATION, IDv2_MUSICCDID, IDv2_MPEGLOOKUPTABLE, IDv2_REVERB, IDv2_VOLUMEADJUSTMENT,    //----
  IDv2_SYNCHRONIZEDLYRICS, IDv2_SYNCEDTEMPOCODES, IDv2_UNIQUEFILEID,
  // Frames, die es nicht überall gibt
  IDv2_COMMERCIALFRAME, IDv2_ENCRYPTIONMETHODREGISTRATION, IDv2_GROUPIDREGISTRATION, IDv2_OWNERSHIP,
  IDv2_PRIVATE, IDv2_POSITIONSYNCHRONISATION, IDv2_TERMSOFUSE, IDv2_SEEKPOINTINDEX, IDv2_SEEKFRAME,
  IDv2_SIGNATURE,
  // Weitere Frames, solten nicht erstellt werden
  IDv2_INVOLVEDPEOPLE, IDv2_ENCRYPTEDMETAFRAME, IDv2_RECORDINGDATES, IDv2_DATE, IDv2_TIME, IDv2_SIZE
  )  ;


type

  TTextEncoding = (TE_Ansi, TE_UTF16, TE_UTF16BE, UTF8);

  // Typ für das große, konstante Array am Anfang, was zur Ermittlung der Description benutzt wird
  TID3v2FrameDescriptionData = record
      IDs: Array[TID3v2FrameVersions] of String;
      Description: String;
  end;


  TBuffer = Array of byte;

  TID3v2Frame = class(TObject)
      private

          fVersion: TID3v2FrameVersions; //(2,3,4)
          fIDString: String;    // z.B. 'TALB'
          fID: TFrameIDs;       // z.B. IDv2_ARTIST
          fHeader: TBuffer;
          fData: TBuffer;
          fGroupID: Byte;
          fDataLength: Integer; // das ist die Größe, die bei ID3v2.4 vor den Daten steht,
                                // wenn das Flag gesetzt ist

          fAlwaysWriteUnicode: Boolean;
          {$IFDEF USE_DIConverters}
          // Keine Konvertierung entsprechend des Dateinamens durchführen
          fAcceptAllEncodings: Boolean;
          fCharCode: TCharCode;
          conv: conv_struct;
          {$ENDIF}

          fParsable: Boolean;

          function ValidFrameID: Boolean;
          function GetFrameType: TID3v2FrameTypes;    // Textframe, URLFrame, Picture-Frame, etc...
          function GetFrameTypeDescription: String;   // Beschreibung des Inhalts des Frames nach ID3.org
          function GetFrameTypeID: TFrameIDs;

          // Liefert die Flags des Frames zurück
          // "Unwichtige Flags"
          function GetFlagTagAlterPreservation: Boolean;
          function GetFlagFileAlterPreservation: Boolean;
          function GetFlagReadOnly: Boolean;
          // "Wichtige Flags", die Einfluss darauf haben, wie der Frame zu lesen ist
          function GetFlagCompression: Boolean;
          function GetFlagEncryption : Boolean;
          function GetFlagGroupingIdentity : Boolean;
          procedure SetFlagGroupingIdentity(Value: Boolean);
          function GetFlagUnsynchronisation : Boolean;
          function GetFlagDataLengthIndicator : Boolean;
          function GetUnknownStatusFlags: Boolean;
          function GetUnknownEncodingFlags: Boolean;

          procedure SetFlag(aFlag: TFrameFlags);
          procedure UnSetFlag(aFlag: TFrameFlags);

          procedure UnSetFlagSomeFlagsAfterDataSet;

          function GetDataSize: Integer;

          procedure SyncStream(Source, Target: TStream; aSize: Integer);
          procedure UpdateHeader(aSize: Integer = -1); // Setzt die Größen-information im Header neu.

          function IsUnicodeNeeded(aWideString: WideString): Boolean;

          // Liest von Start bis Ende die Bytes aus fData in einen WideString ein.
          function GetConvertedUnicodeText(Start, Ende: integer; TextEncoding: TTextEncoding):WideString;
          // Schreibt Value nach fData
          function WideStringToData(Value: Widestring; start: integer; UnicodeIsNeeded: Boolean): integer;

      public
          property FrameType: TID3v2FrameTypes read GetFrameType;
          property FrameTypeDescription: String read GetFrameTypeDescription;
          property FrameIDString: String read fIDString;
          property FrameID: TFrameIDs read GetFrameTypeID;

          property FlagTagAlterPreservation : Boolean read  GetFlagTagAlterPreservation;
          property FlagFileAlterPreservation: Boolean read  GetFlagFileAlterPreservation;
          property FlagReadOnly             : Boolean read  GetFlagReadOnly;

          property FlagCompression          : Boolean read  GetFlagCompression;
          property FlagEncryption           : Boolean read  GetFlagEncryption;
          property FlagGroupingIndentity    : Boolean read  GetFlagGroupingIdentity write SetFlagGroupingIdentity;
          property FlagUnsynchronisation    : Boolean read  GetFlagUnsynchronisation;
          property FlagDataLengthIndicator  : Boolean read  GetFlagDataLengthIndicator;
          property FlagUnknownStatus        : Boolean read  GetUnknownStatusFlags;
          property FlagUnknownEncoding      : Boolean read  GetUnknownEncodingFlags;

          property GroupID  : Byte read fGroupID write fGroupID;

          // Die Größe des Datenteils nach einer Re-Synchronisation
          // Bei Parsable-Frames exklusive GroupID und DataLength,
          //                     inklusive bei nicht lesbaren Frames
          property DataSize : Integer read  GetDataSize;

          property AlwaysWriteUnicode: Boolean read fAlwaysWriteUnicode write fAlwaysWriteUnicode;
          {$IFDEF USE_DIConverters}
          property CharCode: TCharCode read fCharCode write fCharCode;
          property AcceptAllEncodings: Boolean read fAcceptAllEncodings write fAcceptAllEncodings;
          {$ENDIF}

          constructor Create(aID: String; aVersion: TID3v2FrameVersions);

          procedure ReadFromStream(aStream: tStream); // Der Header wurde bereits gelesen und daraus der Frame erstellt
          procedure WriteToStream(aStream: tStream);  // Schreibe alles

          // Schreibe Frame, aber Unsynced. Diese Methode DARF NUR für ID3tags Version 2.4 benutzt werden!!
          // Bei 2.3 und 2.2 geschieht das Unsyncen auf Tag-Ebene, d.h. die frames werden normal geschrieben
          // und anschließend der gesamte Tag unsynced !!
          procedure WriteUnsyncedToStream(aStream: TStream);

          function GetText: Widestring;
          procedure SetText(Value: Widestring);

          function GetCommentsLyrics(out Language: String; out Description: WideString): Widestring;
          procedure SetCommentsLyrics(Language: String; Description, Value: Widestring);

          function GetUserdefinedURL(out Description: WideString): string;
          procedure SetUserdefinedURL(Description: WideString; URL: string);

          function GetURL: String;
          procedure SetURL(Value: String);

          function GetPicture(out Mime: String; out PicType: Byte; out Description: WideString; PictureData: TStream): Boolean;
          procedure SetPicture(Mime: String; PicType: Byte; Description: WideString; PictureData: TStream);

          function GetRating(out UserEMail: String): Byte;
          procedure SetRating(UserEMail: String; Value: Byte);

          procedure GetData(Data: TStream);
          // *************************************************************
          // *************************************************************
          // !! SetData nur nutzen, wenn man wirklich weiß, was man tut !!
          // *************************************************************
          // *************************************************************
          procedure SetData(Data: TStream);
  end;





const  ID3v2KnownFrames : Array[TFrameIDs] of TID3v2FrameDescriptionData =

        (  //  _ NICHT _ die Reihenfolge ändern, ohne den Enum-Typ anzupassen !!!
           // Text-Frames
           ( IDs: ('XXX', 'XXXX', 'XXXX') ; Description : 'Unknown/experimental Frame'),
           ( IDs: ('XMP', 'XMP3', 'XMP3') ; Description : 'Mp3FileUtils experimental Frame'),
           ( IDs: ('TP1', 'TPE1', 'TPE1') ; Description : 'Lead artist(s)/Lead performer(s)/Soloist(s)/Performing group'),
           ( IDs: ('TT2', 'TIT2', 'TIT2') ; Description : 'Title/Songname/Content description'),
           ( IDs: ('TAL', 'TALB', 'TALB') ; Description : 'Album/Movie/Show title'),
           ( IDs: ('TYE', 'TYER', 'TDRC') ; Description : 'Year'),
           ( IDs: ('TCO', 'TCON', 'TCON') ; Description : 'Content type'),
           // ----
           ( IDs: ('TRK', 'TRCK', 'TRCK') ; Description : 'Track number/Position in set'),
           ( IDs: ('TCM', 'TCOM', 'TCOM') ; Description : 'Composer'),
           ( IDs: ('TOA', 'TOPE', 'TOPE') ; Description : 'Original artist(s)/performer(s)'),
           ( IDs: ('TCR', 'TCOP', 'TCOP') ; Description : 'Copyright message'),
           ( IDs: ('TEN', 'TENC', 'TENC') ; Description : 'Encoded by'),
           // ----
           ( IDs: ('TLA', 'TLAN', 'TLAN') ; Description : 'Language(s)'),
           ( IDs: ('TSS', 'TSSE', 'TSSE') ; Description : 'Software/hardware and settings used for encoding'),
           ( IDs: ('TMT', 'TMED', 'TMED') ; Description : 'Media type'),
           ( IDs: ('TLE', 'TLEN', 'TLEN') ; Description : 'Length'),
           ( IDs: ('TPB', 'TPUB', 'TPUB') ; Description : 'Publisher'),
           // ----
           ( IDs: ('TOF', 'TOFN', 'TOFN') ; Description : 'Original filename'),
           ( IDs: ('TOL', 'TOLY', 'TOLY') ; Description : 'Original Lyricist(s)/text writer(s)'),
           ( IDs: ('TOR', 'TORY', 'TDOR') ; Description : 'Original release year'),
           ( IDs: ('TOT', 'TOAL', 'TOAL') ; Description : 'Original album/Movie/Show title'),
           // ----// bishier gabs die Textframes in 0.3
           ( IDs: ('TBP', 'TBPM', 'TBPM') ; Description : 'BPM (Beats Per Minute)'),
           ( IDs: ('TDY', 'TDLY', 'TDLY') ; Description : 'Playlist delay'),
           ( IDs: ('TFT', 'TFLT', 'TFLT') ; Description : 'File type'),
           ( IDs: ('TKE', 'TKEY', 'TKEY') ; Description : 'Initial key'),
           ( IDs: ('TP2', 'TPE2', 'TPE2') ; Description : 'Band/Orchestra/Accompaniment'),
           // ----
           ( IDs: ('TP3', 'TPE3', 'TPE3') ; Description : 'Conductor/Performer refinement'),
           ( IDs: ('TP4', 'TPE4', 'TPE4') ; Description : 'Interpreted, remixed, or otherwise modified by'),
           ( IDs: ('TPA', 'TPOS', 'TPOS') ; Description : 'Part of a set'),
           ( IDs: ('TRC', 'TSRC', 'TSRC') ; Description : 'ISRC (International Standard Recording Code)'),
           ( IDs: ('TT1', 'TIT1', 'TIT1') ; Description : 'Content group description'),
           // ----
           ( IDs: ('TT3', 'TIT3', 'TIT3') ; Description : 'Subtitle/Description refinement'),
           ( IDs: ('TXT', 'TEXT', 'TEXT') ; Description : 'Lyricist/text writer'),
           ( IDs: ('---', 'TOWN', 'TOWN') ; Description : 'File owner/licensee'),
           ( IDs: ('---', 'TRSN', 'TRSN') ; Description : 'Internet radio station name'),
           ( IDs: ('---', 'TRSO', 'TRSO') ; Description : 'Internet radio station owner'),
           // ----
           ( IDs: ('---', '----', 'TDEN') ; Description : 'Encoding time'),
           ( IDs: ('---', '----', 'TDRC') ; Description : 'Recording time'),
           ( IDs: ('---', '----', 'TDRL') ; Description : 'Release time'),
           ( IDs: ('---', '----', 'TDTG') ; Description : 'Tagging time'),
           ( IDs: ('---', '----', 'TMCL') ; Description : 'Musician credits list'),
           //----
           ( IDs: ('---', '----', 'TMOO') ; Description : 'Mood'),
           ( IDs: ('---', '----', 'TPRO') ; Description : 'Produced notice'),
           ( IDs: ('---', '----', 'TSOA') ; Description : 'Album sort order'),
           ( IDs: ('---', '----', 'TSOP') ; Description : 'Performer sort order'),
           ( IDs: ('---', '----', 'TSOT') ; Description : 'Title sort order'),
           ( IDs: ('---', '----', 'TSST') ; Description : 'Set subtitle'),
           ( IDs: ('TXX', 'TXXX', 'TXXX') ; Description : 'User defined text information frame'),
           //----//----//----
           // URL-Frames
           ( IDs: ('WAF', 'WOAF', 'WOAF') ; Description : 'Official audio file webpage'),
           ( IDs: ('WAR', 'WOAR', 'WOAR') ; Description : 'Official artist/performer webpage'),
           ( IDs: ('WAS', 'WOAS', 'WOAS') ; Description : 'Official audio source webpage'),
           ( IDs: ('WCM', 'WCOM', 'WCOM') ; Description : 'Commercial information'),
           ( IDs: ('WCP', 'WCOP', 'WCOP') ; Description : 'Copyright/Legal information'),
           ( IDs: ('WPB', 'WPUB', 'WPUB') ; Description : 'Publishers official webpage'),
           ( IDs: ('---', 'WORS', 'WORS') ; Description : 'Official internet radio station homepage'),
           ( IDs: ('---', 'WPAY', 'WPAY') ; Description : 'Payment'),
            // weitere Frames
           ( IDs: ('PIC', 'APIC', 'APIC') ; Description : 'Attached picture'),
           ( IDs: ('ULT', 'USLT', 'USLT') ; Description : 'Unsychronized lyric/text transcription'),
           ( IDs: ('COM', 'COMM', 'COMM') ; Description : 'Comments'),
           ( IDs: ('POP', 'POPM', 'POPM') ; Description : 'Popularimeter'),
           ( IDs: ('WXX', 'WXXX', 'WXXX') ; Description : 'User defined URL link frame'),
           ( IDs: ('BUF', 'RBUF', 'RBUF') ; Description : 'Recommended buffer size'),
           //----
           ( IDs: ('CNT', 'PCNT', 'PCNT') ; Description : 'Play counter'),
           ( IDs: ('CRA', 'AENC', 'AENC') ; Description : 'Audio encryption'),
           ( IDs: ('ETC', 'ETCO', 'ETCO') ; Description : 'Event timing codes'),
           ( IDs: ('EQU', 'EQUA', 'EQU2') ; Description : 'Equalization'),
           ( IDs: ('GEO', 'GEOB', 'GEOB') ; Description : 'General encapsulated object'),
           //----
           ( IDs: ('LNK', 'LINK', 'LINK') ; Description : 'Linked information'),
           ( IDs: ('MCI', 'MCDI', 'MCDI') ; Description : 'Music CD Identifier'),
           ( IDs: ('MLL', 'MLLT', 'MLLT') ; Description : 'MPEG location lookup table'),
           ( IDs: ('REV', 'RVRB', 'RVRB') ; Description : 'Reverb'),
           ( IDs: ('RVA', 'RVAD', 'RVA2') ; Description : 'Relative volume adjustment'),
            //----
           ( IDs: ('SLT', 'SYLT', 'SYLT') ; Description : 'Synchronized lyric/text'),
           ( IDs: ('STC', 'SYTC', 'SYTC') ; Description : 'Synced tempo codes'),
           ( IDs: ('UFI', 'UFID', 'UFID') ; Description : 'Unique file identifier'),
           // Frames, die es nicht überall gibt
           ( IDs: ('---', 'COMR', 'COMR') ; Description : 'Commercial frame'),
           ( IDs: ('---', 'ENCR', 'ENCR') ; Description : 'Encryption method registration'),
           ( IDs: ('---', 'GRID', 'GRID') ; Description : 'Group identification registration'),
           ( IDs: ('---', 'OWNE', 'OWNE') ; Description : 'Ownership frame'),
           ( IDs: ('---', 'PRIV', 'PRIV') ; Description : 'Private frame'),
           ( IDs: ('---', 'POSS', 'POSS') ; Description : 'Position synchronisation frame'),
           ( IDs: ('---', 'USER', 'USER') ; Description : 'Terms of use'),
           ( IDs: ('---', '----', 'ASPI') ; Description : 'Audio seek point index'),
           ( IDs: ('---', '----', 'SEEK') ; Description : 'Seek frame'),
           ( IDs: ('---', '----', 'SIGN') ; Description : 'Signature frame'),
           // Weitere Frames, sollten nicht erstellt werden.
           ( IDs: ('IPL', 'IPLS', 'TIPL') ; Description : 'Involved people list'),
           ( IDs: ('CRM', '----', '----') ; Description : 'Encrypted meta frame'),
           ( IDs: ('TRD', 'TRDA', '----') ; Description : 'Recording dates'),
           ( IDs: ('TDA', 'TDAT', '----') ; Description : 'Date'),
           ( IDs: ('TIM', 'TIME', '----') ; Description : 'Time'),

           ( IDs: ('TSI', 'TSIZ', '----') ; Description : 'Size')
        );

        Picture_Types: Array[0..20] of string =
          (	'Other',
            '32x32 pixels file icon (PNG only)',
            'Other file icon',
            'Cover (front)',
            'Cover (back)',
            'Leaflet page',
            'Media (e.g. lable side of CD)',
            'Lead artist/lead performer/soloist',
            'Artist/performer',
            'Conductor',
            'Band/Orchestra',
            'Composer',
            'Lyricist/text writer',
            'Recording Location',
            'During recording',
            'During performance',
            'Movie/video screen capture',
            'A bright coloured fish',
            'Illustration',
            'Band/artist logotype',
            'Publisher/Studio logotype' );


function UnSyncStream(Source, Target: TStream): Boolean;
procedure SetStreamEnd(aStream: TStream);

implementation

function ByteToTextEncoding(Value: Byte): TTextEncoding;
begin
  case Value of
    0: result := TE_Ansi;
    1: result := TE_UTF16;
    2: result := TE_UTF16BE;
    3: result := UTF8
  else
    result := TE_Ansi;
  end;
end;

// Entfernt Syncs aus dem Stream.
// d.h. FF Ex => FF 00 Ex
//      FF 00 => FF 00 00
// Rückgabewert: True, falls Änderungen nötig waren, False sonst.
function UnSyncStream(Source, Target: TStream): Boolean;
var buf: TBuffer;
    i, last: Int64;
const
    zero: byte = 0;
begin
    result := false;
    setlength(buf, Source.Size);
    Source.Read(buf[0], length(buf));
    i := 0;
    last := 0;

    while i <= length(buf)-1 do
    begin
        While (i < length(buf)-2)
              and
              ( (buf[i] <> $FF)
                 or
               ( (buf[i+1] <> $00) and (buf[i+1] < $E0) )
              )
        do
            inc(i);

        // i ist hier maximal length(buf)-2, d.h. buf[i] ist höchstens das vorletzte gültige Element
        // buf[i] buf[i+1] ist jetzt $FF Ex oder $FF 00
        if (buf[i] = $FF) and
               ( (buf[i+1] = $00) or (buf[i+1] >= $E0) )
        then
        begin
            // Stelle gefunden, die behandelt werden muss
            Target.Write(buf[last], i - last + 1);
            Target.Write(zero, SizeOf(Zero));
            //target.Write(buf[i+1], 1);   // nur das erste byte schreiben...sonst Problem bie ff ff ff ff ...
            last := i + 1;
            inc(i, 1);   // d.h. last = i
            result := True;
        end else
        begin
            // Wir sind am Ende des Quellstreams, und die letzten beiden Bytes machen keine Probleme
            Target.Write(buf[last], length(buf) - last);
            // evtl. aber das letzte Byte mit dem nächsten Byte in der Gesamt-datei (D.h. letztes Byte = $FF)
            if buf[length(buf)-1] = $FF then
            begin
                result := True;
                Target.Write(zero, SizeOf(Zero));
            end;
            i := length(buf);

        end;
    end;
end;

//--------------------------------------------------------------------
// Setzt das Ende eines Streams
//--------------------------------------------------------------------
procedure SetStreamEnd(aStream: TStream);
begin
  if aStream is THandleStream then
    SetEndOfFile((aStream as THandleStream).Handle)
  else
    if aStream is TMemoryStream then
      TMemoryStream(aStream).SetSize(aStream.Position);
end;



constructor TID3v2Frame.Create(aID: String; aVersion: TID3v2FrameVersions);
begin
    inherited Create;
    fVersion := aVersion;
    fIDString := aID;
    fID := IDv2_UNKNOWN;
    fParsable := True;
    if fVersion = FV_2 then
    begin
        Setlength(fHeader, 6);
        if not ValidFrameID then
          fIDString := 'XXX';
    end
    else
    begin
        Setlength(fHeader, 10);
        if not ValidFrameID  then
          fIDString := 'XXXX';
    end;

    move(fIDString[1], fHeader[0], length(fIDString));

    fAlwaysWriteUnicode := False;
    {$IFDEF USE_DIConverters}
    FillChar(conv, SizeOf(conv), 0);
    fCharCode := DefaultCharCode;
    fAcceptAllEncodings := True;
    {$ENDIF}
end;

// ganz ähnlich wie bei Tag.SyncStream
procedure TID3v2Frame.SyncStream(Source, Target: TStream; aSize: Integer);
var buf: TBuffer;
    i, last: Int64;
begin
    setlength(buf, aSize);
    Source.Read(buf[0], aSize);
    Target.Size := aSize;
    i := 0;
    last := 0;
    while i <= length(buf)-1 do
    begin
        While (i < length(buf)-2) and ((buf[i] <> $FF) or (buf[i+1] <> $00)) do
            inc(i);
        // i ist hier maximal length(buf)-2, d.h. buf[i] ist das vorletzte gültige Element
        // oder buf[i] = 255 und buf[i+1] = 0
        // also: vom letzten Fund bis zu i in den neuen Stream kopieren und buf[i+1] überspringen
        if (buf[i] = $FF) and (buf[i+1] = $00) then
        begin
            Target.Write(buf[last], i - last + 1);
            last := i + 2;
            inc(i, 2);   // d.h. last = i
        end else
        begin
            // wir sind am Ende des Streams und haben da kein FF 00
            Target.Write(buf[last], length(buf) - last);
            i := length(buf); // Ende.
        end;
    end;
    SetStreamEnd(Target);
end;



procedure TID3v2Frame.ReadFromStream(aStream: tStream);
var locSize: Integer;
    DataOffset: Integer;
    SyncedStream: TStream;
begin
  // Der IDStr wurde gerade von MP3FileUtils gelesen!
  locSize := 0;
  fParsable := True;
  // Rest des Headers einlesen.
  aStream.Read(fHeader[length(fIDString)], length(fHeader) - length(fIDString));
  case fVersion of
    FV_2: begin  locSize := 65536 * fHeader[3]
                + 256 * fHeader[4]
                + fHeader[5];
                fParsable := True;
                // keine Header-Flags vorhanden - passt schon
    end;
    FV_3: begin  locSize := 16777216 * fHeader[4]
                + 65536 * fHeader[5]
                + 256 * fHeader[6]
                + fHeader[7];
                if (fHeader[9] and $DF) <> 0 then
                    // Frame ist nicht lesbar für uns
                    // (Compression oder Encryption wird benutzt)
                    fParsable := False;
    end;
    FV_4: begin  locSize := 2097152 * fHeader[4]
                + 16384 * fHeader[5]
                + 128 * fHeader[6]
                + fHeader[7];
                if (fHeader[9] and $BC) <> 0 then
                    // Frame ist nicht lesbar für uns
                    // (Compression oder Encryption wird benutzt)
                    fParsable := False;
    end;
  end;

  // Daten lesen.
  // zuerst ggf. syncen. (Ja, auch GroupID etc. wurde ggf. unsynced!)
  if FlagUnsynchronisation then
  begin
      SyncedStream := TMemoryStream.Create;
      SyncStream(aStream, SyncedStream, locSize);
      locSize := SyncedStream.Size;
      SyncedStream.Position := 0;
  end else
      SyncedStream := aStream;

  DataOffset := 0;
  if fParsable then
  begin
      if FlagGroupingIndentity then
      begin
          inc(DataOffset);
          SyncedStream.Read(fGroupID, SizeOf(fGroupID));
      end;
      if FlagDataLengthIndicator then
      begin
          inc(DataOffset, 4);
          SyncedStream.Read(fDataLength, SizeOf(fDataLength));
      end;
      SetLength(fData, locSize - DataOffset);
      if length(fData) <> 0 then
          SyncedStream.ReadBuffer(fData[0], length(fData))
      else
          fData := NIL;
  end else
  begin
      // Daten komplett aus Stream in fData lesen
      SetLength(fData, SyncedStream.Size);
      if length(fData) <> 0 then
          SyncedStream.ReadBuffer(fData[0], length(fData))
      else
          fData := NIL;
  end;

  if aStream <> SyncedStream then
      SyncedStream.Free;
end;

// Nach dem Lesen stehen in fData die tatsächlichen Daten drin, falls der Frame
// Parsable ist (also weder verschlüsselt noch komprimiert)
// Die entsprechenden Flags im Header sind gesetzt.
// Außerhalb des fData-Blocks gibts DataLength-Indikator und GroupID

procedure TID3v2Frame.WriteToStream(aStream: tStream);
begin
    //hier kein unsync durchführen.
    UnsetFlag(FF_Unsync);

    if fParsable then
    begin
        UnsetFlag(FF_DataLength); // das brauchen wir hier nicht mehr.
                                  // im Fall von Compression/Encryption aber evtl. schon!

        if FlagGroupingIndentity then
            Updateheader(length(fData) + 1);

        aStream.WriteBuffer(fHeader[0],length(fHeader));

        // ggf. GroupID wieder schreiben
        if  FlagGroupingIndentity then
            aStream.Write(fGroupID, SizeOf(fGroupID));

        aStream.WriteBuffer(fData[0],length(fData));
    end else
    begin
        UpdateHeader; // wegen evtl. Unsync-Änderung
        // Header schreiben
        aStream.WriteBuffer(fHeader[0],length(fHeader));
        // Daten einfach komplett schreiben
        aStream.WriteBuffer(fData[0],length(fData));
    end;
end;

procedure TID3v2Frame.WriteUnsyncedToStream(aStream: TStream);
var tmpStream, UnsyncedStream: TMemoryStream;
begin
    UnsyncedStream := TMemoryStream.Create;
    tmpStream := TMemoryStream.Create;

    if fParsable then
    begin
        UnsetFlag(FF_DataLength); // das brauchen wir hier nicht mehr.
                                  // im Fall von Compression/Encryption aber evtl. schon!
        // ggf. GroupID wieder schreiben
        if  FlagGroupingIndentity then
            tmpStream.Write(fGroupID, SizeOf(fGroupID));

        tmpStream.WriteBuffer(fData[0],length(fData));
        tmpStream.Position := 0;
        if UnsyncStream(tmpStream, UnsyncedStream) then
        begin
            SetFlag(FF_Unsync)
        end else
            UnSetFlag(FF_Unsync);

        UpdateHeader(UnsyncedStream.Size);
        aStream.WriteBuffer(fHeader[0],length(fHeader));
        aStream.CopyFrom(UnsyncedStream, 0);

    end else
    begin
        tmpStream.WriteBuffer(fData[0],length(fData));
        tmpStream.Position := 0;
        if UnsyncStream(tmpStream, UnsyncedStream) then
        begin
            SetFlag(FF_Unsync)
        end else
            UnsetFlag(FF_Unsync);

        UpdateHeader(UnsyncedStream.Size);
        aStream.WriteBuffer(fHeader[0],length(fHeader));
        aStream.CopyFrom(UnsyncedStream, 0);
    end;
    UnsyncedStream.Free;
    tmpStream.Free;
end;




function TID3v2Frame.ValidFrameID: Boolean;
var  i: Integer;
begin
    result := True;
    if ((fVersion = FV_2) and (length(fIDString) <> 3))
        OR
       ((fVersion <> FV_2) and (length(fIDString) <> 4)) then
    begin
       result := False;
       exit;
    end;

    for i := 1 to length(fIDString) do
        if not (fIDString[i] in ['0'..'9', 'A'..'Z']) then
        begin
            result := False;
            Break;
        end;
end;


function TID3v2Frame.GetFrameType: TID3v2FrameTypes;
begin
    if Not ValidFrameID then
    begin
       result := FT_INVALID;
       exit;
    end;

    case self.fVersion of
      FV_2: begin
        if (fIDString[1] = 'T') and (fIDString <> 'TXX') then
          result := FT_TextFrame
        else
          if (fIDString = 'WXX') then
            result := FT_UserDefinedURLFrame
          else
            if (fIDString = 'COM') then
              result := FT_CommentFrame
            else
              if (fIDString = 'ULT') then
                result := FT_LyricFrame
              else
                if (fIDString = 'PIC') then
                  result := FT_PictureFrame
                else
                  if (fIDString = 'POP') then
                    result := FT_PopularimeterFrame
                  else
                        if (fIDString = 'WCM') OR (fIDString = 'WCP') OR (fIDString = 'WAF') OR
                           (fIDString = 'WAR') OR (fIDString = 'WAS') OR (fIDString = 'WPB') then
                          result := FT_URLFrame
                        else
                          result := FT_UNKNOWN;
      end
      else begin
        if (fIDString[1] = 'T') and (fIDString <> 'TXXX') then
          result := FT_TextFrame
        else
          if (fIDString = 'WXXX') then
            result := FT_UserDefinedURLFrame
          else
            if (fIDString = 'COMM') then
              result := FT_CommentFrame
            else
              if (fIDString = 'USLT') then
                result := FT_LyricFrame
              else
                if (fIDString = 'APIC') then
                  result := FT_PictureFrame
                else
                  if (fIDString = 'POPM') then
                    result := FT_PopularimeterFrame
                  else
                        if (fIDString = 'WCOM') OR (fIDString = 'WCOP') OR (fIDString = 'WOAF') OR (fIDString = 'WOAR') OR
                           (fIDString = 'WOAS') OR (fIDString = 'WORS') OR (fIDString = 'WPAY') OR (fIDString = 'WPUB') then
                          result := FT_URLFrame
                        else
                          result := FT_UNKNOWN;
      end;
    end; //case
end;

function TID3v2Frame.GetFrameTypeDescription: String;
var i: TFrameIDs;
begin
    if fID <> IDv2_UNKNOWN then
        result := ID3v2KnownFrames[fID].Description
    else
    begin
        result := 'Unknown Frame (' + fIDString + ')';
        for i := low(TFrameIDs) to High(TFrameIDs) do
            if  ID3v2KnownFrames[i].IDs[fVersion] = fIDString then
            begin
                result := ID3v2KnownFrames[i].Description;
                break;
            end;
    end;
end;

function TID3v2Frame.GetFrameTypeID: TFrameIDs;
var i: TFrameIDs;
begin
    if fID <> IDv2_UNKNOWN then
        result := fID
    else
    begin
        result := IDv2_UNKNOWN;
        for i := low(TFrameIDs) to High(TFrameIDs) do
        if  ID3v2KnownFrames[i].IDs[fVersion] = fIDString then
        begin
            result := i;
            fID := i;
            break;
        end;
    end;
end;

// Flag-Schema:
// Version 2.3: abc00000 ijk00000
// Version 2.4: 0abc0000 0h00kmnp
function TID3v2Frame.GetFlagTagAlterPreservation: Boolean;
begin
    case fVersion of
      FV_2: result := True;
      FV_3: result := (fHeader[8] and 128) = 0;
      FV_4: result := (fHeader[8] and 128) = 0
    else result := True;
    end;
end;
function TID3v2Frame.GetFlagFileAlterPreservation: Boolean;
begin
    case fVersion of
      FV_2: result := True;
      FV_3: result := (fHeader[8] and 64) = 0;
      FV_4: result := (fHeader[8] and 64) = 0
    else result := True;
    end;
end;
function TID3v2Frame.GetFlagReadOnly: Boolean;
begin
    case fVersion of
      FV_2: result := False;
      FV_3: result := (fHeader[8] and 32) = 32;
      FV_4: result := (fHeader[8] and 32) = 32
    else result := True;
    end;
end;
function TID3v2Frame.GetFlagCompression: Boolean;
begin
    case fVersion of
      FV_2: result := False;
      FV_3: result := (fHeader[9] and 128) = 128;
      FV_4: result := (fHeader[9] and 8) = 8
    else result := True;
    end;
end;
function TID3v2Frame.GetFlagEncryption : Boolean;
begin
    case fVersion of
      FV_2: result := False;
      FV_3: result := (fHeader[9] and 64) = 64;
      FV_4: result := (fHeader[9] and 4) = 4
    else result := True;
    end;
end;
function TID3v2Frame.GetFlagGroupingIdentity : Boolean;
begin
    case fVersion of
      FV_2: result := False;
      FV_3: result := (fHeader[9] and 32) = 32;
      FV_4: result := (fHeader[9] and 64) = 64
    else result := True;
    end;
end;
procedure TID3v2Frame.SetFlagGroupingIdentity(Value: Boolean);
begin
    if Value then
      SetFlag(FF_GroupID)
    else
      UnsetFlag(FF_GroupID);
end;
function TID3v2Frame.GetFlagUnsynchronisation : Boolean;
begin
    case fVersion of
      FV_2: result := False;
      FV_3: result := False;
      FV_4: result := (fHeader[9] and 2) = 2
    else result := True;
    end;
end;
function TID3v2Frame.GetFlagDataLengthIndicator : Boolean;
begin
    case fVersion of
      FV_2: result := False;
      FV_3: result := False;
      FV_4: result := (fHeader[9] and 1) = 1
    else result := True;
    end;
end;
function TID3v2Frame.GetUnknownStatusFlags: Boolean;
begin
    case fVersion of
      FV_2: result := False;
      FV_3: result := (fHeader[8] and 31) <> 0;
      FV_4: result := (fHeader[8] and 143) <> 0  // 143 = %10001111
    else result := True;
    end;
end;
function TID3v2Frame.GetUnknownEncodingFlags: Boolean;
begin
    case fVersion of
      FV_2: result := False;
      FV_3: result := (fHeader[9] and 31) <> 0;
      FV_4: result := (fHeader[9] and 176) = 176 // = %1011 0000
    else result := True;
    end;
end;

procedure TID3v2Frame.SetFlag(aFlag: TFrameFlags);
begin
    if fVersion <> FV_2 then
    begin
        if aFlag <= FF_UnknownStatus then
          fHeader[8] := fHeader[8] or TFrameFlagValues[fVersion][aFlag]
        else
          fHeader[9] := fHeader[9] or TFrameFlagValues[fVersion][aFlag];
    end;
end;

procedure TID3v2Frame.UnSetFlag(aFlag: TFrameFlags);
begin
    if fVersion <> FV_2 then
    begin
        if aFlag <= FF_UnknownStatus then
          fHeader[8] := fHeader[8] and (Not TFrameFlagValues[fVersion][aFlag])
        else
          fHeader[9] := fHeader[9] and (Not TFrameFlagValues[fVersion][aFlag]);
    end;
end;

procedure TID3v2Frame.UnSetFlagSomeFlagsAfterDataSet;
begin
    if fVersion <> FV_2 then
    begin
          // Alle Flags löschen außer die "Preserve-Flags" und GroupID
          fHeader[8] := fHeader[8] and (Not TFrameFlagValues[fVersion][FF_ReadOnly]);
          fHeader[8] := fHeader[8] and (Not TFrameFlagValues[fVersion][FF_UnknownStatus]);
          fHeader[9] := fHeader[9] and (Not TFrameFlagValues[fVersion][FF_Compression]);
          fHeader[9] := fHeader[9] and (Not TFrameFlagValues[fVersion][FF_Encryption]);
          fHeader[9] := fHeader[9] and (Not TFrameFlagValues[fVersion][FF_Unsync]);
          fHeader[9] := fHeader[9] and (Not TFrameFlagValues[fVersion][FF_DataLength]);
          fHeader[9] := fHeader[9] and (Not TFrameFlagValues[fVersion][FF_UnknownFormat]);
    end;
end;


function TID3v2Frame.GetDataSize: Integer;
begin
  if fData <> NIL then
    result := length(fData)
  else
    result  := 0;
end;

procedure TID3v2Frame.UpdateHeader(aSize: Integer = -1);
begin
  if aSize = -1 then
    aSize := length(fData);

  case fVersion of
    FV_2: begin
      fHeader[3] := aSize DIV 65536;
      aSize := aSize MOD 65536;
      fHeader[4] := aSize DIV 256;
      aSize := aSize MOD 256;
      fHeader[5] := aSize;
    end;
    FV_3: begin
      fHeader[4] := aSize DIV 16777216;
      aSize := aSize MOD 16777216;
      fHeader[5] := aSize DIV 65536;
      aSize := aSize MOD 65536;
      fHeader[6] := aSize DIV 256;
      aSize := aSize MOD 256;
      fHeader[7] := aSize;
    end;
    FV_4: begin
      fHeader[4] := aSize DIV 2097152;
      aSize := aSize MOD 2097152;
      fHeader[5] := aSize DIV 16384;
      aSize := aSize MOD 16384;
      fHeader[6] := aSize DIV 128;
      aSize := aSize MOD 128;
      fHeader[7] := aSize;
    end;
  end;
end;

function TID3v2Frame.IsUnicodeNeeded(aWideString: WideString): Boolean;
var i:integer;
begin
  result := False;
  for i := 1 to length(aWideString) do
    if Word(aWidestring[i]) > 255 then
    begin
      result := True;
      break;
    end;
end;


function TID3v2Frame.GetConvertedUnicodeText(Start, Ende: integer; TextEncoding: TTextEncoding):WideString;
var
  {$IFDEF USE_DIConverters}
  pwc: ucs4_t;
  convt: conv_t;
  i_result:integer;
  {$ENDIF}
  i:integer;
  tmp:string;
  tmpbuf: TBuffer;
  aLength: Integer;

begin
    if Ende >= length(fData) then Ende := length(fData) - 1;
    if Start < 0 then Start := 0;
    if Start > Ende  then
    begin
        result := '';
        exit;
    end;
    aLength := Ende-Start+1;
    Setlength(result, aLength);
    Fillchar(result[1], length(result)*2, 0);

    case TextEncoding of  // TE_Ansi, TE_UTF16, TE_UTF16BE, UTF8
        TE_Ansi: begin
            // Kein Unicode.
            // Es _sollte_ in Iso8859-1 kodiert sein, ist es aber oft nicht
            // Daher: Entsprechend des Zeichensatzes nach Unicode konvertieren

            {$IFDEF USE_DIConverters}
            if (fAcceptAllEncodings)  then
            begin
                // ----------------------->
                // DIESEN CODE NEHMEN, WENN MAN DICONVERTERS NUTZEN MÖCHTE
                // Ansonsten: den kürzeren unten nehmen.
                // Natürlich dann die einleitende Abfrage "if AcceptAllEncodings" entfernen
                // Die macht dann nämlich keinen Sinn mehr ;-)
                i := start;
                i_result := 1;
                while i <= Ende do
                begin
                    FillChar(convt, SizeOf(conv), 0);
                    if (FCharCode.ByteCount = 2) AND (FCharCode.DecodeFunction(convt, pwc, @fData[i], 1) = 1) then
                    begin
                        result[i_result] := WideChar(pwc);
                        inc(i,1);
                    end
                    else
                    begin
                      if fCharCode.DecodeFunction(convt, pwc, @fData[i], fCharCode.ByteCount) = fCharCode.ByteCount then
                          result[i_result] := WideChar(pwc)
                      else
                          result[i_result] := '?';
                      inc(i,fCharCode.ByteCount);
                    end;
                    inc(i_result);
                end;
                // <-----------------------
            end else
            {$ENDIF}
            begin
                // // NUR DIESEN CODE NEHMEN, WENN MAN DIE UNIT DICONVERTERS NICHT BENUTZEN MÖCHTE
                // // Hier wird einfach der Inhalt des Frames in einen String gelesen, und dieser dann
                // // als Ergebnis (von Delphi Konvertiert) zurückgegeben
                // // ----------------------->
                setlength(tmp, aLength);
                move(fData[start], tmp[1], length(tmp));
                result := trim(tmp);
            end;
            // // <-----------------------
            result := trim(result);
        end;
        TE_UTF16: begin
            { UTF-16 [UTF-16] encoded Unicode [UNICODE] __with__ BOM. All
             strings in the same frame SHALL have the same byteorder.
             Terminated with $00 00. }
            setlength(result, aLength DIV 2 - 1);
            if (fData[start] = $FE) and (fData[start + 1] = $FF) then
            begin
              // Bei dieser ByteOrder müssen wir swappen
              setlength(tmpbuf, alength - 2);
              for i := 1 to length(result)-1 do
              begin
                  tmpbuf[2*i - 2] := fData[start + 2*i + 1];
                  tmpbuf[2*i - 1] := fData[start + 2*i];
                  move(tmpbuf[0], result[1], 2*length(result));
              end;
            end else
            begin
              // ByteOrder ist WideString-Kompatibel. Einfach rüberkopieren
              setlength(result,alength DIV 2 - 1);
              move(fData[start+2], result[1], 2*length(result));
            end;
            result := trim(result);
        end;
        TE_UTF16BE: begin
           { UTF-16BE [UTF-16] encoded Unicode [UNICODE] __without__ BOM.
             Terminated with $00 00 } // LE
            setlength(result, alength DIV 2);
            move(fData[start], result[1], 2*length(result));
            result := trim(result);
        end;
        UTF8: begin
            {03   UTF-8 [UTF-8] encoded Unicode [UNICODE]. Terminated with $00.}
            setlength(tmp,alength);
            move(fData[start], tmp[1], alength);
            result := UTF8Decode(tmp);
            result := trim(result);
        end;
        else result := '';
    end;
end;


function TID3v2Frame.WideStringToData(Value: Widestring; start: integer; UnicodeIsNeeded: Boolean): integer;
var tmpstr: string;
begin
  if UnicodeIsNeeded then
  begin
    // ByteOrder
    fData[start] := $FF;
    fData[start+1] := $FE;
    // Inhalt kopieren
    if length(value) > 0 then
      move(value[1], fData[start+2], length(Value) * SizeOf(Widechar));

    result := 2 + SizeOf(WideChar)*length(Value);
  end else
  begin
    // in String konvertieren
    tmpstr := value;
    // kopieren
    if length(tmpstr) > 0 then
      move(tmpstr[1], fData[start], length(tmpstr));

    result := length(tmpstr);
  end;
end;



function TID3v2Frame.GetText: Widestring;
begin
    if fParsable then
      result :=
        GetConvertedUnicodeText(
        1,                            // Das erste Byte gehört nicht zum string, sondern:
        length(fData)-1,              // Datenteil komplett lesen
        ByteToTextEncoding(fData[0]), // Im ersten Byte steht die TextCodierung drin
        )
    else
      result := '';
end;

procedure TID3v2Frame.SetText(Value: Widestring);
var UseUnicode: Boolean;
begin
    UseUnicode := fAlwaysWriteUnicode OR IsUnicodeNeeded(Value);
    If UseUnicode then
    begin
        // 2 Bytes pro Zeichen + 1 Byte TextEncoding-Flag + 2 Bytes ByteOrder (FF FE)
        Setlength(fData, length(Value) * SizeOf(WideChar) + 3);
        // TextEncoding-Flag auf "Unicode" setzen
        fData[0] := 1;
    end else
    begin
        // 1 Byte pro Zeichen + 1 Byte TextEncoding
        Setlength(fData, length(Value)+1);
        // TextEncoding-Flag auf IS0-8859-1 setzen
        fData[0] := 0;
    end;
    // Daten schreiben. Ein Konvertierung von Widestring nach string
    // wird ggf. in der Prozedur WideStringToData vorgenommen
    WideStringToData(Value, 1, UseUnicode);
    UnSetFlagSomeFlagsAfterDataSet;
    UpdateHeader;
end;

function TID3v2Frame.GetCommentsLyrics(out Language: String; out Description: WideString): Widestring;
var enc: TTextEncoding;
  i: Integer;
begin
    // Frames sind in allen drei Versionen gleich aufgebaut:
    // 1 Byte Encoding
    // 3 Byte Language
    // <..> 00 (00) Description (enc)
    // <..> Value (enc)

    if fParsable then
    begin
        if length(fData) < 5 then
        begin
            Language := '';
            Description := '';
            result := '';
            exit;
        end;

        // Textkodierung ermitteln
        enc := ByteToTextEncoding(fData[0]);
        // Sprache ermitteln
        setlength(Language, 3);
        Move(fData[1], Language[1], 3);
        //Description ermitteln
        i := 4;

        if (enc = TE_UTF16) or (enc = TE_UTF16BE) then
        begin
            While (i < length(fData)-1) and ((fData[i] <> 0) or (fData[i+1] <> 0)) do
                inc(i,2);
            Description := GetConvertedUnicodetext(4, i, enc);
            inc(i,2) // zwei Bytes Terminierung
        end
        else
        begin
            While (i < length(fData)) and (fData[i] <> 0) do
                inc(i);
            Description := GetConvertedUnicodetext(4, i, enc);
            inc(i,1); // ein Byte Terminierung
        end;

        result := GetConvertedUnicodetext(i, length(fData)-1, enc);
    end else
    begin
        Language := '';
        Description := '';
        Result := '';
    end;
end;

procedure TID3v2Frame.SetCommentsLyrics(Language: String; Description, Value: Widestring);
var UseUnicode: Boolean;
    BytesWritten: Integer;
begin
    UseUnicode := AlwaysWriteUnicode OR IsUnicodeNeeded(Value) OR IsUnicodeNeeded(Description);
    if length(Language) <> 3 then Language := 'eng';

    If UseUnicode then
    begin
        Setlength(fData,
              4                                             // Text-Encoding + Language
            + 4 + length(Description) * SizeOf(WideChar)    // 2 Bytes BOM + 2Bytes pro Zeichen + 2 Bytes Terminierung (Description)
            + 2 + length(Value) * SizeOf(WideChar)  );      // 2 Bytes BOM + 2Bytes pro Zeichen (Value)
        fData[0] := 1;                                      // TextEncoding-Flag auf "Unicode" setzen
    end else
    begin
      Setlength(fData,
            4                           // Text-Encoding + Language                    
          + 1 + length(Description)     // 1 Byte pro Zeichen + 1 Byte Terminierung (Description)                    
          + length(Value) );            // 1 Byte pro Zeichen                    
      fData[0] := 0;                    // TextEncoding-Flag auf IS0-8859-1 setzen
    end;
    // Language setzen
    move(Language[1], fData[1], 3);
    // Description setzen
    BytesWritten := WideStringToData(Description, 4, UseUnicode);
    // Terminierung setzen
    fData[4 + BytesWritten] := 0;
    inc(BytesWritten); // Ein Byte mehr gechrieben
    if UseUnicode then
    begin // Terminierung mit Doppel-Null
      fData[4 + BytesWritten] := 0;
      inc(BytesWritten);
    end;
    // Kopiere Value in den Frame.
    WideStringToData(Value, 4 + BytesWritten, UseUnicode);
    UnSetFlagSomeFlagsAfterDataSet;
    UpdateHeader;
end;

function TID3v2Frame.GetUserdefinedURL(out Description: WideString): string;
var enc: TTextEncoding;
  i: Integer;
begin
    // Frames sind in allen drei Versionen gleich aufgebaut:
    // 1 Byte Encoding
    // <..> 00 (00) Description (enc)
    // <..> Value (ansii)
    if fParsable then
    begin
        if length(fData) < 2 then
        begin
            Description := '';
            result := '';
            exit;
        end;

        // Textkodierung ermitteln
        enc := ByteToTextEncoding(fData[0]);
        //Description ermitteln
        i := 1;

        if (enc = TE_UTF16) or (enc = TE_UTF16BE) then
        begin
            While (i < length(fData)-1) and ((fData[i] <> 0) or (fData[i+1] <> 0)) do
                inc(i,2);
            Description := GetConvertedUnicodetext(1, i, enc);
            inc(i,2) // zwei Bytes Terminierung
        end
        else
        begin
            While (i < length(fData)) and (fData[i] <> 0) do
                inc(i);
            Description := GetConvertedUnicodetext(1, i, enc);
            inc(i,1); // ein Byte Terminierung
        end;

        result := GetConvertedUnicodetext(i, length(fData)-1, TE_Ansi);
    end else
    begin
        Description := '';
        result := '';
    end;
end;

procedure TID3v2Frame.SetUserdefinedURL(Description: WideString; URL: string);
var UseUnicode: Boolean;
    BytesWritten: Integer;
begin
    UseUnicode := IsUnicodeNeeded(Description);
    If UseUnicode then
    begin
        Setlength(fData,
              1                                             // Text-Encoding + Language
            + 4 + length(Description) * SizeOf(WideChar)    // 2 Bytes BOM + 2Bytes pro Zeichen + 2 Bytes Terminierung (Description)
            + length(URL)   );                              // 1Byte pro Zeichen (Value)
        fData[0] := 1;                                      // TextEncoding-Flag auf "Unicode" setzen
    end else
    begin
      Setlength(fData,
            1                           // Text-Encoding + Language
          + 1 + length(Description)     // 1 Byte pro Zeichen + 1 Byte Terminierung (Description)
          + length(URL) );              // 1 Byte pro Zeichen
      fData[0] := 0;                    // TextEncoding-Flag auf IS0-8859-1 setzen
    end;
    // Description setzen
    BytesWritten := WideStringToData(Description, 1, UseUnicode);
    // Terminierung setzen
    fData[1 + BytesWritten] := 0;
    inc(BytesWritten); // Ein Byte mehr gechrieben
    if UseUnicode then
    begin // Terminierung mit Doppel-Null
      fData[1 + BytesWritten] := 0;
      inc(BytesWritten);
    end;
    // Kopiere Value in den Frame.
    WideStringToData(URL, 1 + BytesWritten, False);
    UnSetFlagSomeFlagsAfterDataSet;
    UpdateHeader;
end;

function TID3v2Frame.GetURL: String;
begin
    if fParsable then
    begin
        setlength(result, length(fData));
        if length(result) > 0 then
          move(fData[0], result[1], length(result))
        else
          result := '';
    end else
        result := '';
end;

procedure TID3v2Frame.SetURL(Value: String);
begin
  if Value = '' then
    Value := ' ';
  Setlength(fData, length(Value));
  move(Value[1], fData[0], length(Value));
  UnSetFlagSomeFlagsAfterDataSet;
  UpdateHeader;
end;

function TID3v2Frame.GetPicture(out Mime: String; out PicType: Byte; out Description: WideString; PictureData: TStream): Boolean;
var 
    enc: TTextEncoding;
    i, dStart: Integer;
begin
    if fParsable then
    begin
        result := True;
        case fVersion of
            FV_2: begin
                if length(fData) <= 6 then  // 1 Enc, 3 Mime, 1 PicTyp, 1 Descr.-Terminierung -> das ist das Minimum
                begin
                    Mime := '';
                    PicType := 0;
                    Description := '';
                    result := False;
                end else
                begin
                    // mindestens 7 Bytes in fData drin, max. Index also 6 oder höher
                    enc := ByteToTextEncoding(fData[0]);
                    // Mime-Typ immer 3 Zeichen (ist eigentlich gar kein Mime-Typ ;-))
                    SetLength(Mime, 3);
                    Move(fData[1], Mime[1], 3);
                    // PicTyp
                    PicType := fData[4];
                    // Description wird mit 0 terminiert
                    i := 5;

                    if (enc = TE_UTF16) or (enc = TE_UTF16BE) then
                    begin
                        While (i < length(fData)-1) and ((fData[i] <> 0) or (fData[i+1] <> 0)) do
                            inc(i,2);
                        Description := GetConvertedUnicodetext(5, i, enc);
                        inc(i,2) // zwei Bytes Terminierung
                    end
                    else
                    begin
                        While (i < length(fData)) and (fData[i] <> 0) do
                            inc(i);
                        Description := GetConvertedUnicodetext(5, i, enc);
                        inc(i,1); // ein Byte Terminierung
                    end;

                    // Hier müssten dann die Bilddaten anfangen
                    if i < length(fData) then
                      PictureData.Write(fData[i], length(fData) - i)
                    else
                      result := False;
                end;
            end
        else begin
                // Version 3 oder 4
                if length(fData) <= 4 then  // 1 Enc, 1 Mime-Terminierung, 1 PicTyp, 1 Descr.-Terminierung -> das ist das Minimum
                begin
                    Mime := '';
                    PicType := 0;
                    Description := '';
                    result := False;
                end else
                begin
                    enc := ByteToTextEncoding(fData[0]);
                    i := 1;
                    // Terminierung des Mime-Typs bestimmen
                    While (i < length(fData)) and (fData[i] <> 0) do
                      inc(i);
                    Setlength(Mime, i-1); // das letzte 0-Bit nicht. (Falls das nicht 0 ist, dann ist result hinterher eh falsch ;-))
                    Move(fData[1], Mime[1], i-1);
                    // Ein Byte-Terminierung
                    inc(i);

                    //PicType
                    if i < length(fData) then
                        PicType := fData[i]
                    else result := False;

                    inc(i);
                    // Terminierung der Description bestimmen
                    dStart := i;

                    if (enc = TE_UTF16) or (enc = TE_UTF16BE) then
                    begin
                        While (i < length(fData)-1) and ((fData[i] <> 0) or (fData[i+1] <> 0)) do
                            inc(i,2);
                        Description := GetConvertedUnicodetext(dStart, i, enc);
                        inc(i,2) // zwei Bytes Terminierung
                    end
                    else
                    begin
                        While (i < length(fData)) and (fData[i] <> 0) do
                            inc(i);
                        Description := GetConvertedUnicodetext(dStart, i, enc);
                        inc(i,1); // ein Byte Terminierung
                    end;

                    // Hier müssten dann die Bilddaten anfangen
                    if i < length(fData) then
                      PictureData.Write(fData[i], length(fData) - i)
                    else
                      result := False;
                end
            end; // else
        end;
    end else
    begin
      result := False;
      Mime := '';
      PicType := 0;
      Description := '';
    end;
end;

procedure TID3v2Frame.SetPicture(Mime: String; PicType: Byte; Description: WideString; PictureData: TStream);
var UseUnicode: Boolean;
    BytesWritten, helpIdx: Integer;
begin
    UseUnicode :=  IsUnicodeNeeded(Description);
    if Pictype > 20 then PicType := 0;

    case fVersion of
        FV_2: begin
            // Mime-Typ für V2 korrigieren
            If length(Mime) <> 3 then
            begin
                if Mime = 'image/png'  then
                    Mime := 'PNG'
                else
                    Mime := 'JPG';
            end;
            if UseUnicode then
            begin
                setlength(fData, 1 + 3 + 1 + (length(Description) + 1) * SizeOf(Widechar) + PictureData.size);
                fData[0] := 1;
            end else
            begin
                setlength(fData, 1 + 3 + 1 + length(Description) + 1 + PictureData.size);
                fData[0] := 0;
            end;
            move(Mime[1], fData[1], 3);
            fData[4] := PicType;
            helpIdx := 5;
        end
        else
        begin
            // Version 3 oder 4
            if UseUnicode then
            begin
                setlength(fData, 1 + length(Mime) + 1 + 1 + (length(Description) + 1) * SizeOf(Widechar) + PictureData.size);
                fData[0] := 1;
            end else
            begin
                setlength(fData, 1 + length(Mime) + 1 + 1 + length(Description) + 1 + PictureData.size);
                fData[0] := 0;
            end;
            move(Mime[1], fData[1], length(Mime));
            fData[1 + length(Mime)] := 0; // Terminierung
            fData[2 + length(Mime)] := PicType;
            helpIdx := 3 + length(Mime);
        end; // else
    end;  // Case

    BytesWritten := WideStringToData(Description, helpIdx, UseUnicode);
    fData[helpIdx + BytesWritten] := 0;
    inc(BytesWritten); // Ein Byte mehr gechrieben
    if UseUnicode then
    begin // Terminierung mit Doppel-Null
      fData[helpIdx + BytesWritten] := 0;
      inc(BytesWritten);
    end;
    PictureData.Seek(0, soFromBeginning);
    PictureData.Read(fData[helpIdx + BytesWritten], PictureData.Size);
    UnSetFlagSomeFlagsAfterDataSet;
    UpdateHeader;
end;

function TID3v2Frame.GetRating(out UserEMail: String): Byte;
var i: Integer;
begin
    if fParsable then
    begin
        i := 0;
        result := 0; // undef.

        // Länge des Beschreibungs-Strings ermitteln
        While (i < length(fData)) and (fData[i] <> 0) do
            inc(i);
        Setlength(UserEMail, i);
        Move(fData[0], UserEMail[1], i);

        // nach dem 0-Byte steht das Rating drin
        inc(i);
        if i < length(fData) then
            result := fData[i];
    end else
    begin
        result := 0;
        UserEMail := '';
    end;
end;

procedure TID3v2Frame.SetRating(UserEMail: String; Value: Byte);
begin
    Setlength(fData, length(UserEMail) + 2);
    move(UserEMail[1], fData[0], length(UserEMail));
    fData[length(UserEMail)] := 0;
    fData[length(UserEMail) + 1] := Value;
    UnSetFlagSomeFlagsAfterDataSet;
    UpdateHeader;
end;

procedure TID3v2Frame.GetData(Data: TStream);
begin
  if length(fData) > 0 then
    Data.Write(fData[0], length(fData));
end;

procedure TID3v2Frame.SetData(Data: TStream);
begin
  Data.Seek(0, soFromBeginning);
  setlength(fData, Data.Size);
  Data.Read(fData[0], Data.Size);
  UpdateHeader;
end;




end.
