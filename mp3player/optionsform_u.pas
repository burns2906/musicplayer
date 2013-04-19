unit optionsform_u;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,main_u;

type
  TForm3 = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Edit1: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Button10: TButton;
    Edit7: TEdit;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    Label7: TLabel;
    GroupBox2: TGroupBox;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    Label8: TLabel;
    GroupBox3: TGroupBox;
    Label9: TLabel;
    edit_hbsong: TEdit;
    procedure Button10Click(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;
  interpret,titel,pfad:array of string;
    
implementation



{$R *.dfm}

procedure TForm3.Button10Click(Sender: TObject);
var
   myFile : TextFile;
   mordner,p:string;

 begin
     mordner:=edit6.text;
     p:=copy(mordner,length(mordner),1);
     if(p<>'\') then mordner:=mordner+'\';
   // Try to open the Test.txt file for writing to
   AssignFile(myFile, 'config.con');
   ReWrite(myFile);
 
   // Write a couple of well known words to this file
   WriteLn(myFile,edit1.text);
   WriteLn(myFile, edit3.text);
   WriteLn(myFile, edit4.text);
   WriteLn(myFile, edit5.text);
   WriteLn(myFile, mordner);
   WriteLn(myFile, edit7.text);
   WriteLn(myFile, edit_hbsong.text);
   dbhost:=edit1.text;
   dbuser:=edit3.Text;
   dbpass:=edit4.Text;
   dbname:=edit5.text;
   musikordner:=mordner;
   adminpass:=edit7.Text;
   hbsong:=edit_hbsong.text;
   if(form3.RadioButton1.checked=true) then WriteLn(myFile,'alle');
   if(form3.RadioButton2.checked=true) then WriteLn(myFile,'pool');

      if(form3.RadioButton1.checked=true) then randomlieder:='alle';
   if(form3.RadioButton2.checked=true) then randomlieder:='pool';
   if(form3.RadioButton3.checked=true) then WriteLn(myFile,'ja');
   if(form3.RadioButton4.checked=true) then WriteLn(myFile,'nein');

      if(form3.RadioButton3.checked=true) then dbupdatetest:='ja';
   if(form3.RadioButton4.checked=true) then dbupdatetest:='nein';


   // Close the file
   CloseFile(myFile);
   ShowMessage('Einstellungen gespeichert');
   form3.GroupBox1.Visible:=false;
   form3.Hide;
end;

procedure TForm3.RadioButton1Click(Sender: TObject);
begin
form3.RadioButton2.Checked:=false;
end;

procedure TForm3.RadioButton2Click(Sender: TObject);
begin
form3.RadioButton1.Checked:=false;
end;

end.
