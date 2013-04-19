unit main_u;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,unit2_u,audiofileclass,playerclass,playlistclass,bass, ExtCtrls,mySQL,
  XPMan, ColorButton, ActnList, Buttons;

type
  TForm1 = class(TForm)
    auswahlOpenDialog: TOpenDialog;
    mainScrollBar: TScrollBar;
    volumeScrollBar: TScrollBar;
    lbltitel: TLabel;
    lbltime: TLabel;
    maintimer: TTimer;
    ListBox1: TListBox;
    ListBox2: TListBox;
    ListBox3: TListBox;
    Edit2: TEdit;
    btn_up: TButton;
    btn_down: TButton;
    ListBox4: TListBox;
    Button11: TButton;
    btn_dbupdate: TButton;
    btn_options: TButton;
    btn_rpopen: TButton;
    playlistsavedlg: TSaveDialog;
    playlistopendlg: TOpenDialog;
    Button15: TButton;
    Panel1: TPanel;
    Panel2: TPanel;
    ListBox5: TListBox;
    dlg_autosave: TSaveDialog;
    btn_autosave: TBitBtn;
    btn_remove: TBitBtn;
    btn_import: TBitBtn;
    btn_add: TBitBtn;
    btn_plsave: TBitBtn;
    btn_plopen: TBitBtn;
    btn_birthday: TBitBtn;
    btn_suederhof: TBitBtn;
    Button8: TBitBtn;
    btnplaypause: TBitBtn;
    btn_next: TBitBtn;
    Button2: TBitBtn;
    XPManifest1: TXPManifest;
    procedure btn_importClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnplaypauseClick(Sender: TObject);
    procedure maintimerTimer(Sender: TObject);
    procedure mainScrollBarScroll(Sender: TObject; ScrollCode: TScrollCode;
      var ScrollPos: Integer);
    procedure volumeScrollBarScroll(Sender: TObject; ScrollCode: TScrollCode;
      var ScrollPos: Integer);
    procedure btn_nextClick(Sender: TObject);
    procedure btn_upClick(Sender: TObject);
    procedure btn_downClick(Sender: TObject);
    procedure btn_dbupdateClick(Sender: TObject);
    procedure btn_addClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure btn_removeClick(Sender: TObject);
    procedure ListBox3DblClick(Sender: TObject);
    procedure ListBox2DblClick(Sender: TObject);
    procedure ListBox2DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure ListBox2DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure ListBox2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ListBox3MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Edit2KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ListBox2KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ListBox3KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btn_optionsClick(Sender: TObject);
    procedure btn_plsaveClick(Sender: TObject);
    procedure btn_plopenClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Button15Click(Sender: TObject);
    procedure btn_rpopenClick(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure btn_suederhofClick(Sender: TObject);
    procedure btn_birthdayClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btn_autosaveClick(Sender: TObject);
    //procedure btnClick(Sender: TObject);
    
    
  private
    { Private declarations }
  public
    { Public declarations }
  end;



var
  Form1: TForm1;
  Id3v1Tag: TId3v1Tag;
Id3v2Tag:TID3v2Tag;
stream:Tstream;
globalaudiofile,audiofile2:TAudiofile;
mpeginfo:Tmpeginfo;
mempplayer:Tmempplayer;

LibHandle: PMYSQL;
mySQL_Res: PMYSQL_RES;
myRow: PMySQL_Row;
  sql: String;
  my_sql: AnsiString;
  tablename: String;
  foundfiles:integer;
  

   interpret,titel,album,pfad,randompool,playlisttitlesave,playlistpathsave:array of string;
   dbhost,dbname,dbpass,dbuser,musikordner,adminpass,randomlieder,dbupdatetest,hbsong:string;
   autosavefile:TextFile;
   autosave:bool;
   StartingPoint : TPoint;
implementation

uses Unit2,optionsform_u,loaddb_u;

{$R *.dfm}
procedure openconfig();
var
   myFile : TextFile;
   text   : string;
   conf  :array of string;
   i:integer;

 begin
   setlength(conf,10);
   i:=0;
   // Try to open the Test.txt file for writing to
   AssignFile(myFile, 'config.con');
  // Reopen the file for reading
   Reset(myFile);

   // Display the file contents
   while not Eof(myFile) do
   begin
     ReadLn(myFile, text);
     conf[i]:=text;
     i:=i+1;
   end;

   // Close the file for the last time
   CloseFile(myFile);
   dbhost:=conf[0];
   dbuser:=conf[1];
   dbpass:=conf[2];
   dbname:=conf[3];
   musikordner:=conf[4];
   adminpass:=conf[5];
   hbsong:=conf[6];
   randomlieder:=conf[7];
   dbupdatetest:=conf[8];


 end;

 procedure connectdb();
begin
if mySQL_Res<>nil then mysql_free_result(mySQL_Res);
 mySQL_Res := nil;
 if LibHandle<>nil then begin
                          mysql_close(LibHandle);
                           LibHandle := nil;
                         end;
  LibHandle := mysql_init(nil);
  if LibHandle=nil then raise Exception.Create('mysql_init failed');

  if mysql_real_connect(LibHandle,
                        PAnsiChar(AnsiString(dbhost)),
                        PAnsiChar(AnsiString(dbuser)),
                        PAnsiChar(AnsiString(dbpass)),
                        PAnsiChar(AnsiString(dbname)), 0, nil, 0)=nil
  then
    raise Exception.Create(UnicodeString(mysql_error(LibHandle)));
end;



  procedure readdb();
var i,j, field_count: Integer;
p:string;
begin
 form1.ListBox3.Clear;
 form1.listbox4.Clear;
 connectdb();
  sql := 'SELECT * FROM  `all` ORDER BY interpret,titel ASC';
  my_sql := AnsiString(sql);

  if mysql_real_query(LibHandle, PAnsiChar(my_sql), Length(my_sql))<>0
  then
    raise Exception.Create(UnicodeString(mysql_error(LibHandle)));
  mySQL_Res := mysql_store_result(LibHandle);
  if mySQL_Res<>nil
  then begin
    field_count := mysql_num_rows(mySQL_Res);
    SetLength(titel, field_count);
     SetLength(interpret, field_count);
     SetLength(album, field_count);
     SetLength(pfad, field_count);
     SetLength(randompool,1);
     j:=0;
    for i := 0 to field_count - 1 do
    begin
      myrow := mysql_fetch_row(mySQL_Res);
      if myrow<>nil
      then begin
      form1.ListBox3.items.add(myrow[2]+' - '+myrow[1]);
      titel[i]:=myrow[1];
      interpret[i]:=myrow[2];
      album[i]:=myrow[3];
      p:=StringReplace(myrow[4], '*b*', '\',[rfReplaceAll, rfIgnoreCase]);
      pfad[i]:=p;
      if(myrow[5]='true') then begin SetLength(randompool,j+1);
                                     randompool[j]:=p;
                                     j:=j+1;

                                end;
      form1.listbox4.Items.add(p);
      end;
    end;
end;

end;

procedure loadrandompool();
var i, field_count: Integer;
p:string;
begin
 form1.ListBox2.Clear;
 form1.listbox1.Clear;
 connectdb();
  sql := 'SELECT * FROM  `all` WHERE `randompool`="true" ORDER BY interpret ASC';
  my_sql := AnsiString(sql);

  if mysql_real_query(LibHandle, PAnsiChar(my_sql), Length(my_sql))<>0
  then
    raise Exception.Create(UnicodeString(mysql_error(LibHandle)));
  mySQL_Res := mysql_store_result(LibHandle);
  if mySQL_Res<>nil
  then begin
    field_count := mysql_num_rows(mySQL_Res);
    //SetLength(titel, field_count);
     //SetLength(interpret, field_count);
     //SetLength(pfad, field_count);

    for i := 0 to field_count - 1 do
    begin
      myrow := mysql_fetch_row(mySQL_Res);
      if myrow<>nil
      then begin
      form1.ListBox2.items.add(myrow[2]+' - '+myrow[1]);
     // titel[i]:=myrow[1];
      //interpret[i]:=myrow[2];
      p:=StringReplace(myrow[3], '*b*', '\',[rfReplaceAll, rfIgnoreCase]);
      //pfad[i]:=p;
      form1.listbox1.Items.add(p);
      end;
    end;
end;

end;


   procedure TForm1.FormCreate(Sender: TObject);
begin
Id3v1Tag := TId3v1Tag.Create;
  Id3v2Tag := TId3v2Tag.Create;
  mpegInfo := TMpegInfo.Create;
  globalaudiofile:=TAudiofile.create;
   GlobalAudioFile := TAudioFile.Create;
   autosave:=false;
   
  MeMPPlayer := TMeMPPlayer .Create;
  MeMPPlayer.InitBassEngine(Handle);
  MeMPPlayer.Volume := 100;
  MeMPPlayer.InitPlugins(ExtractFileDir(ParamStr(0)));
  openconfig();
   libmysql_fast_load(nil);


   setlength(playlisttitlesave,1);
   setlength(playlistpathsave,1);
   //form1.Show();
   readdb();
end;

procedure FileSearch(const PathName, FileName : string; const InDir : boolean);
var Rec  : TSearchRec;
    Path : string;
    itemcount:integer;
begin
Path := IncludeTrailingBackslash(PathName);
if FindFirst(Path + FileName, faAnyFile - faDirectory, Rec) = 0 then
 try
    while(FindNext(Rec) = 0) do
     begin
     //form1.ListBox3.Items.Add(Path + Rec.Name);
     globalaudiofile.GetAudioInfo(Path + Rec.Name);
     form1.ListBox4.Items.Add(globalaudiofile.titel+' - '+globalaudiofile.interpret);
     SetLength(titel, form1.listbox4.Items.count);
     SetLength(interpret, form1.listbox4.Items.count);
     SetLength(pfad, form1.listbox4.Items.count);
     SetLength(album, form1.listbox4.Items.count);
     itemcount:=form1.ListBox4.Items.Count-1;
     //form1.ListBox4.Items.Add(globalaudiofile.titel+' - '+globalaudiofile.interpret);
     titel[itemcount]:=globalaudiofile.titel;
     interpret[itemcount]:=globalaudiofile.interpret;
     album[itemcount]:=globalaudiofile.Album;
     pfad[itemcount]:=Path + Rec.Name;

       foundfiles:=foundfiles+1;

       splashscreen.Label2.Caption:='Suche '+filename+' Files '+inttostr(itemcount);
       splashscreen.Update;
     end;
 finally
   FindClose(Rec);
 end;

If not InDir then Exit;

if FindFirst(Path + '*.*', faDirectory, Rec) = 0 then
 try
     while(FindNext(Rec) = 0) do
    if ((Rec.Attr and faDirectory) <> 0)  and (Rec.Name<>'.') and (Rec.Name<>'..') then
     FileSearch(Path + Rec.Name, FileName, True);

 finally
   FindClose(Rec);
 end;
end;




procedure renewdb();
var i:integer;p,text:string;myfile:textfile;
    time1,time2:integer;
   // fileendings:array of string;

begin
      time1:=gettickcount;
     form1.listbox3.clear;
     form1.listbox4.clear;
     foundfiles:=0;
     //form1.Caption:='Suche MP3 Files';
     //fileendings[0]:='*.mp3';
     //fileendings[1]:='*.wav';
     splashscreen.Label2.Caption:='Suche Musik Files ';
     splashscreen.Update;
     FileSearch(musikordner, '*.mp3', true);
     FileSearch(musikordner, '*.wav', true);
     FileSearch(musikordner, '*.ogg', true);
     //form1.Caption:='Suche Ogg Files';
     //foundfiles:=0;
     //FileSearch(musikordner, '*.ogg', true);
     //FileSearch('G:\musik', '*.*', true);
     //form1.Caption:='update db';
     //SetLength(titel, form1.listbox3.Items.count);
     //SetLength(interpret, form1.listbox3.Items.count);
     //SetLength(pfad, form1.listbox3.Items.count);
    if(dbupdatetest='ja') then begin
     for i:=0 to form1.ListBox3.Items.Count-1 do
     begin
        form1.Caption:='Teste Files '+inttostr(i)+'/'+inttostr(form1.listbox3.Count-1);
         if(mempplayer.IsPlayableFile(form1.ListBox3.Items[i])=true) then
         begin
           globalaudiofile.GetAudioInfo(form1.ListBox3.Items[i]);
           form1.ListBox4.Items.Add(globalaudiofile.titel+' - '+globalaudiofile.interpret);
           titel[i]:=globalaudiofile.titel;
           album[i]:=globalaudiofile.album;
           pfad[i]:=form1.listbox3.Items[i];
           interpret[i]:=globalaudiofile.interpret;

         end;
         //if(mempplayer.IsPlayableFile(form1.ListBox3.Items[i])=false) then form1.listbox6.items.add(form1.ListBox3.Items[i]);
     end;
     end;//if dbupdatetest
    {if(dbupdatetest='nein') then begin
     for i:=0 to form1.ListBox3.Items.Count-1 do
      begin
      globalaudiofile.GetAudioInfo(form1.ListBox3.Items[i]);
           form1.ListBox4.Items.Add(globalaudiofile.titel+' - '+globalaudiofile.interpret);
           titel[i]:=globalaudiofile.titel;
           pfad[i]:=form1.listbox3.Items[i];
           interpret[i]:=globalaudiofile.interpret;
           end;
      end; }
     splashscreen.Label2.Caption:='Speichere Files in DB ';
     splashscreen.Update;
    connectdb();
     mysql_query(LibHandle, pansichar('DROP TABLE `all`'));
     mysql_query(LibHandle, pansichar('CREATE TABLE `all` (`id` INT( 10 ) NOT NULL AUTO_INCREMENT PRIMARY KEY ,`titel` LONGTEXT NOT NULL ,`interpret` LONGTEXT NOT NULL ,`album` LONGTEXT NOT NULL , `pfad` LONGTEXT NOT NULL , `randompool` TEXT NOT NULL) ENGINE = MYISAM ;'));
     for i:=0 to high(titel) do
     begin
     //if (i mod 100) then
     splashscreen.Label2.Caption:='Speichere Files in DB '+inttostr(i)+'/'+inttostr(high(titel));
     splashscreen.Update;
     if (titel[i]<>'') then begin
     pfad[i]:=StringReplace(pfad[i], '\', '*b*',
                          [rfReplaceAll, rfIgnoreCase]);
     sql :='INSERT INTO `all` (`titel` ,`interpret` ,`album`,`pfad`)VALUES ("'+titel[i]+'", "'+interpret[i]+'", "'+album[i]+'", "'+pfad[i]+'")';
     //my_sql := AnsiString(sql);
     mysql_query(LibHandle, pansichar(sql));
        end;
     end;   
     form1.ListBox3.Clear;
     form1.listbox4.Clear;
    {form1.Caption:='Speichere Randompool';
     AssignFile(myFile,'randompool.con');
    Reset(myFile);
    form1.listbox5.clear;
      while not Eof(myFile) do
       begin
        ReadLn(myFile, text);
        form1.ListBox5.Items.Add(text);
       end;
       closefile(myfile);
      for i:=0 to form1.ListBox5.Count-1 do begin
      p:=StringReplace(form1.ListBox5.Items[i], '\', '*b*',[rfReplaceAll, rfIgnoreCase]);
      sql :='UPDATE `all` SET `randompool`="true" WHERE `pfad`="'+p+'"';
     //my_sql := AnsiString(sql);
     mysql_query(LibHandle, pansichar(sql));
      end;}

      splashscreen.Label2.Caption:='';
      splashscreen.Label1.Caption:='DATENBANK WIRD GELADEN';
      splashscreen.Update;
     readdb();
     splashscreen.hide;
     splashscreen.free;
     time2:=gettickcount;
     time1:=time1 div 1000;
     time2:=time2 div 1000;
     //form1.Caption:='Musicplayer (C) Burns Club Lerchenfelderheim';
     ShowMessage('Datenbank wurde aktualisiert '+inttostr(foundfiles)+' Dateien gefunden :)'+' zeit: '+inttostr(time2-time1)+ ' sekunden');


end;











procedure playnext();
    begin
      if(form1.listbox1.Items.count=0) then
        begin
           randomize();
            if(randomlieder='alle') then
               globalaudiofile.getaudioinfo(pfad[random(high(pfad))]);
            if(randomlieder='pool') then
                globalaudiofile.getaudioinfo(randompool[random(high(randompool))]);
            if (MeMPPlayer.IsPlayableFile(GlobalAudioFile.pfad)) then
              begin
                if(autosave=true) then
                  writeln(autosavefile,GlobalAudioFile.pfad);
                MeMPPlayer.Play(GlobalAudioFile);
              end
            else playnext();
           form1.LblTitel.Caption := GlobalAudioFile.PlaylistTitel;
        end;
      if(form1.listbox1.items.count<>0) then
        begin
          globalaudiofile.getaudioinfo(form1.ListBox1.items[0]);


          form1.ListBox1.ItemIndex:=0;
          form1.listbox1.DeleteSelected;
          form1.ListBox2.ItemIndex:=0;
          form1.listbox2.DeleteSelected;
          if (MeMPPlayer.IsPlayableFile(GlobalAudioFile.pfad)) then
            begin
              if (autosave=true) then
              writeln(autosavefile,GlobalAudioFile.pfad);
              MeMPPlayer.Play(GlobalAudioFile);
            end
          else playnext();

          form1.LblTitel.Caption := GlobalAudioFile.PlaylistTitel;
        end;

    end;

procedure move(i,j:integer);
var startitem,startitem2,enditem,enditem2:string;
begin
 if((i<>-1) and (j<>-1)) then
  if ((form1.ListBox1.Items.count-1>=i) and (form1.ListBox1.Items.count-1>=j)) then
    begin
 startitem:=form1.ListBox1.Items[i];
 startitem2:=form1.ListBox2.Items[i];
 enditem:=form1.ListBox1.Items[j];
 enditem2:=form1.ListBox2.Items[j];
  //tausch
 form1.ListBox1.Items[i]:=enditem;
 form1.ListBox2.Items[i]:=enditem2;
 form1.ListBox1.Items[j]:=startitem;
 form1.ListBox2.Items[j]:=startitem2;
   end;
end;





procedure TForm1.btnplaypauseClick(Sender: TObject);
begin

  case MeMPPlayer.BassStatus of
    BASS_ACTIVE_STOPPED:
      begin
       playnext();
      end;
    BASS_ACTIVE_PLAYING: MeMPPlayer.Pause;
    BASS_ACTIVE_PAUSED : MeMPPlayer.Resume;
  end;
end;

procedure TForm1.btn_importClick(Sender: TObject);
begin
 if AuswahlOpenDialog.Execute then
  begin
    if MeMPPlayer.IsPlayableFile(AuswahlOpenDialog.FileName) then
    begin
      globalaudiofile.GetAudioInfo(AuswahlOpenDialog.FileName);
      form1.ListBox1.Items.Add(AuswahlOpenDialog.FileName);
      form1.listbox2.Items.add(globalaudiofile.playlisttitel);

    end else
      Showmessage('Die Datei kann nicht abgespielt werden.');
  end;
end;





procedure TForm1.mainScrollBarScroll(Sender: TObject; ScrollCode: TScrollCode;
  var ScrollPos: Integer);
begin
     MeMPPlayer.Progress := ScrollPos / 100;
end;

procedure TForm1.maintimerTimer(Sender: TObject);
var t: integer;
begin
  MainScrollbar.Position := Round(MeMPPlayer.Progress * 100);
  t := Round(mempplayer.Dauer-MeMPPlayer.Time);

  LblTime.Caption := Format('%.2d:%.2d',[t Div 60, t Mod 60]);
  if(mainscrollbar.Position=100) then
    begin
       playnext();
    end;
end;




procedure TForm1.volumeScrollBarScroll(Sender: TObject; ScrollCode: TScrollCode;
  var ScrollPos: Integer);
  var vol:integer;
begin
  vol:=ScrollPos-100;
  vol:=-vol;
MeMPPlayer.Volume := vol / 100;
end;

procedure TForm1.btn_nextClick(Sender: TObject);
begin
playnext();
end;

procedure TForm1.btn_upClick(Sender: TObject);
var i:integer;
begin
if(form1.listbox2.ItemIndex<>0) then
begin
i:=form1.listbox2.itemindex;
form1.ListBox2.Items.move(i,i-1);
form1.ListBox1.Items.Move(i,i-1);
form1.listbox2.ItemIndex:=i-1;
end;
end;
procedure TForm1.btn_downClick(Sender: TObject);
var i:integer;
begin
if(form1.listbox2.ItemIndex<>form1.listbox2.Items.count-1) then
begin
i:=form1.listbox2.itemindex;
form1.ListBox2.Items.move(i,i+1);
form1.ListBox1.Items.Move(i,i+1);
form1.listbox2.ItemIndex:=i+1;
end;
end;

procedure TForm1.btn_dbupdateClick(Sender: TObject);
begin
splashscreen:=Tsplashscreen.Create(Application);
splashscreen.Label1.Caption:='DATENBANK WIRD AKTUALISIERT';
splashscreen.Show;

renewdb();
//splashscreen.hide;
end;

procedure TForm1.btn_addClick(Sender: TObject);
var p:string;
begin
if(form1.listbox3.itemindex<>-1) then begin
form1.ListBox2.Items.add(form1.ListBox3.Items[form1.ListBox3.Itemindex]);
form1.ListBox1.Items.add(form1.ListBox4.Items[form1.ListBox3.Itemindex]);
if(form1.btn_rpopen.enabled=false) then
  begin
  connectdb();
  p:=StringReplace(form1.ListBox4.items[form1.listbox3.Itemindex], '\', '*b*',[rfReplaceAll, rfIgnoreCase]);
  sql :='UPDATE `all` SET `randompool`="true" WHERE `pfad`="'+p+'"';
  mysql_query(LibHandle, pansichar(sql));
  end;
end;


end;

procedure TForm1.Button2Click(Sender: TObject);
var i:integer;
begin
    if(form1.edit2.text<>'') then begin
    listbox3.Items.clear;
    listbox4.Items.clear;

    for i:=0 to high(titel) do
    begin
      if(pos(uppercase(edit2.Text),uppercase(titel[i]))<>0) then begin
                                          form1.listbox3.Items.add(interpret[i]+' - '+titel[i]);
                                          form1.ListBox4.Items.add(pfad[i]);
                                          end;
      if(pos(uppercase(edit2.Text),uppercase(interpret[i]))<>0) then begin
                                          form1.listbox3.Items.add(interpret[i]+' - '+titel[i]);
                                          form1.ListBox4.Items.add(pfad[i]);
                                          end;

    end;
     for i:=0 to high(album) do
      if(pos(uppercase(edit2.Text),uppercase(album[i]))<>0) then begin
                                          form1.listbox3.Items.add(interpret[i]+' - '+titel[i]);
                                          form1.ListBox4.Items.add(pfad[i]);
                                          end;
 end;
end;

procedure TForm1.Button11Click(Sender: TObject);
var i:integer;myfile:textfile;text,pfadstr,p:string;
begin


   
if (form1.Button11.caption='Adminmodus') then
begin
//loginform:=tloginform.create(Application);
//loginform.Create(Application);
loginform.ed_action.text:='open adminmode';
loginform.Show;
form1.Update;
end
else if (form1.btn_rpopen.Enabled=false) then
        {begin
         AssignFile(myFile,'randompool.con');
         ReWrite(myFile);
        { for i:=0 to form1.ListBox2.Items.Count-1 do
          begin
           WriteLn(myFile,form1.listbox1.items[i]);
           pfadstr:=form1.ListBox1.items[i];
           connectdb();
           SetLength(randompool,i+1);
           randompool[i]:=pfadstr;
           p:=StringReplace(pfadstr, '\', '*b*',[rfReplaceAll, rfIgnoreCase]);
           sql :='UPDATE `all` SET `randompool`="true" WHERE `pfad`="'+p+'"';
           mysql_query(LibHandle, pansichar(sql));
          end;
        CloseFile(myFile);
        form1.ListBox1.Clear;
        form1.ListBox2.clear;
        {if(high(playlisttitlesave)>1) then
          begin
            for i:=0 to high(playlisttitlesave) do
              begin
              form1.ListBox1.Items.Add(playlistpathsave[i]);
              form1.ListBox2.Items.Add(playlisttitlesave[i]);
              end;
            setlength(playlistpathsave,1);
            setlength(playlisttitlesave,1);
          end;
        end; }



     form1.Panel2.Caption:='Playlist';
    // form1.btnplaypause.enabled:=true;
     //form1.Btn_import.Enabled:=true;
     //form1.Btn_next.Enabled:=true;
     //form1.btn_up.Enabled:=true;
     //form1.btn_down.Enabled:=true;
     form1.btn_plopen.Enabled:=true;
     form1.btn_plsave.Enabled:=true;
     form1.Button11.Enabled:=true;
     form1.Button15.Enabled:=true;

     form1.btn_dbupdate.Hide;
     form1.btn_options.Hide;
     form1.btn_rpopen.hide;


     form1.Button11.Caption:='Adminmodus';
    //end;
end;

procedure TForm1.btn_removeClick(Sender: TObject);
var p:string;
begin
if(form1.listbox2.itemindex<>-1) then begin
  if(form1.btn_rpopen.enabled=false) then
  begin
  connectdb();
  p:=StringReplace(form1.ListBox1.items[form1.listbox2.Itemindex], '\', '*b*',[rfReplaceAll, rfIgnoreCase]);
  sql :='UPDATE `all` SET `randompool`="false" WHERE `pfad`="'+p+'"';
  mysql_query(LibHandle, pansichar(sql));
  end;
form1.ListBox1.Items.Delete(form1.ListBox2.Itemindex);
form1.ListBox2.Items.Delete(form1.ListBox2.Itemindex);



end;
end;

procedure TForm1.ListBox3DblClick(Sender: TObject);
begin
form1.btn_add.Click;
end;

procedure TForm1.ListBox2DblClick(Sender: TObject);
var i:integer;
begin
if(form1.listbox2.itemindex<>-1) then
      begin
        i:=form1.listbox2.itemindex;
      form1.ListBox2.Items.Move(i,0);
      form1.ListBox1.Items.Move(i,0);

      end;
end;









procedure TForm1.ListBox2DragDrop(Sender, Source: TObject; X, Y: Integer);
var
   DropPosition, StartPosition: Integer;
   DropPoint: TPoint;
begin
   DropPoint.X := X;
   DropPoint.Y := Y;
   with Source as TListBox do
   begin
     if(Source=listbox2) then begin
     StartPosition := ItemAtPos(StartingPoint,True) ;
     DropPosition := ItemAtPos(DropPoint,True) ;
     Items.Move(StartPosition, DropPosition) ;
     form1.ListBox1.Items.Move(Startposition,Dropposition);
     end;

   end;
       if(Source=listbox3) then begin
        StartPosition :=form1.ListBox3.ItemAtPos(StartingPoint,True) ;
        DropPosition:=form1.ListBox2.ItemAtPos(DropPoint,True) ;
        form1.ListBox2.Items.Insert(Dropposition,form1.ListBox3.Items[startposition]);
        form1.ListBox1.Items.Insert(dropposition,form1.ListBox4.Items[startposition]);
       end;
end;

procedure TForm1.ListBox2DragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
   if(Source=ListBox2) then Accept:=true;
   if(Source=ListBox3) then Accept:=true;

   
end;

procedure TForm1.ListBox2MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
     StartingPoint.X := X;
   StartingPoint.Y := Y;
end;

procedure TForm1.ListBox3MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
     StartingPoint.X := X;
   StartingPoint.Y := Y;
end;

procedure TForm1.Edit2KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     if(key=VK_RETURN) then form1.Button2.Click;
end;

procedure TForm1.ListBox2KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if(key=VK_DELETE)then form1.btn_remove.Click;
end;

procedure TForm1.ListBox3KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if(key=VK_RETURN) then form1.btn_add.Click;
end;

procedure TForm1.btn_optionsClick(Sender: TObject);
begin
form3.show();
form3.GroupBox1.Visible:=true;
       form3.edit1.Text:=dbhost;
       form3.edit3.text:=dbuser;
      form3.edit4.text:=dbpass;
      form3.edit5.Text:=dbname;
      form3.edit6.text:=musikordner;
      form3.edit7.Text:=adminpass;
      form3.edit_hbsong.Text:=hbsong;
      
      if(randomlieder='pool') then form3.RadioButton2.Checked:=true;
      if(randomlieder='alle') then form3.RadioButton1.Checked:=true;
      if(dbupdatetest='ja') then form3.RadioButton3.Checked:=true;
      if(dbupdatetest='nein') then form3.RadioButton4.Checked:=true;
end;

procedure TForm1.btn_plsaveClick(Sender: TObject);
var i:integer;
    myfile:textfile;
begin
if listbox1.Items.Count>0 then begin
 if playlistsavedlg.Execute then
  begin
   AssignFile(myFile, playlistsavedlg.FileName);
   ReWrite(myFile);
   for i:=0 to form1.ListBox1.Items.Count-1 do
   begin
     WriteLn(myFile,form1.listbox1.items[i]);
   end;
    CloseFile(myFile);
    ShowMessage('Playlist gespeichert');
  end;
 end;
end;

procedure TForm1.btn_plopenClick(Sender: TObject);
var text:string;
    myfile:textfile;
begin
  if form1.playlistopendlg.Execute then
    begin
      AssignFile(myFile, form1.playlistopendlg.FileName);
      Reset(myFile);
      while not Eof(myFile) do
       begin
        ReadLn(myFile, text);
       if MeMPPlayer.IsPlayableFile(text) then
         begin
          form1.ListBox1.Items.Add(text);
          globalaudiofile.GetAudioInfo(text);
          form1.listbox2.Items.add(globalaudiofile.playlisttitel);
         end;
       end;

   // Close the file for the last time
   CloseFile(myFile);
  end;
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
CanClose:=false;
if(loginform.ed_action.text='close') then CanClose:=true;
loginform.ed_action.text:='close programm';
loginform.Show;
end;

procedure TForm1.Button15Click(Sender: TObject);
var pfadstr,p,text:string;myfile:textfile;i:integer;
begin
if (mempplayer.BassStatus<>BASS_ACTIVE_PLAYING) and (form1.ListBox2.ItemIndex<>-1) then
 begin
     pfadstr:=form1.ListBox1.items[form1.ListBox2.itemindex];

      setlength(randompool,sizeof(randompool));
      randompool[sizeof(randompool)]:=pfadstr;
      connectdb();
      p:=StringReplace(pfadstr, '\', '*b*',[rfReplaceAll, rfIgnoreCase]);

      sql :='UPDATE `all` SET `randompool`="true" WHERE `pfad`="'+p+'"';
      mysql_query(LibHandle, pansichar(sql));

      Showmessage('hinzugefügt');

 end;
if (mempplayer.BassStatus=BASS_ACTIVE_PLAYING) then
begin
    pfadstr:=globalaudiofile.Pfad;
    setlength(randompool,sizeof(randompool));
      randompool[sizeof(randompool)]:=pfadstr;
    connectdb();
      p:=StringReplace(pfadstr, '\', '*b*',[rfReplaceAll, rfIgnoreCase]);

      sql :='UPDATE `all` SET `randompool`="true" WHERE `pfad`="'+p+'"';


      mysql_query(LibHandle, pansichar(sql));

      Showmessage('hinzugefügt');
end;
AssignFile(myFile,'randompool.con');
    Reset(myFile);
    form1.listbox5.clear;
      while not Eof(myFile) do
       begin
        ReadLn(myFile, text);
        form1.ListBox5.Items.Add(text);
       end;
    ReWrite(myFile);
   for i:=0 to form1.ListBox5.Items.Count-1 do
   begin
     WriteLn(myFile,form1.listbox5.items[i]);
   end;
   WriteLn(myFile,pfadstr);
    CloseFile(myFile);
     form1.listbox5.clear;

end;

procedure TForm1.btn_rpopenClick(Sender: TObject);
var i:integer;
begin
     form1.panel2.Caption:='Randompool';
     if  (form1.ListBox1.Count>0) then
     begin
     setlength(playlistpathsave,form1.ListBox1.Count);
     setlength(playlisttitlesave,form1.ListBox1.Count);
      for i:=0 to form1.ListBox1.Count-1 do
       begin
      playlistpathsave[i]:=form1.ListBox1.Items[i];
      playlisttitlesave[i]:=form1.ListBox2.Items[i];
       end;

     end;
     loadrandompool();
     form1.btnplaypause.enabled:=false;
     //form1.Button1.Enabled:=false;
     //form1.Button3.Enabled:=false;
     //form1.Button6.Enabled:=false;
     //form1.Button7.Enabled:=false;
     //form1.Button12.Enabled:=false;
     //form1.Button13.Enabled:=false;
     //form1.Button14.Enabled:=false;
     //form1.Button15.Enabled:=false;

end;

procedure TForm1.Button8Click(Sender: TObject);
var rand,i:integer;
begin
 randomize();
 rand:=random(listbox2.Items.Count-1);
  for i:=0 to listbox2.Items.Count-1 do
    begin
      listbox1.Items.Move(i,rand);
      listbox2.Items.Move(i,rand);
    end;

end;

procedure TForm1.btn_suederhofClick(Sender: TObject);
var i,ind:integer;
begin
 for i:=0 to high(titel) do
 if (pos(uppercase('kinder vom s'),uppercase(titel[i]))<>0) then begin
                                          form1.listbox2.Items.add(interpret[i]+' - '+titel[i]);
                                          form1.ListBox1.Items.add(pfad[i]);
                                          ind:=form1.listbox2.items.count-1;
                                            form1.ListBox2.Items.move(ind,0);
                                            form1.ListBox1.Items.Move(ind,0);
//form1.listbox2.ItemIndex:=0;
                                          end;

end;



procedure TForm1.btn_birthdayClick(Sender: TObject);
var i,ind:integer;
begin
 for i:=0 to high(titel) do
 if (pos(uppercase(hbsong),uppercase(titel[i]))<>0) then begin
                                          form1.listbox2.Items.add(interpret[i]+' - '+titel[i]);
                                          form1.ListBox1.Items.add(pfad[i]);
                                          ind:=form1.listbox2.items.count-1;
                                            form1.ListBox2.Items.move(ind,0);
                                            form1.ListBox1.Items.Move(ind,0);

                                          end;

end;

procedure TForm1.FormShow(Sender: TObject);
begin
//readdb();
end;

procedure TForm1.btn_autosaveClick(Sender: TObject);
begin
if(autosave=false) then
  begin
     if dlg_autosave.Execute then
          begin
            AssignFile(autosavefile,dlg_autosave.FileName);
            ReWrite(autosavefile);
            autosave:=true;
            btn_autosave.Caption:='autosave';
            btn_autosave.Font.Color:=clGreen;
          end;

  end
  else begin
        autosave:=false;
        CloseFile(autosavefile);
        form1.btn_autosave.Font.Color:=clRed;
        form1.btn_autosave.Caption:='autosave';
      end;

end;


{procedure TForm1.btnClick(Sender: TObject);
var i,ind:integer;
begin
 for i:=0 to high(titel) do
 if (pos(uppercase(hbsong),uppercase(titel[i]))<>0) then begin
                                          form1.listbox2.Items.add(interpret[i]+' - '+titel[i]);
                                          form1.ListBox1.Items.add(pfad[i]);
                                          ind:=form1.listbox2.items.count-1;
                                            form1.ListBox2.Items.move(ind,0);
                                            form1.ListBox1.Items.Move(ind,0);

                                          end;

end;  }






end.
