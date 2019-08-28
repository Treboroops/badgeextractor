unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, IniPropStorage, StrUtils, dataunit, Unit2, LazFileUtils;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    ComboBox1: TComboBox;
    IniPropStorage1: TIniPropStorage;
    Memo1: TMemo;
    OpenDialog1: TOpenDialog;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    BadgeList: TStringList;
    badgefile: TStringList;
    chatlogdir: string;
    outputdir: string;
    procedure ReportBadges(const badgetype: string);
    procedure ReportExpBadges;
  public
    function RemoveSpecialChars(const str: string): string;
    function GetDisplayForBadge(const str: string): string;
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
const
  welcome: string = 'Welcome to City of Heroes, ';
  welcome2: string = 'Now entering the Rogue Isles, ';
  badgeearned: string = 'Congratulations! You earned the ';
  badgetitle: string = ' has been selected as new title.';
var
  tempstring: string;
  tempstr2: string;
  username, charactername: string;
  badge: string;
  I: integer;
  logfile: TStringList;
  outputstrings: TStringList;
begin
  Memo1.Clear;
  Data1.OpenDatabase;

  OpenDialog1.InitialDir := chatlogdir;
  if OpenDialog1.Execute then
  begin
    logfile := TStringList.Create;
    outputstrings := TStringList.Create;
    logfile.LoadFromFile(OpenDialog1.FileName);

    // look for badges
    username := 'default.txt';
    If fileexists(username) then BadgeList.LoadFromFile(username);

    For I := 0 to logfile.Count - 1 do
      begin
        tempstring := copy(logfile.Strings[I],21);

        //now we check each string looking for specific messages
        if AnsiStartsStr(welcome, tempstring) then
          begin
            BadgeList.SaveToFile(username);
            BadgeList.Clear;
            charactername := Trim(Copy(tempstring, length(welcome)));
            username := AppendPathDelim(outputdir) + RemoveSpecialChars(charactername) + '.txt';
            OutputStrings.Append('Starting badges for ' + charactername);
            If fileexists(username) then BadgeList.LoadFromFile(username);
          end
         else if AnsiStartsStr(welcome2, tempstring) then
          begin
            BadgeList.SaveToFile(username);
            BadgeList.Clear;
            charactername := Trim(Copy(tempstring, length(welcome2)));
            username := AppendPathDelim(outputdir) + RemoveSpecialChars(charactername) + '.txt';
            OutputStrings.Append('Starting badges for ' + charactername);
            If fileexists(username) then BadgeList.LoadFromFile(username);
          end;

        if AnsiStartsStr(badgeearned, tempstring) then
          begin
            tempstr2 := Copy(tempstring, length(badgeearned));
            badge := (Trim(copy(tempstr2, 1, length(tempstr2)-7)));
            BadgeList.Add(GetDisplayForBadge(badge));
            OutputStrings.Append(Badge);
          end
        else if AnsiEndsStr(badgetitle, tempstring) then
          begin
            badge := (Trim(Copy(tempstring, 1, length(tempstring) - length(badgeearned))));
            BadgeList.Add(GetDisplayForBadge(badge));
            OutputStrings.Append(Badge);
          end;
      end;

    Memo1.Lines.Assign(OutputStrings);
    BadgeList.SaveToFile(username);
    logfile.Free;
    OutputStrings.Clear;
    OutputStrings.Free;
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  badgename: string;
  I: integer;
begin
  OpenDialog1.InitialDir := outputdir;
  if OpenDialog1.Execute then
  begin
    Data1.OpenDatabase;
    Memo1.Clear;

    // read through the file
    Form1.Caption:= ExtractFileNameOnly(OpenDialog1.FileName);
    badgefile.LoadFromFile(OpenDialog1.FileName);
    badgefile.Sorted := True;

    // check for badges which do not exist
    For I := 0 to badgefile.Count - 1 do
    begin
      badgename := badgefile.Strings[I];

      //badgename is the displayname, check the DB
      With Data1 do
      begin
        SQLQuery1.SQL.Text := 'select Type from badges where DisplayName = ' +
          QuotedStr(badgename);
        SQLQuery1.Open;
        IF SQLQuery1.RecordCount = 0 then
          Memo1.Lines.Add('ERROR: Badge ' + badgename + ' is not in database');

        SQLQuery1.Close;
      end;

    end;

    Memo1.Lines.add('Badges Needed');
    Memo1.Lines.add('=============');
    Memo1.Lines.add('');
    ReportExpBadges;

    // do each type in turn... some better way to display this should be done
    Memo1.Lines.add('');
    ReportBadges('Accolades');
    ReportBadges('Achievement');
    ReportBadges('Architect');
    ReportBadges('Consignment');
    ReportBadges('Day Job');
    ReportBadges('Defeat');
    ReportBadges('Event');
    ReportBadges('Gladiator');
    ReportBadges('History');
    ReportBadges('Invention');
    ReportBadges('Ouroboros');
    ReportBadges('PVP');

  end;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  optionsForm.edChatlogDir.Text := chatlogdir;
  optionsForm.edOutputDir.Text := outputdir;
  if (optionsForm.ShowModal = mrOk) then
  begin
    chatlogdir := optionsForm.edChatlogDir.Text;
    if not DirectoryExists(chatlogdir) then chatlogdir := getcurrentdir;
    IniPropStorage1.StoredValues.Values['ChatLogDirectory'].Value := chatlogdir;

    outputdir := optionsForm.edOutputDir.Text;
    if not DirectoryExists(outputdir) then outputdir := getcurrentdir;
    IniPropStorage1.StoredValues.Values['OutputDirectory'].Value := outputdir;
  end;
end;

procedure TForm1.ComboBox1Change(Sender: TObject);
begin
  if Data1.DBConnection.Connected then
  begin
    Memo1.Clear;
    if ComboBox1.ItemIndex = 6 then
    begin
      ReportExpBadges;
    end
    else
      ReportBadges(ComboBox1.Items[ComboBox1.ItemIndex]);
  end;
end;

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  IniPropStorage1.Save;
  BadgeList.Free;
  badgefile.free;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  BadgeList := TStringList.create;
  BadgeList.Sorted := True;
  BadgeList.Duplicates := dupIgnore;
  badgefile := TStringList.Create;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  IniPropStorage1.Restore;
  chatlogdir := IniPropStorage1.StoredValues.Values['ChatLogDirectory'].Value;
  outputdir := IniPropStorage1.StoredValues.Values['OutputDirectory'].Value;
end;

procedure TForm1.ReportBadges(const badgetype: string);
var
  badgeindex: Integer;
  tmpstringlist: TStringList;
begin
  tmpstringlist := TStringList.Create;

  tmpstringlist.add('-----------');
  tmpstringlist.add(badgetype);
  tmpstringlist.add('-----------');

  With Data1 do
  begin
    SQLQuery1.SQL.text := 'select distinct DisplayName,Description,Notes from '
        + 'badges where Type = ' + QuotedStr(badgetype);
    SQLQuery1.Open;
    SQLQuery1.First;
    while not SQLQuery1.EOF do
    begin
      if badgefile.Find(SQLQuery1.FieldByName('DisplayName').asString, badgeindex) then
      begin
        // character has this badge
        //Memo1.Lines.add(' *' + SQLQuery1.FieldByName('DisplayName').asString);
      end
      else
      begin
        // this badge has not been gained yet
        tmpstringlist.add('  ' + SQLQuery1.FieldByName('DisplayName').asString);
        tmpstringlist.add('     (' + SQLQuery1.FieldByName('Description').asString + ')');
      end;
      SQLQuery1.Next;
    end;

    SQLQuery1.Close;
  end;

  tmpstringlist.Add('');
  Memo1.Lines.AddStrings(tmpstringlist);
  tmpstringlist.free;
end;

procedure TForm1.ReportExpBadges;
var
  templist: TStringList;
  badgeindex: integer;
begin
  templist := TStringList.Create;
  try
    // Do exploration badges first
    Memo1.Lines.add('------------------');
    Memo1.Lines.add('Exploration Badges');
    Memo1.Lines.add('------------------');
    with Data1 do
    begin
      Zones.Active := True; // here is our list of badge zones
      Zones.First;
      While not Zones.EOF do
      begin
        SQLQuery1.Active := False;
        SQLQuery1.SQL.text := 'select distinct DisplayName,Description,Notes,X,Y,Z from '
          + 'badges where Type = ''Exploration'' and Description =' +
          QuotedStr(Zones.FieldByName('Description').asString);
        SQLQuery1.Open;
        // now we have a list of exploration badges for this zone
        // see if each badge is in our list
        templist.Clear;
        SQLQuery1.First;
        While not SQLQuery1.EOF do
        begin
          if badgefile.Find(SQLQuery1.FieldByName('DisplayName').asString, badgeindex) then
          begin
            // character has this badge
            //Memo1.Lines.add(' *' + SQLQuery1.FieldByName('DisplayName').asString);
          end
          else
          begin
            // this badge has not been gained yet
            templist.add('  ' + SQLQuery1.FieldByName('DisplayName').asString + #9#9 +
              SQLQuery1.FieldByName('Notes').asString);
          end;

          SQLQuery1.Next;
        end;
        // if we have badges then list them
        if templist.Count > 0 then
        begin
          Memo1.Lines.add('');
          Memo1.Lines.add(' ' + Zones.FieldByName('Description').asString);

          Memo1.Lines.AddStrings(templist);
          templist.Clear;
        end;
        SQLQuery1.Close;

        Zones.Next;
      end;
    end;
  finally
    templist.clear;
    templist.Free;
  end;
end;

function TForm1.RemoveSpecialChars(const str: string): string;
const
  InvalidChars : set of char =
    [',','.','/','!','@','#','$','%','^','&','*','''','"',';','_','(',')',':','|','[',']'];
var
  i, Count: Integer;
begin
  SetLength(Result, Length(str));
  Count := 0;
  for i := 1 to Length(str) do
    if not (str[i] in InvalidChars) then
    begin
      inc(Count);
      Result[Count] := str[i];
    end;
  SetLength(Result, Count);
end;

function TForm1.GetDisplayForBadge(const str: string): string;
begin
  // look through the DB for the badge return the DisplayName
  // As lots of badges can have different names for the same badge depending on
  // alignment/gender.
  With Data1 do
  begin
    SQLQuery1.Active := False;
    SQLQuery1.SQL.Text := 'select DisplayName from badges where Badge = '
      + QuotedStr(str);
    SQLQuery1.Open;

    GetDisplayForBadge := str; // if we find nothing just return the badge
    SQLQuery1.First;
    If not SQLQuery1.EOF then
      GetDisplayForBadge := SQLQuery1.FieldByName('DisplayName').asString
      else
        Memo1.Lines.add('ERROR ' + str + ' badge not found.');
  end;

end;

end.

