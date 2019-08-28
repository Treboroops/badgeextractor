unit Unit2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  IniPropStorage;

type

  { ToptionsForm }

  ToptionsForm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    edChatlogDir: TEdit;
    edOutputDir: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    SelectDirectoryDialog1: TSelectDirectoryDialog;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private

  public

  end;

var
  optionsForm: ToptionsForm;

implementation

{$R *.lfm}

{ ToptionsForm }

procedure ToptionsForm.Button1Click(Sender: TObject);
begin
  if SelectDirectoryDialog1.Execute then
    edChatlogDir.Text := SelectDirectoryDialog1.FileName;
end;

procedure ToptionsForm.Button2Click(Sender: TObject);
begin
  if SelectDirectoryDialog1.Execute then
    edOutputDir.Text := SelectDirectoryDialog1.FileName;
end;

end.

