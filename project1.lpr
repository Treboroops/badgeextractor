program project1;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, Unit1, LibXmlParserU, dataunit, Unit2;

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

