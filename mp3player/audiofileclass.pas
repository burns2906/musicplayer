unit audiofileclass;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,unit2_u;
type
 TAudioFile = class
    private
        fInterpret: String;
        fTitel    : String;
        fAlbum    : String;
        fPfad     : String;
        fDauer    : Integer;

        procedure GetMp3Info;
        //procedure GetWmaInfo;
        procedure SetUnknown;

        function GetPlaylistTitel: String;

    public
        property Interpret: String read fInterpret write fInterpret;
        property Titel    : String read fTitel     write fTitel;
        property Album    : String read fAlbum     write fAlbum;
        property Pfad     : String read fPfad;
        property Dauer    : Integer read fDauer write fDauer;
        property PlaylistTitel: String read GetPlaylistTitel;

        constructor Create;
        destructor Destroy; override;

        procedure GetAudioInfo(filename: String);
        procedure Assign(aAudioFile: TAudioFile);
    end;


implementation


constructor TAudioFile.create;
begin
  inherited create;
  // hier könnte man einige Dinge initialisieren
end;


destructor TAudioFile.Destroy;
begin
  // hier müsste man einiges freigeben, wenn man die Klasse
  // erweitert
  inherited destroy;
end;


procedure TAudioFile.Assign(aAudioFile: TAudioFile);
begin
  fInterpret := aAudioFile.fInterpret;
  fTitel     := aAudioFile.fTitel    ;
  fAlbum     := aAudioFile.fAlbum    ;
  fPfad      := aAudioFile.fPfad     ;
  fDauer     := aAudioFile.fDauer    ;
end;






  procedure TAudioFile.GetAudioInfo(filename: String);
begin
  fPfad := filename;
  if (AnsiLowerCase(ExtractFileExt(filename)) = '.mp3') then
    GetMp3Info
  else
    if AnsiLowerCase(ExtractFileExt(filename)) = '.wma' then
      //GetWMAInfo
    else
     SetUnknown;
end;

procedure TAudioFile.GetMp3Info;
var mpegInfo: TMpegInfo;
    ID3v2Tag: TID3V2Tag;
    ID3v1tag: TID3v1Tag;
    Stream: TFileStream;
begin
  // Daten mit MP3FileUtils auslesen
   try
    mpeginfo:=TMpegInfo.Create;
    ID3v2Tag:=TID3V2Tag.Create;
    ID3v1tag:=TID3v1Tag.Create;
    stream := TFileStream.Create(fPfad, fmOpenRead or fmShareDenyWrite);
    id3v1tag.ReadFromStream(stream);
    stream.Seek(0, sobeginning);
    id3v2tag.ReadFromStream(stream);
    if Not id3v2Tag.exists then
      stream.Seek(0, sobeginning)
    else
     stream.Seek(id3v2tag.size, soFromBeginning);
    mpeginfo.LoadFromStream(Stream);
    //stream.free;

    // Daten auf unser Geruest uebertragen
    if mpeginfo.Filesize>0 then
    if mpeginfo.FirstHeaderPosition > -1 then
      begin
       if id3v2tag.album <> '' then
        fAlbum := id3v2tag.album
       else
        fAlbum := id3v1tag.album;
       if id3v2tag.artist <> '' then
        fInterpret := id3v2tag.artist
       else
        fInterpret := id3v1tag.artist;
       if id3v2tag.title <> '' then
        fTitel := id3v2tag.title
       else
        if id3v1tag.title <> '' then
         fTitel := id3v1tag.title

        else
         fTitel := ExtractFileName(fPfad);
       fDauer   := mpeginfo.dauer;
      end
      else
        //SetUnknown;
        MpegInfo.Free;
        Id3v2Tag.Free;
        Id3v1Tag.Free;
    except end;

end;

  function TAudioFile.GetPlaylistTitel: String;
begin
  if Trim(fInterpret) = '' then
    result := fTitel
  else
    result := fInterpret + ' - ' + fTitel;
end;

procedure TAudioFile.SetUnknown;
begin
  fTitel := ExtractFileName(fPfad);
  fInterpret := '';
  fDauer := 0;
end;

 
end.
