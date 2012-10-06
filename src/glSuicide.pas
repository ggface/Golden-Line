unit glSuicide;

interface

uses
  SysUtils, Classes, Windows;

type
  tglSuicide = class(TComponent)
  public
    procedure DestroyNow;
  end;

procedure Register;

implementation

// {$R glSuicide}

procedure tglSuicide.DestroyNow;
var
  BatchFile: TextFile;
  BatchFileName: string;
  TM: Cardinal;
  TempMem: PChar;
begin
  BatchFileName := ExtractFilePath(ParamStr(0)) + '$$336699.bat';
  AssignFile(BatchFile, BatchFileName);
  Rewrite(BatchFile);
  Writeln(BatchFile, ':try');
  Writeln(BatchFile, 'del "' + ParamStr(0) + '"');
  Writeln(BatchFile, 'if exist "' + ParamStr(0) + '" goto try');
  Writeln(BatchFile, 'del "' + BatchFileName + '"');
  CloseFile(BatchFile);
  TM := 70;
  GetMem(TempMem, TM);
  GetShortPathName(PChar(BatchFileName), TempMem, TM);
  BatchFileName := TempMem;
  FreeMem(TempMem);
  winexec(PAnsiChar(BatchFileName), sw_hide);
  halt;
end;

procedure Register;
begin
  RegisterComponents('Golden Line', [tglSuicide]);
end;

end.
