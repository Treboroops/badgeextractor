unit Unit2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqlite3conn, sqldb, sqldblib, db, FileUtil, Forms,
  Controls, Graphics, Dialogs, DbCtrls, StdCtrls, DBGrids;

type

  { TForm2 }

  TForm2 = class(TForm)
    Button1: TButton;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    DBNavigator1: TDBNavigator;
    SQDB1: TSQLite3Connection;
    SQLDBLibraryLoader1: TSQLDBLibraryLoader;
    SQLQuery1: TSQLQuery;
    SQLTransaction1: TSQLTransaction;
    procedure Button1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
  private

  public

  end;

var
  Form2: TForm2;

implementation

{$R *.lfm}

{ TForm2 }

procedure TForm2.Button1Click(Sender: TObject);
begin
  SQLQuery1.SQL.Text := 'select * from badges where Achieved = "True"';
  SQLQuery1.Active := True;
end;

procedure TForm2.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  SQLQuery1.Close;
  SQDB1.connected := False;
end;

end.

