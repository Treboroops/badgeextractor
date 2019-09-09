unit orphans;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons,
  ExtCtrls, FileUtil;

type

  { TOrphanBadgeSelector }

  TOrphanBadgeSelector = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    ListBox1: TListBox;
    ListBox2: TListBox;
    Shape1: TShape;
    procedure ListBox2Click(Sender: TObject);
  private

  public
    procedure populateherolist(directory: string);
  end;

var
  OrphanBadgeSelector: TOrphanBadgeSelector;

implementation

{$R *.lfm}

{ TOrphanBadgeSelector }

procedure TOrphanBadgeSelector.ListBox2Click(Sender: TObject);
begin
  If ListBox2.ItemIndex > -1 then
  begin
    Caption := ListBox2.GetSelectedText;
    BitBtn1.Enabled := True;
  end;
end;

procedure TOrphanBadgeSelector.populateherolist(directory: string);
var
  herofiles: TStringList;
  I: integer;
begin
  herofiles := TStringList.Create;
  try
    FindAllFiles(herofiles, directory, '*.txt', true); //find all badgelists
    // trim file extensions and fill listbox
    For I := 0 to herofiles.Count -1 do
    begin
      ListBox2.Items.Add(ChangeFileExt(ExtractFileName(herofiles[I]), ''));
    end;

  finally
    herofiles.Free;

  end;
end;

end.

