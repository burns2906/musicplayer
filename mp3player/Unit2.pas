unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,main_u;

type
  Tloginform = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    Button1: TButton;
    ed_action: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure Edit1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    
  end;

var
  loginform: Tloginform;

implementation

{$R *.dfm}

procedure Tloginform.Button1Click(Sender: TObject);
var passw:string;
begin
  passw:=loginform.Edit1.Text;
  if (passw=adminpass) then
  begin
       loginform.Edit1.Text:='';
       loginform.Hide;
       //loginform.free;
       //form1.show;
       If loginform.ed_action.text='open adminmode' then begin
       form1.Button11.Caption:='Normaler Modus';
       
       form1.btn_dbupdate.Show;
       form1.btn_options.show;
       //form1.btn_rpopen.show;
       end;
       if loginform.ed_action.text='close programm' then begin
        loginform.ed_action.text:='close';
        form1.Close;
       end;
  end
  else showmessage('Falsches Passwort :D') ;


  
end;

procedure Tloginform.Edit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if(key=VK_RETURN) then loginform.Button1.Click;
end;

end.
