unit playerclass;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,audiofileclass,bass;

type

 
  TMeMPPlayer = class
    private
        fMainStream: DWord;
        fMainVolume: single;
        fMainAudioFile: TAudioFile;
        fFileEndSyncHandle: DWord;

        fFilter: String;
        fValidExtensions: TStringlist;

        fOnPlay    : TNotifyEvent;
        fOnPause   : TNotifyEvent;
        fOnResume  : TNotifyEvent;
        fOnStop    : TNotifyEvent;
        fOnChange  : TNotifyEvent;
        fOnEndFile : TNotifyEvent;

        function MeMP_CreateStream(aFilename: String): DWord;
        procedure SetVolume(Value: single);
        procedure SetPosition(Value: Longword);
        function GetTime: Double;
        procedure SetTime(Value: Double);
        function GetProgress: Double;
        procedure SetProgress(Value: Double);

        function GetLength: Double;
        function GetBassStatus: DWord;
        function GetPlaylistTitel: String;
        procedure SetEndSync;

    public

        property Volume: single read fMainVolume write SetVolume;
        property Time: Double read GetTime write SetTime;
        property Progress: Double read GetProgress write SetProgress;
        property Dauer: Double read Getlength;
        property PlaylistTitel: String read GetPlaylistTitel;
        property BassStatus: DWord read GetBassStatus;
        property Filter: String read fFilter;

        property OnPlay    : TNotifyEvent read fOnPlay     write fOnPlay    ;
        property OnPause   : TNotifyEvent read fOnPause    write fOnPause   ;
        property OnResume  : TNotifyEvent read fOnResume   write fOnResume  ;
        property OnStop    : TNotifyEvent read fOnStop     write fOnStop    ;
        property OnChange  : TNotifyEvent read fOnChange   write fOnChange ;
        property OnEndFile : TNotifyEvent read fOnEndFile  write fOnEndFile;

        constructor Create;
        destructor Destroy; override;

        procedure InitBassEngine(HND: HWND);
        procedure InitPlugins(PathToDlls: String);

        procedure Play(aAudioFile: TAudioFile);
        procedure Pause;
        procedure Stop;
        procedure Resume;
        procedure StopAndFree;

        function IsPlayableFile(aFilename: String): Boolean;
          end;

implementation

// ================================================
// ein paar Hilfsfunktionen
// ================================================
procedure EndFileProc(handle: HWND; Channel, Data, User: DWord); stdcall;
begin
    TMeMPPlayer(User).OnEndFile(TMeMPPlayer(User));
end;

function Explode(const Separator, S: String): TStringList;
var
  SepLen: Integer;
  F, P: PChar;
  tmpstr: String;
begin
  result := TStringList.Create;
  if (S = '') then Exit;
  if Separator = '' then
  begin
    Result.Add(S);
    Exit;
  end;
  SepLen := Length(Separator);
  P := PChar(S);
  while P^ <> #0 do
  begin
    F := P;
    P := StrPos(P, PChar(Separator));
    if (P = nil) then P := StrEnd(F);
    SetString(tmpstr, F, P - F);
    Result.Add(tmpstr);
    if P^ <> #0 then Inc(P, SepLen);
  end;
end;


constructor TMeMPPlayer.Create;
begin
  inherited create;
  fMainAudioFile := TAudioFile.Create;
  fValidExtensions := TStringlist.Create;
  // Standard-Extensions hinzufügen,
  // die die bass.dll von sich aus abspielen kann
  fValidExtensions.CaseSensitive := False;
  fValidExtensions.Add('.mp3'); fValidExtensions.Add('.ogg');
  fValidExtensions.Add('.wav'); fValidExtensions.Add('.mp1');
  fValidExtensions.Add('.mp2'); fValidExtensions.Add('.aiff');
  fValidExtensions.Add('.mo3'); fValidExtensions.Add('.it');
  fValidExtensions.Add('.xm'); fValidExtensions.Add('.s3m');
  fValidExtensions.Add('.mtm'); fValidExtensions.Add('.mod');
  fValidExtensions.Add('.umx');
end;


destructor TMeMPPlayer.Destroy;
begin
  fMainAudioFile.Free;
  fValidExtensions.Free;

  BASS_Free;
  inherited Destroy;
end;

// ================================================
// Initialisierung
// ================================================
procedure TMeMPPlayer.InitBassEngine(HND: HWND);
begin
  if (HIWORD(BASS_GetVersion) <> BASSVERSION) then
    MessageDLG('Bass 2.3 nicht gefunden', mtError, [MBOK], 0);
  BASS_Init(-1, 44100, 0, HND, nil);
end;

procedure TMeMPPlayer.InitPlugins(PathToDlls: String);
var fh: THandle;
    fd: TWin32FindData;
    Plug: DWORD;
    Info: PBass_PluginInfo;
    a,i: integer;
    tmpext: TStringlist;
    tmpfilter: String;
begin
  PathToDlls := IncludeTrailingPathDelimiter(PathToDlls);
  fFilter := '|Standard Formate (*.mp3;*.mp2;*.mp1;*.ogg;*.wav;*.aif)'
           + '|*.mp3;*.mp2;*.mp1;*.ogg;*.wav*;*.aif';
  // Plugins laden. Code aus dem Plugin-Beispiel-Projekt
  fh := FindFirstFile(PChar(PathToDlls + 'bass*.dll'), fd);
  if (fh <> INVALID_HANDLE_VALUE) then
  try
    repeat
      Plug := BASS_PluginLoad(fd.cFileName, 0);
      if Plug <> 0 then
      begin
        // get plugin info to add to the file selector filter...
        Info := BASS_PluginGetInfo(Plug);
        for a := 0 to Info.formatc - 1 do
        begin
          // Set The OpenDialog additional, to the supported PlugIn Formats
          fFilter := fFilter
            + '|' + Info.Formats[a].name + ' (' +
            Info.Formats[a].exts + ')|' + Info.Formats[a].exts;
          //einzelne Erweiterungen ermitteln
          tmpext := Explode(';',Info.Formats[a].exts);
          for i := 0 to tmpext.Count - 1 do
            fValidExtensions.Add(StringReplace(tmpext.Strings[i],'*', '',[]));
          FreeAndNil(tmpext);
        end;
      end;
    until FindNextFile(fh, fd) = false;
  finally
    Windows.FindClose(fh);
  end;
  // Plugins geladen
  // Zum Filter "Alle Dateien" hinzufügen
  tmpfilter := '*.mp3';
  for i := 1 to fValidExtensions.Count - 1 do
    tmpfilter := tmpfilter + ';*' + fValidExtensions[i];
  fFilter := 'Alle unterstützten Formate|' + tmpfilter + fFilter;
end;



// ================================================
// Hilfsfunktionen zum Abspielen
// ================================================
procedure TMeMPPlayer.StopAndFree;
begin
  // Wiedergabe stoppen und Handles freigeben
  BASS_ChannelStop(fMainStream);
  BASS_StreamFree(fMainStream);
  fMainStream := 0;
end;

function TMeMPPlayer.MeMP_CreateStream(aFilename: String): DWord;
var extension: String;
  flags: DWORD;
begin
  extension := AnsiLowerCase(ExtractFileExt(aFilename));
  if (extension = '.mp3') OR (extension = '.mp2') OR (extension = '.mp1') then
    flags := BASS_STREAM_PRESCAN           // optional dazu: OR BASS_SAMPLE_SOFTWARE
  else
    flags := 0;                            //optional: BASS_SAMPLE_SOFTWARE;
  result := BASS_StreamCreateFile(False, PChar(aFilename), 0, 0, flags);

  // Vorgang oben fehlgeschlagen? Dann mit Music probieren
  if result = 0 then
    result := BASS_MusicLoad(FALSE, PChar(aFilename), 0, 0, BASS_MUSIC_RAMP OR BASS_MUSIC_PRESCAN ,0);
end;


// ================================================
// Abspielen, Pause, Stop, Resume
// ================================================
procedure TMeMPPlayer.Play(aAudioFile: TAudioFile);
begin
  if aAudioFile <> NIL then
  begin
    fMainAudioFile.Assign(aAudioFile);
    StopAndFree;
    fMainstream := MeMP_CreateStream(fMainAudioFile.Pfad);
    SetEndSync;
    BASS_ChannelSetAttribute(fMainStream, BASS_ATTRIB_VOL, fMainVolume);
    BASS_ChannelPlay(fMainStream , True);
    if fMainstream <> 0 then
    begin
      if assigned(fOnPlay) then fOnPlay(Self);
      if assigned(fOnChange) then fOnChange(Self);
    end;
  end;
end;

procedure TMeMPPlayer.Pause;
begin
  BASS_ChannelPause(fMainStream);
  if assigned(fOnPause) then fOnPause(Self);
end;

procedure TMeMPPlayer.Stop;
begin
  BASS_ChannelStop(fMainStream);
  if assigned(fOnStop) then fOnStop(Self);
end;

procedure TMeMPPlayer.Resume;
begin
  BASS_ChannelPlay(fMainStream, False);
  if assigned(fOnResume) then fOnResume(Self);
end;


// ================================================
// Getter und Setter der Properties
// ================================================
procedure TMeMPPlayer.SetVolume(Value: Single);
begin
  if Value < 0 then Value := 0;
  if Value > 1 then Value := 1;
  fMainVolume := Value;
  BASS_ChannelSetAttribute(fMainStream, BASS_ATTRIB_VOL, fMainVolume);
end;

procedure TMeMPPlayer.SetPosition(Value: Longword);
begin
  BASS_ChannelSetPosition(fMainStream, Value, BASS_POS_BYTE);
end;

function TMeMPPlayer.GetTime: Double;
begin
  if (fMainStream <> 0) then
    result := BASS_ChannelBytes2Seconds(fMainStream, BASS_ChannelGetPosition(fMainStream, BASS_POS_BYTE))
  else
    result := 0;
end;

procedure TMeMPPlayer.SetTime(Value: Double);
begin
  if Value < 0 then Value := 0;
  if Value > BASS_ChannelBytes2seconds(fMainStream, BASS_ChannelGetLength(fMainStream, BASS_POS_BYTE)) then
    Value := BASS_ChannelBytes2seconds(fMainStream, BASS_ChannelGetLength(fMainStream, BASS_POS_BYTE));
  SetPosition(BASS_ChannelSeconds2Bytes(fMainStream, Value));
end;

function TMeMPPlayer.GetProgress: Double;
begin
  if (fMainStream <> 0) then
    result := BASS_ChannelGetPosition(fMainStream, BASS_POS_BYTE) / BASS_ChannelGetLength(fMainStream, BASS_POS_BYTE)
  else
    result := 0;
end;

procedure TMeMPPlayer.SetProgress(Value: Double);
begin
  if Value < 0 then Value := 0;
  if Value > 1 then Value := 1;
  SetPosition(Round(BASS_ChannelGetLength(fMainStream, BASS_POS_BYTE) * Value));
end;

function TMeMPPlayer.GetLength: Double;
begin
  if (fMainStream <> 0) then
    result := BASS_ChannelBytes2Seconds(fMainStream, BASS_ChannelGetLength(fMainStream, BASS_POS_BYTE))
  else
    result := 0;
end;

function TMeMPPlayer.GetBassStatus: DWord;
begin
  result := BASS_ChannelIsActive(fMainStream);
end;

function TMeMPPlayer.GetPlaylistTitel: String;
begin
  if assigned(fMainAudioFile) then
    result := fMainAudioFile.PlaylistTitel
  else
    result := '-';
end;

// ================================================
// Synchronizer setzen
// ================================================
procedure TMeMPPlayer.SetEndSync;
begin
  if Assigned(fOnEndFile) then
    fFileEndSyncHandle := Bass_ChannelSetSync(fMainStream,
                  BASS_SYNC_END, 0,
                  @EndFileProc, Self);
end;

// ================================================
// Abfrage auf Abspielbarkeit einer Datei anhand der Dateiendung
// ================================================
function TMeMPPlayer.IsPlayableFile(aFilename: String): Boolean;
begin
  result := fValidExtensions.IndexOf(ExtractFileExt(aFilename)) >= 0;
end;





end.
