unit Playlistclass;

interface

uses Contnrs, SysUtils, Classes,
     Audiofileclass, Playerclass;

type
  DWORD = cardinal;

  TPlaylistAddItemEvent = procedure(Sender: TObject; NewAudioFile: TAudioFile) of Object;

  TMeMPPlaylist = Class(TMeMPPlayer)
    private
      fPlayingIndex: Integer;
      fPlayingFile: TAudioFile;
      fPlaylist: TObjectlist;

      fOnClear   : TNotifyEvent;
      fOnAddItem : TPlaylistAddItemEvent;

      function GetNextAudioFileIndex: Integer;
      function GetPrevAudioFileIndex: Integer;
      procedure LoadFromM3U(aFilename: String);
      procedure SaveAsM3U(aFilename: String);
    public

      property PlayingFile: TAudioFile read fPlayingFile;
      property PlayingIndex: Integer read fPlayingIndex;
      property OnClear   : TNotifyEvent          read fOnClear    write fOnClear   ;
      property OnAddItem : TPlaylistAddItemEvent read fOnAddItem  write fOnAddItem ;

      constructor Create;
      destructor Destroy; override;

      procedure Add(aAudiofileName:String);
      procedure Play(aIndex: Integer); Overload;
      procedure PlayNext;
      procedure PlayPrevious;
      procedure Clear;

      procedure LoadFromFile(aFilename: String);
      procedure SaveToFile(aFilename: String);
  end;



implementation

constructor TMeMPPlaylist.Create;
begin
  inherited create;
  fPlaylist := TObjectList.Create;
  fPlayingFile := Nil;
end;


destructor TMeMPPlaylist.Destroy;
begin
  fPlaylist.Free;
  inherited Destroy;
end;

// ================================================
// Datei anhand eines Dateinamens der Liste hinzufügen
// ================================================
procedure TMeMPPlaylist.Add(aAudiofileName: String);
var NewFile: TAudioFile;
begin
  NewFile := TAudioFile.Create;
  NewFile.GetAudioInfo(aAudiofileName);
  fPlaylist.Add(NewFile);

  if assigned(fOnAddItem) then
    fOnAddItem(Self, NewFile);
end;


// ================================================
// Einen bestimmten Eintrag abspielen
// ================================================
procedure TMeMPPlaylist.Play(aIndex: Integer);
begin
  if aIndex >= 0 then
    fplayingIndex := aIndex;
  if (fplayingIndex > fPlaylist.Count - 1) and (fPlaylist.Count > 0) then
    fplayingIndex := fPlaylist.Count - 1;  // setzen auf -1 abfangen!!
  if (fplayingIndex >= 0)  and (fPlayingIndex < fPlaylist.Count)  then
    fPlayingFile := TAudioFile(fPlaylist[fplayingIndex]);

  play(fPlayingFile);
end;

// ================================================
// Weiter/Zurück
// ================================================
procedure TMeMPPlaylist.PlayNext;
begin
  Play(GetNextAudioFileIndex);
end;

procedure TMeMPPlaylist.PlayPrevious;
begin
  Play(GetPrevAudioFileIndex);
end;

// ================================================
// Playlist leeren
// ================================================
procedure TMeMPPlaylist.Clear;
begin
  Stop;
  fPlaylist.Clear;
  if Assigned(fOnClear) then
    fOnClear(Self);
  fPlayingFile := Nil;
  fPlayingIndex := 0;
end;


// ================================================
// Hilffunktionen für vor/zurück
// ================================================
function TMeMPPlaylist.GetNextAudioFileIndex: Integer;
begin
  if fPlayingIndex = fPlaylist.Count - 1 then
    result := 0
  else
    result := fPlayingIndex + 1;
end;

function TMeMPPlaylist.GetPrevAudioFileIndex: Integer;
begin
  if fPlayingIndex = 0 then
    result := fPlaylist.Count - 1
  else
    result := fPlayingIndex - 1;
end;

// ================================================
// Playlist-Dateien laden und speichern
// ================================================
procedure TMeMPPlaylist.LoadFromM3U(aFilename: String);
var mylist: tStringlist;
  i: Integer;
  s: String;
begin
  mylist := TStringlist.Create;
  mylist.LoadFromFile(aFilename);
  if (myList.Count > 0) then
  begin
    if (myList[0] = '#EXTM3U') then //Liste ist im EXT-Format
    begin
      i := 1;
      while (i < myList.Count) do
      begin
        // Zuerst kommen ggf. die ExtInf-Daten
        s := myList[i];
        if trim(s) = '' then
          inc(i)
        else
        begin
          if (copy(s,0,7) = '#EXTINF') then // ExtInf-Zeile überspringen
            inc(i);
          Add(ExpandFilename(myList[i]));
          inc(i);
        end;
      end;
    end
    else
      // Liste ist nicht im EXT-Format - einfach nur Dateinamen
      for i := 0 to myList.Count - 1 do
      begin
        if trim(mylist[i])='' then continue;
        Add(ExpandFilename(myList[i]));
      end;
  end;
  FreeAndNil(myList);
end;

procedure TMeMPPlaylist.LoadFromFile(aFilename: String);
begin
  if LowerCase(ExtractFileExt(aFilename)) = '.m3u' then
    LoadFromM3U(aFilename);
end;


procedure TMeMPPlaylist.SaveAsM3U(aFilename: String);
var myList: tStringlist;
    i:integer;
    aAudiofile: TAudioFile;
begin
  myList := TStringList.Create;
  myList.Add('#EXTM3U');
  for i := 0 to fPlayList.Count - 1 do
  begin
    aAudiofile := fPlaylist[i] as TAudioFile;
    myList.add('#EXTINF:' + IntTostr(aAudiofile.Dauer) + ','
          + aAudioFile.Interpret + ' - ' + aAudioFile.Titel);
    myList.Add(ExtractRelativePath(aFilename, aAudioFile.Pfad ));
  end;
  myList.SaveToFile(afilename);
  FreeAndNil(myList);
end;

procedure TMeMPPlaylist.SaveToFile(aFilename: String);
begin
  if LowerCase(ExtractFileExt(aFilename)) = '.m3u' then
    SaveAsM3U(aFilename);
end;


end.
