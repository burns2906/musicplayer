program musicplayer;

uses
  Forms,
  main_u in 'main_u.pas' {Form1},
  unit2_u in 'unit2_u.pas',
  id3v2_u in 'id3v2_u.pas',
  playerclass in 'playerclass.pas',
  audiofileclass in 'audiofileclass.pas',
  bass in 'bass.pas',
  Playlistclass in 'Playlistclass.pas',
  Unit2 in 'Unit2.pas' {loginform},
  optionsform_u in 'optionsform_u.pas' {Form3},
  loaddb_u in 'loaddb_u.pas' {Splashscreen};

{$R *.res}

begin
 SplashScreen := Tsplashscreen.Create(Application) ;
 try
 SplashScreen.Show;
 Application.Initialize;
 Splashscreen.Update;
 Application.CreateForm(TForm1, Form1);
  //Application.MainFormOnTaskbar := True;
  Application.CreateForm(Tloginform, loginform);
  Application.CreateForm(TForm3, Form3);
  //Application.CreateForm(TForm4, Form4);
  SplashScreen.Hide;
 finally
 splashscreen.Free;
 end; 
  Application.Run;
  
end.
