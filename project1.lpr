program project1;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, Unit1, dataunit, Unit2, orphans;

{$R *.res}

begin
  Application.Title:='badgeextractor';
  RequireDerivedFormResource:=True;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TData1, Data1);
  Application.CreateForm(ToptionsForm, optionsForm);
  Application.Run;
end.

