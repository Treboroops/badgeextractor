unit dataunit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqlite3conn, sqldblib, sqldb, FileUtil, sqlite3dyn;

type

  { TData1 }

  TData1 = class(TDataModule)
    DBConnection: TSQLite3Connection;
    SQLQuery1: TSQLQuery;
    SQLQuery2: TSQLQuery;
    Counter: TSQLQuery;
    SQLTransaction1: TSQLTransaction;
    Zones: TSQLQuery;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private

  public
    procedure OpenDatabase;
    procedure CloseDatabase;
    function countbadges(const badgetype: string): integer;
  end;

var
  Data1: TData1;

implementation

{$R *.lfm}

{ TData1 }

procedure TData1.DataModuleCreate(Sender: TObject);
begin
  {$IFDEF LINUX}
  sqlite3dyn.sqlitedefaultlibrary := './libsqlite3.so';
  {$ENDIF}
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

procedure TData1.CloseDatabase;
begin
  SQLQuery1.Active := False;
  Zones.Active := False;
  DBConnection.Close;
end;

function TData1.countbadges(const badgetype: string): integer;
begin
  // get the number of unique badges for the given badge type
  Counter.active := false;
  Counter.SQL.Text:= 'select count(distinct DisplayName) as badgecount from badges where Type = ' +
    quotedstr(badgetype);
  Counter.Open;
  try
    Counter.first;
    result := Counter.FieldByName('badgecount').AsInteger;
  finally
    Counter.close;
  end;
end;

end.

