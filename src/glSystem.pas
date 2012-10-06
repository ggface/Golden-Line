unit glSystem;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes;

function RunAs(Username, Password, CmdString: string): string;

function CountPos(const subtext: string; Text: string): Integer;

function createprocesswithlogonw(lpusername: pwidechar; lpdomain: pwidechar;
  lppassword: pwidechar; dwlogonflags: dword; lpapplicationname: pwidechar;
  lpcommandline: pwidechar; dwcreationflags: dword; lpenvironment: pointer;
  lpcurrentdirectory: pchar; const lpstartupinfo: tstartupinfo;
  var lpprocessinformation: tprocessinformation): bool; stdcall;

function ExePath: string;
function GetUserFromWindows: string;

implementation

function createprocesswithlogonw;
  external advapi32 name 'CreateProcessWithLogonW';

function ExePath: string;
begin
  result := Copy(paramstr(0), 1, LastDelimiter('\:', paramstr(0)));
end;

function GetUserFromWindows: string;
var
  Username: string;
  UserNameLen: dword;
begin
  UserNameLen := 255;
  SetLength(Username, UserNameLen);
  if GetUserName(pchar(Username), UserNameLen) then
    result := Copy(Username, 1, UserNameLen - 1)
  else
    result := 'Unknown';
end;

function CountPos(const subtext: string; Text: string): Integer;
begin
  if (Length(subtext) = 0) or (Length(Text) = 0) or (Pos(subtext, Text) = 0)
  then
    result := 0
  else
    result := (Length(Text) - Length(StringReplace(Text, subtext, '',
      [rfReplaceAll]))) div Length(subtext);
end;

function RunAs(Username, Password, CmdString: string): string;
var
  si: tstartupinfo;
  pi: tprocessinformation;
  puser, ppass, pdomain, pprogram: array [0 .. 255] of wchar;
  lasterror: dword;
  resultstring: string;
begin
  zeromemory(@si, sizeof(si));
  si.cb := sizeof(si);
  zeromemory(@pi, sizeof(pi));

  stringtowidechar(Username, puser, 255);
  stringtowidechar(Password, ppass, 255);
  stringtowidechar('', pdomain, 255);
  stringtowidechar(CmdString, pprogram, 255);
  createprocesswithlogonw(puser, pdomain, ppass, 1, // logon_with_profile,
    pprogram, nil, create_default_error_mode or create_new_console or
    create_new_process_group or create_separate_wow_vdm, nil, nil, si, pi);
  lasterror := getlasterror;
  case lasterror of
    0:
      resultstring := 'success!';
    86:
      resultstring := 'wrong password';
    1326:
      resultstring := 'wrong username or password';
    1327:
      resultstring := 'logon failure user account restriction';
    1385:
      resultstring :=
        'logon failure the user has not been granted the requested logon type at this computer.';
    2:
      resultstring := 'file not found';
    5:
      resultstring := 'acced denied';
  else
    resultstring := 'error ' + inttostr(lasterror);
  end;
  result := resultstring;

end;

end.
