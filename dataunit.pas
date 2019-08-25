unit dataunit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqlite3conn, sqldblib, sqldb, FileUtil;

type

  { TData1 }

  TData1 = class(TDataModule)
    DBConnection: TSQLite3Connection;
    SQLDBLibraryLoader1: TSQLDBLibraryLoader;
    SQLQuery1: TSQLQuery;
    SQLTransaction1: TSQLTransaction;
    Zones: TSQLQuery;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private

  public
    procedure OpenDatabase;
  end;

var
  Data1: TData1;

implementation

{$R *.lfm}

{ TData1 }

procedure TData1.DataModuleCreate(Sender: TObject);
begin
  SQLiteLibraryName := './libsqlite3.so';

end;

procedure TData1.DataModuleDestroy(Sender: TObject);
begin
  Zones.Close;
  SQLQuery1.Close;
  DBConnection.Close;
end;

procedure TData1.OpenDatabase;
begin
  DBConnection.Open;
end;

end.

